Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaLSIzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:55:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaLSIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:33 -0500
X-AuditID: cbfee68e-f79b46d000002b74-82-5493e803e8f0
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 02/11] power: charger-manager: Use thermal subsystem
 interface only to get temperature.
Date: Fri, 19 Dec 2014 17:55:14 +0900
Message-id: <1418979323-7188-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkQJf5xeQQg1OfRS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZXx5t5WtYKFpxe/mD0wN
	jP06XYycHBICJhJffk9ghrDFJC7cW8/WxcjFISSwlFHixM/XjDBFh6+eYYFITGeUmNmyCcpp
	Y5KY+eMvWBWbgI7E/3032UFsEQEFic29z1hBipgFrjBK3Fy8ngkkISyQI3Htzz8WEJtFQFVi
	zZH3YM28Au4Sd66DTOUAWqcgMWeSDUiYU8BD4s/JLWCtQkAljVu+s4PMlBDYxS7R1bqRCWKO
	gMS3yYegemUlNh2AekdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiM
	itP/nvXtYLx5wPoQowAHoxIPb0fh5BAh1sSy4srcQ4ymQBsmMkuJJucDYy+vJN7Q2MzIwtTE
	1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG0mVS/4xfnz3w3ynk9fUv
	l76btSoI/NJge7Xq0M7MyRwMdYGSrozXyzbMXpi+Ko2Z/UBt7/JHvvyZ1y9eOBvs5rC3y6im
	yyal6M22ZGu3iA1tQS4Pwxfe+Gv56Gv6LrbJlz74ljSYFlS+6X+dMPtNgoCJwd7KF38DNkul
	qJ5aa5gn0Z+5Y91VJZbijERDLeai4kQAyPc8t4UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDDZ947E4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHjy7utbAULTSt+N39gamDs1+li5OSQEDCROHz1DAuELSZx4d56ti5GLg4hgemM
	EjNbNrFAOG1MEjN//GUEqWIT0JH4v+8mO4gtIqAgsbn3GStIEbPAFUaJm4vXM4EkhAVyJK79
	+Qc2lkVAVWLNkfdgzbwC7hJ3roNM5QBapyAxZ5INSJhTwEPiz8ktYK1CQCWNW76zT2DkXcDI
	sIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOOaeSe9gXNVgcYhRgINRiYe3o3ByiBBrYllx
	Ze4hRgkOZiURXsfjQCHelMTKqtSi/Pii0pzU4kOMpkBHTWSWEk3OB6aDvJJ4Q2MTMyNLI3ND
	CyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxmhTke55klsP3P0jtE/p/MEvW5rm1Ac8
	lZ+xVpFfO7ovZxPjqZ/mXq/9dfZu2HXxQNrvvtUNh1r3fjeUcGKSjCqdHpb5xDuDde2RuZ1h
	b40fSOvflgj54alleHTiionbOKbwmU6eUy4h8Iw1NvrYRfd+1yU9CvLa06pKzmk5ulkFnOXj
	NJ6ZoMRSnJFoqMVcVJwIAAN1sKnPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It drops the way of using power_supply interface to reference battery's
temperature. Then it tries to use thermal subsystem's only. This makes driver
more simple and also can remove ifdeferies.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/Kconfig                 |    1 +
 drivers/power/charger-manager.c       |  111 ++++++++-------------------------
 include/linux/power/charger-manager.h |    3 +-
 3 files changed, 27 insertions(+), 88 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 8ff2511..9ede4f2 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -316,6 +316,7 @@ config CHARGER_GPIO
 config CHARGER_MANAGER
 	bool "Battery charger manager for multiple chargers"
 	depends on REGULATOR
+	depends on THERMAL
 	select EXTCON
 	help
           Say Y to enable charger-manager support, which allows multiple
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 22246b9..71a3df7 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -28,13 +28,6 @@
 #include <linux/of.h>
 #include <linux/thermal.h>
 
-/*
- * Default termperature threshold for charging.
- * Every temperature units are in tenth of centigrade.
- */
-#define CM_DEFAULT_RECHARGE_TEMP_DIFF	50
-#define CM_DEFAULT_CHARGE_TEMP_MAX	500
-
 static const char * const default_event_names[] = {
 	[CM_EVENT_UNKNOWN] = "Unknown",
 	[CM_EVENT_BATT_FULL] = "Battery Full",
@@ -572,40 +565,18 @@ static int check_charging_duration(struct charger_manager *cm)
 	return ret;
 }
 
-static int cm_get_battery_temperature_by_psy(struct charger_manager *cm,
-					int *temp)
-{
-	struct power_supply *fuel_gauge;
-
-	fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
-	if (!fuel_gauge)
-		return -ENODEV;
-
-	return fuel_gauge->get_property(fuel_gauge,
-				POWER_SUPPLY_PROP_TEMP,
-				(union power_supply_propval *)temp);
-}
-
 static int cm_get_battery_temperature(struct charger_manager *cm,
 					int *temp)
 {
 	int ret;
 
-	if (!cm->desc->measure_battery_temp)
+	if (!cm->tzd_batt)
 		return -ENODEV;
 
-#ifdef CONFIG_THERMAL
-	if (cm->tzd_batt) {
-		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
-		if (!ret)
-			/* Calibrate temperature unit */
-			*temp /= 100;
-	} else
-#endif
-	{
-		/* if-else continued from CONFIG_THERMAL */
-		ret = cm_get_battery_temperature_by_psy(cm, temp);
-	}
+	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
+	if (!ret)
+		/* Calibrate temperature unit */
+		*temp /= 100;
 
 	return ret;
 }
