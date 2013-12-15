Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3LOCEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:04:09 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:36944 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754640Ab3LOCEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:04:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:4321:5007:6119:7652:7903:10004:10400:10848:11026:11658:11914:12043:12296:12517:12519:12740:13019:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: form82_67a7fb119719
X-Filterd-Recvd-Size: 1646
Message-ID: <1387073042.2276.21.camel@joe-AO722>
Subject: Re: [RFC] Add ff-memless-next driver
From: Joe Perches <joe@perches.com>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, elias.vds@gmail.com, anssi.hannula@iki.fi
Date: Sat, 14 Dec 2013 18:04:02 -0800
In-Reply-To: <20107437.IkYg87uJMY@geidi-prime>
References: <20107437.IkYg87uJMY@geidi-prime>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-15 at 01:19 +0100, Michal Malý wrote:
> diff --git a/drivers/input/ff-memless-next.c b/drivers/input/ff-memless-next.c
[]
> +static inline s32 mlnx_clamp_level(const s32 level)
> +{
> +	return (level > 0x7fff) ? 0x7fff : ((level < -0x7fff) ? -0x7fff : level);

	clamp(level, -0x7fff, 0x7fff);
[]
> +static inline int mlnx_is_conditional(const struct ff_effect *effect)
> +{
> +	return (effect->type == FF_DAMPER) || (effect->type == FF_FRICTION) || (effect->type == FF_INERTIA) || (effect->type == FF_SPRING);
> +}

Maybe try to run your patch through scripts/checkpatch.pl

bool?
80 char line max? (true for the file, not just here)
switch?
	switch (effect->type) {
	case FF_DAMPER:
	case FF_FRICTION:
	case FF_INERTIA:
	case FF_SPRING:
		return true;
	}
	return false;



