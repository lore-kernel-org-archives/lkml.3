Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaA1MXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:23:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20320 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaA1MTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:07 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e9-52e7a03954de
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to
 prepare for max77836
Date: Tue, 28 Jan 2014 13:18:31 +0100
Message-id: <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xa7qWC54HGbz6LGkx9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6MmbP/MhfMusRU
	ceA+SwPjrXlMXYycHBICJhIrLvWzQ9hiEhfurWfrYuTiEBJYyihx70UjC4TTxyRx//I5NpAq
	NgFjic3Ll4BViQisZpJYs2AqC0iCWaCXUeLmbg8QW1ggXmLjxx+MIDaLgKpEz+ulYM28Au4S
	2z5MAKrnAFqnIDFnkg1ImFPAQ+LV1Uawi4SASk4df8cygZF3ASPDKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQYPy6g3HpMatDjAIcjEo8vA+6nwUJsSaWFVfmHmKU4GBWEuFNnP08SIg3
	JbGyKrUoP76oNCe1+BAjEwenVAOjm8//l7+0V9R5fvXfH3+LJZR5StqDCSlXc3r8VbnniTek
	xqeZVb6V+XDHevO87l0nAm6rbP2UuvrIRimBqwx8Sq7vThdfnryF6cLEaVfU3z3bM+cjmz+j
	Zrx2k0dD27zrBxzemuZLVPz6qMvG55uWlryllcV5/Yw5znGLOFwfVU++tTDpjGWXEktxRqKh
	FnNRcSIAJmubnCQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for max77836 device to existing
max14577 driver:
1. Renames most of symbols and defines prefixed with MAX14577 to MAXIM.
2. Adds prefixes (MAXIM or MAX14577) to defines without any MAX* prefix.

