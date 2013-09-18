Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3IRUWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:22:48 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:45565 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751686Ab3IRUWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:22:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:560:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:4321:4605:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12679:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crook91_6f51e99f7b318
X-Filterd-Recvd-Size: 2073
Message-ID: <1379535763.1787.63.camel@joe-AO722>
Subject: Re: [PATCH 1/2] hwrng: OMAP3 ROM Random Number Generator support
From: Joe Perches <joe@perches.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Juha Yrjola <juha.yrjola@solidboot.com>
Date: Wed, 18 Sep 2013 13:22:43 -0700
In-Reply-To: <1379534757-20870-2-git-send-email-pali.rohar@gmail.com>
References: <201303281854.02847@pali>
	 <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
	 <1379534757-20870-2-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 22:05 +0200, Pali Rohár wrote:
> This driver provides kernel-side support for the Random Number
> Generator hardware found on OMAP34xx processors.

[]

> diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c

trivial note:

It produces smaller overall code to add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include and use

> +static void omap3_rom_rng_idle(unsigned long data)
> +{
> +	int r;
> +
> +	r = omap3_rom_rng_call(0, 0, RNG_RESET);
> +	if (r != 0) {
> +		printk(KERN_ERR "%s: reset failed: %d\n",
> +		       omap3_rom_rng_name, r);

		pr_err("reset failed: %d\n", r);

> +static int omap3_rom_rng_get_random(void *buf, unsigned int count)
> +{
[]
> +		if (r != 0) {
> +			clk_disable_unprepare(rng_clk);
> +			printk(KERN_ERR "%s: HW init failed: %d\n",
> +			       omap3_rom_rng_name, r);

			pr_err("HW init failed: %d\n", r);

etc...


