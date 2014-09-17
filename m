Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaIQCrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:47:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8837 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaIQCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:47:31 -0400
X-AuditID: cbfee690-f79ce6d00000115a-13-5418f6428e5f
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 2/2] power: smb347-charger: Support Summit SMB358 charger IC.
Date: Wed, 17 Sep 2014 11:47:24 +0900
Message-id: <1410922044-4170-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkWNfpm0SIwfZ/AhYHt2paTHryntli
	4srJzBadZ58wW1zeNYfN4nPvEUaLu6eOslmc3l3iwOExof8To8fOWXfZPTav0PLYtKqTzaNv
	yypGjxWrv7N7fN4kF8AexWWTkpqTWZZapG+XwJUxaeIl1oJ11hUH5u9lamC8q9/FyMkhIWAi
	8XPbWlYIW0ziwr31bF2MXBxCAksZJaY37mCCKfrU2M8KkVjEKPHo5HV2CKeNSWLqvdvsIFVs
	AjoS//fdBLNFBBQkNvc+A+tgFljMKPH01AtmkISwgK/EwmltbCA2i4CqxPbdz8FW8Aq4S/TN
	uMLSxcgBtE5BYs4kG5Awp4CHxLXZMxlBbCGgkpV/NjJCXLSJXWLxkwyIMQIS3yYfgmqVldh0
	gBmiRFLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAz/0/+eTdjBeO+A
	9SFGAQ5GJR7eDZclQoRYE8uKK3MPMZoCbZjILCWanA+MsrySeENjMyMLUxNTYyNzSzMlcd7X
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAuPM4x44zkmUedt3bySHvVL3E27AifLlic
	8UdTef3k8+evPLlw4KZmwt8TX1tuN++6Xy+yu/jMkpdCZSwHP69KLmJ1Zc64EXPMLEa0P+aN
	4j/Gg4tmLN9itYix1++Je3CDwqnL4huDJJsWfJJYuc972vs97Pszr1+sEPdmTFbLeHHPWWdD
	1iIbJZbijERDLeai4kQABi0DFHoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAV2nbxIhBq0f2C0ObtW0mPTkPbPF
	xJWTmS06zz5htri8aw6bxefeI4wWd08dZbM4vbvEgcNjQv8nRo+ds+6ye2xeoeWxaVUnm0ff
	llWMHitWf2f3+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqSJ
	l1gL1llXHJi/l6mB8a5+FyMnh4SAicSnxn5WCFtM4sK99WxdjFwcQgKLGCUenbzODuG0MUlM
	vXebHaSKTUBH4v++m2C2iICCxObeZ6wgRcwCixklnp56wQySEBbwlVg4rY0NxGYRUJXYvvs5
	E4jNK+Au0TfjCksXIwfQOgWJOZNsQMKcAh4S12bPZASxhYBKVv7ZyDiBkXcBI8MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOD4eia9g3FVg8UhRgEORiUe3g2XJUKEWBPLiitzDzFKcDAr
	ifCK3AMK8aYkVlalFuXHF5XmpBYfYjQFOmois5Rocj4w9vNK4g2NTcyMLI3MDS2MjM2VxHkP
	tloHCgmkJ5akZqemFqQWwfQxcXBKNTDmff39mIuhPU3kjwiD5EW2azItPidclk0tOBrKXZf5
	8dehy5z+y86FqT7eV3l5+9sDB6+utnLLTjBZtOvG1ePC8UZ704xebRbouiJqX7ZNbeOy6q0T
	t/0605Eoc/77jqrfp+8Gz5w9sUjuziulXwkHUn64GP++zPhB/upN31j7qLy7qjml506/V2Ip
	zkg01GIuKk4EAH00YWfFAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summit microelectronics' SMB358 charger chip has almost same register map
and functionality with SMB347. The voltage and current table are only differed.
Thus, SMB347 driver can support SMB358 chip fully with few modifications.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by : Chanwoo Choi <cw00.choi@samsung.com>
Acked-by : Myungjoo Ham <myungjoo.ham@samsung.com>
---
 .../bindings/power_supply/smb347_charger.txt       |    1 +
 drivers/power/smb347-charger.c                     |   98 +++++++++-----------
 2 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/Documentation/devicetree/bindings/power_supply/smb347_charger.txt b/Documentation/devicetree/bindings/power_supply/smb347_charger.txt
