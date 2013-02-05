Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3BEMlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:41:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3BEMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:41:13 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-cd-5110fde70479
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v5 2/2] usb: phy: samsung: Add PHY support for USB 3.0
 controller
Date: Tue, 05 Feb 2013 18:14:16 +0530
Message-id: <1360068256-19602-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
References: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkTvf5X4FAgysHrC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyph2dx9rwYK8ilOr/jM1MK6M7mLk5JAQMJG4
	MfsZK4QtJnHh3nq2LkYuDiGBpYwSe89sY4UpurfwFSNEYhGjxIN3HSwQzmQmidUnbrGDVLEJ
	6Eo0vd3FCGKLCMhKHL7ymxmkiFngEZPEl33PWUASwgLBEneWfGECsVkEVCV+9P8Ea+AV8JC4
	//4xI8Q6BYk3t58BNXNwcAp4Spxp8wcJCwGVTHq5Beqi52wSP69mQowRkPg2+RALSLkE0N5N
	B5ghSiQlDq64wTKBUXgBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjMCwPP3vmfQOxlUN
	FocYBTgYlXh4f1zmDxRiTSwrrsw9xCjBwawkwlv9RSBQiDclsbIqtSg/vqg0J7X4EGMy0PKJ
	zFKiyfnAmMkriTc0NjE3NTa1NDIyMzUlTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYx6
	SvvfKFu+is5J+vZs9oe582a++GawYFOhxve2v1tYl+qGrPScuuRhSucXeasze73vfGJKtSnn
	MzmUnryuQvu/1ZmpLL3vg0Rt0g88mtVVt+LdEXOOnDdLFcsO60/ZtaFls0ATN/uuymn/dP61
	7Ji0Z0u5gHjLZ/EE5XPxZhPuck3wrN5pVT5ZiaU4I9FQi7moOBEAn4Lj+Y8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd3nfwUCDXpnqVtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx7e4+
	1oIFeRWnVv1namBcGd3FyMkhIWAicW/hK0YIW0ziwr31bF2MXBxCAosYJR6862CBcCYzSaw+
	cYsdpIpNQFei6e0usA4RAVmJw1d+M4MUMQs8YpL4su85C0hCWCBY4s6SL0wgNouAqsSP/p9g
	DbwCHhL33z+GWqcg8eb2M6BmDg5OAU+JM23+IGEhoJJJL7ewTmDkXcDIsIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOOyfSe9gXNVgcYhRgINRiYf3x2X+QCHWxLLiytxDjBIczEoivNVf
	BAKFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR8Yk3kl8YbGJuamxqaWJhYmZpakCSuJ8zKe
	ehIgJJCeWJKanZpakFoEs4WJg1OqgVGzY9epNOUZKnXnPi3ytIgUKvug/ixGpK4l0q93j+AU
	fnd3WaarP+fYBf4UOpculLQo7v71V44603aeVFubl1bh8UZm97VvzyX+201YtMhkytoz64QK
	rc9FfX5xcMX8Wefm3pvnLhK0gk2mTCBBK2/BjAqOCx9u+G+tWeP4ibWzknvSU1a2gHolluKM
	REMt5qLiRABXCvTmvwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PHY driver support for USB 3.0 controller for Samsung's
SoCs.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/Kconfig           |    8 +
 drivers/usb/phy/Makefile          |    1 +
 drivers/usb/phy/samsung-usb3phy.c |  349 +++++++++++++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.h  |   81 +++++++++
 4 files changed, 439 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb3phy.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index b28878d..723d7b1 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -74,6 +74,14 @@ config SAMSUNG_USB2PHY
 	  Enable this to support Samsung USB 2.0 (High Speed) PHY controller
 	  driver for Samsung SoCs.
 
+config SAMSUNG_USB3PHY
+	bool "Samsung USB 3.0 PHY controller Driver"
+	select SAMSUNG_USBPHY
+	select USB_OTG_UTILS
+	help
+	  Enable this to support Samsung USB 3.0 (Super Speed) phy controller
+	  for samsung SoCs.
+
 config SAMSUNG_USBPHY
 	bool "Samsung USB PHY Driver"
 	help
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 1efa174..77f0b2e 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
 obj-$(CONFIG_USB_RCAR_PHY)		+= rcar-phy.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= samsung-usbphy.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= samsung-usb2phy.o
