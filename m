Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3LZQ6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:58:43 -0500
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:35718 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753495Ab3LZQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:58:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:4362:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12294:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lunch08_1155ef2f29435
X-Filterd-Recvd-Size: 2486
Message-ID: <1388077117.2459.10.camel@joe-AO722>
Subject: Re: [PATCH] Add ff-memless-next module
From: Joe Perches <joe@perches.com>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com
Date: Thu, 26 Dec 2013 08:58:37 -0800
In-Reply-To: <4629786.9msWpURVJS@geidi-prime>
References: <4629786.9msWpURVJS@geidi-prime>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-26 at 17:33 +0100, Michal Malý wrote:
> This patch adds "ff-memless-next" module. This module is based on the current
> "ff-memless" module but it has considerably extended capabilities. These include:
[]
> Why is this written as a new module and not a patch for "ff-memless"? This
> module uses a different API for the HW-specific driver; this was a necessary
> step to make use of the module's additional features. All 25 drivers that
> currently use "ff-memless" would have to be updated. "ff-memless-next" currently
> does not support FF_RUMBLE which is needed to support various joypads.

Thanks for that explanation.

[]

> +static unsigned long mlnx_get_envelope_update_time(const struct mlnx_effect *mlnxeff,
> +						   const unsigned long update_rate_jiffies)
> +{

> +	/* Effect has an envelope with nonzero fade time */
> +	if (mlnxeff->effect.replay.length) {
> +		if (!envelope->fade_length)
> +			return mlnxeff->stop_at;
> +
> +		/* Schedule the next update when the fade begins */
> +		if (time_before(mlnxeff->updated_at, mlnxeff->fade_begin))
> +			return mlnxeff->fade_begin;
> +
> +		/* Already fading */
> +		else {
> +			fade_next = mlnxeff->updated_at + update_rate_jiffies;
> +

There's no need for an else and extra indentation here
 
	if (foo)
		return;
	else {			/* unnecessary else */
		bar...
	}

please just use

	if (foo)
		return;

	bar...

> +			/* Schedule update when the effect stops */
> +			if (time_after(fade_next, mlnxeff->stop_at))
> +				return mlnxeff->stop_at;
> +			/* Schedule update at the next checkpoint */
> +			else
> +				return fade_next;
> +		}
> +	}


