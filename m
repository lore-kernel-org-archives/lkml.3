Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaATNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:38:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10611 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaATNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:38:34 -0500
X-AuditID: cbfee68f-b7f156d00000276c-a1-52dd26d85feb
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, balbi@ti.com, kishon@ti.com, t.figa@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, jwerner@chromium.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Mon, 20 Jan 2014 19:12:43 +0530
Message-id: <1390225363-24210-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkWveG2t0gg1/NWhYH79dbzD9yjtWi
	7cpBdovmxevZLC4vvMRq0XHoMZPFj9cX2Cx6F1xls7jwtIfNYmHbEhaLy7vmsFnMOL+PyWLR
	slZmi8Nv2lkt1s94zeLA7zG74SKLx/65a9g9+rasYvQ4fmM7k8fnTXIBrFFcNimpOZllqUX6
	dglcGdO/7WIteLOBsWLKkrWsDYzrJzB2MXJySAiYSOyY/ZIZwhaTuHBvPVsXIxeHkMBSRokZ
	0zYwdTFygBWdaA+FiC9ilFjw6yozhNPHJLH/9UIWkG42AV2Jpre7wKaKCDhILFl6B2wSs8BR
	Jokbz2eCFQkLWEt07v7JDmKzCKhK7J5wHczmFfCQuLt4NxvEGYoS3c8mgNmcQPE/N7czgdhC
	Au4Szw5vZ4Wouccuse1JJMQcAYlvkw+xQFwqK7HpANQ3khIHV9xgmcAovICRYRWjaGpBckFx
	UnqRsV5xYm5xaV66XnJ+7iZGYOSc/vesfwfj3QPWhxiTgcZNZJYSTc4HRl5eSbyhsZmRhamJ
	qbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcmzh5jv7b8DcHprty
	avSbsNScOnXGx/Ki92Wb2ZzHvRYfaGS6JBjFZtw0RZjjTLGIksTT9U2JCTFv2nJt8kt2+aZ6
	uYtKVGiY3fjz0mTSvt7nB3U+9y1Ur3yWJNn7dJvsTF7/Z6u9eDeuc7aZH3NUVb3R5+Tis11b
	ZJnsEw+/Zp0779ylwwFKLMUZiYZazEXFiQDSBUBMsgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd0baneDDDavkLM4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWi45Dj5ksfry+wGbRu+Aqm8WFpz1sFgvblrBYXN41h81ixvl9TBaL
	lrUyWxx+085qsX7GaxYHfo/ZDRdZPPbPXcPu0bdlFaPH8RvbmTw+b5ILYI1qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpXSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx/dsu1oI3GxgrpixZy9rAuH4CYxcjB4eEgInE
	ifbQLkZOIFNM4sK99WxdjFwcQgKLGCUW/LrKDOH0MUnsf72QBaSKTUBXountLkYQW0TAQWLJ
	0jtgHcwCR5kkbjyfCVYkLGAt0bn7JzuIzSKgKrF7wnUwm1fAQ+Lu4t1sEOsUJbqfTQCzOYHi
	f25uZwKxhQTcJZ4d3s46gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgyHwmvYNx
	VYPFIUYBDkYlHl4DtztBQqyJZcWVuYcYJTiYlUR4OVXvBgnxpiRWVqUW5ccXleakFh9iTAa6
	aiKzlGhyPjBp5JXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD
	4zKR28+mmp4p0DphxK39wfnjI8/FsbtXy9wu4xJx4Al6vG6zNR/To18b/5Wui8uMV5i//PY5
	s2nZPd9e/bp90aXGeVPZpu8u6226Nljt+8rsJDD33X7p/aozX/SF/KsNT/w4J3Ph1DtnZ2iy
	8PlXbZ7tGx8nOFd5Y+oUFrnVnCs4S1n+JKv+navEUpyRaKjFXFScCAB516f2EAMAAA==
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

Changes from v2:
1) Added support for multiple PHYs (UTMI+ and PIPE3) and
   related changes in the driver structuring.
2) Added a xlate function to get the required phy out of
   number of PHYs in mutiple PHY scenerio.
3) Changed the names of few structures and variables to
   have a clearer meaning.
4) Added 'usb3phy_config' structure to take care of mutiple
   phys for a SoC having 'exynos5_usb3phy_drv_data' driver data.
