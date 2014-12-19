Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaLSI4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:56:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaLSIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:40 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-18-5493e803d584
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 08/11] power: charger-manager: Make chraging decision
 focusing on battery status.
Date: Fri, 19 Dec 2014 17:55:20 +0900
Message-id: <1418979323-7188-9-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkQJflxeQQg5VnWS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZdw8fpytYI1bxev5D5ga
	GL9YdDFyckgImEisf7WRFcIWk7hwbz1bFyMXh5DAUkaJhZvmscIUvV5wjgkiMZ1RYtOnTSwQ
	ThuTxOcHn9hBqtgEdCT+77sJZosIKEhs7n3GClLELHCFUeLm4vVA7RwcwgJpEm+vhIDUsAio
	Siza85AZxOYVcJfYuXsWI0iJBFDvnEk2IGFOAQ+JPye3MIHYQkAljVu+s0MctI9d4tQKDYgx
	AhLfJh9igWiVldh0gBmiRFLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93E
	CIyI0/+eTdjBeO+A9SFGAQ5GJR7eB8WTQ4RYE8uKK3MPMZoCbZjILCWanA+Mu7ySeENjMyML
	UxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB2bTniFDH11Zf9XtFW
	VlukvFSZS799m+pblqVWyu0vkxKS8fiCuX/OT51cp7zTXmIHr72zeFBvzuC/be6s8ALxyxal
	hn2WYd9rTFv/rDtgM8lN12aryj5uV8ejbC/2vV7s9SpWb0VDiv7+jftnM26YXe27NWLtppON
	gt29kkfmPSnZ+2q33A8lluKMREMt5qLiRAAlF2QagwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDI5vsbA4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj5vHjbAVr3Cpez3/A1MD4xaKLkZNDQsBE4vWCc0wQtpjEhXvr2boYuTiEBKYz
	Smz6tIkFwmljkvj84BM7SBWbgI7E/303wWwRAQWJzb3PWEGKmAWuMErcXLweaBQHh7BAmsTb
	KyEgNSwCqhKL9jxkBrF5Bdwldu6exQhSIgHUO2eSDUiYU8BD4s/JLWBHCAGVNG75zj6BkXcB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCIeya9g3FVg8UhRgEORiUe3o7CySFCrIll
	xZW5hxglOJiVRHgdjwOFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YDPJK4g2NTcyMLI3M
	DS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhgVWkqbX/yaEPupu26h8NpJbYJ1LNaO
	K+7180xTv6HK3rXU27ZjQpMw2x/nGZsqhK6niIbN/64Wqh4SxPL7kcr+vl9nnwdrqpS3vrh9
	NLx4zVIO451iNjf/ap9hEmyZFS9tYa0WffnlIYErZXZ77FcFHXpwyEs9h/1qSb7j4mUHel68
	1tGdWKXEUpyRaKjFXFScCADyUJqZzgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cm_monitor() where charging management starts, it checks various charging
condition sequentially to decide next charging operation. However, as it
follows sequential process, cascaded IF statements, it does some duplicated
jobs which is already done in previous stage. It results delay in decision
making. And moreover, starting point of charing is spreaded all around, so
it makes maintain codes and debugging difficult.

Both of problems mentioned above becomes clean if it manages battery charging
focusing on battery status not following sequential condition checking.
Now, cm_monitor() moves battery state diagram and does optimal operation for
current state. As a result, it reduces whole monitoring time almost in half.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c       |  177 +++++++++++----------------------
 include/linux/power/charger-manager.h |    3 +
 2 files changed, 62 insertions(+), 118 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index dc15436..44cc19a 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -249,6 +249,19 @@ static bool is_full_charged(struct charger_manager *cm)
 	if (!fuel_gauge)
 		return false;
 
+	/* Full, if it's over the fullbatt voltage */
+	if (desc->fullbatt_uV > 0) {
+		ret = get_batt_uV(cm, &uV);
+		if (!ret) {
+			/* Battery is already full, checks voltage drop. */
+			if (cm->battery_status == POWER_SUPPLY_STATUS_FULL
+					&& desc->fullbatt_vchkdrop_uV)
+				uV += desc->fullbatt_vchkdrop_uV;
+			if (uV >= desc->fullbatt_uV)
+				return true;
+		}
+	}
+
 	if (desc->fullbatt_full_capacity > 0) {
 		val.intval = 0;
 
@@ -259,13 +272,6 @@ static bool is_full_charged(struct charger_manager *cm)
 			return true;
 	}
 
