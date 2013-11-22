Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3KVPvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:51:42 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11262 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3KVPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:51:25 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-1e-528f7d7ac31e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 4/5] regulator: max14577: Add regulator driver for Maxim
 14577
Date: Fri, 22 Nov 2013 16:51:08 +0100
Message-id: <1385135469-27044-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
References: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xy7pVtf1BBs+3cVoc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS1evzC0ONv0ht3i/tejjBbfrnQwWWx6
	fI3VYmHbEhaLy7vmsFmsPXKX3eJ24wo2iwnT17JYHF5xgMli3cvpLBanu1ktXh1sY3EQ81gz
	bw2jx4LPV9g9JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7WHzmHcy0GPzknqP
	vi2rGD0+b5Lz2Dg3NIAvissmJTUnsyy1SN8ugSvjz8uPLAVtIRU7t19jbmD85NrFyMkhIWAi
	sef1VlYIW0ziwr31bF2MXBxCAksZJWZeb2SCcPqYJCa8vwpWxSZgLLF5+RKwKhGBOawSu888
	YwFxmAWOMkq87dzFBFIlLBAs0f5tOiOIzSKgKvF39RkWEJtXwF1i77/HQHEOoH0KEnMm2YCE
	OQU8JB41LAQLCwGV9K93nMDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSOR83cG4
	9JjVIUYBDkYlHt4dln1BQqyJZcWVuYcYJTiYlUR475X3BwnxpiRWVqUW5ccXleakFh9iZOLg
	lGpgDEyxaunqfaFRVBxxzjbpurt999QEd57QWU7dr6553p7UO/2qxdaf348dF+512hHqVrug
	1jn4wO1tZbX1Uy9nb0739vtRd/0/z8MPebf2J1Tf+u957WDLz6PhHA9zLkQfXPt+xdyyZRV2
	dceENsk6W0Xnrb36wr8qaMOC5LV/Hwvqp1xexJG3V4mlOCPRUIu5qDgRAHRMM0N6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX14577 chip is a multi-function device which includes MUIC,
charger and voltage regulator. The driver is located in drivers/mfd.

This patch adds regulator driver for MAX14577 chip. There are two
regulators in this chip:
1. Safeout LDO with constant voltage output of 4.9V. It can be only
   enabled or disabled.
2. Current regulator for the charger. It provides current from 90mA up
   to 950mA.
Driver supports Device Tree.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max14577.c       |    3 +-
 drivers/regulator/Kconfig    |    7 ++
 drivers/regulator/Makefile   |    1 +
 drivers/regulator/max14577.c |  268 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 278 insertions(+), 1 deletion(-)
 create mode 100644 drivers/regulator/max14577.c

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 94b766d..d841f2a 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -26,7 +26,8 @@
 
 static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-muic", },
-	{ .name = "max14577-regulator", },
+	{ .name = "max14577-regulator",
+		.of_compatible = "maxim,max14577-regulator", },
 	{ .name = "max14577-charger", },
 };
 
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ce785f4..11ee053 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -249,6 +249,13 @@ config REGULATOR_LP8788
 	help
 	  This driver supports LP8788 voltage regulator chip.
 
+config REGULATOR_MAX14577
+	tristate "Maxim 14577 regulator"
+	depends on MFD_MAX14577
+	help
+	  This driver controls a Maxim 14577 regulator via I2C bus.
+	  The regulators include safeout LDO and current regulator 'CHARGER'.
+
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 01c597e..654bd43 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-buck.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-ldo.o
 obj-$(CONFIG_REGULATOR_LP8755) += lp8755.o
