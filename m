Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaHVR1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:27:10 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:55325 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932329AbaHVR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:27:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:7652:8660:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13071:13095:13148:13161:13229:13230:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pet46_3dc6bd3a58e22
X-Filterd-Recvd-Size: 2515
Message-ID: <1408728421.13483.43.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch.pl: New instances of ENOSYS are errors
From: Joe Perches <joe@perches.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 10:27:01 -0700
In-Reply-To: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
References: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 09:26 -0700, Andy Lutomirski wrote:
> ENOSYS means that a nonexistent system call was called.  We have a
> bad habit of using it for things like invalid operations on
> otherwise valid syscalls.  We should avoid this in new code.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2931,6 +2931,14 @@ sub process {
>  			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
>  		}
>  
> +# ENOSYS means "bad syscall nr" and nothing else
> +# (note that this doesn't run on assembly files, so entry*.S is okay)
> +		if ($line =~ /\bENOSYS\b/) {
> +			ERROR("ENOSYS",
> +			      "ENOSYS means 'invalid syscall nr' and nothing else\n" .
> +			      "       (ignore if this really is syscall entry code)\n" . $herecurr);
> +		}
> +
>  # function brace can't be on same line, except for #defines of do while,
>  # or if closed on same line
>  		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and

Hi again Andy.

I think this is OK, but you seem to be making
this patch against an old version of checkpatch.

It applies with an offset of a few hundred lines
to Linus' tree and to -next.

Some trivial comments:

I think the "(note that" comment line isn't very useful.
All the tests after:
		next if ($realfile !~ /\.(h|c)$/);
have that attribute.

checkpatch doesn't use multi-line message descriptions.
The "(ignore if this" line should not be on a separate line
but simply use a longer single output line.

ERROR types should not have false positives.
I'd prefer WARN.

cheers, Joe

