Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3KEQPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:15:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10637 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3KEQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:15:00 -0500
Date: Tue, 05 Nov 2013 17:13:19 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1383668001-19141-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-AuditID: cbfee61b-b7fd56d000001fc6-a2-527919828403
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd0mycoggysfBCyW7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0ht1i2s7/rBaXd81hs5hxfh+TxaJlrcwW
	a4/cZbc423+bzeL8lk4mi8Nv2lkt1s94zWLRcfYgu4OQx+W+XiaPnbPusnv0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgyOn/bFsz9yljRs/sCWwPjw5OMXYycHBICJhIP/iyCssUk
	Ltxbz9bFyMUhJLCIUeLQ51/MEE4Hk8TM/jNAVRwcbAKaEqvueYA0iAjMZJTYvNgUpIZZ4CiT
	ROvTLWCThAWsJG5t2soKYrMIqEpc6HvIDmLzCrhI3Og8xQIyR0JAQWLOJBuQMKeAq8T7eeuZ
	QWwhoJITS74zT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOIifSe9gXNVgcYhR
	gINRiYf3YmhFkBBrYllxZe4hRgkOZiUR3mP/gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7Za
	BwoJpCeWpGanphakFsFkmTg4pRoYuyVl1Cf/mnlyYZ1XSoV3eNaMms5mq2OuR16Uzf/9/dvS
	OKVVyc98PR0W1FRcat32fb2wx4um1V8bt0psWJtsFnPC7p3Wl7sZwofm8vQ8OWp6/ogHk/7D
	p+tU7JY7Lnu3vObYupWchSHrmF2EqiZPW2X5b8mT3z3ed6TZ7ixnS3blLXHb2bjxpRJLcUai
	oRZzUXEiACiR1VVeAgAA
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new driver for the Exynos USB PHY. The new driver uses the generic
PHY framework. The driver includes support for the Exynos 4x10 and 4x12
SoC families.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
 drivers/phy/Kconfig                                |   23 +-
 drivers/phy/Makefile                               |    4 +
 drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
 drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
 drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
 drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
 7 files changed, 995 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
 create mode 100644 drivers/phy/phy-exynos-usb2.c
 create mode 100644 drivers/phy/phy-exynos-usb2.h
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4212-usb2.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
new file mode 100644
index 0000000..c8fbc70
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
@@ -0,0 +1,52 @@
+Samsung S5P/EXYNOS SoC series USB PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be one of the listed compatibles:
+	- "samsung,exynos4210-usbphy"
+	- "samsung,exynos4212-usbphy"
+- reg : a list of registers used by phy driver
+	- first and obligatory is the location of phy modules registers
+	- second and also required is the location of isolation registers
+	  (isolation registers control the physical connection between the in
+	  SoC modules and outside of the SoC, this also can be called enable
+	  control in the documentation of the SoC)
+	- third is the location of the mode switch register, this only applies
+	  to SoCs that have such a feature; mode switching enables to have
+	  both host and device used the same SoC pins and is commonly used
+	  when OTG is supported
+- #phy-cells : from the generic phy bindings, must be 1;
+- clocks and clock-names:
+	- the "phy" clocks is required by the phy module
+	- other clocks are associated by name with their respective phys and
+	  are used to determine the value of the clock settings register
+
+The second cell in the PHY specifier identifies the PHY, its  meaning is
+compatible dependent. For the currently supported SoCs (Exynos 4210 and
+Exynos 4212) it is as follows:
+  0 - USB device,
+  1 - USB host,
+  2 - HSIC0,
+  3 - HSIC1,
+
+Example:
+
+For Exynos 4412 (compatible with Exynos 4212):
+
+exynos_usbphy: exynos-usbphy@125B0000 {
+	compatible = "samsung,exynos4212-usbphy";
+	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
+	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
+							<&clock 2>;
+	clock-names = "phy", "device", "host", "hsic0", "hsic1";
+	status = "okay";
+	#phy-cells = <1>;
+};
+
+Then the PHY can be used in other nodes such as:
+
+ehci@12580000 {
+	status = "okay";
+	phys = <&exynos_usbphy 2>;
+	phy-names = "hsic0";
+};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..bdf0fab 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -14,7 +14,7 @@ config GENERIC_PHY
 	  API by which phy drivers can create PHY using the phy framework and
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
-
+	  
 config PHY_EXYNOS_MIPI_VIDEO
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
 	help
