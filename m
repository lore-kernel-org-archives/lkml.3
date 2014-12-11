Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbaLKGhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:37:34 -0500
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:54971 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756158AbaLKGhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:37:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2828:2897:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:4184:4321:5007:6261:6691:6742:9036:10004:10226:10400:10848:11232:11658:11914:12043:12050:12296:12517:12519:12740:13069:13311:13357:13972:21060:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jeans36_7b8eed3904501
X-Filterd-Recvd-Size: 2383
Message-ID: <1418279847.18092.32.camel@perches.com>
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Joe Perches <joe@perches.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Yunzhi Li <lyz@rock-chips.com>, heiko@sntech.de, jwerner@chromium.org,
        dianders@chromium.org, olof@lixom.net, huangtao@rock-chips.com,
        zyw@rock-chips.com, cf@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Date: Wed, 10 Dec 2014 22:37:27 -0800
In-Reply-To: <54893963.7060304@ti.com>
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com>
	 <1418208371-18851-2-git-send-email-lyz@rock-chips.com>
	 <5489338C.1030109@ti.com> <1418278322.18092.30.camel@perches.com>
	 <54893963.7060304@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 11:57 +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 11 December 2014 11:42 AM, Joe Perches wrote:
> > On Thu, 2014-12-11 at 11:32 +0530, Kishon Vijay Abraham I wrote:
> >> On Wednesday 10 December 2014 04:16 PM, Yunzhi Li wrote:
> >>> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
> > []
> >>> +/*
> >>> + * The higher 16-bit of this register is used for write protection
> >>> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
> >>> + */
> >>> +#define SIDDQ_MSK		BIT(13 + 16)
> > 
> > huh?
> > 
> > This #define looks _very_ odd.
> > 
> > Is this supposed to be a single bit 29 or
> > some range?
> 
> From what I understood, the most significant 16 bits are write locks to the
> least significant 16 bits.
> 
> So If I have to write something on bit 0, I have to set bit 16.
> If I have to write something on bit 1, I have to set bit 17.
> If I have to write something on bit 2, I have to set bit 18.
> and so on.

To me it'd look better to use another << rather than a plus


