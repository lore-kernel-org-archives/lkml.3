Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3LZUIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:08:48 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53903 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3LZUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:08:47 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 26 Dec 2013 12:08:40 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] checkpatch: Add a --fix-inplace option
Message-ID: <20131226200840.GB7267@leaf>
References: <cover.1388085015.git.joe@perches.com>
 <f15570aa85918df5942aac86ad80df19e1d743c5.1388085015.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f15570aa85918df5942aac86ad80df19e1d743c5.1388085015.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:20:29AM -0800, Joe Perches wrote:
> Add the ability to fix and overwrite existing files/patches instead
> of creating a new file "<filename>.EXPERIMENTAL-checkpatch-fixes".
> 
> Suggested-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  scripts/checkpatch.pl | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f5d4560..19376b4 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -29,6 +29,7 @@ my $mailback = 0;
>  my $summary_file = 0;
>  my $show_types = 0;
>  my $fix = 0;
> +my $fix_inplace = 0;
>  my $root;
>  my %debug;
>  my %camelcase = ();
> @@ -76,6 +77,9 @@ Options:
>                               "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
>                               with potential errors corrected to the preferred
>                               checkpatch style
> +  --fix-inplace              EXPERIMENTAL - may create horrible results
> +                             Is the same as --fix, but overwrites the input
> +                             file.  It's your fault if there's no backup or git
>    --ignore-perl-version      override checking of perl version.  expect
>                               runtime errors.
>    -h, --help, --version      display this help and exit
> @@ -131,6 +135,7 @@ GetOptions(
>  	'mailback!'	=> \$mailback,
>  	'summary-file!'	=> \$summary_file,
>  	'fix!'		=> \$fix,
> +	'fix-inplace!'	=> \$fix_inplace,
>  	'ignore-perl-version!' => \$ignore_perl_version,
>  	'debug=s'	=> \%debug,
>  	'test-only=s'	=> \$tst_only,
> @@ -140,6 +145,8 @@ GetOptions(
>  
>  help(0) if ($help);
>  
> +$fix = 1 if ($fix_inplace);
> +
>  my $exit = 0;
>  
>  if ($^V && $^V lt $minimum_perl_version) {
> @@ -4456,7 +4463,8 @@ sub process {
>  	hash_show_words(\%ignore_type, "Ignored");
>  
>  	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
> -		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
> +		my $newfile = $filename;
> +		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
>  		my $linecount = 0;
>  		my $f;
>  
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
