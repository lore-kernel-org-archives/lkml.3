Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaA0XMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:12:42 -0500
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:57258 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753849AbaA0XMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:12:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:2894:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:4250:4321:5007:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jump02_33cc1c870a200
X-Filterd-Recvd-Size: 2103
Message-ID: <1390864354.20150.57.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: BUG on %n
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>, Ryan Mallon <rmallon@gmail.com>
Date: Mon, 27 Jan 2014 15:12:34 -0800
In-Reply-To: <20140127230326.GA877@www.outflux.net>
References: <20140127230326.GA877@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 15:03 -0800, Kees Cook wrote:
> Now that there has been a full release of the kernel, and all users
> of %n have been dropped, switch to %n use triggering a BUG. Ignoring
> arguments could be used to assist in information leaks if an arbitrary
> format string was under the control of an attacker.
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1735,15 +1735,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  		case FORMAT_TYPE_NRCHARS: {
>  			/*
>  			 * Since %n poses a greater security risk than
> -			 * utility, ignore %n and skip its argument.
> +			 * utility, it should not be implemented. Instead,
> +			 * BUG when encountering %n, since there are no
> +			 * legitimate users and skipping arguments could
> +			 * assist information leak attacks.
>  			 */
> -			void *skip_arg;
> -
> -			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
> -					old_fmt);
> -
> -			skip_arg = va_arg(args, void *);
> -			break;
> +			BUG();

BUGs should be avoided where possible.

I think using BUG here isn't necessary or good.


