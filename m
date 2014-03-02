Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaCBFgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 00:36:35 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:32828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750760AbaCBFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 00:36:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2526:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:4321:4419:5007:6119:7652:7903:8957:9038:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cord63_5622763413015
X-Filterd-Recvd-Size: 2014
Message-ID: <1393738591.31402.23.camel@joe-AO722>
Subject: Re: [PATCH 7/9] drivers: staging: rtl8187se: fixed checkpatch.pl
 errors
From: Joe Perches <joe@perches.com>
To: Axel Rasmussen <axel.rasmussen1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Sat, 01 Mar 2014 21:36:31 -0800
In-Reply-To: <1393737773-13937-8-git-send-email-axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
	 <1393737773-13937-8-git-send-email-axel.rasmussen1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-01 at 22:22 -0700, Axel Rasmussen wrote:
> The definition of the driver's ChannelPlan array produced a large number
> of checkpatch.pl errors. This patch fixes all of them by adding spaces
> and wrapping the resulting overly-long lines.

I think the current code is better.

> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
[]
> @@ -2242,17 +2242,44 @@ static void watch_dog_adaptive(unsigned long data)
[for instance]
>  static struct rtl8187se_channel_list channel_plan_list[] = {
> -	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
[]
> +	/* FCC */
> +	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40,
> +		44, 48, 52, 56, 60, 64}, 19},

If you really do this, it may be better to
remove the len variable and test for != 0
instead of channel_plan_list[].len

So instead of:

drivers/staging/rtl8187se/r8180_core.c:
			for (i = 0; i < channel_plan_list[channel_plan].len; i++) {
Maybe:
			for (i = 0; channel_plan_list[channel_plan].channel[i]; i++) {


