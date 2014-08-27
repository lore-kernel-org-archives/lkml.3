Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020AbaH0RBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:01:16 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.118]:15251 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbaH0RBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:01:13 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-11.tower-194.messagelabs.com!1409158869!19288622!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 27 Aug 2014 19:01:10 +0200
Date: Wed, 27 Aug 2014 19:53:06 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <linux@roeck-us.net>,
        <lm-sensors@lm-sensors.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>
Subject: [PATCH v6 4/4] drivers/hwmon/menf21bmc_hwmon: introduce MEN14F021P00
 BMC HWMON driver
Message-ID: <65074740dfc6363134384b45fcd3acf5f2b4254f.1409161615.git.andreas.werner@men.de>
References: <cover.1409161615.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1409161615.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added driver to support the 14F021P00 BMC Hardware Monitoring.
The BMC is a Board Management Controller including monitoring of the
board voltages.

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 Documentation/hwmon/menf21bmc   |  50 +++++++++
 drivers/hwmon/Kconfig           |  10 ++
 drivers/hwmon/Makefile          |   1 +
 drivers/hwmon/menf21bmc_hwmon.c | 230 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 291 insertions(+)
 create mode 100644 Documentation/hwmon/menf21bmc
 create mode 100644 drivers/hwmon/menf21bmc_hwmon.c

diff --git a/Documentation/hwmon/menf21bmc b/Documentation/hwmon/menf21bmc
new file mode 100644
index 0000000..2a273a0
--- /dev/null
+++ b/Documentation/hwmon/menf21bmc
@@ -0,0 +1,50 @@
+Kernel driver menf21bmc_hwmon
+=============================
+
+Supported chips:
+	* MEN 14F021P00
+	  Prefix: 'menf21bmc_hwmon'
+	  Adresses scanned: -
+
+Author: Andreas Werner <andreas.werner@men.de>
+
+Description
+-----------
+
+The menf21bmc is a Board Management Controller (BMC) which provides an I2C
+interface to the host to access the features implemented in the BMC.
+
+This driver gives access to the voltage monitoring feature of the main
+voltages of the board.
+The voltage sensors are connected to the ADC inputs of the BMC which is
+a PIC16F917 Mikrocontroller.
+
+Usage Notes
+-----------
+
+This driver is part of the MFD driver named "menf21bmc" and does
+not auto-detect devices.
+You will have to instantiate the MFD driver explicitly.
+Please see Documentation/i2c/instantiating-devices for
+details.
+
+Sysfs entries
+-------------
+
+The following attributes are supported. All attributes are read only
+The Limits are read once by the driver.
+
+in0_input	+3.3V input voltage
+in1_input	+5.0V input voltage
+in2_input	+12.0V input voltage
+in3_input	+5V Standby input voltage
+in4_input	VBAT (on board battery)
+
+in[0-4]_min	Minimum voltage limit
+in[0-4]_max	Maximum voltage limit
+
+in0_label	"MON_3_3V"
+in1_label	"MON_5V"
+in2_label	"MON_12V"
+in3_label	"5V_STANDBY"
+in4_label	"VBAT"
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 37908ff..1063d73 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -828,6 +828,16 @@ config SENSORS_MCP3021
 	  This driver can also be built as a module.  If so, the module
 	  will be called mcp3021.
 
+config SENSORS_MENF21BMC_HWMON
+	tristate "MEN 14F021P00 BMC Hardware Monitoring"
+	depends on MFD_MENF21BMC
+	help
+	  Say Y here to include support for the MEN 14F021P00 BMC
+	  hardware monitoring.
+
+	  This driver can also be built as a module. If so the module
+	  will be called menf21bmc_hwmon.
+
 config SENSORS_ADCXX
 	tristate "National Semiconductor ADCxxxSxxx"
 	depends on SPI_MASTER
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 1362382..56ab872 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
 obj-$(CONFIG_SENSORS_MAX6697)	+= max6697.o
 obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
 obj-$(CONFIG_SENSORS_MCP3021)	+= mcp3021.o
+obj-$(CONFIG_SENSORS_MENF21BMC_HWMON) += menf21bmc_hwmon.o
 obj-$(CONFIG_SENSORS_NCT6683)	+= nct6683.o
 obj-$(CONFIG_SENSORS_NCT6775)	+= nct6775.o
 obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