-	/* Full, if it's over the fullbatt voltage */
-	if (desc->fullbatt_uV > 0) {
-		ret = get_batt_uV(cm, &uV);
-		if (!ret && uV >= desc->fullbatt_uV)
-			return true;
-	}
-
 	/* Full, if the capacity is more than fullbatt_soc */
 	if (desc->fullbatt_soc > 0) {
 		val.intval = 0;
@@ -376,67 +382,13 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		}
 	}
 
-	if (!err) {
+	if (!err)
 		cm->charger_enabled = enable;
-		power_supply_changed(&cm->charger_psy);
-	}
 
 	return err;
 }
 
 /**
- * try_charger_restart - Restart charging.
- * @cm: the Charger Manager representing the battery.
- *
- * Restart charging by turning off and on the charger.
- */
-static int try_charger_restart(struct charger_manager *cm)
-{
-	int err;
-
-	if (cm->emergency_stop)
-		return -EAGAIN;
-
-	err = try_charger_enable(cm, false);
-	if (err)
-		return err;
-
-	return try_charger_enable(cm, true);
-}
-
-/**
- * fullbatt_vchk - Check voltage drop some times after "FULL" event.
- *
- * If a user has designated "fullbatt_vchkdrop_uV" values with
- * charger_desc, Charger Manager checks voltage drop after the battery
- * "FULL" event. It checks whether the voltage has dropped more than
- * fullbatt_vchkdrop_uV by calling this function after fullbatt_vchkrop_ms.
- */
-static void fullbatt_vchk(struct charger_manager *cm)
-{
-	struct charger_desc *desc = cm->desc;
-	int batt_uV, err, diff;
-
-	if (!desc->fullbatt_vchkdrop_uV)
-		return;
-
-	err = get_batt_uV(cm, &batt_uV);
-	if (err) {
-		dev_err(cm->dev, "%s: get_batt_uV error(%d)\n", __func__, err);
-		return;
-	}
-
-	diff = desc->fullbatt_uV - batt_uV;
-	if (diff < 0)
-		return;
-
-	dev_info(cm->dev, "VBATT dropped %duV after full-batt\n", diff);
-
-	if (diff > desc->fullbatt_vchkdrop_uV)
-		try_charger_restart(cm);
-}
-
-/**
  * check_charging_duration - Monitor charging/discharging duration
  * @cm: the Charger Manager representing the battery.
  *
@@ -463,17 +415,14 @@ static int check_charging_duration(struct charger_manager *cm)
 		if (duration > desc->charging_max_duration_ms) {
 			dev_info(cm->dev, "Charging duration exceed %ums\n",
 				 desc->charging_max_duration_ms);
-			try_charger_enable(cm, false);
 			ret = true;
 		}
-	} else if (is_ext_pwr_online(cm) && !cm->charger_enabled) {
+	} else if (cm->battery_status == POWER_SUPPLY_STATUS_NOT_CHARGING) {
 		duration = curr - cm->charging_end_time;
 
-		if (duration > desc->charging_max_duration_ms &&
-				is_ext_pwr_online(cm)) {
+		if (duration > desc->charging_max_duration_ms) {
 			dev_info(cm->dev, "Discharging duration exceed %ums\n",
 				 desc->discharging_max_duration_ms);
-			try_charger_enable(cm, true);
 			ret = true;
 		}
 	}
@@ -527,10 +476,45 @@ static int cm_check_thermal_status(struct charger_manager *cm)
 	else if (temp < lower_limit)
 		ret = CM_EVENT_BATT_COLD;
 
+	cm->emergency_stop = ret;
+
 	return ret;
 }
 
 /**
+ * cm_get_target_status - Check current status and get next target status.
+ * @cm: the Charger Manager representing the battery.
+ */
+static int cm_get_target_status(struct charger_manager *cm)
+{
+	if (!is_ext_pwr_online(cm))
+		return POWER_SUPPLY_STATUS_DISCHARGING;
+
+	if (cm_check_thermal_status(cm)) {
+		/* Check if discharging duration exeeds limit. */
+		if (check_charging_duration(cm))
+			goto charging_ok;
+		return POWER_SUPPLY_STATUS_NOT_CHARGING;
+	}
+
+	switch (cm->battery_status) {
+	case POWER_SUPPLY_STATUS_CHARGING:
+		/* Check if charging duration exeeds limit. */
+		if (check_charging_duration(cm))
+			return POWER_SUPPLY_STATUS_FULL;
+	case POWER_SUPPLY_STATUS_FULL:
+		if (is_full_charged(cm))
+			return POWER_SUPPLY_STATUS_FULL;
+	default:
+		break;
+	}
+
+charging_ok:
+	/* Charging is allowed. */
+	return POWER_SUPPLY_STATUS_CHARGING;
+}
+
+/**
  * _cm_monitor - Monitor the temperature and return true for exceptions.
  * @cm: the Charger Manager representing the battery.
  *
@@ -539,56 +523,18 @@ static int cm_check_thermal_status(struct charger_manager *cm)
  */
 static bool _cm_monitor(struct charger_manager *cm)
 {
-	int temp_alrt;
+	int target;
 
-	temp_alrt = cm_check_thermal_status(cm);
+	target = cm_get_target_status(cm);
 
-	/* It has been stopped already */
-	if (temp_alrt && cm->emergency_stop)
-		return false;
-
-	/*
-	 * Check temperature whether overheat or cold.
-	 * If temperature is out of range normal state, stop charging.
-	 */
-	if (temp_alrt) {
-		cm->emergency_stop = temp_alrt;
-		try_charger_enable(cm, false);
-
-	/*
-	 * Check whole charging duration and discharing duration
-	 * after full-batt.
-	 */
-	} else if (!cm->emergency_stop && check_charging_duration(cm)) {
-		dev_dbg(cm->dev,
-			"Charging/Discharging duration is out of range\n");
-	/*
-	 * Check dropped voltage of battery. If battery voltage is more
-	 * dropped than fullbatt_vchkdrop_uV after fully charged state,
-	 * charger-manager have to recharge battery.
-	 */
-	} else if (!cm->emergency_stop && is_ext_pwr_online(cm) &&
-			!cm->charger_enabled) {
-		fullbatt_vchk(cm);
+	try_charger_enable(cm, (target == POWER_SUPPLY_STATUS_CHARGING));
 
-	/*
-	 * Check whether fully charged state to protect overcharge
-	 * if charger-manager is charging for battery.
-	 */
-	} else if (!cm->emergency_stop && is_full_charged(cm) &&
-			cm->charger_enabled) {
-		dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged\n");
-		try_charger_enable(cm, false);
-
-		fullbatt_vchk(cm);
-	} else {
-		cm->emergency_stop = 0;
-		if (is_ext_pwr_online(cm)) {
-			try_charger_enable(cm, true);
-		}
+	if (cm->battery_status != target) {
+		cm->battery_status = target;
+		power_supply_changed(&cm->charger_psy);
 	}
 
-	return true;
+	return (cm->battery_status == POWER_SUPPLY_STATUS_NOT_CHARGING);
 }
 
 /**
@@ -694,12 +640,7 @@ static int charger_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (is_charging(cm))
-			val->intval = POWER_SUPPLY_STATUS_CHARGING;
-		else if (is_ext_pwr_online(cm))
-			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-		else
-			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		val->intval = cm->battery_status;
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
 		if (cm->emergency_stop > 0)
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 22a8097..37fb181 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -220,6 +220,7 @@ struct charger_desc {
  *	saved status of battery before entering suspend-to-RAM
  * @charging_start_time: saved start time of enabling charging
  * @charging_end_time: saved end time of disabling charging
+ * @battery_status: Current battery status
  */
 struct charger_manager {
 	struct list_head entry;
@@ -237,6 +238,8 @@ struct charger_manager {
 
 	u64 charging_start_time;
 	u64 charging_end_time;
+
+	int battery_status;
 };
 
 #endif /* _CHARGER_MANAGER_H */
-- 
1.7.9.5

