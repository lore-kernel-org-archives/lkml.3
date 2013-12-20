Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab3LTNZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:25:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20769 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab3LTNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:25:39 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-d5-52b44552d9eb
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
Subject: [PATCH RFC alternative ver 1] phy: Exynos 421x USB 2.0 PHY support
Date: Fri, 20 Dec 2013 14:24:16 +0100
Message-id: <1387545857-9472-11-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd0g1y1BBp9PKlos2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4MrYdPAeS8HbJsaK
	h0s3MDYwtud2MXJySAiYSKx4dIUFwhaTuHBvPVsXIxeHkMB0Rolrd1ZAOR1MEl3vjwM5HBxs
	ApoSq+55gDSICNRITLl1hR2khlmgi1liwrbTbCAJYQFviQVT97KD2CwCqhLTr08H28Ar4CJx
	Zdp6JpA5EgIKEnMm2YCEOYHCMxcvAmsVEnCW+H32EesERt4FjAyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYKD/pn0DsZVDRaHGAU4GJV4eAv0NwcJsSaWFVfmHmKU4GBWEuHt194SJMSb
	klhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoHR/eCb7KDoD5FG
	h2/vWnNzcT2j8qIi8/X2s4QFW7mL2RbbRH9Y+P7OhQ1qz3WfHMo6tHTuxs6ux4bubKdP132b
	yOGbLPg6m2tZQeCxO07771veP5L11Nv0yITbsnOV1nSsOrMyo7judeZbznr+BIs1tbd3rn/5
	5GzlwSCDpIPLMquztHanHX7kpcRSnJFoqMVcVJwIAGZG5RN2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the alternative version of the support for Exynos 421x USB 2.0 PHY
in the Generic PHY framework. In this version the support for Exynos
4210 and 4212 was joined into one file.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
Hi,

Me and Kishon were discussing for quite a long time the way how Exynos 4
should be handled. I have decided to post the original patches and try
to make an alternative version with support for Exynos 4210 and 4212 joined
in one file. I have prepared two versions. The first one has 506 lines (vs
563 when two files are used). When doing the second version I was a little
more aggresive in removing code. This was done at a cost of adding if's
deciding which SoC version the driver is dealing with in some internal functions.
This resulted in a better number of removed lines - the second version has
only 452 lines (vs 563 original and 506 version 1).

Personally I like the original approach. One of my goals was to create a driver
that would be clear and easy to understand. I see that this was done at a cost of
having the code a little longer.

The first alternative version mostly was done by removing duplicate defines of
register values. The code clarity suffers a bit, but is still acceptable in my
opinion.

As to the second alternative version. It has the fewest lines, but I am not an
enthusiast of using "if this is SoC" in functions.

Anyway - please have a look at these two alternative versions in addition to
looking at the original patch "phy: Add new Exynos USB PHY driver".

Best wishes,
Kamil Debski
---
 drivers/phy/phy-exynos4212-usb2.c |  506 +++++++++++++++++++++++++++++++++++++
 1 file changed, 506 insertions(+)
 create mode 100644 drivers/phy/phy-exynos4212-usb2.c