This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/extcon/extcon-max14577.c     |  105 ++++-----
 drivers/mfd/max14577.c               |   51 ++---
 drivers/power/max14577_charger.c     |   81 +++----
 drivers/regulator/max14577.c         |   44 ++--
 include/linux/mfd/max14577-private.h |  399 ++++++++++++++++------------------
 include/linux/mfd/max14577.h         |    2 +-
 6 files changed, 333 insertions(+), 349 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 59f084fee4f3..6f7145a929cf 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -86,14 +86,14 @@ struct max14577_muic_irq {
 };
 
 static struct max14577_muic_irq muic_irqs[] = {
-	{ MAX14577_IRQ_INT1_ADC,	"muic-ADC" },
-	{ MAX14577_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
-	{ MAX14577_IRQ_INT1_ADCERR,	"muic-ADCError" },
-	{ MAX14577_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
-	{ MAX14577_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
-	{ MAX14577_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
-	{ MAX14577_IRQ_INT2_DBCHG,	"muic-DBCHG" },
-	{ MAX14577_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
+	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
+	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
+	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
+	{ MAXIM_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
+	{ MAXIM_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
+	{ MAXIM_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
+	{ MAXIM_IRQ_INT2_DBCHG,		"muic-DBCHG" },
+	{ MAXIM_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
 };
 
 /* Define supported accessory type */
@@ -177,9 +177,9 @@ static int max14577_muic_set_debounce_time(struct max14577_muic_info *info,
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
 		ret = max14577_update_reg(info->max14577->regmap,
-					  MAX14577_MUIC_REG_CONTROL3,
-					  CTRL3_ADCDBSET_MASK,
-					  time << CTRL3_ADCDBSET_SHIFT);
+				MAXIM_MUIC_REG_CONTROL3,
+				MAXIM_CONTROL3_ADCDBSET_MASK,
+				time << MAXIM_CONTROL3_ADCDBSET_SHIFT);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
@@ -211,8 +211,9 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 
 	/* Set open state to path before changing hw path */
 	ret = max14577_update_reg(info->max14577->regmap,
-				MAX14577_MUIC_REG_CONTROL1,
-				CLEAR_IDBEN_MICEN_MASK, CTRL1_SW_OPEN);
+			MAXIM_MUIC_REG_CONTROL1,
+			MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK,
+			MAXIM_CONTROL1_SW_OPEN);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -221,24 +222,25 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	if (attached)
 		ctrl1 = val;
 	else
-		ctrl1 = CTRL1_SW_OPEN;
+		ctrl1 = MAXIM_CONTROL1_SW_OPEN;
 
 	ret = max14577_update_reg(info->max14577->regmap,
-				MAX14577_MUIC_REG_CONTROL1,
-				CLEAR_IDBEN_MICEN_MASK, ctrl1);
+				MAXIM_MUIC_REG_CONTROL1,
+				MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK, ctrl1);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
 	}
 
 	if (attached)
-		ctrl2 |= CTRL2_CPEN_MASK;	/* LowPwr=0, CPEn=1 */
+		ctrl2 |= MAXIM_CONTROL2_CPEN_MASK;	/* LowPwr=0, CPEn=1 */
 	else
-		ctrl2 |= CTRL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
+		ctrl2 |= MAXIM_CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
 	ret = max14577_update_reg(info->max14577->regmap,
-			MAX14577_REG_CONTROL2,
-			CTRL2_LOWPWR_MASK | CTRL2_CPEN_MASK, ctrl2);
+			MAXIM_MUIC_REG_CONTROL2,
+			MAXIM_CONTROL2_LOWPWR_MASK | MAXIM_CONTROL2_CPEN_MASK,
+			ctrl2);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -275,8 +277,9 @@ static int max14577_muic_get_cable_type(struct max14577_muic_info *info,
 		 * Read ADC value to check cable type and decide cable state
 		 * according to cable type
 		 */
-		adc = info->status[MAX14577_MUIC_STATUS1] & STATUS1_ADC_MASK;
-		adc >>= STATUS1_ADC_SHIFT;
+		adc = info->status[MAX14577_MUIC_STATUS1] &
+			MAXIM_STATUS1_ADC_MASK;
+		adc >>= MAXIM_STATUS1_ADC_SHIFT;
 
 		/*
 		 * Check current cable state/cable type and store cable type
@@ -300,14 +303,14 @@ static int max14577_muic_get_cable_type(struct max14577_muic_info *info,
 		 * according to type of charger cable.
 		 */
 		chg_type = info->status[MAX14577_MUIC_STATUS2] &
-			STATUS2_CHGTYP_MASK;
-		chg_type >>= STATUS2_CHGTYP_SHIFT;
+			MAXIM_STATUS2_CHGTYP_MASK;
+		chg_type >>= MAXIM_STATUS2_CHGTYP_SHIFT;
 
-		if (chg_type == MAX14577_CHARGER_TYPE_NONE) {
+		if (chg_type == MAXIM_CHARGER_TYPE_NONE) {
 			*attached = false;
 
 			cable_type = info->prev_chg_type;
-			info->prev_chg_type = MAX14577_CHARGER_TYPE_NONE;
+			info->prev_chg_type = MAXIM_CHARGER_TYPE_NONE;
 		} else {
 			*attached = true;
 
@@ -334,7 +337,7 @@ static int max14577_muic_jig_handler(struct max14577_muic_info *info,
 {
 	char cable_name[32];
 	int ret = 0;
-	u8 path = CTRL1_SW_OPEN;
+	u8 path = MAXIM_CONTROL1_SW_OPEN;
 
 	dev_dbg(info->dev,
 		"external connector is %s (adc:0x%02x)\n",
@@ -344,17 +347,17 @@ static int max14577_muic_jig_handler(struct max14577_muic_info *info,
 	case MAX14577_MUIC_ADC_FACTORY_MODE_USB_OFF:	/* ADC_JIG_USB_OFF */
 		/* PATH:AP_USB */
 		strcpy(cable_name, "JIG-USB-OFF");
-		path = CTRL1_SW_USB;
+		path = MAXIM_CONTROL1_SW_USB;
 		break;
 	case MAX14577_MUIC_ADC_FACTORY_MODE_USB_ON:	/* ADC_JIG_USB_ON */
 		/* PATH:AP_USB */
 		strcpy(cable_name, "JIG-USB-ON");
-		path = CTRL1_SW_USB;
+		path = MAXIM_CONTROL1_SW_USB;
 		break;
 	case MAX14577_MUIC_ADC_FACTORY_MODE_UART_OFF:	/* ADC_JIG_UART_OFF */
 		/* PATH:AP_UART */
 		strcpy(cable_name, "JIG-UART-OFF");
-		path = CTRL1_SW_UART;
+		path = MAXIM_CONTROL1_SW_UART;
 		break;
 	default:
 		dev_err(info->dev, "failed to detect %s jig cable\n",
@@ -457,7 +460,7 @@ static int max14577_muic_chg_handler(struct max14577_muic_info *info)
 			chg_type, info->prev_chg_type);
 
 	switch (chg_type) {
-	case MAX14577_CHARGER_TYPE_USB:
+	case MAXIM_CHARGER_TYPE_USB:
 		/* PATH:AP_USB */
 		ret = max14577_muic_set_path(info, info->path_usb, attached);
 		if (ret < 0)
@@ -465,21 +468,21 @@ static int max14577_muic_chg_handler(struct max14577_muic_info *info)
 
 		extcon_set_cable_state(info->edev, "USB", attached);
 		break;
-	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
+	case MAXIM_CHARGER_TYPE_DEDICATED_CHG:
 		extcon_set_cable_state(info->edev, "TA", attached);
 		break;
-	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
+	case MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT:
 		extcon_set_cable_state(info->edev,
 				"Charge-downstream", attached);
 		break;
-	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
+	case MAXIM_CHARGER_TYPE_SPECIAL_500MA:
 		extcon_set_cable_state(info->edev, "Slow-charger", attached);
 		break;
-	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
+	case MAXIM_CHARGER_TYPE_SPECIAL_1A:
 		extcon_set_cable_state(info->edev, "Fast-charger", attached);
 		break;
-	case MAX14577_CHARGER_TYPE_NONE:
-	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAXIM_CHARGER_TYPE_NONE:
+	case MAXIM_CHARGER_TYPE_DEAD_BATTERY:
 		break;
 	default:
 		dev_err(info->dev,
@@ -503,7 +506,7 @@ static void max14577_muic_irq_work(struct work_struct *work)
 	mutex_lock(&info->mutex);
 
 	ret = max14577_bulk_read(info->max14577->regmap,
-			MAX14577_MUIC_REG_STATUS1, info->status, 2);
+			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -543,18 +546,18 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 			irq_type = muic_irqs[i].irq;
 
 	switch (irq_type) {
-	case MAX14577_IRQ_INT1_ADC:
-	case MAX14577_IRQ_INT1_ADCLOW:
-	case MAX14577_IRQ_INT1_ADCERR:
+	case MAXIM_IRQ_INT1_ADC:
+	case MAXIM_IRQ_INT1_ADCLOW:
+	case MAXIM_IRQ_INT1_ADCERR:
 		/* Handle all of accessory except for
 		   type of charger accessory */
 		info->irq_adc = true;
 		break;
-	case MAX14577_IRQ_INT2_CHGTYP:
-	case MAX14577_IRQ_INT2_CHGDETRUN:
-	case MAX14577_IRQ_INT2_DCDTMR:
-	case MAX14577_IRQ_INT2_DBCHG:
-	case MAX14577_IRQ_INT2_VBVOLT:
+	case MAXIM_IRQ_INT2_CHGTYP:
+	case MAXIM_IRQ_INT2_CHGDETRUN:
+	case MAXIM_IRQ_INT2_DCDTMR:
+	case MAXIM_IRQ_INT2_DBCHG:
+	case MAXIM_IRQ_INT2_VBVOLT:
 		/* Handle charger accessory */
 		info->irq_chg = true;
 		break;
@@ -579,7 +582,7 @@ static int max14577_muic_detect_accessory(struct max14577_muic_info *info)
 
 	/* Read STATUSx register to detect accessory */
 	ret = max14577_bulk_read(info->max14577->regmap,
-			MAX14577_MUIC_REG_STATUS1, info->status, 2);
+			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -599,7 +602,7 @@ static int max14577_muic_detect_accessory(struct max14577_muic_info *info)
 
 	chg_type = max14577_muic_get_cable_type(info, MAX14577_CABLE_GROUP_CHG,
 					&attached);
-	if (attached && chg_type != MAX14577_CHARGER_TYPE_NONE) {
+	if (attached && chg_type != MAXIM_CHARGER_TYPE_NONE) {
 		ret = max14577_muic_chg_handler(info);
 		if (ret < 0) {
 			dev_err(info->dev, "Cannot detect charger accessory\n");
@@ -682,8 +685,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Default h/w line path */
-	info->path_usb = CTRL1_SW_USB;
-	info->path_uart = CTRL1_SW_UART;
+	info->path_usb = MAXIM_CONTROL1_SW_USB;
+	info->path_uart = MAXIM_CONTROL1_SW_UART;
 	delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
 
 	/* Set initial path for UART */
@@ -691,7 +694,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 
 	/* Check revision number of MUIC device*/
 	ret = max14577_read_reg(info->max14577->regmap,
-			MAX14577_REG_DEVICEID, &id);
+			MAXIM_MUIC_REG_DEVICEID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
 		goto err_extcon;
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 75b37082a3fe..a054f6f6c16d 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -36,10 +36,10 @@ static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-charger", },
 };
 
-static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
+static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case MAX14577_REG_INT1 ... MAX14577_REG_STATUS3:
+	case MAXIM_MUIC_REG_INT1 ... MAXIM_MUIC_REG_STATUS3:
 		return true;
 	default:
 		break;
@@ -47,35 +47,35 @@ static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
-static const struct regmap_config max14577_regmap_config = {
+static const struct regmap_config max14577_muic_regmap_config = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
-	.volatile_reg	= max14577_volatile_reg,
-	.max_register	= MAX14577_REG_END,
+	.volatile_reg	= max14577_muic_volatile_reg,
+	.max_register	= MAXIM_MUIC_REG_END,
 };
 
 static const struct regmap_irq max14577_irqs[] = {
 	/* INT1 interrupts */
-	{ .reg_offset = 0, .mask = INT1_ADC_MASK, },
-	{ .reg_offset = 0, .mask = INT1_ADCLOW_MASK, },
-	{ .reg_offset = 0, .mask = INT1_ADCERR_MASK, },
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCLOW_MASK, },
+	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCERR_MASK, },
 	/* INT2 interrupts */
-	{ .reg_offset = 1, .mask = INT2_CHGTYP_MASK, },
-	{ .reg_offset = 1, .mask = INT2_CHGDETRUN_MASK, },
-	{ .reg_offset = 1, .mask = INT2_DCDTMR_MASK, },
-	{ .reg_offset = 1, .mask = INT2_DBCHG_MASK, },
-	{ .reg_offset = 1, .mask = INT2_VBVOLT_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGTYP_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGDETRUN_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_DCDTMR_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_DBCHG_MASK, },
+	{ .reg_offset = 1, .mask = MAXIM_INT2_VBVOLT_MASK, },
 	/* INT3 interrupts */
-	{ .reg_offset = 2, .mask = INT3_EOC_MASK, },
-	{ .reg_offset = 2, .mask = INT3_CGMBC_MASK, },
-	{ .reg_offset = 2, .mask = INT3_OVP_MASK, },
-	{ .reg_offset = 2, .mask = INT3_MBCCHGERR_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_EOC_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_CGMBC_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_OVP_MASK, },
+	{ .reg_offset = 2, .mask = MAXIM_INT3_MBCCHGERR_MASK, },
 };
 
 static const struct regmap_irq_chip max14577_irq_chip = {
 	.name			= "max14577",
-	.status_base		= MAX14577_REG_INT1,
-	.mask_base		= MAX14577_REG_INTMASK1,
+	.status_base		= MAXIM_MUIC_REG_INT1,
+	.mask_base		= MAXIM_MUIC_REG_INTMASK1,
 	.mask_invert		= 1,
 	.num_regs		= 3,
 	.irqs			= max14577_irqs,
@@ -112,7 +112,8 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	max14577->i2c = i2c;
 	max14577->irq = i2c->irq;
 
-	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
+	max14577->regmap = devm_regmap_init_i2c(i2c,
+			&max14577_muic_regmap_config);
 	if (IS_ERR(max14577->regmap)) {
 		ret = PTR_ERR(max14577->regmap);
 		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
@@ -120,17 +121,17 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
+	ret = max14577_read_reg(max14577->regmap, MAXIM_MUIC_REG_DEVICEID,
 			&reg_data);
 	if (ret) {
 		dev_err(max14577->dev, "Device not found on this channel: %d\n",
 				ret);
 		return ret;
 	}
-	max14577->vendor_id = ((reg_data & DEVID_VENDORID_MASK) >>
-				DEVID_VENDORID_SHIFT);
-	max14577->device_id = ((reg_data & DEVID_DEVICEID_MASK) >>
-				DEVID_DEVICEID_SHIFT);
+	max14577->vendor_id = ((reg_data & MAXIM_DEVID_VENDORID_MASK) >>
+				MAXIM_DEVID_VENDORID_SHIFT);
+	max14577->device_id = ((reg_data & MAXIM_DEVID_DEVICEID_MASK) >>
+				MAXIM_DEVID_DEVICEID_SHIFT);
 	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
 			max14577->device_id, max14577->vendor_id);
 
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index fad2a75b3604..66a4e4edea42 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -46,14 +46,14 @@ static int max14577_get_charger_state(struct max14577_charger *chg)
 	 *  - handle properly dead-battery charging (respect timer)
 	 *  - handle timers (fast-charge and prequal) /MBCCHGERR/
 	 */
-	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2, &reg_data);
-	if ((reg_data & CHGCTRL2_MBCHOSTEN_MASK) == 0)
+	max14577_read_reg(rmap, MAXIM_CHG_REG_CHGCTRL2, &reg_data);
+	if ((reg_data & MAXIM_CHGCTRL2_MBCHOSTEN_MASK) == 0)
 		goto state_set;
 
-	max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
-	if (reg_data & STATUS3_CGMBC_MASK) {
+	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS3, &reg_data);
+	if (reg_data & MAXIM_STATUS3_CGMBC_MASK) {
 		/* Charger or USB-cable is connected */
-		if (reg_data & STATUS3_EOC_MASK)
+		if (reg_data & MAXIM_STATUS3_EOC_MASK)
 			state = POWER_SUPPLY_STATUS_FULL;
 		else
 			state = POWER_SUPPLY_STATUS_CHARGING;
@@ -90,18 +90,19 @@ static int max14577_get_online(struct max14577_charger *chg)
 	struct regmap *rmap = chg->max14577->regmap;
 	u8 reg_data;
 
-	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
-	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
+	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
+	reg_data = reg_data & MAXIM_STATUS2_CHGTYP_MASK;
+	reg_data >>= MAXIM_STATUS2_CHGTYP_SHIFT;
 	switch (reg_data) {
-	case MAX14577_CHARGER_TYPE_USB:
-	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
-	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
-	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
-	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAXIM_CHARGER_TYPE_USB:
+	case MAXIM_CHARGER_TYPE_DEDICATED_CHG:
+	case MAXIM_CHARGER_TYPE_SPECIAL_500MA:
+	case MAXIM_CHARGER_TYPE_SPECIAL_1A:
+	case MAXIM_CHARGER_TYPE_DEAD_BATTERY:
 		return 1;
-	case MAX14577_CHARGER_TYPE_NONE:
-	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
-	case MAX14577_CHARGER_TYPE_RESERVED:
+	case MAXIM_CHARGER_TYPE_NONE:
+	case MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT:
+	case MAXIM_CHARGER_TYPE_RESERVED:
 	default:
 		return 0;
 	}
@@ -119,15 +120,16 @@ static int max14577_get_battery_health(struct max14577_charger *chg)
 	int state = POWER_SUPPLY_HEALTH_GOOD;
 	u8 reg_data;
 
-	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
-	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
-	if (reg_data == MAX14577_CHARGER_TYPE_DEAD_BATTERY) {
+	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
+	reg_data = reg_data & MAXIM_STATUS2_CHGTYP_MASK;
+	reg_data >>= MAXIM_STATUS2_CHGTYP_SHIFT;
+	if (reg_data == MAXIM_CHARGER_TYPE_DEAD_BATTERY) {
 		state = POWER_SUPPLY_HEALTH_DEAD;
 		goto state_set;
 	}
 
-	max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
-	if (reg_data & STATUS3_OVP_MASK) {
+	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS3, &reg_data);
+	if (reg_data & MAXIM_STATUS3_OVP_MASK) {
 		state = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto state_set;
 	}
@@ -162,46 +164,47 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	 * Charger-Detection Enable, default on (set CHGDETEN to 1)
 	 * Combined mask of CHGDETEN and CHGTYPMAN will zero the CHGTYPMAN bit
 	 */
-	reg_data = 0x1 << CDETCTRL1_CHGDETEN_SHIFT;
-	max14577_update_reg(rmap, MAX14577_REG_CDETCTRL1,
-			CDETCTRL1_CHGDETEN_MASK | CDETCTRL1_CHGTYPMAN_MASK,
+	reg_data = 0x1 << MAXIM_CDETCTRL1_CHGDETEN_SHIFT;
+	max14577_update_reg(rmap, MAXIM_MUIC_REG_CDETCTRL1,
+			MAXIM_CDETCTRL1_CHGDETEN_MASK |
+				MAXIM_CDETCTRL1_CHGTYPMAN_MASK,
 			reg_data);
 
 	/* Battery Fast-Charge Timer, from SM-V700: 6hrs */
-	reg_data = 0x3 << CHGCTRL1_TCHW_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL1, reg_data);
+	reg_data = 0x3 << MAXIM_CHGCTRL1_TCHW_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL1, reg_data);
 
 	/*
 	 * Wall-Adapter Rapid Charge, default on
 	 * Battery-Charger, default on
 	 */
-	reg_data = 0x1 << CHGCTRL2_VCHGR_RC_SHIFT;
-	reg_data |= 0x1 << CHGCTRL2_MBCHOSTEN_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL2, reg_data);
+	reg_data = 0x1 << MAXIM_CHGCTRL2_VCHGR_RC_SHIFT;
+	reg_data |= 0x1 << MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL2, reg_data);
 
 	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
-	reg_data = 0xf << CHGCTRL3_MBCCVWRC_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL3, reg_data);
+	reg_data = 0xf << MAXIM_CHGCTRL3_MBCCVWRC_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL3, reg_data);
 
 	/*
 	 * Fast Battery-Charge Current Low, default 200-950mA
 	 * Fast Battery-Charge Current High, from SM-V700: 450mA
 	 */
-	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
-	reg_data |= 0x5 << CHGCTRL4_MBCICHWRCH_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL4, reg_data);
+	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
+	reg_data |= 0x5 << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL4, reg_data);
 
 	/* End-of-Charge Current, from SM-V700: 50mA */
-	reg_data = 0x0 << CHGCTRL5_EOCS_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL5, reg_data);
+	reg_data = 0x0 << MAXIM_CHGCTRL5_EOCS_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL5, reg_data);
 
 	/* Auto Charging Stop, default off */
-	reg_data = 0x0 << CHGCTRL6_AUTOSTOP_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL6, reg_data);
+	reg_data = 0x0 << MAXIM_CHGCTRL6_AUTOSTOP_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL6, reg_data);
 
 	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
-	reg_data = 0x2 << CHGCTRL7_OTPCGHCVS_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL7, reg_data);
+	reg_data = 0x2 << MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL7, reg_data);
 }
 
 /* Support property from charger */
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 38821458d413..e65d61bb200f 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -30,11 +30,11 @@ static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 
 	switch (rid) {
 	case MAX14577_CHARGER:
-		max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2, &reg_data);
-		if ((reg_data & CHGCTRL2_MBCHOSTEN_MASK) == 0)
+		max14577_read_reg(rmap, MAXIM_CHG_REG_CHGCTRL2, &reg_data);
+		if ((reg_data & MAXIM_CHGCTRL2_MBCHOSTEN_MASK) == 0)
 			return 0;
-		max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
-		if ((reg_data & STATUS3_CGMBC_MASK) == 0)
+		max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS3, &reg_data);
+		if ((reg_data & MAXIM_STATUS3_CGMBC_MASK) == 0)
 			return 0;
 		/* MBCHOSTEN and CGMBC are on */
 		return 1;
@@ -51,13 +51,13 @@ static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
 
-	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL4, &reg_data);
+	max14577_read_reg(rmap, MAXIM_CHG_REG_CHGCTRL4, &reg_data);
 
-	if ((reg_data & CHGCTRL4_MBCICHWRCL_MASK) == 0)
+	if ((reg_data & MAXIM_CHGCTRL4_MBCICHWRCL_MASK) == 0)
 		return MAX14577_REGULATOR_CURRENT_LIMIT_MIN;
 
-	reg_data = ((reg_data & CHGCTRL4_MBCICHWRCH_MASK) >>
-			CHGCTRL4_MBCICHWRCH_SHIFT);
+	reg_data = ((reg_data & MAXIM_CHGCTRL4_MBCICHWRCH_MASK) >>
+			MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT);
 	return MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
 		reg_data * MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP;
 }
