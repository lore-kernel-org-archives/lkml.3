Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaGNINy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:13:54 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:59036 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaGNINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:13:49 -0400
Date: Mon, 14 Jul 2014 09:13:52 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Add for_each tests to indentation and brace
 tests
Message-ID: <20140714081352.GE3743@bark>
References: <20140712230828.GA15827@kroah.com>
 <1405229634.9132.38.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405229634.9132.38.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 10:33:54PM -0700, Joe Perches wrote:
> All the various for_each loop macros were not tested for
> trailing brace on the following lines and for bad indentation.
> 
> Add them.
> 
> Reported-by: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> On Sat, 2014-07-12 at 16:08 -0700, Greg KH wrote:
> > The following function:
> > 
> > $ cat foo.c 
> > 
> > static int foo_init(void)
> > {
> > 
> > 	list_for_each_entry(foo, &foo, list)
> > 	{
> > 		do_something_foo(foo);
> > 	}
> > 
> > 	return 0;
> > }
> > 
> > Will not be caught by checkpatch:
> > 
> > $ ./scripts/checkpatch.pl --file foo.c 
> > total: 0 errors, 0 warnings, 11 lines checked
> > 
> > foo.c has no obvious style problems and is ready for submission.
> 
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d5ac001..5efbf50 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2698,7 +2698,7 @@ sub process {
>  
>  # if/while/etc brace do not go on next line, unless defining a do while loop,
>  # or if that brace on the next line is for something else
> -		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
> +		if ($line =~ /(.*)\b((?:if|while|for|switch|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {

They way you end this first addition with |) converts it the (?:[a-z_]*)
doesn't it?  Were you intending to do (?:[a-z_]+_|) ?

>  			my $pre_ctx = "$1$2";
>  
>  			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
> @@ -2744,7 +2744,7 @@ sub process {
>  		}
>  
>  # Check relative indent for conditionals and blocks.
> -		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
> +		if ($line =~ /\b(?:(?:if|while|for|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
>  			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
>  				ctx_statement_block($linenr, $realcnt, 0)
>  					if (!defined $stat);

With the above clarified it all seems sensible.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
