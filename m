Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3ANMzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:55:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60940 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3ANMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:55:45 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0a-50f4004f1eed
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        av.tikhomirov@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 2/2] usb: phy: samsung: Add PHY support for USB 3.0
 controller
Date: Mon, 14 Jan 2013 18:29:37 +0530
Message-id: <1358168377-22919-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
References: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkVtef4UuAwd4GSYvLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mr4v2cpUcDe3omv/TaYGxh9RXYycHBICJhIX
	f99lh7DFJC7cW8/WxcjFISSwlFHi7KwGZpiiW5OWsEAkFjFKbHp6GapqMpPE7Gc3warYBHQl
	mt7uYgSxRQRkJQ5f+c0MUsQssIlJYtu/FrAdwgLBEhc3TmMBsVkEVCVefeoFa+YV8JC4t/Qs
	1DoFiTe3nwHZHBycAp4S+x8XgYSFgEr+zehihmgVkPg2+RALSIkE0K5NB8BWSQg8ZpM41LyU
	BWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRGJin/z2T3sG4qsHi
	EKMAB6MSD6/Dis8BQqyJZcWVuYcYJTiYlUR4414DhXhTEiurUovy44tKc1KLDzH6AF0ykVlK
	NDkfGDV5JfGGxibmpsamlkZGZqamOISVxHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cBoLvKc
	5fnd6h1XL4mf2t19f6rbIaUtkzvO+qisL3uxN2t/zyQrwyt7g3yT35pINTBP/HKgZPtcs2Sp
	vbeMHyQKLLh7OjapRCC9yqC+OfXq0vnLn/TyhfVcmtCj63Xww/fvLxcJm0XYC7jdCz50UyVY
	7uGD2X58MknqAVc/Kz2zX9iVF+A08cIEJZbijERDLeai4kQAPt/o2HkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAV1/hi8BBps2sFtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxfclW
	poK7uRVd+28yNTD+iOpi5OSQEDCRuDVpCQuELSZx4d56ti5GLg4hgUWMEpueXoZyJjNJzH52
	kxmkik1AV6Lp7S5GEFtEQFbi8JXfzCBFzAKbmCS2/WthB0kICwRLXNw4DWwsi4CqxKtPvWDN
	vAIeEveWnmWGWKcg8eb2MyCbg4NTwFNi/+MikLAQUMm/GV3MExh5FzAyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIDvtn0jsYVzVYHGIU4GBU4uF1WPE5QIg1say4MvcQowQHs5IIb9xr
	oBBvSmJlVWpRfnxRaU5q8SFGH6CjJjJLiSbnA2MyryTe0NjE3NTY1NLEwsTMEoewkjgv46kn
	AUIC6YklqdmpqQWpRTDjmDg4pRoYF66wTbTte/Yw/tq3tTOebN1w4zRbQ8TFk2minhXmp/Mj
	s++laf2ZOoNhr3dx7O6YD7Y69i/a0hb63P/1ItH8cPX1puXxGxlmSbvwmxu+e2obmHxHmXMt
	c4OGlL2xQVyKt4pWw4Tb/cyzc7++eB9z5/s9vZ/OogZ3uTNFdmwJyi1/IZluLKGnxFKckWio
	xVxUnAgAAHnpnagCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PHY driver support for USB 3.0 controller for Samsung's
SoCs.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/Kconfig          |    8 +
 drivers/usb/phy/Makefile         |    1 +
 drivers/usb/phy/samsung-usb3.c   |  349 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.h |   81 +++++++++
 4 files changed, 439 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb3.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index fae4d08..a7b0536 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -53,3 +53,11 @@ config SAMSUNG_USBPHY
 	help
 	  Enable this to support Samsung USB phy controller for samsung
 	  SoCs.
+
+config SAMSUNG_USB3PHY
+	bool "Samsung USB 3.0 PHY controller Driver"
+	depends on USB_DWC3
+	select USB_OTG_UTILS
+	help
+	  Enable this to support Samsung USB 3.0 phy controller for samsung
+	  SoCs.
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 0f4fd4f..ed28e89 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
 obj-$(CONFIG_USB_RCAR_PHY)		+= rcar-phy.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= samsung-usbphy.o samsung-usb2.o
+obj-$(CONFIG_SAMSUNG_USB3PHY)		+= samsung-usb3.o
diff --git a/drivers/usb/phy/samsung-usb3.c b/drivers/usb/phy/samsung-usb3.c
new file mode 100644
index 0000000..8029c1b
--- /dev/null
+++ b/drivers/usb/phy/samsung-usb3.c
@@ -0,0 +1,349 @@
+/* linux/drivers/usb/phy/samsung-usb3.c
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
+static u32 samsung_usb3_phy_set_refclk(struct samsung_usbphy *sphy)
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
+static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sphy)
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
+	phyclkrst = samsung_usb3_phy_set_refclk(sphy);
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
+static void samsung_exynos5_usb3_phy_disable(struct samsung_usbphy *sphy)
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
+static int samsung_usb3_phy_init(struct usb_phy *phy)
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
+	samsung_exynos5_usb3_phy_enable(sphy);
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
+static void samsung_usb3_phy_shutdown(struct usb_phy *phy)
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
+	samsung_exynos5_usb3_phy_disable(sphy);
+
+	/* Enable phy isolation */
+	samsung_usbphy_set_isolation(sphy, true);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
+	clk_disable_unprepare(sphy->clk);
+}
+
+static int __devinit samsung_usb3_phy_probe(struct platform_device *pdev)
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
+	sphy->phy.label		= "samsung-usb3-phy";
+	sphy->phy.init		= samsung_usb3_phy_init;
+	sphy->phy.shutdown	= samsung_usb3_phy_shutdown;
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
+static int __exit samsung_usb3_phy_remove(struct platform_device *pdev)
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
+static struct samsung_usbphy_drvdata usb3_phy_exynos5 = {
+	.cpu_type		= TYPE_EXYNOS5250,
+	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id samsung_usbphy_dt_match[] = {
+	{
+		.compatible = "samsung,exynos5250-usb3-phy",
+		.data = &usb3_phy_exynos5
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
+#endif
+
+static struct platform_device_id samsung_usbphy_driver_ids[] = {
+	{
+		.name		= "exynos5250-usb3-phy",
+		.driver_data	= (unsigned long)&usb3_phy_exynos5,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
+
+static struct platform_driver samsung_usbphy_driver = {
+	.probe		= samsung_usb3_phy_probe,
+	.remove		= __devexit_p(samsung_usb3_phy_remove),
+	.id_table	= samsung_usbphy_driver_ids,
+	.driver		= {
+		.name	= "samsung-usb3-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(samsung_usbphy_dt_match),
+	},
+};
+
+module_platform_driver(samsung_usbphy_driver);
+
+MODULE_DESCRIPTION("Samsung USB 3.0 phy controller");
+MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:samsung-usb3-phy");
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

