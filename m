Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbaHZFdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:33:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31747 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbaHZFdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:33:45 -0400
X-AuditID: cbfee690-f79ce6d00000115a-96-53fc1c376be5
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: jdelvare@suse.de, linux@roeck-us.net,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] hwmon: ntc_thermistor: Add ntc thermistor to thermal subsystem
 as a sensor.
Date: Tue, 26 Aug 2014 14:33:40 +0900
Message-id: <1409031220-25922-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWyRsSkUNdc5k+wwaFr5hZL735is+g8+4TZ
	4vKuOWwWTxaeYbK4M20vmwOrx4OJu9k8dn5vYPfo27KK0WPz6WqPz5vkAlijuGxSUnMyy1KL
	9O0SuDK2v7zDVvBGrOL2S5UGxi9CXYycHBICJhIX3t5hhbDFJC7cW8/WxcjFISSwlFHi5IVm
	Npii1otXmCES0xkl9j28ygThtDFJPN91hwWkik1AR+L/vpvsILaIgLXE5T2vGUFsZoEAiQ+3
	djGD2MICcRKbJt0Aq2ERUJW4+/ws2AZeAQ+JMxcPAJ3BAbRNQWLOJBuQ+RIC79kkNszZBlUv
	IPFt8iEWiBpZiU0HmCGOk5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcx
	AsPz9L9nE3Yw3jtgfYhRgINRiYf3RvzvYCHWxLLiytxDjKZAGyYyS4km5wOjIK8k3tDYzMjC
	1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYy+Vgs9Hh/4OofhyoXP
	3ywn5xnEqh/csTW38vH9QM96Ia4/lVmnIx9+tuSbdaxrue/t1KlHS85vSefzm6h+wr06ifmY
	xoVbz8oWsrGGbiqojN8S0F5dZs+53NRv/2zPNomco0IsvV+up611Leq+En554zw1NsmAL79F
	468kylzkPaD2vae9ME+JpTgj0VCLuag4EQD4ecUHSgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xoK65zJ9gg4dHDS2W3v3EZtF59gmz
	xeVdc9gsniw8w2RxZ9peNgdWjwcTd7N57PzewO7Rt2UVo8fm09UenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmbH95h63gjVjF7ZcqDYxfhLoYOTkkBEwkWi9e
	YYawxSQu3FvP1sXIxSEkMJ1RYt/Dq0wQThuTxPNdd1hAqtgEdCT+77vJDmKLCFhLXN7zmhHE
	ZhYIkPhwaxfYJGGBOIlNk26A1bAIqErcfX6WDcTmFfCQOHPxAGsXIwfQNgWJOZNsJjByL2Bk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPzPpHYwrmywOMQowMGoxMN7I/53sBBrYllx
	Ze4hRgkOZiURXoaHQCHelMTKqtSi/Pii0pzU4kOMpkDLJzJLiSbnAyMzryTe0NjEzMjSyNzQ
	wsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QD46rszVskk1k53b8GcB5RNKrnVg7M/uW5
	V+qU2k3+C/9DX8cd7d/lvGVSR6bl3cTD9gfrxE5rvJq3Ol6ypEZqrp2L9iapqrNbGj8JR51f
	+FNppTdr5k1O3dernjy0NEw9/NLYcNHrLRPWz2vvdHGqYX810+ZASnOmdnTJQS3Df/b9bkIX
	8pY/VWIpzkg01GIuKk4EAGoew2CUAgAA
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
 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
 drivers/hwmon/ntc_thermistor.c                     |   26 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
index bd41072..369dc8c 100644
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
@@ -578,6 +601,9 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
 	ntc_iio_channel_release(pdata);
 
+	if (data->tz)
+		thermal_zone_of_sensor_unregister(data->dev, data->tz);
+
 	return 0;
 }
 
-- 
1.7.9.5

