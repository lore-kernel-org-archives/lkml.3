Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaLSI6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:58:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63688 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaLSIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:36 -0500
X-AuditID: cbfee68d-f79296d000004278-34-5493e803ae81
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 05/11] power: charger-manager: Fix to use CHARGE_NOW/FULL
 property correctly.
Date: Fri, 19 Dec 2014 17:55:17 +0900
Message-id: <1418979323-7188-6-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkSJf5xeQQg7VPtSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZWx6uZy54JtyxcVXf9kb
	GC/JdjFycEgImEhcakvrYuQEMsUkLtxbz9bFyMUhJLCUUeLr8dmsEAkTiSPne1khEtMZJT5P
	bGWBcNqYJD4/+MQOUsUmoCPxf99NMFtEQEFic+8zsA5mgSuMEjcXr2cCSQgLJEkc/7+GBcRm
	EVCVuPl5CVgDr4C7xLXjfSwQJylIzJlkAxLmFPCQ+HNyC1irEFBJ45bv7CAzJQT2sUus334W
	ao6AxLfJh6B6ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/d
	xAiMidP/nvXuYLx9wPoQowAHoxIPb2fh5BAh1sSy4srcQ4ymQBsmMkuJJucDIy+vJN7Q2MzI
	wtTE1NjI3NJMSZxXUepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG7Nf+B/jdHzv2dJgf
	F+vXjlnkzX83gffEe2GetU0X9hzws90qZ7maf614VGPyuZ/sAQ88RUyu+K42/NO91/V5JUt0
	nvPiwMPv/k/7t3t10m72d9flsqz+PhXemlEtn5jfGa13qej0Ws6elCL5pXcc9B+7u64ul51n
	bp7yc96hQ9+Mpr3VNpVWYinOSDTUYi4qTgQA0FjHeoQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDH6vVLI4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFj08vlzAXflCsuvvrL3sB4SbaLkZNDQsBE4sj5XlYIW0ziwr31bF2MXBxCAtMZ
	JT5PbGWBcNqYJD4/+MQOUsUmoCPxf99NMFtEQEFic+8zVpAiZoErjBI3F69nAkkICyRJHP+/
	hgXEZhFQlbj5eQlYA6+Au8S1431AcQ6gdQoScybZgIQ5BTwk/pzcAtYqBFTSuOU7+wRG3gWM
	DKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPumfQOxlUNFocYBTgYlXh4OwonhwixJpYV
	V+YeYpTgYFYS4XU8DhTiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGA6yCuJNzQ2MTOyNDI3
	tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYGyTODB7z+c3PS+s2Gq5jqYV3/dtTDDT
	cl32WsL1Tp5gYPk0Fc5116Vab0WlaX2Mln7689qLGJb7RrJXDZX//5OUYOqTKXqTLLVzrznb
	oaTL/wuWzVuaMXXttHX621oSVN7/fdFUqLEpeUsHr5rX3Zc7li3Iunv+mvCeWUpllkKC3awb
	eVn55iqxFGckGmoxFxUnAgALVwAozwIAAA==
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
index 5482661..7bbaef6 100644
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