diff --git a/drivers/phy/phy-exynos4212-usb2.c b/drivers/phy/phy-exynos4212-usb2.c
new file mode 100644
index 0000000..3fa22d0
--- /dev/null
+++ b/drivers/phy/phy-exynos4212-usb2.c
@@ -0,0 +1,506 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4210 and 4212 support
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+#include "phy-samsung-usb2.h"
+
+/* Exynos USB PHY registers */
+
+/* PHY power control */
+#define EXYNOS_421x_UPHYPWR			0x0
+
+#define EXYNOS_421x_UPHYPWR_PHY0_SUSPEND	BIT(0)
+#define EXYNOS_421x_UPHYPWR_PHY0_PWR		BIT(3)
+#define EXYNOS_421x_UPHYPWR_PHY0_OTG_PWR	BIT(4)
+#define EXYNOS_421x_UPHYPWR_PHY0_SLEEP		BIT(5)
+#define EXYNOS_421x_UPHYPWR_PHY0 ( \
+	EXYNOS_421x_UPHYPWR_PHY0_SUSPEND | \
+	EXYNOS_421x_UPHYPWR_PHY0_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY0_OTG_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY0_SLEEP)
+
+#define EXYNOS_421x_UPHYPWR_PHY1_SUSPEND	BIT(6)
+#define EXYNOS_421x_UPHYPWR_PHY1_PWR		BIT(7)
+#define EXYNOS_421x_UPHYPWR_PHY1_SLEEP		BIT(8)
+#define EXYNOS_421x_UPHYPWR_PHY1 ( \
+	EXYNOS_421x_UPHYPWR_PHY1_SUSPEND | \
+	EXYNOS_421x_UPHYPWR_PHY1_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY1_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND	BIT(9)
+#define EXYNOS_4210_UPHYPWR_HSCI0_SLEEP		BIT(10)
+#define EXYNOS_4210_UPHYPWR_HSCI0 ( \
+	EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND	BIT(11)
+#define EXYNOS_4210_UPHYPWR_HSCI1_SLEEP		BIT(12)
+#define EXYNOS_4210_UPHYPWR_HSCI1 ( \
+	EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_HSCI1_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND	BIT(9)
+#define EXYNOS_4212_UPHYPWR_HSCI0_PWR		BIT(10)
+#define EXYNOS_4212_UPHYPWR_HSCI0_SLEEP		BIT(11)
+#define EXYNOS_4212_UPHYPWR_HSCI0 ( \
+	EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HSCI0_PWR | \
+	EXYNOS_4212_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND	BIT(12)
+#define EXYNOS_4212_UPHYPWR_HSCI1_PWR		BIT(13)
+#define EXYNOS_4212_UPHYPWR_HSCI1_SLEEP		BIT(14)
+#define EXYNOS_4212_UPHYPWR_HSCI1 ( \
+	EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HSCI1_PWR | \
+	EXYNOS_4212_UPHYPWR_HSCI1_SLEEP)
+
+/* PHY clock control */
+#define EXYNOS_421x_UPHYCLK			0x4
+
+#define EXYNOS_421x_UPHYCLK_PHY0_COMMON_ON	BIT(4)
+#define EXYNOS_421x_UPHYCLK_PHY1_COMMON_ON	BIT(7)
+
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+
+#define EXYNOS_4210_UPHYCLK_PHY0_ID_PULLUP	BIT(2)
+
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_MASK	(0x7 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6	(0x0 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ	(0x1 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2	(0x3 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ	(0x4 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ	(0x5 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ	(0x7 << 0)
+
+#define EXYNOS_4212_UPHYCLK_PHY0_ID_PULLUP	BIT(3)
+
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_MASK	(0x7f << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_12MHZ	(0x24 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_15MHZ	(0x1c << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_16MHZ	(0x1a << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_19MHZ2	(0x15 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_20MHZ	(0x14 << 10)
+
+/* PHY reset control */
+#define EXYNOS_421x_UPHYRST			0x8
+
+#define EXYNOS_421x_URSTCON_PHY0		BIT(0)
+#define EXYNOS_421x_URSTCON_OTG_HLINK		BIT(1)
+#define EXYNOS_421x_URSTCON_OTG_PHYLINK		BIT(2)
+
+#define EXYNOS_4210_URSTCON_PHY1_ALL		BIT(3)
+#define EXYNOS_4210_URSTCON_PHY1_P0		BIT(4)
+#define EXYNOS_4210_URSTCON_PHY1_P1P2		BIT(5)
+#define EXYNOS_4210_URSTCON_HOST_LINK_ALL	BIT(6)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P0	BIT(7)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P1	BIT(8)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P2	BIT(9)
+
+#define EXYNOS_4212_URSTCON_HOST_PHY		BIT(3)
+#define EXYNOS_4212_URSTCON_PHY1		BIT(4)
+#define EXYNOS_4212_URSTCON_HSIC0		BIT(5)
+#define EXYNOS_4212_URSTCON_HSIC1		BIT(6)
+#define EXYNOS_4212_URSTCON_HOST_LINK_ALL	BIT(7)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P0	BIT(8)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P1	BIT(9)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P2	BIT(10)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_4210_USB_ISOL_DEVICE_OFFSET	0x704
+#define EXYNOS_4210_USB_ISOL_DEVICE		BIT(0)
+#define EXYNOS_4210_USB_ISOL_HOST_OFFSET	0x708
+#define EXYNOS_4210_USB_ISOL_HOST		BIT(0)
+
+#define EXYNOS_4212_USB_ISOL_OFFSET		0x704
+#define EXYNOS_4212_USB_ISOL_OTG		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC0_OFFSET	0x708
+#define EXYNOS_4212_USB_ISOL_HSIC0		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC1_OFFSET	0x70c
+#define EXYNOS_4212_USB_ISOL_HSIC1		BIT(0)
+
+/* USBYPHY1 Floating prevention */
+#define EXYNOS_4210_UPHY1CON			0x34
+#define EXYNOS_4210_UPHY1CON_FLOAT_PREVENTION	0x1
+
+/* Mode switching SUB Device <-> Host */
+#define EXYNOS_421x_MODE_SWITCH_OFFSET		0x21c
+#define EXYNOS_421x_MODE_SWITCH_MASK		1
+#define EXYNOS_421x_MODE_SWITCH_DEVICE		0
+#define EXYNOS_421x_MODE_SWITCH_HOST		1
+
+enum exynos4210_phy_id {
+	EXYNOS4210_DEVICE,
+	EXYNOS4210_HOST,
+	EXYNOS4210_HSIC0,
+	EXYNOS4210_HSIC1,
+	EXYNOS4210_NUM_PHYS,
+};
+
+enum exynos4212_phy_id {
+	EXYNOS4212_DEVICE,
+	EXYNOS4212_HOST,
+	EXYNOS4212_HSIC0,
+	EXYNOS4212_HSIC1,
+	EXYNOS4212_NUM_PHYS,
+};
+
+/*
+ * exynos4210_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int exynos4210_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	switch (rate) {
+	case 12 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 48 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * exynos4212_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int exynos4212_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	/* EXYNOS_4212_UPHYCLK_PHYFSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void exynos4210_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4210_DEVICE:
+		offset = EXYNOS_4210_USB_ISOL_DEVICE_OFFSET;
+		mask = EXYNOS_4210_USB_ISOL_DEVICE;
+		break;
+	case EXYNOS4210_HOST:
+		offset = EXYNOS_4210_USB_ISOL_HOST_OFFSET;
+		mask = EXYNOS_4210_USB_ISOL_HOST;
+		break;
+	default:
+		return;
+	};
+
+	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
+}
+
+static void exynos4212_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4212_DEVICE:
+	case EXYNOS4212_HOST:
+		offset = EXYNOS_4212_USB_ISOL_OFFSET;
+		mask = EXYNOS_4212_USB_ISOL_OTG;
+		break;
+	case EXYNOS4212_HSIC0:
+		offset = EXYNOS_4212_USB_ISOL_HSIC0_OFFSET;
+		mask = EXYNOS_4212_USB_ISOL_HSIC0;
+		break;
+	case EXYNOS4212_HSIC1:
+		offset = EXYNOS_4212_USB_ISOL_HSIC1_OFFSET;
+		mask = EXYNOS_4212_USB_ISOL_HSIC1;
+		break;
+	default:
+		return;
+	};
+
+	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
+}
+
+static void exynos4210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 rstbits = 0;
+	u32 phypwr = 0;
+	u32 rst;
+	u32 pwr;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4210_DEVICE:
+		phypwr =	EXYNOS_421x_UPHYPWR_PHY0;
+		rstbits =	EXYNOS_421x_URSTCON_PHY0;
+		break;
+	case EXYNOS4210_HOST:
+		phypwr =	EXYNOS_421x_UPHYPWR_PHY1;
+		rstbits =	EXYNOS_4210_URSTCON_PHY1_ALL |
+				EXYNOS_4210_URSTCON_PHY1_P0 |
+				EXYNOS_4210_URSTCON_PHY1_P1P2 |
+				EXYNOS_4210_URSTCON_HOST_LINK_ALL |
+				EXYNOS_4210_URSTCON_HOST_LINK_P0;
+		writel(on, drv->reg_phy + EXYNOS_4210_UPHY1CON);
+		break;
+	case EXYNOS4210_HSIC0:
+		phypwr =	EXYNOS_4210_UPHYPWR_HSCI0;
+		rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
+				EXYNOS_4210_URSTCON_HOST_LINK_P1;
+		break;
+	case EXYNOS4210_HSIC1:
+		phypwr =	EXYNOS_4210_UPHYPWR_HSCI1;
+		rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
+				EXYNOS_4210_URSTCON_HOST_LINK_P2;
+		break;
+	};
+
+	if (on) {
+		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_421x_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+
+		rst = readl(drv->reg_phy + EXYNOS_421x_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+	}
+}
+
+static void exynos4212_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 rstbits = 0;
+	u32 phypwr = 0;
+	u32 rst;
+	u32 pwr;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4212_DEVICE:
+		phypwr =	EXYNOS_421x_UPHYPWR_PHY0;
+		rstbits =	EXYNOS_421x_URSTCON_PHY0;
+		break;
+	case EXYNOS4212_HOST:
+		phypwr =	EXYNOS_421x_UPHYPWR_PHY1;
+		rstbits =	EXYNOS_4212_URSTCON_HOST_PHY;
+		break;
+	case EXYNOS4212_HSIC0:
+		phypwr =	EXYNOS_4212_UPHYPWR_HSCI0;
+		rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
+				EXYNOS_4212_URSTCON_HOST_LINK_P0 |
+				EXYNOS_4212_URSTCON_HOST_PHY;
+		break;
+	case EXYNOS4212_HSIC1:
+		phypwr =	EXYNOS_4212_UPHYPWR_HSCI1;
+		rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
+				EXYNOS_4212_URSTCON_HOST_LINK_P1;
+		break;
+	};
+
+	if (on) {
+		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_421x_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+
+		rst = readl(drv->reg_phy + EXYNOS_421x_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+	}
+}
+
+static int exynos4210_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	/* Order of initialisation is important - first power then isolation */
+	exynos4210_phy_pwr(inst, 1);
+	exynos4210_isol(inst, 0);
+
+	return 0;
+}
+
+static int exynos4210_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	exynos4210_isol(inst, 1);
+	exynos4210_phy_pwr(inst, 0);
+
+	return 0;
+}
+
+static int exynos4212_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	inst->enabled = 1;
+	exynos4212_phy_pwr(inst, 1);
+	exynos4212_isol(inst, 0);
+
+	/* Power on the device, as it is necessary for HSIC to work */
+	if (inst->cfg->id == EXYNOS4212_HSIC0) {
+		struct samsung_usb2_phy_instance *device =
+					&drv->instances[EXYNOS4212_DEVICE];
+		exynos4212_phy_pwr(device, 1);
+		exynos4212_isol(device, 0);
+	}
+
+	return 0;
+}
+
+static int exynos4212_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	struct samsung_usb2_phy_instance *device =
+					&drv->instances[EXYNOS4212_DEVICE];
+
+	inst->enabled = 0;
+	exynos4212_isol(inst, 1);
+	exynos4212_phy_pwr(inst, 0);
+
+	if (inst->cfg->id == EXYNOS4212_HSIC0 && !device->enabled) {
+		exynos4212_isol(device, 1);
+		exynos4212_phy_pwr(device, 0);
+	}
+
+	return 0;
+}
+
+static const struct samsung_usb2_common_phy exynos4210_phys[] = {
+	{
+		.label		= "device",
+		.id		= EXYNOS4210_DEVICE,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "host",
+		.id		= EXYNOS4210_HOST,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.id		= EXYNOS4210_HSIC0,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.id		= EXYNOS4210_HSIC1,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config exynos4210_usb2_phy_config = {
+	.num_phys		= EXYNOS4210_NUM_PHYS,
+	.phys			= exynos4210_phys,
+	.has_mode_switch	= 1,
+};
+
+
+static const struct samsung_usb2_common_phy exynos4212_phys[] = {
+	{
+		.label		= "device",
+		.id		= EXYNOS4212_DEVICE,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "host",
+		.id		= EXYNOS4212_HOST,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.id		= EXYNOS4212_HSIC0,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.id		= EXYNOS4212_HSIC1,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config exynos4212_usb2_phy_config = {
+	.num_phys		= EXYNOS4212_NUM_PHYS,
+	.phys			= exynos4212_phys,
+	.has_mode_switch	= 1,
+};
+
-- 
1.7.9.5