@@ -77,10 +77,10 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 
 	if (max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START) {
 		/* Less than 200 mA, so set 90mA (turn only Low Bit off) */
-		u8 reg_data = 0x0 << CHGCTRL4_MBCICHWRCL_SHIFT;
+		u8 reg_data = 0x0 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
 		return max14577_update_reg(rdev->regmap,
-				MAX14577_CHG_REG_CHG_CTRL4,
-				CHGCTRL4_MBCICHWRCL_MASK, reg_data);
+				MAXIM_CHG_REG_CHGCTRL4,
+				MAXIM_CHGCTRL4_MBCICHWRCL_MASK, reg_data);
 	}
 
 	/* max_uA is in range: <LIMIT_HIGH_START, inifinite>, so search for
@@ -94,13 +94,13 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 	}
 	BUG_ON(current_bits < 0); /* Cannot happen */
 	/* Turn Low Bit on (use range 200mA-950 mA) */
-	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
+	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
 	/* and set proper High Bits */
-	reg_data |= current_bits << CHGCTRL4_MBCICHWRCH_SHIFT;
+	reg_data |= current_bits << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
 
-	return max14577_update_reg(rdev->regmap, MAX14577_CHG_REG_CHG_CTRL4,
-			CHGCTRL4_MBCICHWRCL_MASK | CHGCTRL4_MBCICHWRCH_MASK,
-			reg_data);
+	return max14577_update_reg(rdev->regmap, MAXIM_CHG_REG_CHGCTRL4,
+		MAXIM_CHGCTRL4_MBCICHWRCL_MASK | MAXIM_CHGCTRL4_MBCICHWRCH_MASK,
+		reg_data);
 }
 
 static struct regulator_ops max14577_safeout_ops = {
@@ -127,8 +127,8 @@ static const struct regulator_desc supported_regulators[] = {
 		.owner		= THIS_MODULE,
 		.n_voltages	= 1,
 		.min_uV		= MAX14577_REGULATOR_SAFEOUT_VOLTAGE,
-		.enable_reg	= MAX14577_REG_CONTROL2,
-		.enable_mask	= CTRL2_SFOUTORD_MASK,
+		.enable_reg	= MAXIM_MUIC_REG_CONTROL2,
+		.enable_mask	= MAXIM_CONTROL2_SFOUTORD_MASK,
 	},
 	[MAX14577_CHARGER] = {
 		.name		= "CHARGER",
@@ -136,8 +136,8 @@ static const struct regulator_desc supported_regulators[] = {
 		.ops		= &max14577_charger_ops,
 		.type		= REGULATOR_CURRENT,
 		.owner		= THIS_MODULE,
-		.enable_reg	= MAX14577_CHG_REG_CHG_CTRL2,
-		.enable_mask	= CHGCTRL2_MBCHOSTEN_MASK,
+		.enable_reg	= MAXIM_CHG_REG_CHGCTRL2,
+		.enable_mask	= MAXIM_CHGCTRL2_MBCHOSTEN_MASK,
 	},
 };
 
@@ -159,7 +159,7 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 	}
 
 	ret = of_regulator_match(&pdev->dev, np, max14577_regulator_matches,
-			MAX14577_REG_MAX);
+			ARRAY_SIZE(max14577_regulator_matches));
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
 		return ret;
