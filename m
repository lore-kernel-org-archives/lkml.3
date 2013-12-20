Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3LTNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:25:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20721 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3LTNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:25:19 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-ac-52b4453d45b2
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
Subject: [PATCH v5 7/9] phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
 driver
Date: Fri, 20 Dec 2013 14:24:13 +0100
Message-id: <1387545857-9472-8-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV071y1BBr+38Vos2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4Mo4+vETU8Gr6ooT
	/dENjPMyuhg5OSQETCSm7t/OCmGLSVy4t56ti5GLQ0hgOqPE5PPr2SGcDiaJX4+3AlVxcLAJ
	aEqsuucB0iAiUCMx5dYVsBpmgS5miQnbTrOBJIQFwiV+LPjECGKzCKhKLO6ZwA5i8wo4Sxzf
	+J4ZZI6EgILEnEk2IGFOAReJmYsXgbUKAZX8PvuIdQIj7wJGhlWMoqkFyQXFSem5RnrFibnF
	pXnpesn5uZsYwQH/THoH46oGi0OMAhyMSjy8Bfqbg4RYE8uKK3MPMUpwMCuJ8PZrbwkS4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDhNpNy7cqv9HWWR
	daV3RBLW7hYNuKppcWBKfXTTRqndp9Zd4H9dsie+yrhiP7u0h1Bk6BFzs21MDqUROScLVcLq
	dLovuLepl2knXO+OeKJ9SKNYau293dMCn6ofqH4SdqFzInOzK9vk8nl2J66usVK6fe5SUliU
	2/Yk174bujd2lN1qj2dQUWIpzkg01GIuKk4EAHuFOx10AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Exynos 5250. This driver is to replace the old
USB 2.0 PHY driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    1 +
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5250-usb2.c                  |  356 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |    6 +
 drivers/phy/phy-samsung-usb2.h                     |    1 +
 6 files changed, 376 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5250-usb2.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index eb40460..afc47c2 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -29,6 +29,7 @@ Required properties:
 	- "samsung,s5pv210-usb2-phy"
 	- "samsung,exynos4210-usb2-phy"
 	- "samsung,exynos4212-usb2-phy"
+	- "samsung,exynos5250-usb2-phy"
 - reg : a list of registers used by phy driver
 	- first and obligatory is the location of phy modules registers
 - samsung,sysreg-phandle - handle to syscon used to control the system registers
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index b2c51ce..726410f 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -90,4 +90,15 @@ config PHY_EXYNOS4212_USB2
 	  Samsung USB 2.0 PHY driver is enabled and means that support for this
 	  particular SoC is compiled in the driver. In case of Exynos 4212 four
 	  phys are available - device, host, HSIC0 and HSIC1.
+
+config PHY_EXYNOS5250_USB2
+	bool "Support for Exynos 5250"
+	depends on PHY_SAMSUNG_USB2
+	depends on SOC_EXYNOS5250
+	help
+	  Enable USB PHY support for Exynos 5250. This option requires that
+	  Samsung USB 2.0 PHY driver is enabled and means that support for this
+	  particular SoC is compiled in the driver. In case of Exynos 5250 four
+	  phys are available - device, host, HSIC0 and HSIC.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index fefc6c2..33c3ac1 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
 obj-$(CONFIG_PHY_S5PV210_USB2)		+= phy-s5pv210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
+obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
diff --git a/drivers/phy/phy-exynos5250-usb2.c b/drivers/phy/phy-exynos5250-usb2.c
new file mode 100644
index 0000000..b9b3b98
--- /dev/null
+++ b/drivers/phy/phy-exynos5250-usb2.c
@@ -0,0 +1,356 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 5250 support
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
+#define EXYNOS_5250_REFCLKSEL_CRYSTAL	0x0
+#define EXYNOS_5250_REFCLKSEL_XO	0x1
+#define EXYNOS_5250_REFCLKSEL_CLKCORE	0x2
+
+#define EXYNOS_5250_FSEL_9MHZ6		0x0
+#define EXYNOS_5250_FSEL_10MHZ		0x1
+#define EXYNOS_5250_FSEL_12MHZ		0x2
+#define EXYNOS_5250_FSEL_19MHZ2		0x3
+#define EXYNOS_5250_FSEL_20MHZ		0x4
+#define EXYNOS_5250_FSEL_24MHZ		0x5
+#define EXYNOS_5250_FSEL_50MHZ		0x7
+
+/* Normal host */
+#define EXYNOS_5250_HOSTPHYCTRL0			0x0
+
+#define EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL		BIT(31)
+#define EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_SHIFT	19
+#define EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_MASK	\
+		(0x3 << EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_SHIFT)
+#define EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT		16
+#define EXYNOS_5250_HOSTPHYCTRL0_FSEL_MASK \
+		(0x7 << EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT)
+#define EXYNOS_5250_HOSTPHYCTRL0_TESTBURNIN		BIT(11)
+#define EXYNOS_5250_HOSTPHYCTRL0_RETENABLE		BIT(10)
+#define EXYNOS_5250_HOSTPHYCTRL0_COMMON_ON_N		BIT(9)
+#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_MASK		(0x3 << 7)
+#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_DUAL		(0x0 << 7)
+#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_ID0		(0x1 << 7)
+#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_ANALOGTEST	(0x2 << 7)
+#define EXYNOS_5250_HOSTPHYCTRL0_SIDDQ			BIT(6)
+#define EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP		BIT(5)
+#define EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND		BIT(4)
+#define EXYNOS_5250_HOSTPHYCTRL0_WORDINTERFACE		BIT(3)
+#define EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST		BIT(2)
+#define EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST		BIT(1)
+#define EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST		BIT(0)
+
+/* HSIC0 & HSCI1 */
+#define EXYNOS_5250_HOSTPHYCTRL1			0x10
+#define EXYNOS_5250_HOSTPHYCTRL2			0x20
+
+#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_MASK		(0x3 << 23)
+#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_MASK		(0x7f << 16)
+#define EXYNOS_5250_HOSTPHYCTRLX_SIDDQ			BIT(6)
+#define EXYNOS_5250_HOSTPHYCTRLX_FORCESLEEP		BIT(5)
+#define EXYNOS_5250_HOSTPHYCTRLX_FORCESUSPEND		BIT(4)
+#define EXYNOS_5250_HOSTPHYCTRLX_WORDINTERFACE		BIT(3)
+#define EXYNOS_5250_HOSTPHYCTRLX_UTMISWRST		BIT(2)
+#define EXYNOS_5250_HOSTPHYCTRLX_PHYSWRST		BIT(0)
+
+/* EHCI control */
+#define EXYNOS_5250_HOSTEHCICTRL			0x30
+#define EXYNOS_5250_HOSTEHCICTRL_ENAINCRXALIGN		BIT(29)
+#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR4		BIT(28)
+#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR8		BIT(27)
+#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR16		BIT(26)
+#define EXYNOS_5250_HOSTEHCICTRL_AUTOPPDONOVRCUREN	BIT(25)
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT	19
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_MASK	\
+		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT)
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_SHIFT	13
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_MASK	\
+		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_SHIFT)
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL2_SHIFT	7
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_MASK	\
+		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT)
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_SHIFT	1
+#define EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_MASK \
+		(0x1 << EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_SHIFT)
+#define EXYNOS_5250_HOSTEHCICTRL_SIMULATIONMODE		BIT(0)
+
+/* OHCI control */
+#define EXYNOS_5250_HOSTOHCICTRL                        0x34
+#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_SHIFT	1
+#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_MASK \
+		(0x3ff << EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_SHIFT)
+#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVALEN		BIT(0)
+
+/* USBOTG */
+#define EXYNOS_5250_USBOTGSYS				0x38
+#define EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET		BIT(14)
+#define EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG		BIT(13)
+#define EXYNOS_5250_USBOTGSYS_PHY_SW_RST		BIT(12)
+#define EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT		9
+#define EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK \
+		(0x3 << EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT)
+#define EXYNOS_5250_USBOTGSYS_ID_PULLUP			BIT(8)
+#define EXYNOS_5250_USBOTGSYS_COMMON_ON			BIT(7)
+#define EXYNOS_5250_USBOTGSYS_FSEL_SHIFT		4
+#define EXYNOS_5250_USBOTGSYS_FSEL_MASK \
+		(0x3 << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT)
+#define EXYNOS_5250_USBOTGSYS_FORCE_SLEEP		BIT(3)
+#define EXYNOS_5250_USBOTGSYS_OTGDISABLE		BIT(2)
+#define EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG		BIT(1)
+#define EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND		BIT(0)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_5250_USB_ISOL_OTG_OFFSET		0x704
+#define EXYNOS_5250_USB_ISOL_OTG		BIT(0)
+#define EXYNOS_5250_USB_ISOL_HOST_OFFSET	0x708
+#define EXYNOS_5250_USB_ISOL_HOST		BIT(0)
+
+/* Mode swtich register */
+#define EXYNOS_5250_MODE_SWITCH_OFFSET		0x230
+#define EXYNOS_5250_MODE_SWITCH_MASK		1
+#define EXYNOS_5250_MODE_SWITCH_DEVICE		0
+#define EXYNOS_5250_MODE_SWITCH_HOST		1
+
+enum exynos4x12_phy_id {
+	EXYNOS5250_DEVICE,
+	EXYNOS5250_HOST,
+	EXYNOS5250_HSIC0,
+	EXYNOS5250_HSIC1,
+	EXYNOS5250_NUM_PHYS,
+};
+
+/*
+ * exynos5250_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int exynos5250_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	/* EXYNOS_5250_FSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		*reg = EXYNOS_5250_FSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		*reg = EXYNOS_5250_FSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		*reg = EXYNOS_5250_FSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		*reg = EXYNOS_5250_FSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		*reg = EXYNOS_5250_FSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS_5250_FSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		*reg = EXYNOS_5250_FSEL_50MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void exynos5250_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+
+	switch (inst->cfg->id) {
+	case EXYNOS5250_DEVICE:
+		offset = EXYNOS_5250_USB_ISOL_OTG_OFFSET;
+		mask = EXYNOS_5250_USB_ISOL_OTG;
+		break;
+	case EXYNOS5250_HOST:
+		offset = EXYNOS_5250_USB_ISOL_HOST_OFFSET;
+		mask = EXYNOS_5250_USB_ISOL_HOST;
+		break;
+	default:
+		return;
+	};
+
+	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
+}
+
+static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 ctrl0;
+	u32 otg;
+	u32 ehci;
+	u32 ohci;
+
+	switch (inst->cfg->id) {
+	case EXYNOS5250_DEVICE:
+		regmap_update_bits(drv->reg_sys,
+			EXYNOS_5250_MODE_SWITCH_OFFSET,
+			EXYNOS_5250_MODE_SWITCH_MASK,
+			EXYNOS_5250_MODE_SWITCH_DEVICE);
+
+		/* OTG configuration */
+		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
+		/* The clock */
+		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
+		otg |= inst->clk_reg_val << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
+		/* Reset */
+		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
+			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
+			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
+		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
+			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
+			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
+			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
+		/* Ref clock */
+		otg &=	~EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
+		otg |=  EXYNOS_5250_REFCLKSEL_CLKCORE <<
+					EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT;
+		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
+		udelay(100);
+		otg &= ~(EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
+			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
+			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
+			EXYNOS_5250_USBOTGSYS_OTGDISABLE);
+		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
+
+
+		break;
+	case EXYNOS5250_HOST:
+		/* Host registers configuration */
+		ctrl0 = readl(drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
+		/* The clock */
+		ctrl0 &= ~EXYNOS_5250_HOSTPHYCTRL0_FSEL_MASK;
+		ctrl0 |= inst->clk_reg_val <<
+					EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT;
+
+		/* Reset */
+		ctrl0 &=	~(EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST |
+				EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL |
+				EXYNOS_5250_HOSTPHYCTRL0_SIDDQ |
+				EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND |
+				EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP);
+		ctrl0 |=	EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
+				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST |
+				EXYNOS_5250_HOSTPHYCTRL0_COMMON_ON_N;
+		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
+		udelay(10);
+		ctrl0 &=	~(EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
+				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST);
+		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
+
+		/* OTG configuration */
+		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
+		/* The clock */
+		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
+		otg |= inst->clk_reg_val << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
+		/* Reset */
+		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
+			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
+			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
+		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
+			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
+			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
+			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
+		/* Ref clock */
+		otg &=	~EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
+		otg |=  EXYNOS_5250_REFCLKSEL_CLKCORE <<
+					EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT;
+		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
+		udelay(10);
+		otg &= ~(EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
+			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
+			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET);
+
+		/* Enable EHCI DMA burst */
+		ehci = readl(drv->reg_phy + EXYNOS_5250_HOSTEHCICTRL);
+		ehci |=	EXYNOS_5250_HOSTEHCICTRL_ENAINCRXALIGN |
+			EXYNOS_5250_HOSTEHCICTRL_ENAINCR4 |
+			EXYNOS_5250_HOSTEHCICTRL_ENAINCR8 |
+			EXYNOS_5250_HOSTEHCICTRL_ENAINCR16;
+		writel(ehci, drv->reg_phy + EXYNOS_5250_HOSTEHCICTRL);
+
+		/* OHCI settings */
+		ohci = readl(drv->reg_phy + EXYNOS_5250_HOSTOHCICTRL);
+		/* Following code is based on the old driver */
+		ohci |=	0x1 << 3;
+		writel(ohci, drv->reg_phy + EXYNOS_5250_HOSTOHCICTRL);
+
+		break;
+	}
+}
+
+static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	inst->enabled = 1;
+	exynos5250_phy_pwr(inst, 1);
+	exynos5250_isol(inst, 0);
+
+	return 0;
+}
+
+static int exynos5250_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	inst->enabled = 0;
+	exynos5250_isol(inst, 1);
+	exynos5250_phy_pwr(inst, 0);
+
+	return 0;
+}
+
+
+static const struct samsung_usb2_common_phy exynos5250_phys[] = {
+	{
+		.label		= "device",
+		.id		= EXYNOS5250_DEVICE,
+		.rate_to_clk	= exynos5250_rate_to_clk,
+		.power_on	= exynos5250_power_on,
+		.power_off	= exynos5250_power_off,
+	},
+	{
+		.label		= "host",
+		.id		= EXYNOS5250_HOST,
+		.rate_to_clk	= exynos5250_rate_to_clk,
+		.power_on	= exynos5250_power_on,
+		.power_off	= exynos5250_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.id		= EXYNOS5250_HSIC0,
+		.rate_to_clk	= exynos5250_rate_to_clk,
+		.power_on	= exynos5250_power_on,
+		.power_off	= exynos5250_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.id		= EXYNOS5250_HSIC1,
+		.rate_to_clk	= exynos5250_rate_to_clk,
+		.power_on	= exynos5250_power_on,
+		.power_off	= exynos5250_power_off,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config exynos5250_usb2_phy_config = {
+	.num_phys		= EXYNOS5250_NUM_PHYS,
+	.phys			= exynos5250_phys,
+	.has_mode_switch	= 1,
+};
+
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 464a626..76c2df0 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -113,6 +113,12 @@ static const struct of_device_id samsung_usb2_phy_of_match[] = {
 		.data = &exynos4212_usb2_phy_config,
 	},
 #endif
+#ifdef CONFIG_PHY_EXYNOS5250_USB2
+	{
+		.compatible = "samsung,exynos5250-usb2-phy",
+		.data = &exynos5250_usb2_phy_config,
+	},
+#endif
 	{ },
 };
 
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index 5f5b240..ffc3296 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -64,5 +64,6 @@ struct samsung_usb2_phy_config {
 extern const struct samsung_usb2_phy_config s5pv210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4212_usb2_phy_config;
+extern const struct samsung_usb2_phy_config exynos5250_usb2_phy_config;
 #endif
 
-- 
1.7.9.5

