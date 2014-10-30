Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbaJ3Mqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:46:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33177 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544AbaJ3MnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:23 -0400
X-AuditID: cbfee68f-f791c6d000004834-dd-545232683bc7
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 02/10] power: charger-manager: Use power_supply_changed() not
 private uevent.
Date: Thu, 30 Oct 2014 21:43:08 +0900
Message-id: <1414672996-28355-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkRDfDKCjE4EKHlcXBrZoW1788Z7WY
	9OQ9s8XElZOZLTrPPmG2uLxrDpvF594jjBa3G1ewWdw9dZTN4vTuEgcujwn9nxg9ds66y+6x
	eYWWx6ZVnWwefVtWMXqsWP2d3ePzJrkA9igum5TUnMyy1CJ9uwSujHtz3Arum1Q0/zrJ2MC4
	V7uLkZNDQsBEoq3tFiOELSZx4d56ti5GLg4hgaWMEt+PbWOGKVr5YQojRGIRo8TX5plQThuT
	xPmze8Da2QR0JP7vu8kOYosIKEhs7n3GClLELHCFUeLm4vVMIAlhgXiJKTd72UBsFgFViUl/
	H4M18Ap4SOxbdxvI5gBapyAxZ5INSJhTwFNi05WZLCC2EFDJg11d7CAzJQT2sUucWX6NGWKO
	gMS3yYdYIHplJTYdgLpaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQI
	jInT/57172C8e8D6EKMAB6MSD6/GicAQIdbEsuLK3EOMpkAbJjJLiSbnAyMvryTe0NjMyMLU
	xNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJUs+TIvHLv8Jn01ntMX
	ecnu5v2Idu8ZH39/vrNvRrOzxSTP3JSNH13N3k1q6lbX6zO5KPoqo7ryppH4dZOoCV4zVngz
	1ZlOtDfr3VbkzZ0UE2/pmCX0+lb4TlZDZa/bHL2TLuq/4FwTueaezuovr2SyVn5aGGlv/bTv
	bONuqduZHvIzi86wKLEUZyQaajEXFScCAAuTcE+EAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd0Mo6AQg32HDCwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcy4N8et4L5JRfOvk4wNjHu1uxg5OSQETCRWfpjCCGGLSVy4t56ti5GLQ0hgEaPE
	1+aZjBBOG5PE+bN7wKrYBHQk/u+7yQ5iiwgoSGzufcYKUsQscIVR4ubi9UwgCWGBeIkpN3vZ
	QGwWAVWJSX8fgzXwCnhI7Ft3G8jmAFqnIDFnkg1ImFPAU2LTlZksILYQUMmDXV3sExh5FzAy
	rGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjrhnUjsYVzZYHGIU4GBU4uHVOBEYIsSaWFZc
	mXuIUYKDWUmE96hOUIgQb0piZVVqUX58UWlOavEhRlOgoyYyS4km5wOTQV5JvKGxiZmRpZG5
	oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsZdp7sTC7Ju3D0pPTdatfTgpx8M19bU
	rL694ImO3SWxVSs+cJ16tSvXa+fR2kn1ixbdXzGl7M+c6XpSSx8qHZ/bfOv9nulvfqy4PyV1
	2t0Kn1cSp4LXHF2Q93l9r9JVy2hj+U3vVtdf7juwU3vp7MdioqkV7Je95DOOv94t5Bsmpzov
	aZngNv8ttkosxRmJhlrMRcWJAEXZ6mHOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever battery status is changed, charger manager tries to trigger uevent
through private interface. This patch modifies it to use power_supply_changed()
since it belongs to power supply subsystem.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   91 +++++----------------------------------
 1 file changed, 11 insertions(+), 80 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index b4b101c..33a1a4d 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -28,18 +28,6 @@
 #include <linux/of.h>
 #include <linux/thermal.h>
 
-static const char * const default_event_names[] = {
-	[CM_EVENT_UNKNOWN] = "Unknown",
-	[CM_EVENT_BATT_FULL] = "Battery Full",
-	[CM_EVENT_BATT_IN] = "Battery Inserted",
-	[CM_EVENT_BATT_OUT] = "Battery Pulled Out",
-	[CM_EVENT_BATT_OVERHEAT] = "Battery Overheat",
-	[CM_EVENT_BATT_COLD] = "Battery Cold",
-	[CM_EVENT_EXT_PWR_IN_OUT] = "External Power Attach/Detach",
-	[CM_EVENT_CHG_START_STOP] = "Charging Start/Stop",
-	[CM_EVENT_OTHERS] = "Other battery events"
-};
-
 /*
  * Regard CM_JIFFIES_SMALL jiffies is small enough to ignore for
  * delayed works so that we can run delayed works with CM_JIFFIES_SMALL
@@ -56,8 +44,6 @@ static const char * const default_event_names[] = {
  */
 #define CM_RTC_SMALL		(2)
 
-#define UEVENT_BUF_SIZE		32
-
 static LIST_HEAD(cm_list);
 static DEFINE_MUTEX(cm_list_mtx);
 
