Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaLAGlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:41:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaLAGlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:41:20 -0500
Date: Mon, 1 Dec 2014 07:40:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v2 8/8] ARM: dts: mt8135: Add support for MT6397 regulator
Message-ID: <20141201064011.GC30369@pengutronix.de>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-9-git-send-email-flora.fu@mediatek.com>
 <20141128153008.GS7712@sirena.org.uk>
 <1417403967.9547.2.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417403967.9547.2.camel@mtksdaap41>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:33:08 up 46 days, 17:46, 44 users,  load average: 0.03, 0.10,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:19:25AM +0800, Flora Fu wrote:
> Hi, Mark, 
> 
> On Fri, 2014-11-28 at 15:30 +0000, Mark Brown wrote: 
> > On Fri, Nov 28, 2014 at 11:54:34AM +0800, Flora Fu wrote:
> > 
> > > Add device tree for MT6397 regulators in mt8135.dtsi.
> > > 
> > > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > > ---
> > >  arch/arm/boot/dts/mt8135.dtsi | 192 ++++++++++++++++++++++++++++++++++++++++++
> > 
> > This appears to be the DT fragment for a SoC but you are defining the
> > system integration for the PMIC.  That's bad, the PMIC is a separate
> > device so should be hooked up by the board using it.  If there's common
> > elements from a reference design they should be in their own .dtsi.
> > 
> 
> Do you mean that we should add a mt6397.dtsi and include it from
> mt8135.dtsi? For board specific, update them in mt8135.dtsi?

You can't include it from mt8135.dtsi since here you don't know if a
mt6397.dtsi is connected. You have to include both the mt8135.dtsi and
the mt6397.dtsi from the board file.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
