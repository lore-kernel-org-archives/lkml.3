Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaLRNPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:15:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29801 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLRNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:15:51 -0500
X-AuditID: cbfee68f-f791c6d000004834-46-5492d3849ef1
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 1/3] power: rt5033_battery: Add RT5033 Fuel gauge device driver
Date: Thu, 18 Dec 2014 22:15:45 +0900
Message-id: <1418908547-10241-2-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418908547-10241-1-git-send-email-beomho.seo@samsung.com>
References: <1418908547-10241-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkSLfl8qQQg6eLbCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4tyrlYwWk+5PYLF4v+cMo8W3Kx1MFpd3zWGz
	+Nx7hNFi6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUWMya/ZHMQ9lgzbw2jx+W+XiaPnbPusnus
	XP6FzWPzCi2PTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFcEVx2aSk5mSWpRbp2yVwZWy6sJa1
	4It5xZarZ9kaGCfodzFyckgImEjsvDKPBcIWk7hwbz1bFyMXh5DAUkaJcz3rWGCK1p+ZC5VY
	xCjx7vw5JginjUliz5EDrCBVbAKaEu+nXAHrEBGIkDi7bBaYzSzwk0ni5qVsEFtYwF/iz6v5
	bCA2i4CqxNKl65hBbF4BN4mNjRPYuxg5gLYpSMyZZAMS5hRwl7j+8QQ7iC0EVLLg0TVmkL0S
	AhM5JA58W8UKMUdA4tvkQywQvbISmw4wQxwtKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6xUn
	5haX5qXrJefnbmIERuLpf8/6dzDePWB9iFGAg1GJh1dCb1KIEGtiWXFl7iFGU6ANE5mlRJPz
	gfGeVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxmVz
	jXhEn5yWm86gcf6HWcVR1jef4hWtn2rtLr16gfneGZu8ld0Ka8RO5rPFty9qalzwcVPOL4kq
	q/qz8up3D1TPuq3catE24/v9qI7+c1lsxo+OfA6R0wh281vR9TNjPetUuZvcbCHf1Gpfn5Ln
	3fxUdYXt2SMlnHNtcm//e9Pfu2jz8lAvDSWW4oxEQy3mouJEAEM6evi/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAd2Wy5NCDDZdNrQ4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJaTLo/gcXi/Z4zjBbfrnQwWVzeNYfN
	4nPvEUaLpdcvMllMmL6WxaJ17xF2i9PdrBand5dYzJj8ks1B2GPNvDWMHpf7epk8ds66y+6x
	cvkXNo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SYkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjFj04W1rAVfzCu2XD3L1sA4Qb+LkZNDQsBEYv2ZuWwQtpjEhXvr
	gWwuDiGBRYwS786fY4Jw2pgk9hw5wApSxSagKfF+yhUWEFtEIELi7LJZYDazwE8miZuXskFs
	YQF/iT+v5oNNZRFQlVi6dB0ziM0r4CaxsXECexcjB9A2BYk5k2xAwpwC7hLXP55gB7GFgEoW
	PLrGPIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Dh/JrWDcWWDxSFGAQ5GJR5e
	Cb1JIUKsiWXFlbmHGCU4mJVEeKNzgEK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD0xBeSXx
	hsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjKdMDEKM1/StcrMU805c
	1/N0Mpv2upWiXmkeK7L9Eq57C1kZvOxb+LEmU/tJ/665p05utwouzQoRfsZoPF3Cp7SJKWa2
	i99NkTUdZV4bbsct3fz2cIRQT+X1KB7lKcv1xbm+9tl2RW3zzF6QZDLTi/etwLyMkvqJsza7
	G4SdDWsVOjDfk1lWiaU4I9FQi7moOBEArE255wkDAAA=
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

