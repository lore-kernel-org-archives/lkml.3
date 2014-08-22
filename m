Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaHVSOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:14:34 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:58568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410AbaHVSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:14:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2693:2828:2911:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4425:5007:7652:7875:8660:10004:10400:10450:10455:10848:11232:11658:11914:12043:12517:12519:12555:12663:12740:13019:13069:13148:13230:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: road83_2774552100051
X-Filterd-Recvd-Size: 2780
Message-ID: <1408731270.17241.12.camel@joe-AO725>
Subject: Re: [PATCH v3] checkpatch.pl: New instances of ENOSYS are errors
From: Joe Perches <joe@perches.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 11:14:30 -0700
In-Reply-To: <5eb299021dec23c1a48fa7d9f2c8b794e967766d.1408730669.git.luto@amacapital.net>
References: <5eb299021dec23c1a48fa7d9f2c8b794e967766d.1408730669.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 11:05 -0700, Andy Lutomirski wrote:
> ENOSYS means that a nonexistent system call was called.  We have a
> bad habit of using it for things like invalid operations on
> otherwise valid syscalls.  We should avoid this in new code.

Seems sensible thanks for persisting.

Andrew Morton is generally the upstream path (cc'd)

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Pervasive incorrect usage of ENOSYS came up at the kernel summit ABI
> review discussion.  Let's see if checkpatch can help.
> 
> I'll submit a separate patch for include/uapi/asm-generic/errno.h.
> 
> Changes from v2:
>  - Reduce severity to WARN.
>  - Remove unnecessary clarification.
>  - Rebase onto Linus' tree instead of v3.16.
> 
> Changes from v1:
>  - Moved later so that it won't warn on context lines.
>  - Use $herecur.
>  - Improve regex pattern.
> 
>  scripts/checkpatch.pl | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 31a731e..448d075 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3214,6 +3214,14 @@ sub process {
>  			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
>  		}
>  
> +# ENOSYS means "bad syscall nr" and nothing else.  This will have a small
> +# number of false positives, but assembly files are not checked, so at
> +# least the arch entry code will not trigger this warning.
> +		if ($line =~ /\bENOSYS\b/) {
> +			WARN("ENOSYS",
> +			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
> +		}
> +
>  # function brace can't be on same line, except for #defines of do while,
>  # or if closed on same line
>  		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and



