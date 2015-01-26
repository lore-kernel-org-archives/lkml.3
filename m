Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbbAZKwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:52:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbAZKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:52:28 -0500
Date: Mon, 26 Jan 2015 11:52:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yingjoe Chen =?utf-8?B?KOmZs+iLsea0sik=?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>,
        Flora Fu <flora.fu@mediatek.com>
Subject: Re: [PATCH 7/7] mfd: Add support for the MediaTek MT6397 PMIC
Message-ID: <20150126105222.GM12209@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
 <1422022202-7526-8-git-send-email-s.hauer@pengutronix.de>
 <20150123161440.GA11745@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123161440.GA11745@x1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:28:51 up 102 days, 20:42, 132 users,  load average: 0.07, 0.07,
 0.08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 04:14:40PM +0000, Lee Jones wrote:
> On Fri, 23 Jan 2015, Sascha Hauer wrote:
> 
> > From: Flora Fu <flora.fu@mediatek.com>
> > 
> > This adds support for the MediaTek MT6397 PMIC. This is a
> > multifunction device with the following sub modules:
> > 
> > - Regulator
> > - RTC
> > - Audio codec
> > - GPIO
> > - Clock
> > 
> > It is interfaced to the host controller using SPI interface by a proprietary
> > hardware called PMIC wrapper or pwrap. MT6397 MFD is a child device of the
> > pwrap.
> > 
> > Signed-off-by: Flora Fu, MediaTek
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/mfd/mt6397.txt |  70 +++++
> 
> This should be submitted seperately, as per:
> 
>   Documentation/devicetree/bindings/submitting-patches.txt

I didn't know this document yet, thanks for noting. I thought it is still
acceptable to combine patches adding both code and the binding docs.

