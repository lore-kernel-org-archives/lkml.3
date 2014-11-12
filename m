Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaKLMJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:09:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13238 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaKLMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:08:31 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-95-54634dbba894
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v3 2/5] regulator: rt5033: Add RT5033 Regulator device driver
Date: Wed, 12 Nov 2014 21:07:59 +0900
Message-id: <1415794082-30277-3-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
References: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRHe3b3KIwcy5ShanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	6Jncy1LwxqDi8+f3TA2MTzW6GDk5JARMJDbvaGSDsMUkLtxbD2RzcQgJLGWU6GqYwQRTtKHj
	AztEYjqjxMlXb1kgnDYmibsXD7ODVLEJaEq8n3KFBcQWEYiQOLtsFlgRs8AkZombb3sYQRLC
	Ar4STy/2s4LYLAKqEk/6z4LFeQXcJE5PO8HcxcgBtE5BYs4kG5Awp4C7xOyvV8BKhIBKjrW0
	MIHMlBCYySHR/m8/O8QcAYlvkw+xQPTKSmw6wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJRe
	ZKJXnJhbXJqXrpecn7uJERiVp/89m7CD8d4B60OMAhyMSjy8CWuSQoRYE8uKK3MPMZoCbZjI
	LCWanA+M/bySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTBOFYpg6k4KD1tg/Dx0V3Z6bJrH30lzYts/q7bOYfC91Hx3IVfo1YhPqn9u/Fjrvk5Odulr
	7edVeqlGv6wfRMkuvVwjbeHw/cH2w4fYOiRnlLNyO0foGMytFNcJ/SyzLSd3TZtX8l6+7IKF
	8SkdglrdD/QVGNfLbrX/lXpbqP3i1jeLlXQ2nFViKc5INNRiLipOBACujBSWxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd3dvskhBntniluc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0bP5F6WgjcGFZ8/v2dqYHyq0cXIySEhYCKxoeMDO4Qt
	JnHh3nq2LkYuDiGB6YwSJ1+9ZYFw2pgk7l48DFbFJqAp8X7KFRYQW0QgQuLssllgRcwCk5gl
	br7tYQRJCAv4Sjy92M8KYrMIqEo86T8LFucVcJM4Pe0EcxcjB9A6BYk5k2xAwpwC7hKzv14B
	KxECKjnW0sI0gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgmH8mtYNxZYPFIUYB
	DkYlHl5Oh+QQIdbEsuLK3EOMEhzMSiK8112BQrwpiZVVqUX58UWlOanFhxhNgY6ayCwlmpwP
	TEd5JfGGxiZmRpZG5oYWRsbmSuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoY5/z4HZFrk2i+
	Ufu1QvOMo/7LfNcLFv31KCh8t2HFYUnJRdsuXYo66zVp6nHt/aY/Trw5mxp0U/X41c4TfndC
	5oZIC2qrfxLRZT81q3Bn+IP7K00n7RJx3Xq47gc370uN6Ua/voeaH5fxU7M0Cg7ZXDVR2/Kg
	+c25oUyuvS9nihvG5jGdkm/wV2Ipzkg01GIuKk4EAPuRXXEPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add device driver of Richtek RT5033 PMIC.
The driver support multiple regulator like LDO and synchronous Buck.
The integrated synchronous buck converter is designed to provide 0.6 A
application with high efficiency. Two LDOs are integrated. One safe LDO is
for 60mA and the other one LDO is for 150 mA.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes in v3:
- Add author information the top of driver.

Changes in v2:
- Remove unnecessary device specific code.
---
 drivers/regulator/Kconfig            |    8 +++
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/rt5033-regulator.c |  123 ++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+)
 create mode 100644 drivers/regulator/rt5033-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 55d7b7b..8558e1b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -521,6 +521,14 @@ config REGULATOR_RN5T618
 	help
 	  Say y here to support the regulators found on Ricoh RN5T618 PMIC.
 
+config REGULATOR_RT5033
+	tristate "Richtek RT5033 Regulators"
+	depends on MFD_RT5033
+	help
+	  This adds support for voltage and current regulators in Richtek
+	  RT5033 PMIC. The device supports multiple regulators like
+	  current source, LDO and Buck.
+
 config REGULATOR_S2MPA01
 	tristate "Samsung S2MPA01 voltage regulator"
 	depends on MFD_SEC_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 1029ed3..1f28ebf 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
 obj-$(CONFIG_REGULATOR_RN5T618) += rn5t618-regulator.o
