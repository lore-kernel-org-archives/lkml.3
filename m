Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaLSCtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:49:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58375 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaLSCrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:40 -0500
X-AuditID: cbfee68f-f791c6d000004834-dd-549391c9d315
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 06/10] power: charger-manager: Get external power
 souce information only from EXTCON.
Date: Fri, 19 Dec 2014 11:47:26 +0900
Message-id: <1418957250-6542-7-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkUPfkxMkhBo2zuCwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZfxbuIWx4KxQxYI5+5ga
	GDv4uxg5OSQETCSuLVzKBmGLSVy4tx7I5uIQEljKKHF9425mmKKZ3/+yQyQWMUpMXDaTGcJp
	Y5JYM38RE0gVm4COxP99N9lBbBEBBYnNvc9YQYqYBa4wStxcvB6sSFigUGLevz4gm4ODRUBV
	YnajNkiYV8Bdov/YJjaQsARQ75xJNiBhTgEPiaeXmsCuEwIqOfHtLQvISAmBXewS13bsANvF
	IiAg8W3yIRaIXlmJTQegjpaUOLjiBssERuEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3
	MQJj4vS/Z/07GO8esD7EKMDBqMTD+6B4cogQa2JZcWXuIUZToA0TmaVEk/OBkZdXEm9obGZk
	YWpiamxkbmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGWSdPnFy9cuKCUEmP
	DZZR1xfGrTaQvNR7wpTz5etlxyqjT7z1szpkIBqjmt34z7z8b2f2lrxLl7QvLpY7cSvtfuqZ
	vTxBK0o0Kt8ncrwXT5m+W8ktVV64uK7e73/ANe1Evr+B6TKbahevOFpxstZfPGLSsU7Rh3ZX
	ed8Gfhbe9m8jp8XfB4arlFiKMxINtZiLihMBm6oRkYQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2TEyeHGByYzmRxcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGv4VbGAvOClUsmLOPqYGxg7+LkZNDQsBEYub3v+wQtpjEhXvr2boYuTiEBBYx
	SkxcNpMZwmljklgzfxETSBWbgI7E/303wTpEBBQkNvc+YwUpYha4wihxc/F6sCJhgUKJef/6
	gGwODhYBVYnZjdogYV4Bd4n+Y5vYQMISQL1zJtmAhDkFPCSeXmpiA7GFgEpOfHvLMoGRdwEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ih7JrWDcWWDxSFGAQ5GJR7ejsLJIUKsiWXF
	lbmHGCU4mJVEeM0zgUK8KYmVValF+fFFpTmpxYcYTYFumsgsJZqcD0wGeSXxhsYmZkaWRuaG
	FkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjEfMjr9vPZ37aE1gSz+HOP+3x5zdR+UM
	f7yc/a0h00ND+fNn1uOXbxye87/JsHPP5+Wd7wT5ra/8jP2j1/ic1eSC+VpvTp6qi40Sy1ZI
	ZzNsf+L/Tc0rOneFct6j7q6VKZmVM3+G+jMuW3fE+7V/xGMTnme6n/R/cr1i/WahxDT70fI8
	Af4Hc5VYijMSDbWYi4oTAdW5GUnOAgAA
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

