Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab3LTNZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:25:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29367 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LTNZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:25:12 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-e2-52b445371264
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v5 6/9] phy: Add support for S5PV210 to the Exynos USB 2.0 PHY
 driver
Date: Fri, 20 Dec 2013 14:24:12 +0100
Message-id: <1387545857-9472-7-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV1z1y1BBncviFks2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4Mp4vPMBc8Fa94pX
	p66wNDA+sOpi5OSQEDCRWPvuPxuELSZx4d56IJuLQ0hgOqPEjSnr2CGcDiaJA5e2A2U4ONgE
	NCVW3fMAaRARqJGYcusKWA2zQBezxIRtp8FqhAXCJVa+swCpYRFQlejcvJoRxOYVcJb4cHQB
	K0iJhICCxJxJNiBhTgEXiZmLF4HdIARU8vvsI9YJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgQH/DOpHYwrGywOMQpwMCrx8DbYbg4SYk0sK67MPcQowcGsJMLbr70lSIg3JbGy
	KrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjp2pX2Vo2p5MB/jcf
	CZ9aq6YXZ/Fy5c9wPaEITR47oQ1PT/1d3TzLWtjF+/gPgU3tGl9lJ8uflf4ktbpGrrrCp+fV
	vldMWY1Ffd+nv55Ve+DqidPS2bEuhq2XqrZr39feffNHt6+Z5Td2gdRtu2d/4XjdNKdFyKOk
	qFKEdf//7hs2vsJpx2YrsRRnJBpqMRcVJwIAw+B/Q3QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mateusz Krawczuk <mat.krawczuk@gmail.com>

Add support for the Samsung's S5PV210 SoC to the Exynos USB 2.0 PHY driver.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
[k.debski@samsung.com: cleanup and commit description]
[k.debski@samsung.com: make changes accordingly to the mailing list
comments]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    1 +
 drivers/phy/Kconfig                                |   10 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-s5pv210-usb2.c                     |  199 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |    6 +
 drivers/phy/phy-samsung-usb2.h                     |    1 +
 6 files changed, 218 insertions(+)
 create mode 100644 drivers/phy/phy-s5pv210-usb2.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 39d52cc..eb40460 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -26,6 +26,7 @@ Samsung S5P/EXYNOS SoC series USB PHY
 
 Required properties:
 - compatible : should be one of the listed compatibles:
+	- "samsung,s5pv210-usb2-phy"
 	- "samsung,exynos4210-usb2-phy"
 	- "samsung,exynos4212-usb2-phy"
 - reg : a list of registers used by phy driver
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 8e5cce1..b2c51ce 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -61,6 +61,16 @@ config PHY_SAMSUNG_USB2
 	  particular SoCs has to be enabled in addition to this driver. Number
 	  and type of supported phys depends on the SoC.
 
+config PHY_S5PV210_USB2
+	bool "Support for S5PV210"
+	depends on PHY_SAMSUNG_USB2
+	depends on ARCH_S5PV210
+	help
+	  Enable USB PHY support for S5PV210. This option requires that Samsung
+	  USB 2.0 PHY driver is enabled and means that support for this
+	  particular SoC is compiled in the driver. In case of S5PV210 two phys
+	  are available - device and host.
+
 config PHY_EXYNOS4210_USB2
 	bool "Support for Exynos 4210"
 	depends on PHY_SAMSUNG_USB2
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 9f4befd..fefc6c2 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
 obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
