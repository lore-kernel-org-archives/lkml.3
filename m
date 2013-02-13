Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3BMJgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:36:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab3BMJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:24 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-39-511b5e5bdca9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 7/9] extcon: max8997: Consolidate duplicate code for checking
 ADC/CHG cable type
Date: Wed, 13 Feb 2013 18:35:22 +0900
Message-id: <1360748122-22011-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zTd3oOOlAg/l7RCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGio3NLAUTVzJWNKz4xtLAOK2HsYuRk0NCwERi4oI17BC2mMSF
	e+vZuhi5OIQEljFKrHk2iw2uaOFsZojEIkaJOys+sUI4C5gk/jT9BKtiE9CS2P/iBpgtImAq
	cerpdbCxzAK1Eqcv32UGsYUFkiSOtvwHW80ioCrRcHgVWA2vgKvE9fOXmCC2yUl82PMI6qQd
	bBJ9i+Ig6gUkvk0+xNLFyAEUl5XYdIAZokRS4uCKGywTGAUXMDKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAgJK6kdjCsbLA4xCnAwKvHwOoRIBQqxJpYVV+YeYpTgYFYS4XX0lw4U4k1J
	rKxKLcqPLyrNSS0+xJgMtHwis5Rocj4w5PNK4g2NDYwNDS0NzUwtTQ1IE1YS52U89SRASCA9
	sSQ1OzW1ILUIZgsTB6dUA6P0Hotws2dF87LkFlhuiFT/qrCj6v7MYIupX+4+2ntZy71qQuqJ
	yvmzTtho5r7Y+GMPR7xjzvnCG+p3GD9xJG+PK9WO99y3ZF9BoHfN7+imyIa4i4nTj1+xnhJz
	smbdjEl2BgsDVSrWXmUwZvA7vfrxmQcJd8I8rt7ZVXzm1t/f2fPUXQRk77cqsRRnJBpqMRcV
	JwIA840vxm8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xgG50nHSgQdcmLovLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWJjM0vBxJWMFQ0rvrE0
	ME7rYexi5OSQEDCRmLhwNjOELSZx4d56ti5GLg4hgUWMEndWfGKFcBYwSfxp+skGUsUmoCWx
	/8UNMFtEwFTi1NPr7CA2s0CtxOnLd8EmCQskSRxt+Q+2gUVAVaLh8CqwGl4BV4nr5y8xQWyT
	k/iw5xH7BEbuBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw/aZ1A7GlQ0WhxgFOBiV
	eHgdQqQChVgTy4orcw8xSnAwK4nwOvpLBwrxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5HxhT
	eSXxhsYmZkaWRmbGJubGxqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBce2Gqw+5/jiG
	+9rnNV67oeAdu/L2pOa+eSKzilpVni4uW3dPz3TZyU3SxY2Ci7kUetu23hLb67bUMG7LbVv+
	y8+r21Reli0x2eTlmZ7LHre+oGrqp1yn8kO5c1fnTkpnlz6p/law5af6+y+2WqJRn/T3salK
	rPq46b1Ybku7XYDDrh1v9y6wUmIpzkg01GIuKk4EAB1RMqafAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make max8997_muic_get_cable_type() function to remove
duplicate code for checking ADC/Charger cable type because almost
internal function need to read adc/chg_type value of MUIC register.

