Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaDNLrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:47:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49708 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaDNLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:47:45 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-8c-534bcadea224
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 03/13] extcon: extcon-class: remove extcon_set_cable_state()
 function
Date: Mon, 14 Apr 2014 13:46:14 +0200
Message-id: <1397475984-28001-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRW0jTcRQH8H77Xx0u/kyrfxPChklJeauHH2RhoPEviy6+hA/V1L+3vIxN
	JQXREvOuc1LLnOl03rbZxNSc93khs5ozIUMzFTV1moEZSprmlN4+55wv5zwcEuG3ogIyPDqW
	lUSLIoU4F32/PUOdmRz083cfabaFugVvaGw6BY2TyXB0bR6D8tmfCCztM2GwoLYQgfnLKgzm
	N/rA7q0WAFMr9Dg0WWoBzPw4i0DzXA4OKzu1KFQ9UaNwpFWJw2J1PgrLq9IQOKv6wIF1fRME
	rBwd5sDxRzU4rP6xg0OZog6FU70GAr5aVKAwraOPgJ3mLQzqny+h3scY3UsdYEbycjlMq0GJ
	MbL8VcAYXkwQTG31Gs70/lahzOsaF6ZBk4kzFm0Rxnz93I4zXSU6gslNXcGZxYJNnDGspxBM
	XqMG3LQL4HoFs5Hh8azE7eJ9bti2cggTv30GHm4q5zkpQJeUBWxImjpHK9sziH0fps3f9HgW
	4JJ8qhzQE/o2Yr9I59AlWjNqTeHUabpxXQastqcQuuzp0J4Rag6j32xcsNqOCqB3Zso5VqPU
	CfpPvwW3mkf50t2Kjd2l5O41R1op97K2bajLtLHoL2I13xpJHUdkgFcGDmjAIVYcJJYGhkZ5
	ukpFUdK46FDXoJioBrD30e8OLUCTAnsARQKhLS9D6efPx0Tx0oSoHkCTiNCe59u02+IFixIS
	WUnMPUlcJCvtAQ4kKjzCM6adv8WnQkWx7AOWFbOS/1MOaSNIAR6ZzQuG5VWZ7objgdxF8dh1
	z44utc8lRba4VWBZCSstC5EQO2zHO3mS/GB6Rczdyqbp4gFTgfuX4YEu41Toqlt/fZW3fXKO
	8+CvoyHZY9ORhWNODVctDY8j9GmjcYHJVW3O22cjrty+M6/2XndK1F7zW/I//mlpaNN0UiCv
	Z3OEqDRM5OGCSKSifzUZ46zNAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes extcon_set_cable_state() and replace all calls of
this function witch extcon_set_cable_state_(), which is faster version.
This is first step of changing extcon API to faster and safer.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-class.c    |   17 --------
 drivers/extcon/extcon-max14577.c |   24 ++++++------
 drivers/extcon/extcon-max77693.c |   79 +++++++++++++++++++++++---------------
 drivers/extcon/extcon-max8997.c  |   32 +++++++++------
 drivers/extcon/extcon-palmas.c   |   27 +++++++++----
 include/linux/extcon.h           |    8 ----
 6 files changed, 99 insertions(+), 88 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index a45c5e9..1b98c4e 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -358,23 +358,6 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
 /**
- * extcon_set_cable_state() - Set the status of a specific cable.
- * @edev:		the extcon device that has the cable.
- * @cable_name:		cable name.
- * @cable_state:	the new cable status. The default semantics is
- *			true: attached / false: detached.
- *
- * Note that this is slower than extcon_set_cable_state_.
- */
-int extcon_set_cable_state(struct extcon_dev *edev,
-			const char *cable_name, bool cable_state)
-{
-	return extcon_set_cable_state_(edev, extcon_find_cable_index
-					(edev, cable_name), cable_state);
-}
-EXPORT_SYMBOL_GPL(extcon_set_cable_state);
-
-/**
  * extcon_get_extcon_dev() - Get the extcon device instance from the name
  * @extcon_name:	The extcon name provided with extcon_dev_register()
  */
diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 3846941..7a947d3 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -333,7 +333,7 @@ static int max14577_muic_get_cable_type(struct max14577_muic_info *info,
 static int max14577_muic_jig_handler(struct max14577_muic_info *info,
 		int cable_type, bool attached)
 {
-	char cable_name[32];
+	int cable;
 	int ret = 0;
 	u8 path = CTRL1_SW_OPEN;
 
@@ -344,17 +344,17 @@ static int max14577_muic_jig_handler(struct max14577_muic_info *info,
 	switch (cable_type) {
 	case MAX14577_MUIC_ADC_FACTORY_MODE_USB_OFF:	/* ADC_JIG_USB_OFF */
 		/* PATH:AP_USB */
-		strcpy(cable_name, "JIG-USB-OFF");
+		cable = EXTCON_CABLE_JIG_USB_OFF;
 		path = CTRL1_SW_USB;
 		break;
 	case MAX14577_MUIC_ADC_FACTORY_MODE_USB_ON:	/* ADC_JIG_USB_ON */
 		/* PATH:AP_USB */
-		strcpy(cable_name, "JIG-USB-ON");
+		cable = EXTCON_CABLE_JIG_USB_ON;
 		path = CTRL1_SW_USB;
 		break;
 	case MAX14577_MUIC_ADC_FACTORY_MODE_UART_OFF:	/* ADC_JIG_UART_OFF */
 		/* PATH:AP_UART */
-		strcpy(cable_name, "JIG-UART-OFF");
+		cable = EXTCON_CABLE_JIG_UART_OFF;
 		path = CTRL1_SW_UART;
 		break;
 	default:
@@ -367,7 +367,7 @@ static int max14577_muic_jig_handler(struct max14577_muic_info *info,
 	if (ret < 0)
 		return ret;
 
-	extcon_set_cable_state(info->edev, cable_name, attached);
+	extcon_set_cable_state_(info->edev, cable, attached);
 
 	return 0;
 }
@@ -464,20 +464,22 @@ static int max14577_muic_chg_handler(struct max14577_muic_info *info)
 		if (ret < 0)
 			return ret;
 
-		extcon_set_cable_state(info->edev, "USB", attached);
+		extcon_set_cable_state_(info->edev, EXTCON_CABLE_USB, attached);
 		break;
 	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
-		extcon_set_cable_state(info->edev, "TA", attached);
+		extcon_set_cable_state_(info->edev, EXTCON_CABLE_TA, attached);
 		break;
 	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev,
-				"Charge-downstream", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_CHARGE_DOWNSTREAM, attached);
 		break;
 	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
-		extcon_set_cable_state(info->edev, "Slow-charger", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_SLOW_CHARGER, attached);
 		break;
 	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
-		extcon_set_cable_state(info->edev, "Fast-charger", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_FAST_CHARGER, attached);
 		break;
 	case MAX14577_CHARGER_TYPE_NONE:
 	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 905051d..7a014cd 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -216,6 +216,7 @@ enum {
 	EXTCON_CABLE_DOCK_SMART,
 	EXTCON_CABLE_DOCK_DESK,
 	EXTCON_CABLE_DOCK_AUDIO,
+	EXTCON_CABLE_AV_LOAD,
 
 	_EXTCON_CABLE_NUM,
 };
@@ -236,6 +237,7 @@ static const char *max77693_extcon_cable[] = {
 	[EXTCON_CABLE_DOCK_SMART]		= "Dock-Smart",
 	[EXTCON_CABLE_DOCK_DESK]		= "Dock-Desk",
 	[EXTCON_CABLE_DOCK_AUDIO]		= "Dock-Audio",
+	[EXTCON_CABLE_AV_LOAD]			= "Audio-video-load",
 
 	NULL,
 };
@@ -480,7 +482,7 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 	int ret = 0;
 	int vbvolt;
 	bool cable_attached;
-	char dock_name[CABLE_NAME_MAX];
+	int dock;
 
 	dev_info(info->dev,
 		"external connector is %s (adc:0x%02x)\n",
@@ -525,19 +527,22 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 		if (ret < 0)
 			return ret;
 
-		extcon_set_cable_state(info->edev, "Dock-Smart", attached);
-		extcon_set_cable_state(info->edev, "MHL", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_DOCK_SMART, attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL, attached);
 		goto out;
 	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
-		strcpy(dock_name, "Dock-Car");
+		dock = EXTCON_CABLE_JIG_UART_ON;
 		break;
 	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
-		strcpy(dock_name, "Dock-Desk");
+		dock = EXTCON_CABLE_DOCK_DESK;
 		break;
 	case MAX77693_MUIC_ADC_AV_CABLE_NOLOAD:		/* Dock-Audio */
-		strcpy(dock_name, "Dock-Audio");
+		dock = EXTCON_CABLE_DOCK_AUDIO;
 		if (!attached)
-			extcon_set_cable_state(info->edev, "USB", false);
+			extcon_set_cable_state_(info->edev,
+						EXTCON_CABLE_USB, false);
 		break;
 	default:
 		dev_err(info->dev, "failed to detect %s dock device\n",
@@ -549,7 +554,7 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 	ret = max77693_muic_set_path(info, CONTROL1_SW_AUDIO, attached);
 	if (ret < 0)
 		return ret;
-	extcon_set_cable_state(info->edev, dock_name, attached);
+	extcon_set_cable_state_(info->edev, dock, attached);
 
 out:
 	return 0;
@@ -614,20 +619,22 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info)
 		ret = max77693_muic_set_path(info, CONTROL1_SW_USB, attached);
 		if (ret < 0)
 			return ret;
-		extcon_set_cable_state(info->edev, "USB-Host", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_USB_HOST, attached);
 		break;
 	case MAX77693_MUIC_GND_AV_CABLE_LOAD:
 		/* Audio Video Cable with load, PATH:AUDIO */
 		ret = max77693_muic_set_path(info, CONTROL1_SW_AUDIO, attached);
 		if (ret < 0)
 			return ret;
-		extcon_set_cable_state(info->edev,
-				"Audio-video-load", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_AV_LOAD, attached);
 		break;
 	case MAX77693_MUIC_GND_MHL:
 	case MAX77693_MUIC_GND_MHL_VB:
 		/* MHL or MHL with USB/TA cable */
-		extcon_set_cable_state(info->edev, "MHL", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL, attached);
 		break;
 	default:
 		dev_err(info->dev, "failed to detect %s cable of gnd type\n",
@@ -641,7 +648,7 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info)
 static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 		int cable_type, bool attached)
 {
-	char cable_name[32];
+	int cable;
 	int ret = 0;
 	u8 path = CONTROL1_SW_OPEN;
 
@@ -652,17 +659,17 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 	switch (cable_type) {
 	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_OFF:	/* ADC_JIG_USB_OFF */
 		/* PATH:AP_USB */
-		strcpy(cable_name, "JIG-USB-OFF");
+		cable = EXTCON_CABLE_JIG_USB_OFF;
 		path = CONTROL1_SW_USB;
 		break;
 	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_ON:	/* ADC_JIG_USB_ON */
 		/* PATH:AP_USB */
-		strcpy(cable_name, "JIG-USB-ON");
+		cable = EXTCON_CABLE_JIG_USB_ON;
 		path = CONTROL1_SW_USB;
 		break;
 	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_OFF:	/* ADC_JIG_UART_OFF */
 		/* PATH:AP_UART */
-		strcpy(cable_name, "JIG-UART-OFF");
+		cable = EXTCON_CABLE_JIG_UART_OFF;
 		path = CONTROL1_SW_UART;
 		break;
 	default:
@@ -675,7 +682,7 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 	if (ret < 0)
 		return ret;
 
-	extcon_set_cable_state(info->edev, cable_name, attached);
+	extcon_set_cable_state_(info->edev, cable, attached);
 
 	return 0;
 }
@@ -829,10 +836,11 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 			 * - Support charging through micro-usb port without
 			 *   data connection
 			 */
-			extcon_set_cable_state(info->edev, "MHL_TA", attached);
+			extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL_TA, attached);
 			if (!cable_attached)
-				extcon_set_cable_state(info->edev,
-						      "MHL", cable_attached);
+				extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL, cable_attached);
 			break;
 		}
 
@@ -855,11 +863,13 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 			 * - Support charging through micro-usb port without
 			 *   data connection.
 			 */
-			extcon_set_cable_state(info->edev, "USB", attached);
+			extcon_set_cable_state_(info->edev,
+						EXTCON_CABLE_USB, attached);
 
 			if (!cable_attached)
-				extcon_set_cable_state(info->edev, "Dock-Audio",
-						      cable_attached);
+				extcon_set_cable_state_(info->edev,
+						EXTCON_CABLE_DOCK_AUDIO,
+						cable_attached);
 			break;
 		case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
 			/*
@@ -887,9 +897,10 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 			if (ret < 0)
 				return ret;
 
-			extcon_set_cable_state(info->edev, "Dock-Smart",
-					      attached);
-			extcon_set_cable_state(info->edev, "MHL", attached);
+			extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_DOCK_SMART, attached);
+			extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL, attached);
 
 			break;
 		}
@@ -923,23 +934,27 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 			if (ret < 0)
 				return ret;
 
-			extcon_set_cable_state(info->edev, "USB", attached);
+			extcon_set_cable_state_(info->edev,
+						EXTCON_CABLE_USB, attached);
 			break;
 		case MAX77693_CHARGER_TYPE_DEDICATED_CHG:
 			/* Only TA cable */
-			extcon_set_cable_state(info->edev, "TA", attached);
+			extcon_set_cable_state_(info->edev,
+						EXTCON_CABLE_TA, attached);
 			break;
 		}
 		break;
 	case MAX77693_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev,
