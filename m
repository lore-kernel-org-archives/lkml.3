Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaKJHUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:20:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKJHT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:19:57 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-71-54606715caff
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 2/5] regulator: rt5033: Add RT5033 Regulator device driver
Date: Mon, 10 Nov 2014 16:19:44 +0900
Message-id: <1415603987-32475-3-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
References: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkRFc0PSHE4Esvt8XpT9vYLaY+fMJm
	cf3Lc1aL+UfOsVr8mdDKZjHp/gQWi29XOpgsLu+aw2bxufcIo8WMyS/ZHLg8ds66y+6xaVUn
	m0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlPHz9l71gqUHF/eZtzA2M6zS6GDk5JARMJM7f
	P8QCYYtJXLi3nq2LkYtDSGApo8SR442MMEVvJ3QxQiQWMUoca1jLDOG0MUl8vnSZCaSKTUBT
	4v2UK2CjRAQiJM4um8UCUsQscJ5R4kzvfrBRwgK+Es9m7GYGsVkEVCVOXZ3FBmLzCrhJdF9u
	A7I5gNYpSMyZZAMS5hRwl7g9cwdYiRBQydWZP8HOkxBYxy6xt7ODFWKOgMS3ySA/gPTKSmw6
	wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERj8p/89m7CD8d4B
	60OMAhyMSjy8Dm/jQ4RYE8uKK3MPMZoCbZjILCWanA+MsbySeENjMyMLUxNTYyNzSzMlcd7X
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC6O9WvcfPYuclkgvmClwHf/M5K37VJXGlh
	q9J4oPAxo5icucSy6kOaL1RnOF6NFlPM4vgkGvFuzrtcLr9lm0V+1FRF9l/9eUbsOXPbszPb
	XrgGv120aKH9up/visxqp6yy/JLGKrz27+fa1q7iVRt9M9l3/FBaH/tMIHbTJ/0Ty/ZHaTlY
	tvErsRRnJBpqMRcVJwIA4l7UcXkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAV3R9IQQgxeXGC1Of9rGbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWHy70sFkcXnXHDaLz71HGC1mTH7J5sDlsXPWXXaPTas6
	2Tz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bD13/Z
	C5YaVNxv3sbcwLhOo4uRk0NCwETi7YQuRghbTOLCvfVsXYxcHEICixgljjWsZYZw2pgkPl+6
	zARSxSagKfF+yhUWEFtEIELi7LJZLCBFzALnGSXO9O4HGyUs4CvxbMZuZhCbRUBV4tTVWWwg
	Nq+Am0T35TYgmwNonYLEnEk2IGFOAXeJ2zN3gJUIAZVcnfmTbQIj7wJGhlWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwbH1TGoH48oGi0OMAhyMSjy8Dm/jQ4RYE8uKK3MPMUpwMCuJ8Nb+
	BwrxpiRWVqUW5ccXleakFh9iNAU6aiKzlGhyPjDu80riDY1NzIwsjcwNLYyMzZXEeQ+0WgcK
	CaQnlqRmp6YWpBbB9DFxcEo1MHJxTX/b+GOatNSOzZszj71hZK3QyFHm8LIxnHDAZpr310sO
	Z/0qNst5MSzIe7Jh96qnvBX/Lu/+H7h6ooq/iYT8x46CgBmp221sVTM7c/qnPkotfb3k7L/1
	P21OCCR7X5PmWqJrc+/rktNfnx1uP8kXL+Fgb3f4jcA3yd64/OBgyeXv21XOLlBiKc5INNRi
	LipOBADYWHO9wwIAAA==
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
index 0000000..782ba2d
--- /dev/null
+++ b/drivers/regulator/rt5033-regulator.c
@@ -0,0 +1,123 @@
+/*
+ * Regulator driver for the Richtek RT5033
+ *
+ * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
+ * Beomho Seo <beomho.seo@samsung.com>
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

