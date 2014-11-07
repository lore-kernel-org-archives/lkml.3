Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaKGCxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:53:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37408 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKGCwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:52:14 -0500
X-AuditID: cbfee68d-f79296d000004278-ed-545c33d9a751
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        jonghwa3.lee@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 3/5] power: rt5033_battery: Add RT5033 Fuel gauge device driver
Date: Fri, 07 Nov 2014 11:52:05 +0900
Message-id: <1415328727-16245-4-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
References: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkQPeWcUyIQW+6xelP29gtpj58wmZx
	/ctzVotJT94zW8w/co7VYuLKycwW/W8Wslr8mdDKZnHu1UpGi0n3J7BYdJ59wmxxtukNu8X9
	r0cZLb5d6WCyuLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OYx5p5
	axg9Lvf1MnnsnHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK4rLJiU1
	J7MstUjfLoEr49ETg4J9VhX7OnYxNzAuM+xi5OSQEDCRONK/hRHCFpO4cG89WxcjF4eQwFJG
	iR2fWthginpuHGOFSExnlNj8axojhNPGJHF03juwKjYBTYn3U66wgNgiAhESZ5fNYgEpYhY4
	xSyx/vQfsISwgL/E+htXmEBsFgFViT1/t4Ht5hVwk5i/bztQDQfQOgWJOZNsQMKcAu4Szx9v
	YwaxhYBK9q49CDZTQmAlh8T7HxvYIOYISHybfAiqV1Zi0wFmiKslJQ6uuMEygVF4ASPDKkbR
	1ILkguKk9CJDveLE3OLSvHS95PzcTYzAKD3971nvDsbbB6wPMQpwMCrx8N7gjQkRYk0sK67M
	PcRoCrRhIrOUaHI+MBXklcQbGpsZWZiamBobmVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAeINP7e5fwXMFPJ+YkgpcQ58XT2v59jFYK+hgBJ/uGSdmnzXb7fO+H3i43YJ/
	ghVnefq8f1y1ZeyHguM8dJK5zgpOtHLL3vC4btnpF/M7m9N4JDS+W4asXbn478ppcno7XTgu
	8yj0P+wsvLyuX+uZpfzXNR949m8P6Frc9lzGoF/+t/22grtzlViKMxINtZiLihMBFvrXXs0C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoO5N45gQg1MfjCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxaLz7BNmi7NNb9gt
	7n89ymjx7UoHk8XlXXPYLD73HmG0WHr9IpPFhOlrWSxa9x5htzjdzWpxeneJxYzJL9kcxDzW
	zFvD6HG5r5fJY+esu+weK5d/YfPYvELLY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAVxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB/KimUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzHj0xKNhnVbGvYxdzA+Mywy5GTg4J
	AROJnhvHWCFsMYkL99azdTFycQgJTGeU2PxrGiOE08YkcXTeOzaQKjYBTYn3U66wgNgiAhES
	Z5fNYgEpYhY4xSyx/vQfsISwgL/E+htXmEBsFgFViT1/tzGC2LwCbhLz920HquEAWqcgMWeS
	DUiYU8Bd4vnjbcwgthBQyd61B1kmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGc
	BJ5J7WBc2WBxiFGAg1GJh/cmb0yIEGtiWXFl7iFGCQ5mJRFeG3agEG9KYmVValF+fFFpTmrx
	IUZToKMmMkuJJucDE1ReSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5O
	qQbGAKfl9V2nxM0c63asXv52r8k73pl1FbI8XrpZmw177uz5X+BgsMbtRrX/nsyXVfyaHSW/
	DedwB84TXpx5qkDZ8fzOOXpSRSpPV8RWB0fpeR1cvv5ZUuAcm7/fDNmXzuK7u/7NceOvO9bN
	+Sy82ruVUUaviY3bamK3z91815U3fjLdzHbbutNYiaU4I9FQi7moOBEAtqJ2YhgDAAA=
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
 drivers/power/rt5033_battery.c |  189 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+)
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
index 0000000..660f039
--- /dev/null
+++ b/drivers/power/rt5033_battery.c
@@ -0,0 +1,189 @@
+/*
+ * Fuel gauge driver for Richtek RT5033
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
+		regh = RT5033_FUEL_REG_AVG_VOLT_H;
+		regl = RT5033_FUEL_REG_AVG_VOLT_L;
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
+static bool rt5033_battery_bolatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case RT5033_FUEL_REG_OCV_H ... RT5033_FUEL_REG_SOC_L:
+	case RT5033_FUEL_REG_CRATE ... RT5033_FUEL_REG_AVG_VOLT_L:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static struct regmap_config rt5033_battery_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.volatile_reg	= rt5033_battery_bolatile_reg,
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