@@ -423,61 +409,6 @@ static int try_charger_restart(struct charger_manager *cm)
 }
 
 /**
- * uevent_notify - Let users know something has changed.
- * @cm: the Charger Manager representing the battery.
- * @event: the event string.
- *
- * If @event is null, it implies that uevent_notify is called
- * by resume function. When called in the resume function, cm_suspended
- * should be already reset to false in order to let uevent_notify
- * notify the recent event during the suspend to users. While
- * suspended, uevent_notify does not notify users, but tracks
- * events so that uevent_notify can notify users later after resumed.
- */
-static void uevent_notify(struct charger_manager *cm, const char *event)
-{
-	static char env_str[UEVENT_BUF_SIZE + 1] = "";
-	static char env_str_save[UEVENT_BUF_SIZE + 1] = "";
-
-	if (cm_suspended) {
-		/* Nothing in suspended-event buffer */
-		if (env_str_save[0] == 0) {
-			if (!strncmp(env_str, event, UEVENT_BUF_SIZE))
-				return; /* status not changed */
-			strncpy(env_str_save, event, UEVENT_BUF_SIZE);
-			return;
-		}
-
-		if (!strncmp(env_str_save, event, UEVENT_BUF_SIZE))
-			return; /* Duplicated. */
-		strncpy(env_str_save, event, UEVENT_BUF_SIZE);
-		return;
-	}
-
-	if (event == NULL) {
-		/* No messages pending */
-		if (!env_str_save[0])
-			return;
-
-		strncpy(env_str, env_str_save, UEVENT_BUF_SIZE);
-		kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
-		env_str_save[0] = 0;
-
-		return;
-	}
-
-	/* status not changed */
-	if (!strncmp(env_str, event, UEVENT_BUF_SIZE))
-		return;
-
-	/* save the status and notify the update */
-	strncpy(env_str, event, UEVENT_BUF_SIZE);
-	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
-
-	dev_info(cm->dev, "%s\n", event);
-}
-
-/**
  * fullbatt_vchk - Check voltage drop some times after "FULL" event.
  * @work: the work_struct appointing the function
  *
@@ -514,7 +445,7 @@ static void fullbatt_vchk(struct work_struct *work)
 
 	if (diff > desc->fullbatt_vchkdrop_uV) {
 		try_charger_restart(cm);
-		uevent_notify(cm, "Recharging");
+		power_supply_changed(&cm->charger_psy);
 	}
 }
 
@@ -545,7 +476,7 @@ static int check_charging_duration(struct charger_manager *cm)
 		if (duration > desc->charging_max_duration_ms) {
 			dev_info(cm->dev, "Charging duration exceed %ums\n",
 				 desc->charging_max_duration_ms);
-			uevent_notify(cm, "Discharging");
+			power_supply_changed(&cm->charger_psy);
 			try_charger_enable(cm, false);
 			ret = true;
 		}
@@ -556,7 +487,7 @@ static int check_charging_duration(struct charger_manager *cm)
 				is_ext_pwr_online(cm)) {
 			dev_info(cm->dev, "Discharging duration exceed %ums\n",
 				 desc->discharging_max_duration_ms);
-			uevent_notify(cm, "Recharging");
+			power_supply_changed(&cm->charger_psy);
 			try_charger_enable(cm, true);
 			ret = true;
 		}
@@ -638,7 +569,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 	if (temp_alrt) {
 		cm->emergency_stop = temp_alrt;
 		if (!try_charger_enable(cm, false))
-			uevent_notify(cm, default_event_names[temp_alrt]);
+			power_supply_changed(&cm->charger_psy);
 
 	/*
 	 * Check whole charging duration and discharing duration
@@ -663,7 +594,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 	} else if (!cm->emergency_stop && is_full_charged(cm) &&
 			cm->charger_enabled) {
 		dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged\n");
-		uevent_notify(cm, default_event_names[CM_EVENT_BATT_FULL]);
+		power_supply_changed(&cm->charger_psy);
 
 		try_charger_enable(cm, false);
 
@@ -672,7 +603,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 		cm->emergency_stop = 0;
 		if (is_ext_pwr_online(cm)) {
 			if (!try_charger_enable(cm, true))
-				uevent_notify(cm, "CHARGING");
+				power_supply_changed(&cm->charger_psy);
 		}
 	}
 
@@ -793,7 +724,7 @@ static void fullbatt_handler(struct charger_manager *cm)
 
 out:
 	dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged\n");
-	uevent_notify(cm, default_event_names[CM_EVENT_BATT_FULL]);
+	power_supply_changed(&cm->charger_psy);
 }
 
 /**
@@ -807,9 +738,9 @@ static void battout_handler(struct charger_manager *cm)
 
 	if (!is_batt_present(cm)) {
 		dev_emerg(cm->dev, "Battery Pulled Out!\n");
-		uevent_notify(cm, default_event_names[CM_EVENT_BATT_OUT]);
+		power_supply_changed(&cm->charger_psy);
 	} else {
-		uevent_notify(cm, "Battery Reinserted?");
+		power_supply_changed(&cm->charger_psy);
 	}
 }
 
@@ -826,7 +757,7 @@ static void misc_event_handler(struct charger_manager *cm,
 
 	if (is_polling_required(cm) && cm->desc->polling_interval_ms)
 		schedule_work(&setup_polling);
-	uevent_notify(cm, default_event_names[type]);
+	power_supply_changed(&cm->charger_psy);
 }
 
 static int charger_get_property(struct power_supply *psy,
@@ -1988,7 +1919,7 @@ void cm_notify_event(struct power_supply *psy, enum cm_event_types type,
 		break;
 	case CM_EVENT_UNKNOWN:
 	case CM_EVENT_OTHERS:
-		uevent_notify(cm, msg ? msg : default_event_names[type]);
+		power_supply_changed(&cm->charger_psy);
 		break;
 	default:
 		dev_err(cm->dev, "%s: type not specified\n", __func__);
-- 
1.7.9.5

