Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaHNOYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:24 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35347 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaHNOYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:20 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 1/7] usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver
Date: Thu, 14 Aug 2014 19:53:54 +0530
Message-Id: <1408026240-28365-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing this older USB 3.0 DRD controller PHY driver, since
a new driver based on generic phy framework is now available.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/Kconfig            |    8 -
 drivers/usb/phy/Makefile           |    1 -
 drivers/usb/phy/phy-samsung-usb.h  |   80 ---------
 drivers/usb/phy/phy-samsung-usb3.c |  350 ------------------------------------
 4 files changed, 439 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index e253fa0..751b594 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -86,14 +86,6 @@ config SAMSUNG_USB2PHY
 	  Enable this to support Samsung USB 2.0 (High Speed) PHY controller
 	  driver for Samsung SoCs.
 
-config SAMSUNG_USB3PHY
-	tristate "Samsung USB 3.0 PHY controller Driver"
-	select SAMSUNG_USBPHY
-	select USB_PHY
-	help
-	  Enable this to support Samsung USB 3.0 (Super Speed) phy controller
-	  for samsung SoCs.
-
 config TWL6030_USB
 	tristate "TWL6030 USB Transceiver Driver"
 	depends on TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 24a9133..9c984dd 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_OTG)			+= phy-omap-otg.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
-obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
 obj-$(CONFIG_TWL6030_USB)		+= phy-twl6030-usb.o
 obj-$(CONFIG_USB_EHCI_TEGRA)		+= phy-tegra-usb.o
 obj-$(CONFIG_USB_GPIO_VBUS)		+= phy-gpio-vbus-usb.o
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 68771bf..dd2a0b5 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -155,86 +155,6 @@
 
 #define EXYNOS5_PHY_OTG_TUNE			(0x40)
 
