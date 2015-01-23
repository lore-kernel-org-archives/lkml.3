Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbbAWFFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:05:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14407 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbAWFDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:22 -0500
X-AuditID: cbfee68d-f79296d000004278-5b-54c1d606971e
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 4/6] power: max77843_battery: Add Max77843 fuel gauge device
 driver
Date: Fri, 23 Jan 2015 14:02:45 +0900
Message-id: <1421989367-32721-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrMt27WCIwdQHshanP21jt5j68Amb
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLSbdn8Bicf/rUUaLy7vmsFl87j3CaLH0+kUmiwnT17JY
	tO49wm5xeneJA5/HmnlrGD0u9/Uyeaxc/oXNY9OqTjaPO9f2sHn0bVnF6PF5k1wAexSXTUpq
	TmZZapG+XQJXxsGNWgXnvCsm7P/D2sD4266LkZNDQsBE4u+BJewQtpjEhXvr2boYuTiEBJYy
	Sjw4O50dpuje42+sEInpjBK9HddZIJw2JomODwvBqtgEtCW+r1/MCmKLCERIPP+4khmkiFlg
	BrPEh487wIqEBUIl1m7dzgRiswioSix8uosZxOYV8JBYNWMCkM0BtE5BYs4kG5Awp4CnxLs9
	L9hAbCGgktUTToItlhC4xy7xre0vM8QcAYlvkw+xQPTKSmw6wAxxtaTEwRU3WCYwCi9gZFjF
	KJpakFxQnJReZKhXnJhbXJqXrpecn7uJERg/p/89693BePuA9SFGAQ5GJR7ehi0HQ4RYE8uK
	K3MPMZoCbZjILCWanA+M0rySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhhNfF6Idc0pM+O46XPST8Xni2To/EnPltn+ywg9vftUzzrGSNmbaVfv9N6K
	C7lrenT9uhrj/8v+lIvPcJxQfXzhZiN/mXfdn5+Xyp7+2xgY6Hvz6FsrQ1d325/LJqxjcvD9
	nrGOV3qx5bOazDDhB1P4WsJye0Q+Mq69wTtr16+4szrL0yS2eG5TYinOSDTUYi4qTgQAVTuw
	s5oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQV22awdDDL5tEbA4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWi/tfjzJaXN41h83ic+8RRoul1y8yWUyYvpbF
	onXvEXaL07tLHPg81sxbw+hxua+XyWPl8i9sHptWdbJ53Lm2h82jb8sqRo/Pm+QC2KMaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGYc3KhVcM67YsL+P6wNjL/tuhg5OSQE
	TCTuPf7GCmGLSVy4t56ti5GLQ0hgOqNEb8d1FginjUmi48NCdpAqNgFtie/rF4N1iAhESDz/
	uJIZpIhZYAazxIePO8CKhAVCJdZu3c4EYrMIqEosfLqLGcTmFfCQWDVjApDNAbROQWLOJBuQ
	MKeAp8S7PS/YQGwhoJLVE06yTGDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjODqf
	Se9gXNVgcYhRgINRiYe3YcvBECHWxLLiytxDjBIczEoivE8OAIV4UxIrq1KL8uOLSnNSiw8x
	mgIdNZFZSjQ5H5g48kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUa
	GLtFzlZtV919ft1OpXXbEwo/GEyQ9T2jtGfF3vyfTk+E2OYub2X6UfqeM/HFvlLV4julP9qW
	v1gScKV+2ZzsdZ9TF8k993joeVFuC2tTyuL0A+G/arfLHcucq9og9V7WydHh1gTBKWUdkzIv
	PZBXNWhjabl8rH75hCqJsLzNkdvVtv1iu/gyZY8SS3FGoqEWc1FxIgC3uEd15AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beomho Seo <beomho.seo@samsung.com>