-				"Charge-downstream", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_CHARGE_DOWNSTREAM, attached);
 		break;
 	case MAX77693_CHARGER_TYPE_APPLE_500MA:
-		extcon_set_cable_state(info->edev, "Slow-charger", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_SLOW_CHARGER, attached);
 		break;
 	case MAX77693_CHARGER_TYPE_APPLE_1A_2A:
-		extcon_set_cable_state(info->edev, "Fast-charger", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_FAST_CHARGER, attached);
 		break;
 	case MAX77693_CHARGER_TYPE_DEAD_BATTERY:
 		break;
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index f97a38a..a3df70d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -348,10 +348,12 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 
 	switch (usb_type) {
 	case MAX8997_USB_HOST:
-		extcon_set_cable_state(info->edev, "USB-Host", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_USB_HOST, attached);
 		break;
 	case MAX8997_USB_DEVICE:
-		extcon_set_cable_state(info->edev, "USB", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_USB, attached);
 		break;
 	default:
 		dev_err(info->dev, "failed to detect %s usb cable\n",
@@ -375,10 +377,12 @@ static int max8997_muic_handle_dock(struct max8997_muic_info *info,
 
 	switch (cable_type) {
 	case MAX8997_MUIC_ADC_AV_CABLE_NOLOAD:
-		extcon_set_cable_state(info->edev, "Dock-desk", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_DOCK_DESK, attached);
 		break;
 	case MAX8997_MUIC_ADC_FACTORY_MODE_UART_ON:
-		extcon_set_cable_state(info->edev, "Dock-card", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_DOCK_CARD, attached);
 		break;
 	default:
 		dev_err(info->dev, "failed to detect %s dock device\n",
@@ -401,7 +405,7 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 		return ret;
 	}
 
-	extcon_set_cable_state(info->edev, "JIG", attached);
+	extcon_set_cable_state_(info->edev, EXTCON_CABLE_JIG, attached);
 
 	return 0;
 }
@@ -423,7 +427,8 @@ static int max8997_muic_adc_handler(struct max8997_muic_info *info)
 			return ret;
 		break;
 	case MAX8997_MUIC_ADC_MHL:
-		extcon_set_cable_state(info->edev, "MHL", attached);
+		extcon_set_cable_state_(info->edev,
+					EXTCON_CABLE_MHL, attached);
 		break;
 	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_OFF:
 	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_ON:
@@ -506,17 +511,20 @@ static int max8997_muic_chg_handler(struct max8997_muic_info *info)
 		}
 		break;
 	case MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev,
-				      "Charge-downstream", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_CHARGE_DOWNSTREAM, attached);
 		break;
 	case MAX8997_CHARGER_TYPE_DEDICATED_CHG:
-		extcon_set_cable_state(info->edev, "TA", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_TA, attached);
 		break;
 	case MAX8997_CHARGER_TYPE_500MA:
-		extcon_set_cable_state(info->edev, "Slow-charger", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_SLOW_CHARGER, attached);
 		break;
 	case MAX8997_CHARGER_TYPE_1A:
-		extcon_set_cable_state(info->edev, "Fast-charger", attached);
+		extcon_set_cable_state_(info->edev,
+				EXTCON_CABLE_FAST_CHARGER, attached);
 		break;
 	default:
 		dev_err(info->dev,
@@ -758,7 +766,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Set initial path for UART */
-	 max8997_muic_set_path(info, info->path_uart, true);
+	max8997_muic_set_path(info, info->path_usb, true);
 
 	/* Set ADC debounce time */
 	max8997_muic_set_debounce_time(info, ADC_DEBOUNCE_TIME_25MS);
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index ddff2b7..26c0619 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -28,9 +28,14 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
+enum {
+	EXTCON_CABLE_USB = 0,
+	EXTCON_CABLE_USB_HOST,
+};
+
 static const char *palmas_extcon_cable[] = {
-	[0] = "USB",
-	[1] = "USB-HOST",
+	[EXTCON_CABLE_USB] = "USB",
+	[EXTCON_CABLE_USB_HOST] = "USB-HOST",
 	NULL,
 };
 
@@ -56,7 +61,8 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
 	if (vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS) {
 		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
 			palmas_usb->linkstat = PALMAS_USB_STATE_VBUS;
-			extcon_set_cable_state(&palmas_usb->edev, "USB", true);
+			extcon_set_cable_state_(&palmas_usb->edev,
+						EXTCON_CABLE_USB, true);
 			dev_info(palmas_usb->dev, "USB cable is attached\n");
 		} else {
 			dev_dbg(palmas_usb->dev,
@@ -65,7 +71,8 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
 	} else if (!(vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS)) {
 		if (palmas_usb->linkstat == PALMAS_USB_STATE_VBUS) {
 			palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-			extcon_set_cable_state(&palmas_usb->edev, "USB", false);
+			extcon_set_cable_state_(&palmas_usb->edev,
+						EXTCON_CABLE_USB, false);
 			dev_info(palmas_usb->dev, "USB cable is detached\n");
 		} else {
 			dev_dbg(palmas_usb->dev,
@@ -92,7 +99,8 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
+		extcon_set_cable_state_(&palmas_usb->edev,
+					EXTCON_CABLE_USB_HOST, true);
 		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
 	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
@@ -100,17 +108,20 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
+		extcon_set_cable_state_(&palmas_usb->edev,
+					EXTCON_CABLE_USB_HOST, false);
 		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
 				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
+		extcon_set_cable_state_(&palmas_usb->edev,
+					EXTCON_CABLE_USB_HOST, false);
 		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
+		extcon_set_cable_state_(&palmas_usb->edev,
+					EXTCON_CABLE_USB_HOST, true);
 		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
 	}
 
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..ed4a47b 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -214,8 +214,6 @@ extern int extcon_set_cable_state_(struct extcon_dev *edev, int cable_index,
 
 extern int extcon_get_cable_state(struct extcon_dev *edev,
 				  const char *cable_name);
-extern int extcon_set_cable_state(struct extcon_dev *edev,
-				  const char *cable_name, bool cable_state);
 
 /*
  * Following APIs are for notifiees (those who want to be notified)
@@ -282,12 +280,6 @@ static inline int extcon_get_cable_state_(struct extcon_dev *edev,
 	return 0;
 }
 
-static inline int extcon_set_cable_state_(struct extcon_dev *edev,
-					  int cable_index, bool cable_state)
-{
-	return 0;
-}
-
 static inline int extcon_get_cable_state(struct extcon_dev *edev,
 			const char *cable_name)
 {
-- 
1.7.9.5