@@ -51,4 +51,25 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config PHY_EXYNOS_USB2
+	tristate "Samsung USB 2.0 PHY driver"
+	help
+	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
+	  This driver provides common interface to interact, for Samsung
+	  USB 2.0 PHY driver.
+
+config PHY_EXYNOS4210_USB2
+	bool "Support for Exynos 4210"
+	depends on PHY_EXYNOS_USB2
+	depends on CPU_EXYNOS4210
+	help
+	  Enable USB PHY support for Exynos 4210
+
+config PHY_EXYNOS4212_USB2
+	bool "Support for Exynos 4212"
+	depends on PHY_EXYNOS_USB2
+	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
+	help
+	  Enable USB PHY support for Exynos 4212
+ 
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index d0caae9..c87bc65 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -7,3 +7,7 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_EXYNOS5250_USB)	+= phy-exynos5250-usb.o
+obj-$(CONFIG_PHY_EXYNOS_USB2)		+= phy-exynos-usb2.o
+obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
+obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
diff --git a/drivers/phy/phy-exynos-usb2.c b/drivers/phy/phy-exynos-usb2.c
new file mode 100644
index 0000000..3e9d525
--- /dev/null
+++ b/drivers/phy/phy-exynos-usb2.c
@@ -0,0 +1,234 @@
+/*
+ * Samsung S5P/EXYNOS SoC series USB PHY driver
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
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include "phy-exynos-usb2.h"
+
+static int exynos_usb2_phy_power_on(struct phy *phy)
+{
+	struct usb2_phy_instance *inst = phy_get_drvdata(phy);
+	struct usb2_phy_driver *drv = inst->drv;
+	int ret;
+
+	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
+							inst->cfg->label);
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		return ret;
+	if (inst->cfg->power_on) {
+		spin_lock(&drv->lock);
+		ret = inst->cfg->power_on(inst);
+		spin_unlock(&drv->lock);
+	}
+	clk_disable_unprepare(drv->clk);
+	return ret;
+}
+
+static int exynos_usb2_phy_power_off(struct phy *phy)
+{
+	struct usb2_phy_instance *inst = phy_get_drvdata(phy);
+	struct usb2_phy_driver *drv = inst->drv;
+	int ret;
+
+	dev_dbg(drv->dev, "Request to power_off \"%s\" usb phy\n",
+							inst->cfg->label);
+	ret = clk_prepare_enable(drv->clk);
+	if (ret)
+		return ret;
+	if (inst->cfg->power_off) {
+		spin_lock(&drv->lock);
+		ret = inst->cfg->power_off(inst);
+		spin_unlock(&drv->lock);
+	}
+	clk_disable_unprepare(drv->clk);
+	return ret;
+}
+
+static struct phy_ops exynos_usb2_phy_ops = {
+	.power_on	= exynos_usb2_phy_power_on,
+	.power_off	= exynos_usb2_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static struct phy *exynos_usb2_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct usb2_phy_driver *drv;
+
+	drv = dev_get_drvdata(dev);
+	if (!drv)
+		return ERR_PTR(-EINVAL);
+
+	if (WARN_ON(args->args[0] >= drv->cfg->num_phys))
+		return ERR_PTR(-ENODEV);
+
+	return drv->usb2_phy_instances[args->args[0]].phy;
+}
+
+static const struct of_device_id exynos_usb2_phy_of_match[];
+
+static int exynos_usb2_phy_probe(struct platform_device *pdev)
+{
+	struct usb2_phy_driver *drv;
+	struct device *dev = &pdev->dev;
+	struct resource *mem;
+	struct phy_provider *phy_provider;
+
+	const struct of_device_id *match;
+	const struct usb2_phy_config *cfg;
+	struct clk *clk;
+
+	int i;
+
+	match = of_match_node(exynos_usb2_phy_of_match, pdev->dev.of_node);
+	if (!match) {
+		dev_err(dev, "of_match_node() failed\n");
+		return -EINVAL;
+	}
+	cfg = match->data;
+	if (!cfg) {
+		dev_err(dev, "Failed to get configuration\n");
+		return -EINVAL;
+	}
+
+	drv = devm_kzalloc(dev, sizeof(struct usb2_phy_driver) +
+		cfg->num_phys * sizeof(struct usb2_phy_instance), GFP_KERNEL);
+
+	if (!drv) {
+		dev_err(dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
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
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	drv->reg_isol = devm_ioremap_resource(dev, mem);
+	if (IS_ERR(drv->reg_isol)) {
+		dev_err(dev, "Failed to map register memory (isolation)\n");
+		return PTR_ERR(drv->reg_isol);
+	}
+
+	if (drv->cfg->has_mode_switch) {
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		drv->reg_mode = devm_ioremap_resource(dev, mem);
+		if (IS_ERR(drv->reg_mode)) {
+			dev_err(dev, "Failed to map register memory (mode switch)\n");
+			return PTR_ERR(drv->reg_mode);
+		}
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev,
+							exynos_usb2_phy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(drv->dev, "Failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
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
+		struct usb2_phy_instance *p = &drv->usb2_phy_instances[i];
+
+		dev_dbg(dev, "Creating phy \"%s\"\n", label);
+		p->phy = devm_phy_create(dev, &exynos_usb2_phy_ops, NULL);
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
+		clk = clk_get(dev, p->cfg->label);
+		if (IS_ERR(clk)) {
+			dev_err(dev, "Failed to get clock of \"%s\" phy\n",
+								p->cfg->label);
+			return PTR_ERR(clk);
+		}
+
+		p->rate = clk_get_rate(clk);
+
+		if (p->cfg->rate_to_clk) {
+			p->clk = p->cfg->rate_to_clk(p->rate);
+			if (p->clk == CLKSEL_ERROR) {
+				dev_err(dev, "Clock rate (%ld) not supported\n",
+								p->rate);
+				clk_put(clk);
+				return -EINVAL;
+			}
+		}
+		clk_put(clk);
+	}
+
+	return 0;
+}
+
+extern const struct usb2_phy_config exynos4210_usb2_phy_config;
+extern const struct usb2_phy_config exynos4212_usb2_phy_config;
+
+static const struct of_device_id exynos_usb2_phy_of_match[] = {
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
+static struct platform_driver exynos_usb2_phy_driver = {
+	.probe	= exynos_usb2_phy_probe,
+	.driver = {
+		.of_match_table	= exynos_usb2_phy_of_match,
+		.name		= "exynos-usb2-phy",
+		.owner		= THIS_MODULE,
+	}
+};
+
+module_platform_driver(exynos_usb2_phy_driver);
+MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
+MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:exynos-usb2-phy");
+
diff --git a/drivers/phy/phy-exynos-usb2.h b/drivers/phy/phy-exynos-usb2.h
new file mode 100644
index 0000000..91e4f73
--- /dev/null
+++ b/drivers/phy/phy-exynos-usb2.h
@@ -0,0 +1,87 @@
+/*
+ * Samsung S5P/EXYNOS SoC series USB PHY driver
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
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#define CLKSEL_ERROR                       -1
+
+#ifndef KHZ
+#define KHZ 1000
+#endif
+
+#ifndef MHZ
+#define MHZ (KHZ * KHZ)
+#endif
+
+enum phy_type {
+	PHY_DEVICE,
+	PHY_HOST,
+};
+
+enum usb2_phy_state {
+	STATE_OFF,
+	STATE_ON,
+};
+
+struct usb2_phy_driver;
+struct usb2_phy_instance;
+struct usb2_phy_config;
+
+struct usb2_phy_instance {
+	struct usb2_phy_driver *drv;
+	struct phy *phy;
+	const struct common_phy *cfg;
+	enum usb2_phy_state state;
+	u32 clk;
+	unsigned long rate;
+};
+
+struct usb2_phy_driver {
+	struct device *dev;
+	spinlock_t lock;
+	void __iomem *reg_phy;
+	void __iomem *reg_isol;
+	void __iomem *reg_mode;
+	const struct usb2_phy_config *cfg;
+	struct clk *clk;
+	struct usb2_phy_instance usb2_phy_instances[0];
+};
+
+struct common_phy {
+	char *label;
+	enum phy_type type;
+	unsigned int id;
+	u32 (*rate_to_clk)(unsigned long);
+	int (*power_on)(struct usb2_phy_instance*);
+	int (*power_off)(struct usb2_phy_instance*);
+};
+
+
+struct usb2_phy_config {
+	int num_phys;
+	const struct common_phy *phys;
+	char has_mode_switch;
+};
+
+#endif
+
diff --git a/drivers/phy/phy-exynos4210-usb2.c b/drivers/phy/phy-exynos4210-usb2.c
new file mode 100644
index 0000000..d04ee8e
--- /dev/null
+++ b/drivers/phy/phy-exynos4210-usb2.c
@@ -0,0 +1,272 @@
+/*
+ * Samsung S5P/EXYNOS SoC series USB PHY driver
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
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include "phy-exynos-usb2.h"
+
+/* Exynos USB PHY registers */
+
+/* PHY power control */
+#define EXYNOS_4210_UPHYPWR			0x0
+
+#define EXYNOS_4210_UPHYPWR_PHY0_SUSPEND	(1 << 0)
+#define EXYNOS_4210_UPHYPWR_PHY0_PWR		(1 << 3)
+#define EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR	(1 << 4)
+#define EXYNOS_4210_UPHYPWR_PHY0_SLEEP		(1 << 5)
+#define EXYNOS_4210_UPHYPWR_PHY0	( \
+	EXYNOS_4210_UPHYPWR_PHY0_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_PHY0_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY0_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_PHY1_SUSPEND	(1 << 6)
+#define EXYNOS_4210_UPHYPWR_PHY1_PWR		(1 << 7)
+#define EXYNOS_4210_UPHYPWR_PHY1_SLEEP		(1 << 8)
+#define EXYNOS_4210_UPHYPWR_PHY1 ( \
+	EXYNOS_4210_UPHYPWR_PHY1_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_PHY1_PWR | \
+	EXYNOS_4210_UPHYPWR_PHY1_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND	(1 << 9)
+#define EXYNOS_4210_UPHYPWR_HSCI0_SLEEP		(1 << 10)
+#define EXYNOS_4210_UPHYPWR_HSCI0 ( \
+	EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND	(1 << 11)
+#define EXYNOS_4210_UPHYPWR_HSCI1_SLEEP		(1 << 12)
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
+#define EXYNOS_4210_UPHYCLK_PHY0_ID_PULLUP	(0x1 << 2)
+#define EXYNOS_4210_UPHYCLK_PHY0_COMMON_ON	(0x1 << 4)
+#define EXYNOS_4210_UPHYCLK_PHY1_COMMON_ON	(0x1 << 7)
+
+/* PHY reset control */
+#define EXYNOS_4210_UPHYRST			0x8
+
+#define EXYNOS_4210_URSTCON_PHY0		(1 << 0)
+#define EXYNOS_4210_URSTCON_OTG_HLINK		(1 << 1)
+#define EXYNOS_4210_URSTCON_OTG_PHYLINK		(1 << 2)
+#define EXYNOS_4210_URSTCON_PHY1_ALL		(1 << 3)
+#define EXYNOS_4210_URSTCON_PHY1_P0		(1 << 4)
+#define EXYNOS_4210_URSTCON_PHY1_P1P2		(1 << 5)
+#define EXYNOS_4210_URSTCON_HOST_LINK_ALL	(1 << 6)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P0	(1 << 7)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P1	(1 << 8)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P2	(1 << 9)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_4210_USB_ISOL_DEVICE_OFFSET	0x0
+#define EXYNOS_4210_USB_ISOL_DEVICE		(1 << 0)
+#define EXYNOS_4210_USB_ISOL_HOST_OFFSET	0x4
+#define EXYNOS_4210_USB_ISOL_HOST		(1 << 0)
+
+/* USBYPHY1 Floating prevention */
+#define EXYNOS_4210_UPHY1CON			0x34
+#define EXYNOS_4210_UPHY1CON_FLOAT_PREVENTION	0x1
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
+static u32 exynos4210_rate_to_clk(unsigned long rate)
+{
+	unsigned int clksel;
+
+	switch (rate) {
+	case 12 * MHZ:
+		clksel = EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 24 * MHZ:
+		clksel = EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 48 * MHZ:
+		clksel = EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ;
+		break;
+	default:
+		clksel = CLKSEL_ERROR;
+	}
+
+	return clksel;
+}
+
+static void exynos4210_isol(struct usb2_phy_instance *inst, bool on)
+{
+	struct usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+	u32 tmp;
+
+	if (!drv->reg_isol)
+		return;
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
+	tmp = readl(drv->reg_isol + offset);
+	if (on)
+		tmp &= ~mask;
+	else
+		tmp |= mask;
+	writel(tmp, drv->reg_isol + offset);
+}
+
+static void exynos4210_phy_pwr(struct usb2_phy_instance *inst, bool on)
+{
+	struct usb2_phy_driver *drv = inst->drv;
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
+		writel(inst->clk, drv->reg_phy + EXYNOS_4210_UPHYCLK);
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
+static int exynos4210_power_on(struct usb2_phy_instance *inst)
+{
+	/* Order of initialisation is important - first power then isolation */
+	exynos4210_phy_pwr(inst, 1);
+	exynos4210_isol(inst, 0);
+
+	return 0;
+}
+
+static int exynos4210_power_off(struct usb2_phy_instance *inst)
+{
+	exynos4210_isol(inst, 1);
+	exynos4210_phy_pwr(inst, 0);
+
+	return 0;
+}
+
+
+static const struct common_phy exynos4210_phys[] = {
+	{
+		.label		= "device",
+		.type		= PHY_DEVICE,
+		.id		= EXYNOS4210_DEVICE,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "host",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4210_HOST,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4210_HSIC0,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4210_HSIC1,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos4210_power_on,
+		.power_off	= exynos4210_power_off,
+	},
+	{},
+};
+
+const struct usb2_phy_config exynos4210_usb2_phy_config = {
+	.num_phys		= EXYNOS4210_NUM_PHYS,
+	.phys			= exynos4210_phys,
+	.has_mode_switch	= 1,
+};
+
diff --git a/drivers/phy/phy-exynos4212-usb2.c b/drivers/phy/phy-exynos4212-usb2.c
new file mode 100644
index 0000000..654efe0
--- /dev/null
+++ b/drivers/phy/phy-exynos4212-usb2.c
@@ -0,0 +1,324 @@
+/*
+ * Samsung S5P/EXYNOS SoC series USB PHY driver
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
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include "phy-exynos-usb2.h"
+
+/* Exynos USB PHY registers */
+
+/* PHY power control */
+#define EXYNOS_4212_UPHYPWR			0x0
+
+#define EXYNOS_4212_UPHYPWR_DEV_SUSPEND		(1 << 0)
+#define EXYNOS_4212_UPHYPWR_DEV_PWR		(1 << 3)
+#define EXYNOS_4212_UPHYPWR_DEV_OTG_PWR		(1 << 4)
+#define EXYNOS_4212_UPHYPWR_DEV_SLEEP		(1 << 5)
+#define EXYNOS_4212_UPHYPWR_DEV	( \
+	EXYNOS_4212_UPHYPWR_DEV_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_DEV_PWR | \
+	EXYNOS_4212_UPHYPWR_DEV_OTG_PWR | \
+	EXYNOS_4212_UPHYPWR_DEV_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HOST_SUSPEND	(1 << 6)
+#define EXYNOS_4212_UPHYPWR_HOST_PWR		(1 << 7)
+#define EXYNOS_4212_UPHYPWR_HOST_SLEEP		(1 << 8)
+#define EXYNOS_4212_UPHYPWR_HOST ( \
+	EXYNOS_4212_UPHYPWR_HOST_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HOST_PWR | \
+	EXYNOS_4212_UPHYPWR_HOST_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND	(1 << 9)
+#define EXYNOS_4212_UPHYPWR_HSCI0_PWR		(1 << 10)
+#define EXYNOS_4212_UPHYPWR_HSCI0_SLEEP		(1 << 11)
+#define EXYNOS_4212_UPHYPWR_HSCI0 ( \
+	EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HSCI0_PWR | \
+	EXYNOS_4212_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND	(1 << 12)
+#define EXYNOS_4212_UPHYPWR_HSCI1_PWR		(1 << 13)
+#define EXYNOS_4212_UPHYPWR_HSCI1_SLEEP		(1 << 14)
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
+#define EXYNOS_4212_UPHYCLK_PHY0_ID_PULLUP	(0x1 << 3)
+#define EXYNOS_4212_UPHYCLK_PHY0_COMMON_ON	(0x1 << 4)
+#define EXYNOS_4212_UPHYCLK_PHY1_COMMON_ON	(0x1 << 7)
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
+#define EXYNOS_4212_URSTCON_DEVICE		(1 << 0)
+#define EXYNOS_4212_URSTCON_OTG_HLINK		(1 << 1)
+#define EXYNOS_4212_URSTCON_OTG_PHYLINK		(1 << 2)
+#define EXYNOS_4212_URSTCON_HOST_PHY		(1 << 3)
+#define EXYNOS_4212_URSTCON_PHY1		(1 << 4)
+#define EXYNOS_4212_URSTCON_HSIC0		(1 << 5)
+#define EXYNOS_4212_URSTCON_HSIC1		(1 << 6)
+#define EXYNOS_4212_URSTCON_HOST_LINK_ALL	(1 << 7)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P0	(1 << 8)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P1	(1 << 9)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P2	(1 << 10)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_4212_USB_ISOL_OFFSET		0x0
+#define EXYNOS_4212_USB_ISOL_OTG		(1 << 0)
+#define EXYNOS_4212_USB_ISOL_HSIC0_OFFSET	0x4
+#define EXYNOS_4212_USB_ISOL_HSIC0		(1 << 0)
+#define EXYNOS_4212_USB_ISOL_HSIC1_OFFSET	0x8
+#define EXYNOS_4212_USB_ISOL_HSIC1		(1 << 0)
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
+static u32 exynos4212_rate_to_clk(unsigned long rate)
+{
+	unsigned int clksel;
+
+	/* EXYNOS_4212_UPHYCLK_PHYFSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		clksel = EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ;
+		break;
+	default:
+		clksel = CLKSEL_ERROR;
+	}
+
+	return clksel;
+}
+
+static void exynos4212_isol(struct usb2_phy_instance *inst, bool on)
+{
+	struct usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+	u32 tmp;
+
+	if (!drv->reg_isol)
+		return;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4212_DEVICE:
+		offset = EXYNOS_4212_USB_ISOL_OFFSET;
+		mask = EXYNOS_4212_USB_ISOL_OTG;
+		break;
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
+	tmp = readl(drv->reg_isol + offset);
+	if (on)
+		tmp &= ~mask;
+	else
+		tmp |= mask;
+	writel(tmp, drv->reg_isol + offset);
+}
+
+static void exynos4212_phy_pwr(struct usb2_phy_instance *inst, bool on)
+{
+	struct usb2_phy_driver *drv = inst->drv;
+	u32 rstbits = 0;
+	u32 phypwr = 0;
+	u32 rst;
+	u32 pwr;
+
+	switch (inst->cfg->id) {
+	case EXYNOS4212_DEVICE:
+		phypwr =	EXYNOS_4212_UPHYPWR_DEV;
+		rstbits =	EXYNOS_4212_URSTCON_DEVICE;
+		break;
+	case EXYNOS4212_HOST:
+		phypwr =	EXYNOS_4212_UPHYPWR_HOST;
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
+		writel(inst->clk, drv->reg_phy + EXYNOS_4212_UPHYCLK);
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
+static int exynos4212_power_on(struct usb2_phy_instance *inst)
+{
+	struct usb2_phy_driver *drv = inst->drv;
+
+	inst->state = STATE_ON;
+	exynos4212_phy_pwr(inst, 1);
+	exynos4212_isol(inst, 0);
+
+	/* Power on the device, as it is necessary for HSIC to work */
+	if (inst->cfg->id == EXYNOS4212_HSIC0) {
+		struct usb2_phy_instance *device =
+					&drv->usb2_phy_instances[EXYNOS4212_DEVICE];
+		exynos4212_phy_pwr(device, 1);
+		exynos4212_isol(device, 0);
+	}
+
+	return 0;
+}
+
+static int exynos4212_power_off(struct usb2_phy_instance *inst)
+{
+	struct usb2_phy_driver *drv = inst->drv;
+	struct usb2_phy_instance *device =
+		&drv->usb2_phy_instances[EXYNOS4212_DEVICE];
+
+	inst->state = STATE_OFF;
+	exynos4212_isol(inst, 1);
+	exynos4212_phy_pwr(inst, 0);
+
+	if (inst->cfg->id == EXYNOS4212_HSIC0 && device->state != STATE_ON) {
+		exynos4212_isol(device, 1);
+		exynos4212_phy_pwr(device, 0);
+	}
+
+	return 0;
+}
+
+
+static const struct common_phy exynos4212_phys[] = {
+	{
+		.label		= "device",
+		.type		= PHY_DEVICE,
+		.id		= EXYNOS4212_DEVICE,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "host",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4212_HOST,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4212_HSIC0,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.type		= PHY_HOST,
+		.id		= EXYNOS4212_HSIC1,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos4212_power_on,
+		.power_off	= exynos4212_power_off,
+	},
+	{},
+};
+
+const struct usb2_phy_config exynos4212_usb2_phy_config = {
+	.num_phys		= EXYNOS4212_NUM_PHYS,
+	.phys			= exynos4212_phys,
+	.has_mode_switch	= 1,
+};
+
-- 
1.7.9.5