index 91570a5..776ae29 100644
--- a/Documentation/devicetree/bindings/power_supply/smb347_charger.txt
+++ b/Documentation/devicetree/bindings/power_supply/smb347_charger.txt
@@ -3,6 +3,7 @@ smb347_charger bindings
 
 [Required porperties]
 - compatible : "summit,smb347"
+	       "summit,smb358"
 - reg : Slave address for i2c interface
 # At least one of followings should be set
   - enable-usb-charging
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 8073879..1bfb115 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -136,6 +136,7 @@
  * @pdata: pointer to platform data
  */
 struct smb347_charger {
+	int			id;
 	struct mutex		lock;
 	struct device		*dev;
 	struct regmap		*regmap;
@@ -148,58 +149,46 @@ struct smb347_charger {
 	const struct smb347_charger_platform_data *pdata;
 };
 
+enum smb_charger_chipid {
+	SMB347,
+	SMB358,
+	NUM_CHIP_TYPES,
+};
+
 /* Fast charge current in uA */
-static const unsigned int fcc_tbl[] = {
-	700000,
-	900000,
-	1200000,
-	1500000,
-	1800000,
-	2000000,
-	2200000,
-	2500000,
+static const unsigned int fcc_tbl[NUM_CHIP_TYPES][8] = {
+	[SMB347] = { 700000, 900000, 1200000, 1500000,
+			1800000, 2000000, 2200000, 2500000 },
+	[SMB358] = { 200000, 450000, 600000, 900000,
+			1300000, 1500000, 1800000, 2000000 },
 };
 
 /* Pre-charge current in uA */
-static const unsigned int pcc_tbl[] = {
-	100000,
-	150000,
-	200000,
-	250000,
+static const unsigned int pcc_tbl[NUM_CHIP_TYPES][4] = {
+	[SMB347] = { 100000, 150000, 200000, 250000 },
+	[SMB358] = { 150000, 250000, 350000, 450000 },
 };
 
 /* Termination current in uA */
-static const unsigned int tc_tbl[] = {
-	37500,
-	50000,
-	100000,
-	150000,
-	200000,
-	250000,
-	500000,
-	600000,
+static const unsigned int tc_tbl[NUM_CHIP_TYPES][8] = {
+	[SMB347] = { 37500, 50000, 100000, 150000,
+			200000, 250000, 500000, 600000 },
+	[SMB358] = { 30000, 40000, 60000, 80000,
+			100000, 125000, 150000, 200000 },
 };
 
 /* Input current limit in uA */
-static const unsigned int icl_tbl[] = {
-	300000,
-	500000,
-	700000,
-	900000,
-	1200000,
-	1500000,
-	1800000,
-	2000000,
-	2200000,
-	2500000,
+static const unsigned int icl_tbl[NUM_CHIP_TYPES][10] = {
+	[SMB347] = { 300000, 500000, 700000, 900000, 1200000,
+			1500000, 1800000, 2000000, 2200000, 2500000 },
+	[SMB358] = { 300000, 500000, 700000, 1000000, 1500000,
+			1800000, 2000000, 2000000, 2000000, 2000000 },
 };
 
 /* Charge current compensation in uA */
-static const unsigned int ccc_tbl[] = {
-	250000,
-	700000,
-	900000,
-	1200000,
+static const unsigned int ccc_tbl[NUM_CHIP_TYPES][4] = {
+	[SMB347] = { 250000, 700000, 900000, 1200000 },
+	[SMB358] = { 200000, 450000, 600000, 900000 },
 };
 
 /* Convert register value to current using lookup table */
@@ -354,10 +343,10 @@ static int smb347_start_stop_charging(struct smb347_charger *smb)
 
 static int smb347_set_charge_current(struct smb347_charger *smb)
 {
-	int ret;
+	int ret, id = smb->id;
 
 	if (smb->pdata->max_charge_current) {
-		ret = current_to_hw(fcc_tbl, ARRAY_SIZE(fcc_tbl),
+		ret = current_to_hw(fcc_tbl[id], ARRAY_SIZE(fcc_tbl[id]),
 				    smb->pdata->max_charge_current);
 		if (ret < 0)
 			return ret;
@@ -370,7 +359,7 @@ static int smb347_set_charge_current(struct smb347_charger *smb)
 	}
 
 	if (smb->pdata->pre_charge_current) {
-		ret = current_to_hw(pcc_tbl, ARRAY_SIZE(pcc_tbl),
+		ret = current_to_hw(pcc_tbl[id], ARRAY_SIZE(pcc_tbl[id]),
 				    smb->pdata->pre_charge_current);
 		if (ret < 0)
 			return ret;
@@ -383,7 +372,7 @@ static int smb347_set_charge_current(struct smb347_charger *smb)
 	}
 
 	if (smb->pdata->termination_current) {
-		ret = current_to_hw(tc_tbl, ARRAY_SIZE(tc_tbl),
+		ret = current_to_hw(tc_tbl[id], ARRAY_SIZE(tc_tbl[id]),
 				    smb->pdata->termination_current);
 		if (ret < 0)
 			return ret;
@@ -399,10 +388,10 @@ static int smb347_set_charge_current(struct smb347_charger *smb)
 
 static int smb347_set_current_limits(struct smb347_charger *smb)
 {
-	int ret;
+	int ret, id = smb->id;
 
 	if (smb->pdata->mains_current_limit) {
-		ret = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+		ret = current_to_hw(icl_tbl[id], ARRAY_SIZE(icl_tbl[id]),
 				    smb->pdata->mains_current_limit);
 		if (ret < 0)
 			return ret;
@@ -415,7 +404,7 @@ static int smb347_set_current_limits(struct smb347_charger *smb)
 	}
 
 	if (smb->pdata->usb_hc_current_limit) {
-		ret = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+		ret = current_to_hw(icl_tbl[id], ARRAY_SIZE(icl_tbl[id]),
 				    smb->pdata->usb_hc_current_limit);
 		if (ret < 0)
 			return ret;
@@ -467,7 +456,7 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 {
 	bool enable_therm_monitor = false;
 	int ret = 0;
-	int val;
+	int val, id = smb->id;
 
 	if (smb->pdata->chip_temp_threshold) {
 		val = smb->pdata->chip_temp_threshold;
@@ -589,7 +578,7 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 	}
 
 	if (smb->pdata->charge_current_compensation) {
-		val = current_to_hw(ccc_tbl, ARRAY_SIZE(ccc_tbl),
+		val = current_to_hw(ccc_tbl[id], ARRAY_SIZE(ccc_tbl[id]),
 				    smb->pdata->charge_current_compensation);
 		if (val < 0)
 			return val;
@@ -879,7 +868,7 @@ out:
  */
 static int get_const_charge_current(struct smb347_charger *smb)
 {
-	int ret, intval;
+	int ret, intval, id = smb->id;
 	unsigned int v;
 
 	if (!smb347_is_ps_online(smb))
@@ -894,10 +883,12 @@ static int get_const_charge_current(struct smb347_charger *smb)
 	 * and we can detect which table to use from bit 5.
 	 */
 	if (v & 0x20) {
-		intval = hw_to_current(fcc_tbl, ARRAY_SIZE(fcc_tbl), v & 7);
+		intval = hw_to_current(fcc_tbl[id],
+					ARRAY_SIZE(fcc_tbl[id]), v & 7);
 	} else {
 		v >>= 3;
-		intval = hw_to_current(pcc_tbl, ARRAY_SIZE(pcc_tbl), v & 7);
+		intval = hw_to_current(pcc_tbl[id],
+					ARRAY_SIZE(pcc_tbl[id]), v & 7);
 	}
 
 	return intval;
@@ -1282,6 +1273,7 @@ static int smb347_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, smb);
 
 	mutex_init(&smb->lock);
+	smb->id = id->driver_data;
 	smb->dev = &client->dev;
 
 	smb->regmap = devm_regmap_init_i2c(client, &smb347_regmap);
@@ -1369,7 +1361,8 @@ static int smb347_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id smb347_id[] = {
-	{ "smb347", 0 },
+	{ "smb347", SMB347 },
+	{ "smb358", SMB358 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, smb347_id);
@@ -1377,6 +1370,7 @@ MODULE_DEVICE_TABLE(i2c, smb347_id);
 #ifdef CONFIG_OF
 static struct of_device_id of_smb347_ids[] = {
 	{ .compatible = "summit,smb347" },
+	{ .compatible = "summit,smb358" },
 	{},
 };
 #endif
-- 
1.7.9.5

