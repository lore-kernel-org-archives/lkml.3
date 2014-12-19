Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaLSCrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:47:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58375 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaLSCri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:38 -0500
X-AuditID: cbfee68e-f79b46d000002b74-49-549391c86eeb
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 05/10] power: charger-manager: Concentrate scattered
 power_supply_changed() calls.
Date: Fri, 19 Dec 2014 11:47:25 +0900
Message-id: <1418957250-6542-6-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkRPfkxMkhBo8jLA5u1bS4/uU5q8Wk
	J++ZLSaunMxs0Xn2CbPF5V1z2Cw+9x5htLjduILN4u6po2wWp3eXOHB5TOj/xOixc9Zddo/N
	K7Q8Nq3qZPPo27KK0WPF6u/sHp83yQWwR3HZpKTmZJalFunbJXBlXLp0nbFgjWhF664ZrA2M
	ewS7GDk5JARMJFouf2GBsMUkLtxbz9bFyMUhJLCUUWLyvz/MXYwcYEW79vBCxBcxSiz7c5QR
	wmljklgzfxETSDebgI7E/3032UFsEQEFic29z1hBipgFrjBK3Fy8HqxIWCBPYs//PawgNouA
	qsTq5qfsIBt4Bdwlts4JhlimIDFnkg1IBaeAh8TTS01sILYQUMWJb29ZQEZKCOxjl3iy8B0z
	xBgBiW+TD7FA9MpKbDrADPGMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeul5yf
	u4kRGA+n/z3r28F484D1IUYBDkYlHt6OwskhQqyJZcWVuYcYTYE2TGSWEk3OB0ZdXkm8obGZ
	kYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBrnLidPjyvWNFu0
	yvqF/5n7N+vM9zDqfvzmKGc+OfJ1l2zMxzNWx8xmip5ZVbO47eVKw9n1tvcXGoUfSOt5fb72
	QNWsqT77Lh+4FLlwSjt3UXQQw3l/zWXGxom2++P3K/My6tulfO+9bOnjGMzMquB81OZDyud1
	XaWHI56JSbIliT3/fOsgpxJLcUaioRZzUXEiACdXRTqCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd0TEyeHGOzoN7M4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj0qXrjAVrRCtad81gbWDcI9jFyMEhIWAisWsPbxcjJ5ApJnHh3nq2LkYuDiGB
	RYwSy/4cZYRw2pgk1sxfxARSxSagI/F/3012EFtEQEFic+8zVpAiZoErjBI3F68HKxIWyJPY
	838PK4jNIqAqsbr5KTvINl4Bd4mtc4IhFitIzJlkA1LBKeAh8fRSExuILQRUceLbW5YJjLwL
	GBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH2zPpHYyrGiwOMQpwMCrx8HYUTg4RYk0s
	K67MPcQowcGsJMJrngkU4k1JrKxKLcqPLyrNSS0+xGgKdNNEZinR5HxgKsgriTc0NjEzsjQy
	N7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamBcJdV262TgyUsb3vRqv7OIFZ4Z++j5
	u6zwI8b8ZoYzYhJfNH8Wke7aeE2PWzL1cr/h5V1K/eJ7l6r79mTcmq3DlJM/n+tusIwOd8pJ
	Q11ny66XC18xMl28KbzkeVyI0rTfhlu2bpqaz6oT5aedcHDCjcPvj6mx/0jds+Svre0p7zvV
	LyuXnXJUYinOSDTUYi4qTgQArnc1b80CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current charger-manager calls power_suuply_changed() whenever charging
status is changed. This patch removes seperated power_supply_changed()
use and let it be called at end of try_charger_enable() function which
is called to set charging/discharging.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 687f109..bb44588 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -382,8 +382,10 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		}
 	}
 
-	if (!err)
+	if (!err) {
 		cm->charger_enabled = enable;
+		power_supply_changed(&cm->charger_psy);
+	}
 
 	return err;
 }
@@ -436,10 +438,8 @@ static void fullbatt_vchk(struct charger_manager *cm)
 
 	dev_info(cm->dev, "VBATT dropped %duV after full-batt\n", diff);
 
-	if (diff > desc->fullbatt_vchkdrop_uV) {
+	if (diff > desc->fullbatt_vchkdrop_uV)
 		try_charger_restart(cm);
-		power_supply_changed(&cm->charger_psy);
-	}
 }
 
 /**
@@ -469,7 +469,6 @@ static int check_charging_duration(struct charger_manager *cm)
 		if (duration > desc->charging_max_duration_ms) {
 			dev_info(cm->dev, "Charging duration exceed %ums\n",
 				 desc->charging_max_duration_ms);
-			power_supply_changed(&cm->charger_psy);
 			try_charger_enable(cm, false);
 			ret = true;
 		}
@@ -480,7 +479,6 @@ static int check_charging_duration(struct charger_manager *cm)
 				is_ext_pwr_online(cm)) {
 			dev_info(cm->dev, "Discharging duration exceed %ums\n",
 				 desc->discharging_max_duration_ms);
-			power_supply_changed(&cm->charger_psy);
 			try_charger_enable(cm, true);
 			ret = true;
 		}
@@ -561,8 +559,7 @@ static bool _cm_monitor(struct charger_manager *cm)
 	 */
 	if (temp_alrt) {
 		cm->emergency_stop = temp_alrt;
-		if (!try_charger_enable(cm, false))
-			power_supply_changed(&cm->charger_psy);
+		try_charger_enable(cm, false);
 
 	/*
 	 * Check whole charging duration and discharing duration
@@ -587,16 +584,13 @@ static bool _cm_monitor(struct charger_manager *cm)
 	} else if (!cm->emergency_stop && is_full_charged(cm) &&
 			cm->charger_enabled) {
 		dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged\n");
-		power_supply_changed(&cm->charger_psy);
-
 		try_charger_enable(cm, false);
 
 		fullbatt_vchk(cm);
 	} else {
 		cm->emergency_stop = 0;
 		if (is_ext_pwr_online(cm)) {
-			if (!try_charger_enable(cm, true))
-				power_supply_changed(&cm->charger_psy);
+			try_charger_enable(cm, true);
 		}
 	}
 
-- 
1.7.9.5

