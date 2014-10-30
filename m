Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbaJ3Mq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:46:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45008 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938AbaJ3MnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:25 -0400
X-AuditID: cbfee691-f79b86d000004a5a-ad-54523269c912
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 04/10] power: charger-manager: Fix to use CHARGE_NOW/FULL
 property correctly.
Date: Thu, 30 Oct 2014 21:43:10 +0900
Message-id: <1414672996-28355-5-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkUDfTKCjE4PoDSYuDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGT+vn2Yu+KZccebgMaYG
	xkuyXYwcHBICJhJHTvB3MXICmWISF+6tZ+ti5OIQEljKKLGu5SAzRMJE4kLXX2aIxCJGiRfb
	mhkhnDYmiTc7D7GDVLEJ6Ej833cTzBYRUJDY3PuMFaSIWeAKo8TNxeuZQBLCAvESW7ZcAxvL
	IqAqcfjDJkYQm1fAQ6Lx7nQWiJMUJOZMsgEJcwp4Smy6MpMFxBYCKnmwq4sdZKaEwCF2iYVt
	e6HmCEh8m3wIqldWYtMBqKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYzAmDj979nEHYz3D1gfYhTgYFTi4b1wNDBEiDWxrLgy9xCjKdCGicxSosn5wMjLK4k3NDYz
	sjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcbfEQ3m1f+1Kshc7
	Hk2bVGOg+Z3t5arCzD5RUbkjse0HklIsLouUZey34mk3uxXz32PfxqbinrdTWVy1pXiXPr60
	Z8nu9bwxHatb3FVz9x0QPzb3brdzi8q+975+l27PPtXkdLEzMuiD5caAF28Ykxe8amHO/azn
	ur83Uir8/POGa3OE5HYKKLEUZyQaajEXFScCAGtLt1CEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd1Mo6AQg8MPBSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcz4ef00c8E35YozB48xNTBeku1i5OSQEDCRuND1lxnCFpO4cG89WxcjF4eQwCJG
	iRfbmhkhnDYmiTc7D7GDVLEJ6Ej833cTzBYRUJDY3PuMFaSIWeAKo8TNxeuZQBLCAvESW7Zc
	AxvLIqAqcfjDJkYQm1fAQ6Lx7nSWLkYOoHUKEnMm2YCEOQU8JTZdmckCYgsBlTzY1cU+gZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgmHsmvYNxVYPFIUYBDkYlHl6NE4EhQqyJ
	ZcWVuYcYJTiYlUR4j+oEhQjxpiRWVqUW5ccXleakFh9iNAU6aiKzlGhyPjAd5JXEGxqbmBlZ
	GpkbWhgZmyuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYJzBcHGR/YIp905d4fH4cIvVrcvP
	Z+bGxievl7Zbf+QxLer4z7xgWZvexbD9EcVXX9hZrurVOa19bMf3j74Oc9ZWCQRvXHnHRuTx
	4uV/RRjeTi78ZeDAmPH6zJWWJbU7DeyNVr0Q9Vm/PNDSzOWrv5SyJI9NNA/T8ajNnU0XY5TZ
	rR5e59ivYKbEUpyRaKjFXFScCAAWu1AVzwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POWER_SUPPLY_CHARGE_NOW/FULL property reflects battery's charges
