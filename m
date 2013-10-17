Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189Ab3JQCfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:35:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28130 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761786Ab3JQCfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:35:02 -0400
X-AuditID: cbfee690-b7fa36d00000744b-99-525f4cd4a910
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] fuelguage: max17042: Support regmap to access device's
 registers.
Date: Thu, 17 Oct 2013 11:34:54 +0900
Message-id: <1381977294-20129-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkQPeKT3yQwYe5ghYHt2paTFw5mdmi
	8+wTZovLu+awWdxuXMHmwOoxof8To8fmFVoefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXHz
	0T72gkOnGSsm7W5mbWA8vYqxi5GTQ0LARGJq80s2CFtM4sK99UA2F4eQwFJGiW1/fjDBFK1f
	v5EVIrGIUWLZrkdQThuTxNW3+1hBqtgEdCT+77vJDmKLCChIbO59BlbELLCAUeLgwn9gRcIC
	IRJL27rB9rEIqEpcONkO1sAr4CExc8Z9oHUcQOsUJOZMsgHplRB4zyYx8f0vqHoBiW+TD7FA
	1MhKbDrADHGdpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGJqn/z2b
	sIPx3gHrQ4zJQOMmMkuJJucDQzuvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYyyEQXVaxpsZVUMFryZdORL2EHNz49EGN/1NfEum7L5ElPU3Ph9
	epzrJbbV3NC4orbqAa/by7vcDZELRE7fkotn8z+p7JWj//G/+P4/Ndw3tZbeV/3d+838c/DH
	Ij/1ZScf7VtwSKFEfOUO1S0OeV7zf2rxTrHuPvbm4YI973sYFY13ewhkcPcosRRnJBpqMRcV
	JwIATGR7eGMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jAd0rPvFBBl1zmC0ObtW0mLhyMrNF
	59knzBaXd81hs7jduILNgdVjQv8nRo/NK7Q8+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8l
	My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj5qN97AWHTjNWTNrdzNrAeHoVYxcjJ4eEgInE+vUbWSFs
	MYkL99azdTFycQgJLGKUWLbrESuE08YkcfXtPrAqNgEdif/7brKD2CICChKbe5+BFTELLGCU
	OLjwH1iRsECIxNK2bjYQm0VAVeLCyXawBl4BD4mZM+4zdTFyAK1TkJgzyWYCI/cCRoZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGB/0x6B+OqBotDjAIcjEo8vDOWxwUJsSaWFVfmHmKU
	4GBWEuHdIREfJMSbklhZlVqUH19UmpNafIgxGWj5RGYp0eR8YFTmlcQbGpuYGVkamRtaGBmb
	kyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPj0t0rzTepXxFeuH+TPp9oY6mv0bGuf5PY
	HpXzpLHa6N35bLmh2WjuNI/nvwzmy1VcMzO0OtNSNEtQsI8r87s849dDk67+mMjL3jRj3ZW3
	ETPS107fWGUvafkk8J6O64WlBnxfso1OFeyanLSS1bGj85BhyIc9/5+nF1c46vptMdKXlny9
	5sEfJZbijERDLeai4kQAt+cTocACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes max17042 fuelguage driver uses regmap API to access
its device's registers.

It's based on linux-next.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/max17042_battery.c |  357 +++++++++++++++++++-------------------
 1 file changed, 174 insertions(+), 183 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d664ef5..0382cb5 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -33,6 +33,7 @@
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
 #include <linux/of.h>
+#include <linux/regmap.h>
 
 /* Status register bits */
 #define STATUS_POR_BIT         (1 << 1)
