Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3LaPbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:31:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44923 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3LaPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:30:58 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-17-52c2e330b7f7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
Cc: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, mark.rutland@arm.com, jg1.han@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, swarren@wwwdotorg.org,
        rob.herring@calxeda.com, grant.likely@linaro.org,
        christoffer.dall@linaro.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH V4 1/2] Phy: Exynos: Add Exynos5250 sata phy driver
Date: Tue, 31 Dec 2013 16:30:42 +0100
Message-id: <11600750.UKZ7EpemHS@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1388408823-4963-2-git-send-email-yuvaraj.cd@samsung.com>
References: <1388408823-4963-1-git-send-email-yuvaraj.cd@samsung.com>
 <1388408823-4963-2-git-send-email-yuvaraj.cd@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jAV2Dx4eCDF7ulLR48fofo8X8I+dY
	LQ782cFocXnhJVaL77u+sFv0LrjKZnHhaQ+bxfyjO5gsNj2+xmqxsG0Ji8WxHY+YLC7vmsNm
	sfT6RSaLwysOMFm8OtjGYrF+xmsWi1XrDrNZPDzazWpx9lS5g7DHmnlrGD0WfL7C7rFz1l12
	jzvX9rB5bF5S79G3ZRWjx/Eb25k8Pm+S89g4NzSAM4rLJiU1J7MstUjfLoErY/9bt4IztRXf
	7jSyNDBOSu1i5OSQEDCR6Ju9mB3CFpO4cG89WxcjF4eQwCJGifvPXrJAOC1MEvsnPmACqWIT
	sJKY2L6KEcQWEdCR2L39CpjNLPCLWWLHHoEuRg4OYQF3icPz+EBMFgFViXXfdUEqeAW0JDbP
	+MoCYosKeErs2L6SDcTmFHCTmPxhHdTeRkaJ/U8OsUE0CEr8mHyPBWK8vMS+/VNZIWwdif2t
	09gmMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER98z6R2Mqxos
	DjEKcDAq8fAueHAoSIg1say4MvcQowQHs5IIb9B+oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
	g63WgUIC6YklqdmpqQWpRTBZJg5OqQZGxReK+ismrK8UjZpf7+XZMGnijDeumhOW3TR/0ul+
	bMP62upVu79eTCmbPXmi18EDzWkmcUXyXvO7p/1ivm9gOCckSzr1vMmLl2nclfLnp2RUmEgV
	L+nq7HfKOdm5JPduw2q7m/6WCTb/pjYu/35SnnnymqcnP23/V1m7v/OB1K8fu08aTZL4rsRS
	nJFoqMVcVJwIAO7/4qW6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-ide ML to Cc: ]

Hi,

Overall the code looks good, thank you for working on this.

I still have some review comments though..

On Monday, December 30, 2013 06:37:02 PM Yuvaraj Kumar C D wrote:
> This patch adds the sata phy driver for Exynos5250.Exynos5250 sata
> phy comprises of CMU and TRSV blocks which are of I2C register Map.
> So this patch also adds a i2c client driver, which is used configure
> the CMU and TRSV block of exynos5250 SATA PHY.
> 
> This patch incorporates the generic phy framework to deal with sata
> phy.

Two minor nits here:

- Some consistency in using of "SATA", "PHY" and "Exynos" would be
  nice, i.e.:

  s/sata/SATA/
  s/phy/PHY/
  s/exynos/Exynos/

- Please add two spaces after each "." and before new sentence.

> This patch depends on the below patches
> 	[1].drivers: phy: add generic PHY framework
> 		by Kishon Vijay Abraham I<kishon@ti.com>
> 	[2].ata: ahci_platform: Manage SATA PHY
> 		by Roger Quadros <rogerq@ti.com>
> 
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>
> ---
> Changes from V3:
> 	1.Moved devm_phy_create before to devm_phy_provider_register.
> 
> Changes from V2:
> 	1.Removed of_match_table
> 	2.Moved to syscon interface for PMU handling.
> 
> Changes from V1:
> 	1.Adapted to latest version of Generic PHY framework
> 	2.Removed exynos_sata_i2c_remove function.
> 
> 
>  drivers/phy/Kconfig               |   11 ++
>  drivers/phy/Makefile              |    1 +
>  drivers/phy/exynos5250_phy_i2c.c  |   44 ++++++++
>  drivers/phy/sata_phy_exynos5250.c |  220 +++++++++++++++++++++++++++++++++++++

