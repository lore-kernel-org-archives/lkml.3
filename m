Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaIVCbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:31:35 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:39800 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751820AbaIVCbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:31:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3868:3871:4321:5007:7514:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13019:13069:13161:13229:13311:13357:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball50_d798d142ed5b
X-Filterd-Recvd-Size: 2464
Message-ID: <1411353090.2952.19.camel@joe-AO725>
Subject: Re: [PATCH] scripts: checkpatch.pl: Fix existing typedef false
 positive warning
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Sun, 21 Sep 2014 19:31:30 -0700
In-Reply-To: <1411349544-7479-1-git-send-email-gdonald@gmail.com>
References: <1411349544-7479-1-git-send-email-gdonald@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-21 at 20:32 -0500, Greg Donald wrote:
> Fixing an "open brace '{' following struct go on the same line" error causes a
> false positive warning "do not add new typedefs". Fix existing typedef false
> positive warning.

This doesn't work.
The matching deleted line can be any number of lines above.

> Signed-off-by: Greg Donald <gdonald@gmail.com>
> ---
>  scripts/checkpatch.pl | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4d08b39..eafe5e7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3081,14 +3081,24 @@ sub process {
>  		}
>  
>  # check for new typedefs, only function parameters and sparse annotations
> -# make sense.
> +# and existing typedefs make sense.
>  		if ($line =~ /\btypedef\s/ &&
>  		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
>  		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
>  		    $line !~ /\b$typeTypedefs\b/ &&
>  		    $line !~ /\b__bitwise(?:__|)\b/) {
> -			WARN("NEW_TYPEDEFS",
> -			     "do not add new typedefs\n" . $herecurr);
> +			# check if $line is diff-like
> +			if (substr($rawlines[$linenr - 3], 0, 1) eq '-') {
> +				my $oldline3 = substr($rawlines[$linenr - 3], 1);
> +				# check if typedef already existed
> +				if ($line !~ /$oldline3/) {
> +					WARN("NEW_TYPEDEFS",
> +					     "do not add new typedefs\n" . $herecurr);
> +				}
> +			} else {
> +				WARN("NEW_TYPEDEFS",
> +				     "do not add new typedefs\n" . $herecurr);
> +			}
>  		}
>  
>  # * goes on variable not on type



