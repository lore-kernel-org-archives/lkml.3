Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaLOL3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:29:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57809 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbaLOL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:28:59 -0500
Date: Mon, 15 Dec 2014 11:28:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
Message-ID: <20141215112848.GE462@leverpostej>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
 <20141211180245.GE28150@leverpostej>
 <20141212065235.GK30369@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212065235.GK30369@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:52:35AM +0000, Sascha Hauer wrote:
> On Thu, Dec 11, 2014 at 06:02:46PM +0000, Mark Rutland wrote:
> > Hi,
> > 
> > On Wed, Dec 10, 2014 at 10:50:01AM +0000, Eddie Huang wrote:
> > > Add device tree support for MT8173 SoC and evalutaion board based on it.
> > > 
> > > Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> > > ---
> > >  arch/arm64/boot/dts/Makefile       |   1 +
> > >  arch/arm64/boot/dts/mt8173-evb.dts |  31 +++++++
> > >  arch/arm64/boot/dts/mt8173.dtsi    | 164 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 196 insertions(+)
> > >  create mode 100644 arch/arm64/boot/dts/mt8173-evb.dts
> > >  create mode 100644 arch/arm64/boot/dts/mt8173.dtsi
> > > 
> > > diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> > > index f8001a6..db7661e 100644
> > > --- a/arch/arm64/boot/dts/Makefile
> > > +++ b/arch/arm64/boot/dts/Makefile
> > > @@ -1,3 +1,4 @@
> > > +dtb-$(CONFIG_ARCH_MEDIATEK) += mt8173-evb.dtb
> > >  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
> > >  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
> > >  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> > > diff --git a/arch/arm64/boot/dts/mt8173-evb.dts b/arch/arm64/boot/dts/mt8173-evb.dts
> > > new file mode 100644
> > > index 0000000..adf26dd
> > > --- /dev/null
> > > +++ b/arch/arm64/boot/dts/mt8173-evb.dts
> > > @@ -0,0 +1,31 @@
> > > +/*
> > > + * Copyright (c) 2014 MediaTek Inc.
> > > + * Author: Eddie Huang <eddie.huang@mediatek.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +/dts-v1/;
> > > +#include "mt8173.dtsi"
> > > +
> > > +/ {
> > > +	model = "mediatek,mt8173-evb";
> > > +
> > > +	aliases {
> > > +		serial0 = &uart0;
> > > +		serial1 = &uart1;
> > > +		serial2 = &uart2;
> > > +		serial3 = &uart3;
> > 
> > Do any of these support earlycon?
> > 
> > > +	};
> > > +
> > > +	memory {
> > 
> > Nit: should be memory@40000000 (and you'll need to add device_type =
> > "memory").
> 
> skeleton.dtsi already has a /memory node with device_type = "memory".
> Shouldn't that be used?

To be honest I don't think that skeleton.dtsi is all that helpful.

Almost all dts files define the root #address-cells and #size-cells for
clarity anyway (which means the memory node isn't necessarily adequately
sized), and the memory node(s) should have unit-addresses (so they won't
match the memory node it provides).

Where a dts is written with the assumption that the bootloader will fill
things there should be a comment in the dts to that effect, with
adequately sized memory nodes.

The only potentially useful items are the empty /chosen and /aliases
nodes. Both of which don't seem to be strictly required.

If anything, I'd be tempted to get rid of skeleton.dtsi entirely.

Thanks,
Mark.
