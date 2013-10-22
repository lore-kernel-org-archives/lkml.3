Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3JVMxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:53:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3JVMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:52:06 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-b1-526674f45a36
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 2/4] charger-manager: Use IIO subsystem to read battery
 temperature instead of legacy method
Date: Tue, 22 Oct 2013 21:51:55 +0900
Message-id: <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSovulJC3I4HIrt8XBrZoW1788Z7WY
	f+Qcq8XElZOZLQ782cFocbbpDbvF5V1z2CxuN65gszi84gCTA6fHgs9X2D0m9H9i9Ni8Qsvj
	zrU9bB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8ebwZ8aCLquKVTMfMDYwHtHvYuTkkBAw
	kThwaykLhC0mceHeerYuRi4OIYGljBLdW2aywRQ9+zefGSKxiFHi0tFbUFWNTBLHpm1gBqli
	E9CS2P/iBliHiICfxPW325hAipgFpjNKrFzYxwqSEBbIk/h59AcTiM0ioCpxatJXIJuDg1fA
	VWLdbE2IbXISH/Y8YgexOQXcJPZN/QVWLgRUcvfPJFaImk3sEg0P0iHGCEh8m3yIBWSMhICs
	xKYDzBAlkhIHV9xgmcAovICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYASc/vesbwfj
	zQPWhxiTgcZNZJYSTc4HRlBeSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamDcsGlVQ6js9FThIDFpQ8nADGHtvnz1A64xi14nZp/gmXdQI1mJw9iy
	asp29SZbDxFvx2t61XPbWZftKpCedUfS+CTbisoK96faAuEpty4F9yrmexnc7f9fdye050jr
	ZlPZ5wo68y+vDZmTUdQ6b4vL6du5h48mGHjP7DeMz5z/sW6eYl0lkxJLcUaioRZzUXEiAB+3
	KgaWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd0vJWlBBg+2Mlkc3Kppcf3Lc1aL
	+UfOsVpMXDmZ2eLAnx2MFmeb3rBbXN41h83iduMKNovDKw4wOXB6LPh8hd1jQv8nRo/NK7Q8
	7lzbw+bRt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPe
	HP7MWNBlVbFq5gPGBsYj+l2MnBwSAiYSz/7NZ4awxSQu3FvP1sXIxSEksIhR4tLRW1BOI5PE
	sWkbwKrYBLQk9r+4wQZiiwj4SVx/u40JpIhZYDqjxMqFfawgCWGBPImfR38wgdgsAqoSpyZ9
	BbI5OHgFXCXWzdaE2CYn8WHPI3YQm1PATWLf1F9g5UJAJXf/TGKdwMi7gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwhD2T3sG4qsHiEKMAB6MSD2+GVWqQEGtiWXFl7iFGCQ5mJRHe
	Zt+0ICHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB0Z/Xkm8obGJmZGlkbmhhZGxOWnCSuK8
	B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwmpiLbQjO3X/oTL4tx1It2dSm6e7fujTuFPTnSa5I
	+TvV/XtysFvmt/UJl3SFfvpOCFCUE2/62m/wQtbhtEhyOUPKp+2bat8za878tlDbd6H/XIbT
	lsEPXhg+uSHEID/PTE2XxYXzfN8OYcGorfoq7ww6ku4vvubHOY2d9bfb66xl2TMuWjsrsRRn
	JBpqMRcVJwIA+HR4x/QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support charger-manager use IIO(Industrial I/O) subsystem to read
current battery temperature instead of legacy methor about callback function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/Kconfig                 |  1 +
 drivers/power/charger-manager.c       | 88 +++++++++++++++++++++++++++++++++--
 include/linux/power/charger-manager.h | 13 ++++++
 3 files changed, 97 insertions(+), 5 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e6f92b4..6700191 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -309,6 +309,7 @@ config CHARGER_MANAGER
 	bool "Battery charger manager for multiple chargers"
 	depends on REGULATOR && RTC_CLASS
 	select EXTCON
+	select IIO
 	help
           Say Y to enable charger-manager support, which allows multiple
           chargers attached to a battery and multiple batteries attached to a
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index cc720f9..02a395c 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -26,6 +26,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>
+#include <linux/iio/consumer.h>
 
 static const char * const default_event_names[] = {
 	[CM_EVENT_UNKNOWN] = "Unknown",
@@ -542,6 +543,50 @@ static int check_charging_duration(struct charger_manager *cm)
 }
 
 /**
+ * read_battery_temperature - Read current battery temperature
+ * @cm: the Charger Manager representing the battery.
+ * @last_temp_mC: store current battery temperature
+ *
+ * Returns current state of temperature by using IIO or legacy method
+ * - CM_TEMP_NORMAL
+ * - CM_TEMP_OVERHEAT
+ * - CM_TEMP_COLD
+ */
+static int read_battery_temperature(struct charger_manager *cm,
+				    int *last_temp_mC)
+{
+	struct charger_desc *desc = cm->desc;
+	int temp;
+
+	if (desc->channel) {
+		temp = iio_read_channel_raw(desc->channel, last_temp_mC);
+
+		/*
+		 * The charger-manager use IIO subsystem to read ADC raw data
+		 * from IIO ADC device drvier. The each device driver has
+		 * own non-standard ADC table. If user of charger-manager
+		 * would like to get correct temperature value, have to convert
+		 * 'last_temp_mC' variable according to proper calculation
+		 * method and own ADC table.
+		 */
+
+		if (*last_temp_mC >= desc->iio_adc_overheat)
+			temp = CM_TEMP_NORMAL;	/* Overheat */
+		else if (*last_temp_mC <= desc->iio_adc_cold)
+			temp = CM_TEMP_COLD;	/* Cold */
+		else
+			temp = CM_TEMP_NORMAL;	/* Normal */
+
+	} else if (desc->temperature_out_of_range) {
+		temp = desc->temperature_out_of_range(last_temp_mC);
+	} else {
+		temp = INT_MAX;
+	}
+
+	return temp;
+}
+
+/**
  * _cm_monitor - Monitor the temperature and return true for exceptions.
  * @cm: the Charger Manager representing the battery.
  *
@@ -551,7 +596,7 @@ static int check_charging_duration(struct charger_manager *cm)
 static bool _cm_monitor(struct charger_manager *cm)
 {
 	struct charger_desc *desc = cm->desc;
-	int temp = desc->temperature_out_of_range(&cm->last_temp_mC);
+	int temp = read_battery_temperature(cm, &cm->last_temp_mC);
 
 	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
 		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
@@ -805,7 +850,7 @@ static int charger_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		/* in thenth of centigrade */
 		if (cm->last_temp_mC == INT_MIN)
