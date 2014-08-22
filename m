Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaHVQwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:52:17 -0400
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:35424 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbaHVQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:52:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:7903:8660:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit11_309476a794b33
X-Filterd-Recvd-Size: 1862
Message-ID: <1408726332.13483.25.camel@joe-AO725>
Subject: Re: [PATCH] errno.h: Improve ENOSYS's comment
From: Joe Perches <joe@perches.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 09:52:12 -0700
In-Reply-To: <5c34ad9efb9b1ef1ffed1077d064ad877819dffc.1408724938.git.luto@amacapital.net>
References: <5c34ad9efb9b1ef1ffed1077d064ad877819dffc.1408724938.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 09:30 -0700, Andy Lutomirski wrote:
> ENOSYS is the mechanism used by user code to detect whether the
> running kernel implements a given system call.  It should not be
> returned by anything except an unimplemented system call.
> 
> Unfortunately, it is rather frequently used in the kernel to
> indicate that various new functions of existing system calls are not
> implemented.  This should be discouraged.
> 
> Improve the command in errno.h to help clarify ENOSYS's purpose.
[]
> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
[]
> @@ -6,7 +6,7 @@
[]
> -#define	ENOSYS		38	/* Function not implemented */
> +#define	ENOSYS		38	/* Bad system call number */

I suggest "Invalid" rather than "Bad".

Maybe also add something like:
	/* see: man 2 syscalls */
or
	/* grep for SYSCALL_DEFINE */


