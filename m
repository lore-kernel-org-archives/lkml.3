Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbaJ3Mq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:46:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38443 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbaJ3MnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:24 -0400
X-AuditID: cbfee68e-f79b46d000002b74-0b-54523269ab71
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 05/10] power: charger-manager: Concentrate scattered
 power_supply_changed() calls.
Date: Thu, 30 Oct 2014 21:43:11 +0900
Message-id: <1414672996-28355-6-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkRDfTKCjEYPcBbYuDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGZcuXWcsWCNa0bprBmsD
	4x7BLkZODgkBE4n111uZIGwxiQv31rN1MXJxCAksZZTYv/QFK0zRotd9UIlFjBJbf+9kgXDa
	mCTe7DzEDlLFJqAj8X/fTTBbREBBYnPvM1aQImaBK4wSNxevB9shLJAicfr7YyCbg4NFQFXi
	5z1fkDCvgIfEjp1zwcISQL1zJtmAhDkFPCU2XZnJAmILAZU82NXFDjJSQmAXu8SOhf/AdrEI
	CEh8m3yIBaJXVmLTAWaIoyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxN
	jMCYOP3vWd8OxpsHrA8xCnAwKvHwapwIDBFiTSwrrsw9xGgKtGEis5Rocj4w8vJK4g2NzYws
	TE1MjY3MLc2UxHkTpH4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamD0Dv5/xvG1uNipyRnd
	aY9+rj7s0DWFu66zUMtXKvdqDvfjrG0xzkZ3Pz9+eoijoaBm+vLbub7bhZ9nHjun93oRg8Wq
	b8cLWJ7IauZte7blzEnzz1ozRBM6NA+FfhOdVb6n6jLv4RkdSooPZn6yZ3yQ+uHGoxs/JCbM
	+bdfSCGlmFexLdXsIcMEJZbijERDLeai4kQADa+cU4QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd1Mo6AQg1vXlC0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcy4dOk6Y8Ea0YrWXTNYGxj3CHYxcnJICJhILHrdxwZhi0lcuLceyObiEBJYxCix
	9fdOFginjUnizc5D7CBVbAI6Ev/33QSzRQQUJDb3PmMFKWIWuMIocXPxeiaQhLBAisTp74+B
	bA4OFgFViZ/3fEHCvAIeEjt2zgULSwD1zplkAxLmFPCU2HRlJguILQRU8mBXF/sERt4FjAyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj7pn0DsZVDRaHGAU4GJV4eDVOBIYIsSaWFVfm
	HmKU4GBWEuE9qhMUIsSbklhZlVqUH19UmpNafIjRFOimicxSosn5wGSQVxJvaGxiZmRpZG5o
	YWRsriTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBMXOjztbK96yBs5+szzvlKvH3dgCDz2yn
	bctD1wrIRwiXfJMrPNTcVePVVibesCPBeZdio+aVlL9rMh49jLr3KKBpk4HL/a8OC7QZjuRN
	OnP/+brwh3MFWa1umZxMmnCAd+3lh8G8x+2nnrS/sWfx1bd6/F0zBPLnsIS8/mX4c3FDTYK0
	0H6xu0osxRmJhlrMRcWJAL8Hi7HOAgAA
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

