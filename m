Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaLSCtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:49:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45831 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLSCrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:39 -0500
X-AuditID: cbfee691-f79b86d000004a5a-19-549391c832a9
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 02/10] power: charger-manager: Use
 power_supply_changed() not private uevent.
Date: Fri, 19 Dec 2014 11:47:22 +0900
Message-id: <1418957250-6542-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkSPfExMkhBmc/Slkc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI/isklJzcksSy3St0vgyrg3x63gvklF86+TjA2M
	e7W7GDk5JARMJH48PcsKYYtJXLi3ng3EFhJYyijxvjURpubb/tMsXYxcQPFFjBL3ns1ihHDa
	mCTWzF/EBFLFJqAj8X/fTXYQW0RAQWJz7zNWkCJmgSuMEjcXrwcrEhbIlPi48QcjiM0ioCpx
	YsNOMJtXwF1i89Je5i5GDqB1ChJzJtmAhDkFPCSeXmqCushd4sS3t2BXSAjsY5c4M+kaE8Qc
	AYlvkw+xQPTKSmw6wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJ
	ERgRp/89m7iD8f4B60OMAhyMSjy8D4onhwixJpYVV+YeYjQF2jCRWUo0OR8Yd3kl8YbGZkYW
	piamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAaiWqqtWyadKLKeW3k
	HJ9VLmvrg1cWptn7WVgfjBEIeyPd3eqd0vRnhumCzo3nfB0UbMq/6vJ9PrTmmPUX6bbQapmj
	09qmyurcvLKm3GaXZveu00vut6eILjl6YtL3J0LdSaf/b30zcwb3rpXcP++dtb8Yz/rXq6ln
	OdPnj6+0bWM0YtP3fGhXYinOSDTUYi4qTgQAJ6MQAoMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd0TEyeHGGw6IGhxcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGvTluBfdNKpp/nWRsYNyr3cXIySEhYCLxbf9pFghbTOLCvfVsXYxcHEICixgl
	7j2bxQjhtDFJrJm/iAmkik1AR+L/vpvsILaIgILE5t5nrCBFzAJXGCVuLl4PViQskCnxceMP
	RhCbRUBV4sSGnWA2r4C7xOalvcxdjBxA6xQk5kyyAQlzCnhIPL3UxAZiCwGVnPj2lmUCI+8C
	RoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMER90xqB+PKBotDjAIcjEo8vB2Fk0OEWBPL
	iitzDzFKcDArifCaZwKFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YDPJK4g2NTcyMLI3M
	DS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhjT/3LGvlh6q036L8tzu1tv/U+c3vK0
	UfvUt6T1Bs5xc9S+Tt8gPYt9r5dOyd4X+QdW6y3N4e9Rn7x7xS6VG4YPNmb+/ax920U1VMDV
	QbaqwexJpE556WcN93nRXd/Ft83T3t1v6B8yv2jq8ie8UlqHkyQzs08c4DxtulTr4sMrfyuW
	K+0+U6+sxFKckWioxVxUnAgAAao6584CAAA=
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

