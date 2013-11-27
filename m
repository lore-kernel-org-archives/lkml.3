Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3K0N0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:26:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29978 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3K0N0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:26:44 -0500
X-AuditID: cbfee61b-b7f166d000007a34-f5-5295f3125255
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: t.figa@samsung.com, kgene.kim@samsung.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com, kishon@ti.com,
        kyungmin.park@samsung.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] phy: Add exynos-phy driver
Date: Wed, 27 Nov 2013 14:26:28 +0100
Message-id: <1385558788-10880-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1385558788-10880-1-git-send-email-t.stanislaws@samsung.com>
References: <1385558788-10880-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAV2hz1ODDKYctrKYf+Qcq8WBPzsY
	LXoXXGWzuPC0h83ibNMbdotNj6+xWlzeNYfNYsb5fUwWh1ccYLKY93knk8X6Ga9ZLOa1v2R1
	4PFY8PkKu8fOWXfZPe5c28PmsXlJvUffllWMHsdvbGfy+LxJLoA9issmJTUnsyy1SN8ugSvj
	+6mdjAWztCo+/XvE0sB4TKmLkZNDQsBEYtvETmYIW0ziwr31bF2MXBxCAosYJebMWcEK4XQx
	Sfzrmc4EUsUG1HFsyWdGkISIQDujxN3f/1hAHGaB24wS+z9uBari4BAW0JZ4cCMWpIFFQFXi
	9eaHrCA2r4CHxPsHS9kg1slLPL3fxwZSzingKfFwszdIWAio5O/8CUwTGHkXMDKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAgOzWfSOxhXNVgcYhTgYFTi4Z1weUqQEGtiWXFl7iFGCQ5m
	JRHezJNTg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	GkzsXVNz4tLrct7D2oeiTkevrpuh3jnt2aqUZuMle1/Zu0+84Kz/zvublfXddyxcH1j/Mu2+
	1FC1ub2LoUlPTv3CKtcVDMI2z/Ja9wZH7Zwr/uXRleMPJofrH9CScjj8ck5dKtPCw0cOHJB4
	WJQ16eia1LrV0ofStnJc8LWocZQ90XdnY3yFiBJLcUaioRZzUXEiAOuTmK5JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add exynos-phy driver to support a single register
PHY interfaces present on Exynos4 SoC.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/phy/Kconfig      |    5 ++
 drivers/phy/Makefile     |    1 +
 drivers/phy/exynos-phy.c |  152 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+)
 create mode 100644 drivers/phy/exynos-phy.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..4414c73 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -51,4 +51,9 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config EXYNOS_PHY
+	tristate "Exynos PHY driver"
+	help
+	  Support for PHY controllers on SoCs from Exynos family.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index d0caae9..b2a833d 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
+obj-$(CONFIG_EXYNOS_PHY)	+= exynos-phy.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
diff --git a/drivers/phy/exynos-phy.c b/drivers/phy/exynos-phy.c
new file mode 100644
index 0000000..5a1ae6d
--- /dev/null
+++ b/drivers/phy/exynos-phy.c
@@ -0,0 +1,152 @@
+/*
+ * Exynos PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+
+#define EXYNOS_PHY_ENABLE	(1 << 0)
+
+static int exynos_phy_power_on(struct phy *phy)
+{
+	void __iomem *reg = phy_get_drvdata(phy);
+	u32 val;
+
+	val = readl(reg);
+	val |= EXYNOS_PHY_ENABLE;
+	writel(val, reg);
+
+	return 0;
+}
+
+static int exynos_phy_power_off(struct phy *phy)
+{
+	void __iomem *reg = phy_get_drvdata(phy);
+	u32 val;
+
+	val = readl(reg);
+	val &= ~EXYNOS_PHY_ENABLE;
+	writel(val, reg);
+
+	return 0;
+}
+
+static struct phy_ops exynos_phy_ops = {
+	.power_on	= exynos_phy_power_on,
+	.power_off	= exynos_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static const u32 exynos4210_offsets[] = {
+	0x0700, /* HDMI_PHY */
+	0x070C, /* DAC_PHY */
+	0x0718, /* ADC_PHY */
+	0x071C, /* PCIE_PHY */
+	0x0720, /* SATA_PHY */
+	~0, /* end mark */
+};
+
+static const u32 exynos4412_offsets[] = {
+	0x0700, /* HDMI_PHY */
+	0x0718, /* ADC_PHY */
+	~0, /* end mark */
+};
+
+static const struct of_device_id exynos_phy_of_match[] = {
+	{ .compatible = "exynos4210-phy", .data = exynos4210_offsets},
+	{ .compatible = "exynos4412-phy", .data = exynos4412_offsets},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_phy_of_match);
+
+static struct phy *exynos_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct phy **phys = dev_get_drvdata(dev);
+	int index = args->args[0];
+	int i;
+
+	/* verify if index is valid */
+	for (i = 0; i <= index; ++i)
+		if (!phys[i])
+			return ERR_PTR(-ENODEV);
+
+	return phys[index];
+}
+
+static int exynos_phy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id = of_match_device(
+		of_match_ptr(exynos_phy_of_match), &pdev->dev);
+	const u32 *offsets = of_id->data;
+	int count;
+	struct device *dev = &pdev->dev;
+	struct phy **phys;
+	struct resource *res;
+	void __iomem *regs;
+	int i;
+	struct phy_provider *phy_provider;
+
+	/* count number of phys to create */
+	for (count = 0; offsets[count] != ~0; ++count)
+		;
+
+	phys = devm_kzalloc(dev, (count + 1) * sizeof(phys[0]), GFP_KERNEL);
+	if (!phys)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, phys);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	regs = devm_ioremap(dev, res->start, res->end);
+	if (IS_ERR(regs)) {
+		dev_err(dev, "failed to ioremap registers\n");
+		return PTR_ERR(regs);
+	}
+
+	/* NOTE: last entry in phys[] is NULL */
+	for (i = 0; i < count; ++i) {
+		phys[i] = devm_phy_create(dev, &exynos_phy_ops, NULL);
+		if (IS_ERR(phys[i])) {
+			dev_err(dev, "failed to create PHY %d\n", i);
+			return PTR_ERR(phys[i]);
+		}
+		phy_set_drvdata(phys[i], regs + offsets[i]);
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev, exynos_phy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(dev, "failed to register PHY provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	dev_info(dev, "added %d phys\n", count);
+
+	return 0;
+}
+
+static struct platform_driver exynos_phy_driver = {
+	.probe	= exynos_phy_probe,
+	.driver = {
+		.of_match_table	= exynos_phy_of_match,
+		.name  = "exynos-phy",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(exynos_phy_driver);
+
+MODULE_DESCRIPTION("Exynos PHY driver");
+MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

