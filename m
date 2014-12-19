Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaLSI6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:58:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaLSIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:37 -0500
X-AuditID: cbfee68e-f79b46d000002b74-8b-5493e8039c93
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 03/11] power: charger-manager: Use power_supply_changed()
 not private uevent.
Date: Fri, 19 Dec 2014 17:55:15 +0900
Message-id: <1418979323-7188-4-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkRJf5xeQQgxddshYHt2paXP/ynNVi
	0pP3zBYTV05mtug8+4TZ4vKuOWwWn3uPMFrcblzBZnH31FE2i9O7Sxy4PCb0f2L02DnrLrvH
	5hVaHptWdbJ59G1ZxeixYvV3do/Pm+QC2KO4bFJSczLLUov07RK4MuasP81acN+k4vqGP6wN
	jHu1uxg5OSQETCTuH/jIDmGLSVy4t54NxBYSWMoo8W9FFEzNtjlXgOJcQPHpjBJ7Nn9lhHDa
	mCQ+P/gE1s0moCPxf99NMFtEQEFic+8zVpAiZoErjBI3F69nAkkICyRJzPn9hBXEZhFQlbj6
	fzYziM0r4C5xZ9NxoDgH0DoFiTmTbEDCnAIeEn9ObmGCuMhdonHLd3aQmRICu9glNl98wwwx
	R0Di2+RDLBC9shKbDjBDXC0pcXDFDZYJjMILGBlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+du
	YgTGxOl/z/p2MN48YH2IUYCDUYmHt6NwcogQa2JZcWXuIUZToA0TmaVEk/OBkZdXEm9obGZk
	YWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjtKHVrk0yJ2W25M97
	87CgM2NH7AnzTcd91gZpfzjyzqGtYmr24qPe+VOfJidmr17yMO/bdS0Tw4iDqjvC9I5kL5Fe
	mxPffuoBf2F+wxTWBQK3Ngg8C/9Xr+g+Z/bvxMhtecc5tP9ZiXSxHlg/Mfouw+sN11TEX+Wc
	uX3TaT3LGtWvDfJSzs7XlViKMxINtZiLihMBxRUlLoQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDA4tErE4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFjzvrTrAX3TSqub/jD2sC4V7uLkZNDQsBEYtucK2wQtpjEhXvrgWwuDiGB6YwS
	ezZ/ZYRw2pgkPj/4xA5SxSagI/F/300wW0RAQWJz7zNWkCJmgSuMEjcXr2cCSQgLJEnM+f2E
	FcRmEVCVuPp/NjOIzSvgLnFn03GgOAfQOgWJOZNsQMKcAh4Sf05uAWsVAipp3PKdfQIj7wJG
	hlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTH3THoH46oGi0OMAhyMSjy8HYWTQ4RYE8uK
	K3MPMUpwMCuJ8DoeBwrxpiRWVqUW5ccXleakFh9iNAU6aiKzlGhyPjAd5JXEGxqbmBlZGpkb
	WhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MNYccuI84/NVcb5W373s2/v2aj/yO6jb
	WcwYHt8ssPvv0uXdO40mldx8dV32xAvpR/zznjeExLOl7fly5oeMYHOb34drYi+LHvkty42V
	trkQ8CH7BB+z6EmdOn2hRI34iAvSE4PTZY7dWudq+PqzfhKHs7k/X9F05UVB6z9WGTYIpzkx
	vrCLVmIpzkg01GIuKk4EABVbuXHPAgAA
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
index 71a3df7..8c76bce 100644
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

