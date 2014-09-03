Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaICCju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:39:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaICCjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:39:49 -0400
X-AuditID: cbfee68f-f797f6d000001173-70-54067f73d437
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: cw00.choi@samsung.com, jdelvare@suse.de, linux@roeck-us.net,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v2] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
Date: Wed, 03 Sep 2014 11:39:38 +0900
Message-id: <1409711978-3377-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWyRsSkULe4ni3E4P5aTovrX56zWiy9+4nN
	ovPsE2aLy7vmsFk8WXiGyeLOtL1sDmweDybuZvPY+b2B3aNvyypGj82nqz0+b5ILYI3isklJ
	zcksSy3St0vgymg/M4m94KB4xYdLh5kaGPcKdzFyckgImEjcmD2DEcIWk7hwbz1bFyMXh5DA
	UkaJKf+3ssEU/dx8mxEisYhRYuK628wgCSGBNiaJg6uZQGw2AR2J//tusoPYIgLWEpf3vAab
	yiyQKdH+5AVYjbBAosSm2ZPBhrIIqEpc3N8DVM/BwSvgLtHzgBfElBBQkJgzyQZklYTAdzaJ
	Y5NPMkKUC0h8m3yIBaJGVmLTAWaI0yQlDq64wTKBUXABI8MqRtHUguSC4qT0ImO94sTc4tK8
	dL3k/NxNjMAwPf3vWf8OxrsHrA8xCnAwKvHwLghgCxFiTSwrrsw9xGgKtGEis5Rocj4wGvJK
	4g2NzYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIPN+Zx6ii
	73iVdtvjW+lMjOd/OUyNTvZWnbLljugMBZtvS9avsNXIUDp8763c0/LeTjvW9aGbXwsd87m5
	fo6Z4Y6929+cvNmmf9JG7/LmyTytD86mJQo433fgs9zoemxztWNuxlmRN/m6Oj7v1f9+Xrvm
	8XSFquDWoEmBaTXZIR/cuq6tcqlRYinOSDTUYi4qTgQA9onQF04CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xgG5xPVuIQesyRovrX56zWiy9+4nN
	ovPsE2aLy7vmsFk8WXiGyeLOtL1sDmweDybuZvPY+b2B3aNvyypGj82nqz0+b5ILYI1qYLTJ
	SE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpASaEsMacU
	KBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRfmYSe8FB8YoPlw4zNTDuFe5i5OSQ
	EDCR+Ln5NiOELSZx4d56ti5GLg4hgUWMEhPX3WYGSQgJtDFJHFzNBGKzCehI/N93kx3EFhGw
	lri85zVYM7NApkT7kxdgNcICiRKbZk9mA7FZBFQlLu7vAarn4OAVcJfoecALYkoIKEjMmWQz
	gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgKHgmvYNxVYPFIUYBDkYlHt4FAWwh
	QqyJZcWVuYcYJTiYlUR4fROBQrwpiZVVqUX58UWlOanFhxhNgXZPZJYSTc4HRmheSbyhsYmZ
	kaWRuaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGVR6GsV93rfzGu2XBhOQguUvq
	c38KXnzYftRC98NTgUVzvqTU305J1JkkfzPWzntm3N4Nakt+OTXqaIb/twmY5X5Fa8HFiw8d
	7n4PjA/cIlE4X7y19kreos+7EtRuJyZ3Mf2bWuVoYrqyM5G9zW7lLIV73x62Zft+SZ0tUfE6
	8fabD4/e/aw7pMRSnJFoqMVcVJwIAOSgq+yYAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get more comprehensive and integrated thermal management, it adds ntc
thermistor to thermal framework as a thermal sensor. It's governed thermal
susbsystem only if it is described in DT node. Otherwise, it just notifies
temperature to userspace via sysfs as it used to be.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
Updates in v2
 - Remove NULL pointer checking already done by thermal_zone_of_sensor_unregister().

 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
 drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
index 2391e5c..fcca8e7 100644
--- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
+++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
@@ -25,6 +25,9 @@ Requires node properties:
 - "io-channels"	Channel node of ADC to be used for
 		conversion.
 
+Optional node properties:
+- "#thermal-sensor-cells" Used to expose itself to thermal fw.
+
 Read more about iio bindings at
 	Documentation/devicetree/bindings/iio/iio-bindings.txt
 
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index bd41072..4ff89b2 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -38,6 +38,7 @@
 
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/thermal.h>
 
 struct ntc_compensation {
 	int		temp_c;
@@ -182,6 +183,7 @@ struct ntc_data {
 	struct device *dev;
 	int n_comp;
 	char name[PLATFORM_NAME_SIZE];
+	struct thermal_zone_device *tz;
 };
 
 #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
@@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
 	return -EINVAL;
 }
 
+static int ntc_read_temp(void *dev, long *temp)
+{
+	struct ntc_data *data = dev_get_drvdata(dev);
+	int ohm;
+
+	ohm = ntc_thermistor_get_ohm(data);
+	if (ohm < 0)
+		return ohm;
+
+	*temp = get_temp_mc(data, ohm);
+
+	return 0;
+}
+
 static ssize_t ntc_show_name(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
 								pdev_id->name);
 
+	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
+						ntc_read_temp, NULL);
+	if (IS_ERR(data->tz)) {
+		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
+		data->tz = NULL;
+	}
+
 	return 0;
 err_after_sysfs:
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
@@ -578,6 +601,8 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
 	ntc_iio_channel_release(pdata);
 
+	thermal_zone_of_sensor_unregister(data->dev, data->tz);
+
 	return 0;
 }
 
-- 
1.7.9.5

