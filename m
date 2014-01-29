Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaA2PQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:16:30 -0500
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:45506 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaA2PQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:16:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3870:3871:4321:5007:6120:7652:7901:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13255:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board58_55448523b2209
X-Filterd-Recvd-Size: 1611
Message-ID: <1391008584.11756.59.camel@joe-AO722>
Subject: Re: [PATCH v5 17/23] drm/i2c: tda998x: set the PLL division factor
 in range 0..3
From: Joe Perches <joe@perches.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Wed, 29 Jan 2014 07:16:24 -0800
In-Reply-To: <d4ba259762605793aee726b5e33dcad6a8bd4777.1390986083.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
	 <d4ba259762605793aee726b5e33dcad6a8bd4777.1390986083.git.moinejf@free.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-25 at 18:14 +0100, Jean-Francois Moine wrote:
> The predivider division factor of the register PLL_SERIAL_2 is in the
> range 0..3, the value 0 being used for a division by 1.

trivia:

> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
[]
> @@ -886,6 +886,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  	}
>  
>  	div = 148500 / mode->clock;
> +	if (div != 0) {
> +		div--;
> +		if (div > 3)
> +			div = 3;
> +	}

perhaps
	clamp(div, 1, 4)
	div--;


