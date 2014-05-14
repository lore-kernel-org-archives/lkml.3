Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaENTTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:19:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaENTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:18:23 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-22-5373c17d89e2
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
Date: Thu, 15 May 2014 00:47:21 +0530
Message-id: <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkWrf2YHGwwZuzyha31p1jtZh/BEhc
	+fqezeLAnx2MFt93fWG36F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLKYsOs1q07j3CbjHv
	804mi3ntL1kd+Dx2zrrL7rFpVSebx51re9g87ncfZ/Lo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBlzLjxlq2gPaBi2fzKBsZepy5GTg4JAROJrp/b2SFsMYkL99azdTFycQgJLGWU
	+LfzLQtMUWffJCaIxHRGif+b2pkhnHYmiT1tK8Gq2AR0JWYffMYIYosIpEl8O9DCClLELDCb
	SWLji9dsIAlhAUuJrs9zwBpYBFQlrmw8zQpi8wq4SUz88QvoDg6gdQoScybZgIQ5BdwlGi5t
	ZAaxhYBKVrTMA5spIXCPXeLRvYVMEHMEJL5NPsQC0SsrsekAM8TVkhIHV9xgmcAovICRYRWj
	aGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYASd/vds4g7G+wesDzEmA42byCwlmpwPjMC8knhD
	YzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAs8us7NPWq
	S1ruhfMHBOdE3wku2HvYz4y7/dk08avlD3O3T1p0oyDnA4Oq5322r4cCuAxNDk7wl+S3a9tz
	SUTXM9ztrtr0SE7hVfunhop6i6leOfjqlOy+1nM1D77vfXyyPsZmwhrz81e/su2OdEyVrq6J
	DFh0pmgG5zvZ1pPSk+qEfiaz/uhSYinOSDTUYi4qTgQAA6JNALYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoG7tweJgg/49gha31p1jtZh/BEhc
	+fqezeLAnx2MFt93fWG36F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLKYsOs1q07j3CbjHv
	804mi3ntL1kd+Dx2zrrL7rFpVSebx51re9g87ncfZ/Lo27KK0eP4je1MHp83yQWwRzUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa2kUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJhx4y1bQXtAxbL5lQ2MvU5djJwcEgIm
	Ep19k5ggbDGJC/fWs3UxcnEICUxnlPi/qZ0ZwmlnktjTtpIFpIpNQFdi9sFnjCC2iECaxLcD
	LawgRcwCs5kkNr54zQaSEBawlOj6PAesgUVAVeLKxtOsIDavgJvExB+/2LsYOYDWKUjMmWQD
	EuYUcJdouLSRGcQWAipZ0TKPdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH5
	THoH46oGi0OMAhyMSjy8DJOLg4VYE8uKK3MPMUpwMCuJ8CbtBQrxpiRWVqUW5ccXleakFh9i
	TAY6aiKzlGhyPjB15JXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDY0tCb6XMm8VC+Yp5PbNjttw0ZXs7dXZHoLax6JtzfaqP1pdJaR1bdSM1cH7NGbtbnpVT
	HP+rrfk5jUurar/4r4xLx55Y+J8+PcV5gsmfGwfm+u/fzb7Ofbmnu1OG5Cd5Dvn9p+Usowz+
	e0iWvj3x9Vlnjqy99NXyvDrpPcId09zkG/ZOmfFpvhJLcUaioRZzUXEiAL17A98TAwAA
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
 .../devicetree/bindings/phy/samsung-phy.txt        |   56 ++++++
 drivers/phy/Kconfig                                |    5 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/exynos-simple-phy.c                    |  189 ++++++++++++++++++++
 include/dt-bindings/phy/exynos-simple-phy.h        |   27 +++
 5 files changed, 278 insertions(+)
 create mode 100644 drivers/phy/exynos-simple-phy.c
 create mode 100644 include/dt-bindings/phy/exynos-simple-phy.h

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 2049261..12ad9cf 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -161,3 +161,59 @@ Example:
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
+For "samsung,exynos4210-simple-phy" compatible PHYs the second cell in
+the PHY specifier identifies the PHY and the supported phys for exynos4210
+are:
+  HDMI_PHY,
+  DAC_PHY,
+  ADC_PHY,
+  PCIE_PHY,
+  SATA_PHY.
+
+For "samsung,exynos4412-simple-phy" compatible PHYs the second cell in
+the PHY specifier identifies the PHY and the supported phys for exynos4412
+are:
+  HDMI_PHY,
+  ADC_PHY.
+
+For "samsung,exynos5250-simple-phy" compatible PHYs the second cell in
+the PHY specifier identifies the PHY and the supported phys for exynos5250
+are:
+  HDMI_PHY,
+  ADC_PHY,
+  SATA_PHY.
+
+For "samsung,exynos5420-simple-phy" compatible PHYs the second cell in
+the PHY specifier identifies the PHY and the supported phys for exynos5420
+are:
+  HDMI_PHY,
+  ADC_PHY.
+
+Example:
+Simple PHY provider node:
+
+	simplephys: simple-phys@10040000 {
+		compatible = "samsung,exynos5250-simple-phy";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <1>;
+	};
+
+Other nodes accessing simple PHYs:
+
+	hdmi {
+		phys = <&simplephys HDMI_PHY>;
+		phy-names = "hdmiphy";
+	};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..2a13e0d 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -178,4 +178,9 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config EXYNOS_SIMPLE_PHY
+	tristate "Exynos Simple PHY driver"
+	help
+	  Support for 1-bit PHY controllers on SoCs from Exynos family.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d57..81b6efa 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_EXYNOS_SIMPLE_PHY)		+= exynos-simple-phy.o
diff --git a/drivers/phy/exynos-simple-phy.c b/drivers/phy/exynos-simple-phy.c
new file mode 100644
index 0000000..792e9bc
--- /dev/null
+++ b/drivers/phy/exynos-simple-phy.c
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
+#include <dt-bindings/phy/exynos-simple-phy.h>
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
+#define EXYNOS_PHY_ENABLE	(1 << 0)
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
+	{ HDMI_PHY, 0x0700 },	/* HDMI_PHY */
+	{ DAC_PHY, 0x070C },	/* DAC_PHY */
+	{ ADC_PHY, 0x0718 },	/* ADC_PHY */
+	{ PCIE_PHY, 0x071C },	/* PCIE_PHY */
+	{ SATA_PHY, 0x0720 },	/* SATA_PHY */
+	{ INVALID, 0 },		/* End Mark */
+};
+
+static const struct phy_driver_data exynos4412_offsets[] = {
+	{ HDMI_PHY, 0x0700 },	/* HDMI_PHY */
+	{ ADC_PHY, 0x0718 },	/* ADC_PHY */
+	{ INVALID, 0 },		/* End Mark */
+};
+
+static const struct phy_driver_data exynos5250_offsets[] = {
+	{ HDMI_PHY, 0x0700 },	/* HDMI_PHY */
+	{ ADC_PHY, 0x0718 },	/* ADC_PHY */
+	{ SATA_PHY, 0x0724 },	/* SATA_PHY */
+	{ INVALID, 0 },		/* End Mark */
+};
+
+static const struct phy_driver_data exynos5420_offsets[] = {
+	{ HDMI_PHY, 0x0700 },	/* HDMI_PHY */
+	{ ADC_PHY, 0x0720 },	/* ADC_PHY */
+	{ INVALID, 0 },		/* End Mark */
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
+		of_match_ptr(exynos_phy_of_match), &pdev->dev);
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
+	dev_info(dev, "probe success\n");
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
diff --git a/include/dt-bindings/phy/exynos-simple-phy.h b/include/dt-bindings/phy/exynos-simple-phy.h
new file mode 100644
index 0000000..30bb341
--- /dev/null
+++ b/include/dt-bindings/phy/exynos-simple-phy.h
@@ -0,0 +1,27 @@
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
+/* simeple phys */
+
+#define INVALID	(~1)
+
+#define HDMI_PHY	0
+#define DAC_PHY	1
+#define ADC_PHY	2
+#define PCIE_PHY	3
+#define SATA_PHY	4
+#define PHY_NR	5
+
+#endif
-- 
1.7.9.5

