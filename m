Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3AVM4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:56:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3AVM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:56:45 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-28-50fe8c8c26d1
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v8 2/4] usb: phy: samsung: Add host phy support to samsung-phy
 driver
Date: Tue, 22 Jan 2013 18:30:41 +0530
Message-id: <1358859643-5030-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
References: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSp9vT8y/AYNElYYvLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4MlZfm89ccHgvY8Wzl+9YGhgnzWTsYuTkkBAw
	kZg4+w4LhC0mceHeerYuRi4OIYGljBLnH+1ngSm6urqRCSIxnVHiyotXUM5kJolll18yg1Sx
	CehKNL3dBTZWREBW4vCV38wgRcwCf5kkHq/qZwdJCAuES3z7/BmsgUVAVWLT3sVsIDavgLtE
	+7FuJoh1ChJvbj8Dq+EU8JD4cOA0WK8QUE3rt/dg90kIPGeT6N3yhx1ikIDEt8mHgG7lAErI
	Smw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECAzP0/+eSe9g
	XNVgcYhRgINRiYf3wf2/AUKsiWXFlbmHGCU4mJVEeHXr/wUI8aYkVlalFuXHF5XmpBYfYkwG
	Wj6RWUo0OR8YO3kl8YbGJuamxqaWRkZmpqakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJg1Oq
	gTFq1wnn+Mvcb7bNazl+PPu4mo9xzFnjt85SiSKBvJsOvJ22Y4VRTvbybxIHToqFHfpvXzul
	6bT4ivVy/9vXM97z0C0rkduq8/9aqI7h5qOaC0+vcFW0yCrZfDt9ifyPx38P3pq8RYNdZrOl
	a4WokMNihruJD2/Z1uQXpBknvqyW0j/6diujQ4QSS3FGoqEWc1FxIgAI8Fd/kwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jQd2enn8BBhebGC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxYfW0+
	c8HhvYwVz16+Y2lgnDSTsYuRk0NCwETi6upGJghbTOLCvfVsXYxcHEIC0xklrrx4xQThTGaS
	WHb5JTNIFZuArkTT211g3SICshKHr/xmBiliFvjLJPF4VT87SEJYIFzi2+fPYA0sAqoSm/Yu
	ZgOxeQXcJdqPdUOtU5B4c/sZWA2ngIfEhwOnwXqFgGpav71nm8DIu4CRYRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcPA/k97BuKrB4hCjAAejEg/vg/t/A4RYE8uKK3MPMUpwMCuJ8OrW
	/wsQ4k1JrKxKLcqPLyrNSS0+xJgMdNVEZinR5HxgZOaVxBsam5ibGptamliYmFmSJqwkzst4
	6kmAkEB6YklqdmpqQWoRzBYmDk6pBsZu0Xs35i13rj2tXdOyMkHkqtG+qrpogfCrgneboxt3
	b5C0fXDJ4c7mvsSsCsFJ+gt/V1+U4wuPznhft49T4F3Yw58Hi1XM9zKKWDyaY6Nr+vrTJo/n
	f4MaZ02R/ZstL5uUkzZXuarK+8X2PwWrT5RVJz4SZD+64VT+5He6/YEGa08WsxgpBSqxFGck
	GmoxFxUnAgD603mVwgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds host phy support to samsung-usbphy driver and
further adds support for samsung's exynos5250 usb-phy.

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/samsung-usbphy.c                   |  513 ++++++++++++++++++--
 3 files changed, 496 insertions(+), 31 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 22d06cf..0331949 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -1,15 +1,23 @@
 * Samsung's usb phy transceiver
 
-The Samsung's phy transceiver is used for controlling usb otg phy for
-s3c-hsotg usb device controller.
+The Samsung's phy transceiver is used for controlling usb phy for
+s3c-hsotg as well as ehci-s5p and ohci-exynos usb controllers
+across Samsung SOCs.
 TODO: Adding the PHY binding with controller(s) according to the under
 developement generic PHY driver.
 
 Required properties:
+
+Exynos4210:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
 
