Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaLSI7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:59:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaLSIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:35 -0500
X-AuditID: cbfee68e-f79b46d000002b74-90-5493e803216a
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 06/11] power: charger-manager: Concentrate scattered
 power_supply_changed() calls.
Date: Fri, 19 Dec 2014 17:55:18 +0900
Message-id: <1418979323-7188-7-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkUJf5xeQQg0tXDS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZfTsvsBWsEa0YtXLs+wN
	jHsEuxg5OSQETCTO7LjNDmGLSVy4t56ti5GLQ0hgKaPEixtv2WCKZqyfxwKRmM4osfrKKqiq
	NiaJzw8+gbWzCehI/N93E8wWEVCQ2Nz7jBWkiFngCqPEzcXrmUASwgLpErc/bABKcHCwCKhK
	zH6pBhLmFXCX+LT1GVhYAqh3ziQbkDCngIfEn5NbwDqFgEoat3xnBxkpIbCLXeLk5bWsIAkW
	AQGJb5MPsUD0ykpsOsAMcbSkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7
	iREYE6f/PevbwXjzgPUhRgEORiUe3o7CySFCrIllxZW5hxhNgTZMZJYSTc4HRl5eSbyhsZmR
	hamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MgnsLTJec9rY5/sNZ
	8stMhxPfvA4yTFmq4n+ZrUdoj1Lo4huKvZUfud9dt7GWeJVqfPB77LREhTl/dW6sLnHqPP3c
	8/9a+b+/j639Yy+6PMngzevP+dlH78q8P/Yz6IUzi9hUP279O/G5v6YLT53fy7RBSjvszbWN
	RxziMg5HG0w+vfZu8Ty2UiWW4oxEQy3mouJEADmaXDCEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDDqeaVoc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5jRs/sCW8Ea0YpVL8+yNzDuEexi5OSQEDCRmLF+HguELSZx4d56ti5GLg4hgemM
	EquvrIJy2pgkPj/4xA5SxSagI/F/300wW0RAQWJz7zNWkCJmgSuMEjcXr2cCSQgLpEvc/rAB
	KMHBwSKgKjH7pRpImFfAXeLT1mdgYQmg3jmTbEDCnAIeEn9ObgHrFAIqadzynX0CI+8CRoZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER90x6B+OqBotDjAIcjEo8vB2Fk0OEWBPLiitz
	DzFKcDArifA6HgcK8aYkVlalFuXHF5XmpBYfYjQFumkis5Rocj4wGeSVxBsam5gZWRqZG1oY
	GZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTCyb/czdDhh+EGp4eeX3OTjd39LfJacvH3l
	pQtdFzWdJBSNfyUolPtzxQkvWvfOZs+/j5qWXfemdB0t391s8+n97XqVZ3Oly85aFx76sWHP
	4fTkFX3iNVzyoR48DrvqAx49O1tTmuadW5DGmzVrhfnlmi06CTGL7BJiW6VXhj8JUzb6u3F3
	/iclluKMREMt5qLiRAAeBF31zgIAAA==
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
index 7bbaef6..d29155d 100644
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

