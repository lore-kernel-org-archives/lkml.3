Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaIQCmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:42:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43915 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaIQCl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:41:59 -0400
X-AuditID: cbfee68d-f79c46d000000b84-46-5418f4ed1290
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: jdelvare@suse.de, linux@roeck-us.net,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
Date: Wed, 17 Sep 2014 11:41:33 +0900
Message-id: <1410921693-3291-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWyRsSkUPftF4kQg9Uf2S2W3v3EZtF59gmz
	xeVdc9gsniw8w2RxZ9peNgdWjwcTd7N57PzewO7Rt2UVo8fm09UenzfJBbBGcdmkpOZklqUW
	6dslcGW0n5nEXnBQvOLDpcNMDYx7hbsYOTkkBEwkJtw/ywhhi0lcuLeerYuRi0NIYCmjxKab
	X1lgiqZcncIEkVjEKLF99n5GCKeNSaKp/yEbSBWbgI7E/3032UFsEQFrict7XoONZRYIkPhw
	axcziC0skCFx/9NtoEkcHCwCqhJPD7OChHkF3CW2fG9lAQlLCChIzJlkA7H3M5vEs40OIDaL
	gIDEt8mHoEpkJTYdYIYokZQ4uOIGywRGwQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	AoPz9L9nvTsYbx+wPsQowMGoxMO74bJEiBBrYllxZe4hRlOgDROZpUST84ExkFcSb2hsZmRh
	amJqbGRuaaYkzqso9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2OIqf/Sj5YZRjt9D/ef
	8Xt4ziDJyilqgUvXbfYMOc+EYIvFbY0VBSYvJ9aZ5t01bH5hVxnx6FrFd7YKW6lVOjJOO/yE
	GO9O3u5UbnTXkVlR7k3Cm3fOji66z2a9M1KbIdGx43lGh1GD+6nJH68WiP7QXyil+6Wy/uL1
	4yIdB6LrP2wWjXdKV2Ipzkg01GIuKk4EAAHuJkhJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xgO6bLxIhBve/2lgsvfuJzaLz7BNm
	i8u75rBZPFl4hsnizrS9bA6sHg8m7mbz2Pm9gd2jb8sqRo/Np6s9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMaD8zib3goHjFh0uHmRoY9wp3MXJySAiYSEy5
	OoUJwhaTuHBvPVsXIxeHkMAiRonts/czQjhtTBJN/Q/ZQKrYBHQk/u+7yQ5iiwhYS1ze85oR
	xGYWCJD4cGsXM4gtLJAhcf/TbaCpHBwsAqoSTw+zgoR5BdwltnxvZQEJSwgoSMyZZDOBkXsB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODgfya9g3FVg8UhRgEORiUe3g2XJUKEWBPL
	iitzDzFKcDArifCK3AMK8aYkVlalFuXHF5XmpBYfYjQF2j2RWUo0OR8YmXkl8YbGJmZGlkbm
	hhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhjrdD/IGmrVNiQn7FaRseH7lV15+8um
	mB57obuiktOPbXI5+ntnrMXfSq1NG66fqUverLWBVWDj9m1v/fMCZZoN3vc7f3T5r3hgwv+D
	58RjwyyafIxkT3g+W6AqciiuK3HOk1Su4uIJlixndOzX9t6uq1qbv+DOa9PITV/zN9/deyd8
	nmjTpkYlluKMREMt5qLiRAD8HBgnlAIAAA==
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