+Exynos5250:
+- compatible : should be "samsung,exynos5250-usbphy"
+- reg : base physical address of the phy registers and length of memory mapped
+	region.
+
 Optional properties:
 - #address-cells: should be '1' when usbphy node has a child node with 'reg'
 		  property.
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 36a85b6..fae4d08 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -48,7 +48,7 @@ config USB_RCAR_PHY
 
 config SAMSUNG_USBPHY
 	bool "Samsung USB PHY controller Driver"
-	depends on USB_S3C_HSOTG
+	depends on USB_S3C_HSOTG || USB_EHCI_S5P || USB_OHCI_EXYNOS
 	select USB_OTG_UTILS
 	help
 	  Enable this to support Samsung USB phy controller for samsung
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 30aebb5..9e9861c 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -5,7 +5,8 @@
  *
  * Author: Praveen Paneri <p.paneri@samsung.com>
  *
- * Samsung USB2.0 High-speed OTG transceiver, talks to S3C HS OTG controller
+ * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
+ * OHCI-EXYNOS controllers.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,11 +22,13 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/usb/otg.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 /* Register definitions */
@@ -57,24 +60,132 @@
 #define RSTCON_HLINK_SWRST			(0x1 << 1)
 #define RSTCON_SWRST				(0x1 << 0)
 
