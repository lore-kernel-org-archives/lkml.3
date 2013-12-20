Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3LTNY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:24:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60218 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LTNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:24:52 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-c6-52b445227765
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
Subject: [PATCH v5 3/9] phy: Add new Exynos USB 2.0 PHY driver
Date: Fri, 20 Dec 2013 14:24:09 +0100
Message-id: <1387545857-9472-4-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQV0l1y1BBuu2m1ks2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4Mq4fe0ie8Ghz4wV
	SzcvYWtg3HiKsYuRk0NCwETiytqtLBC2mMSFe+vZuhi5OIQEpjNK7Giayg7hdDBJzFx4HKiK
	g4NNQFNi1T0PkAYRgRqJKbeugNUwC3QxS0zYdpoNJCEsYCfROv83E4jNIqAqMfP8DUaQXl4B
	Z4mGmYUgpoSAgsScSTYgFZwCLhIzFy8C6xQCqvh99hHrBEbeBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCg/6Z1A7GlQ0WhxgFOBiVeHgbbDcHCbEmlhVX5h5ilOBgVhLh7dfeEiTE
	m5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBcfpH/a4Xa+9+
	3x7Alb67q3rbVcXbm1NexcjyrdO6MenLpML8dMYJL6a1Gqqphrx0iLJTdvxVfHs2z+qQoibe
	bZ8b7LcFnTr49e21HZZbDlywLFn7POXvGcPt26WfB/RcKo7X379gmt7exO3au78lPFI+ruay
	t/PXMQV+8xrFiTu019heNPRZvEmJpTgj0VCLuag4EQCux1b3dgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new driver for the Exynos USB 2.0 PHY. The new driver uses the generic
PHY framework. The driver includes support for the Exynos 4x10 and 4x12
SoC families.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |   55 ++++
 drivers/phy/Kconfig                                |   29 ++
 drivers/phy/Makefile                               |    3 +
 drivers/phy/phy-exynos4210-usb2.c                  |  257 ++++++++++++++++
 drivers/phy/phy-exynos4212-usb2.c                  |  306 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |  226 +++++++++++++++
 drivers/phy/phy-samsung-usb2.h                     |   67 +++++
 7 files changed, 943 insertions(+)
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4212-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.h

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index c0fccaa..39d52cc 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -20,3 +20,58 @@ Required properties:
 - compatible : should be "samsung,exynos5250-dp-video-phy";
 - reg : offset and length of the Display Port PHY register set;
 - #phy-cells : from the generic PHY bindings, must be 0;
