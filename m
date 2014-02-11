Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaBKLpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:45:10 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:43646 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbaBKLpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:45:06 -0500
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Feb 2014 19:44:51 +0800
Subject: RE: [PATCH V6 04/12] phy: st-miphy40lp: Add skeleton driver
Thread-Topic: [PATCH V6 04/12] phy: st-miphy40lp: Add skeleton driver
Thread-Index: Ac8nHWPKWXkkJR7QT8qTlBV05TaCHAAAQYDQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAC1B@EAPEX1MAIL1.st.com>
References: <cover.1392109054.git.mohit.kumar@st.com>
 <850ed00862e7059e3973293131ba3c476b2d52cb.1392109054.git.mohit.kumar@st.com>
 <52FA0AFC.6030708@ti.com>
In-Reply-To: <52FA0AFC.6030708@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1BBjU0H006389

Hello Kishon

> -----Original Message-----
> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Tuesday, February 11, 2014 5:05 PM
> To: Mohit KUMAR DCG; arnd@arndb.de
> Cc: Pratyush ANAND; Viresh Kumar; spear-devel; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH V6 04/12] phy: st-miphy40lp: Add skeleton driver
> 
> Hi,
> 
> On Tuesday 11 February 2014 03:00 PM, Mohit Kumar wrote:
> > From: Pratyush Anand <pratyush.anand@st.com>
> >
> > ST miphy40lp supports PCIe, SATA and Super Speed USB. This driver adds
> > skeleton support for the same.
> >
> > This skeleton defines function corresponding to phy ops as well as
> > sleep pm ops. Any platform using this phy can add its own platform
> > specific ops(if needed) corresponding to each phy ops.
> >
> > Phy specific modifications will require phy register space, which is
> > passed from DT as a resource. Currently only SPEAr1310 and SPEAr1340
> > are known user of this phy, which do not need to modify phy registers
> > normally. Therefore we have not retrieved phy base address from DT and
> > hence not io-remapped it. However, same can be added in future if
> > required.
> >
> > SoC specific modifications should be done in plat specific ops and phy
> > specific modifications should be done in phy ops itself. As a general
> > rule, follow the convention of modifying misc reg space in plat ops
> > and phy reg space in phy ops.
> >
> > Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> > Tested-by: Mohit Kumar <mohit.kumar@st.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Viresh Kumar <viresh.linux@gmail.com>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > Cc: spear-devel@list.st.com
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/phy/Kconfig         |    7 ++
> >  drivers/phy/Makefile        |    1 +
> >  drivers/phy/phy-miphy40lp.c |  234
> > +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 242 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/phy/phy-miphy40lp.c
> >
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig index
> > afa2354..ed5b4f3 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -64,4 +64,11 @@ config BCM_KONA_USB2_PHY
> >  	help
> >  	  Enable this to support the Broadcom Kona USB 2.0 PHY.
> >
> > +config PHY_ST_MIPHY40LP
> > +	tristate "ST MIPHY 40LP driver"
> > +	select GENERIC_PHY
> > +	help
> > +	  Support for ST MIPHY 40LP which can be used for PCIe, SATA and
> Super Speed USB.
> > +	  SPEAr13xx SoCs have used this PHY internally for PCIe and SATA
> implementation.
> > +
> >  endmenu
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
> > b57c253..c061091 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -9,3 +9,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+=
> phy-exynos-mipi-video.o
> >  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
> >  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> >  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> > +obj-$(CONFIG_PHY_ST_MIPHY40LP)		+= phy-miphy40lp.o
> > diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
> > new file mode 100644 index 0000000..98859ff
> > --- /dev/null
> > +++ b/drivers/phy/phy-miphy40lp.c
> > @@ -0,0 +1,234 @@
> > +/*
> > + * ST MiPHY-40LP PHY driver
> > + *
> > + * Copyright (C) 2014 ST Microelectronics
> > + * Pratyush Anand <pratyush.anand@st.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/module.h>
> > +#include <linux/of_device.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/regmap.h>
> > +
> > +enum phy_mode {
> miphy40lp_phy_mode?

- OK

> > +	SATA,
> > +	PCIE,
> > +	SS_USB,
> > +};
> > +
> > +struct miphy40lp_priv;
> > +
> > +/* platform specific function struct */ struct miphy40lp_plat_ops {
> > +	int	(*plat_init)(struct miphy40lp_priv *priv);
> > +	int	(*plat_exit)(struct miphy40lp_priv *priv);
> > +	int	(*plat_power_off)(struct miphy40lp_priv *priv);
> > +	int	(*plat_power_on)(struct miphy40lp_priv *priv);
> > +	int	(*plat_suspend)(struct miphy40lp_priv *priv);
> > +	int	(*plat_resume)(struct miphy40lp_priv *priv);
> > +};
> > +
> > +struct miphy40lp_priv {
> > +	/* regmap for any soc specific misc registers */
> > +	struct regmap			*misc;
> > +	/* phy struct pointer */
> > +	struct phy			*phy;
> > +	/* phy mode: 0 for SATA 1 for PCIe and 2 for SS-USB */
> > +	enum phy_mode			mode;
> > +	/* instance id of this phy */
> > +	u32				id;
> > +	/* platform specific callbacks */
> > +	const struct miphy40lp_plat_ops	*plat_ops;
> > +};
> > +
> > +static int miphy40lp_init(struct phy *phy) {
> > +	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_init)
> > +		ret = ops->plat_init(priv);
> > +
> > +	return ret;
> > +}
> > +
> > +static int miphy40lp_exit(struct phy *phy) {
> > +	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_exit)
> > +		ret = ops->plat_exit(priv);
> > +
> > +	return ret;
> > +}
> > +
> > +static int miphy40lp_power_off(struct phy *phy) {
> > +	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_init)
> > +		ret = ops->plat_init(priv);
> 
> plat_power_off here..

- Oops!

> > +
> > +	return ret;
> > +}
> > +
> > +static int miphy40lp_power_on(struct phy *phy) {
> > +	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_power_on)
> > +		ret = ops->plat_power_on(priv);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct of_device_id miphy40lp_of_match[] = {
> > +	{ .compatible = "st,miphy40lp-phy", .data = NULL },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, miphy40lp_of_match);
> > +
> > +static struct phy_ops miphy40lp_ops = {
> > +	.init = miphy40lp_init,
> > +	.exit = miphy40lp_exit,
> > +	.power_off = miphy40lp_power_off,
> > +	.power_on = miphy40lp_power_on,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int miphy40lp_suspend(struct device *dev) {
> > +	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_suspend)
> > +		ret = ops->plat_suspend(priv);
> > +
> > +	return ret;
> > +}
> > +
> > +static int miphy40lp_resume(struct device *dev) {
> > +	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
> > +	const struct miphy40lp_plat_ops *ops = priv->plat_ops;
> > +	int ret = 0;
> > +
> > +	if (ops && ops->plat_resume)
> > +		ret = ops->plat_resume(priv);
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(miphy40lp_pm_ops, miphy40lp_suspend,
> > +		miphy40lp_resume);
> > +
> > +static struct phy *miphy40lp_xlate(struct device *dev,
> > +					struct of_phandle_args *args)
> > +{
> > +	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
> > +
> > +	if (args->args_count < 1) {
> > +		dev_err(dev, "DT did not pass correct no of args\n");
> > +		return NULL;
> > +	}
> > +
> > +	priv->mode = args->args[0];
> 
> Lets add error checking here if the mode is incorrect.

- Ok, will add it.

> 
> Thanks
> Kishon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
