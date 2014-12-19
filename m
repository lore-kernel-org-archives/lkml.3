Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaLSCs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:48:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaLSCrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:40 -0500
X-AuditID: cbfee68d-f79296d000004278-c5-549391c8ea45
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 04/10] power: charger-manager: Fix to use
 CHARGE_NOW/FULL property correctly.
Date: Fri, 19 Dec 2014 11:47:24 +0900
Message-id: <1418957250-6542-5-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkWPfExMkhBvP/6Vsc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI/isklJzcksSy3St0vgyvh5/TRzwTflijMHjzE1
	MF6S7WLk5JAQMJFofNzLBGGLSVy4t56ti5GLQ0hgKaPEtc6/LDBFr849ZIFILGKU2Nm4Ccpp
	Y5JYM38RWDubgI7E/3032UFsEQEFic29z1hBipgFrjBK3Fy8HqxIWCBTYta56YwgNouAqkRb
	+yygIg4OXgF3iQ/tISCmBFDvnEk2IBWcAh4STy81sYHYQkAVJ769BdsrIbCPXWLStvNMEGME
	JL5NPsQC0SsrsekAM8TRkhIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZG
	YEyc/vesdwfj7QPWhxgFOBiVeHg7CyeHCLEmlhVX5h5iNAXaMJFZSjQ5Hxh5eSXxhsZmRham
	JqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MO5vnat24k3Ly41PJV45
	c8e/fJi/ebrm45VfHil7ds34cSzn6W/XLXIlpaUcv5dfyoo/7+/qs6vaMsyvSC7LX5vjXIK+
	TNG+immqb4W1+fR+16Rz3hA6eG/5o8V/+3ZM3ti9eM1J/cd/A+PM6nMObfCxcLL7YZaq25zV
	p3SdofBsdbvm2eT6Q0osxRmJhlrMRcWJAO0XR22EAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd0TEyeHGDTsUbc4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj5/XTzAXflCvOHDzG1MB4SbaLkZNDQsBE4tW5hywQtpjEhXvr2boYuTiEBBYx
	Suxs3MQC4bQxSayZv4gJpIpNQEfi/76b7CC2iICCxObeZ6wgRcwCVxglbi5eD1YkLJApMevc
	dEYQm0VAVaKtfRZQEQcHr4C7xIf2EBBTAqh3ziQbkApOAQ+Jp5ea2EBsIaCKE9/eskxg5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjinkntYFzZYHGIUYCDUYmHt6NwcogQa2JZ
	cWXuIUYJDmYlEV7zTKAQb0piZVVqUX58UWlOavEhRlOgmyYyS4km5wOTQV5JvKGxiZmRpZG5
	oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA6PKk8alu/TW/e2wXDOxef2BIgHRu8+m
	nHJu8Dtbfin0c9b1P0bPJjIECS157sRdeTN53YFzDRVVlt8mzTBSLuFySHi6iPkja+K6IrMo
	pUu8ied59as1DnVPlNSMVz43R3Ri89aLK3ZlRvdtvPxJu/PxuZn/Fq+YrZ25dntNaazivxZG
	QyHXNYxKLMUZiYZazEXFiQCEHcSdzgIAAA==
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