+/* EXYNOS5 */
+#define EXYNOS5_PHY_HOST_CTRL0			(0x00)
+
+#define HOST_CTRL0_PHYSWRSTALL			(0x1 << 31)
+
+#define HOST_CTRL0_REFCLKSEL_MASK		(0x3 << 19)
+#define HOST_CTRL0_REFCLKSEL_XTAL		(0x0 << 19)
+#define HOST_CTRL0_REFCLKSEL_EXTL		(0x1 << 19)
+#define HOST_CTRL0_REFCLKSEL_CLKCORE		(0x2 << 19)
+
+#define HOST_CTRL0_FSEL_MASK			(0x7 << 16)
+#define HOST_CTRL0_FSEL(_x)			((_x) << 16)
+
+#define FSEL_CLKSEL_50M				(0x7)
+#define FSEL_CLKSEL_24M				(0x5)
+#define FSEL_CLKSEL_20M				(0x4)
+#define FSEL_CLKSEL_19200K			(0x3)
+#define FSEL_CLKSEL_12M				(0x2)
+#define FSEL_CLKSEL_10M				(0x1)
+#define FSEL_CLKSEL_9600K			(0x0)
+
+#define HOST_CTRL0_TESTBURNIN			(0x1 << 11)
+#define HOST_CTRL0_RETENABLE			(0x1 << 10)
+#define HOST_CTRL0_COMMONON_N			(0x1 << 9)
+#define HOST_CTRL0_SIDDQ			(0x1 << 6)
+#define HOST_CTRL0_FORCESLEEP			(0x1 << 5)
+#define HOST_CTRL0_FORCESUSPEND			(0x1 << 4)
+#define HOST_CTRL0_WORDINTERFACE		(0x1 << 3)
+#define HOST_CTRL0_UTMISWRST			(0x1 << 2)
+#define HOST_CTRL0_LINKSWRST			(0x1 << 1)
+#define HOST_CTRL0_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_TUNE0			(0x04)
+
+#define EXYNOS5_PHY_HSIC_CTRL1			(0x10)
+
+#define EXYNOS5_PHY_HSIC_TUNE1			(0x14)
+
+#define EXYNOS5_PHY_HSIC_CTRL2			(0x20)
+
+#define EXYNOS5_PHY_HSIC_TUNE2			(0x24)
+
+#define HSIC_CTRL_REFCLKSEL_MASK		(0x3 << 23)
+#define HSIC_CTRL_REFCLKSEL			(0x2 << 23)
+
+#define HSIC_CTRL_REFCLKDIV_MASK		(0x7f << 16)
+#define HSIC_CTRL_REFCLKDIV(_x)			((_x) << 16)
+#define HSIC_CTRL_REFCLKDIV_12			(0x24 << 16)
+#define HSIC_CTRL_REFCLKDIV_15			(0x1c << 16)
+#define HSIC_CTRL_REFCLKDIV_16			(0x1a << 16)
+#define HSIC_CTRL_REFCLKDIV_19_2		(0x15 << 16)
+#define HSIC_CTRL_REFCLKDIV_20			(0x14 << 16)
+
+#define HSIC_CTRL_SIDDQ				(0x1 << 6)
+#define HSIC_CTRL_FORCESLEEP			(0x1 << 5)
+#define HSIC_CTRL_FORCESUSPEND			(0x1 << 4)
+#define HSIC_CTRL_WORDINTERFACE			(0x1 << 3)
+#define HSIC_CTRL_UTMISWRST			(0x1 << 2)
+#define HSIC_CTRL_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_EHCICTRL		(0x30)
+
+#define HOST_EHCICTRL_ENAINCRXALIGN		(0x1 << 29)
+#define HOST_EHCICTRL_ENAINCR4			(0x1 << 28)
+#define HOST_EHCICTRL_ENAINCR8			(0x1 << 27)
+#define HOST_EHCICTRL_ENAINCR16			(0x1 << 26)
+
+#define EXYNOS5_PHY_HOST_OHCICTRL		(0x34)
+
+#define HOST_OHCICTRL_SUSPLGCY			(0x1 << 3)
+#define HOST_OHCICTRL_APPSTARTCLK		(0x1 << 2)
+#define HOST_OHCICTRL_CNTSEL			(0x1 << 1)
+#define HOST_OHCICTRL_CLKCKTRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_SYS			(0x38)
+
+#define OTG_SYS_PHYLINK_SWRESET			(0x1 << 14)
+#define OTG_SYS_LINKSWRST_UOTG			(0x1 << 13)
+#define OTG_SYS_PHY0_SWRST			(0x1 << 12)
+
+#define OTG_SYS_REFCLKSEL_MASK			(0x3 << 9)
+#define OTG_SYS_REFCLKSEL_XTAL			(0x0 << 9)
+#define OTG_SYS_REFCLKSEL_EXTL			(0x1 << 9)
+#define OTG_SYS_REFCLKSEL_CLKCORE		(0x2 << 9)
+
+#define OTG_SYS_IDPULLUP_UOTG			(0x1 << 8)
+#define OTG_SYS_COMMON_ON			(0x1 << 7)
+
+#define OTG_SYS_FSEL_MASK			(0x7 << 4)
+#define OTG_SYS_FSEL(_x)			((_x) << 4)
+
+#define OTG_SYS_FORCESLEEP			(0x1 << 3)
+#define OTG_SYS_OTGDISABLE			(0x1 << 2)
+#define OTG_SYS_SIDDQ_UOTG			(0x1 << 1)
+#define OTG_SYS_FORCESUSPEND			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_TUNE			(0x40)
+
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
 
+#ifndef KHZ
+#define KHZ (1000)
+#endif
+
+#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
 #define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
 #define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
