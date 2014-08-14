Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaHNO0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:26:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63140 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHNO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:26:11 -0400
X-AuditID: cbfee61b-f79f86d00000144c-18-53ecc701a2b4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 4/5] usb: phy: samsung: remove old USB 3.0 PHY driver
Date: Thu, 14 Aug 2014 16:25:26 +0200
Message-id: <1408026327-31437-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQV3G42+CDa6e5LbYOGM9q8XB+/UW
	m65fZ7Vou3KQ3eLH6wtsFr0LrrJZXHjaw2ZxtukNu8XlXXPYLGac38dksWhZK7MDt8eda3vY
	PPq2rGL0OH5jO5PH501yASxRXDYpqTmZZalF+nYJXBlbP5cUrImpWHSthbGB8alPFyMnh4SA
	icSrXbtYIWwxiQv31rN1MXJxCAlMZ5Q41vyOFcLpYpJYPnURWBWbgJXExPZVjCC2iICaRM/i
	rYwgRcwC95kkNj88DVYkLOAqcWjGKiYQm0VAVeJN+zkWEJtXwEPizZxPUOsUJbqfTWADsTkF
	PCUOz1nGDGILAdUcPLyLfQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSH3THoH
	46oGi0OMAhyMSjy8DdvfBAuxJpYVV+YeYpTgYFYS4Z2+GyjEm5JYWZValB9fVJqTWnyIUZqD
	RUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBUf+nlMJVkeMMy9+m7nja6+I3MSNpq2WAQ5rx
	9LjrRR3PPzxkiVY3mVjlHBfBePqiZ9T0ozkcBxd92vjVUNJ2V9IExxlZpvonDFhCZcQPHZCa
	LDWj+qR+6hvVNzvWxHFpvSz4Gypw+KziocCjpW56x7K+VFSZOn2f/41r33knr9fSx6U2nYjo
	V2Ipzkg01GIuKk4EAPRWw5k1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb3 driver got replaced by
drivers/phy/phy-samsung-usb3 one and is no longer used.

Cc: Kamil Debski <k.debski@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/phy/Kconfig            |   8 -
 drivers/usb/phy/Makefile           |   1 -
 drivers/usb/phy/phy-samsung-usb3.c | 350 -------------------------------------
 3 files changed, 359 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 452e252..0cd1f44 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -78,14 +78,6 @@ config SAMSUNG_USBPHY
 	  This driver provides common interface to interact, for Samsung USB 2.0 PHY
 	  driver and later for Samsung USB 3.0 PHY driver.
 
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
index c651005..75f2bba 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
 obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_OTG)			+= phy-omap-otg.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
-obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
 obj-$(CONFIG_TWL6030_USB)		+= phy-twl6030-usb.o
 obj-$(CONFIG_USB_EHCI_TEGRA)		+= phy-tegra-usb.o
 obj-$(CONFIG_USB_GPIO_VBUS)		+= phy-gpio-vbus-usb.o
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
1.8.2.3