in uAh unit, but charger-manager has been used it wrongly. This patch
makes it to use those propeties correctly and change to be optional.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   85 +++++++++++++--------------------------
 1 file changed, 28 insertions(+), 57 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 64fdaaf..687f109 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -796,35 +796,13 @@ static int charger_get_property(struct power_supply *psy,
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		if (is_full_charged(cm))
-			val->intval = 1;
-		else
-			val->intval = 0;
-		ret = 0;
-		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
-		if (is_charging(cm)) {
-			fuel_gauge = power_supply_get_by_name(
-					cm->desc->psy_fuel_gauge);
-			if (!fuel_gauge) {
-				ret = -ENODEV;
-				break;
-			}
-
-			ret = fuel_gauge->get_property(fuel_gauge,
-						POWER_SUPPLY_PROP_CHARGE_NOW,
-						val);
-			if (ret) {
-				val->intval = 1;
-				ret = 0;
-			} else {
-				/* If CHARGE_NOW is supplied, use it */
-				val->intval = (val->intval > 0) ?
-						val->intval : 1;
-			}
-		} else {
-			val->intval = 0;
+		fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
+		if (!fuel_gauge) {
+			ret = -ENODEV;
+			break;
 		}
+		ret = fuel_gauge->get_property(fuel_gauge, psp, val);
 		break;
 	default:
 		return -EINVAL;
@@ -832,8 +810,7 @@ static int charger_get_property(struct power_supply *psy,
 	return ret;
 }
 
-#define NUM_CHARGER_PSY_OPTIONAL	(4)
-static enum power_supply_property default_charger_props[] = {
+static enum power_supply_property cm_default_props[] = {
 	/* Guaranteed to provide */
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_HEALTH,
@@ -841,20 +818,21 @@ static enum power_supply_property default_charger_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_ONLINE,
-	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_TEMP,
-	/*
-	 * Optional properties are:
-	 * POWER_SUPPLY_PROP_CHARGE_NOW,
-	 * POWER_SUPPLY_PROP_CURRENT_NOW,
-	 */
 };
 
+static enum power_supply_property cm_optional_props[] = {
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+};
+
+#define CM_NUM_OF_PROPS	\
+	(ARRAY_SIZE(cm_default_props) + ARRAY_SIZE(cm_optional_props))
+
 static struct power_supply psy_default = {
 	.name = "battery",
 	.type = POWER_SUPPLY_TYPE_BATTERY,
-	.properties = default_charger_props,
-	.num_properties = ARRAY_SIZE(default_charger_props),
 	.get_property = charger_get_property,
 	.no_thermal = true,
 };
@@ -1484,29 +1462,22 @@ static int charger_manager_probe(struct platform_device *pdev)
 	/* Allocate for psy properties because they may vary */
 	cm->charger_psy.properties = devm_kzalloc(&pdev->dev,
 				sizeof(enum power_supply_property)
-				* (ARRAY_SIZE(default_charger_props) +
-				NUM_CHARGER_PSY_OPTIONAL), GFP_KERNEL);
+				* CM_NUM_OF_PROPS, GFP_KERNEL);
 	if (!cm->charger_psy.properties)
 		return -ENOMEM;
 
-	memcpy(cm->charger_psy.properties, default_charger_props,
-		sizeof(enum power_supply_property) *
-		ARRAY_SIZE(default_charger_props));
-	cm->charger_psy.num_properties = psy_default.num_properties;
-
-	/* Find which optional psy-properties are available */
-	if (!fuel_gauge->get_property(fuel_gauge,
-					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-				POWER_SUPPLY_PROP_CHARGE_NOW;
-		cm->charger_psy.num_properties++;
-	}
-	if (!fuel_gauge->get_property(fuel_gauge,
-					  POWER_SUPPLY_PROP_CURRENT_NOW,
-					  &val)) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-				POWER_SUPPLY_PROP_CURRENT_NOW;
-		cm->charger_psy.num_properties++;
+	memcpy(cm->charger_psy.properties, cm_default_props,
+			sizeof(enum power_supply_property) *
+			ARRAY_SIZE(cm_default_props));
+	cm->charger_psy.num_properties = ARRAY_SIZE(cm_default_props);
+
+	/* Add available optional properties */
+	for (i = 0; i < ARRAY_SIZE(cm_optional_props); i++) {
+		if (fuel_gauge->get_property(fuel_gauge,
+				cm_optional_props[i], &val))
+			continue;
+		cm->charger_psy.properties[cm->charger_psy.num_properties++] =
+				cm_optional_props[i];
 	}
 
 	if (desc->thermal_zone) {
-- 
1.7.9.5