+#define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
 
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
+	TYPE_EXYNOS5250,
 };
 
 /*
  * struct samsung_usbphy_drvdata - driver data for various SoC variants
  * @cpu_type: machine identifier
  * @devphy_en_mask: device phy enable mask for PHY CONTROL register
+ * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
  * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
  *		       mapped address of system controller.
+ * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
+ *		       mapped address of system controller.
  *
  *	Here we have a separate mask for device type phy.
  *	Having different masks for host and device type phy helps
@@ -87,7 +198,9 @@ enum samsung_cpu_type {
 struct samsung_usbphy_drvdata {
 	int cpu_type;
 	int devphy_en_mask;
+	int hostphy_en_mask;
 	u32 devphy_reg_offset;
+	u32 hostphy_reg_offset;
 };
 
 /*
@@ -98,8 +211,12 @@ struct samsung_usbphy_drvdata {
  * @clk: usb phy clock
  * @regs: usb phy controller registers memory base
  * @pmuregs: USB device PHY_CONTROL register memory base
+ * @sysreg: USB2.0 PHY_CFG register memory base
  * @ref_clk_freq: reference clock frequency selection
  * @drv_data: driver data available for different SoCs
+ * @phy_type: Samsung SoCs specific phy types:	#HOST
+ *						#DEVICE
+ * @phy_usage: usage count for phy
  * @lock: lock for phy operations
  */
 struct samsung_usbphy {
@@ -109,13 +226,27 @@ struct samsung_usbphy {
 	struct clk	*clk;
 	void __iomem	*regs;
 	void __iomem	*pmuregs;
+	void __iomem	*sysreg;
 	int		ref_clk_freq;
 	const struct samsung_usbphy_drvdata *drv_data;
+	enum samsung_usb_phy_type phy_type;
+	atomic_t	phy_usage;
 	spinlock_t	lock;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
 
+int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
+{
+	if (!otg)
+		return -ENODEV;
+
+	if (!otg->host)
+		otg->host = host;
+
+	return 0;
+}
+
 static int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 {
 	struct device_node *usbphy_sys;
@@ -129,14 +260,27 @@ static int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 
 	sphy->pmuregs = of_iomap(usbphy_sys, 0);
 
-	of_node_put(usbphy_sys);
-
 	if (sphy->pmuregs == NULL) {
 		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
-		return -ENODEV;
+		goto err0;
 	}
 
+	sphy->sysreg = of_iomap(usbphy_sys, 1);
+
+	/*
+	 * Not returning error code here, since this situation is not fatal.
+	 * Few SoCs may not have this switch available
+	 */
+	if (sphy->sysreg == NULL)
+		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
+
+	of_node_put(usbphy_sys);
+
 	return 0;
+
+err0:
+	of_node_put(usbphy_sys);
+	return -ENXIO;
 }
 
 /*
@@ -146,17 +290,42 @@ static int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
  */
 static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
 {
-	void __iomem *reg;
+	void __iomem *reg = NULL;
 	u32 reg_val;
-	u32 en_mask;
+	u32 en_mask = 0;
 
 	if (!sphy->pmuregs) {
 		dev_warn(sphy->dev, "Can't set pmu isolation\n");
 		return;
 	}
 
-	reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
-	en_mask = sphy->drv_data->devphy_en_mask;
+	switch (sphy->drv_data->cpu_type) {
+	case TYPE_S3C64XX:
+		/*
+		 * Do nothing: We will add here once S3C64xx goes for DT support
+		 */
+		break;
+	case TYPE_EXYNOS4210:
+		/*
+		 * Fall through since exynos4210 and exynos5250 have similar
+		 * register architecture: two separate registers for host and
+		 * device phy control with enable bit at position 0.
+		 */
+	case TYPE_EXYNOS5250:
+		if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
+			reg = sphy->pmuregs +
+				sphy->drv_data->devphy_reg_offset;
+			en_mask = sphy->drv_data->devphy_en_mask;
+		} else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
+			reg = sphy->pmuregs +
+				sphy->drv_data->hostphy_reg_offset;
+			en_mask = sphy->drv_data->hostphy_en_mask;
+		}
+		break;
+	default:
+		dev_err(sphy->dev, "Invalid SoC type\n");
+		return;
+	}
 
 	reg_val = readl(reg);
 
@@ -169,6 +338,43 @@ static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
 }
 
 /*
+ * Configure the mode of working of usb-phy here: HOST/DEVICE.
+ */
+static void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
+{
+	u32 reg;
+
+	if (!sphy->sysreg) {
+		dev_warn(sphy->dev, "Can't configure specified phy mode\n");
+		return;
+	}
+
+	reg = readl(sphy->sysreg);
+
+	if (sphy->phy_type == USB_PHY_TYPE_DEVICE)
+		reg &= ~EXYNOS_USB20PHY_CFG_HOST_LINK;
+	else if (sphy->phy_type == USB_PHY_TYPE_HOST)
+		reg |= EXYNOS_USB20PHY_CFG_HOST_LINK;
+
+	writel(reg, sphy->sysreg);
+}
+
+/*
+ * PHYs are different for USB Device and USB Host.
+ * This make sure that correct PHY type is selected before
+ * any operation on PHY.
+ */
+static int samsung_usbphy_set_type(struct usb_phy *phy,
+				enum samsung_usb_phy_type phy_type)
+{
+	struct samsung_usbphy *sphy = phy_to_sphy(phy);
+
+	sphy->phy_type = phy_type;
+
+	return 0;
+}
+
+/*
  * Returns reference clock frequency selection value
  */
 static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