+
+Samsung S5P/EXYNOS SoC series USB PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be one of the listed compatibles:
+	- "samsung,exynos4210-usb2-phy"
+	- "samsung,exynos4212-usb2-phy"
+- reg : a list of registers used by phy driver
+	- first and obligatory is the location of phy modules registers
+- samsung,sysreg-phandle - handle to syscon used to control the system registers
+- samsung,pmureg-phandle - handle to syscon used to control PMU registers
+- #phy-cells : from the generic phy bindings, must be 1;
+- clocks and clock-names:
+	- the "phy" clocks is required by the phy module
+	- next for each of the phys a clock has to be assigned, this clock
+	  will be used to determine clocking frequency for the phys
+	  (the labels are specified in the paragraph below)
+
+The first phandle argument in the PHY specifier identifies the PHY, its
+meaning is compatible dependent. For the currently supported SoCs (Exynos 4210
+and Exynos 4212) it is as follows:
+  0 - USB device ("device"),
+  1 - USB host ("host"),
+  2 - HSIC0 ("hsic0"),
+  3 - HSIC1 ("hsic1"),
+
+Exynos 4210 and Exynos 4212 use mode switching and require that mode switch
+register is supplied.
+
+Example:
+
+For Exynos 4412 (compatible with Exynos 4212):
+
+usbphy: phy@125b0000 {
+	compatible = "samsung,exynos4212-usb2-phy";
+	reg = <0x125b0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
+	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
+							<&clock 2>;
+	clock-names = "phy", "device", "host", "hsic0", "hsic1";
+	status = "okay";
+	#phy-cells = <1>;
+	samsung,sysreg-phandle = <&sys_reg>;
+	samsung,pmureg-phandle = <&pmu_reg>;
+};
+
+Then the PHY can be used in other nodes such as:
+
+phy-consumer@12340000 {
+	phys = <&usbphy 2>;
+	phy-names = "phy";
+};
+
+Refer to DT bindings documentation of particular PHY consumer devices for more
+information about required PHYs and the way of specification.
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..8e5cce1 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -51,4 +51,33 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config PHY_SAMSUNG_USB2
+	tristate "Samsung USB 2.0 PHY driver"
+	select GENERIC_PHY
+	select MFD_SYSCON
+	help
+	  Enable this to support the Samsung USB 2.0 PHY driver for Samsung
+	  SoCs. This driver provides the interface for USB 2.0 PHY. Support for
+	  particular SoCs has to be enabled in addition to this driver. Number
+	  and type of supported phys depends on the SoC.
+
+config PHY_EXYNOS4210_USB2
+	bool "Support for Exynos 4210"
+	depends on PHY_SAMSUNG_USB2
+	depends on CPU_EXYNOS4210
+	help
+	  Enable USB PHY support for Exynos 4210. This option requires that
+	  Samsung USB 2.0 PHY driver is enabled and means that support for this
+	  particular SoC is compiled in the driver. In case of Exynos 4210 four
+	  phys are available - device, host, HSCI0 and HSCI1.
+
+config PHY_EXYNOS4212_USB2
+	bool "Support for Exynos 4212"
+	depends on PHY_SAMSUNG_USB2
+	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
+	help
+	  Enable USB PHY support for Exynos 4212. This option requires that
+	  Samsung USB 2.0 PHY driver is enabled and means that support for this
+	  particular SoC is compiled in the driver. In case of Exynos 4212 four
+	  phys are available - device, host, HSIC0 and HSIC1.
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index d0caae9..9f4befd 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
+obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
+obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
diff --git a/drivers/phy/phy-exynos4210-usb2.c b/drivers/phy/phy-exynos4210-usb2.c
new file mode 100644
index 0000000..1c8f63f
--- /dev/null
+++ b/drivers/phy/phy-exynos4210-usb2.c
@@ -0,0 +1,257 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4210 support
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
+#define EXYNOS_4210_UPHYPWR			0x0
+
+#define EXYNOS_4210_UPHYPWR_PHY0_SUSPEND	BIT(0)
+#define EXYNOS_4210_UPHYPWR_PHY0_PWR		BIT(3)
+#define EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR	BIT(4)
+#define EXYNOS_4210_UPHYPWR_PHY0_SLEEP		BIT(5)
+#define EXYNOS_4210_UPHYPWR_PHY0	( \
+	EXYNOS_4210_UPHYPWR_PHY0_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_PHY0_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY0_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_PHY1_SUSPEND	BIT(6)
+#define EXYNOS_4210_UPHYPWR_PHY1_PWR		BIT(7)
+#define EXYNOS_4210_UPHYPWR_PHY1_SLEEP		BIT(8)
+#define EXYNOS_4210_UPHYPWR_PHY1 ( \
+	EXYNOS_4210_UPHYPWR_PHY1_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_PHY1_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY1_SLEEP)
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
+/* PHY clock control */
+#define EXYNOS_4210_UPHYCLK			0x4
+
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+
+#define EXYNOS_4210_UPHYCLK_PHY0_ID_PULLUP	BIT(2)
+#define EXYNOS_4210_UPHYCLK_PHY0_COMMON_ON	BIT(4)
+#define EXYNOS_4210_UPHYCLK_PHY1_COMMON_ON	BIT(7)
+
+/* PHY reset control */
+#define EXYNOS_4210_UPHYRST			0x8
+
+#define EXYNOS_4210_URSTCON_PHY0		BIT(0)
+#define EXYNOS_4210_URSTCON_OTG_HLINK		BIT(1)
+#define EXYNOS_4210_URSTCON_OTG_PHYLINK		BIT(2)
+#define EXYNOS_4210_URSTCON_PHY1_ALL		BIT(3)
+#define EXYNOS_4210_URSTCON_PHY1_P0		BIT(4)
+#define EXYNOS_4210_URSTCON_PHY1_P1P2		BIT(5)
+#define EXYNOS_4210_URSTCON_HOST_LINK_ALL	BIT(6)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P0	BIT(7)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P1	BIT(8)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P2	BIT(9)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_4210_USB_ISOL_DEVICE_OFFSET	0x704
+#define EXYNOS_4210_USB_ISOL_DEVICE		BIT(0)
+#define EXYNOS_4210_USB_ISOL_HOST_OFFSET	0x708
+#define EXYNOS_4210_USB_ISOL_HOST		BIT(0)
+
+/* USBYPHY1 Floating prevention */
+#define EXYNOS_4210_UPHY1CON			0x34
+#define EXYNOS_4210_UPHY1CON_FLOAT_PREVENTION	0x1
+
+/* Mode switching SUB Device <-> Host */
+#define EXYNOS_4210_MODE_SWITCH_OFFSET		0x21c
+#define EXYNOS_4210_MODE_SWITCH_MASK		1
+#define EXYNOS_4210_MODE_SWITCH_DEVICE		0
+#define EXYNOS_4210_MODE_SWITCH_HOST		1
+
+enum exynos4210_phy_id {
+	EXYNOS4210_DEVICE,
+	EXYNOS4210_HOST,
+	EXYNOS4210_HSIC0,
+	EXYNOS4210_HSIC1,
+	EXYNOS4210_NUM_PHYS,
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
+		phypwr =	EXYNOS_4210_UPHYPWR_PHY0;
+		rstbits =	EXYNOS_4210_URSTCON_PHY0;
+		break;
+	case EXYNOS4210_HOST:
+		phypwr =	EXYNOS_4210_UPHYPWR_PHY1;
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
+		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_4210_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + EXYNOS_4210_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_4210_UPHYPWR);
+
+		rst = readl(drv->reg_phy + EXYNOS_4210_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_4210_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_4210_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + EXYNOS_4210_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_4210_UPHYPWR);
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
diff --git a/drivers/phy/phy-exynos4212-usb2.c b/drivers/phy/phy-exynos4212-usb2.c
new file mode 100644
index 0000000..50f809c
--- /dev/null
+++ b/drivers/phy/phy-exynos4212-usb2.c
@@ -0,0 +1,306 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4212 support
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
+#define EXYNOS_4212_UPHYPWR			0x0
+
+#define EXYNOS_4212_UPHYPWR_PHY0_SUSPEND	BIT(0)
+#define EXYNOS_4212_UPHYPWR_PHY0_PWR		BIT(3)
+#define EXYNOS_4212_UPHYPWR_PHY0_OTG_PWR	BIT(4)
+#define EXYNOS_4212_UPHYPWR_PHY0_SLEEP		BIT(5)
+#define EXYNOS_4212_UPHYPWR_PHY0 ( \
+	EXYNOS_4212_UPHYPWR_PHY0_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_PHY0_PWR | \
+	EXYNOS_4212_UPHYPWR_PHY0_OTG_PWR | \
+	EXYNOS_4212_UPHYPWR_PHY0_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_PHY1_SUSPEND	BIT(6)
+#define EXYNOS_4212_UPHYPWR_PHY1_PWR		BIT(7)
+#define EXYNOS_4212_UPHYPWR_PHY1_SLEEP		BIT(8)
+#define EXYNOS_4212_UPHYPWR_PHY1 ( \
+	EXYNOS_4212_UPHYPWR_PHY1_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_PHY1_PWR | \
+	EXYNOS_4212_UPHYPWR_PHY1_SLEEP)
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
+#define EXYNOS_4212_UPHYCLK			0x4
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
+#define EXYNOS_4212_UPHYCLK_PHY0_COMMON_ON	BIT(4)
+#define EXYNOS_4212_UPHYCLK_PHY1_COMMON_ON	BIT(7)
+
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_MASK	(0x7f << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_12MHZ	(0x24 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_15MHZ	(0x1c << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_16MHZ	(0x1a << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_19MHZ2	(0x15 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_20MHZ	(0x14 << 10)
+
+/* PHY reset control */
+#define EXYNOS_4212_UPHYRST			0x8
+
+#define EXYNOS_4212_URSTCON_PHY0		BIT(0)
+#define EXYNOS_4212_URSTCON_OTG_HLINK		BIT(1)
+#define EXYNOS_4212_URSTCON_OTG_PHYLINK		BIT(2)
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
+#define EXYNOS_4212_USB_ISOL_OFFSET		0x704
+#define EXYNOS_4212_USB_ISOL_OTG		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC0_OFFSET	0x708
+#define EXYNOS_4212_USB_ISOL_HSIC0		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC1_OFFSET	0x70c
+#define EXYNOS_4212_USB_ISOL_HSIC1		BIT(0)
+
+/* Mode switching SUB Device <-> Host */
+#define EXYNOS_4212_MODE_SWITCH_OFFSET		0x21c
+#define EXYNOS_4212_MODE_SWITCH_MASK		1
+#define EXYNOS_4212_MODE_SWITCH_DEVICE		0
+#define EXYNOS_4212_MODE_SWITCH_HOST		1
+
+enum exynos4x12_phy_id {
+	EXYNOS4212_DEVICE,
+	EXYNOS4212_HOST,
+	EXYNOS4212_HSIC0,
+	EXYNOS4212_HSIC1,
+	EXYNOS4212_NUM_PHYS,
+};
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
+		phypwr =	EXYNOS_4212_UPHYPWR_PHY0;
+		rstbits =	EXYNOS_4212_URSTCON_PHY0;
+		break;
+	case EXYNOS4212_HOST:
+		phypwr =	EXYNOS_4212_UPHYPWR_PHY1;
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
+		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_4212_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + EXYNOS_4212_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_4212_UPHYPWR);
+
+		rst = readl(drv->reg_phy + EXYNOS_4212_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_4212_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_4212_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + EXYNOS_4212_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_4212_UPHYPWR);
+	}
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
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
new file mode 100644
index 0000000..3c09e0e
--- /dev/null
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -0,0 +1,226 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include "phy-samsung-usb2.h"
+
+static int samsung_usb2_phy_power_on(struct phy *phy)
+{
+	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	int ret;
+
+	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
+							inst->cfg->label);
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		goto err_main_clk;
+	ret = clk_prepare_enable(inst->clk);
+	if (ret)
+		goto err_instance_clk;
+	inst->rate = clk_get_rate(inst->clk);
+	if (inst->cfg->rate_to_clk) {
+		ret = inst->cfg->rate_to_clk(inst->rate, &inst->clk_reg_val);
+		if (ret)
+			goto err_get_rate;
+	}
+	if (inst->cfg->power_on) {
+		spin_lock(&drv->lock);
+		ret = inst->cfg->power_on(inst);
+		spin_unlock(&drv->lock);
+	}
+
+	return 0;
+
+err_get_rate:
+	clk_disable_unprepare(inst->clk);
+err_instance_clk:
+	clk_disable_unprepare(drv->clk);
+err_main_clk:
+	return ret;
+}
+
+static int samsung_usb2_phy_power_off(struct phy *phy)
+{
+	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	int ret = 0;
+
+	dev_dbg(drv->dev, "Request to power_off \"%s\" usb phy\n",
+							inst->cfg->label);
+	if (inst->cfg->power_off) {
+		spin_lock(&drv->lock);
+		ret = inst->cfg->power_off(inst);
+		spin_unlock(&drv->lock);
+	}
+	clk_disable_unprepare(inst->clk);
+	clk_disable_unprepare(drv->clk);
+	return ret;
+}
+
+static struct phy_ops samsung_usb2_phy_ops = {
+	.power_on	= samsung_usb2_phy_power_on,
+	.power_off	= samsung_usb2_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static struct phy *samsung_usb2_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct samsung_usb2_phy_driver *drv;
+
+	drv = dev_get_drvdata(dev);
+	if (!drv)
+		return ERR_PTR(-EINVAL);
+
+	if (WARN_ON(args->args[0] >= drv->cfg->num_phys))
+		return ERR_PTR(-ENODEV);
+
+	return drv->instances[args->args[0]].phy;
+}
+
+static const struct of_device_id samsung_usb2_phy_of_match[] = {
+#ifdef CONFIG_PHY_EXYNOS4210_USB2
+	{
+		.compatible = "samsung,exynos4210-usb2-phy",
+		.data = &exynos4210_usb2_phy_config,
+	},
+#endif
+#ifdef CONFIG_PHY_EXYNOS4212_USB2
+	{
+		.compatible = "samsung,exynos4212-usb2-phy",
+		.data = &exynos4212_usb2_phy_config,
+	},
+#endif
+	{ },
+};
+
+static int samsung_usb2_phy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	const struct samsung_usb2_phy_config *cfg;
+	struct clk *clk;
+	struct device *dev = &pdev->dev;
+	struct phy_provider *phy_provider;
+	struct resource *mem;
+	struct samsung_usb2_phy_driver *drv;
+	int i;
+
+	if (!pdev->dev.of_node) {
+		dev_err(dev, "This driver is required to be instantiated from device tree\n");
+		return -EINVAL;
+	}
+
+	match = of_match_node(samsung_usb2_phy_of_match, pdev->dev.of_node);
+	if (!match) {
+		dev_err(dev, "of_match_node() failed\n");
+		return -EINVAL;
+	}
+	cfg = match->data;
+
+	drv = devm_kzalloc(dev, sizeof(struct samsung_usb2_phy_driver) +
+		cfg->num_phys * sizeof(struct samsung_usb2_phy_instance),
+								GFP_KERNEL);
+	if (!drv)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, drv);
+	spin_lock_init(&drv->lock);
+
+	drv->cfg = cfg;
+	drv->dev = dev;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	drv->reg_phy = devm_ioremap_resource(dev, mem);
+	if (IS_ERR(drv->reg_phy)) {
+		dev_err(dev, "Failed to map register memory (phy)\n");
+		return PTR_ERR(drv->reg_phy);
+	}
+
+	drv->reg_pmu = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+		"samsung,pmureg-phandle");
+	if (IS_ERR(drv->reg_pmu)) {
+		dev_err(dev, "Failed to map PMU registers (via syscon)\n");
+		return PTR_ERR(drv->reg_pmu);
+	}
+
+	if (drv->cfg->has_mode_switch) {
+		drv->reg_sys = syscon_regmap_lookup_by_phandle(
+				pdev->dev.of_node, "samsung,sysreg-phandle");
+		if (IS_ERR(drv->reg_sys)) {
+			dev_err(dev, "Failed to map system registers (via syscon)\n");
+			return PTR_ERR(drv->reg_sys);
+		}
+	}
+
+	drv->clk = devm_clk_get(dev, "phy");
+	if (IS_ERR(drv->clk)) {
+		dev_err(dev, "Failed to get clock of phy controller\n");
+		return PTR_ERR(drv->clk);
+	}
+
+	for (i = 0; i < drv->cfg->num_phys; i++) {
+		char *label = drv->cfg->phys[i].label;
+		struct samsung_usb2_phy_instance *p = &drv->instances[i];
+
+		dev_dbg(dev, "Creating phy \"%s\"\n", label);
+		p->phy = devm_phy_create(dev, &samsung_usb2_phy_ops, NULL);
+		if (IS_ERR(p->phy)) {
+			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
+						label);
+			return PTR_ERR(p->phy);
+		}
+
+		p->cfg = &drv->cfg->phys[i];
+		p->drv = drv;
+		phy_set_drvdata(p->phy, p);
+
+		clk = devm_clk_get(dev, p->cfg->label);
+		if (IS_ERR(clk)) {
+			dev_err(dev, "Failed to get clock of \"%s\" phy\n",
+								p->cfg->label);
+			return PTR_ERR(clk);
+		}
+		p->clk = clk;
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev,
+							samsung_usb2_phy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(drv->dev, "Failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver samsung_usb2_phy_driver = {
+	.probe	= samsung_usb2_phy_probe,
+	.driver = {
+		.of_match_table	= samsung_usb2_phy_of_match,
+		.name		= "samsung-usb2-phy",
+		.owner		= THIS_MODULE,
+	}
+};
+
+module_platform_driver(samsung_usb2_phy_driver);
+MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
+MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:samsung-usb2-phy");
+
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
new file mode 100644
index 0000000..ab89f91
--- /dev/null
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -0,0 +1,67 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PHY_EXYNOS_USB2_H
+#define _PHY_EXYNOS_USB2_H
+
+#include <linux/clk.h>
+#include <linux/phy/phy.h>
+#include <linux/device.h>
+#include <linux/regmap.h>
+#include <linux/spinlock.h>
+
+#define KHZ 1000
+#define MHZ (KHZ * KHZ)
+
+struct samsung_usb2_phy_driver;
+struct samsung_usb2_phy_instance;
+struct samsung_usb2_phy_config;
+
+struct samsung_usb2_phy_instance {
+	const struct samsung_usb2_common_phy *cfg;
+	struct clk *clk;
+	struct phy *phy;
+	struct samsung_usb2_phy_driver *drv;
+	unsigned long rate;
+	u32 clk_reg_val;
+	bool enabled;
+};
+
+struct samsung_usb2_phy_driver {
+	const struct samsung_usb2_phy_config *cfg;
+	struct clk *clk;
+	struct device *dev;
+	void __iomem *reg_phy;
+	struct regmap *reg_pmu;
+	struct regmap *reg_sys;
+	spinlock_t lock;
+	struct samsung_usb2_phy_instance instances[0];
+};
+
+struct samsung_usb2_common_phy {
+	int (*rate_to_clk)(unsigned long, u32 *);
+	int (*power_on)(struct samsung_usb2_phy_instance *);
+	int (*power_off)(struct samsung_usb2_phy_instance *);
+	unsigned int id;
+	char *label;
+};
+
+
+struct samsung_usb2_phy_config {
+	const struct samsung_usb2_common_phy *phys;
+	unsigned int num_phys;
+	bool has_mode_switch;
+};
+
+extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
+extern const struct samsung_usb2_phy_config exynos4212_usb2_phy_config;
+#endif
+
-- 
1.7.9.5