diff --git a/drivers/hwmon/menf21bmc_hwmon.c b/drivers/hwmon/menf21bmc_hwmon.c
new file mode 100644
index 0000000..c92229d
--- /dev/null
+++ b/drivers/hwmon/menf21bmc_hwmon.c
@@ -0,0 +1,230 @@
+/*
+ *  MEN 14F021P00 Board Management Controller (BMC) hwmon driver.
+ *
+ *  This is the core hwmon driver of the MEN 14F021P00 BMC.
+ *  The BMC monitors the board voltages which can be access with this
+ *  driver through sysfs.
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/jiffies.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#define DRV_NAME  "menf21bmc_hwmon"
+
+#define BMC_VOLT_COUNT	5
+#define MENF21BMC_V33	0
+#define MENF21BMC_V5	1
+#define MENF21BMC_V12	2
+#define MENF21BMC_V5_SB	3
+#define MENF21BMC_VBAT	4
+
+#define IDX_TO_VOLT_MIN_CMD(idx) (0x40 + idx)
+#define IDX_TO_VOLT_MAX_CMD(idx) (0x50 + idx)
+#define IDX_TO_VOLT_INP_CMD(idx) (0x60 + idx)
+
+struct menf21bmc_hwmon {
+	bool valid;
+	struct i2c_client *i2c_client;
+	unsigned long last_update;
+	int in_val[BMC_VOLT_COUNT];
+	int in_min[BMC_VOLT_COUNT];
+	int in_max[BMC_VOLT_COUNT];
+};
+
+static const char *const input_names[] = {
+	[MENF21BMC_V33]		= "MON_3_3V",
+	[MENF21BMC_V5]		= "MON_5V",
+	[MENF21BMC_V12]		= "MON_12V",
+	[MENF21BMC_V5_SB]	= "5V_STANDBY",
+	[MENF21BMC_VBAT]	= "VBAT"
+};
+
+static struct menf21bmc_hwmon *menf21bmc_hwmon_update(struct device *dev)
+{
+	int i;
+	int val;
+	struct menf21bmc_hwmon *drv_data = dev_get_drvdata(dev);
+	struct menf21bmc_hwmon *data_ret = drv_data;
+
+	if (time_after(jiffies, drv_data->last_update + HZ)
+	    || !drv_data->valid) {
+		for (i = 0; i < BMC_VOLT_COUNT; i++) {
+			val = i2c_smbus_read_word_data(drv_data->i2c_client,
+						       IDX_TO_VOLT_INP_CMD(i));
+			if (val < 0) {
+				data_ret = ERR_PTR(val);
+				goto abort;
+			}
+			drv_data->in_val[i] = val;
+		}
+		drv_data->last_update = jiffies;
+		drv_data->valid = true;
+	}
+abort:
+	return data_ret;
+}
+
+static int menf21bmc_hwmon_get_volt_limits(struct menf21bmc_hwmon *drv_data)
+{
+	int i, val;
+
+	for (i = 0; i < BMC_VOLT_COUNT; i++) {
+		val = i2c_smbus_read_word_data(drv_data->i2c_client,
+					       IDX_TO_VOLT_MIN_CMD(i));
+		if (val < 0)
+			return val;
+
+		drv_data->in_min[i] = val;
+
+		val = i2c_smbus_read_word_data(drv_data->i2c_client,
+					       IDX_TO_VOLT_MAX_CMD(i));
+		if (val < 0)
+			return val;
+
+		drv_data->in_max[i] = val;
+	}
+	return 0;
+}
+
+static ssize_t
+show_label(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%s\n", input_names[attr->index]);
+}
+
+static ssize_t
+show_in(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = menf21bmc_hwmon_update(dev);
+
+	if (IS_ERR(drv_data))
+		return PTR_ERR(drv_data);
+
+	return sprintf(buf, "%d\n", drv_data->in_val[attr->index]);
+}
+
+static ssize_t
+show_min(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", drv_data->in_min[attr->index]);
+}
+
+static ssize_t
+show_max(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", drv_data->in_max[attr->index]);
+}
+
+#define create_voltage_sysfs(idx)			\
+static SENSOR_DEVICE_ATTR(in##idx##_input, S_IRUGO,	\
+			show_in, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_min, S_IRUGO,	\
+			show_min, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_max, S_IRUGO,	\
+			show_max, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_label, S_IRUGO,	\
+			show_label, NULL, idx);
+
+create_voltage_sysfs(0);
+create_voltage_sysfs(1);
+create_voltage_sysfs(2);
+create_voltage_sysfs(3);
+create_voltage_sysfs(4);
+
+static struct attribute *menf21bmc_hwmon_attrs[] = {
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_min.dev_attr.attr,
+	&sensor_dev_attr_in0_max.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_min.dev_attr.attr,
+	&sensor_dev_attr_in1_max.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_min.dev_attr.attr,
+	&sensor_dev_attr_in2_max.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in3_min.dev_attr.attr,
+	&sensor_dev_attr_in3_max.dev_attr.attr,
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_min.dev_attr.attr,
+	&sensor_dev_attr_in4_max.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(menf21bmc_hwmon);
+
+static int menf21bmc_hwmon_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct menf21bmc_hwmon *drv_data;
+	struct i2c_client *i2c_client = to_i2c_client(pdev->dev.parent);
+	struct device *hwmon_dev;
+
+	drv_data = devm_kzalloc(&pdev->dev, sizeof(struct menf21bmc_hwmon),
+				GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
+	drv_data->i2c_client = i2c_client;
+
+	ret = menf21bmc_hwmon_get_volt_limits(drv_data);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to read sensor limits");
+		return ret;
+	}
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
+						   "menf21bmc", drv_data,
+						   menf21bmc_hwmon_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
+
+	dev_info(&pdev->dev, "MEN 14F021P00 BMC hwmon device enabled");
+
+	return 0;
+}
+
+static struct platform_driver menf21bmc_hwmon = {
+	.probe		= menf21bmc_hwmon_probe,
+	.driver		= {
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+	},
+};
+
+module_platform_driver(menf21bmc_hwmon);
+
+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
+MODULE_DESCRIPTION("MEN 14F021P00 BMC hwmon");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:menf21bmc_hwmon");
-- 
2.0.4