+obj-$(CONFIG_REGULATOR_RT5033)	+= rt5033-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
diff --git a/drivers/regulator/rt5033-regulator.c b/drivers/regulator/rt5033-regulator.c
new file mode 100644
index 0000000..870cc49
--- /dev/null
+++ b/drivers/regulator/rt5033-regulator.c
@@ -0,0 +1,123 @@
+/*
+ * Regulator driver for the Richtek RT5033
+ *
+ * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
+ * Author: Beomho Seo <beomho.seo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published bythe Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/rt5033.h>
+#include <linux/mfd/rt5033-private.h>
+#include <linux/regulator/of_regulator.h>
+
+static struct regulator_ops rt5033_safe_ldo_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+};
+
+static struct regulator_ops rt5033_buck_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+};
+
+static const struct regulator_desc rt5033_supported_regulators[] = {
+	[RT5033_BUCK] = {
+		.name		= "BUCK",
+		.id		= RT5033_BUCK,
+		.ops		= &rt5033_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM,
+		.min_uV		= RT5033_REGULATOR_BUCK_VOLTAGE_MIN,
+		.uV_step	= RT5033_REGULATOR_BUCK_VOLTAGE_STEP,
+		.enable_reg	= RT5033_REG_CTRL,
+		.enable_mask	= RT5033_CTRL_EN_BUCK_MASK,
+		.vsel_reg	= RT5033_REG_BUCK_CTRL,
+		.vsel_mask	= RT5033_BUCK_CTRL_MASK,
+	},
+	[RT5033_LDO] = {
+		.name		= "LDO",
+		.id		= RT5033_LDO,
+		.ops		= &rt5033_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM,
+		.min_uV		= RT5033_REGULATOR_LDO_VOLTAGE_MIN,
+		.uV_step	= RT5033_REGULATOR_LDO_VOLTAGE_STEP,
+		.enable_reg	= RT5033_REG_CTRL,
+		.enable_mask	= RT5033_CTRL_EN_LDO_MASK,
+		.vsel_reg	= RT5033_REG_LDO_CTRL,
+		.vsel_mask	= RT5033_LDO_CTRL_MASK,
+	},
+	[RT5033_SAFE_LDO] = {
+		.name		= "SAFE_LDO",
+		.id		= RT5033_SAFE_LDO,
+		.ops		= &rt5033_safe_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= 1,
+		.min_uV		= RT5033_REGULATOR_SAFE_LDO_VOLTAGE,
+		.enable_reg	= RT5033_REG_CTRL,
+		.enable_mask	= RT5033_CTRL_EN_SAFE_LDO_MASK,
+	},
+};
+
+static int rt5033_regulator_probe(struct platform_device *pdev)
+{
+	struct rt5033_dev *rt5033 = dev_get_drvdata(pdev->dev.parent);
+	int ret, i;
+	struct regulator_config config = {};
+
+	config.dev = &pdev->dev;
+	config.driver_data = rt5033;
+
+	for (i = 0; i < ARRAY_SIZE(rt5033_supported_regulators); i++) {
+		struct regulator_dev *regulator;
+
+		config.regmap = rt5033->regmap;
+
+		regulator = devm_regulator_register(&pdev->dev,
+				&rt5033_supported_regulators[i], &config);
+		if (IS_ERR(regulator)) {
+			ret = PTR_ERR(regulator);
+			dev_err(&pdev->dev,
+				"Regulator init failed %d: with error: %d\n",
+				i, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct platform_device_id rt5033_regulator_id[] = {
+	{ "rt5033-regulator", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, rt5033_regulator_id);
+
+static struct platform_driver rt5033_regulator_driver = {
+	.driver = {
+		.name = "rt5033-regulator",
+	},
+	.probe		= rt5033_regulator_probe,
+	.id_table	= rt5033_regulator_id,
+};
+module_platform_driver(rt5033_regulator_driver);
+
+MODULE_DESCRIPTION("Richtek RT5033 Regulator driver");
+MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