For consistency with other PHY drivers this file should be named
diffirently (phy-exynos5250-sata.c).

>  drivers/phy/sata_phy_exynos5250.h |   35 ++++++
>  5 files changed, 311 insertions(+)
>  create mode 100644 drivers/phy/exynos5250_phy_i2c.c
>  create mode 100644 drivers/phy/sata_phy_exynos5250.c
>  create mode 100644 drivers/phy/sata_phy_exynos5250.h
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index d0611b8..6ea124d 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -57,4 +57,15 @@ config PHY_EXYNOS_DP_VIDEO
>  	help
>  	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
>  
> +config EXYNOS5250_SATA_PHY

I think that for consistency with other config options it should be
named PHY_EXYNOS5250_SATA instead.

> +	tristate "Exynos5250 Sata SerDes/PHY driver"
> +	depends on SOC_EXYNOS5250
> +	select GENERIC_PHY
> +	select MFD_SYSCON if ARCH_EXYNOS5

"if ARCH_EXYNOS5" check shouldn't be needed given SOC_EXYNOS5250
dependency.

> +	help
> +	  Enable this to support SATA SerDes/Phy found on Samsung's
> +	  Exynos5250 based SoCs.This SerDes/Phy supports SATA 1.5 Gb/s,
> +	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds.It supports one SATA host
> +	  port to accept one SATA device.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 4e4adc9..b73eb73 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_EXYNOS5250_SATA_PHY)	+= sata_phy_exynos5250.o exynos5250_phy_i2c.o

Will this compile/work without I2C support?

CONFIG_EXYNOS5250_SATA_PHY doesn't require it currently.

> diff --git a/drivers/phy/exynos5250_phy_i2c.c b/drivers/phy/exynos5250_phy_i2c.c
> new file mode 100644
> index 0000000..c0c1150
> --- /dev/null
> +++ b/drivers/phy/exynos5250_phy_i2c.c
> @@ -0,0 +1,44 @@
> +/*
> + * Copyright (C) 2013 Samsung Electronics Co.Ltd
> + * Author:
> + *	Yuvaraj C D <yuvaraj.cd@samsung.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>

Please add a newline here.

> +#include "sata_phy_exynos5250.h"
> +
> +static int exynos_sata_i2c_probe(struct i2c_client *client,
> +		const struct i2c_device_id *i2c_id)
> +{
> +	int ret = 0;

No need to initialize "ret", also please add a newline here.

> +	ret = sataphy_attach_i2c_client(client);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_info(&client->adapter->dev,
> +		"attached %s into sataphy i2c adapter successfully\n",
> +		client->name);
> +
> +	return ret;
> +}
> +
> +static const struct i2c_device_id sataphy_i2c_device_match[] = {
> +	{ "exynos-sataphy-i2c", 0 },
> +};
> +
> +struct i2c_driver sataphy_i2c_driver = {

Keeping it global together with sataphy_attach_i2c_client() is not very
nice.  I've talked with our local device tree guru (a.k.a. Tomasz Figa)
about this and it may be that this i2c driver is not even necessary.

If you manage to extract i2c adapter and address data from the device
tree (using proper of_* methods) they can be used instead of i2c client
data in the SATA PHY driver.

> +	.probe		= exynos_sata_i2c_probe,
> +	.id_table	= sataphy_i2c_device_match,
> +	.driver   = {
> +		.name = "exynos-sataphy-i2c",
> +		.owner = THIS_MODULE,
> +		},
> +};
> diff --git a/drivers/phy/sata_phy_exynos5250.c b/drivers/phy/sata_phy_exynos5250.c
> new file mode 100644
> index 0000000..0765863
> --- /dev/null
> +++ b/drivers/phy/sata_phy_exynos5250.c
> @@ -0,0 +1,220 @@
> +/*
> + * Samsung SATA SerDes(PHY) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Authors: Girish K S <ks.giri@samsung.com>
> + *         Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/spinlock.h>
> +#include <linux/mfd/syscon.h>

Please add a newline here.

> +#include "sata_phy_exynos5250.h"
> +
> +static struct i2c_client *phy_i2c_client;
> +
> +struct exynos_sata_phy {
> +	struct phy *phy;
> +	struct clk *phyclk;
> +	void __iomem *regs;
> +	void __iomem *pmureg;
> +};
> +
> +static bool wait_for_reg_status(void __iomem *base, u32 reg, u32 checkbit,
> +				u32 status)
> +{
> +	unsigned long timeout = jiffies + usecs_to_jiffies(1000);

ditto

> +	while (time_before(jiffies, timeout)) {
> +		if ((readl(base + reg) & checkbit) == status)
> +			return true;
> +	}

ditto

> +	return false;
> +}
> +
> +int sataphy_attach_i2c_client(struct i2c_client *sata_phy)

sata_phy is not a best variable name here, maybe just use "client"
instead?

> +{
> +	if (!sata_phy)
> +		return -EPROBE_DEFER;
> +	else
> +		phy_i2c_client = sata_phy;
> +
> +	return 0;
> +}
> +
> +static int exynos_sata_phy_power_on(struct phy *phy)
> +{
> +	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
> +
> +	if (sata_phy->pmureg)

No need to check it, exynos_sata_phy_probe() fails early if pmureg
cannot be find.

> +		regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
> +			EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
> +
> +	return 0;
> +}
> +
> +static int exynos_sata_phy_power_off(struct phy *phy)
> +{
> +	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
> +
> +	if (sata_phy->pmureg)

ditto

> +		regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
> +			EXYNOS5_SATAPHY_PMU_ENABLE, ~EXYNOS_SATA_PHY_EN);
> +
> +	return 0;
> +}
> +
> +static int exynos_sata_phy_init(struct phy *phy)
> +{
> +	u32 val = 0;
> +	int ret = 0;
> +	u8 buf[] = { 0x3A, 0x0B };
> +	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
> +
> +	if (sata_phy->pmureg)

ditto

> +		regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
> +			EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
> +
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
> +
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
> +	val |= 0xFF;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
> +
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
> +	val |= LINK_RESET;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
> +
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
> +	val |= RESET_CMN_RST_N;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);

Please add a newline here.

> +	val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
> +	val &= ~PHCTRLM_REF_RATE;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
> +
> +	/* High speed enable for Gen3 */
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
> +	val |= PHCTRLM_HIGH_SPEED;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
> +
> +	val |= CTRL0_P0_PHY_CALIBRATED_SEL | CTRL0_P0_PHY_CALIBRATED;