@@ -67,6 +68,7 @@
 
 struct max17042_chip {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct power_supply battery;
 	enum max170xx_chip_type chip_type;
 	struct max17042_platform_data *pdata;
@@ -74,35 +76,6 @@ struct max17042_chip {
 	int    init_complete;
 };
 
-static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
-{
-	int ret = i2c_smbus_write_word_data(client, reg, value);
-
-	if (ret < 0)
-		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
-
-	return ret;
-}
-
-static int max17042_read_reg(struct i2c_client *client, u8 reg)
-{
-	int ret = i2c_smbus_read_word_data(client, reg);
-
-	if (ret < 0)
-		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
-
-	return ret;
-}
-
-static void max17042_set_reg(struct i2c_client *client,
-			     struct max17042_reg_data *data, int size)
-{
-	int i;
-
-	for (i = 0; i < size; i++)
-		max17042_write_reg(client, data[i].addr, data[i].data);
-}
-
 static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
@@ -125,96 +98,98 @@ static int max17042_get_property(struct power_supply *psy,
 {
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
+	struct regmap *map = chip->regmap;
 	int ret;
+	u32 data;
 
 	if (!chip->init_complete)
 		return -EAGAIN;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
-		ret = max17042_read_reg(chip->client, MAX17042_STATUS);
+		ret = regmap_read(map, MAX17042_STATUS, &data);
 		if (ret < 0)
 			return ret;
 
-		if (ret & MAX17042_STATUS_BattAbsent)
+		if (data & MAX17042_STATUS_BattAbsent)
 			val->intval = 0;
 		else
 			val->intval = 1;
 		break;
 	case POWER_SUPPLY_PROP_CYCLE_COUNT:
-		ret = max17042_read_reg(chip->client, MAX17042_Cycles);
+		ret = regmap_read(map, MAX17042_Cycles, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret;
+		val->intval = data;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
-		ret = max17042_read_reg(chip->client, MAX17042_MinMaxVolt);
+		ret = regmap_read(map, MAX17042_MinMaxVolt, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret >> 8;
+		val->intval = data >> 8;
 		val->intval *= 20000; /* Units of LSB = 20mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
 		if (chip->chip_type == MAX17042)
-			ret = max17042_read_reg(chip->client, MAX17042_V_empty);
+			ret = regmap_read(map, MAX17042_V_empty, &data);
 		else
-			ret = max17042_read_reg(chip->client, MAX17047_V_empty);
+			ret = regmap_read(map, MAX17047_V_empty, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret >> 7;
+		val->intval = data >> 7;
 		val->intval *= 10000; /* Units of LSB = 10mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = max17042_read_reg(chip->client, MAX17042_VCELL);
+		ret = regmap_read(map, MAX17042_VCELL, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret * 625 / 8;
+		val->intval = data * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-		ret = max17042_read_reg(chip->client, MAX17042_AvgVCELL);
+		ret = regmap_read(map, MAX17042_AvgVCELL, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret * 625 / 8;
+		val->intval = data * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
-		ret = max17042_read_reg(chip->client, MAX17042_OCVInternal);
+		ret = regmap_read(map, MAX17042_OCVInternal, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret * 625 / 8;
+		val->intval = data * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
+		ret = regmap_read(map, MAX17042_RepSOC, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret >> 8;
+		val->intval = data >> 8;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		ret = max17042_read_reg(chip->client, MAX17042_FullCAP);
+		ret = regmap_read(map, MAX17042_FullCAP, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret * 1000 / 2;
+		val->intval = data * 1000 / 2;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
-		ret = max17042_read_reg(chip->client, MAX17042_QH);
+		ret = regmap_read(map, MAX17042_QH, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret * 1000 / 2;
+		val->intval = data * 1000 / 2;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		ret = max17042_read_reg(chip->client, MAX17042_TEMP);
+		ret = regmap_read(map, MAX17042_TEMP, &data);
 		if (ret < 0)
 			return ret;
 
-		val->intval = ret;
+		val->intval = data;
 		/* The value is signed. */
 		if (val->intval & 0x8000) {
 			val->intval = (0x7fff & ~val->intval) + 1;
@@ -226,11 +201,11 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		if (chip->pdata->enable_current_sense) {
-			ret = max17042_read_reg(chip->client, MAX17042_Current);
+			ret = regmap_read(map, MAX17042_Current, &data);
 			if (ret < 0)
 				return ret;
 
-			val->intval = ret;
+			val->intval = data;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
@@ -244,12 +219,11 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		if (chip->pdata->enable_current_sense) {
-			ret = max17042_read_reg(chip->client,
-						MAX17042_AvgCurrent);
+			ret = regmap_read(map, MAX17042_AvgCurrent, &data);
 			if (ret < 0)
 				return ret;
 
-			val->intval = ret;
+			val->intval = data;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
@@ -267,16 +241,15 @@ static int max17042_get_property(struct power_supply *psy,
 	return 0;
 }
 
-static int max17042_write_verify_reg(struct i2c_client *client,
-				u8 reg, u16 value)
+static int max17042_write_verify_reg(struct regmap *map, u8 reg, u32 value)
 {
 	int retries = 8;
 	int ret;
-	u16 read_value;
+	u32 read_value;
 
 	do {
-		ret = i2c_smbus_write_word_data(client, reg, value);
-		read_value =  max17042_read_reg(client, reg);
+		ret = regmap_write(map, reg, value);
+		regmap_read(map, reg, &read_value);
 		if (read_value != value) {
 			ret = -EIO;
 			retries--;
@@ -284,50 +257,51 @@ static int max17042_write_verify_reg(struct i2c_client *client,
 	} while (retries && read_value != value);
 
 	if (ret < 0)
-		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+		pr_err("%s: err %d\n", __func__, ret);
 
 	return ret;
 }
 
-static inline void max17042_override_por(
-	struct i2c_client *client, u8 reg, u16 value)
+static inline void max17042_override_por(struct regmap *map,
+					 u8 reg, u16 value)
 {
 	if (value)
-		max17042_write_reg(client, reg, value);
+		regmap_write(map, reg, value);
 }
 
 static inline void max10742_unlock_model(struct max17042_chip *chip)
 {
-	struct i2c_client *client = chip->client;
-	max17042_write_reg(client, MAX17042_MLOCKReg1, MODEL_UNLOCK1);
-	max17042_write_reg(client, MAX17042_MLOCKReg2, MODEL_UNLOCK2);
+	struct regmap *map = chip->regmap;
+	regmap_write(map, MAX17042_MLOCKReg1, MODEL_UNLOCK1);
+	regmap_write(map, MAX17042_MLOCKReg2, MODEL_UNLOCK2);
 }
 
 static inline void max10742_lock_model(struct max17042_chip *chip)
 {
-	struct i2c_client *client = chip->client;
-	max17042_write_reg(client, MAX17042_MLOCKReg1, MODEL_LOCK1);
-	max17042_write_reg(client, MAX17042_MLOCKReg2, MODEL_LOCK2);
+	struct regmap *map = chip->regmap;
+
+	regmap_write(map, MAX17042_MLOCKReg1, MODEL_LOCK1);
+	regmap_write(map, MAX17042_MLOCKReg2, MODEL_LOCK2);
 }
 
 static inline void max17042_write_model_data(struct max17042_chip *chip,
 					u8 addr, int size)
 {
-	struct i2c_client *client = chip->client;
+	struct regmap *map = chip->regmap;
 	int i;
 	for (i = 0; i < size; i++)
-		max17042_write_reg(client, addr + i,
-				chip->pdata->config_data->cell_char_tbl[i]);
+		regmap_write(map, addr + i,
+			chip->pdata->config_data->cell_char_tbl[i]);
 }
 
 static inline void max17042_read_model_data(struct max17042_chip *chip,
-					u8 addr, u16 *data, int size)
+					u8 addr, u32 *data, int size)
 {
-	struct i2c_client *client = chip->client;
+	struct regmap *map = chip->regmap;
 	int i;
 
 	for (i = 0; i < size; i++)
-		data[i] = max17042_read_reg(client, addr + i);
+		regmap_read(map, addr + i, &data[i]);
 }
 
 static inline int max17042_model_data_compare(struct max17042_chip *chip,
@@ -350,7 +324,7 @@ static int max17042_init_model(struct max17042_chip *chip)
 {
 	int ret;
 	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
-	u16 *temp_data;
+	u32 *temp_data;
 
 	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
 	if (!temp_data)
@@ -365,7 +339,7 @@ static int max17042_init_model(struct max17042_chip *chip)
 	ret = max17042_model_data_compare(
 		chip,
 		chip->pdata->config_data->cell_char_tbl,
-		temp_data,
+		(u16 *)temp_data,
 		table_size);
 
 	max10742_lock_model(chip);
@@ -378,7 +352,7 @@ static int max17042_verify_model_lock(struct max17042_chip *chip)
 {
 	int i;
 	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
-	u16 *temp_data;
+	u32 *temp_data;
 	int ret = 0;
 
 	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
@@ -398,40 +372,38 @@ static int max17042_verify_model_lock(struct max17042_chip *chip)
 static void max17042_write_config_regs(struct max17042_chip *chip)
 {
 	struct max17042_config_data *config = chip->pdata->config_data;
+	struct regmap *map = chip->regmap;
 
-	max17042_write_reg(chip->client, MAX17042_CONFIG, config->config);
-	max17042_write_reg(chip->client, MAX17042_LearnCFG, config->learn_cfg);
-	max17042_write_reg(chip->client, MAX17042_FilterCFG,
+	regmap_write(map, MAX17042_CONFIG, config->config);
+	regmap_write(map, MAX17042_LearnCFG, config->learn_cfg);
+	regmap_write(map, MAX17042_FilterCFG,
 			config->filter_cfg);
-	max17042_write_reg(chip->client, MAX17042_RelaxCFG, config->relax_cfg);
+	regmap_write(map, MAX17042_RelaxCFG, config->relax_cfg);
 	if (chip->chip_type == MAX17047)
-		max17042_write_reg(chip->client, MAX17047_FullSOCThr,
+		regmap_write(map, MAX17047_FullSOCThr,
 						config->full_soc_thresh);
 }
 
 static void  max17042_write_custom_regs(struct max17042_chip *chip)
 {
 	struct max17042_config_data *config = chip->pdata->config_data;
+	struct regmap *map = chip->regmap;
 
-	max17042_write_verify_reg(chip->client, MAX17042_RCOMP0,
-				config->rcomp0);
-	max17042_write_verify_reg(chip->client, MAX17042_TempCo,
-				config->tcompc0);
-	max17042_write_verify_reg(chip->client, MAX17042_ICHGTerm,
-				config->ichgt_term);
+	max17042_write_verify_reg(map, MAX17042_RCOMP0, config->rcomp0);
+	max17042_write_verify_reg(map, MAX17042_TempCo,	config->tcompc0);
+	max17042_write_verify_reg(map, MAX17042_ICHGTerm, config->ichgt_term);
 	if (chip->chip_type == MAX17042) {
-		max17042_write_reg(chip->client, MAX17042_EmptyTempCo,
-					config->empty_tempco);
-		max17042_write_verify_reg(chip->client, MAX17042_K_empty0,
+		regmap_write(map, MAX17042_EmptyTempCo,	config->empty_tempco);
+		max17042_write_verify_reg(map, MAX17042_K_empty0,
 					config->kempty0);
 	} else {
-		max17042_write_verify_reg(chip->client, MAX17047_QRTbl00,
+		max17042_write_verify_reg(map, MAX17047_QRTbl00,
 						config->qrtbl00);
-		max17042_write_verify_reg(chip->client, MAX17047_QRTbl10,
+		max17042_write_verify_reg(map, MAX17047_QRTbl10,
 						config->qrtbl10);
-		max17042_write_verify_reg(chip->client, MAX17047_QRTbl20,
+		max17042_write_verify_reg(map, MAX17047_QRTbl20,
 						config->qrtbl20);
-		max17042_write_verify_reg(chip->client, MAX17047_QRTbl30,
+		max17042_write_verify_reg(map, MAX17047_QRTbl30,
 						config->qrtbl30);
 	}
 }
@@ -439,58 +411,60 @@ static void  max17042_write_custom_regs(struct max17042_chip *chip)
 static void max17042_update_capacity_regs(struct max17042_chip *chip)
 {
 	struct max17042_config_data *config = chip->pdata->config_data;
+	struct regmap *map = chip->regmap;
 
-	max17042_write_verify_reg(chip->client, MAX17042_FullCAP,
+	max17042_write_verify_reg(map, MAX17042_FullCAP,
 				config->fullcap);
-	max17042_write_reg(chip->client, MAX17042_DesignCap,
-			config->design_cap);
-	max17042_write_verify_reg(chip->client, MAX17042_FullCAPNom,
+	regmap_write(map, MAX17042_DesignCap, config->design_cap);
+	max17042_write_verify_reg(map, MAX17042_FullCAPNom,
 				config->fullcapnom);
 }
 
 static void max17042_reset_vfsoc0_reg(struct max17042_chip *chip)
 {
-	u16 vfSoc;
+	unsigned int vfSoc;
+	struct regmap *map = chip->regmap;
 
-	vfSoc = max17042_read_reg(chip->client, MAX17042_VFSOC);
-	max17042_write_reg(chip->client, MAX17042_VFSOC0Enable, VFSOC0_UNLOCK);
-	max17042_write_verify_reg(chip->client, MAX17042_VFSOC0, vfSoc);
-	max17042_write_reg(chip->client, MAX17042_VFSOC0Enable, VFSOC0_LOCK);
+	regmap_read(map, MAX17042_VFSOC, &vfSoc);
+	regmap_write(map, MAX17042_VFSOC0Enable, VFSOC0_UNLOCK);
+	max17042_write_verify_reg(map, MAX17042_VFSOC0, vfSoc);
+	regmap_write(map, MAX17042_VFSOC0Enable, VFSOC0_LOCK);
 }
 
 static void max17042_load_new_capacity_params(struct max17042_chip *chip)
 {
-	u16 full_cap0, rep_cap, dq_acc, vfSoc;
+	u32 full_cap0, rep_cap, dq_acc, vfSoc;
 	u32 rem_cap;
 
 	struct max17042_config_data *config = chip->pdata->config_data;
+	struct regmap *map = chip->regmap;
 
-	full_cap0 = max17042_read_reg(chip->client, MAX17042_FullCAP0);
-	vfSoc = max17042_read_reg(chip->client, MAX17042_VFSOC);
+	regmap_read(map, MAX17042_FullCAP0, &full_cap0);
+	regmap_read(map, MAX17042_VFSOC, &vfSoc);
 
 	/* fg_vfSoc needs to shifted by 8 bits to get the
 	 * perc in 1% accuracy, to get the right rem_cap multiply
 	 * full_cap0, fg_vfSoc and devide by 100
 	 */
 	rem_cap = ((vfSoc >> 8) * full_cap0) / 100;
-	max17042_write_verify_reg(chip->client, MAX17042_RemCap, (u16)rem_cap);
+	max17042_write_verify_reg(map, MAX17042_RemCap, rem_cap);
 
-	rep_cap = (u16)rem_cap;
-	max17042_write_verify_reg(chip->client, MAX17042_RepCap, rep_cap);
+	rep_cap = rem_cap;
+	max17042_write_verify_reg(map, MAX17042_RepCap, rep_cap);
 
 	/* Write dQ_acc to 200% of Capacity and dP_acc to 200% */
 	dq_acc = config->fullcap / dQ_ACC_DIV;
-	max17042_write_verify_reg(chip->client, MAX17042_dQacc, dq_acc);
-	max17042_write_verify_reg(chip->client, MAX17042_dPacc, dP_ACC_200);
+	max17042_write_verify_reg(map, MAX17042_dQacc, dq_acc);
+	max17042_write_verify_reg(map, MAX17042_dPacc, dP_ACC_200);
 
-	max17042_write_verify_reg(chip->client, MAX17042_FullCAP,
+	max17042_write_verify_reg(map, MAX17042_FullCAP,
 			config->fullcap);
-	max17042_write_reg(chip->client, MAX17042_DesignCap,
+	regmap_write(map, MAX17042_DesignCap,
 			config->design_cap);
-	max17042_write_verify_reg(chip->client, MAX17042_FullCAPNom,
+	max17042_write_verify_reg(map, MAX17042_FullCAPNom,
 			config->fullcapnom);
 	/* Update SOC register with new SOC */
-	max17042_write_reg(chip->client, MAX17042_RepSOC, vfSoc);
+	regmap_write(map, MAX17042_RepSOC, vfSoc);
 }
 
 /*
@@ -500,59 +474,60 @@ static void max17042_load_new_capacity_params(struct max17042_chip *chip)
  */
 static inline void max17042_override_por_values(struct max17042_chip *chip)
 {
-	struct i2c_client *client = chip->client;
+	struct regmap *map = chip->regmap;
 	struct max17042_config_data *config = chip->pdata->config_data;
 
-	max17042_override_por(client, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(client, MAx17042_TOFF, config->toff);
-	max17042_override_por(client, MAX17042_CGAIN, config->cgain);
-	max17042_override_por(client, MAX17042_COFF, config->coff);
-
-	max17042_override_por(client, MAX17042_VALRT_Th, config->valrt_thresh);
-	max17042_override_por(client, MAX17042_TALRT_Th, config->talrt_thresh);
-	max17042_override_por(client, MAX17042_SALRT_Th,
-			config->soc_alrt_thresh);
-	max17042_override_por(client, MAX17042_CONFIG, config->config);
-	max17042_override_por(client, MAX17042_SHDNTIMER, config->shdntimer);
-
-	max17042_override_por(client, MAX17042_DesignCap, config->design_cap);
-	max17042_override_por(client, MAX17042_ICHGTerm, config->ichgt_term);
-
-	max17042_override_por(client, MAX17042_AtRate, config->at_rate);
-	max17042_override_por(client, MAX17042_LearnCFG, config->learn_cfg);
-	max17042_override_por(client, MAX17042_FilterCFG, config->filter_cfg);
-	max17042_override_por(client, MAX17042_RelaxCFG, config->relax_cfg);
-	max17042_override_por(client, MAX17042_MiscCFG, config->misc_cfg);
-	max17042_override_por(client, MAX17042_MaskSOC, config->masksoc);
-
-	max17042_override_por(client, MAX17042_FullCAP, config->fullcap);
-	max17042_override_por(client, MAX17042_FullCAPNom, config->fullcapnom);
+	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
+	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
+	max17042_override_por(map, MAX17042_COFF, config->coff);
+
+	max17042_override_por(map, MAX17042_VALRT_Th, config->valrt_thresh);
+	max17042_override_por(map, MAX17042_TALRT_Th, config->talrt_thresh);
+	max17042_override_por(map, MAX17042_SALRT_Th,
+						config->soc_alrt_thresh);
+	max17042_override_por(map, MAX17042_CONFIG, config->config);
+	max17042_override_por(map, MAX17042_SHDNTIMER, config->shdntimer);
+
+	max17042_override_por(map, MAX17042_DesignCap, config->design_cap);
+	max17042_override_por(map, MAX17042_ICHGTerm, config->ichgt_term);
+
+	max17042_override_por(map, MAX17042_AtRate, config->at_rate);
+	max17042_override_por(map, MAX17042_LearnCFG, config->learn_cfg);
+	max17042_override_por(map, MAX17042_FilterCFG, config->filter_cfg);
+	max17042_override_por(map, MAX17042_RelaxCFG, config->relax_cfg);
+	max17042_override_por(map, MAX17042_MiscCFG, config->misc_cfg);
+	max17042_override_por(map, MAX17042_MaskSOC, config->masksoc);
+
+	max17042_override_por(map, MAX17042_FullCAP, config->fullcap);
+	max17042_override_por(map, MAX17042_FullCAPNom, config->fullcapnom);
 	if (chip->chip_type == MAX17042)
-		max17042_override_por(client, MAX17042_SOC_empty,
+		max17042_override_por(map, MAX17042_SOC_empty,
 						config->socempty);
-	max17042_override_por(client, MAX17042_LAvg_empty, config->lavg_empty);
-	max17042_override_por(client, MAX17042_dQacc, config->dqacc);
-	max17042_override_por(client, MAX17042_dPacc, config->dpacc);
+	max17042_override_por(map, MAX17042_LAvg_empty, config->lavg_empty);
+	max17042_override_por(map, MAX17042_dQacc, config->dqacc);
+	max17042_override_por(map, MAX17042_dPacc, config->dpacc);
 
 	if (chip->chip_type == MAX17042)
-		max17042_override_por(client, MAX17042_V_empty, config->vempty);
+		max17042_override_por(map, MAX17042_V_empty, config->vempty);
 	else
-		max17042_override_por(client, MAX17047_V_empty, config->vempty);
-	max17042_override_por(client, MAX17042_TempNom, config->temp_nom);
-	max17042_override_por(client, MAX17042_TempLim, config->temp_lim);
-	max17042_override_por(client, MAX17042_FCTC, config->fctc);
-	max17042_override_por(client, MAX17042_RCOMP0, config->rcomp0);
-	max17042_override_por(client, MAX17042_TempCo, config->tcompc0);
+		max17042_override_por(map, MAX17047_V_empty, config->vempty);
+	max17042_override_por(map, MAX17042_TempNom, config->temp_nom);
+	max17042_override_por(map, MAX17042_TempLim, config->temp_lim);
+	max17042_override_por(map, MAX17042_FCTC, config->fctc);
+	max17042_override_por(map, MAX17042_RCOMP0, config->rcomp0);
+	max17042_override_por(map, MAX17042_TempCo, config->tcompc0);
 	if (chip->chip_type) {
-		max17042_override_por(client, MAX17042_EmptyTempCo,
-					config->empty_tempco);
-		max17042_override_por(client, MAX17042_K_empty0,
-					config->kempty0);
+		max17042_override_por(map, MAX17042_EmptyTempCo,
+						config->empty_tempco);
+		max17042_override_por(map, MAX17042_K_empty0,
+						config->kempty0);
 	}
 }
 
 static int max17042_init_chip(struct max17042_chip *chip)
 {
+	struct regmap *map = chip->regmap;
 	int ret;
 	int val;
 
@@ -597,31 +572,32 @@ static int max17042_init_chip(struct max17042_chip *chip)
 	max17042_load_new_capacity_params(chip);
 
 	/* Init complete, Clear the POR bit */
-	val = max17042_read_reg(chip->client, MAX17042_STATUS);
-	max17042_write_reg(chip->client, MAX17042_STATUS,
-			val & (~STATUS_POR_BIT));
+	regmap_read(map, MAX17042_STATUS, &val);
+	regmap_write(map, MAX17042_STATUS, val & (~STATUS_POR_BIT));
 	return 0;
 }
 
 static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
 {
-	u16 soc, soc_tr;
+	struct regmap *map = chip->regmap;
+	u32 soc, soc_tr;
 
 	/* program interrupt thesholds such that we should
 	 * get interrupt for every 'off' perc change in the soc
 	 */
-	soc = max17042_read_reg(chip->client, MAX17042_RepSOC) >> 8;
+	regmap_read(map, MAX17042_RepSOC, &soc);
+	soc >>= 8;
 	soc_tr = (soc + off) << 8;
 	soc_tr |= (soc - off);
-	max17042_write_reg(chip->client, MAX17042_SALRT_Th, soc_tr);
+	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 
 static irqreturn_t max17042_thread_handler(int id, void *dev)
 {
 	struct max17042_chip *chip = dev;
-	u16 val;
+	u32 val;
 
-	val = max17042_read_reg(chip->client, MAX17042_STATUS);
+	regmap_read(chip->regmap, MAX17042_STATUS, &val);
 	if ((val & STATUS_INTR_SOCMIN_BIT) ||
 		(val & STATUS_INTR_SOCMAX_BIT)) {
 		dev_info(&chip->client->dev, "SOC threshold INTR\n");
@@ -682,13 +658,20 @@ max17042_get_pdata(struct device *dev)
 }
 #endif
 
+static struct regmap_config max17042_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 16,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
 static int max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct max17042_chip *chip;
 	int ret;
-	int reg;
+	int i;
+	u32 val;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EIO;
@@ -698,6 +681,12 @@ static int max17042_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
+	chip->regmap = devm_regmap_init_i2c(client, &max17042_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		dev_err(&client->dev, "Failed to initialize regmap\n");
+		return -EINVAL;
+	}
+
 	chip->pdata = max17042_get_pdata(&client->dev);
 	if (!chip->pdata) {
 		dev_err(&client->dev, "no platform data provided\n");
@@ -706,15 +695,15 @@ static int max17042_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, chip);
 
-	ret = max17042_read_reg(chip->client, MAX17042_DevName);
-	if (ret == MAX17042_IC_VERSION) {
+	regmap_read(chip->regmap, MAX17042_DevName, &val);
+	if (val == MAX17042_IC_VERSION) {
 		dev_dbg(&client->dev, "chip type max17042 detected\n");
 		chip->chip_type = MAX17042;
-	} else if (ret == MAX17047_IC_VERSION) {
+	} else if (val == MAX17047_IC_VERSION) {
 		dev_dbg(&client->dev, "chip type max17047/50 detected\n");
 		chip->chip_type = MAX17047;
 	} else {
-		dev_err(&client->dev, "device version mismatch: %x\n", ret);
+		dev_err(&client->dev, "device version mismatch: %x\n", val);
 		return -EIO;
 	}
 
@@ -733,13 +722,15 @@ static int max17042_probe(struct i2c_client *client,
 		chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
 
 	if (chip->pdata->init_data)
-		max17042_set_reg(client, chip->pdata->init_data,
-				chip->pdata->num_init_data);
+		for (i = 0; i < chip->pdata->num_init_data; i++)
+			regmap_write(chip->regmap,
+					chip->pdata->init_data[i].addr,
+					chip->pdata->init_data[i].data);
 
 	if (!chip->pdata->enable_current_sense) {
-		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
-		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
-		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
+		regmap_write(chip->regmap, MAX17042_CGAIN, 0x0000);
+		regmap_write(chip->regmap, MAX17042_MiscCFG, 0x0003);
+		regmap_write(chip->regmap, MAX17042_LearnCFG, 0x0007);
 	}
 
 	ret = power_supply_register(&client->dev, &chip->battery);
@@ -754,9 +745,9 @@ static int max17042_probe(struct i2c_client *client,
 						IRQF_TRIGGER_FALLING,
 						chip->battery.name, chip);
 		if (!ret) {
-			reg =  max17042_read_reg(client, MAX17042_CONFIG);
-			reg |= CONFIG_ALRT_BIT_ENBL;
-			max17042_write_reg(client, MAX17042_CONFIG, reg);
+			regmap_read(chip->regmap, MAX17042_CONFIG, &val);
+			val |= CONFIG_ALRT_BIT_ENBL;
+			regmap_write(chip->regmap, MAX17042_CONFIG, val);
 			max17042_set_soc_threshold(chip, 1);
 		} else {
 			client->irq = 0;
@@ -765,8 +756,8 @@ static int max17042_probe(struct i2c_client *client,
 		}
 	}
 
-	reg = max17042_read_reg(chip->client, MAX17042_STATUS);
-	if (reg & STATUS_POR_BIT) {
+	regmap_read(chip->regmap, MAX17042_STATUS, &val);
+	if (val & STATUS_POR_BIT) {
 		INIT_WORK(&chip->work, max17042_init_worker);
 		schedule_work(&chip->work);
 	} else {
-- 
1.7.9.5

