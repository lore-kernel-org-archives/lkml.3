Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaEONNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:13:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33753 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaEONNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:13:08 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d8-5374bd623858
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, kishon@ti.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com, r.sh.open@gmail.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v4 1/3] phy: Add exynos-simple-phy driver
Date: Thu, 15 May 2014 18:40:52 +0530
Message-id: <1400159454-31107-2-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
References: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkVjdpb0mwQfcsDYtb686xWsw/AiSu
	fH3PZnHgzw5Gi++7vrBb9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PFwhfxFlMWHWa1aN17
	hN1i3uedTBbz2l+yWvzcNY/FQcBj56y77B6bVnWyedy5tofN4373cSaPvi2rGD2O39jO5PF5
	k1wAexSXTUpqTmZZapG+XQJXRtfH7YwF04Mrlj7pYW5gnOraxcjJISFgIjHr2DdmCFtM4sK9
	9WxdjFwcQgJLGSWWtJ9ihyla2PiUFSKxiFHiVOc+JginnUni9acVLCBVbAK6ErMPPmMEsUUE
	0iS+HWgB62AWOMMk8ezKflaQhLCApUTf4X9sIDaLgKpEx7PXQCs4OHgFPCTe3/ICMSUEFCTm
	TLIBqeAU8JTYdeYm2HVCQBVvj89kBhkpIfCVXWLhjflQYwQkvk0+xALRKyux6QDUN5ISB1fc
	YJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmBMnf73bOIOxvsHrA8xJgONm8gs
	JZqcD4zJvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgZMsSbdL8uV/ou063/N2L2moes2WX3Wp7btj9f+snn2uLRJqnc9WeKEquKZlQYHfwaOe2
	/bvsag7NWnpDRzEnesWqDjZ1+T+HlZ9rnJh/9NmEHpvEhHUdRsJVp37PmLTEdKMA/wXvg/fn
	xO1N9bwdVj6jm/vLuVebMnY9ajp/4u2T9scL7T/rXFViKc5INNRiLipOBAB4OVr4vwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7S3pJgg2tNMha31p1jtZh/BEhc
	+fqezeLAnx2MFt93fWG36F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLhS/iLaYsOsxq0br3
	CLvFvM87mSzmtb9ktfi5ax6Lg4DHzll32T02repk87hzbQ+bx/3u40wefVtWMXocv7GdyePz
	JrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wc
	oOuVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBldH7czFkwPrlj6pIe5
	gXGqaxcjJ4eEgInEwsanrBC2mMSFe+vZuhi5OIQEFjFKnOrcxwThtDNJvP60ggWkik1AV2L2
	wWeMILaIQJrEtwMtrCBFzAJnmCSeXdkPNkpYwFKi7/A/NhCbRUBVouPZa/YuRg4OXgEPife3
	vEBMCQEFiTmTbEAqOAU8JXaduckMYgsBVbw9PpN5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBEftMegfjqgaLQ4wCHIxKPLwMk4uDhVgTy4orcw8xSnAwK4nwNk4vCRbiTUms
	rEotyo8vKs1JLT7EmAx000RmKdHkfGAyySuJNzQ2MTc1NrU0sTAxsyRNWEmc92CrdaCQQHpi
	SWp2ampBahHMFiYOTqkGxqbUwnZjJuvvT8Oe9xkJCavrH3qtHJx39ZTCGt3fB08uZ3jDfVSr
	7akdh0Yvn4/L3t9mL6eIbFtacPR3Z2I671K/SLuSkycTGS/EPIr7q8Ytvqxdtf3pBsbmm017
	a5xvX+g/cLT58+vfp+NyT3QeWNV16ZfHi71b4nn2Wk5y8dt06ajlmRnLTimxFGckGmoxFxUn
	AgAopYIVHAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Add exynos-simple-phy driver to support a single register
PHY interfaces present on Exynos4 SoC.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Rahul Sharma <Rahul.Sharma@samsung.com>

---
 .../devicetree/bindings/phy/samsung-phy.txt        |   57 ++++++
 drivers/phy/Kconfig                                |    5 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-simple.c                    |  189 ++++++++++++++++++++
 include/dt-bindings/phy/phy-exynos-simple.h        |   22 +++
 5 files changed, 274 insertions(+)
 create mode 100644 drivers/phy/phy-exynos-simple.c
 create mode 100644 include/dt-bindings/phy/phy-exynos-simple.h

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 2049261..a8d95d6 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -161,3 +161,60 @@ Example:
 		usbdrdphy0 = &usb3_phy0;
 		usbdrdphy1 = &usb3_phy1;
 	};
