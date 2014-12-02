Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaLBNlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:41:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58038 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaLBNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:39:58 -0500
X-AuditID: cbfee68f-f791c6d000004834-b5-547dc1292f9b
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
Subject: [PATCH v7 2/4] power: rt5033_battery: Add RT5033 Fuel gauge device
 driver
Date: Tue, 02 Dec 2014 22:39:49 +0900
Message-id: <1417527591-20450-3-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417527591-20450-1-git-send-email-beomho.seo@samsung.com>
References: <1417527591-20450-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQFfzYG2Iwfl5WhanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	uPl5M0vBf8uKZR8/MTUw3jHoYuTkkBAwkfhxejYLhC0mceHeerYuRi4OIYGljBLfLz9lhyk6
	e7aRESKxiFHi9ZrFTBBOG5PEpHdrmECq2AQ0Jd5PuQI2SkQgQuLsslksIEXMApOYJW6+7QFq
	5+AQFgiRmP7JC6SGRUBVYnbLA7BeXgE3iUPTF7CDlEgIKEjMmWQDEuYUcJc4dacFrFMIqOTr
	B16Ie+ZySNztioKYIiDxbfIhFohOWYlNB5ghSiQlDq64wTKBUXgBI8MqRtHUguSC4qT0ImO9
	4sTc4tK8dL3k/NxNjMB4PP3vWf8OxrsHrA8xCnAwKvHwnjhfEyLEmlhWXJl7iNEUaMNEZinR
	5Hxg1OeVxBsamxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx
	Z+71LdefL3zBXZegm8e2Un0f2/7VjguUt7/elKDaukiW53veAreMNXrsUqs9ZgV+Cmu13mtz
	puOgap7Tm+1bXVrvMyWc2DldfdIt26Ql71jNfGSFFt+XCN68ct60zK/FJw4fVvWy5nq79Y5R
	9ZITt3Wer9fZ9zjBcr+HieLpw96ij1M9H4ubKbEUZyQaajEXFScCAHg9FZfCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAV3Ng7UhBq1H5C1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFdXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9J2SQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMePm580sBf8tK5Z9/MTUwHjHoIuRk0NCwETi7NlGRghb
	TOLCvfVsXYxcHEICixglXq9ZzAThtDFJTHq3hgmkik1AU+L9lCssILaIQITE2WWzWECKmAUm
	MUvcfNsDNIqDQ1ggRGL6Jy+QGhYBVYnZLQ/AenkF3CQOTV/ADlIiIaAgMWeSDUiYU8Bd4tSd
	FrBOIaCSrx94JzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHO/PpHcwrmqwOMQo
	wMGoxMN74nxNiBBrYllxZe4hRgkOZiUR3l/GtSFCvCmJlVWpRfnxRaU5qcWHGE2BbprILCWa
	nA9MRXkl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBKNTA65Eg4v93w
	uHGXFGviLe6zB/QWJlXyen94U5xnvOX5bPNrJl/KmGfwdR9h211YbVh+VuZXV+anOD0Ozelb
	j6tHugil8v0ODDjOrrK19ODt2FJ+ru1n/kdq2n7I/PbGl++OeNrJT1MDNFTffuC9F7jG1pFv
	3aG6kESP9kVzmM5EP3Iu4lzwqkKJpTgj0VCLuag4EQAilsU2DQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device driver of Richtek PMIC.
The driver support battery fuel gange. Fuel gauge calculates and determines the
battery state of charge(SOC) according to battery open circuit voltage(OCV).
Also, this driver provides battery average voltage, voltage and bettery present
property.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes in v7:
Changes in v6:
Changes in v5:
Changes in v4:
- none.

Changes in v3:
- Add author information the top of driver.

Changes in v2:
- Remove volatile_reg callback. Because this driver not in use regmap cache.
- Fix wrong register name.
---

 drivers/power/Kconfig          |    8 ++
 drivers/power/Makefile         |    1 +
 drivers/power/rt5033_battery.c |  177 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 drivers/power/rt5033_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0108c2a..da6981f 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -397,6 +397,14 @@ config BATTERY_GOLDFISH
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
 
+config BATTERY_RT5033
+	tristate "RT5033 fuel gauge support"
+	depends on MFD_RT5033
+	help
+	  This adds support for battery fuel gauge in Richtek RT5033 PMIC.
+	  The fuelgauge calculates and determines the battery state of charge
+	  according to battery open circuit voltage.
+
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index dfa8942..b83a0c7 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
+obj-$(CONFIG_BATTERY_RT5033)	+= rt5033_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_BATTERY_TWL4030_MADC)	+= twl4030_madc_battery.o
 obj-$(CONFIG_CHARGER_88PM860X)	+= 88pm860x_charger.o