This doesn't look correct.  The "val" variable still contains value
used previously for PHCTRLM register and now (after setting bits 8-9)
it will be reused for CTRL0 register.  I believe that there is a

	val = readl(sata_phy->regs + EXYNOS5_SATA_CTRL0);

missing here.

> +	writel(val, sata_phy->regs + EXYNOS5_SATA_CTRL0);
> +
> +	writel(0x2, sata_phy->regs + EXYNOS5_SATA_MODE0);

Please add a define instead of using a magic number.  Morever the code
should read the content of MODE0 register first and then set bit1 (in
the documentation that I have bits 2-31 are marked as Reserved, which
means that they are not necessarily hard-wired to zero).

Also:

This code sets PHY# speed mode to 6.0 Gb/s.  Does this setting need to
be updated when 3.0 Gb/s or 1.5 Gb/s devices are used instead?  Do such
devices work fine with the current code?

[ There is a patch adding set_speed method to the generic PHY framework:

	http://permalink.gmane.org/gmane.linux.scsi/86660

  but AHCI platform driver would still need to be updated to use it. ]

> +	ret = i2c_master_send(phy_i2c_client, buf, sizeof(buf));
> +	if (ret < 0)
> +		return -ENXIO;
> +
> +	/* release cmu reset */
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
> +	val &= ~RESET_CMN_RST_N;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
> +
> +	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
> +	val |= RESET_CMN_RST_N;
> +	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
> +
> +	return (wait_for_reg_status(sata_phy->regs, EXYNOS5_SATA_PHSATA_STATM,
> +		PHSTATM_PLL_LOCKED, 1)) ? 0 : -EINVAL;
> +
> +}
> +
> +static struct phy_ops exynos_sata_phy_ops = {
> +	.init		= exynos_sata_phy_init,
> +	.power_on	= exynos_sata_phy_power_on,
> +	.power_off	= exynos_sata_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int exynos_sata_phy_probe(struct platform_device *pdev)
> +{
> +	struct exynos_sata_phy *sata;

Why not name it sata_phy like in other functions?

> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	int ret = 0;
> +
> +	sata = devm_kzalloc(dev, sizeof(*sata), GFP_KERNEL);
> +	if (!sata)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	sata->regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(sata->regs))
> +		return PTR_ERR(sata->regs);
> +
> +	sata->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
> +					"samsung,syscon-phandle");
> +	if (!sata->pmureg) {
> +		dev_err(dev, "syscon regmap lookup failed.\n");
> +		return PTR_ERR(sata->pmureg);
> +	}
> +	dev_set_drvdata(dev, sata);
> +
> +	if (i2c_add_driver(&sataphy_i2c_driver)) {
> +		dev_err(dev, "failed to register sataphy i2c driver\n");
> +		return -ENOENT;
> +	}
> +
> +	sata->phyclk = devm_clk_get(dev, "sata_phyctrl");
> +	if (IS_ERR(sata->phyclk)) {

Don't we need to also unregister i2c driver on failure?

> +		dev_err(dev, "failed to get clk for PHY\n");
> +		return PTR_ERR(sata->phyclk);
> +	}
> +
> +	ret = clk_prepare_enable(sata->phyclk);
> +	if (ret < 0) {

ditto

> +		dev_err(dev, "failed to enable source clk\n");
> +		return ret;
> +	}
> +
> +	sata->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
> +	if (IS_ERR(sata->phy)) {

ditto + clk_disable_unprepare(sata->phyclk)

> +		dev_err(dev, "failed to create PHY\n");
> +		return PTR_ERR(sata->phy);
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> +					of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))