@@ -249,7 +249,7 @@ static int __init max14577_regulator_init(void)
 	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
 			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
 			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
-	BUILD_BUG_ON(ARRAY_SIZE(supported_regulators) != MAX14577_REG_MAX);
+	BUILD_BUG_ON(ARRAY_SIZE(supported_regulators) != MAX14577_REG_NUM);
 
 	return platform_driver_register(&max14577_regulator_driver);
 }
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index c9b332fb0d5d..9f5ce26cb54e 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -22,224 +22,199 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 
-#define MAX14577_REG_INVALID		(0xff)
-
-/* Slave addr = 0x4A: Interrupt */
-enum max14577_reg {
-	MAX14577_REG_DEVICEID		= 0x00,
-	MAX14577_REG_INT1		= 0x01,
-	MAX14577_REG_INT2		= 0x02,
-	MAX14577_REG_INT3		= 0x03,
-	MAX14577_REG_STATUS1		= 0x04,
-	MAX14577_REG_STATUS2		= 0x05,
-	MAX14577_REG_STATUS3		= 0x06,
-	MAX14577_REG_INTMASK1		= 0x07,
-	MAX14577_REG_INTMASK2		= 0x08,
-	MAX14577_REG_INTMASK3		= 0x09,
-	MAX14577_REG_CDETCTRL1		= 0x0A,
-	MAX14577_REG_RFU		= 0x0B,
-	MAX14577_REG_CONTROL1		= 0x0C,
-	MAX14577_REG_CONTROL2		= 0x0D,
-	MAX14577_REG_CONTROL3		= 0x0E,
-	MAX14577_REG_CHGCTRL1		= 0x0F,
-	MAX14577_REG_CHGCTRL2		= 0x10,
-	MAX14577_REG_CHGCTRL3		= 0x11,
-	MAX14577_REG_CHGCTRL4		= 0x12,
-	MAX14577_REG_CHGCTRL5		= 0x13,
-	MAX14577_REG_CHGCTRL6		= 0x14,
-	MAX14577_REG_CHGCTRL7		= 0x15,
-
-	MAX14577_REG_END,
+/* Slave addr = 0x4A: MUIC and Charger */
+enum maxim_muic_reg {
+	MAXIM_MUIC_REG_DEVICEID			= 0x00,
+	MAXIM_MUIC_REG_INT1			= 0x01,
+	MAXIM_MUIC_REG_INT2			= 0x02,
+	MAXIM_MUIC_REG_INT3			= 0x03,
+	MAXIM_MUIC_REG_STATUS1			= 0x04,
+	MAXIM_MUIC_REG_STATUS2			= 0x05,
+	MAXIM_MUIC_REG_STATUS3			= 0x06,
+	MAXIM_MUIC_REG_INTMASK1			= 0x07,
+	MAXIM_MUIC_REG_INTMASK2			= 0x08,
+	MAXIM_MUIC_REG_INTMASK3			= 0x09,
+	MAXIM_MUIC_REG_CDETCTRL1		= 0x0A,
+	MAXIM_MUIC_REG_RFU			= 0x0B,
+	MAXIM_MUIC_REG_CONTROL1			= 0x0C,
+	MAXIM_MUIC_REG_CONTROL2			= 0x0D,
+	MAXIM_MUIC_REG_CONTROL3			= 0x0E,
+	MAXIM_CHG_REG_CHGCTRL1			= 0x0F,
+	MAXIM_CHG_REG_CHGCTRL2			= 0x10,
+	MAXIM_CHG_REG_CHGCTRL3			= 0x11,
+	MAXIM_CHG_REG_CHGCTRL4			= 0x12,
+	MAXIM_CHG_REG_CHGCTRL5			= 0x13,
+	MAXIM_CHG_REG_CHGCTRL6			= 0x14,
+	MAXIM_CHG_REG_CHGCTRL7			= 0x15,
+
+	MAXIM_MUIC_REG_END,
 };
 
-/* Slave addr = 0x4A: MUIC */
-enum max14577_muic_reg {
-	MAX14577_MUIC_REG_STATUS1	= 0x04,
-	MAX14577_MUIC_REG_STATUS2	= 0x05,
-	MAX14577_MUIC_REG_CONTROL1	= 0x0C,
-	MAX14577_MUIC_REG_CONTROL3	= 0x0E,
-
-	MAX14577_MUIC_REG_END,
-};
-
-enum max14577_muic_charger_type {
-	MAX14577_CHARGER_TYPE_NONE = 0,
-	MAX14577_CHARGER_TYPE_USB,
-	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT,
-	MAX14577_CHARGER_TYPE_DEDICATED_CHG,
-	MAX14577_CHARGER_TYPE_SPECIAL_500MA,
-	MAX14577_CHARGER_TYPE_SPECIAL_1A,
-	MAX14577_CHARGER_TYPE_RESERVED,
-	MAX14577_CHARGER_TYPE_DEAD_BATTERY = 7,
+enum maxim_muic_charger_type {
+	MAXIM_CHARGER_TYPE_NONE			= 0,
+	MAXIM_CHARGER_TYPE_USB,
+	MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT,
+	MAXIM_CHARGER_TYPE_DEDICATED_CHG,
+	MAXIM_CHARGER_TYPE_SPECIAL_500MA,
+	MAXIM_CHARGER_TYPE_SPECIAL_1A,
+	MAXIM_CHARGER_TYPE_RESERVED,
+	MAXIM_CHARGER_TYPE_DEAD_BATTERY		= 7,
 };
 
 /* MAX14577 interrupts */
-#define INT1_ADC_MASK			(0x1 << 0)
-#define INT1_ADCLOW_MASK		(0x1 << 1)
-#define INT1_ADCERR_MASK		(0x1 << 2)
+#define MAXIM_INT1_ADC_MASK			(0x1 << 0)
+#define MAXIM_INT1_ADCLOW_MASK			(0x1 << 1)
+#define MAXIM_INT1_ADCERR_MASK			(0x1 << 2)
 
-#define INT2_CHGTYP_MASK		(0x1 << 0)
-#define INT2_CHGDETRUN_MASK		(0x1 << 1)
-#define INT2_DCDTMR_MASK		(0x1 << 2)
-#define INT2_DBCHG_MASK			(0x1 << 3)
-#define INT2_VBVOLT_MASK		(0x1 << 4)
+#define MAXIM_INT2_CHGTYP_MASK			(0x1 << 0)
+#define MAXIM_INT2_CHGDETRUN_MASK		(0x1 << 1)
+#define MAXIM_INT2_DCDTMR_MASK			(0x1 << 2)
+#define MAXIM_INT2_DBCHG_MASK			(0x1 << 3)
+#define MAXIM_INT2_VBVOLT_MASK			(0x1 << 4)
 
-#define INT3_EOC_MASK			(0x1 << 0)
-#define INT3_CGMBC_MASK			(0x1 << 1)
-#define INT3_OVP_MASK			(0x1 << 2)
-#define INT3_MBCCHGERR_MASK		(0x1 << 3)
+#define MAXIM_INT3_EOC_MASK			(0x1 << 0)
+#define MAXIM_INT3_CGMBC_MASK			(0x1 << 1)
+#define MAXIM_INT3_OVP_MASK			(0x1 << 2)
+#define MAXIM_INT3_MBCCHGERR_MASK		(0x1 << 3)
 
 /* MAX14577 DEVICE ID register */
-#define DEVID_VENDORID_SHIFT		0
-#define DEVID_DEVICEID_SHIFT		3
-#define DEVID_VENDORID_MASK		(0x07 << DEVID_VENDORID_SHIFT)
-#define DEVID_DEVICEID_MASK		(0x1f << DEVID_DEVICEID_SHIFT)
+#define MAXIM_DEVID_VENDORID_SHIFT	0
+#define MAXIM_DEVID_DEVICEID_SHIFT	3
+#define MAXIM_DEVID_VENDORID_MASK	(0x07 << MAXIM_DEVID_VENDORID_SHIFT)
+#define MAXIM_DEVID_DEVICEID_MASK	(0x1f << MAXIM_DEVID_DEVICEID_SHIFT)
 
 /* MAX14577 STATUS1 register */
-#define STATUS1_ADC_SHIFT		0
-#define STATUS1_ADCLOW_SHIFT		5
-#define STATUS1_ADCERR_SHIFT		6
-#define STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
-#define STATUS1_ADCLOW_MASK		(0x1 << STATUS1_ADCLOW_SHIFT)
-#define STATUS1_ADCERR_MASK		(0x1 << STATUS1_ADCERR_SHIFT)
+#define MAXIM_STATUS1_ADC_SHIFT		0
+#define MAXIM_STATUS1_ADCLOW_SHIFT	5
+#define MAXIM_STATUS1_ADCERR_SHIFT	6
+#define MAXIM_STATUS1_ADC_MASK		(0x1f << MAXIM_STATUS1_ADC_SHIFT)
+#define MAXIM_STATUS1_ADCLOW_MASK	(0x1 << MAXIM_STATUS1_ADCLOW_SHIFT)
+#define MAXIM_STATUS1_ADCERR_MASK	(0x1 << MAXIM_STATUS1_ADCERR_SHIFT)
 
 /* MAX14577 STATUS2 register */
-#define STATUS2_CHGTYP_SHIFT		0
-#define STATUS2_CHGDETRUN_SHIFT		3
-#define STATUS2_DCDTMR_SHIFT		4
-#define STATUS2_DBCHG_SHIFT		5
-#define STATUS2_VBVOLT_SHIFT		6
-#define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
-#define STATUS2_CHGDETRUN_MASK		(0x1 << STATUS2_CHGDETRUN_SHIFT)
-#define STATUS2_DCDTMR_MASK		(0x1 << STATUS2_DCDTMR_SHIFT)
-#define STATUS2_DBCHG_MASK		(0x1 << STATUS2_DBCHG_SHIFT)
-#define STATUS2_VBVOLT_MASK		(0x1 << STATUS2_VBVOLT_SHIFT)
+#define MAXIM_STATUS2_CHGTYP_SHIFT	0
+#define MAXIM_STATUS2_CHGDETRUN_SHIFT	3
+#define MAXIM_STATUS2_DCDTMR_SHIFT	4
+#define MAXIM_STATUS2_DBCHG_SHIFT	5
+#define MAXIM_STATUS2_VBVOLT_SHIFT	6
+#define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
+#define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
+#define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
+#define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
+#define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
+
+/* MAX14577 STATUS3 register */
+#define MAXIM_STATUS3_EOC_SHIFT		0
+#define MAXIM_STATUS3_CGMBC_SHIFT	1
+#define MAXIM_STATUS3_OVP_SHIFT		2
+#define MAXIM_STATUS3_MBCCHGERR_SHIFT	3
+#define MAXIM_STATUS3_EOC_MASK		(0x1 << MAXIM_STATUS3_EOC_SHIFT)
+#define MAXIM_STATUS3_CGMBC_MASK	(0x1 << MAXIM_STATUS3_CGMBC_SHIFT)
+#define MAXIM_STATUS3_OVP_MASK		(0x1 << MAXIM_STATUS3_OVP_SHIFT)
+#define MAXIM_STATUS3_MBCCHGERR_MASK	(0x1 << MAXIM_STATUS3_MBCCHGERR_SHIFT)
 
 /* MAX14577 CONTROL1 register */
-#define COMN1SW_SHIFT			0
-#define COMP2SW_SHIFT			3
-#define MICEN_SHIFT			6
-#define IDBEN_SHIFT			7
-#define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
-#define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
-#define MICEN_MASK			(0x1 << MICEN_SHIFT)
-#define IDBEN_MASK			(0x1 << IDBEN_SHIFT)
-#define CLEAR_IDBEN_MICEN_MASK		(COMN1SW_MASK | COMP2SW_MASK)
-#define CTRL1_SW_USB			((1 << COMP2SW_SHIFT) \
-						| (1 << COMN1SW_SHIFT))
-#define CTRL1_SW_AUDIO			((2 << COMP2SW_SHIFT) \
-						| (2 << COMN1SW_SHIFT))
-#define CTRL1_SW_UART			((3 << COMP2SW_SHIFT) \
-						| (3 << COMN1SW_SHIFT))
-#define CTRL1_SW_OPEN			((0 << COMP2SW_SHIFT) \
-						| (0 << COMN1SW_SHIFT))
+#define MAXIM_CONTROL1_COMN1SW_SHIFT	0
+#define MAXIM_CONTROL1_COMP2SW_SHIFT	3
+#define MAXIM_CONTROL1_MICEN_SHIFT	6
+#define MAXIM_CONTROL1_IDBEN_SHIFT	7
+#define MAXIM_CONTROL1_COMN1SW_MASK	(0x7 << MAXIM_CONTROL1_COMN1SW_SHIFT)
+#define MAXIM_CONTROL1_COMP2SW_MASK	(0x7 << MAXIM_CONTROL1_COMP2SW_SHIFT)
+#define MAXIM_CONTROL1_MICEN_MASK	(0x1 << MAXIM_CONTROL1_MICEN_SHIFT)
+#define MAXIM_CONTROL1_IDBEN_MASK	(0x1 << MAXIM_CONTROL1_IDBEN_SHIFT)
+
+#define MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK	(MAXIM_CONTROL1_COMN1SW_MASK | MAXIM_CONTROL1_COMP2SW_MASK)
+#define MAXIM_CONTROL1_SW_USB		((1 << MAXIM_CONTROL1_COMP2SW_SHIFT) \
+					| (1 << MAXIM_CONTROL1_COMN1SW_SHIFT))
+#define MAXIM_CONTROL1_SW_AUDIO		((2 << MAXIM_CONTROL1_COMP2SW_SHIFT) \
+					| (2 << MAXIM_CONTROL1_COMN1SW_SHIFT))
+#define MAXIM_CONTROL1_SW_UART		((3 << MAXIM_CONTROL1_COMP2SW_SHIFT) \
+					| (3 << MAXIM_CONTROL1_COMN1SW_SHIFT))
+#define MAXIM_CONTROL1_SW_OPEN		((0 << MAXIM_CONTROL1_COMP2SW_SHIFT) \
+					| (0 << MAXIM_CONTROL1_COMN1SW_SHIFT))
 
 /* MAX14577 CONTROL2 register */