-			desc->temperature_out_of_range(&cm->last_temp_mC);
+			read_battery_temperature(cm, &cm->last_temp_mC);
 		val->intval = cm->last_temp_mC / 100;
 		if (!desc->measure_battery_temp)
 			ret = -ENODEV;
@@ -813,7 +858,7 @@ static int charger_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		/* in thenth of centigrade */
 		if (cm->last_temp_mC == INT_MIN)
-			desc->temperature_out_of_range(&cm->last_temp_mC);
+			read_battery_temperature(cm, &cm->last_temp_mC);
 		val->intval = cm->last_temp_mC / 100;
 		if (desc->measure_battery_temp)
 			ret = -ENODEV;
@@ -1586,6 +1631,32 @@ static int charger_manager_dt_parse_regulator(struct device *dev,
 	return 0;
 }
 
+static int charger_manager_dt_parse_iio(struct device *dev,
+					      struct charger_desc *desc)
+{
+	struct device_node *np = dev->of_node;
+
+	if (of_property_read_u32(np, "iio-adc-overheat",
+				&desc->iio_adc_overheat)) {
+		dev_warn(dev, "cannot get standard value for hot temperature\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(np, "iio-adc-cold",
+				&desc->iio_adc_cold)) {
+		dev_warn(dev, "cannot get standard value for cold temperature\n");
+		return -EINVAL;
+	}
+
+	desc->channel = iio_channel_get(dev, NULL);
+	if (IS_ERR(desc->channel)) {
+		dev_err(dev, "cannot get iio channel\n");
+		return PTR_ERR(desc->channel);
+	}
+
+	return 0;
+}
+
 static struct charger_desc *charger_manager_dt_parse(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -1688,6 +1759,11 @@ static struct charger_desc *charger_manager_dt_parse(struct device *dev)
 	desc->charging_max_duration_ms *= (60 * 1000);
 	desc->discharging_max_duration_ms *= (60 * 1000);
 
+	if (charger_manager_dt_parse_iio(dev, desc)) {
+		dev_err(dev, "cannot get iio device to read temperature\n");
+		return NULL;
+	}
+
 	return desc;
 }
 #else
@@ -1814,8 +1890,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 		goto err_chg_stat;
 	}
 
-	if (!desc->temperature_out_of_range) {
-		dev_err(&pdev->dev, "there is no temperature_out_of_range\n");
+	if (!desc->channel && !desc->temperature_out_of_range) {
+		dev_err(&pdev->dev, "there is no temperature function\n");
 		ret = -EINVAL;
 		goto err_chg_stat;
 	}
@@ -1986,6 +2062,8 @@ static int charger_manager_remove(struct platform_device *pdev)
 
 	try_charger_enable(cm, false);
 
+	iio_channel_release(desc->channel);
+
 	kfree(cm->charger_psy.properties);
 	kfree(cm->charger_stat);
 	kfree(cm->desc);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 8696fb8..33dfc69 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -42,6 +42,12 @@ enum cm_event_types {
 	CM_EVENT_OTHERS,
 };
 
+enum cm_temperature_types {
+	CM_TEMP_COLD = -1,
+	CM_TEMP_NORMAL = 0,
+	CM_TEMP_OVERHEAT = 1,
+};
+
 /**
  * struct charger_global_desc
  * @rtc_name: the name of RTC used to wake up the system from suspend.
@@ -188,6 +194,9 @@ struct charger_regulator {
  *	Maximum possible duration for discharging with charger cable
  *	after full-batt. If discharging duration exceed 'discharging
  *	max_duration_ms', cm start charging.
+ * @channel: filled with a channel from iio
+ * @iio_adc_overheat: the value of the highest ADC for temperature
+ * @iio_adc_cold: the value of the lowest ADC for temperature
  */
 struct charger_desc {
 	const char *psy_name;
@@ -215,6 +224,10 @@ struct charger_desc {
 
 	unsigned int charging_max_duration_ms;
 	unsigned int discharging_max_duration_ms;
+
+	struct iio_channel *channel;
+	int iio_adc_overheat;
+	int iio_adc_cold;
 };
 
 #define PSY_NAME_MAX	30
-- 
1.8.0

