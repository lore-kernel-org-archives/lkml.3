Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaLSIzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:55:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaLSIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:38 -0500
X-AuditID: cbfee68f-f791c6d000004834-80-5493e803382e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 07/11] power: charger-manager: Get external power souce
 information only from EXTCON.
Date: Fri, 19 Dec 2014 17:55:19 +0900
Message-id: <1418979323-7188-8-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkUJf5xeQQg0tTLC0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZVzdo1RwVqhi08NlLA2M
	HfxdjJwcEgImEktfr2aDsMUkLtxbD2RzcQgJLGWU+Hr1MSNM0YFzT6AS0xkldvbsYodw2pgk
	Pj/4xA5SxSagI/F/300wW0RAQWJz7zNWkCJmgSuMEjcXr2cCSQgLZEkc3fYMbCyLgKpEz+Wn
	YDavgLvEy59rgGwOoHUKEnMm2YCEOQU8JP6c3ALWKgRU0rjlO9hiCYFt7BIb/j1khZgjIPFt
	8iEWiF5ZiU0HmCGulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAmPi
	9L9n/TsY7x6wPsQowMGoxMP7oHhyiBBrYllxZe4hRlOgDROZpUST84GRl1cSb2hsZmRhamJq
	bGRuaaYkzrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa5v3P1nr/dWjnJNu9nfh6f
	xT13k5NePOxdEscaV/w7wefCedlnto+C18uwNw1/Vwg5Fkw7VrF9myNbzw/V3gj/GZfY9jbu
	7+DuebcyyfCvuHzVxSh+Rr8FYSccz9/Z6785KOCIpvL1pPzNDptu8ZkJ3l71QtWt4ihTxO0Z
	bC8W+p0PNDnUfESJpTgj0VCLuag4EQCb/oEchAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDNb/NbA4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj6h6lgrNCFZseLmNpYOzg72Lk5JAQMJE4cO4JG4QtJnHh3nogm4tDSGA6o8TO
	nl3sEE4bk8TnB5/YQarYBHQk/u+7CWaLCChIbO59xgpSxCxwhVHi5uL1TCAJYYEsiaPbnjGC
	2CwCqhI9l5+C2bwC7hIvf64BsjmA1ilIzJlkAxLmFPCQ+HNyC1irEFBJ45bv7BMYeRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI64Z9I7GFc1WBxiFOBgVOLh7SicHCLEmlhWXJl7
	iFGCg1lJhNfxOFCINyWxsiq1KD++qDQntfgQoynQUROZpUST84HJIK8k3tDYxMzI0sjc0MLI
	2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgVHw+0QthogvRz+5N7OWxharfIkLjp2xU2/u
	xKnfjJlfyDXNXsTq6Rexv/G25qcJLB/VC+pkFY6F30iacfmpudatzxmiRdFZh5fe+Nhtf7FM
	S8bu10QXvaYeA4P1XrPfWV6vs573mW/mfb0mA8dNc72YC3a3qjFcaAv/+oyhzCDpeKnP/AxL
	WyWW4oxEQy3mouJEAKM+aJXOAgAA
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
index d29155d..dc15436 100644
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