-#define CTRL2_LOWPWR_SHIFT		(0)
-#define CTRL2_ADCEN_SHIFT		(1)
-#define CTRL2_CPEN_SHIFT		(2)
-#define CTRL2_SFOUTASRT_SHIFT		(3)
-#define CTRL2_SFOUTORD_SHIFT		(4)
-#define CTRL2_ACCDET_SHIFT		(5)
-#define CTRL2_USBCPINT_SHIFT		(6)
-#define CTRL2_RCPS_SHIFT		(7)
-#define CTRL2_LOWPWR_MASK		(0x1 << CTRL2_LOWPWR_SHIFT)
-#define CTRL2_ADCEN_MASK		(0x1 << CTRL2_ADCEN_SHIFT)
-#define CTRL2_CPEN_MASK			(0x1 << CTRL2_CPEN_SHIFT)
-#define CTRL2_SFOUTASRT_MASK		(0x1 << CTRL2_SFOUTASRT_SHIFT)
-#define CTRL2_SFOUTORD_MASK		(0x1 << CTRL2_SFOUTORD_SHIFT)
-#define CTRL2_ACCDET_MASK		(0x1 << CTRL2_ACCDET_SHIFT)
-#define CTRL2_USBCPINT_MASK		(0x1 << CTRL2_USBCPINT_SHIFT)
-#define CTRL2_RCPS_MASK			(0x1 << CTR2_RCPS_SHIFT)
-
-#define CTRL2_CPEN1_LOWPWR0 ((1 << CTRL2_CPEN_SHIFT) | \
-				(0 << CTRL2_LOWPWR_SHIFT))
-#define CTRL2_CPEN0_LOWPWR1 ((0 << CTRL2_CPEN_SHIFT) | \
-				(1 << CTRL2_LOWPWR_SHIFT))
+#define MAXIM_CONTROL2_LOWPWR_SHIFT	0
+#define MAXIM_CONTROL2_ADCEN_SHIFT	1
+#define MAXIM_CONTROL2_CPEN_SHIFT	2
+#define MAXIM_CONTROL2_SFOUTASRT_SHIFT	3
+#define MAXIM_CONTROL2_SFOUTORD_SHIFT	4
+#define MAXIM_CONTROL2_ACCDET_SHIFT	5
+#define MAXIM_CONTROL2_USBCPINT_SHIFT	6
+#define MAXIM_CONTROL2_RCPS_SHIFT	7
+#define MAXIM_CONTROL2_LOWPWR_MASK	(0x1 << MAXIM_CONTROL2_LOWPWR_SHIFT)
+#define MAXIM_CONTROL2_ADCEN_MASK	(0x1 << MAXIM_CONTROL2_ADCEN_SHIFT)
+#define MAXIM_CONTROL2_CPEN_MASK	(0x1 << MAXIM_CONTROL2_CPEN_SHIFT)
+#define MAXIM_CONTROL2_SFOUTASRT_MASK	(0x1 << MAXIM_CONTROL2_SFOUTASRT_SHIFT)
+#define MAXIM_CONTROL2_SFOUTORD_MASK	(0x1 << MAXIM_CONTROL2_SFOUTORD_SHIFT)
+#define MAXIM_CONTROL2_ACCDET_MASK	(0x1 << MAXIM_CONTROL2_ACCDET_SHIFT)
+#define MAXIM_CONTROL2_USBCPINT_MASK	(0x1 << MAXIM_CONTROL2_USBCPINT_SHIFT)
+#define MAXIM_CONTROL2_RCPS_MASK	(0x1 << MAXIM_CONTROL2_RCPS_SHIFT)
+
+#define MAXIM_CONTROL2_CPEN1_LOWPWR0	((1 << MAXIM_CONTROL2_CPEN_SHIFT) | \
+					(0 << MAXIM_CONTROL2_LOWPWR_SHIFT))
+#define MAXIM_CONTROL2_CPEN0_LOWPWR1	((0 << MAXIM_CONTROL2_CPEN_SHIFT) | \
+					(1 << MAXIM_CONTROL2_LOWPWR_SHIFT))
 
 /* MAX14577 CONTROL3 register */