> 
> >  drivers/mfd/Kconfig                              |  10 +
> >  drivers/mfd/Makefile                             |   1 +
> >  drivers/mfd/mt6397-core.c                        | 251 ++++++++++++++++
> >  include/linux/mfd/mt6397/core.h                  |  76 +++++
> >  include/linux/mfd/mt6397/registers.h             | 362 +++++++++++++++++++++++
> >  6 files changed, 770 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/mt6397.txt
> >  create mode 100644 drivers/mfd/mt6397-core.c
> >  create mode 100644 include/linux/mfd/mt6397/core.h
> >  create mode 100644 include/linux/mfd/mt6397/registers.h
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt
> > new file mode 100644
> > index 0000000..25b40a6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/mt6397.txt
> > @@ -0,0 +1,70 @@
> > +MediaTek MT6397 Multifunction Device Driver
> > +
> > +MT6397 is a multifunction device with the following sub modules:
> > +- Regulator
> > +- RTC
> > +- Audio codec
> > +- GPIO
> > +- Clock
> > +
> > +It is interfaced to host controller using SPI interface by a proprietary hardware
> > +called PMIC wrapper or pwrap. MT6397 MFD is a child device of pwrap.
> > +See the following for pwarp node definitions:
> > +Documentation/devicetree/bindings/soc/pwrap.txt
> > +
> > +This document describes the binding for mfd device and its sub module.
> 
> Nit: s/mfd/MFD/
> 
> > +Required properties:
> > +compatible: "mediatek,mt6397"
> > +
> > +Optional subnodes:
> > +
> > +- rtc:
> > +	Required properties:
> > +		- compatible: "mediatek,mt6397-rtc",
> > +- regulators
> > +	Required properties:
> > +		- compatible: "mediatek,mt6397-regulator",
> > +	see Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
> > +- codec
> > +	Required properties:
> > +		- compatible: "mediatek,mt6397-codec",
> > +- clk
> > +	Required properties:
> > +		- compatible: "mediatek,mt6397-clk",
> 
> Nit: Titles with or without ':', as long as it's consistent.
> 
> Drop the comma at the end of each compatible line.
> 
> > +Example:
> > +	pwrap: pwrap@1000f000 {
> > +		compatible = "mediatek,mt8135-pwrap";
> > +
> > +		...
> > +
> > +		pmic {
> > +			compatible = "mediatek,mt6397";
> > +
> > +			codec: mt6397codec {
> > +				compatible = "mediatek,mt6397-codec";
> > +			};
> > +
> > +			mt6397regulator: mt6397regulator {
> 
> s/mt6397regulator/regulator/

Dropped the label completely since consumers will point to the
individual regulators, not this node.

> > diff --git a/drivers/mfd/mt6397-core.c b/drivers/mfd/mt6397-core.c
> > new file mode 100644
> > index 0000000..9710fca
> > --- /dev/null
> > +++ b/drivers/mfd/mt6397-core.c
> > @@ -0,0 +1,251 @@
> > +/*
> > + * Copyright (c) 2014 MediaTek Inc.
> > + * Author: Flora Fu, MediaTek
> 
> Email address?

She does not work for MediaTek anymore. Her Email address is no longer
valid, so I removed it but kept her credits in the driver.

> > +{
> > +	return irq >> 4;
> > +}
> > +
> > +static void mt6397_irq_lock(struct irq_data *data)
> > +{
> > +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> > +
> > +	mutex_lock(&mt6397->irqlock);
> > +}
> > +
> > +static void mt6397_irq_sync_unlock(struct irq_data *data)
> > +{
> > +	int i;
> > +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> > +
> > +	regmap_write(mt6397->regmap, MT6397_INT_CON0, mt6397->irq_masks_cur[0]);
> > +	regmap_write(mt6397->regmap, MT6397_INT_CON1, mt6397->irq_masks_cur[1]);
> > +
> > +	mutex_unlock(&mt6397->irqlock);
> > +}
> > +
> > +static void mt6397_irq_mask(struct irq_data *data)
> > +{
> > +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> > +	int shift = mt6397_irq_shift(data->hwirq);
> > +	int reg = mt6397_irq_reg(data->hwirq);
> > +	int reg_ofs = MT6397_INT_CON0 + reg * 2;
> > +
> > +	mt6397->irq_masks_cur[reg] &= ~(1 << shift);
> 
> s/(1 << shift)/BIT(shift)/

Is it mentioned somewhere that these BIT macros shall be used? There are
quadrillions of examples for both styles in the kernel and personally I
think 1 << x is more readable.

> > +	for (i = 0; i < MT6397_IRQ_GROUP_NR; i++) {
> > +		ret = regmap_read(mt6397->regmap,
> > +			MT6397_INT_STATUS0 + i * 2, &irq_reg[i]);
> > +		if (ret > 0) {
> 
> Can regmap_read() return <0?

Yes, but not > 0 ;). Fixed.

> 
> > +			dev_err(mt6397->dev,
> > +				"failed to read interrupt status [0x%x]\n",
> > +				MT6397_INT_STATUS0 + i * 2);
> > +			return IRQ_NONE;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < MT6397_IRQ_NR; i++) {
> > +		int shift = mt6397_irq_shift(i);
> > +		int reg = mt6397_irq_reg(i);
> > +		int reg_ofs = MT6397_INT_STATUS0 + reg * 2;
> > +
> > +		if (irq_reg[reg] & (1 << shift)) {
> > +			cur_irq = irq_find_mapping(mt6397->irq_domain, i);
> > +			if (cur_irq)
> > +				handle_nested_irq(cur_irq);
> > +
> > +			/* write 1 to status bit to clear the event.  */
> 
> There are very few comments in the driver and _this_ is where it was
> felt appropriate to do so?  If you put "MT6397_INT_STATUS0 + reg * 2"
> directly into the call, the line will speak for itself.

I refactored the code a bit, like write status reg once after handling
all interrupts and not after each interrupt. I also removed this comment
since it only states the obvious.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
