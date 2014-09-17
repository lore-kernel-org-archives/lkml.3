Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaIQFyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:54:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaIQFym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:54:42 -0400
X-AuditID: cbfee691-f79546d0000011a1-63-54192220b819
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: jdelvare@suse.de, linux@roeck-us.net,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v3] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
Date: Wed, 17 Sep 2014 14:54:37 +0900
Message-id: <1410933277-31704-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkWFdBSTLEYO8Pc4uldz+xWXSefcJs
	cXnXHDaLJwvPMFncmbaXzYHV48HE3WweO783sHv0bVnF6LH5dLXH501yAaxRXDYpqTmZZalF
	+nYJXBnf1x1lKlgjU7Hz4HP2BsaF4l2MnBwSAiYSW3Y1M0HYYhIX7q1n62Lk4hASWMoose3D
	MkaYomMTFrFAJKYzShy4cIoVwmljkpiy+wQ7SBWbgI7E/303wWwRAWuJy3teg3UzCwRIfLi1
	ixnEFhZIlFg17TQbiM0ioCpx4PFLsBpeAQ+JTQd/AW3gANqmIDFnkg3IfAmB92wSU7dBzGcR
	EJD4NvkQVI2sxKYDzBDHSUocXHGDZQKj4AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsY
	gQF6+t+ziTsY7x+wPsQowMGoxMO74bJEiBBrYllxZe4hRlOgDROZpUST84FxkFcSb2hsZmRh
	amJqbGRuaaYkzqsj/TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PibSXNPrv1t7u2dnW+
	2qb0tG/eLIuTv8rWZy9RnHne8+NXVv+Vl+uK37JLzfOelnw3KrMoMdmKYWfktVPr+o60eTfl
	enCruPz17Zt1sG7i0iveV5UlHBWXBAf/L+J3nTh31owHoWym1+dPjW8qzphw9uWxgFNZRRyb
	q84om97f/NZ71t6dmReVWIozEg21mIuKEwGR8rz1SwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xoK6CkmSIQf81fYuldz+xWXSefcJs
	cXnXHDaLJwvPMFncmbaXzYHV48HE3WweO783sHv0bVnF6LH5dLXH501yAaxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ39cdZSpYI1Ox8+Bz9gbGheJdjJwcEgImEscm
	LGKBsMUkLtxbz9bFyMUhJDCdUeLAhVOsEE4bk8SU3SfYQarYBHQk/u+7CWaLCFhLXN7zmhHE
	ZhYIkPhwaxcziC0skCixatppNhCbRUBV4sDjl2A1vAIeEpsO/gLaxgG0TUFiziSbCYzcCxgZ
	VjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh/8zqR2MKxssDjEKcDAq8fBuuCwRIsSaWFZc
	mXuIUYKDWUmEV+QeUIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wNjMK4k3NDYxM7I0Mje0
	MDI2VxLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAKP7PZu/GaDHuE4w1BWcj/9XwPzB7cHqV
	RIz0noDsC46btSsyfuy4tc3giXe9fYvqVcbYVR+9sq90pmjM/qgwQcrh+kKVhsOTshnW2Wac
	07+S3GqycaHOnH3Ps+d1fBYoO3RWhjXqg2P2MRG+lV1eh9c22JraOZr8/3Yy9/6xutMX7x6u
	ae5OVGIpzkg01GIuKk4EAMzqX4+VAgAA
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
Changes:
v3:
 - Add dependencies of thermal subsystem for proper building.
v2:
 - Remove NULL pointer checking already done by thermal_zone_of_sensor_unregister().

 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
 drivers/hwmon/Kconfig                              |    1 +
 drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
 3 files changed, 29 insertions(+)

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
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 4289a4f..f790b41 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1077,6 +1077,7 @@ config SENSORS_PC87427
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support from Murata"
 	depends on !OF || IIO=n || IIO
+	depends on THERMAL || !THERMAL_OF
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
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