@@ -176,34 +382,185 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 	struct clk *ref_clk;
 	int refclk_freq = 0;
 
-	ref_clk = clk_get(sphy->dev, "xusbxti");
+	/*
+	 * In exynos5250 USB host and device PHY use
+	 * external crystal clock XXTI
+	 */
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
+		ref_clk = clk_get(sphy->dev, "ext_xtal");
+	else
+		ref_clk = clk_get(sphy->dev, "xusbxti");
 	if (IS_ERR(ref_clk)) {
 		dev_err(sphy->dev, "Failed to get reference clock\n");
 		return PTR_ERR(ref_clk);
 	}
 
-	switch (clk_get_rate(ref_clk)) {
-	case 12 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_12M;
-		break;
-	case 24 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_24M;
-		break;
-	case 48 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_48M;
-		break;
-	default:
-		if (sphy->drv_data->cpu_type == TYPE_S3C64XX)
-			refclk_freq = PHYCLK_CLKSEL_48M;
-		else
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250) {
+		/* set clock frequency for PLL */
+		switch (clk_get_rate(ref_clk)) {
+		case 9600 * KHZ:
+			refclk_freq = FSEL_CLKSEL_9600K;
+			break;
+		case 10 * MHZ:
+			refclk_freq = FSEL_CLKSEL_10M;
+			break;
+		case 12 * MHZ:
+			refclk_freq = FSEL_CLKSEL_12M;
+			break;
+		case 19200 * KHZ:
+			refclk_freq = FSEL_CLKSEL_19200K;
+			break;
+		case 20 * MHZ:
+			refclk_freq = FSEL_CLKSEL_20M;
+			break;
+		case 50 * MHZ:
+			refclk_freq = FSEL_CLKSEL_50M;
+			break;
+		case 24 * MHZ:
+		default:
+			/* default reference clock */
+			refclk_freq = FSEL_CLKSEL_24M;
+			break;
+		}
+	} else {
+		switch (clk_get_rate(ref_clk)) {
+		case 12 * MHZ:
+			refclk_freq = PHYCLK_CLKSEL_12M;
+			break;
+		case 24 * MHZ:
 			refclk_freq = PHYCLK_CLKSEL_24M;
-		break;
+			break;
+		case 48 * MHZ:
+			refclk_freq = PHYCLK_CLKSEL_48M;
+			break;
+		default:
+			if (sphy->drv_data->cpu_type == TYPE_S3C64XX)
+				refclk_freq = PHYCLK_CLKSEL_48M;
+			else
+				refclk_freq = PHYCLK_CLKSEL_24M;
+			break;
+		}
 	}
 	clk_put(ref_clk);
 
 	return refclk_freq;
 }
 
