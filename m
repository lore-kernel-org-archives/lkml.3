Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbbAIIp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:45:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34440 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbbAIIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:45:18 -0500
X-AuditID: cbfee68e-f79b46d000002b74-c0-54af951c6701
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 1/3] power: rt5033_battery: Add RT5033 Fuel gauge device
 driver
Date: Fri, 09 Jan 2015 17:45:11 +0900
Message-id: <1420793114-20586-2-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkQFdm6voQgwl/pS1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4tyrlYwWk+5PYLF4v+cMo8XlXXPYLD73HmG0
	WHr9IpPFhOlrWSxa9x5htzi9u8RixuSXbA6CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxeoeWx
	aVUnm8eda3vYPPq2rGL0+LxJLoAzissmJTUnsyy1SN8ugSvj259b7AUTLSo+HLnK3sC4RL+L
	kZNDQsBE4k3DYiYIW0ziwr31bF2MXBxCAksZJVq/XmCFKdq1cgM7RGIRo8Ssn/sZIZw2Jokb
	73rAqtgENCXeT7nCAmKLCGRIbO+YwgxSxCxwlkli4tsedpCEsECIRP+ZB2ANLAKqEp0b2xlB
	bF4BN4mtLRuAbA6gdQoScybZgIQ5BdwlXm6ZAFYuBFSyZcM5VpCZEgKNHBJ3fq1lh5gjIPFt
	8iEWiF5ZiU0HmCGulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAiPu
	9L9nfTsYbx6wPsQowMGoxMO7QW59iBBrYllxZe4hRlOgDROZpUST84FxnVcSb2hsZmRhamJq
	bGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+O8k7v17VV/Pt189MT93a0d
	Idm+PfvWsC5JNtvxhZOp0XHn5eZ3EznXXN6tnHK5NPmduPmTSVxFx/ofJOsJVvHdsTyql7r1
	caLX68bJsQd5/5gYTp2z2jG2vllR+gL3Rb/nfA0PbNZfFvDfmOv79+B8+aNbF/f0tOptX/vw
	R0b8MZcvNs9EPksqsRRnJBpqMRcVJwIATwLko7MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAV2ZqetDDHqfC1qc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxblXKxktJt2fwGLxfs8ZRovLu+awWXzuPcJo
	sfT6RSaLCdPXsli07j3CbnF6d4nFjMkv2RwEPdbMW8Pocbmvl8lj56y77B4rl39h89i8Qstj
	06pONo871/awefRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjG9/brEXTLSo+HDkKnsD4xL9LkZODgkBE4ldKzewQ9hiEhfurWfrYuTiEBJYxCgx6+d+
	RginjUnixrseVpAqNgFNifdTrrCA2CICGRLbO6YwgxQxC5xlkpj4tgdslLBAiET/mQdgDSwC
	qhKdG9sZQWxeATeJrS0bgGwOoHUKEnMm2YCEOQXcJV5umQBWLgRUsmXDOdYJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgTH8zPpHYyrGiwOMQpwMCrx8G6QWx8ixJpYVlyZe4hR
	goNZSYT30ASgEG9KYmVValF+fFFpTmrxIUZToKMmMkuJJucDU01eSbyhsYmZkaWRuaGFkbG5
	kjivkn1biJBAemJJanZqakFqEUwfEwenVAPjyr7rO0ymCJ2a+eajms8EOz13N5X9glZXEiaZ
	VhcHMIlUenmob0ix5til3Oye/CCs7cKTJ54a/ZvjiqbJbI+cldLYeukc81X9lV3Xa9OmrCwt
	4tmrOePz6XX/Ck+tXSmk3LvH5pqY8Wvjy/P1PJPb3Tat9Hp7Yk113YpTCS4vDH61CDydkztT
	iaU4I9FQi7moOBEAmzQzp/0CAAA=
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
Changes in v2
- none.
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

