Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaLSCth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:49:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36086 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaLSCrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:39 -0500
X-AuditID: cbfee691-f79b86d000004a5a-23-549391c91faf
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 07/10] power: charger-manager: Make chraging decision
 focusing on battery status.
Date: Fri, 19 Dec 2014 11:47:27 +0900
Message-id: <1418957250-6542-8-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkSPfkxMkhBr/7xC0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZew+2clYsMat4uCpNSwN
	jF8suhg5OSQETCQuTFzBCGGLSVy4t56ti5GLQ0hgKaPE9CuLGGGKJnw9yw6RWMQo8aZ1FguE
	08YksePyVzaQKjYBHYn/+26yg9giAgoSm3ufsYIUMQtcYZS4uXg9E0hCWCBX4uDS02BFLAKq
	Ek+3f2cFsXkF3CWun1wFNIgDaJ2CxJxJNiBhTgEPiaeXmsDmCwGVnPj2FmyxhMA+don3iw5A
	zRGQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5
	mxiBUXH637OJOxjvH7A+xCjAwajEw/ugeHKIEGtiWXFl7iFGU6ANE5mlRJPzgbGXVxJvaGxm
	ZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD48HJ217qJjRd/TXn
	rlbQ/NZD+5h54rab/7gx7Zv1TJfp21P11JuNm2911N6Z0V1kY1WkkOG35HnJg3TXhWVfKo9F
	e33Qm1DVdIVJyf/uxINWrRMfXT3ufZXncVnvVMv0+L/TWJ12BGXkt7UdOzHNa83hKX+V+r+u
	6r+q57P4isl8vSixktfX5iqxFGckGmoxFxUnAgAgOcV/hQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd2TEyeHGEz8z21xcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPG7pOdjAVr3CoOnlrD0sD4xaKLkZNDQsBEYsLXs+wQtpjEhXvr2boYuTiEBBYx
	SrxpncUC4bQxSey4/JUNpIpNQEfi/76bYB0iAgoSm3ufsYIUMQtcYZS4uXg9E0hCWCBX4uDS
	02BFLAKqEk+3f2cFsXkF3CWun1wFNIgDaJ2CxJxJNiBhTgEPiaeXmsDmCwGVnPj2lmUCI+8C
	RoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx90x6B+OqBotDjAIcjEo8vB2Fk0OEWBPL
	iitzDzFKcDArifCaZwKFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YDvJK4g2NTcyMLI3M
	DS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhgnJ1lv/H8r+tD1n+W3tM7O/2oe+CbN
	LIPn0UPVB5LHRSL3b6/NyGMvjT/GuvjpZbfM8jUH665Hbb+73KxlK6PGNv3uGU3LAo3PLVdz
	exyhbcgwYxmT4ArPRVyhbBwhFTtMcxO6vFm99inPkn++2/6bxgFtG/+WBZO0X0xVXS213vM3
	677Las+VWIozEg21mIuKEwH2J3UJzwIAAA==
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
index 172dfe5..065b92a 100644
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

