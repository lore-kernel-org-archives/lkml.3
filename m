Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3CYDjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:39:25 -0400
Received: from ozlabs.org ([203.10.76.45]:57350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab3CYDjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:39:23 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, apw@canonical.com
Subject: Re: [PATCH 06/29] checkpatch: Don't warn about if ((status = _xbegin()) == _XBEGIN_STARTED)
In-reply-to: <1364001923-10796-7-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <1364001923-10796-7-git-send-email-andi@firstfloor.org>
Comments: In-reply-to Andi Kleen <andi@firstfloor.org>
   message dated "Fri, 22 Mar 2013 18:25:00 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 14:39:21 +1100
Message-ID: <30434.1364182761@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> Writing _xbegin which is like setjmp in a if is very natural.
> Stop checkpatch's whining about this.

This patch should go in before the RTM tester.  

> 
> Cc: apw@canonical.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/checkpatch.pl |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b28cc38..659e683 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2831,7 +2831,10 @@ sub process {
>  		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
>  			my ($s, $c) = ($stat, $cond);
>  
> -			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
> +			# if ((status = _xbegin()) == _XBEGIN_STARTED) is natural,
> +			# so don't warn about this case.
> +			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s &&
> +			    $c !~ /_xbegin/) {
>  				ERROR("ASSIGN_IN_IF",
>  				      "do not use assignment in if condition\n" . $herecurr);
>  			}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
