#!usr/bin/perl

use warnings;
use strict;

my $word_list_filename = $ARGV[0];
my $target_word = $ARGV[1];
my @chars = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");


my %social_network;
my @queue;
my @word_list = &open_file($word_list_filename);
my %word_hash;

&preprocess();

&build_social_network();

#open file function
sub open_file()
{
	my ($filename) = @_;

	open(FILENAME, $filename) || die "Cannot Open Inputfile >$filename<";
	my @lines = <FILENAME>;
	close(FILENAME);

	return @lines;
}

sub preprocess()
{
	for (my $i = 0; $i < scalar(@word_list); $i++)
	{
		chomp($word_list[$i]);
		$word_hash{$word_list[$i]} = 0;
	}
}

sub build_social_network()
{
	$social_network{$target_word} = 0;
	push(@queue, $target_word);
	my $count = 0;

	while (scalar(@queue) > 0)
	{
		my $word = $queue[0];
		shift(@queue);
		print $word . "\n";
		$count++;
		my @new_words = &add($word);
		@queue = (@queue, @new_words);
	}

	print $count . "\n";
}

sub add()
{
	my @words;
	my ($word) = @_;
	my $temp;

	for (my $i = 0; $i < length($word); $i++)
	{
		$temp = $word;
		substr($temp, $i, 1, "");
		if (defined($word_hash{$temp}) && not defined($social_network{$temp}))
		{
			push(@words, $temp);
			$social_network{$temp} = 0;
		}

		for (my $j = 0; $j < 26; $j++)
		{
			$temp = substr($word, 0, $i) . $chars[$j] . substr($word, $i);
			if (defined($word_hash{$temp}) && not defined($social_network{$temp}))
			{
				push(@words, $temp);
				$social_network{$temp} = 0;

			}

			$temp = $word;
			substr($temp, $i, 1, $chars[$j]);
			if (defined($word_hash{$temp}) && not defined($social_network{$temp}))
			{
				push(@words, $temp);
				$social_network{$temp} = 0;

			}
		}
	}

	for (my $j = 0; $j < 26; $j++)
	{
		$temp = $word . $chars[$j];
		if (defined($word_hash{$temp}) && not defined($social_network{$temp}))
		{
			push(@words, $temp);
			$social_network{$temp} = 0;

		}
	}


	return @words;
}