+static bool exynos5_phyhost_is_on(void *regs)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	return !(reg & HOST_CTRL0_SIDDQ);
+}
+
+static void samsung_exynos5_usbphy_enable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyclk = sphy->ref_clk_freq;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+	u32 ehcictrl;
+	u32 ohcictrl;
+
+	/*
+	 * phy_usage helps in keeping usage count for phy
+	 * so that the first consumer enabling the phy is also
+	 * the last consumer to disable it.
+	 */
+
+	atomic_inc(&sphy->phy_usage);
+
+	if (exynos5_phyhost_is_on(regs)) {
+		dev_info(sphy->dev, "Already power on PHY\n");
+		return;
+	}
+
+	/* Host configuration */
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* phy reference clock configuration */
+	phyhost &= ~HOST_CTRL0_FSEL_MASK;
+	phyhost |= HOST_CTRL0_FSEL(phyclk);
+
+	/* host phy reset */
+	phyhost &= ~(HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL |
+			HOST_CTRL0_SIDDQ |
+			/* Enable normal mode of operation */
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP);
+
+	/* Link reset */
+	phyhost |= (HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST |
+			/* COMMON Block configuration during suspend */
+			HOST_CTRL0_COMMONON_N);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+	udelay(10);
+	phyhost &= ~(HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* OTG configuration */
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* phy reference clock configuration */
+	phyotg &= ~OTG_SYS_FSEL_MASK;
+	phyotg |= OTG_SYS_FSEL(phyclk);
+
+	/* Enable normal mode of operation */
+	phyotg &= ~(OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP |
+			OTG_SYS_REFCLKSEL_MASK |
+			/* COMMON Block configuration during suspend */
+			OTG_SYS_COMMON_ON);
+
+	/* OTG phy & link reset */
+	phyotg |= (OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET |
+			OTG_SYS_OTGDISABLE |
+			/* Set phy refclk */
+			OTG_SYS_REFCLKSEL_CLKCORE);
+
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+	udelay(10);
+	phyotg &= ~(OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* HSIC phy configuration */
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_PHYSWRST);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+	udelay(10);
+	phyhsic &= ~HSIC_CTRL_PHYSWRST;
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	udelay(80);
+
+	/* enable EHCI DMA burst */
+	ehcictrl = readl(regs + EXYNOS5_PHY_HOST_EHCICTRL);
+	ehcictrl |= (HOST_EHCICTRL_ENAINCRXALIGN |
+				HOST_EHCICTRL_ENAINCR4 |
+				HOST_EHCICTRL_ENAINCR8 |
+				HOST_EHCICTRL_ENAINCR16);
+	writel(ehcictrl, regs + EXYNOS5_PHY_HOST_EHCICTRL);
+
+	/* set ohci_suspend_on_n */
+	ohcictrl = readl(regs + EXYNOS5_PHY_HOST_OHCICTRL);
+	ohcictrl |= HOST_OHCICTRL_SUSPLGCY;
+	writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
+}
+
 static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -239,6 +596,41 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 }
 
