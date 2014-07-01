Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaGAQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:30:44 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:34350 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756491AbaGAQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:30:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:4250:4321:4385:5007:6119:7576:7652:10004:10400:10450:10455:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13019:13069:13255:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chin72_22ffa8cf61947
X-Filterd-Recvd-Size: 1975
Message-ID: <1404232237.14624.2.camel@joe-AO725>
Subject: Re: [PATCH 15/20] drbd: cosmetic: change all printk(level, ...) to
 pr_<level>(...)
From: Joe Perches <joe@perches.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Date: Tue, 01 Jul 2014 09:30:37 -0700
In-Reply-To: <1404231410-29852-16-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
	 <1404231410-29852-16-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 18:16 +0200, Philipp Reisner wrote:
> From: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> Cosmetic change only.
[]
> diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
[]
> @@ -353,9 +353,8 @@ static void bm_free_pages(struct page **pages, unsigned long number)
>  
>  	for (i = 0; i < number; i++) {
>  		if (!pages[i]) {
> -			printk(KERN_ALERT "drbd: bm_free_pages tried to free "
> -					  "a NULL pointer; i=%lu n=%lu\n",
> -					  i, number);
> +			pr_alert("bm_free_pages tried to free a NULL pointer; i=%lu n=%lu\n",
> +				 i, number);

Cosmetic yes, but these won't be prefixed with "drbd: "
unless there's a #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
somewhere above this and before any other #include.

> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
[]
> @@ -26,6 +26,8 @@
>  
>   */
>  
> +#define pr_fmt(fmt)	"drbd: " fmt

like this one, though I think KBUILD_MODNAME would be better.