-/* EXYNOS5: USB 3.0 DRD */
-#define EXYNOS5_DRD_LINKSYSTEM			(0x04)
-
-#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
-#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
-#define LINKSYSTEM_XHCI_VERSION_CONTROL		(0x1 << 27)
-
-#define EXYNOS5_DRD_PHYUTMI			(0x08)
-
-#define PHYUTMI_OTGDISABLE			(0x1 << 6)
-#define PHYUTMI_FORCESUSPEND			(0x1 << 1)
-#define PHYUTMI_FORCESLEEP			(0x1 << 0)
-
-#define EXYNOS5_DRD_PHYPIPE			(0x0c)
-
-#define EXYNOS5_DRD_PHYCLKRST			(0x10)
-
-#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
-#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
-
-#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
-#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
-
-#define PHYCLKRST_SSC_EN			(0x1 << 20)
-#define PHYCLKRST_REF_SSP_EN			(0x1 << 19)
-#define PHYCLKRST_REF_CLKDIV2			(0x1 << 18)
-
-#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x02 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
-
-#define PHYCLKRST_FSEL_MASK			(0x3f << 5)
-#define PHYCLKRST_FSEL(_x)			((_x) << 5)
-#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
-#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
-#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
-#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
-
-#define PHYCLKRST_RETENABLEN			(0x1 << 4)
-
-#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
-#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
-#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
-
-#define PHYCLKRST_PORTRESET			(0x1 << 1)
-#define PHYCLKRST_COMMONONN			(0x1 << 0)
-
-#define EXYNOS5_DRD_PHYREG0			(0x14)
-#define EXYNOS5_DRD_PHYREG1			(0x18)
-
-#define EXYNOS5_DRD_PHYPARAM0			(0x1c)
-
-#define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
-#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
-#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
-
-#define EXYNOS5_DRD_PHYPARAM1			(0x20)
-
-#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
-#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
-
-#define EXYNOS5_DRD_PHYTERM			(0x24)
-
-#define EXYNOS5_DRD_PHYTEST			(0x28)
-
-#define PHYTEST_POWERDOWN_SSP			(0x1 << 3)
-#define PHYTEST_POWERDOWN_HSP			(0x1 << 2)
-
-#define EXYNOS5_DRD_PHYADP			(0x2c)
-
-#define EXYNOS5_DRD_PHYBATCHG			(0x30)
-
-#define PHYBATCHG_UTMI_CLKSEL			(0x1 << 2)
-
-#define EXYNOS5_DRD_PHYRESUME			(0x34)
-#define EXYNOS5_DRD_LINKPORT			(0x44)
-
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
deleted file mode 100644
index cc08192..0000000
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ /dev/null
@@ -1,350 +0,0 @@
-/* linux/drivers/usb/phy/phy-samsung-usb3.c
- *
- * Copyright (c) 2013 Samsung Electronics Co., Ltd.
- *              http://www.samsung.com
- *
- * Author: Vivek Gautam <gautam.vivek@samsung.com>
- *
- * Samsung USB 3.0 PHY transceiver; talks to DWC3 controller.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/usb/samsung_usb_phy.h>
-#include <linux/platform_data/samsung-usbphy.h>
-
-#include "phy-samsung-usb.h"
-
-/*
- * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
- */
-static u32 samsung_usb3phy_set_refclk(struct samsung_usbphy *sphy)
-{
-	u32 reg;
-	u32 refclk;
-
-	refclk = sphy->ref_clk_freq;
-
-	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
-		PHYCLKRST_FSEL(refclk);
-
-	switch (refclk) {
-	case FSEL_CLKSEL_50M:
-		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
-			PHYCLKRST_SSC_REFCLKSEL(0x00));
-		break;
-	case FSEL_CLKSEL_20M:
-		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
-			PHYCLKRST_SSC_REFCLKSEL(0x00));
-		break;
-	case FSEL_CLKSEL_19200K:
-		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
-			PHYCLKRST_SSC_REFCLKSEL(0x88));
-		break;
-	case FSEL_CLKSEL_24M:
-	default:
-		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
-			PHYCLKRST_SSC_REFCLKSEL(0x88));
-		break;
-	}
-
-	return reg;
-}
-
-static void samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
-{
-	void __iomem *regs = sphy->regs;
-	u32 phyparam0;
-	u32 phyparam1;
-	u32 linksystem;
-	u32 phybatchg;
-	u32 phytest;
-	u32 phyclkrst;
-
-	/* Reset USB 3.0 PHY */
-	writel(0x0, regs + EXYNOS5_DRD_PHYREG0);
-
-	phyparam0 = readl(regs + EXYNOS5_DRD_PHYPARAM0);
-	/* Select PHY CLK source */
-	phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
-	/* Set Loss-of-Signal Detector sensitivity */
-	phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
-	phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
-	writel(phyparam0, regs + EXYNOS5_DRD_PHYPARAM0);
-
-	writel(0x0, regs + EXYNOS5_DRD_PHYRESUME);
-
-	/*
-	 * Setting the Frame length Adj value[6:1] to default 0x20
-	 * See xHCI 1.0 spec, 5.2.4
-	 */
-	linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
-			LINKSYSTEM_FLADJ(0x20);
-	writel(linksystem, regs + EXYNOS5_DRD_LINKSYSTEM);
-
-	phyparam1 = readl(regs + EXYNOS5_DRD_PHYPARAM1);
-	/* Set Tx De-Emphasis level */
-	phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
-	phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
-	writel(phyparam1, regs + EXYNOS5_DRD_PHYPARAM1);
-
-	phybatchg = readl(regs + EXYNOS5_DRD_PHYBATCHG);
-	phybatchg |= PHYBATCHG_UTMI_CLKSEL;
-	writel(phybatchg, regs + EXYNOS5_DRD_PHYBATCHG);
-
-	/* PHYTEST POWERDOWN Control */
-	phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
-	phytest &= ~(PHYTEST_POWERDOWN_SSP |
-			PHYTEST_POWERDOWN_HSP);
-	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
-
-	/* UTMI Power Control */
-	writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
-
-	phyclkrst = samsung_usb3phy_set_refclk(sphy);
-
-	phyclkrst |= PHYCLKRST_PORTRESET |
-			/* Digital power supply in normal operating mode */
-			PHYCLKRST_RETENABLEN |
-			/* Enable ref clock for SS function */
-			PHYCLKRST_REF_SSP_EN |
-			/* Enable spread spectrum */
-			PHYCLKRST_SSC_EN |
-			/* Power down HS Bias and PLL blocks in suspend mode */
-			PHYCLKRST_COMMONONN;
-
-	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
-
-	udelay(10);
-
-	phyclkrst &= ~(PHYCLKRST_PORTRESET);
-	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
-}
-
-static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
-{
-	u32 phyutmi;
-	u32 phyclkrst;
-	u32 phytest;
-	void __iomem *regs = sphy->regs;
-
-	phyutmi = PHYUTMI_OTGDISABLE |
-			PHYUTMI_FORCESUSPEND |
-			PHYUTMI_FORCESLEEP;
-	writel(phyutmi, regs + EXYNOS5_DRD_PHYUTMI);
-
-	/* Resetting the PHYCLKRST enable bits to reduce leakage current */
-	phyclkrst = readl(regs + EXYNOS5_DRD_PHYCLKRST);
-	phyclkrst &= ~(PHYCLKRST_REF_SSP_EN |
-			PHYCLKRST_SSC_EN |
-			PHYCLKRST_COMMONONN);
-	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
-
-	/* Control PHYTEST to remove leakage current */
-	phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
-	phytest |= (PHYTEST_POWERDOWN_SSP |
-			PHYTEST_POWERDOWN_HSP);
-	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
-}
-
-static int samsung_usb3phy_init(struct usb_phy *phy)
-{
-	struct samsung_usbphy *sphy;
-	unsigned long flags;
-	int ret = 0;
-
-	sphy = phy_to_sphy(phy);
-
-	/* Enable the phy clock */
-	ret = clk_prepare_enable(sphy->clk);
-	if (ret) {
-		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
-		return ret;
-	}
-
-	spin_lock_irqsave(&sphy->lock, flags);
-
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
-	/* Disable phy isolation */
-	if (sphy->drv_data->set_isolation)
-		sphy->drv_data->set_isolation(sphy, false);
-
-	/* Initialize usb phy registers */
-	sphy->drv_data->phy_enable(sphy);
-
-	spin_unlock_irqrestore(&sphy->lock, flags);
-
-	/* Disable the phy clock */
-	clk_disable_unprepare(sphy->clk);
-
-	return ret;
-}
-
-/*
- * The function passed to the usb driver for phy shutdown
- */
-static void samsung_usb3phy_shutdown(struct usb_phy *phy)
-{
-	struct samsung_usbphy *sphy;
-	unsigned long flags;
-
-	sphy = phy_to_sphy(phy);
-
-	if (clk_prepare_enable(sphy->clk)) {
-		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
-		return;
-	}
-
-	spin_lock_irqsave(&sphy->lock, flags);
-
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
-	/* De-initialize usb phy registers */
-	sphy->drv_data->phy_disable(sphy);
-
-	/* Enable phy isolation */
-	if (sphy->drv_data->set_isolation)
-		sphy->drv_data->set_isolation(sphy, true);
-
-	spin_unlock_irqrestore(&sphy->lock, flags);
-
-	clk_disable_unprepare(sphy->clk);
-}
-
-static int samsung_usb3phy_probe(struct platform_device *pdev)
-{
-	struct samsung_usbphy *sphy;
-	struct samsung_usbphy_data *pdata = dev_get_platdata(&pdev->dev);
-	struct device *dev = &pdev->dev;
-	struct resource *phy_mem;
-	void __iomem	*phy_base;
-	struct clk *clk;
-	int ret;
-
-	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	phy_base = devm_ioremap_resource(dev, phy_mem);
-	if (IS_ERR(phy_base))
-		return PTR_ERR(phy_base);
-
-	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
-	if (!sphy)
-		return -ENOMEM;
-
-	clk = devm_clk_get(dev, "usbdrd30");
-	if (IS_ERR(clk)) {
-		dev_err(dev, "Failed to get device clock\n");
-		return PTR_ERR(clk);
-	}
-
-	sphy->dev = dev;
-
-	if (dev->of_node) {
-		ret = samsung_usbphy_parse_dt(sphy);
-		if (ret < 0)
-			return ret;
-	} else {
-		if (!pdata) {
-			dev_err(dev, "no platform data specified\n");
-			return -EINVAL;
-		}
-	}
-
-	sphy->plat		= pdata;
-	sphy->regs		= phy_base;
-	sphy->clk		= clk;
-	sphy->phy.dev		= sphy->dev;
-	sphy->phy.label		= "samsung-usb3phy";
-	sphy->phy.type		= USB_PHY_TYPE_USB3;
-	sphy->phy.init		= samsung_usb3phy_init;
-	sphy->phy.shutdown	= samsung_usb3phy_shutdown;
-	sphy->drv_data		= samsung_usbphy_get_driver_data(pdev);
-
-	sphy->ref_clk_freq = samsung_usbphy_get_refclk_freq(sphy);
-	if (sphy->ref_clk_freq < 0)
-		return -EINVAL;
-
-	spin_lock_init(&sphy->lock);
-
-	platform_set_drvdata(pdev, sphy);
-
-	return usb_add_phy_dev(&sphy->phy);
-}
-
-static int samsung_usb3phy_remove(struct platform_device *pdev)
-{
-	struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
-
-	usb_remove_phy(&sphy->phy);
-
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
-	if (sphy->sysreg)
-		iounmap(sphy->sysreg);
-
-	return 0;
-}
-
-static struct samsung_usbphy_drvdata usb3phy_exynos5 = {
-	.cpu_type		= TYPE_EXYNOS5250,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
-	.set_isolation		= samsung_usbphy_set_isolation_4210,
-	.phy_enable		= samsung_exynos5_usb3phy_enable,
-	.phy_disable		= samsung_exynos5_usb3phy_disable,
-};
-
-#ifdef CONFIG_OF
-static const struct of_device_id samsung_usbphy_dt_match[] = {
-	{
-		.compatible = "samsung,exynos5250-usb3phy",
-		.data = &usb3phy_exynos5
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
-#endif
-
-static struct platform_device_id samsung_usbphy_driver_ids[] = {
-	{
-		.name		= "exynos5250-usb3phy",
-		.driver_data	= (unsigned long)&usb3phy_exynos5,
-	},
-	{},
-};
-
-MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
-
-static struct platform_driver samsung_usb3phy_driver = {
-	.probe		= samsung_usb3phy_probe,
-	.remove		= samsung_usb3phy_remove,
-	.id_table	= samsung_usbphy_driver_ids,
-	.driver		= {
-		.name	= "samsung-usb3phy",
-		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(samsung_usbphy_dt_match),
-	},
-};
-
-module_platform_driver(samsung_usb3phy_driver);
-
-MODULE_DESCRIPTION("Samsung USB 3.0 phy controller");
-MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:samsung-usb3phy");
-- 
1.7.10.4

