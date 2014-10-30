Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbaJ3Mne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964AbaJ3Mn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:29 -0400
X-AuditID: cbfee68d-f79296d000004278-14-545232695a66
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 06/10] power: charger-manager: Get external power souce
 information only from EXTCON.
Date: Thu, 30 Oct 2014 21:43:12 +0900
Message-id: <1414672996-28355-7-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkSDfTKCjE4GmblcXBrZoW1788Z7WY
	9OQ9s8XElZOZLTrPPmG2uLxrDpvF594jjBa3G1ewWdw9dZTN4vTuEgcujwn9nxg9ds66y+6x
	eYWWx6ZVnWwefVtWMXqsWP2d3ePzJrkA9igum5TUnMyy1CJ9uwSujH8LtzAWnBWqWDBnH1MD
	Ywd/FyMnh4SAicTq95MYIWwxiQv31rN1MXJxCAksZZS4uvQeG0zRpjUrmCESixglzi77xALh
	tDFJvNl5iB2kik1AR+L/vptgtoiAgsTm3mesIEXMAlcYJW4uXs8EkhAWSJe4cuEo2FgWAVWJ
	y22fWUBsXgEPiVVtM4AaOIDWKUjMmWQDEuYU8JTYdGUmWIkQUMmDXV3sIDMlBA6xS0yYuZER
	Yo6AxLfJh1ggemUlNh1ghrhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P
	3cQIjIrT/5717mC8fcD6EKMAB6MSD6/GicAQIdbEsuLK3EOMpkAbJjJLiSbnA2MvryTe0NjM
	yMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpqJz64dWHkqgPGw
	le8pAZ6PWzJnxImoerx9k/bktGxyiccU5b81n28oHiyXftlndf3PtiLmkonnmZ0jmlS0tpwX
	tt0rWxG0P+183Y68r22ylR9vl2+O2nzyv3X04g0SJdUhj6PfLpV9zyu89Zaw2bbVT/IsQ7WX
	z7giOatX+d+LGY/72+ucryqxFGckGmoxFxUnAgBcQq4HhQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd1Mo6AQg71bjCwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcz4t3ALY8FZoYoFc/YxNTB28HcxcnJICJhIbFqzghnCFpO4cG89WxcjF4eQwCJG
	ibPLPrFAOG1MEm92HmIHqWIT0JH4v+8mmC0ioCCxufcZK0gRs8AVRombi9czgSSEBdIlrlw4
	ygZiswioSlxu+8wCYvMKeEisapsB1MABtE5BYs4kG5Awp4CnxKYrM8FKhIBKHuzqYp/AyLuA
	kWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDMPZPewbiqweIQowAHoxIPr8aJwBAh1sSy
	4srcQ4wSHMxKIrxHdYJChHhTEiurUovy44tKc1KLDzGaAh01kVlKNDkfmA7ySuINjU3MjCyN
	zA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwNhf6Z/p+mvJl6RqWs/VcWwI/+Iup
	VXK92L3MW9s45ep8k5/v+qvX/ZQ8VPBylu6v39JV016J7jzwcNe1Kxuy1x+/UXpwcyfTBt4b
	tf3b/u/fEBNxKln9Z+3LFTdtgh91nr4rfi9pZ47rtCVSxnL3duTFZxZr7Uq/pK4sYLac+9yd
	c0lPa1dfvKTEUpyRaKjFXFScCACIh/ALzwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When charger-manager checks whether external power source is available,
it gets information from charger IC driver. However, it's not correct source,
charger IC doesn't have responsibilty to give cable connection status.
The charger-manager already gets cable information from EXTCON susbsystem,
so it can re-use it.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index bb44588..172dfe5 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -115,34 +115,28 @@ static bool is_batt_present(struct charger_manager *cm)
  * is_ext_pwr_online - See if an external power source is attached to charge
  * @cm: the Charger Manager representing the battery.
  *
- * Returns true if at least one of the chargers of the battery has an external
- * power source attached to charge the battery regardless of whether it is
- * actually charging or not.
+ * Returns true if there is external power source.
+ * Cable connection information is only obtained by EXTCON class notification.
  */
 static bool is_ext_pwr_online(struct charger_manager *cm)
 {
-	union power_supply_propval val;
-	struct power_supply *psy;
-	bool online = false;
-	int i, ret;
 
-	/* If at least one of them has one, it's yes. */
-	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
-		psy = power_supply_get_by_name(cm->desc->psy_charger_stat[i]);
-		if (!psy) {
-			dev_err(cm->dev, "Cannot find power supply \"%s\"\n",
-					cm->desc->psy_charger_stat[i]);
-			continue;
-		}
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *regulators = desc->charger_regulators;
+	struct charger_cable *cables;
+	int i, j, num_cables;
 
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
-		if (ret == 0 && val.intval) {
-			online = true;
-			break;
+	/* If at least one of them has one, it's yes. */
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		cables = regulators[i].cables;
+		num_cables = regulators[i].num_cables;
+		for (j = 0; j < num_cables; j++) {
+			if (cables[j].attached)
+				return true;
 		}
 	}
 
-	return online;
+	return false;
 }
 
 /**
-- 
1.7.9.5