Also, remove *_detach() function, extcon-max8997 driver treat
attach/detach operation of cable in max8997_*_handler() function.
Lastly, this patch move defined constant in header file(include/
linux/mfd/max8997.h, max8997-private.h) because defined constant
is only used in the 'extcon-max8997.c'.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c     | 492 +++++++++++++++++++++++-------------
 include/linux/mfd/max8997-private.h |   9 -
 include/linux/mfd/max8997.h         |  15 --
 3 files changed, 323 insertions(+), 193 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 3206daa..35338a0 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -44,31 +44,89 @@ struct max8997_muic_irq {
 };
 
 static struct max8997_muic_irq muic_irqs[] = {
-	{ MAX8997_MUICIRQ_ADCError, "muic-ADC_error" },
-	{ MAX8997_MUICIRQ_ADCLow, "muic-ADC_low" },
-	{ MAX8997_MUICIRQ_ADC, "muic-ADC" },
-	{ MAX8997_MUICIRQ_VBVolt, "muic-VB_voltage" },
-	{ MAX8997_MUICIRQ_DBChg, "muic-DB_charger" },
-	{ MAX8997_MUICIRQ_DCDTmr, "muic-DCD_timer" },
-	{ MAX8997_MUICIRQ_ChgDetRun, "muic-CDR_status" },
-	{ MAX8997_MUICIRQ_ChgTyp, "muic-charger_type" },
-	{ MAX8997_MUICIRQ_OVP, "muic-over_voltage" },
+	{ MAX8997_MUICIRQ_ADCError,	"muic-ADCERROR" },
+	{ MAX8997_MUICIRQ_ADCLow,	"muic-ADCLOW" },
+	{ MAX8997_MUICIRQ_ADC,		"muic-ADC" },
+	{ MAX8997_MUICIRQ_VBVolt,	"muic-VBVOLT" },
+	{ MAX8997_MUICIRQ_DBChg,	"muic-DBCHG" },
+	{ MAX8997_MUICIRQ_DCDTmr,	"muic-DCDTMR" },
+	{ MAX8997_MUICIRQ_ChgDetRun,	"muic-CHGDETRUN" },
+	{ MAX8997_MUICIRQ_ChgTyp,	"muic-CHGTYP" },
+	{ MAX8997_MUICIRQ_OVP,		"muic-OVP" },
+};
+
+/* Define supported cable type */
+enum max8997_muic_acc_type {
+	MAX8997_MUIC_ADC_GROUND = 0x0,
+	MAX8997_MUIC_ADC_MHL,			/* MHL*/
+	MAX8997_MUIC_ADC_REMOTE_S1_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S2_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S3_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S4_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S5_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S6_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S7_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S8_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S9_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S10_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S11_BUTTON,
+	MAX8997_MUIC_ADC_REMOTE_S12_BUTTON,
+	MAX8997_MUIC_ADC_RESERVED_ACC_1,
+	MAX8997_MUIC_ADC_RESERVED_ACC_2,
+	MAX8997_MUIC_ADC_RESERVED_ACC_3,
+	MAX8997_MUIC_ADC_RESERVED_ACC_4,
+	MAX8997_MUIC_ADC_RESERVED_ACC_5,
+	MAX8997_MUIC_ADC_CEA936_AUDIO,
+	MAX8997_MUIC_ADC_PHONE_POWERED_DEV,
+	MAX8997_MUIC_ADC_TTY_CONVERTER,
+	MAX8997_MUIC_ADC_UART_CABLE,
+	MAX8997_MUIC_ADC_CEA936A_TYPE1_CHG,
+	MAX8997_MUIC_ADC_FACTORY_MODE_USB_OFF,	/* JIG-USB-OFF */
+	MAX8997_MUIC_ADC_FACTORY_MODE_USB_ON,	/* JIG-USB-ON */
+	MAX8997_MUIC_ADC_AV_CABLE_NOLOAD,	/* DESKDOCK */
+	MAX8997_MUIC_ADC_CEA936A_TYPE2_CHG,
+	MAX8997_MUIC_ADC_FACTORY_MODE_UART_OFF,	/* JIG-UART */
+	MAX8997_MUIC_ADC_FACTORY_MODE_UART_ON,	/* CARDOCK */
+	MAX8997_MUIC_ADC_AUDIO_MODE_REMOTE,
+	MAX8997_MUIC_ADC_OPEN,			/* OPEN */
+};
+
+enum max8997_muic_cable_group {
+	MAX8997_CABLE_GROUP_ADC = 0,
+	MAX8997_CABLE_GROUP_ADC_GND,
+	MAX8997_CABLE_GROUP_CHG,
+	MAX8997_CABLE_GROUP_VBVOLT,
+};
+
+enum max8997_muic_usb_type {
+	MAX8997_USB_HOST,
+	MAX8997_USB_DEVICE,
+};
+
+enum max8997_muic_charger_type {
+	MAX8997_CHARGER_TYPE_NONE = 0,
+	MAX8997_CHARGER_TYPE_USB,
+	MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT,
+	MAX8997_CHARGER_TYPE_DEDICATED_CHG,
+	MAX8997_CHARGER_TYPE_500MA,
+	MAX8997_CHARGER_TYPE_1A,
+	MAX8997_CHARGER_TYPE_DEAD_BATTERY = 7,
 };
 
 struct max8997_muic_info {
 	struct device *dev;
 	struct i2c_client *muic;
-	struct max8997_muic_platform_data *muic_pdata;
+	struct extcon_dev *edev;
+	int prev_cable_type;
+	int prev_chg_type;
+	u8 status[2];
 
 	int irq;
 	struct work_struct irq_work;
-
-	enum max8997_muic_charger_type pre_charger_type;
-	int pre_adc;
-
 	struct mutex mutex;
 
-	struct extcon_dev	*edev;
+	struct max8997_muic_platform_data *muic_pdata;
+	enum max8997_muic_charger_type pre_charger_type;
 };
 
 enum {
@@ -181,6 +239,83 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	return 0;
 }
 
