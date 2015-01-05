Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbbAERQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:16:49 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:34610 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752865AbbAERQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:16:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3867:3868:3872:3873:4321:5007:6119:6120:6261:7576:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roof51_1dc46aa079710
X-Filterd-Recvd-Size: 1910
Message-ID: <1420478203.2652.17.camel@perches.com>
Subject: Re: [RFC PATCH 2/4] x86, alternatives: Cleanup DPRINTK macro
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 09:16:43 -0800
In-Reply-To: <1420470013-26413-3-git-send-email-bp@alien8.de>
References: <1420470013-26413-1-git-send-email-bp@alien8.de>
	 <1420470013-26413-3-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 16:00 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Make it pass __func__ implicitly. Also, dump info about each replacing
> we're doing. Fixup comments and style while at it.

It may be better to use dynamic debug functionality
directly with pr_debug instead of this __setup with
"debug-alternative".

It's becoming quite a bit more common to use the
#define macro(fmt, ...) style where you converted
back to the older #define macro(fmt, args...) style.

> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
[]
> @@ -52,10 +52,10 @@ static int __init setup_noreplace_paravirt(char *str)
>  __setup("noreplace-paravirt", setup_noreplace_paravirt);
>  #endif
>  
> -#define DPRINTK(fmt, ...)				\
> -do {							\
> -	if (debug_alternative)				\
> -		printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
> +#define DPRINTK(fmt, args...)						\
> +do {									\
> +	if (debug_alternative)						\
> +		printk(KERN_DEBUG "%s: " fmt "\n", __func__, ##args);	\
>  } while (0)