ditto

> +		return PTR_ERR(phy_provider);
> +
> +	phy_set_drvdata(sata->phy, sata);
> +	return 0;
> +}
> +
> +static const struct of_device_id exynos_sata_phy_of_match[] = {
> +	{ .compatible = "samsung,exynos5250-sata-phy" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_sata_phy_of_match);
> +
> +static struct platform_driver exynos_sata_phy_driver = {
> +	.probe	= exynos_sata_phy_probe,
> +	.driver = {
> +		.of_match_table	= exynos_sata_phy_of_match,
> +		.name  = "samsung,sata-phy",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +module_platform_driver(exynos_sata_phy_driver);
> +
> +MODULE_DESCRIPTION("Samsung SerDes PHY driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("ks.giri <ks.giri@samsung.com>");
> +MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
> diff --git a/drivers/phy/sata_phy_exynos5250.h b/drivers/phy/sata_phy_exynos5250.h
> new file mode 100644
> index 0000000..3e2089d
> --- /dev/null
> +++ b/drivers/phy/sata_phy_exynos5250.h
> @@ -0,0 +1,35 @@
> +/*
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + * Author:
> + *	Yuvaraj Kumar C D<yuvaraj.cd@samsung.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#define EXYNOS5_SATA_RESET		0x4
> +#define EXYNOS5_SATA_MODE0		0x10
> +#define EXYNOS5_SATA_CTRL0		0x14
> +#define EXYNOS5_SATA_STAT0		0x18

This one seems to be unused and can be removed.

> +#define EXYNOS5_SATA_PHSATA_CTRLM	0xE0
> +#define EXYNOS5_SATA_PHSATA_CTRL0	0xE4

ditto

> +#define EXYNOS5_SATA_PHSATA_STATM	0xF0
> +#define EXYNOS5_SATA_PHSTAT0		0xF4

ditto

> +#define RESET_CMN_RST_N			(1 << 1)
> +#define LINK_RESET			0xF0000
> +#define CTRL0_P0_PHY_CALIBRATED_SEL	(1 << 9)
> +#define CTRL0_P0_PHY_CALIBRATED		(1 << 8)
> +#define PHCTRLM_REF_RATE		(1 << 1)
> +#define PHCTRLM_HIGH_SPEED		(1 << 0)
> +#define PHSTATM_PLL_LOCKED		(1 << 0)
> +#define SATA_PHY_CON_RESET		(LINK_RESET | 3F)

ditto (LINK_RESET can also be removed)

> +#define EXYNOS_SATA_PHY_EN		(1 << 0)
> +#define SATAPHY_CONTROL_OFFSET		0x0724
> +#define EXYNOS5_SATAPHY_PMU_ENABLE	(1 << 0)

All above defines can be moved into the SATA PHY driver as they are
not intended to be shared with other code.

To make the code easier to read you can also group the defines for
specific register below this register offset define, i.e.:

#define EXYNOS5_SATA_RESET		0x4
#define RESET_CMN_RST_N			(1 << 1)
#define LINK_RESET			0xF0000
#define EXYNOS5_SATA_MODE0		0x10
...

> +int sataphy_attach_i2c_client(struct i2c_client *sata_phy);
> +extern struct i2c_driver sataphy_i2c_driver;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