+
+Samsung S5P/EXYNOS SoC series SIMPLE PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be one of the listed compatibles:
+	- "samsung,exynos4210-simple-phy"
+	- "samsung,exynos4412-simple-phy"
+	- "samsung,exynos5250-simple-phy"
+	- "samsung,exynos5420-simple-phy"
+- samsung,pmureg-phandle - handle to syscon to control PMU registers
+- #phy-cells : from the generic phy bindings, must be 1;
+
+For a compatible PHY, the single cell specifier should be one of these
+listed values:
+
+  PHY_EXYNOS_SIMPLE_HDMI	0
+  PHY_EXYNOS_SIMPLE_DAC		1
+  PHY_EXYNOS_SIMPLE_ADC		2
+  PHY_EXYNOS_SIMPLE_PCIE	3
+  PHY_EXYNOS_SIMPLE_SATA	4
+
+List of supported PHYs for compatible "samsung,exynos4210-simple-phy" are:
+  PHY_EXYNOS_SIMPLE_HDMI,
+  PHY_EXYNOS_SIMPLE_DAC,
+  PHY_EXYNOS_SIMPLE_ADC,
+  PHY_EXYNOS_SIMPLE_PCIE,
+  PHY_EXYNOS_SIMPLE_SATA.
+
+List of supported PHYs for compatible "samsung,exynos4412-simple-phy" are:
+  PHY_EXYNOS_SIMPLE_HDMI,
+  PHY_EXYNOS_SIMPLE_ADC.
+
+List of supported PHYs for compatible "samsung,exynos5250-simple-phy" are:
+  PHY_EXYNOS_SIMPLE_HDMI,
+  PHY_EXYNOS_SIMPLE_ADC,
+  PHY_EXYNOS_SIMPLE_SATA.
+
+List of supported PHYs for compatible "samsung,exynos5420-simple-phy" are:
+  PHY_EXYNOS_SIMPLE_HDMI,
+  PHY_EXYNOS_SIMPLE_ADC.
+
+Example:
+Simple PHY provider node:
+
+	simplephys: simple-phys {
+		compatible = "samsung,exynos5250-simple-phy";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <1>;
+	};
+
+Other nodes accessing simple PHYs:
+
+	hdmi {
+		phys = <&simplephys PHY_EXYNOS_SIMPLE_HDMI>;
+		phy-names = "hdmiphy";
+	};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..c306ff2 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -178,4 +178,9 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_EXYNOS_SIMPLE
+	tristate "Exynos Simple PHY driver"
+	help
+	  Support for 1-bit PHY controllers on SoCs from Exynos family.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d57..cdf0b65 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
+obj-$(CONFIG_PHY_EXYNOS_SIMPLE)		+= phy-exynos-simple.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
 obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
