Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLRBrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:47:52 -0500
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:50948 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751822AbaLRBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:47:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4321:4605:5007:6261:6742:8957:9038:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cakes28_26e7772f2931b
X-Filterd-Recvd-Size: 2283
Message-ID: <1418867265.28384.6.camel@perches.com>
Subject: Re: [PATCH v3 1/2] watchdog: Add driver for Mediatek watchdog
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, wim@iguana.be,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        heiko@sntech.de, yingjoe.chen@gmail.com, ibanezchen@gmail.com,
        greta.zhang@mediatek.com, eddie.huang@mediatek.com, wens@csie.org
Date: Wed, 17 Dec 2014 17:47:45 -0800
In-Reply-To: <20141218013717.GA9855@roeck-us.net>
References: <1418851085-17787-1-git-send-email-matthias.bgg@gmail.com>
	 <1418851085-17787-2-git-send-email-matthias.bgg@gmail.com>
	 <20141218013717.GA9855@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 17:37 -0800, Guenter Roeck wrote:
> On Wed, Dec 17, 2014 at 10:18:04PM +0100, Matthias Brugger wrote:
> > This patch adds a driver for the Mediatek SoC integrated
> > watchdog. This driver supports watchdog and software reset
> > for mt65xx and mt81xx SoCs.
[]
> > diff --git a/drivers/watchdog/mtk_wdt.c b/drivers/watchdog/mtk_wdt.c
[]
> > +static int mtk_reset_handler(struct notifier_block *this, unsigned long mode,
> > +				void *cmd)
> > +{
> > +	struct mtk_wdt_dev *mtk_wdt = container_of(this,
> > +						       struct mtk_wdt_dev,
> > +						       restart_handler);

> I don't really understand the indentation logic you are using.
> Can you make it consistent ?
> 
> I would suggest to align with '(' in the previous line.

Another way is to separate the declaration and the set

	struct mtk_wdt_dev *mtk_wdt;
	void __iomem *wdt_base;

	mtk_wdt = container_of(this, struct mtk_wdt_dev, restart_handler);
	wdt_base = mtk_wdt->wdt_base;