diff --git a/drivers/power/rt5033_battery.c b/drivers/power/rt5033_battery.c
new file mode 100644
index 0000000..7b898f4
--- /dev/null
+++ b/drivers/power/rt5033_battery.c
@@ -0,0 +1,177 @@
+/*
+ * Fuel gauge driver for Richtek RT5033
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
+#include <linux/power_supply.h>
+#include <linux/mfd/rt5033-private.h>
+#include <linux/mfd/rt5033.h>
+
+static int rt5033_battery_get_capacity(struct i2c_client *client)
+{
+	struct rt5033_battery *battery = i2c_get_clientdata(client);
+	u32 msb;
+
+	regmap_read(battery->regmap, RT5033_FUEL_REG_SOC_H, &msb);
+
+	return msb;
+}
+
+static int rt5033_battery_get_present(struct i2c_client *client)
+{
+	struct rt5033_battery *battery = i2c_get_clientdata(client);
+	u32 val;
+
+	regmap_read(battery->regmap, RT5033_FUEL_REG_CONFIG_L, &val);
+
+	return (val & RT5033_FUEL_BAT_PRESENT) ? true : false;
+}
+
+static int rt5033_battery_get_watt_prop(struct i2c_client *client,
+		enum power_supply_property psp)
+{
+	struct rt5033_battery *battery = i2c_get_clientdata(client);
+	unsigned int regh, regl;
+	int ret;
+	u32 msb, lsb;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		regh = RT5033_FUEL_REG_VBAT_H;
+		regl = RT5033_FUEL_REG_VBAT_L;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		regh = RT5033_FUEL_REG_AVG_VOLT_H;
+		regl = RT5033_FUEL_REG_AVG_VOLT_L;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		regh = RT5033_FUEL_REG_OCV_H;
+		regl = RT5033_FUEL_REG_OCV_L;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_read(battery->regmap, regh, &msb);
+	regmap_read(battery->regmap, regl, &lsb);
+
+	ret = ((msb << 4) + (lsb >> 4)) * 1250 / 1000;
+
+	return ret;
+}
+
+static int rt5033_battery_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct rt5033_battery *battery = container_of(psy,
+				struct rt5033_battery, psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		val->intval = rt5033_battery_get_watt_prop(battery->client,
+									psp);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = rt5033_battery_get_present(battery->client);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = rt5033_battery_get_capacity(battery->client);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static enum power_supply_property rt5033_battery_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_OCV,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CAPACITY,
+};
+
+static struct regmap_config rt5033_battery_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= RT5033_FUEL_REG_END,
+};
+
+static int rt5033_battery_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct rt5033_battery *battery;
+	u32 ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
+
+	battery = devm_kzalloc(&client->dev, sizeof(*battery), GFP_KERNEL);
+	if (!battery)
+		return -EINVAL;
+
+	battery->client = client;
+	battery->regmap = devm_regmap_init_i2c(client,
+			&rt5033_battery_regmap_config);
+	if (IS_ERR(battery->regmap)) {
+		dev_err(&client->dev, "Failed to initialize regmap\n");
+		return -EINVAL;
+	}
+
+	i2c_set_clientdata(client, battery);
+
+	battery->psy.name		= "rt5033-battery";
+	battery->psy.type		= POWER_SUPPLY_TYPE_BATTERY;
+	battery->psy.get_property	= rt5033_battery_get_property;
+	battery->psy.properties		= rt5033_battery_props;
+	battery->psy.num_properties	= ARRAY_SIZE(rt5033_battery_props);
+
+	ret = power_supply_register(&client->dev, &battery->psy);
+	if (ret) {
+		dev_err(&client->dev, "Failed to register power supply\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rt5033_battery_remove(struct i2c_client *client)
+{
+	struct rt5033_battery *battery = i2c_get_clientdata(client);
+
+	power_supply_unregister(&battery->psy);
+
+	return 0;
+}
+
+static const struct i2c_device_id rt5033_battery_id[] = {
+	{ "rt5033-battery", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, rt5033_battery_id);
+
+static struct i2c_driver rt5033_battery_driver = {
+	.driver = {
+		.name = "rt5033-battery",
+	},
+	.probe = rt5033_battery_probe,
+	.remove = rt5033_battery_remove,
+	.id_table = rt5033_battery_id,
+};
+module_i2c_driver(rt5033_battery_driver);
+
+MODULE_DESCRIPTION("Richtek RT5033 fuel gauge driver");
+MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