This patch adds device driver of max77843 fuel gauge.
The driver support for battery fuel gauge in Maxim Max77843.
It is fuel-gauge systems for lithuum-ion batteries in handled and
portable devices.

Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
---
 drivers/power/Kconfig            |    9 ++
 drivers/power/Makefile           |    1 +
 drivers/power/max77843_battery.c |  283 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 293 insertions(+)
 create mode 100644 drivers/power/max77843_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index a054a28..0039bbb 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -212,6 +212,15 @@ config BATTERY_MAX17042
 	  with MAX17042. This driver also supports max17047/50 chips which are
 	  improved version of max17042.
 
+config BATTERY_MAX77843
+	tristate "Maxim MAX77843 Fuel Gauge"
+	depends on MFD_MAX77843
+	help
+	  This add support for battery fuel gauge in Maxim MAX77843. It is
+	  fuel-gauge systems for lithuum-ion (Li+) batteries in handled and
+	  portable devices. The MAX17040 is configured to operate with a single
+	  lithium cell.
+
 config BATTERY_Z2
 	tristate "Z2 battery driver"
 	depends on I2C && MACH_ZIPIT2
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 212c6a2..ae0d795 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
+obj-$(CONFIG_BATTERY_MAX77843)	+= max77843_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_BATTERY_TWL4030_MADC)	+= twl4030_madc_battery.o
diff --git a/drivers/power/max77843_battery.c b/drivers/power/max77843_battery.c
new file mode 100644
index 0000000..a08dd0c
--- /dev/null
+++ b/drivers/power/max77843_battery.c
@@ -0,0 +1,283 @@
+/*
+ * Fuel gauge driver for Maxim MAX77843
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
+#include <linux/mfd/max77843-private.h>
+
+struct max77843_battery {
+	struct device		*dev;
+	struct max77843		*max77843;
+	struct i2c_client	*client;
+	struct regmap		*regmap;
+	struct power_supply	psy;
+};
+
+static int max77843_battery_get_capacity(struct max77843_battery *battery)
+{
+	struct regmap *regmap = battery->regmap;
+	int ret, val;
+	u8 reg_data[2];
+
+	ret = regmap_bulk_read(regmap, MAX77843_FG_REG_SOCREP, reg_data, 2);
+	if (ret) {
+		dev_err(battery->dev, "Failed to read fuelgauge register\n");
+		return ret;
+	}
+
+	val =  ((reg_data[1] * 100) + (reg_data[0] * 100 / 256)) / 100;
+
+	return val;
+}
+
+static int max77843_battery_get_energy_prop(struct max77843_battery *battery,
+		enum power_supply_property psp)
+{
+	struct regmap *regmap = battery->regmap;
+	unsigned int reg;
+	int ret, val;
+	u8 reg_data[2];
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+		reg = MAX77843_FG_REG_FULLCAP;
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+		reg = MAX77843_FG_REG_REMCAP_REP;
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_AVG:
+		reg = MAX77843_FG_REG_REMCAP_AV;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
+	if (ret) {
+		dev_err(battery->dev, "Failed to read fuelgauge register\n");
+		return ret;
+	}
+
+	val = (reg_data[1] << 8) | reg_data[0];
+
+	return val;
+}
+
+static int max77843_battery_get_current_prop(struct max77843_battery *battery,
+		enum power_supply_property psp)
+{
+	struct regmap *regmap = battery->regmap;
+	unsigned int reg;
+	int ret, val;
+	u8 reg_data[2];
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		reg = MAX77843_FG_REG_CURRENT;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		reg = MAX77843_FG_REG_AVG_CURRENT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
+	if (ret) {
+		dev_err(battery->dev, "Failed to read fuelgauge register\n");
+		return ret;
+	}
+
+	val = (reg_data[1] << 8) | reg_data[0];
+	if (val & 0x8000) {
+		/* Negative */
+		val = ~val & 0xffff;
+		val++;
+		val *= -1;
+	}
+	/* Unit of current is mA */
+	val =  val * 15625 / 100000;
+
+	return val;
+}
+
+static int max77843_battery_get_voltage_prop(struct max77843_battery *battery,
+		enum power_supply_property psp)
+{
+	struct regmap *regmap = battery->regmap;
+	unsigned int reg;
+	int ret, val;
+	u8 reg_data[2];
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		reg = MAX77843_FG_REG_VCELL;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		reg = MAX77843_FG_REG_AVG_VCELL;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		reg = MAX77843_FG_REG_OCV;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
+	if (ret) {
+		dev_err(battery->dev, "Failed to read fuelgauge register\n");
+		return ret;
+	}
+
+	val = ((reg_data[1] << 4) + (reg_data[0] >> 4)) * 125;
+	val /= 100;
+
+	return val;
+}
+
+static const char *model_name = "MAX77843";
+static const char *manufacturer = "Maxim Integrated";
+
+static int max77843_battery_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct max77843_battery *battery = container_of(psy,
+				struct max77843_battery, psy);
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		val->intval = max77843_battery_get_voltage_prop(battery, psp);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = max77843_battery_get_current_prop(battery, psp);
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+	case POWER_SUPPLY_PROP_ENERGY_AVG:
+		val->intval = max77843_battery_get_energy_prop(battery, psp);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = max77843_battery_get_capacity(battery);
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval =  model_name;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = manufacturer;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property max77843_battery_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_OCV,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_ENERGY_FULL,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_ENERGY_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static const struct regmap_config max77843_fuel_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= MAX77843_FG_END,
+};
+
+static int max77843_battery_probe(struct platform_device *pdev)
+{
+	struct max77843 *max77843 = dev_get_drvdata(pdev->dev.parent);
+	struct max77843_battery *battery;
+	int ret;
+
+	battery = devm_kzalloc(&pdev->dev, sizeof(*battery), GFP_KERNEL);
+	if (!battery)
+		return -ENOMEM;
+
+	battery->dev = &pdev->dev;
+	battery->max77843 = max77843;
+
+	battery->client = i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_FG);
+	if (!battery->client) {
+		dev_err(&pdev->dev, "Failed to get dummy i2c client.\n");
+		return PTR_ERR(battery->client);
+	}
+	i2c_set_clientdata(battery->client, max77843);
+
+	battery->regmap = devm_regmap_init_i2c(battery->client,
+			&max77843_fuel_regmap_config);
+	if (IS_ERR(battery->regmap)) {
+		ret = PTR_ERR(battery->regmap);
+		goto err_i2c;
+	}
+
+	platform_set_drvdata(pdev, battery);
+
+	battery->psy.name	= "max77843-fuelgauge";
+	battery->psy.type	= POWER_SUPPLY_TYPE_BATTERY;
+	battery->psy.get_property	= max77843_battery_get_property;
+	battery->psy.properties		= max77843_battery_props;
+	battery->psy.num_properties	= ARRAY_SIZE(max77843_battery_props);
+
+	ret = power_supply_register(&pdev->dev, &battery->psy);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed  to register power supply\n");
+		goto err_i2c;
+	}
+
+	return 0;
+
+err_i2c:
+	i2c_unregister_device(battery->client);
+
+	return ret;
+}
+
+static int max77843_battery_remove(struct platform_device *pdev)
+{
+	struct max77843_battery *battery = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&battery->psy);
+
+	return 0;
+}
+
+static const struct platform_device_id max77843_battery_id[] = {
+	{ "max77843-fuelgauge", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max77843_battery_id);
+
+static struct platform_driver max77843_battery_driver = {
+	.driver = {
+		.name = "max77843-fuelgauge",
+	},
+	.probe = max77843_battery_probe,
+	.remove = max77843_battery_remove,
+	.id_table = max77843_battery_id,
+};
+module_platform_driver(max77843_battery_driver);
+
+MODULE_DESCRIPTION("Maxim MAX77843 fuel gauge driver");
+MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

