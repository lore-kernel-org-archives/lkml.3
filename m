Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3HZI4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:56:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60508 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3HZI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:56:34 -0400
X-AuditID: cbfee68e-b7f756d000004512-22-521b1841d061
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "'devicetree'" <devicetree@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
In-reply-to: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
Subject: [PATCH 1/3] phy: Add driver for Exynos DP PHY
Date: Mon, 26 Aug 2013 17:56:32 +0900
Message-id: <004001cea23a$29580400$7c080c00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6iOgN7MgvkoL3hRgS3gzfXOa2c2AAABRJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zga6jhHSQwbZXLBYH79dbvDykaTH/
	yDlWi+bF69ksLi+8xGrRu+Aqm8WFpz1sFif6PrBaXN41h81ixvl9TBbrHr5gsjj8pp3VYv2M
	1ywW6+ffYnPg83h14Q6Lx/65a9g9+rasYvQ4fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGXf+
	LGcu2KldsXTSfMYGxkkqXYwcHBICJhIrl9R0MXICmWISF+6tZ+ti5OIQEljGKHFiwX02mJqF
	B+Ih4osYJdY+38kC4fxilJh9+ysTSDebgJrEly+H2UFsEQEdiYWn1zODFDELvGOWuHV8NTNI
	QkjAVqJ162JWEJtTwE7iz4FWsGZhATOJQ0/2MILYLAKqEi3LboLV8wLV75jQyg5hC0r8mHyP
	BcRmFtCS2LytiRXClpfYvOYtM8Sl6hKP/upC3GAk8fbbXagSEYl9L94xgtwjITCXQ2IJ1HwW
	AQGJb5MPsUD0ykpsOsAMCQlJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KL
	jPSKE3OLS/PS9ZLzczcxQuK/bwfjzQPWhxiTgdZPZJYSTc4Hpo+8knhDYzMjC1MTU2Mjc0sz
	0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDKiiVcdah5Y7qxaxLLmgiDd0Gi
	Ig+PhulEtuoWX9J9f0XtxdxoL8+gNh2payuVWHy42eYkHpAr2LZt1u1FBlxhblqlmsFNBfEn
	j51N+FB3e98DM/k7bIYXMw5P3TZtnszvqZxp0VdvTlJ8KNr6T0HtskJwovPNDJZjcxUYlrxt
	vtohv5B/ymMlluKMREMt5qLiRAAHEvpuFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAV0HCekgg58PrS0O3q+3eHlI02L+
	kXOsFs2L17NZXF54idWid8FVNosLT3vYLE70fWC1uLxrDpvFjPP7mCzWPXzBZHH4TTurxfoZ
	r1ks1s+/xebA5/Hqwh0Wj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWbc+bOcuWCndsXSSfMZGxgnqXQxcnBICJhILDwQ38XICWSK
	SVy4t56ti5GLQ0hgEaPE2uc7WSCcX4wSs29/ZQKpYhNQk/jy5TA7iC0ioCOx8PR6ZpAiZoF3
	zBK3jq9mBkkICdhKtG5dzApicwrYSfw50ArWLCxgJnHoyR5GEJtFQFWiZdlNsHpeoPodE1rZ
	IWxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWGuFpd4tFfXYgbjCTefrsLVSIise/FO8YJjEKz
	kEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOL08k97BuKrB4hCj
	AAejEg9vAJt0kBBrYllxZe4hRgkOZiURXnNRoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbn
	A1NfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwiuzl5LH6
	s8p4X+iDN5YfTX0iiw+nWbwLi+JPXF2heXr1m8SOhphTPycf2uirO6F5useeg4tfaDgk1Ozw
	2N3bynt87b+6v7kXr+X1BDxrF7JkmrCGb9JPxiduxvPE9dP7pKV8X8cH/p7Pd3LqMWHlkm/F
	WyYfznzyQz9GbGqa7PzGBo79F1KuKLEUZyQaajEXFScCAMR5vvNzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a PHY provider driver for the Samsung Exynos SoC Display Port PHY.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    7 ++
 drivers/phy/Kconfig                                |    7 ++
 drivers/phy/Makefile                               |    7 +-
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++++++++++
 4 files changed, 129 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 drivers/phy/phy-exynos-dp-video.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
new file mode 100644
index 0000000..ee262238
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -0,0 +1,7 @@
+Samsung EXYNOS SoC series Display Port PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be "samsung,exynos5250-dp-video-phy";
+- reg : offset and length of the Display Port PHY register set;
+- #phy-cells : from the generic PHY bindings, must be 0;
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index ac239ac..fed26a0 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -38,4 +38,11 @@ config TWL4030_USB
 	  This transceiver supports high and full speed devices plus,
 	  in host mode, low speed.
 
+config PHY_EXYNOS_DP_VIDEO
+	tristate "EXYNOS SoC series Display Port PHY driver"
+	depends on OF
+	select GENERIC_PHY
+	help
+	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 0dd8a98..433e685 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the phy drivers.
 #
 
-obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
-obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
-obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
+obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
+obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
new file mode 100644
index 0000000..1dbe6ce
--- /dev/null
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -0,0 +1,111 @@
+/*
+ * Samsung EXYNOS SoC series Display Port PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
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
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+/* DPTX_PHY_CONTROL register */
+#define EXYNOS_DPTX_PHY_ENABLE		(1 << 0)
+
+struct exynos_dp_video_phy {
+	void __iomem *regs;
+};
+
+static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
+{
+	u32 reg;
+
+	reg = readl(state->regs);
+	if (on)
+		reg |= EXYNOS_DPTX_PHY_ENABLE;
+	else
+		reg &= ~EXYNOS_DPTX_PHY_ENABLE;
+	writel(reg, state->regs);
+
+	return 0;
+}
+
+static int exynos_dp_video_phy_power_on(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 1);
+}
+
+static int exynos_dp_video_phy_power_off(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 0);
+}
+
+static struct phy_ops exynos_dp_video_phy_ops = {
+	.power_on	= exynos_dp_video_phy_power_on,
+	.power_off	= exynos_dp_video_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int exynos_dp_video_phy_probe(struct platform_device *pdev)
+{
+	struct exynos_dp_video_phy *state;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	struct phy *phy;
+
+	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	state->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(state->regs))
+		return PTR_ERR(state->regs);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create Display Port PHY\n");
+		return PTR_ERR(phy);
+	}
+	phy_set_drvdata(phy, state);
+
+	return 0;
+}
+
+static const struct of_device_id exynos_dp_video_phy_of_match[] = {
+	{ .compatible = "samsung,exynos5250-dp-video-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
+
+static struct platform_driver exynos_dp_video_phy_driver = {
+	.probe	= exynos_dp_video_phy_probe,
+	.driver = {
+		.name	= "exynos-dp-video-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= exynos_dp_video_phy_of_match,
+	}
+};
+module_platform_driver(exynos_dp_video_phy_driver);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS SoC DP PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4