5) Not deleting support for old driver 'phy-samsung-usb3' until
   required support for generic phy is added to DWC3.

 .../devicetree/bindings/phy/samsung-phy.txt        |   49 ++
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usb3.c                     |  621 ++++++++++++++++++++
 4 files changed, 679 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5-usb3.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index c0fccaa..57079f8 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -20,3 +20,52 @@ Required properties:
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
+		used for register access.
+	- usb3phy_refclk: PHY's reference clock (usually crystal clock),
+		associated by phy name, used to determine bit values for
+		clock settings register.
+	Additional clock required for Exynos5420:
+	- usb30_sclk_100m: Additional special clock used for PHY operation
+			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.
+- samsung,syscon-phandle: phandle for syscon interface, which is used to
+	control pmu registers for power isolation.
+- #phy-cells : from the generic PHY bindings, must be 1;
+
+For "samsung,exynos5250-usb3phy" and "samsung,exynos5420-usb3phy" compatible
+PHYs, the second cell in the PHY specifier identifies the PHY id, which is
+interpreted as follows:
+  0 - UTMI+ type phy,
+  1 - PIPE3 type phy,
+
+Example:
+	usb3_phy: usbphy@12100000 {
+		compatible = "samsung,exynos5250-usb3phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock 286>, <&clock 1>;
+		clock-names = "phy", "usb3phy_refclk";
+		samsung,syscon-phandle = <&pmu_syscon>;
+		#phy-cells = <1>;
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
index 330ef2d..32f9f38 100644
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
index 0000000..24efed0
--- /dev/null
+++ b/drivers/phy/phy-exynos5-usb3.c
@@ -0,0 +1,621 @@
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
+enum exynos5_usb3phy_id {
+	EXYNOS5_USB3PHY_UTMI,
+	EXYNOS5_USB3PHY_PIPE3,
+	EXYNOS5_USB3PHYS_NUM,
+};
+
+struct usb3phy_config {
+	u32 id;
+	u32 reg_pmu_offset;
+	void (*phy_isol)(struct phy *phy, u32 on);
+};
+
+struct exynos5_usb3phy_drv_data {
+	bool has_usb30_sclk;
+	bool has_multi_controller;
+	const struct usb3phy_config *phy_cfg;
+};
+
+/**
+ * struct exynos5_usb3phy_driver - driver data for USB 3.0 PHY
+ * @dev: pointer to device instance of this platform device
+ * @reg_phy: usb phy controller register memory base
+ * @clk: phy clock for register access
+ * @usb30_sclk: additional special clock for phy operations
+ * @drv_data: pointer to SoC level driver data structure
+ * @phys[]: array for 'EXYNOS5_USB3PHYS_NUM' number of PHY
+ *	    instances each with its 'phy' and 'phy_cfg'.
+ * @extrefclk: frequency select settings when using 'separate
+ *	       reference clocks' for SS and HS operations
+ * @rate: rate of reference clock to PHY block
+ * @channel: number of PHY channels present in SoC
+ */
+struct exynos5_usb3phy_driver {
+	struct device *dev;
+	void __iomem *reg_phy;
+	struct clk *clk;
+	struct clk *usb30_sclk;
+	const struct exynos5_usb3phy_drv_data *drv_data;
+	struct phy_usb_instance {
+		struct phy *phy;
+		u32 index;
+		struct regmap *reg_isol;
+		const struct usb3phy_config *phy_cfg;
+	} phys[EXYNOS5_USB3PHYS_NUM];
+	u32 extrefclk;
+	unsigned long rate;
+	u32 channel;
+};
+
+#define to_usb3phy_driver(inst) \
+	container_of((inst), struct exynos5_usb3phy_driver, \
+		     phys[(inst)->index]);
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
+static void exynos5_usb3phy_isol(struct phy *phy, unsigned int on)
+{
+	u32 pmu_offset;
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
+
+	pmu_offset = inst->phy_cfg->reg_pmu_offset;
+	if (!inst->reg_isol)
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
+	regmap_update_bits(inst->reg_isol, pmu_offset,
+			   EXYNOS5_USB3DRD_PMU_ISOL, ~on);
+}
+
+/*
+ * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
+ */
+static u32 exynos5_usb3phy_set_refclk(struct exynos5_usb3phy_driver *drv)
+{
+	u32 reg;
+
+	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
+	      PHYCLKRST_FSEL(drv->extrefclk);
+
+	switch (drv->extrefclk) {
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
+	int ret;
+	u32 phyparam0;
+	u32 phyparam1;
+	u32 linksystem;
+	u32 phybatchg;
+	u32 phytest;
+	u32 phyclkrst;
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
+
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		return ret;
+
+	drv->extrefclk = exynos5_rate_to_clk(drv->rate);
+	if (drv->extrefclk == -EINVAL) {
+		dev_err(drv->dev, "Clock rate (%ld) not supported\n",
+						drv->rate);
+		return -EINVAL;
+	}
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
+	int ret;
+	u32 phyutmi;
+	u32 phyclkrst;
+	u32 phytest;
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
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
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
+
+	dev_dbg(drv->dev, "Request to power_on usb3drd phy\n");
+
+	if (!IS_ERR(drv->usb30_sclk))
+		clk_prepare_enable(drv->usb30_sclk);
+
+	/* Power-on PHY*/
+	inst->phy_cfg->phy_isol(phy, 0);
+
+	return 0;
+}
+
+static int exynos5_usb3phy_power_off(struct phy *phy)
+{
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
+
+	dev_dbg(drv->dev, "Request to power_off usb3drd phy\n");
+
+	/* Power-off the PHY */
+	inst->phy_cfg->phy_isol(phy, 1);
+
+	if (!IS_ERR(drv->usb30_sclk))
+		clk_disable_unprepare(drv->usb30_sclk);
+
+	return 0;
+}
+
+static struct phy *exynos5_usb3phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct exynos5_usb3phy_driver *drv = dev_get_drvdata(dev);
+
+	if (WARN_ON(args->args[0] > EXYNOS5_USB3PHYS_NUM))
+		return ERR_PTR(-ENODEV);
+
+	return drv->phys[args->args[0]].phy;
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
+const struct usb3phy_config exynos5_usb3phy_cfg[] = {
+	{
+		.id		= EXYNOS5_USB3PHY_UTMI,
+		.reg_pmu_offset	= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
+		.phy_isol	= exynos5_usb3phy_isol,
+	},
+	{
+		.id		= EXYNOS5_USB3PHY_PIPE3,
+		.reg_pmu_offset	= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
+		.phy_isol	= exynos5_usb3phy_isol,
+	},
+	{},
+};
+
+const struct exynos5_usb3phy_drv_data exynos5420_usb3phy = {
+	.has_usb30_sclk		= true,
+	.has_multi_controller	= true,
+	.phy_cfg		= exynos5_usb3phy_cfg,
+};
+
+const struct exynos5_usb3phy_drv_data exynos5250_usb3phy = {
+	.has_usb30_sclk		= false,
+	.has_multi_controller	= false,
+	.phy_cfg		= exynos5_usb3phy_cfg,
+};
+
+static const struct of_device_id exynos5_usb3phy_of_match[] = {
+	{
+		.compatible = "samsung,exynos5250-usb3phy",
+		.data = &exynos5250_usb3phy
+	}, {
+		.compatible = "samsung,exynos5420-usb3phy",
+		.data = &exynos5420_usb3phy
+	},
+	{ },
+};
+
+static int exynos5_usb3phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct exynos5_usb3phy_driver *drv;
+	struct phy_provider *phy_provider;
+	struct resource *res;
+	struct clk *clk;
+	const struct of_device_id *match;
+	const struct exynos5_usb3phy_drv_data *drv_data;
+	struct regmap *reg_isol;
+	int i;
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
+	drv_data = match->data;
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
+	drv->drv_data = drv_data;
+
+	/*
+	 * Exynos5420 SoC has multiple channels for USB 3.0 PHY, with
+	 * each having separate power control registers.
+	 * 'drv->channel' facilitates to set such registers.
+	 */
+	if (drv->drv_data->has_multi_controller) {
+		drv->channel = of_alias_get_id(node, "usb3phy");
+		if (drv->channel < 0) {
+			dev_err(dev, "Invalid usb3drd phy node\n");
+			return -EINVAL;
+		}
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
+	if (drv_data->has_usb30_sclk) {
+		drv->usb30_sclk = devm_clk_get(dev, "usb30_sclk_100m");
+		if (IS_ERR(drv->usb30_sclk)) {
+			dev_err(dev, "Failed to get phy reference clock\n");
+			return PTR_ERR(drv->usb30_sclk);
+		}
+	}
+
+	clk = clk_get(dev, "usb3phy_refclk");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to get reference clock of usb3drd phy\n");
+		return PTR_ERR(clk);
+	}
+	drv->rate = clk_get_rate(clk);
+	clk_put(clk);
+
+	dev_dbg(dev, "Creating usb3drd phy\n");
+
+	reg_isol = syscon_regmap_lookup_by_phandle(dev->of_node,
+						   "samsung,syscon-phandle");
+	if (IS_ERR(reg_isol)) {
+		dev_err(dev, "Failed to map register memory (isolation)\n");
+		return PTR_ERR(reg_isol);
+	}
+
+	for (i = 0; i < EXYNOS5_USB3PHYS_NUM; i++) {
+		struct phy *phy = devm_phy_create(dev, &exynos5_usb3phy_ops,
+						  NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "Failed to create usb3drd phy\n");
+			return PTR_ERR(phy);
+		}
+
+		drv->phys[i].phy = phy;
+		drv->phys[i].index = i;
+		drv->phys[i].reg_isol = reg_isol;
+		drv->phys[i].phy_cfg = &drv_data->phy_cfg[i];
+		phy_set_drvdata(phy, &drv->phys[i]);
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev,
+						     exynos5_usb3phy_xlate);
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
-- 
1.7.10.4