+obj-$(CONFIG_SAMSUNG_USB3PHY)		+= samsung-usb3phy.o
diff --git a/drivers/usb/phy/samsung-usb3phy.c b/drivers/usb/phy/samsung-usb3phy.c
new file mode 100644
index 0000000..70e2c7b
--- /dev/null
+++ b/drivers/usb/phy/samsung-usb3phy.c
@@ -0,0 +1,349 @@
+/* linux/drivers/usb/phy/samsung-usb3phy.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Vivek Gautam <gautam.vivek@samsung.com>
+ *
+ * Samsung USB 3.0 PHY transceiver; talks to DWC3 controller.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/usb/samsung_usb_phy.h>
+#include <linux/platform_data/samsung-usbphy.h>
+
+#include "samsung-usbphy.h"
+
+/*
+ * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
+ */
+static u32 samsung_usb3phy_set_refclk(struct samsung_usbphy *sphy)
+{
+	u32 reg;
+	u32 refclk;
+
+	refclk = sphy->ref_clk_freq;
+
+	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
+		PHYCLKRST_FSEL(refclk);
+
+	switch (refclk) {
+	case FSEL_CLKSEL_50M:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case FSEL_CLKSEL_20M:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case FSEL_CLKSEL_19200K:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	case FSEL_CLKSEL_24M:
+	default:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	}
+
+	return reg;
+}
+
+static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyparam0;
+	u32 phyparam1;
+	u32 linksystem;
+	u32 phybatchg;
+	u32 phytest;
+	u32 phyclkrst;
+
+	/* Reset USB 3.0 PHY */
+	writel(0x0, regs + EXYNOS5_DRD_PHYREG0);
+
+	phyparam0 = readl(regs + EXYNOS5_DRD_PHYPARAM0);
+	/* Select PHY CLK source */
+	phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
+	/* Set Loss-of-Signal Detector sensitivity */
+	phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
+	phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
+	writel(phyparam0, regs + EXYNOS5_DRD_PHYPARAM0);
+
+	writel(0x0, regs + EXYNOS5_DRD_PHYRESUME);
+
+	/*
+	 * Setting the Frame length Adj value[6:1] to default 0x20
+	 * See xHCI 1.0 spec, 5.2.4
+	 */
+	linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
+			LINKSYSTEM_FLADJ(0x20);
+	writel(linksystem, regs + EXYNOS5_DRD_LINKSYSTEM);
+
+	phyparam1 = readl(regs + EXYNOS5_DRD_PHYPARAM1);
+	/* Set Tx De-Emphasis level */
+	phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
+	phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
+	writel(phyparam1, regs + EXYNOS5_DRD_PHYPARAM1);
+
+	phybatchg = readl(regs + EXYNOS5_DRD_PHYBATCHG);
+	phybatchg |= PHYBATCHG_UTMI_CLKSEL;
+	writel(phybatchg, regs + EXYNOS5_DRD_PHYBATCHG);
+
+	/* PHYTEST POWERDOWN Control */
+	phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
+	phytest &= ~(PHYTEST_POWERDOWN_SSP |
+			PHYTEST_POWERDOWN_HSP);
+	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
+
+	/* UTMI Power Control */
+	writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
+
+	phyclkrst = samsung_usb3phy_set_refclk(sphy);
+
+	phyclkrst |= PHYCLKRST_PORTRESET |
+			/* Digital power supply in normal operating mode */
+			PHYCLKRST_RETENABLEN |
+			/* Enable ref clock for SS function */
+			PHYCLKRST_REF_SSP_EN |
+			/* Enable spread spectrum */
+			PHYCLKRST_SSC_EN |
+			/* Power down HS Bias and PLL blocks in suspend mode */
+			PHYCLKRST_COMMONONN;
+
+	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
+
+	udelay(10);
+
+	phyclkrst &= ~(PHYCLKRST_PORTRESET);
+	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
+
+	return 0;
+}
+
+static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
+{
+	u32 phyutmi;
+	u32 phyclkrst;
+	u32 phytest;
+	void __iomem *regs = sphy->regs;
+
+	phyutmi = PHYUTMI_OTGDISABLE |
+			PHYUTMI_FORCESUSPEND |
+			PHYUTMI_FORCESLEEP;
+	writel(phyutmi, regs + EXYNOS5_DRD_PHYUTMI);
+
+	/* Resetting the PHYCLKRST enable bits to reduce leakage current */
+	phyclkrst = readl(regs + EXYNOS5_DRD_PHYCLKRST);
+	phyclkrst &= ~(PHYCLKRST_REF_SSP_EN |
+			PHYCLKRST_SSC_EN |
+			PHYCLKRST_COMMONONN);
+	writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
+
+	/* Control PHYTEST to remove leakage current */
+	phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
+	phytest |= (PHYTEST_POWERDOWN_SSP |
+			PHYTEST_POWERDOWN_HSP);
+	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
+}
+
+static int samsung_usb3phy_init(struct usb_phy *phy)
+{
+	struct samsung_usbphy *sphy;
+	unsigned long flags;
+	int ret = 0;
+
+	sphy = phy_to_sphy(phy);
+
+	/* Enable the phy clock */
+	ret = clk_prepare_enable(sphy->clk);
+	if (ret) {
+		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
+		return ret;
+	}
+
+	spin_lock_irqsave(&sphy->lock, flags);
+
+	/* setting default phy-type for USB 3.0 */
+	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+
+	/* Disable phy isolation */
+	samsung_usbphy_set_isolation(sphy, false);
+
+	/* Initialize usb phy registers */
+	samsung_exynos5_usb3phy_enable(sphy);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
+	/* Disable the phy clock */
+	clk_disable_unprepare(sphy->clk);
+
+	return ret;
+}
+
+/*
+ * The function passed to the usb driver for phy shutdown
+ */
+static void samsung_usb3phy_shutdown(struct usb_phy *phy)
+{
+	struct samsung_usbphy *sphy;
+	unsigned long flags;
+
+	sphy = phy_to_sphy(phy);
+
+	if (clk_prepare_enable(sphy->clk)) {
+		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&sphy->lock, flags);
+
+	/* setting default phy-type for USB 3.0 */
+	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+
+	/* De-initialize usb phy registers */
+	samsung_exynos5_usb3phy_disable(sphy);
+
+	/* Enable phy isolation */
+	samsung_usbphy_set_isolation(sphy, true);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
+	clk_disable_unprepare(sphy->clk);
+}
+
+static int samsung_usb3phy_probe(struct platform_device *pdev)
+{
+	struct samsung_usbphy *sphy;
+	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct resource *phy_mem;
+	void __iomem	*phy_base;
+	struct clk *clk;
+	int ret;
+
+	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!phy_mem) {
+		dev_err(dev, "%s: missing mem resource\n", __func__);
+		return -ENODEV;
+	}
+
+	phy_base = devm_request_and_ioremap(dev, phy_mem);
+	if (!phy_base) {
+		dev_err(dev, "%s: register mapping failed\n", __func__);
+		return -ENXIO;
+	}
+
+	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
+	if (!sphy)
+		return -ENOMEM;
+
+	clk = devm_clk_get(dev, "usbdrd30");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to get device clock\n");
+		return PTR_ERR(clk);
+	}
+
+	sphy->dev = dev;
+
+	if (dev->of_node) {
+		ret = samsung_usbphy_parse_dt(sphy);
+		if (ret < 0)
+			return ret;
+	} else {
+		if (!pdata) {
+			dev_err(dev, "no platform data specified\n");
+			return -EINVAL;
+		}
+	}
+
+	sphy->plat		= pdata;
+	sphy->regs		= phy_base;
+	sphy->clk		= clk;
+	sphy->phy.dev		= sphy->dev;
+	sphy->phy.label		= "samsung-usb3phy";
+	sphy->phy.init		= samsung_usb3phy_init;
+	sphy->phy.shutdown	= samsung_usb3phy_shutdown;
+	sphy->drv_data		= samsung_usbphy_get_driver_data(pdev);
+	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
+
+	spin_lock_init(&sphy->lock);
+
+	platform_set_drvdata(pdev, sphy);
+
+	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB3);
+}
+
+static int samsung_usb3phy_remove(struct platform_device *pdev)
+{
+	struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&sphy->phy);
+
+	if (sphy->pmuregs)
+		iounmap(sphy->pmuregs);
+	if (sphy->sysreg)
+		iounmap(sphy->sysreg);
+
+	return 0;
+}
+
+static struct samsung_usbphy_drvdata usb3phy_exynos5 = {
+	.cpu_type		= TYPE_EXYNOS5250,
+	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id samsung_usbphy_dt_match[] = {
+	{
+		.compatible = "samsung,exynos5250-usb3phy",
+		.data = &usb3phy_exynos5
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
+#endif
+
+static struct platform_device_id samsung_usbphy_driver_ids[] = {
+	{
+		.name		= "exynos5250-usb3phy",
+		.driver_data	= (unsigned long)&usb3phy_exynos5,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
+
+static struct platform_driver samsung_usb3phy_driver = {
+	.probe		= samsung_usb3phy_probe,
+	.remove		= samsung_usb3phy_remove,
+	.id_table	= samsung_usbphy_driver_ids,
+	.driver		= {
+		.name	= "samsung-usb3phy",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(samsung_usbphy_dt_match),
+	},
+};
+
+module_platform_driver(samsung_usb3phy_driver);
+
+MODULE_DESCRIPTION("Samsung USB 3.0 phy controller");
+MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:samsung-usb3phy");
diff --git a/drivers/usb/phy/samsung-usbphy.h b/drivers/usb/phy/samsung-usbphy.h
index 969632b..f7e657d 100644
--- a/drivers/usb/phy/samsung-usbphy.h
+++ b/drivers/usb/phy/samsung-usbphy.h
@@ -145,6 +145,87 @@
 
 #define EXYNOS5_PHY_OTG_TUNE			(0x40)
 
+/* EXYNOS5: USB 3.0 DRD */
+#define EXYNOS5_DRD_LINKSYSTEM			(0x04)
+
+#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
+#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
+#define LINKSYSTEM_XHCI_VERSION_CONTROL		(0x1 << 27)
+
+#define EXYNOS5_DRD_PHYUTMI			(0x08)
+
+#define PHYUTMI_OTGDISABLE			(0x1 << 6)
+#define PHYUTMI_FORCESUSPEND			(0x1 << 1)
+#define PHYUTMI_FORCESLEEP			(0x1 << 0)
+
+#define EXYNOS5_DRD_PHYPIPE			(0x0c)
+
+#define EXYNOS5_DRD_PHYCLKRST			(0x10)
+
+#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
+#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
+
+#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
+#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
+
+#define PHYCLKRST_SSC_EN			(0x1 << 20)
+#define PHYCLKRST_REF_SSP_EN			(0x1 << 19)
+#define PHYCLKRST_REF_CLKDIV2			(0x1 << 18)
+
+#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x02 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
+
+#define PHYCLKRST_FSEL_MASK			(0x3f << 5)
+#define PHYCLKRST_FSEL(_x)			((_x) << 5)
+#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
+#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
+#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
+#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
+
+#define PHYCLKRST_RETENABLEN			(0x1 << 4)
+
+#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
+#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
+#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
+
+#define PHYCLKRST_PORTRESET			(0x1 << 1)
+#define PHYCLKRST_COMMONONN			(0x1 << 0)
+
+#define EXYNOS5_DRD_PHYREG0			(0x14)
+#define EXYNOS5_DRD_PHYREG1			(0x18)
+
+#define EXYNOS5_DRD_PHYPARAM0			(0x1c)
+
+#define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
+#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
+#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
+
+#define EXYNOS5_DRD_PHYPARAM1			(0x20)
+
+#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
+#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
+
+#define EXYNOS5_DRD_PHYTERM			(0x24)
+
+#define EXYNOS5_DRD_PHYTEST			(0x28)
+
+#define PHYTEST_POWERDOWN_SSP			(0x1 << 3)
+#define PHYTEST_POWERDOWN_HSP			(0x1 << 2)
+
+#define EXYNOS5_DRD_PHYADP			(0x2c)
+
+#define EXYNOS5_DRD_PHYBATCHG			(0x30)
+
+#define PHYBATCHG_UTMI_CLKSEL			(0x1 << 2)
+
+#define EXYNOS5_DRD_PHYRESUME			(0x34)
+#define EXYNOS5_DRD_LINKPORT			(0x44)
+
+
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
-- 
1.7.6.5