-#define CTRL3_JIGSET_SHIFT		0
-#define CTRL3_BOOTSET_SHIFT		2
-#define CTRL3_ADCDBSET_SHIFT		4
-#define CTRL3_JIGSET_MASK		(0x3 << CTRL3_JIGSET_SHIFT)
-#define CTRL3_BOOTSET_MASK		(0x3 << CTRL3_BOOTSET_SHIFT)
-#define CTRL3_ADCDBSET_MASK		(0x3 << CTRL3_ADCDBSET_SHIFT)
-
-/* Slave addr = 0x4A: Charger */
-enum max14577_charger_reg {
-	MAX14577_CHG_REG_STATUS3	= 0x06,
-	MAX14577_CHG_REG_CHG_CTRL1	= 0x0F,
-	MAX14577_CHG_REG_CHG_CTRL2	= 0x10,
-	MAX14577_CHG_REG_CHG_CTRL3	= 0x11,
-	MAX14577_CHG_REG_CHG_CTRL4	= 0x12,
-	MAX14577_CHG_REG_CHG_CTRL5	= 0x13,
-	MAX14577_CHG_REG_CHG_CTRL6	= 0x14,
-	MAX14577_CHG_REG_CHG_CTRL7	= 0x15,
-
-	MAX14577_CHG_REG_END,
-};
-
-/* MAX14577 STATUS3 register */
-#define STATUS3_EOC_SHIFT		0
-#define STATUS3_CGMBC_SHIFT		1
-#define STATUS3_OVP_SHIFT		2
-#define STATUS3_MBCCHGERR_SHIFT		3
-#define STATUS3_EOC_MASK		(0x1 << STATUS3_EOC_SHIFT)
-#define STATUS3_CGMBC_MASK		(0x1 << STATUS3_CGMBC_SHIFT)
-#define STATUS3_OVP_MASK		(0x1 << STATUS3_OVP_SHIFT)
-#define STATUS3_MBCCHGERR_MASK		(0x1 << STATUS3_MBCCHGERR_SHIFT)
+#define MAXIM_CONTROL3_JIGSET_SHIFT	0
+#define MAXIM_CONTROL3_BOOTSET_SHIFT	2
+#define MAXIM_CONTROL3_ADCDBSET_SHIFT	4
+#define MAXIM_CONTROL3_JIGSET_MASK	(0x3 << MAXIM_CONTROL3_JIGSET_SHIFT)
+#define MAXIM_CONTROL3_BOOTSET_MASK	(0x3 << MAXIM_CONTROL3_BOOTSET_SHIFT)
+#define MAXIM_CONTROL3_ADCDBSET_MASK	(0x3 << MAXIM_CONTROL3_ADCDBSET_SHIFT)
 
 /* MAX14577 CDETCTRL1 register */
