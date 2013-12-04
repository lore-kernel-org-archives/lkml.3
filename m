Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3LDKNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:13:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59778 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab3LDKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:09:50 -0500
X-AuditID: cbfee690-b7f676d00000310d-d8-529eff6b9bf1
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, t.figa@samsung.com, jwerner@chromium.org,
        k.debski@samsung.com
Subject: [PATCH v2 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Wed, 04 Dec 2013 15:39:04 +0530
Message-id: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkRjfn/7wgg4MnWC0O3q+3ODD7IatF
	8+L1bBaXF15iteg49JjJ4sfrC2wWvQuusllceNrDZrGwbQmLxeVdc9gsZpzfx2SxaFkrs8Xh
	FQeYLA6/aWe1WD/jNYsDv8eCz1fYPWY3XGTx2D93DbvH+RkLGT36tqxi9Dh+YzuTx+dNcgHs
	UVw2Kak5mWWpRfp2CVwZEzd3Mxf87GSqmDDrPVsD46JbjF2MnBwSAiYSM/5vZoKwxSQu3FvP
	1sXIxSEksJRRYvG+FmaYopkzfkAlpjNKrNxziBHCmcIksfZkB9goNgFdiaa3u8BsEYF0if93
	+8FsZoGZTBJTNkuC2MIC9hIPJ60BW8cioCoxp62bFcTmFXCXWLz9IAvENgWJN7efgW3mFPCQ
	WLlxAtgcIaCaXS9fMIMslhB4xC5x+8QBqEECEt8mHwJq5gBKyEpsOgB1taTEwRU3WCYwCi9g
	ZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERhPp/89m7CD8d4B60OMyUDjJjJLiSbnA+Mx
	ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYzW6J
	/rk+M//D5ow37yzlpvpee8Qczd0rNGuitcyJ305/VgvyssUzRbw8sN87/5TJ+ytvXpbxrRVf
	Fj5bI7PEdeqLl3WWB9vLw79IX7Xe5bEid88spQVRtTWs/GJZlWf0bPSV/hbPvmasyGX5sPzP
	m2rTG1KXP4hazlTr/W2/J5ZTh/VN9Y0IJZbijERDLeai4kQACrIw370CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoG72/3lBBrd3GVkcvF9vcWD2Q1aL
	5sXr2SwuL7zEatFx6DGTxY/XF9gsehdcZbO48LSHzWJh2xIWi8u75rBZzDi/j8li0bJWZovD
	Kw4wWRx+085qsX7GaxYHfo8Fn6+we8xuuMjisX/uGnaP8zMWMnr0bVnF6HH8xnYmj8+b5ALY
	oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
	KEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZkzc3M1c8LOTqWLCrPdsDYyL
	bjF2MXJySAiYSMyc8YMNwhaTuHBvPZDNxSEkMJ1RYuWeQ4wQzhQmibUnO8A62AR0JZre7gKz
	RQTSJf7f7QezmQVmMklM2SwJYgsL2Es8nLSGCcRmEVCVmNPWzQpi8wq4SyzefpAFYpuCxJvb
	z5hBbE4BD4mVGyeAzRECqtn18gXzBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	o/WZ1A7GlQ0WhxgFOBiVeHgTOOcFCbEmlhVX5h5ilOBgVhLhzfwDFOJNSaysSi3Kjy8qzUkt
	PsSYDHTVRGYp0eR8YCLJK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwW
	Jg5OqQbGqa+ncf8suqQ4T8hKOvn+vZXPE/xX7bq86amNcIG698T9WfOSbbkOcu3pZnfYnd92
	Lyah9/PDaKGGorT5iye2HRd72xv0z2Uaj6fAsa3iS5tFD80vEedV+/N9rbJ/HEevmItBMnen
	rx/L1vc+Pztv7zDytHl0ki3mA4erd/y30sCruoWtVzYqsRRnJBpqMRcVJwIAhVAQzBoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
The new driver uses the generic PHY framework and will interact
with DWC3 controller present on Exynos5 series of SoCs.
Thereby, removing old phy-samsung-usb3 driver and related code
used untill now which was based on usb/phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |   43 ++
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usb3.c                     |  545 ++++++++++++++++++++
 drivers/usb/phy/Kconfig                            |   10 +-
 drivers/usb/phy/Makefile                           |    1 -
 drivers/usb/phy/phy-samsung-usb.h                  |   80 ---
 drivers/usb/phy/phy-samsung-usb3.c                 |  350 -------------
 8 files changed, 598 insertions(+), 440 deletions(-)
 create mode 100644 drivers/phy/phy-exynos5-usb3.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index c0fccaa..bcd95dd 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -20,3 +20,46 @@ Required properties:
 - compatible : should be "samsung,exynos5250-dp-video-phy";
 - reg : offset and length of the Display Port PHY register set;
 - #phy-cells : from the generic PHY bindings, must be 0;
+
+Samsung Exynos5 SoC series USB 3.0 PHY controller
+--------------------------------------------------
+
+Required properties:
+- compatible : Should be set to one of the following supported values:
+	- "samsung,exynos5250-usb3phy" - for exynos5250 SoC,
+	- "samsung,exynos5420-usb3phy" - for exynos5420 SoC.
+- reg : Register offset and length of USB 3.0 PHY register set;
+- clocks: Clock IDs array as required by the controller
+- clock-names: names of clocks correseponding to IDs in the clock property;
+	Required clocks:
+	- phy: main PHY clock (same as USB 3.0 controller IP clock),
+		 used for register access.
+	- usb3phy_refclk: PHY's reference clock (usually crystal clock), associated
+		   by phy name, used to determine bit values for clock
+		   settings register.
+	Additional clock required for Exynos5420:
+	- usb30_sclk_100m: Additional special clock used for PHY operation
+			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.
+- samsung,syscon-phandle: phandle for syscon interface, which is used to
+	control pmu registers for power isolation.
+- #phy-cells : from the generic PHY bindings, must be 0;
+
+Example:
+	usb3_phy: usbphy@12100000 {
+		compatible = "samsung,exynos5250-usb3phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock 286>, <&clock 1>;
+		clock-names = "phy", "usb3phy_refclk";
+		samsung,syscon-phandle = <&pmu_syscon>;
+		#phy-cells = <0>;
+	};
+
+- aliases: For SoCs like Exynos5420 having multiple USB PHY controllers,
+	   'usb3_phy' nodes should have numbered alias in the aliases node,
+	   in the form of usb3phyN, N = 0, 1... (depending on number of
+	   controllers).
+Example:
+	aliases {
+		usb3phy0 = &usb3_phy0;
+		usb3phy1 = &usb3_phy1;
+	};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..67e9045 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -51,4 +51,12 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config PHY_EXYNOS5_USB3
+	tristate "Exynos5 SoC series USB 3.0 PHY driver"
+	depends on ARCH_EXYNOS5
+	select GENERIC_PHY
+	select MFD_SYSCON
+	help
+	  Enable USB 3.0 PHY support for Exynos 5 SoC series
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index d0caae9..9c06a61 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_EXYNOS5_USB3)		+= phy-exynos5-usb3.o
diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
new file mode 100644
index 0000000..2bafc9d
--- /dev/null
+++ b/drivers/phy/phy-exynos5-usb3.c
@@ -0,0 +1,545 @@
+/*
+ * Samsung EXYNOS5 SoC series USB 3.0 PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Vivek Gautam <gautam.vivek@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+/* Exynos USB PHY registers */
+#define EXYNOS5_FSEL_9MHZ6		0x0
+#define EXYNOS5_FSEL_10MHZ		0x1
+#define EXYNOS5_FSEL_12MHZ		0x2
+#define EXYNOS5_FSEL_19MHZ2		0x3
+#define EXYNOS5_FSEL_20MHZ		0x4
+#define EXYNOS5_FSEL_24MHZ		0x5
+#define EXYNOS5_FSEL_50MHZ		0x7
+
+/* EXYNOS5: USB 3.0 DRD PHY registers */
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
+#define PHYCLKRST_EN_UTMISUSPEND		(0x1 << 31)
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
+#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x32 << 11)
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
+/* Power isolation defined in power management unit */
+#define EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET	(0x704)
+#define EXYNOS5_USB3DRD_PMU_ISOL		(1 << 0)
+
+#define KHZ	1000
+#define MHZ	(KHZ * KHZ)
+
+struct usb3phy_config {
+	bool has_usb30_sclk;
+	u32 reg_pmu_offset;
+	bool has_multi_controller;
+};
+
+struct usb3phy_driver {
+	struct device *dev;
+	void __iomem *reg_phy;
+	struct regmap *reg_isol;
+	const struct usb3phy_config *cfg;
+	struct clk *clk;
+	struct clk *usb30_sclk;
+	struct phy *phy;
+	u32 refclk;
+	unsigned long rate;
+	u32 channel;
+};
+
+/*
+ * exynos5_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static u32 exynos5_rate_to_clk(unsigned long rate)
+{
+	unsigned int clksel;
+
+	/* EXYNOS5_FSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		clksel = EXYNOS5_FSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		clksel = EXYNOS5_FSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		clksel = EXYNOS5_FSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		clksel = EXYNOS5_FSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		clksel = EXYNOS5_FSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		clksel = EXYNOS5_FSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		clksel = EXYNOS5_FSEL_50MHZ;
+		break;
+	default:
+		clksel = -EINVAL;
+	}
+
+	return clksel;
+}
+
+static void exynos5_usb3phy_isol(struct usb3phy_driver *drv, unsigned int on)
+{
+	u32 pmu_offset = drv->cfg->reg_pmu_offset;
+
+	if (!drv->reg_isol)
+		return;
+
+	switch (drv->channel) {
+	case 1:
+		/* Channel 1 is at 0x708 offset */
+		pmu_offset += sizeof(&pmu_offset);
+		break;
+	case 0:
+	default:
+		/* Channel 0 is at 0x704 offset */
+		break;
+	}
+
+	regmap_update_bits(drv->reg_isol, pmu_offset,
+					EXYNOS5_USB3DRD_PMU_ISOL, ~on);
+}
+
+/*
+ * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
+ */
+static u32 exynos5_usb3phy_set_refclk(struct usb3phy_driver *drv)
+{
+	u32 reg;
+
+	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
+	      PHYCLKRST_FSEL(drv->refclk);
+
+	switch (drv->refclk) {
+	case EXYNOS5_FSEL_50MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case EXYNOS5_FSEL_24MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	case EXYNOS5_FSEL_20MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case EXYNOS5_FSEL_19MHZ2:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	default:
+		dev_dbg(drv->dev, "unsupported ref clk\n");
+		break;
+	}
+
+	return reg;
+}
+
+static int exynos5_usb3phy_init(struct phy *phy)
+{
+	struct usb3phy_driver *drv = phy_get_drvdata(phy);
+	int ret;
+	u32 phyparam0;
+	u32 phyparam1;
+	u32 linksystem;
+	u32 phybatchg;
+	u32 phytest;
+	u32 phyclkrst;
+
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		return ret;
+
+	/* Reset USB 3.0 PHY */
+	writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
+
+	phyparam0 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+	/* Select PHY CLK source */
+	phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
+	/* Set Loss-of-Signal Detector sensitivity */
+	phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
+	phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
+	writel(phyparam0, drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+
+	writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYRESUME);
+
+	/*
+	 * Setting the Frame length Adj value[6:1] to default 0x20
+	 * See xHCI 1.0 spec, 5.2.4
+	 */
+	linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
+		     LINKSYSTEM_FLADJ(0x20);
+	writel(linksystem, drv->reg_phy + EXYNOS5_DRD_LINKSYSTEM);
+
+	phyparam1 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+	/* Set Tx De-Emphasis level */
+	phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
+	phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
+	writel(phyparam1, drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+
+	phybatchg = readl(drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
+	phybatchg |= PHYBATCHG_UTMI_CLKSEL;
+	writel(phybatchg, drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
+
+	/* PHYTEST POWERDOWN Control */
+	phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
+	phytest &= ~(PHYTEST_POWERDOWN_SSP |
+		     PHYTEST_POWERDOWN_HSP);
+	writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
+
+	/* UTMI Power Control */
+	writel(PHYUTMI_OTGDISABLE, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
+
+	phyclkrst = exynos5_usb3phy_set_refclk(drv);
+
+	phyclkrst |= PHYCLKRST_PORTRESET |
+		     /* Digital power supply in normal operating mode */
+		     PHYCLKRST_RETENABLEN |
+		     /* Enable ref clock for SS function */
+		     PHYCLKRST_REF_SSP_EN |
+		     /* Enable spread spectrum */
+		     PHYCLKRST_SSC_EN |
+		     /* Power down HS Bias and PLL blocks in suspend mode */
+		     PHYCLKRST_COMMONONN;
+
+	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	udelay(10);
+
+	phyclkrst &= ~PHYCLKRST_PORTRESET;
+	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	clk_disable_unprepare(drv->clk);
+
+	return 0;
+}
+
+static int exynos5_usb3phy_exit(struct phy *phy)
+{
+	struct usb3phy_driver *drv = phy_get_drvdata(phy);
+	int ret;
+	u32 phyutmi;
+	u32 phyclkrst;
+	u32 phytest;
+
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		return ret;
+
+	phyutmi = PHYUTMI_OTGDISABLE |
+		  PHYUTMI_FORCESUSPEND |
+		  PHYUTMI_FORCESLEEP;
+	writel(phyutmi, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
+
+	/* Resetting the PHYCLKRST enable bits to reduce leakage current */
+	phyclkrst = readl(drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+	phyclkrst &= ~(PHYCLKRST_REF_SSP_EN |
+		       PHYCLKRST_SSC_EN |
+		       PHYCLKRST_COMMONONN);
+	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	/* Control PHYTEST to remove leakage current */
+	phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
+	phytest |= PHYTEST_POWERDOWN_SSP |
+		   PHYTEST_POWERDOWN_HSP;
+	writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
+
+	clk_disable_unprepare(drv->clk);
+
+	return 0;
+}
+
+static int exynos5_usb3phy_power_on(struct phy *phy)
+{
+	struct usb3phy_driver *drv = phy_get_drvdata(phy);
+
+	dev_dbg(drv->dev, "Request to power_on usb3drd phy\n");
+
+	if (!IS_ERR(drv->usb30_sclk))
+		clk_prepare_enable(drv->usb30_sclk);
+
+	/* Power-on PHY*/
+	exynos5_usb3phy_isol(drv, 0);
+
+	return 0;
+}
+
+static int exynos5_usb3phy_power_off(struct phy *phy)
+{
+	struct usb3phy_driver *drv = phy_get_drvdata(phy);
+
+	dev_dbg(drv->dev, "Request to power_off usb3drd phy\n");
+
+	/* Power-off the PHY */
+	exynos5_usb3phy_isol(drv, 1);
+
+	if (!IS_ERR(drv->usb30_sclk))
+		clk_disable_unprepare(drv->usb30_sclk);
+
+	return 0;
+}
+
+static struct phy_ops exynos5_usb3phy_ops = {
+	.init		= exynos5_usb3phy_init,
+	.exit		= exynos5_usb3phy_exit,
+	.power_on	= exynos5_usb3phy_power_on,
+	.power_off	= exynos5_usb3phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+const struct usb3phy_config exynos5420_usb3phy_cfg = {
+	.has_usb30_sclk		= true,
+	.reg_pmu_offset		= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
+	.has_multi_controller	= true,
+};
+
+const struct usb3phy_config exynos5250_usb3phy_cfg = {
+	.has_usb30_sclk		= false,
+	.reg_pmu_offset		= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
+	.has_multi_controller	= false,
+};
+
+static const struct of_device_id exynos5_usb3phy_of_match[] = {
+	{
+		.compatible = "samsung,exynos5250-usb3phy",
+		.data = &exynos5250_usb3phy_cfg
+	}, {
+		.compatible = "samsung,exynos5420-usb3phy",
+		.data = &exynos5420_usb3phy_cfg
+	},
+	{ },
+};
+
+static int exynos5_usb3phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct usb3phy_driver *drv;
+	struct phy_provider *phy_provider;
+	struct resource *res;
+	struct clk *clk;
+	const struct of_device_id *match;
+	const struct usb3phy_config *cfg;
+
+	/*
+	 * Exynos systems are completely DT enabled,
+	 * so lets not have any platform data support for this driver.
+	 */
+	if (!node) {
+		dev_err(dev, "no device node found\n");
+		return -ENODEV;
+	}
+
+	match = of_match_node(exynos5_usb3phy_of_match, pdev->dev.of_node);
+	if (!match) {
+		dev_err(dev, "of_match_node() failed\n");
+		return -EINVAL;
+	}
+	cfg = match->data;
+
+	drv = devm_kzalloc(dev, sizeof(*drv), GFP_KERNEL);
+	if (!drv) {
+		dev_err(dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(dev, drv);
+	drv->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	drv->reg_phy = devm_ioremap_resource(dev, res);
+	if (IS_ERR(drv->reg_phy)) {
+		dev_err(dev, "Failed to map register memory (phy)\n");
+		return PTR_ERR(drv->reg_phy);
+	}
+
+	drv->cfg = cfg;
+
+	/*
+	 * Exynos5420 SoC has multiple channels for USB 3.0 PHY, with
+	 * each having separate power control registers.
+	 * 'drv->channel' facilitates to set such registers.
+	 */
+	if (drv->cfg->has_multi_controller) {
+		drv->channel = of_alias_get_id(node, "usb3phy");
+		if (drv->channel < 0) {
+			dev_err(dev, "Invalid usb3drd phy node\n");
+			return -EINVAL;
+		}
+	}
+
+	drv->reg_isol = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"samsung,syscon-phandle");
+	if (IS_ERR(drv->reg_isol)) {
+		dev_err(dev, "Failed to map register memory (isolation)\n");
+		return PTR_ERR(drv->reg_isol);
+	}
+
+	drv->clk = devm_clk_get(dev, "phy");
+	if (IS_ERR(drv->clk)) {
+		dev_err(dev, "Failed to get clock of phy controller\n");
+		return PTR_ERR(drv->clk);
+	}
+
+	/*
+	 * Exysno5420 SoC has an additional special clock, used for
+	 * for USB 3.0 PHY operation, this clock goes to the PHY block
+	 * as a reference clock to clock generation block of the controller,
+	 * named as 'USB30_SCLK_100M'.
+	 */
+	if (cfg->has_usb30_sclk) {
+		drv->usb30_sclk = devm_clk_get(dev, "usb30_sclk_100m");
+		if (IS_ERR(drv->usb30_sclk)) {
+			dev_err(dev, "Failed to get phy reference clock\n");
+			return PTR_ERR(drv->usb30_sclk);
+		}
+	}
+
+	dev_dbg(dev, "Creating usb3drd phy\n");
+	drv->phy = devm_phy_create(dev, &exynos5_usb3phy_ops, NULL);
+	if (IS_ERR(drv->phy)) {
+		dev_err(drv->dev, "Failed to create usb3drd phy\n");
+		return PTR_ERR(drv->phy);
+	}
+
+	phy_set_drvdata(drv->phy, drv);
+
+	clk = clk_get(dev, "usb3phy_refclk");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to get reference clock of usb3drd phy\n");
+		return PTR_ERR(clk);
+	}
+	drv->rate = clk_get_rate(clk);
+
+	drv->refclk = exynos5_rate_to_clk(drv->rate);
+	if (drv->refclk == -EINVAL) {
+		dev_err(dev, "Clock rate (%ld) not supported\n",
+						drv->rate);
+		clk_put(clk);
+		return -EINVAL;
+	}
+	clk_put(clk);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(drv->dev, "Failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver exynos5_usb3phy_driver = {
+	.probe	= exynos5_usb3phy_probe,
+	.driver = {
+		.of_match_table	= exynos5_usb3phy_of_match,
+		.name		= "exynos5-usb3phy",
+		.owner		= THIS_MODULE,
+	}
+};
+
+module_platform_driver(exynos5_usb3phy_driver);
+MODULE_DESCRIPTION("Samsung EXYNOS5 series SoC USB 3.0 PHY driver");
+MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:exynos5-usb3phy");
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 08e2f39..629789d 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -95,7 +95,7 @@ config SAMSUNG_USBPHY
 	help
 	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
 	  This driver provides common interface to interact, for Samsung USB 2.0 PHY
-	  driver and later for Samsung USB 3.0 PHY driver.
+	  driver.
 
 config SAMSUNG_USB2PHY
 	tristate "Samsung USB 2.0 PHY controller Driver"
@@ -105,14 +105,6 @@ config SAMSUNG_USB2PHY
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
index 022c1da..b7f304a 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
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
1.7.6.5

