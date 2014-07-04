Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbaGDRtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:49:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576AbaGDRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:07 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-2b-53b6e9092ef5
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 07/19] phy: Add support for S5PV210 to the Exynos USB 2.0 PHY
 driver
Date: Fri, 04 Jul 2014 19:48:07 +0200
Message-id: <1404496099-26708-8-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7qcL7cFG/zsULb4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i1a4/jA5cHr9/TWL02Dnr
	LrvHplWdbB6bl9R7XDnRxOrRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DKuHdrDVPB
	K4+KZ/+usDcwrrHpYuTkkBAwkTh9ajILhC0mceHeerYuRi4OIYGljBJbbvQyQjh9TBJ7/q5j
	BKliE1CT+NzwiA3EFhFQlfjctoC9i5GDg1ngNpNEqzBIWFggTOLrsylMIDYLUMm1L6uYQWxe
	ASeJgxMOQi2Tk+jd9gYszingLDFx3QWweiGgmj//57NMYORdwMiwilE0tTS5oDgpPddQrzgx
	t7g0L10vOT93EyMkHL/sYFx8zOoQowAHoxIPb+OKDcFCrIllxZW5hxglOJiVRHj/rNoWLMSb
	klhZlVqUH19UmpNafIiRiYNTqoHRbMpk6Scrvv/0E0n/enF3r9OSbfvSH3wLYgp8qufhXeCe
	91wq6Heb+avov7VvI1JDjIrXpN/sutXrIzvNcsvBRIm8XrczlrLzrz69OXm20UKmPfu7vzVf
	eDWrYkqUz8zUt7Wc2zSmzplWc0j+QlKtinuCiOajTx6LTu/WXjxZecW3cl33/A1xSizFGYmG
	WsxFxYkAtBY/myUCAAA=
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
Signed-off-by: Mateusz Krawczuk <mat.krawczuk@gmail.com>
[t.figa: rebased, fixed merge errors, neatened]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/phy/samsung-phy.txt        |   1 +
 drivers/phy/Kconfig                                |  10 ++
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-s5pv210-usb2.c                     | 187 +++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |   6 +
 drivers/phy/phy-samsung-usb2.h                     |   1 +
 6 files changed, 206 insertions(+)
 create mode 100644 drivers/phy/phy-s5pv210-usb2.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 2049261..7dce043 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -26,6 +26,7 @@ Samsung S5P/EXYNOS SoC series USB PHY
 
 Required properties:
 - compatible : should be one of the listed compatibles:
+	- "samsung,s5pv210-usb2-phy"
 	- "samsung,exynos4210-usb2-phy"
 	- "samsung,exynos4x12-usb2-phy"
 	- "samsung,exynos5250-usb2-phy"
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..7153361 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -130,6 +130,16 @@ config PHY_SAMSUNG_USB2
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
index b4f1d57..2983808 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -18,5 +18,6 @@ phy-exynos-usb2-y			+= phy-samsung-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)	+= phy-s5pv210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
diff --git a/drivers/phy/phy-s5pv210-usb2.c b/drivers/phy/phy-s5pv210-usb2.c
new file mode 100644
index 0000000..004d320
--- /dev/null
+++ b/drivers/phy/phy-s5pv210-usb2.c
@@ -0,0 +1,187 @@
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
+#define S5PV210_USB_ISOL_OFFSET		0x680c
+#define S5PV210_USB_ISOL_DEVICE		BIT(0)
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
+
+	return 0;
+}
+
+static void s5pv210_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 mask;
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
+	regmap_update_bits(drv->reg_pmu, S5PV210_USB_ISOL_OFFSET,
+							mask, on ? 0 : mask);
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
+		writel(drv->ref_reg_val, drv->reg_phy + S5PV210_UPHYCLK);
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
+	s5pv210_isol(inst, 0);
+	s5pv210_phy_pwr(inst, 1);
+
+	return 0;
+}
+
+static int s5pv210_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	s5pv210_phy_pwr(inst, 0);
+	s5pv210_isol(inst, 1);
+
+	return 0;
+}
+
+static const struct samsung_usb2_common_phy s5pv210_phys[S5PV210_NUM_PHYS] = {
+	[S5PV210_DEVICE] = {
+		.label		= "device",
+		.id		= S5PV210_DEVICE,
+		.power_on	= s5pv210_power_on,
+		.power_off	= s5pv210_power_off,
+	},
+	[S5PV210_HOST] = {
+		.label		= "host",
+		.id		= S5PV210_HOST,
+		.power_on	= s5pv210_power_on,
+		.power_off	= s5pv210_power_off,
+	},
+};
+
+const struct samsung_usb2_phy_config s5pv210_usb2_phy_config = {
+	.num_phys	= ARRAY_SIZE(s5pv210_phys),
+	.phys		= s5pv210_phys,
+	.rate_to_clk	= s5pv210_rate_to_clk,
+};
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 8a8c6bc..6d7439c 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -87,6 +87,12 @@ static struct phy *samsung_usb2_phy_xlate(struct device *dev,
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
index 45b3170..1c55795 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -61,6 +61,7 @@ struct samsung_usb2_phy_config {
 	bool has_mode_switch;
 };
 
+extern const struct samsung_usb2_phy_config s5pv210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4x12_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos5250_usb2_phy_config;
-- 
1.9.3