-#define CDETCTRL1_CHGDETEN_SHIFT	0
-#define CDETCTRL1_CHGTYPMAN_SHIFT	1
-#define CDETCTRL1_DCDEN_SHIFT		2
-#define CDETCTRL1_DCD2SCT_SHIFT		3
-#define CDETCTRL1_DCHKTM_SHIFT		4
-#define CDETCTRL1_DBEXIT_SHIFT		5
-#define CDETCTRL1_DBIDLE_SHIFT		6
-#define CDETCTRL1_CDPDET_SHIFT		7
-#define CDETCTRL1_CHGDETEN_MASK		(0x1 << CDETCTRL1_CHGDETEN_SHIFT)
-#define CDETCTRL1_CHGTYPMAN_MASK	(0x1 << CDETCTRL1_CHGTYPMAN_SHIFT)
-#define CDETCTRL1_DCDEN_MASK		(0x1 << CDETCTRL1_DCDEN_SHIFT)
-#define CDETCTRL1_DCD2SCT_MASK		(0x1 << CDETCTRL1_DCD2SCT_SHIFT)
-#define CDETCTRL1_DCHKTM_MASK		(0x1 << CDETCTRL1_DCHKTM_SHIFT)
-#define CDETCTRL1_DBEXIT_MASK		(0x1 << CDETCTRL1_DBEXIT_SHIFT)
-#define CDETCTRL1_DBIDLE_MASK		(0x1 << CDETCTRL1_DBIDLE_SHIFT)
-#define CDETCTRL1_CDPDET_MASK		(0x1 << CDETCTRL1_CDPDET_SHIFT)
-
-/* MAX14577 CHGCTRL1 register */
-#define CHGCTRL1_TCHW_SHIFT		4
-#define CHGCTRL1_TCHW_MASK		(0x7 << CHGCTRL1_TCHW_SHIFT)
-
-/* MAX14577 CHGCTRL2 register */
-#define CHGCTRL2_MBCHOSTEN_SHIFT	6
-#define CHGCTRL2_MBCHOSTEN_MASK		(0x1 << CHGCTRL2_MBCHOSTEN_SHIFT)
-#define CHGCTRL2_VCHGR_RC_SHIFT		7
-#define CHGCTRL2_VCHGR_RC_MASK		(0x1 << CHGCTRL2_VCHGR_RC_SHIFT)
-
-/* MAX14577 CHGCTRL3 register */
-#define CHGCTRL3_MBCCVWRC_SHIFT		0
-#define CHGCTRL3_MBCCVWRC_MASK		(0xf << CHGCTRL3_MBCCVWRC_SHIFT)
-
-/* MAX14577 CHGCTRL4 register */
-#define CHGCTRL4_MBCICHWRCH_SHIFT	0
-#define CHGCTRL4_MBCICHWRCH_MASK	(0xf << CHGCTRL4_MBCICHWRCH_SHIFT)
-#define CHGCTRL4_MBCICHWRCL_SHIFT	4
-#define CHGCTRL4_MBCICHWRCL_MASK	(0x1 << CHGCTRL4_MBCICHWRCL_SHIFT)
-
-/* MAX14577 CHGCTRL5 register */
-#define CHGCTRL5_EOCS_SHIFT		0
-#define CHGCTRL5_EOCS_MASK		(0xf << CHGCTRL5_EOCS_SHIFT)
-
-/* MAX14577 CHGCTRL6 register */
-#define CHGCTRL6_AUTOSTOP_SHIFT		5
-#define CHGCTRL6_AUTOSTOP_MASK		(0x1 << CHGCTRL6_AUTOSTOP_SHIFT)
-
-/* MAX14577 CHGCTRL7 register */
-#define CHGCTRL7_OTPCGHCVS_SHIFT	0
-#define CHGCTRL7_OTPCGHCVS_MASK		(0x3 << CHGCTRL7_OTPCGHCVS_SHIFT)
-
-/* MAX14577 regulator current limits (as in CHGCTRL4 register), uA */
+#define MAXIM_CDETCTRL1_CHGDETEN_SHIFT	0
+#define MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT	1
+#define MAXIM_CDETCTRL1_DCDEN_SHIFT	2
+#define MAXIM_CDETCTRL1_DCD2SCT_SHIFT	3
+#define MAXIM_CDETCTRL1_DCHKTM_SHIFT	4
+#define MAXIM_CDETCTRL1_DBEXIT_SHIFT	5
+#define MAXIM_CDETCTRL1_DBIDLE_SHIFT	6
+#define MAXIM_CDETCTRL1_CDPDET_SHIFT	7
+#define MAXIM_CDETCTRL1_CHGDETEN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGDETEN_SHIFT)
+#define MAXIM_CDETCTRL1_CHGTYPMAN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT)
+#define MAXIM_CDETCTRL1_DCDEN_MASK	(0x1 << MAXIM_CDETCTRL1_DCDEN_SHIFT)
+#define MAXIM_CDETCTRL1_DCD2SCT_MASK	(0x1 << MAXIM_CDETCTRL1_DCD2SCT_SHIFT)
+#define MAXIM_CDETCTRL1_DCHKTM_MASK	(0x1 << MAXIM_CDETCTRL1_DCHKTM_SHIFT)
+#define MAXIM_CDETCTRL1_DBEXIT_MASK	(0x1 << MAXIM_CDETCTRL1_DBEXIT_SHIFT)
+#define MAXIM_CDETCTRL1_DBIDLE_MASK	(0x1 << MAXIM_CDETCTRL1_DBIDLE_SHIFT)
+#define MAXIM_CDETCTRL1_CDPDET_MASK	(0x1 << MAXIM_CDETCTRL1_CDPDET_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL1 register */
+#define MAXIM_CHGCTRL1_TCHW_SHIFT	4
+#define MAXIM_CHGCTRL1_TCHW_MASK	(0x7 << MAXIM_CHGCTRL1_TCHW_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL2 register */
+#define MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT	6
+#define MAXIM_CHGCTRL2_MBCHOSTEN_MASK	(0x1 << MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT)
+#define MAXIM_CHGCTRL2_VCHGR_RC_SHIFT	7
+#define MAXIM_CHGCTRL2_VCHGR_RC_MASK	(0x1 << MAXIM_CHGCTRL2_VCHGR_RC_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL3 register */
+#define MAXIM_CHGCTRL3_MBCCVWRC_SHIFT	0
+#define MAXIM_CHGCTRL3_MBCCVWRC_MASK	(0xf << MAXIM_CHGCTRL3_MBCCVWRC_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL4 register */
+#define MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT	0
+#define MAXIM_CHGCTRL4_MBCICHWRCH_MASK	(0xf << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT)
+#define MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT	4
+#define MAXIM_CHGCTRL4_MBCICHWRCL_MASK	(0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL5 register */
+#define MAXIM_CHGCTRL5_EOCS_SHIFT	0
+#define MAXIM_CHGCTRL5_EOCS_MASK	(0xf << MAXIM_CHGCTRL5_EOCS_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL6 register */
+#define MAXIM_CHGCTRL6_AUTOSTOP_SHIFT	5
+#define MAXIM_CHGCTRL6_AUTOSTOP_MASK	(0x1 << MAXIM_CHGCTRL6_AUTOSTOP_SHIFT)
+
+/* MAX14577 MAXIM_CHGCTRL7 register */
+#define MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT	0
+#define MAXIM_CHGCTRL7_OTPCGHCVS_MASK	(0x3 << MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT)
+
+/* MAX14577 regulator current limits (as in MAXIM_CHGCTRL4 register), uA */
 #define MAX14577_REGULATOR_CURRENT_LIMIT_MIN		 90000
 #define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START	200000
 #define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 50000