@@ -1007,12 +978,11 @@ static enum power_supply_property default_charger_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_TEMP,
 	/*
 	 * Optional properties are:
 	 * POWER_SUPPLY_PROP_CHARGE_NOW,
 	 * POWER_SUPPLY_PROP_CURRENT_NOW,
-	 * POWER_SUPPLY_PROP_TEMP, and
-	 * POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	 */
 };
 
@@ -1417,49 +1387,6 @@ err:
 	return ret;
 }
 
-static int cm_init_thermal_data(struct charger_manager *cm,
-		struct power_supply *fuel_gauge)
-{
-	struct charger_desc *desc = cm->desc;
-	union power_supply_propval val;
-	int ret;
-
-	/* Verify whether fuel gauge provides battery temperature */
-	ret = fuel_gauge->get_property(fuel_gauge,
-					POWER_SUPPLY_PROP_TEMP, &val);
-
-	if (!ret) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-				POWER_SUPPLY_PROP_TEMP;
-		cm->charger_psy.num_properties++;
-		cm->desc->measure_battery_temp = true;
-	}
-#ifdef CONFIG_THERMAL
-	if (ret && desc->thermal_zone) {
-		cm->tzd_batt =
-			thermal_zone_get_zone_by_name(desc->thermal_zone);
-		if (IS_ERR(cm->tzd_batt))
-			return PTR_ERR(cm->tzd_batt);
-
-		/* Use external thermometer */
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-				POWER_SUPPLY_PROP_TEMP_AMBIENT;
-		cm->charger_psy.num_properties++;
-		cm->desc->measure_battery_temp = true;
-		ret = 0;
-	}
-#endif
-	if (cm->desc->measure_battery_temp) {
-		/* NOTICE : Default allowable minimum charge temperature is 0 */
-		if (!desc->temp_max)
-			desc->temp_max = CM_DEFAULT_CHARGE_TEMP_MAX;
-		if (!desc->temp_diff)
-			desc->temp_diff = CM_DEFAULT_RECHARGE_TEMP_DIFF;
-	}
-
-	return ret;
-}
-
 static struct of_device_id charger_manager_match[] = {
 	{
 		.compatible = "charger-manager",
@@ -1474,6 +1401,7 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 	u32 poll_mode = CM_POLL_DISABLE;
 	u32 battery_stat = CM_NO_BATTERY;
 	int num_chgs = 0;
+	bool monitor_temp = false;
 
 	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
 	if (!desc)
@@ -1517,14 +1445,16 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 
 	of_property_read_string(np, "cm-fuel-gauge", &desc->psy_fuel_gauge);
 
-	of_property_read_string(np, "cm-thermal-zone", &desc->thermal_zone);
-
-	of_property_read_u32(np, "cm-battery-cold", &desc->temp_min);
-	if (of_get_property(np, "cm-battery-cold-in-minus", NULL))
-		desc->temp_min *= -1;
-	of_property_read_u32(np, "cm-battery-hot", &desc->temp_max);
+	if (!of_property_read_u32(np, "cm-battery-cold", &desc->temp_min))
+		monitor_temp = true;
+	if (!of_property_read_u32(np, "cm-battery-hot", &desc->temp_max))
+		monitor_temp = true;
 	of_property_read_u32(np, "cm-battery-temp-diff", &desc->temp_diff);
 
+	if (monitor_temp && of_property_read_string(np,
+				"cm-thermal-zone", &desc->thermal_zone))
+		desc->thermal_zone = desc->psy_fuel_gauge;
+
 	of_property_read_u32(np, "cm-charging-max",
 				&desc->charging_max_duration_ms);
 	of_property_read_u32(np, "cm-discharging-max",
@@ -1733,7 +1663,16 @@ static int charger_manager_probe(struct platform_device *pdev)
 		cm->charger_psy.num_properties++;
 	}
 
-	ret = cm_init_thermal_data(cm, fuel_gauge);
+	if (desc->thermal_zone) {
+		cm->tzd_batt =
+			thermal_zone_get_zone_by_name(desc->thermal_zone);
+		if (!cm->tzd_batt) {
+			pr_err("Failed to get thermal zone (%s).\n",
+				desc->thermal_zone);
+			return -ENODEV;
+		}
+	}
+
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize thermal data\n");
 		cm->desc->measure_battery_temp = false;
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 416ebeb..29d9b19 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -231,9 +231,8 @@ struct charger_manager {
 	struct device *dev;
 	struct charger_desc *desc;
 
-#ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd_batt;
-#endif
+
 	bool charger_enabled;
 
 	unsigned long fullbatt_vchk_jiffies_at;
-- 
1.7.9.5

