Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaJWDXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:23:22 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:51076 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932381AbaJWDXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:23:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3873:4250:4321:4470:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net86_571647a50cf32
X-Filterd-Recvd-Size: 2488
Message-ID: <1414034597.15751.3.camel@perches.com>
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
From: Joe Perches <joe@perches.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Brian Vandre <bvandre@gmail.com>, gregkh@linuxfoundation.org,
        jic23@kernel.org, alexandre.belloni@free-electrons.com,
        linux-iio@vger.kernel.org, marex@denx.de, linux-kernel@vger.kernel.org
Date: Wed, 22 Oct 2014 20:23:17 -0700
In-Reply-To: <54484219.5000708@gmx.de>
References: <cover.1413858979.git.bvandre@gmail.com>
	 <cover.1413931615.git.bvandre@gmail.com>
	 <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
	 <20141022042115.GA2530@sudip-PC> <54484219.5000708@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 01:47 +0200, Hartmut Knaack wrote:
> Sudip Mukherjee schrieb am 22.10.2014 06:21:
> > On Tue, Oct 21, 2014 at 05:56:47PM -0500, Brian Vandre wrote:
> >> This fixes the 2 checkpatch.pl warnings:
> >> WARNING: line over 80 characters
> >>
> > please check your patch with --strict option of checkpatch.pl , and you will get :
> > "Alignment should match open parenthesis" .
> > 
> Good point, but what solution would you propose?

> >> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c

> >> @@ -455,7 +455,8 @@ static void mxs_lradc_setup_ts_channel(struct mxs_lradc *lradc, unsigned ch)
> >>  	 * SoC's delay unit and start the conversion later
> >>  	 * and automatically.
> >>  	 */
> >> -	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
> >> +	mxs_lradc_reg_wrt(lradc,
> >> +		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
> >>  		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
> >>  		LRADC_DELAY_KICK |
> >>  		LRADC_DELAY_DELAY(lradc->settling_delay),

Maybe something like:

	mxs_lradc_reg_wrt(lradc,
			  LRADC_DELAY_TRIGGER(0) |
						/* don't trigger ADC */
			  LRADC_DELAY_TRIGGER_DELAYS(1 << 3) |
						/* trigger DELAY unit#3 */
			  LRADC_DELAY_KICK |
			  LRADC_DELAY_DELAY(lradc->settling_delay),