+obj-$(CONFIG_REGULATOR_MAX14577) += max14577.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
new file mode 100644
index 0000000..7126b96
--- /dev/null
+++ b/drivers/regulator/max14577.c
@@ -0,0 +1,268 @@
+/*
+ * max14577.c - Regulator driver for the Maxim 14577
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/max14577.h>
+#include <linux/mfd/max14577-private.h>
+#include <linux/regulator/of_regulator.h>
+
+struct max14577_regulator {
+	struct device *dev;
+	struct max14577 *max14577;
+	struct regulator_dev **regulators;
+};
+
+static int max14577_reg_is_enabled(struct regulator_dev *rdev)
+{
+	int rid = rdev_get_id(rdev);
+	struct regmap *rmap = rdev->regmap;
+	u8 reg_data;
+
+	switch (rid) {
+	case MAX14577_CHARGER:
+		max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2, &reg_data);
+		if ((reg_data & CHGCTRL2_MBCHOSTEN_MASK) == 0)
+			return 0;
+		max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
+		if ((reg_data & STATUS3_CGMBC_MASK) == 0)
+			return 0;
+		/* MBCHOSTEN and CGMBC are on */
+		return 1;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
+{
+	u8 reg_data;
+	struct regmap *rmap = rdev->regmap;
+
+	if (rdev_get_id(rdev) != MAX14577_CHARGER)
+		return -EINVAL;
+
+	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL4, &reg_data);
+
+	if ((reg_data & CHGCTRL4_MBCICHWRCL_MASK) == 0)
+		return MAX14577_REGULATOR_CURRENT_LIMIT_MIN;
+
+	reg_data = ((reg_data & CHGCTRL4_MBCICHWRCH_MASK) >>
+			CHGCTRL4_MBCICHWRCH_SHIFT);
+	return MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
+		reg_data * MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP;
+}
+
+static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
+		int min_uA, int max_uA)
+{
+	int i, current_bits = 0xf;
+	u8 reg_data;
+
+	if (rdev_get_id(rdev) != MAX14577_CHARGER)
+		return -EINVAL;
+
+	if (min_uA > MAX14577_REGULATOR_CURRENT_LIMIT_MAX ||
+			max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_MIN)
+		return -EINVAL;
+
+	if (max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START) {
+		/* Less than 200 mA, so set 90mA (turn only Low Bit off) */
+		u8 reg_data = 0x0 << CHGCTRL4_MBCICHWRCL_SHIFT;
+		return max14577_update_reg(rdev->regmap,
+				MAX14577_CHG_REG_CHG_CTRL4,
+				CHGCTRL4_MBCICHWRCL_MASK, reg_data);
+	}
+
+	/* max_uA is in range: <LIMIT_HIGH_START, inifinite>, so search for
+	 * valid current starting from LIMIT_MAX. */
+	for (i = MAX14577_REGULATOR_CURRENT_LIMIT_MAX;
+			i >= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START;
+			i -= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP) {
+		if (i <= max_uA)
+			break;
+		current_bits--;
+	}
+	BUG_ON(current_bits < 0); /* Cannot happen */
+	/* Turn Low Bit on (use range 200mA-950 mA) */
+	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
+	/* and set proper High Bits */
+	reg_data |= current_bits << CHGCTRL4_MBCICHWRCH_SHIFT;
+
+	return max14577_update_reg(rdev->regmap, MAX14577_CHG_REG_CHG_CTRL4,
+			CHGCTRL4_MBCICHWRCL_MASK | CHGCTRL4_MBCICHWRCH_MASK,
+			reg_data);
+}
+
+static struct regulator_ops max14577_safeout_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+};
+
+static struct regulator_ops max14577_charger_ops = {
+	.is_enabled		= max14577_reg_is_enabled,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_current_limit	= max14577_reg_get_current_limit,
+	.set_current_limit	= max14577_reg_set_current_limit,
+};
+
+static const struct regulator_desc supported_regulators[] = {
+	[MAX14577_SAFEOUT] = {
+		.name = "SAFEOUT",
+		.id = MAX14577_SAFEOUT,
+		.ops = &max14577_safeout_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.n_voltages = 1,
+		.min_uV = MAX14577_REGULATOR_SAFEOUT_VOLTAGE,
+		.enable_reg = MAX14577_REG_CONTROL2,
+		.enable_mask = CTRL2_SFOUTORD_MASK,
+	},
+	[MAX14577_CHARGER] = {
+		.name = "CHARGER",
+		.id = MAX14577_CHARGER,
+		.ops = &max14577_charger_ops,
+		.type = REGULATOR_CURRENT,
+		.owner = THIS_MODULE,
+		.enable_reg = MAX14577_CHG_REG_CHG_CTRL2,
+		.enable_mask = CHGCTRL2_MBCHOSTEN_MASK,
+	},
+};
+
+#ifdef CONFIG_OF
+static struct of_regulator_match max14577_regulator_matches[] = {
+	{ .name	= "SAFEOUT", },
+	{ .name = "CHARGER", },
+};
+
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
+{
+	int ret;
+	struct device_node *np = pdev->dev.of_node;
+
+	ret = of_regulator_match(&pdev->dev, np, max14577_regulator_matches,
+			MAX14577_REG_MAX);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline struct regulator_init_data *match_init_data(int index)
+{
+	return max14577_regulator_matches[index].init_data;
+}
+
+static inline struct device_node *match_of_node(int index)
+{
+	return max14577_regulator_matches[index].of_node;
+}
+#else /* CONFIG_OF */
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
+{
+	return 0;
+}
+static inline struct regulator_init_data *match_init_data(int index)
+{
+	return NULL;
+}
+
+static inline struct device_node *match_of_node(int index)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
+
+static int max14577_regulator_probe(struct platform_device *pdev)
+{
+	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np = pdev->dev.of_node;
+	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
+	int i;
+	struct regulator_config config = {};
+
+	if (np) {
+		int ret = max14577_regulator_dt_parse_pdata(pdev);
+		if (ret)
+			return ret;
+	}
+
+	config.dev = &pdev->dev;
+	config.regmap = max14577->regmap;
+
+	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
+		struct regulator_dev *regulator;
+		/*
+		 * Index of supported_regulators[] is also the id and must
+		 * match index of pdata->regulators[].
+		 */
+		if (pdata && pdata->regulators) {
+			config.init_data = pdata->regulators[i].initdata;
+			config.of_node = pdata->regulators[i].of_node;
+		} else {
+			config.init_data = match_init_data(i);
+			config.of_node = match_of_node(i);
+		}
+
+		regulator = devm_regulator_register(&pdev->dev,
+				&supported_regulators[i], &config);
+		if (IS_ERR(regulator)) {
+			int ret = PTR_ERR(regulator);
+			dev_err(&pdev->dev,
+					"Regulator init failed for ID %d with error: %d\n",
+					i, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct platform_driver max14577_regulator_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = "max14577-regulator",
+		   },
+	.probe	= max14577_regulator_probe,
+};
+
+static int __init max14577_regulator_init(void)
+{
+	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
+			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
+	BUILD_BUG_ON(ARRAY_SIZE(supported_regulators) != MAX14577_REG_MAX);
+	return platform_driver_register(&max14577_regulator_driver);
+}
+subsys_initcall(max14577_regulator_init);
+
+static void __exit max14577_regulator_exit(void)
+{
+	platform_driver_unregister(&max14577_regulator_driver);
+}
+module_exit(max14577_regulator_exit);
+
+MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
+MODULE_DESCRIPTION("MAXIM 14577 regulator driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