+obj-$(CONFIG_PHY_S5PV210_USB2)		+= phy-s5pv210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
diff --git a/drivers/phy/phy-s5pv210-usb2.c b/drivers/phy/phy-s5pv210-usb2.c
new file mode 100644
index 0000000..58797a7
--- /dev/null
+++ b/drivers/phy/phy-s5pv210-usb2.c
@@ -0,0 +1,199 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - S5PV210 support
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Authors: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/phy/phy.h>
+#include "phy-samsung-usb2.h"
+
+/* Exynos USB PHY registers */
+
+/* PHY power control */
+#define S5PV210_UPHYPWR			0x0
+
+#define S5PV210_UPHYPWR_PHY0_SUSPEND	BIT(0)
+#define S5PV210_UPHYPWR_PHY0_PWR	BIT(3)
+#define S5PV210_UPHYPWR_PHY0_OTG_PWR	BIT(4)
+#define S5PV210_UPHYPWR_PHY0	( \
+	S5PV210_UPHYPWR_PHY0_SUSPEND | \
+	S5PV210_UPHYPWR_PHY0_PWR | \
+	S5PV210_UPHYPWR_PHY0_OTG_PWR)
+
+#define S5PV210_UPHYPWR_PHY1_SUSPEND	BIT(6)
+#define S5PV210_UPHYPWR_PHY1_PWR	BIT(7)
+#define S5PV210_UPHYPWR_PHY1 ( \
+	S5PV210_UPHYPWR_PHY1_SUSPEND | \
+	S5PV210_UPHYPWR_PHY1_PWR)
+
+/* PHY clock control */
+#define S5PV210_UPHYCLK			0x4
+
+#define S5PV210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
+#define S5PV210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
+#define S5PV210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
+#define S5PV210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+
+#define S5PV210_UPHYCLK_PHY0_ID_PULLUP	BIT(2)
+#define S5PV210_UPHYCLK_PHY0_COMMON_ON	BIT(4)
+#define S5PV210_UPHYCLK_PHY1_COMMON_ON	BIT(7)
+
+/* PHY reset control */
+#define S5PV210_UPHYRST			0x8
+
+#define S5PV210_URSTCON_PHY0		BIT(0)
+#define S5PV210_URSTCON_OTG_HLINK	BIT(1)
+#define S5PV210_URSTCON_OTG_PHYLINK	BIT(2)
+#define S5PV210_URSTCON_PHY1_ALL	BIT(3)
+#define S5PV210_URSTCON_HOST_LINK_ALL	BIT(4)
+
+/* Isolation, configured in the power management unit */
+#define S5PV210_USB_ISOL_DEVICE_OFFSET	0x704
+#define S5PV210_USB_ISOL_DEVICE		BIT(0)
+#define S5PV210_USB_ISOL_HOST_OFFSET	0x708
+#define S5PV210_USB_ISOL_HOST		BIT(1)
+
+
+enum s5pv210_phy_id {
+	S5PV210_DEVICE,
+	S5PV210_HOST,
+	S5PV210_NUM_PHYS,
+};
+
+/*
+ * s5pv210_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int s5pv210_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	pr_info("%lu\n", rate);
+	switch (rate) {
+	case 12 * MHZ:
+		*reg = S5PV210_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = S5PV210_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 48 * MHZ:
+		*reg = S5PV210_UPHYCLK_PHYFSEL_48MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+}
+
+static void s5pv210_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 mask;
+	u32 tmp;
+
+	if (!drv->reg_isol)
+		return;
+
+	switch (inst->cfg->id) {
+	case S5PV210_DEVICE:
+		mask = S5PV210_USB_ISOL_DEVICE;
+		break;
+	case S5PV210_HOST:
+		mask = S5PV210_USB_ISOL_HOST;
+		break;
+	default:
+		return;
+	};
+
+	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
+}
+
+static void s5pv210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 rstbits = 0;
+	u32 phypwr = 0;
+	u32 rst;
+	u32 pwr;
+
+	switch (inst->cfg->id) {
+	case S5PV210_DEVICE:
+		phypwr =	S5PV210_UPHYPWR_PHY0;
+		rstbits =	S5PV210_URSTCON_PHY0;
+		break;
+	case S5PV210_HOST:
+		phypwr =	S5PV210_UPHYPWR_PHY1;
+		rstbits =	S5PV210_URSTCON_PHY1_ALL |
+				S5PV210_URSTCON_HOST_LINK_ALL;
+		break;
+	};
+
+	if (on) {
+		writel(inst->clk, drv->reg_phy + S5PV210_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + S5PV210_UPHYPWR);
+
+		rst = readl(drv->reg_phy + S5PV210_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + S5PV210_UPHYPWR);
+	}
+}
+
+static int s5pv210_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	s5pv210_isol(inst, 0);
+	s5pv210_phy_pwr(inst, 1);
+
+	return 0;
+}
+
+static int s5pv210_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	s5pv210_phy_pwr(inst, 0);
+	s5pv210_isol(inst, 1);
+
+	return 0;
+}
+
+
+static const struct samsung_usb2_common_phy s5pv210_phys[] = {
+	{
+		.label		= "device",
+		.id		= S5PV210_DEVICE,
+		.rate_to_clk	= s5pv210_rate_to_clk,
+		.power_on	= s5pv210_power_on,
+		.power_off	= s5pv210_power_off,
+	},
+	{
+		.label		= "host",
+		.id		= S5PV210_HOST,
+		.rate_to_clk	= s5pv210_rate_to_clk,
+		.power_on	= s5pv210_power_on,
+		.power_off	= s5pv210_power_off,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config s5pv210_usb2_phy_config = {
+	.cpu		= TYPE_S5PV210,
+	.num_phys	= S5PV210_NUM_PHYS,
+	.phys		= s5pv210_phys,
+};
+
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 3c09e0e..464a626 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -95,6 +95,12 @@ static struct phy *samsung_usb2_phy_xlate(struct device *dev,
 }
 
 static const struct of_device_id samsung_usb2_phy_of_match[] = {
+#ifdef CONFIG_PHY_S5PV210_USB2
+	{
+		.compatible = "samsung,s5pv210-usb2-phy",
+		.data = &s5pv210_usb2_phy_config,
+	},
+#endif
 #ifdef CONFIG_PHY_EXYNOS4210_USB2
 	{
 		.compatible = "samsung,exynos4210-usb2-phy",
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index ab89f91..5f5b240 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -61,6 +61,7 @@ struct samsung_usb2_phy_config {
 	bool has_mode_switch;
 };
 
+extern const struct samsung_usb2_phy_config s5pv210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4212_usb2_phy_config;
 #endif
-- 
1.7.9.5