+/*
+ * max8997_muic_get_cable_type - Return cable type and check cable state
+ * @info: the instance including private data of max8997 MUIC
+ * @group: the path according to attached cable
+ * @attached: store cable state and return
+ *
+ * This function check the cable state either attached or detached,
+ * and then divide precise type of cable according to cable group.
+ *	- MAX8997_CABLE_GROUP_ADC
+ *	- MAX8997_CABLE_GROUP_CHG
+ */
+static int max8997_muic_get_cable_type(struct max8997_muic_info *info,
+		enum max8997_muic_cable_group group, bool *attached)
+{
+	int cable_type = 0;
+	int adc;
+	int chg_type;
+
+	switch (group) {
+	case MAX8997_CABLE_GROUP_ADC:
+		/*
+		 * Read ADC value to check cable type and decide cable state
+		 * according to cable type
+		 */
+		adc = info->status[0] & STATUS1_ADC_MASK;
+		adc >>= STATUS1_ADC_SHIFT;
+
+		/*
+		 * Check current cable state/cable type and store cable type
+		 * (info->prev_cable_type) for handling cable when cable is
+		 * detached.
+		 */
+		if (adc == MAX8997_MUIC_ADC_OPEN) {
+			*attached = false;
+
+			cable_type = info->prev_cable_type;
+			info->prev_cable_type = MAX8997_MUIC_ADC_OPEN;
+		} else {
+			*attached = true;
+
+			cable_type = info->prev_cable_type = adc;
+		}
+		break;
+	case MAX8997_CABLE_GROUP_CHG:
+		/*
+		 * Read charger type to check cable type and decide cable state
+		 * according to type of charger cable.
+		 */
+		chg_type = info->status[1] & STATUS2_CHGTYP_MASK;
+		chg_type >>= STATUS2_CHGTYP_SHIFT;
+
+		if (chg_type == MAX8997_CHARGER_TYPE_NONE) {
+			*attached = false;
+
+			cable_type = info->prev_chg_type;
+			info->prev_chg_type = MAX8997_CHARGER_TYPE_NONE;
+		} else {
+			*attached = true;
+
+			/*
+			 * Check current cable state/cable type and store cable
+			 * type(info->prev_chg_type) for handling cable when
+			 * charger cable is detached.
+			 */
+			cable_type = info->prev_chg_type = chg_type;
+		}
+
+		break;
+	default:
+		dev_err(info->dev, "Unknown cable group (%d)\n", group);
+		cable_type = -EINVAL;
+		break;
+	}
+
+	return cable_type;
+}
+
 static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 			enum max8997_muic_usb_type usb_type, bool attached)
 {
@@ -188,9 +323,9 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 
 	if (usb_type == MAX8997_USB_HOST) {
 		ret = max8997_muic_set_path(info, CONTROL1_SW_USB, attached);
-		if (ret) {
+		if (ret < 0) {
 			dev_err(info->dev, "failed to update muic register\n");
-			goto out;
+			return ret;
 		}
 	}
 
@@ -202,38 +337,39 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 		extcon_set_cable_state(info->edev, "USB", attached);
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		dev_err(info->dev, "failed to detect %s usb cable\n",
+			attached ? "attached" : "detached");
+		return -EINVAL;
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 static int max8997_muic_handle_dock(struct max8997_muic_info *info,
-			int adc, bool attached)
+			int cable_type, bool attached)
 {
 	int ret = 0;
 
 	ret = max8997_muic_set_path(info, CONTROL1_SW_AUDIO, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
-		goto out;
+		return ret;
 	}
 
-	switch (adc) {
-	case MAX8997_ADC_DESKDOCK:
+	switch (cable_type) {
+	case MAX8997_MUIC_ADC_AV_CABLE_NOLOAD:
 		extcon_set_cable_state(info->edev, "Dock-desk", attached);
 		break;
-	case MAX8997_ADC_CARDOCK:
+	case MAX8997_MUIC_ADC_FACTORY_MODE_UART_ON:
 		extcon_set_cable_state(info->edev, "Dock-card", attached);
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		dev_err(info->dev, "failed to detect %s dock device\n",
+			attached ? "attached" : "detached");
+		return -EINVAL;
 	}
-out:
-	return ret;
+
+	return 0;
 }
 
 static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
@@ -245,193 +381,185 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 	ret = max8997_muic_set_path(info, CONTROL1_SW_UART, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
-		goto out;
+		return -EINVAL;
 	}
 
 	extcon_set_cable_state(info->edev, "JIG", attached);
-out:
-	return ret;
-}
 
-static int max8997_muic_handle_adc_detach(struct max8997_muic_info *info)
-{
-	int ret = 0;
-
-	switch (info->pre_adc) {
-	case MAX8997_ADC_GROUND:
-		ret = max8997_muic_handle_usb(info, MAX8997_USB_HOST, false);
-		break;
-	case MAX8997_ADC_MHL:
-		extcon_set_cable_state(info->edev, "MHL", false);
-		break;
-	case MAX8997_ADC_JIG_USB_1:
-	case MAX8997_ADC_JIG_USB_2:
-		ret = max8997_muic_handle_usb(info, MAX8997_USB_DEVICE, false);
-		break;
-	case MAX8997_ADC_DESKDOCK:
-	case MAX8997_ADC_CARDOCK:
-		ret = max8997_muic_handle_dock(info, info->pre_adc, false);
-		break;
-	case MAX8997_ADC_JIG_UART:
-		ret = max8997_muic_handle_jig_uart(info, false);
-		break;
-	default:
-		break;
-	}
-
-	return ret;
+	return 0;
 }
 
-static int max8997_muic_handle_adc(struct max8997_muic_info *info, int adc)
+static int max8997_muic_adc_handler(struct max8997_muic_info *info)
 {
+	int cable_type;
+	bool attached;
 	int ret = 0;
 
-	switch (adc) {
-	case MAX8997_ADC_GROUND:
-		ret = max8997_muic_handle_usb(info, MAX8997_USB_HOST, true);
-		break;
-	case MAX8997_ADC_MHL:
-		extcon_set_cable_state(info->edev, "MHL", true);
-		break;
-	case MAX8997_ADC_JIG_USB_1:
-	case MAX8997_ADC_JIG_USB_2:
-		ret = max8997_muic_handle_usb(info, MAX8997_USB_DEVICE, true);
-		break;
-	case MAX8997_ADC_DESKDOCK:
-	case MAX8997_ADC_CARDOCK:
-		ret = max8997_muic_handle_dock(info, adc, true);
-		break;
-	case MAX8997_ADC_JIG_UART:
-		ret = max8997_muic_handle_jig_uart(info, true);
-		break;
-	case MAX8997_ADC_OPEN:
-		ret = max8997_muic_handle_adc_detach(info);
-		break;
-	default:
-		ret = -EINVAL;
-		goto out;
-	}
-
-	info->pre_adc = adc;
-out:
-	return ret;
-}
-
-static int max8997_muic_handle_charger_type_detach(
-				struct max8997_muic_info *info)
-{
-	switch (info->pre_charger_type) {
-	case MAX8997_CHARGER_TYPE_USB:
-		extcon_set_cable_state(info->edev, "USB", false);
-		break;
-	case MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev, "Charge-downstream", false);
-		break;
-	case MAX8997_CHARGER_TYPE_DEDICATED_CHG:
-		extcon_set_cable_state(info->edev, "TA", false);
-		break;
-	case MAX8997_CHARGER_TYPE_500MA:
-		extcon_set_cable_state(info->edev, "Slow-charger", false);
-		break;
-	case MAX8997_CHARGER_TYPE_1A:
-		extcon_set_cable_state(info->edev, "Fast-charger", false);
-		break;
+	/* Check cable state which is either detached or attached */
+	cable_type = max8997_muic_get_cable_type(info,
+				MAX8997_CABLE_GROUP_ADC, &attached);
+
+	switch (cable_type) {
+	case MAX8997_MUIC_ADC_GROUND:
+		ret = max8997_muic_handle_usb(info, MAX8997_USB_HOST, attached);
+		if (ret < 0)
+			return ret;
+		break;
+	case MAX8997_MUIC_ADC_MHL:
+		extcon_set_cable_state(info->edev, "MHL", attached);
+		break;
+	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_OFF:
+	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_ON:
+		ret = max8997_muic_handle_usb(info, MAX8997_USB_DEVICE, attached);
+		if (ret < 0)
+			return ret;
+		break;
+	case MAX8997_MUIC_ADC_AV_CABLE_NOLOAD:
+	case MAX8997_MUIC_ADC_FACTORY_MODE_UART_ON:
+		ret = max8997_muic_handle_dock(info, cable_type, attached);
+		if (ret < 0)
+			return ret;
+		break;
+	case MAX8997_MUIC_ADC_FACTORY_MODE_UART_OFF:
+		ret = max8997_muic_handle_jig_uart(info, attached);
+		break;
+	case MAX8997_MUIC_ADC_REMOTE_S1_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S2_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S3_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S4_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S5_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S6_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S7_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S8_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S9_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S10_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S11_BUTTON:
+	case MAX8997_MUIC_ADC_REMOTE_S12_BUTTON:
+	case MAX8997_MUIC_ADC_RESERVED_ACC_1:
+	case MAX8997_MUIC_ADC_RESERVED_ACC_2:
+	case MAX8997_MUIC_ADC_RESERVED_ACC_3:
+	case MAX8997_MUIC_ADC_RESERVED_ACC_4:
+	case MAX8997_MUIC_ADC_RESERVED_ACC_5:
+	case MAX8997_MUIC_ADC_CEA936_AUDIO:
+	case MAX8997_MUIC_ADC_PHONE_POWERED_DEV:
+	case MAX8997_MUIC_ADC_TTY_CONVERTER:
+	case MAX8997_MUIC_ADC_UART_CABLE:
+	case MAX8997_MUIC_ADC_CEA936A_TYPE1_CHG:
+	case MAX8997_MUIC_ADC_CEA936A_TYPE2_CHG:
+	case MAX8997_MUIC_ADC_AUDIO_MODE_REMOTE:
+		/*
+		 * This cable isn't used in general case if it is specially
+		 * needed to detect additional cable, should implement
+		 * proper operation when this cable is attached/detached.
+		 */
+		dev_info(info->dev,
+			"cable is %s but it isn't used (type:0x%x)\n",
+			attached ? "attached" : "detached", cable_type);
+		return -EAGAIN;
 	default:
+		dev_err(info->dev,
+			"failed to detect %s unknown cable (type:0x%x)\n",
+			attached ? "attached" : "detached", cable_type);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static int max8997_muic_handle_charger_type(struct max8997_muic_info *info,
-				enum max8997_muic_charger_type charger_type)
+static int max8997_muic_chg_handler(struct max8997_muic_info *info)
 {
-	u8 adc;
-	int ret;
+	int chg_type;
+	bool attached;
+	int adc;
 
-	ret = max8997_read_reg(info->muic, MAX8997_MUIC_REG_STATUS1, &adc);
-	if (ret) {
-		dev_err(info->dev, "failed to read muic register\n");
-		goto out;
-	}
+	chg_type = max8997_muic_get_cable_type(info,
+				MAX8997_CABLE_GROUP_CHG, &attached);
 
-	switch (charger_type) {
+	switch (chg_type) {
 	case MAX8997_CHARGER_TYPE_NONE:
-		ret = max8997_muic_handle_charger_type_detach(info);
 		break;
 	case MAX8997_CHARGER_TYPE_USB:
-		if ((adc & STATUS1_ADC_MASK) == MAX8997_ADC_OPEN) {
+		adc = info->status[0] & STATUS1_ADC_MASK;
+		adc >>= STATUS1_ADC_SHIFT;
+
+		if ((adc & STATUS1_ADC_MASK) == MAX8997_MUIC_ADC_OPEN) {
 			max8997_muic_handle_usb(info,
-					MAX8997_USB_DEVICE, true);
+					MAX8997_USB_DEVICE, attached);
 		}
 		break;
 	case MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev, "Charge-downstream", true);
+		extcon_set_cable_state(info->edev, "Charge-downstream", attached);
 		break;
 	case MAX8997_CHARGER_TYPE_DEDICATED_CHG:
-		extcon_set_cable_state(info->edev, "TA", true);
+		extcon_set_cable_state(info->edev, "TA", attached);
 		break;
 	case MAX8997_CHARGER_TYPE_500MA:
-		extcon_set_cable_state(info->edev, "Slow-charger", true);
+		extcon_set_cable_state(info->edev, "Slow-charger", attached);
 		break;
 	case MAX8997_CHARGER_TYPE_1A:
-		extcon_set_cable_state(info->edev, "Fast-charger", true);
+		extcon_set_cable_state(info->edev, "Fast-charger", attached);
 		break;
 	default:
-		ret = -EINVAL;
-		goto out;
+		dev_err(info->dev,
+			"failed to detect %s unknown chg cable (type:0x%x)\n",
+			attached ? "attached" : "detached", chg_type);
+		return -EINVAL;
 	}
 
-	info->pre_charger_type = charger_type;
-out:
-	return ret;
+	return 0;
 }
 
 static void max8997_muic_irq_work(struct work_struct *work)
 {
 	struct max8997_muic_info *info = container_of(work,
 			struct max8997_muic_info, irq_work);
-	u8 status[2];
-	u8 adc, chg_type;
 	int irq_type = 0;
 	int i, ret;
 
+	if (!info->edev)
+		return;
+
 	mutex_lock(&info->mutex);
 
+	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+		if (info->irq == muic_irqs[i].virq)
+			irq_type = muic_irqs[i].irq;
+
 	ret = max8997_bulk_read(info->muic, MAX8997_MUIC_REG_STATUS1,
-				2, status);
+				2, info->status);
 	if (ret) {
 		dev_err(info->dev, "failed to read muic register\n");
 		mutex_unlock(&info->mutex);
 		return;
 	}
 
-	dev_dbg(info->dev, "%s: STATUS1:0x%x, 2:0x%x\n", __func__,
-			status[0], status[1]);
-
-	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
-		if (info->irq == muic_irqs[i].virq)
-			irq_type = muic_irqs[i].irq;
-
 	switch (irq_type) {
+	case MAX8997_MUICIRQ_ADCError:
+	case MAX8997_MUICIRQ_ADCLow:
 	case MAX8997_MUICIRQ_ADC:
-		adc = status[0] & STATUS1_ADC_MASK;
-		adc >>= STATUS1_ADC_SHIFT;
-
-		max8997_muic_handle_adc(info, adc);
+		/* Handle all of cable except for charger cable */
+		ret = max8997_muic_adc_handler(info);
 		break;
+	case MAX8997_MUICIRQ_VBVolt:
+	case MAX8997_MUICIRQ_DBChg:
+	case MAX8997_MUICIRQ_DCDTmr:
+	case MAX8997_MUICIRQ_ChgDetRun:
 	case MAX8997_MUICIRQ_ChgTyp:
-		chg_type = status[1] & STATUS2_CHGTYP_MASK;
-		chg_type >>= STATUS2_CHGTYP_SHIFT;
-
-		max8997_muic_handle_charger_type(info, chg_type);
+		/* Handle charger cable */
+		ret = max8997_muic_chg_handler(info);
+		break;
+	case MAX8997_MUICIRQ_OVP:
 		break;
 	default:
 		dev_info(info->dev, "misc interrupt: irq %d occurred\n",
 				irq_type);
-		break;
+		mutex_unlock(&info->mutex);
+		return;
 	}
 
+	if (ret < 0)
+		dev_err(info->dev, "failed to handle MUIC interrupt\n");
+
 	mutex_unlock(&info->mutex);
 
 	return;
@@ -449,29 +577,49 @@ static irqreturn_t max8997_muic_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void max8997_muic_detect_dev(struct max8997_muic_info *info)
+static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 {
-	int ret;
-	u8 status[2], adc, chg_type;
+	int ret = 0;
+	int adc;
+	int chg_type;
+	bool attached;
 
-	ret = max8997_bulk_read(info->muic, MAX8997_MUIC_REG_STATUS1,
-				2, status);
+	mutex_lock(&info->mutex);
+
+	/* Read STATUSx register to detect accessory */
+	ret = max8997_bulk_read(info->muic,
+			MAX8997_MUIC_REG_STATUS1, 2, info->status);
 	if (ret) {
-		dev_err(info->dev, "failed to read muic register\n");
-		return;
+		dev_err(info->dev, "failed to read MUIC register\n");
+		mutex_unlock(&info->mutex);
+		return -EINVAL;
 	}
 
-	dev_info(info->dev, "STATUS1:0x%x, STATUS2:0x%x\n",
-			status[0], status[1]);
+	adc = max8997_muic_get_cable_type(info, MAX8997_CABLE_GROUP_ADC,
+					&attached);
+	if (attached && adc != MAX8997_MUIC_ADC_OPEN) {
+		ret = max8997_muic_adc_handler(info);
+		if (ret < 0) {
+			dev_err(info->dev, "Cannot detect ADC cable\n");
+			mutex_unlock(&info->mutex);
+			return ret;
+		}
+	}
 
-	adc = status[0] & STATUS1_ADC_MASK;
-	adc >>= STATUS1_ADC_SHIFT;
+	chg_type = max8997_muic_get_cable_type(info, MAX8997_CABLE_GROUP_CHG,
+					&attached);
+	if (attached && chg_type != MAX8997_CHARGER_TYPE_NONE) {
+		ret = max8997_muic_chg_handler(info);
+		if (ret < 0) {
+			dev_err(info->dev, "Cannot detect charger cable\n");
+			mutex_unlock(&info->mutex);
+			return ret;
+		}
+	}
 
-	chg_type = status[1] & STATUS2_CHGTYP_MASK;
-	chg_type >>= STATUS2_CHGTYP_SHIFT;
+	mutex_unlock(&info->mutex);
 
-	max8997_muic_handle_adc(info, adc);
-	max8997_muic_handle_charger_type(info, chg_type);
+	return 0;
 }
 
 static int max8997_muic_probe(struct platform_device *pdev)
@@ -550,10 +698,16 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	max8997_muic_set_debounce_time(info, ADC_DEBOUNCE_TIME_25MS);
 
 	/* Initial device detection */
-	max8997_muic_detect_dev(info);
+	ret = max8997_muic_detect_dev(info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to detect cable type\n");
+		goto err_extcon;
+	}
 
 	return ret;
 
+err_extcon:
+	extcon_dev_unregister(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index cd37a92..fb465df 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -258,15 +258,6 @@ enum max8997_muic_reg {
 #define CONTROL3_BTLDSET_MASK		(0x3 << CONTROL3_BTLDSET_SHIFT)
 #define CONTROL3_ADCDBSET_MASK		(0x3 << CONTROL3_ADCDBSET_SHIFT)
 
-#define	MAX8997_ADC_GROUND		0x00
-#define	MAX8997_ADC_MHL			0x01
-#define	MAX8997_ADC_JIG_USB_1		0x18
-#define	MAX8997_ADC_JIG_USB_2		0x19
-#define	MAX8997_ADC_DESKDOCK		0x1a
-#define	MAX8997_ADC_JIG_UART		0x1c
-#define	MAX8997_ADC_CARDOCK		0x1d
-#define	MAX8997_ADC_OPEN		0x1f
-
 enum max8997_haptic_reg {
 	MAX8997_HAPTIC_REG_GENERAL	= 0x00,
 	MAX8997_HAPTIC_REG_CONF1	= 0x01,
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 1d4a4fe..65f8d6a 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -78,21 +78,6 @@ struct max8997_regulator_data {
 	struct device_node *reg_node;
 };
 
-enum max8997_muic_usb_type {
-	MAX8997_USB_HOST,
-	MAX8997_USB_DEVICE,
-};
-
-enum max8997_muic_charger_type {
-	MAX8997_CHARGER_TYPE_NONE = 0,
-	MAX8997_CHARGER_TYPE_USB,
-	MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT,
-	MAX8997_CHARGER_TYPE_DEDICATED_CHG,
-	MAX8997_CHARGER_TYPE_500MA,
-	MAX8997_CHARGER_TYPE_1A,
-	MAX8997_CHARGER_TYPE_DEAD_BATTERY = 7,
-};
-
 struct max8997_muic_reg_data {
 	u8 addr;
 	u8 data;
-- 
1.8.0