diff --git a/drivers/phy/phy-exynos-simple.c b/drivers/phy/phy-exynos-simple.c
new file mode 100644
index 0000000..77fc3f7
--- /dev/null
+++ b/drivers/phy/phy-exynos-simple.c
@@ -0,0 +1,189 @@
+/*
+ * Exynos Simple PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include <dt-bindings/phy/phy-exynos-simple.h>
+
+#define EXYNOS_PHY_ENABLE	(1 << 0)
+#define INVALID			(~1)
+#define PHY_NR			5
+
+struct phy_driver_priv {
+	struct phy *phys[PHY_NR];
+	struct regmap *pmureg;
+	u32 offsets[PHY_NR];
+};
+
+struct phy_driver_data {
+	u32 index;
+	u32 offset;
+};
+
+struct phy_private {
+	struct regmap *pmureg;
+	u32 offset;
+};
+
+static int exynos_phy_power_on(struct phy *phy)
+{
+	struct phy_private *phy_private = phy_get_drvdata(phy);
+
+	return regmap_update_bits(phy_private->pmureg, phy_private->offset,
+		EXYNOS_PHY_ENABLE, 1);
+}
+
+static int exynos_phy_power_off(struct phy *phy)
+{
+	struct phy_private *phy_private = phy_get_drvdata(phy);
+
+	return regmap_update_bits(phy_private->pmureg, phy_private->offset,
+		EXYNOS_PHY_ENABLE, 0);
+}
+
+static struct phy_ops exynos_phy_ops = {
+	.power_on	= exynos_phy_power_on,
+	.power_off	= exynos_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static const struct phy_driver_data exynos4210_offsets[] = {
+	{ PHY_EXYNOS_SIMPLE_HDMI, 0x0700 },	/* HDMI_PHY */
+	{ PHY_EXYNOS_SIMPLE_DAC, 0x070C },	/* DAC_PHY */
+	{ PHY_EXYNOS_SIMPLE_ADC, 0x0718 },	/* ADC_PHY */
+	{ PHY_EXYNOS_SIMPLE_PCIE, 0x071C },	/* PCIE_PHY */
+	{ PHY_EXYNOS_SIMPLE_SATA, 0x0720 },	/* SATA_PHY */
+	{ INVALID, 0 },				/* End Mark */
+};
+
+static const struct phy_driver_data exynos4412_offsets[] = {
+	{ PHY_EXYNOS_SIMPLE_HDMI, 0x0700 },	/* HDMI_PHY */
+	{ PHY_EXYNOS_SIMPLE_ADC, 0x0718 },	/* ADC_PHY */
+	{ INVALID, 0 },				/* End Mark */
+};
+
+static const struct phy_driver_data exynos5250_offsets[] = {
+	{ PHY_EXYNOS_SIMPLE_HDMI, 0x0700 },	/* HDMI_PHY */
+	{ PHY_EXYNOS_SIMPLE_ADC, 0x0718 },	/* ADC_PHY */
+	{ PHY_EXYNOS_SIMPLE_SATA, 0x0724 },	/* SATA_PHY */
+	{ INVALID, 0 },				/* End Mark */
+};
+
+static const struct phy_driver_data exynos5420_offsets[] = {
+	{ PHY_EXYNOS_SIMPLE_HDMI, 0x0700 },	/* HDMI_PHY */
+	{ PHY_EXYNOS_SIMPLE_ADC, 0x0720 },	/* ADC_PHY */
+	{ INVALID, 0 },				/* End Mark */
+};
+
+static const struct of_device_id exynos_phy_of_match[] = {
+	{ .compatible = "samsung,exynos4210-simple-phy",
+	  .data = exynos4210_offsets},
+	{ .compatible = "samsung,exynos4412-simple-phy",
+	  .data = exynos4412_offsets},
+	{ .compatible = "samsung,exynos5250-simple-phy",
+	  .data = exynos5250_offsets},
+	{ .compatible = "samsung,exynos5420-simple-phy",
+	  .data = exynos5420_offsets},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_phy_of_match);
+
+static struct phy *exynos_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct phy_driver_priv *priv = dev_get_drvdata(dev);
+	struct phy_private *phy_private;
+	int index = args->args[0];
+
+	/* verify if index and corresponding offset are valid */
+	if (index >= PHY_NR || priv->offsets[index] == INVALID)
+		return ERR_PTR(-ENODEV);
+
+	/* return phy if already allocated */
+	if (!IS_ERR_OR_NULL(priv->phys[index]))
+		return priv->phys[index];
+
+	priv->phys[index] = devm_phy_create(dev, &exynos_phy_ops, NULL);
+	if (IS_ERR(priv->phys[index])) {
+		dev_err(dev, "failed to create PHY %d\n", index);
+		return priv->phys[index];
+	}
+
+	phy_private = devm_kzalloc(dev, sizeof(*phy_private), GFP_KERNEL);
+	if (!phy_private)
+		return ERR_PTR(-ENOMEM);
+
+	phy_private->pmureg = priv->pmureg;
+	phy_private->offset = priv->offsets[index];
+	phy_set_drvdata(priv->phys[index], phy_private);
+
+	return priv->phys[index];
+}
+
+static int exynos_phy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id = of_match_device(
+		exynos_phy_of_match, &pdev->dev);
+	const struct phy_driver_data *drv_data = of_id->data;
+	struct device *dev = &pdev->dev;
+	struct phy_driver_priv *priv;
+	struct phy_provider *phy_provider;
+	int i;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, priv);
+
+	priv->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
+			"samsung,pmu-syscon");
+	if (IS_ERR(priv->pmureg)) {
+		dev_err(dev, "Failed to map PMU register (via syscon)\n");
+		return PTR_ERR(priv->pmureg);
+	}
+
+	/* make all offsets invalid */
+	for (i = 0; i < PHY_NR; i++)
+		priv->offsets[i] = INVALID;
+
+	/* initialize offsets only if available in drv data */
+	for (i = 0; drv_data[i].index != INVALID; i++)
+		priv->offsets[drv_data[i].index] = drv_data[i].offset;
+
+	phy_provider = devm_of_phy_provider_register(dev, exynos_phy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(dev, "failed to register PHY provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver exynos_phy_driver = {
+	.probe	= exynos_phy_probe,
+	.driver = {
+		.of_match_table	= exynos_phy_of_match,
+		.name  = "exynos-simple-phy",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(exynos_phy_driver);
+
+MODULE_DESCRIPTION("Exynos Simple PHY driver");
+MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/dt-bindings/phy/phy-exynos-simple.h b/include/dt-bindings/phy/phy-exynos-simple.h
new file mode 100644
index 0000000..0b7ae14
--- /dev/null
+++ b/include/dt-bindings/phy/phy-exynos-simple.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for Exynos Simple PHY driver
+ *
+ */
+
+#ifndef _DT_BINDINGS_PHY_EXYNOS_SIMPLE_PHY_H
+#define _DT_BINDINGS_PHY_EXYNOS_SIMPLE_PHY_H
+
+#define PHY_EXYNOS_SIMPLE_HDMI		0
+#define PHY_EXYNOS_SIMPLE_DAC		1
+#define PHY_EXYNOS_SIMPLE_ADC		2
+#define PHY_EXYNOS_SIMPLE_PCIE		3
+#define PHY_EXYNOS_SIMPLE_SATA		4
+
+#endif
-- 
1.7.9.5

