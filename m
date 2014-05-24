Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaEXTKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 15:10:54 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:51353 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751282AbaEXTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 15:10:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:4321:5007:7652:7875:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13149:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cap16_5e9a7673a2963
X-Filterd-Recvd-Size: 1882
Message-ID: <1400958648.22191.3.camel@joe-AO725>
Subject: Re: [PATCH] msi3103: Use time_before_eq()
From: Joe Perches <joe@perches.com>
To: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: crope@iki.fi, m.chehab@samsung.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 24 May 2014 12:10:48 -0700
In-Reply-To: <1400957276-13222-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400957276-13222-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 20:47 +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_before_eq() instead of plain, error-prone math.

A couple of unrelated, trivial notes: (repeated a few times)

> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
[]
> @@ -208,7 +208,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
>  	}
>  
>  	/* calculate samping rate and output it in 10 seconds intervals */

s/samping/sampling/

> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
>  		unsigned long jiffies_now = jiffies;
>  		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

Perhaps better to subtract then convert
instead of convert twice then subtract.