+static void samsung_exynos5_usbphy_disable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+
+	if (atomic_dec_return(&sphy->phy_usage) > 0) {
+		dev_info(sphy->dev, "still being used\n");
+		return;
+	}
+
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_SIDDQ |
+			HSIC_CTRL_FORCESLEEP |
+			HSIC_CTRL_FORCESUSPEND);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+	phyhost |= (HOST_CTRL0_SIDDQ |
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP |
+			HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+	phyotg |= (OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+}
+
 static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -266,11 +658,14 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 static int samsung_usbphy_init(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
+	struct usb_bus *host = NULL;
 	unsigned long flags;
 	int ret = 0;
 
 	sphy = phy_to_sphy(phy);
 
+	host = phy->otg->host;
+
 	/* Enable the phy clock */
 	ret = clk_prepare_enable(sphy->clk);
 	if (ret) {
@@ -280,19 +675,35 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
+	if (host) {
+		/* setting default phy-type for USB 2.0 */
+		if (!strstr(dev_name(host->controller), "ehci") ||
+				!strstr(dev_name(host->controller), "ohci"))
+			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+	} else {
+		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+	}
+
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
 	else
 		samsung_usbphy_set_isolation(sphy, false);
 
+	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
+	samsung_usbphy_cfg_sel(sphy);
+
 	/* Initialize usb phy registers */
-	samsung_usbphy_enable(sphy);
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usbphy_enable(sphy);
+	else
+		samsung_usbphy_enable(sphy);
 
 	spin_unlock_irqrestore(&sphy->lock, flags);
 
 	/* Disable the phy clock */
 	clk_disable_unprepare(sphy->clk);
+
 	return ret;
 }
 
@@ -302,10 +713,13 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 static void samsung_usbphy_shutdown(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
+	struct usb_bus *host = NULL;
 	unsigned long flags;
 
 	sphy = phy_to_sphy(phy);
 
+	host = phy->otg->host;
+
 	if (clk_prepare_enable(sphy->clk)) {
 		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
 		return;
@@ -313,8 +727,20 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
+	if (host) {
+		/* setting default phy-type for USB 2.0 */
+		if (!strstr(dev_name(host->controller), "ehci") ||
+				!strstr(dev_name(host->controller), "ohci"))
+			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+	} else {
+		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+	}
+
 	/* De-initialize usb phy registers */
-	samsung_usbphy_disable(sphy);
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usbphy_disable(sphy);
+	else
+		samsung_usbphy_disable(sphy);
 
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
@@ -346,7 +772,9 @@ static inline const struct samsung_usbphy_drvdata
 static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
+	struct usb_otg *otg;
 	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
+	const struct samsung_usbphy_drvdata *drv_data;
 	struct device *dev = &pdev->dev;
 	struct resource *phy_mem;
 	void __iomem	*phy_base;
@@ -369,7 +797,17 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	if (!sphy)
 		return -ENOMEM;
 
-	clk = devm_clk_get(dev, "otg");
+	otg = devm_kzalloc(dev, sizeof(*otg), GFP_KERNEL);
+	if (!otg)
+		return -ENOMEM;
+
+	drv_data = samsung_usbphy_get_driver_data(pdev);
+
+	if (drv_data->cpu_type == TYPE_EXYNOS5250)
+		clk = devm_clk_get(dev, "usbhost");
+	else
+		clk = devm_clk_get(dev, "otg");
+
 	if (IS_ERR(clk)) {
 		dev_err(dev, "Failed to get otg clock\n");
 		return PTR_ERR(clk);
@@ -391,13 +829,17 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	sphy->plat		= pdata;
 	sphy->regs		= phy_base;
 	sphy->clk		= clk;
+	sphy->drv_data		= drv_data;
 	sphy->phy.dev		= sphy->dev;
 	sphy->phy.label		= "samsung-usbphy";
 	sphy->phy.init		= samsung_usbphy_init;
 	sphy->phy.shutdown	= samsung_usbphy_shutdown;
-	sphy->drv_data		= samsung_usbphy_get_driver_data(pdev);
 	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
 
+	sphy->phy.otg		= otg;
+	sphy->phy.otg->phy	= &sphy->phy;
+	sphy->phy.otg->set_host = samsung_usbphy_set_host;
+
 	spin_lock_init(&sphy->lock);
 
 	platform_set_drvdata(pdev, sphy);
@@ -413,6 +855,8 @@ static int __exit samsung_usbphy_remove(struct platform_device *pdev)
 
 	if (sphy->pmuregs)
 		iounmap(sphy->pmuregs);
+	if (sphy->sysreg)
+		iounmap(sphy->sysreg);
 
 	return 0;
 }
@@ -425,6 +869,13 @@ static const struct samsung_usbphy_drvdata usbphy_s3c64xx = {
 static const struct samsung_usbphy_drvdata usbphy_exynos4 = {
 	.cpu_type		= TYPE_EXYNOS4210,
 	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+};
+
+static struct samsung_usbphy_drvdata usbphy_exynos5 = {
+	.cpu_type		= TYPE_EXYNOS5250,
+	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
 };
 
 #ifdef CONFIG_OF
@@ -435,6 +886,9 @@ static const struct of_device_id samsung_usbphy_dt_match[] = {
 	}, {
 		.compatible = "samsung,exynos4210-usbphy",
 		.data = &usbphy_exynos4,
+	}, {
+		.compatible = "samsung,exynos5250-usbphy",
+		.data = &usbphy_exynos5
 	},
 	{},
 };
@@ -448,6 +902,9 @@ static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	}, {
 		.name		= "exynos4210-usbphy",
 		.driver_data	= (unsigned long)&usbphy_exynos4,
+	}, {
+		.name		= "exynos5250-usbphy",
+		.driver_data	= (unsigned long)&usbphy_exynos5,
 	},
 	{},
 };
-- 
1.7.6.5