@@ -248,26 +223,28 @@ enum max14577_charger_reg {
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
-enum max14577_irq {
+
+
+enum maxim_irq {
 	/* INT1 */
-	MAX14577_IRQ_INT1_ADC,
-	MAX14577_IRQ_INT1_ADCLOW,
-	MAX14577_IRQ_INT1_ADCERR,
+	MAXIM_IRQ_INT1_ADC,
+	MAXIM_IRQ_INT1_ADCLOW,
+	MAXIM_IRQ_INT1_ADCERR,
 
 	/* INT2 */
-	MAX14577_IRQ_INT2_CHGTYP,
-	MAX14577_IRQ_INT2_CHGDETRUN,
-	MAX14577_IRQ_INT2_DCDTMR,
-	MAX14577_IRQ_INT2_DBCHG,
-	MAX14577_IRQ_INT2_VBVOLT,
+	MAXIM_IRQ_INT2_CHGTYP,
+	MAXIM_IRQ_INT2_CHGDETRUN,
+	MAXIM_IRQ_INT2_DCDTMR,
+	MAXIM_IRQ_INT2_DBCHG,
+	MAXIM_IRQ_INT2_VBVOLT,
 
 	/* INT3 */
-	MAX14577_IRQ_INT3_EOC,
-	MAX14577_IRQ_INT3_CGMBC,
-	MAX14577_IRQ_INT3_OVP,
-	MAX14577_IRQ_INT3_MBCCHGERR,
+	MAXIM_IRQ_INT3_EOC,
+	MAXIM_IRQ_INT3_CGMBC,
+	MAXIM_IRQ_INT3_OVP,
+	MAXIM_IRQ_INT3_MBCCHGERR,
 
-	MAX14577_IRQ_NUM,
+	MAXIM_IRQ_NUM,
 };
 
 struct max14577 {
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 736d39c3ec0d..75301be5c548 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -32,7 +32,7 @@ enum max14577_regulators {
 	MAX14577_SAFEOUT = 0,
 	MAX14577_CHARGER,
 
-	MAX14577_REG_MAX,
+	MAX14577_REG_NUM,
 };
 
 struct max14577_regulator_platform_data {
-- 
1.7.9.5

