Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3FXMkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:40:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17676 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3FXMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:40:07 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-33-51c83e24037a
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 2/3] regulator: max8998: Use arrays for specifying voltages
 in platform data
Date: Mon, 24 Jun 2013 14:39:53 +0200
Message-id: <1372077594-17052-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
In-reply-to: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7oqdicCDabfZLJYcvEqu8XUh0/Y
	LA782cFosXvOYhaL3gVX2Sy+Xelgstj0+BqrxeVdc9gsZpzfx2Rx+zKvxeNZ89gsDq84wGSx
	7uV0Fov9nR2MFqe7WS0uzbjObrF+xmsWB0GPluYeNo8Fn6+we+ycdZfdY8/Ek2wem1Z1snm8
	Wj2T1ePOtT1sHvNOBnpsXlLvcaEr26NvyypGjzMLjrB7TJ/3k8nj8ya5AL4oLpuU1JzMstQi
	fbsErowre68wFzy0r/i25htrA+M1oy5GTg4JAROJ+x0fWCFsMYkL99azdTFycQgJLGWUePiq
	jRnC6WOS2DD5CAtIFZuAmsTnhkdsILaIgILE5t5nrCBFzAI3WCQ6DjezgySEBRIlJh8+zQRi
	swioSqxa9ByogYODV8BJ4vWpaohtChLHt29jBLE5BZwlHvyYygxiCwGVPLrXyziBkXcBI8Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBY+LKDcfExq0OMAhyMSjy8Py2PBwqxJpYVV+Ye
	YpTgYFYS4Q0VOREoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXHjCzmTVKUYhXte1Q18t04rXgpy
	erDYWaajXbqrxnCPONOFztnW7n/3Czb+slz13uDB5OonynoJXTc2XTu3rLbJ4XT8icuuoW9k
	DeomNNbvPzD14/KgsvtzdBd9CHxxJfJLlFkjK+9kb8PjJq8Oe3s0/1m43O5J9vZjwprdrG+u
	ea8q4j/6V0iJpTgj0VCLuag4EQCrabKNYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the platform data of max8998 to use arrays for
specifying predefined voltages of buck1 and buck2 instead of separate
field for each voltage.

This allows to simplify the code a bit and will help in adding support
for Device Tree, which will be introduced in further patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/mach-universal_c210.c |  8 +--
 arch/arm/mach-s5pv210/mach-aquila.c        |  8 +--
 arch/arm/mach-s5pv210/mach-goni.c          |  8 +--
 drivers/regulator/max8998.c                | 96 +++++++++---------------------
 include/linux/mfd/max8998.h                | 16 ++---
 5 files changed, 39 insertions(+), 97 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 74ddb2b5..f912444 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -540,15 +540,11 @@ static struct max8998_regulator_data lp3974_regulators[] = {
 static struct max8998_platform_data universal_lp3974_pdata = {
 	.num_regulators		= ARRAY_SIZE(lp3974_regulators),
 	.regulators		= lp3974_regulators,
-	.buck1_voltage1		= 1100000,	/* INT */
-	.buck1_voltage2		= 1000000,
-	.buck1_voltage3		= 1100000,
-	.buck1_voltage4		= 1000000,
+	.buck1_voltage		= { 1100000, 1000000, 1100000, 1000000 },
 	.buck1_set1		= EXYNOS4_GPX0(5),
 	.buck1_set2		= EXYNOS4_GPX0(6),
-	.buck2_voltage1		= 1200000,	/* G3D */
-	.buck2_voltage2		= 1100000,
 	.buck1_default_idx	= 0,
+	.buck2_voltage		= { 1200000, 1100000 },
 	.buck2_set3		= EXYNOS4_GPE2(0),
 	.buck2_default_idx	= 0,
 	.wakeup			= true,
diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index ed2b854..ad40ab0 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -377,12 +377,8 @@ static struct max8998_platform_data aquila_max8998_pdata = {
 	.buck1_set1	= S5PV210_GPH0(3),
 	.buck1_set2	= S5PV210_GPH0(4),
 	.buck2_set3	= S5PV210_GPH0(5),
-	.buck1_voltage1	= 1200000,
-	.buck1_voltage2	= 1200000,
-	.buck1_voltage3	= 1200000,
-	.buck1_voltage4	= 1200000,
-	.buck2_voltage1	= 1200000,
-	.buck2_voltage2	= 1200000,
+	.buck1_voltage	= { 1200000, 1200000, 1200000, 1200000 },
+	.buck2_voltage	= { 1200000, 1200000 },
 };
 #endif
 
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 30b24ad..e5cd9fb 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -580,12 +580,8 @@ static struct max8998_platform_data goni_max8998_pdata = {
 	.buck1_set1	= S5PV210_GPH0(3),
 	.buck1_set2	= S5PV210_GPH0(4),
 	.buck2_set3	= S5PV210_GPH0(5),
-	.buck1_voltage1	= 1200000,
-	.buck1_voltage2	= 1200000,
-	.buck1_voltage3	= 1200000,
-	.buck1_voltage4	= 1200000,
-	.buck2_voltage1	= 1200000,
-	.buck2_voltage2	= 1200000,
+	.buck1_voltage	= { 1200000, 1200000, 1200000, 1200000 },
+	.buck2_voltage	= { 1200000, 1200000 },
 };
 #endif
 
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index a57a1b1..8c45b93 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -630,6 +630,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 	struct max8998_data *max8998;
 	struct i2c_client *i2c;
 	int i, ret, size;
+	unsigned int v;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "No platform init data supplied\n");
@@ -688,53 +689,21 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		gpio_request(pdata->buck1_set2, "MAX8998 BUCK1_SET2");
 		gpio_direction_output(pdata->buck1_set2,
 				      (max8998->buck1_idx >> 1) & 0x1);
-		/* Set predefined value for BUCK1 register 1 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck1_voltage1)
-			i++;
-		max8998->buck1_vol[0] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
-		if (ret)
-			goto err_out;
-
-		/* Set predefined value for BUCK1 register 2 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck1_voltage2)
-			i++;
-
-		max8998->buck1_vol[1] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i);
-		if (ret)
-			goto err_out;
-
-		/* Set predefined value for BUCK1 register 3 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck1_voltage3)
-			i++;
-
-		max8998->buck1_vol[2] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE3, i);
-		if (ret)
-			goto err_out;
-
-		/* Set predefined value for BUCK1 register 4 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck1_voltage4)
-			i++;
-
-		max8998->buck1_vol[3] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE4, i);
-		if (ret)
-			goto err_out;
 
+		/* Set predefined values for BUCK1 registers */
+		for (v = 0; v < ARRAY_SIZE(pdata->buck1_voltage); ++v) {
+			i = 0;
+			while (buck12_voltage_map_desc.min +
+			       buck12_voltage_map_desc.step*i
+			       < pdata->buck1_voltage[v])
+				i++;
+
+			max8998->buck1_vol[v] = i;
+			ret = max8998_write_reg(i2c,
+					MAX8998_REG_BUCK1_VOLTAGE1 + v, i);
+			if (ret)
+				goto err_out;
+		}
 	}
 
 	if (gpio_is_valid(pdata->buck2_set3)) {
@@ -750,27 +719,20 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		gpio_direction_output(pdata->buck2_set3,
 				      max8998->buck2_idx & 0x1);
 
-		/* BUCK2 register 1 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck2_voltage1)
-			i++;
-		max8998->buck2_vol[0] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
-		if (ret)
-			goto err_out;
-
-		/* BUCK2 register 2 */
-		i = 0;
-		while (buck12_voltage_map_desc.min +
-		       buck12_voltage_map_desc.step*i
-		       < pdata->buck2_voltage2)
-			i++;
-		max8998->buck2_vol[1] = i;
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
-		if (ret)
-			goto err_out;
+		/* Set predefined values for BUCK2 registers */
+		for (v = 0; v < ARRAY_SIZE(pdata->buck2_voltage); ++v) {
+			i = 0;
+			while (buck12_voltage_map_desc.min +
+			       buck12_voltage_map_desc.step*i
+			       < pdata->buck2_voltage[v])
+				i++;
+
+			max8998->buck2_vol[v] = i;
+			ret = max8998_write_reg(i2c,
+					MAX8998_REG_BUCK2_VOLTAGE1 + v, i);
+			if (ret)
+				goto err_out;
+		}
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 7547118..ca56bb0 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -73,12 +73,8 @@ struct max8998_regulator_data {
  * @buck_voltage_lock: Do NOT change the values of the following six
  *   registers set by buck?_voltage?. The voltage of BUCK1/2 cannot
  *   be other than the preset values.
- * @buck1_voltage1: BUCK1 DVS mode 1 voltage register
- * @buck1_voltage2: BUCK1 DVS mode 2 voltage register
- * @buck1_voltage3: BUCK1 DVS mode 3 voltage register
- * @buck1_voltage4: BUCK1 DVS mode 4 voltage register
- * @buck2_voltage1: BUCK2 DVS mode 1 voltage register
- * @buck2_voltage2: BUCK2 DVS mode 2 voltage register
+ * @buck1_voltage: BUCK1 DVS mode 1 voltage registers
+ * @buck2_voltage: BUCK2 DVS mode 2 voltage registers
  * @buck1_set1: BUCK1 gpio pin 1 to set output voltage
  * @buck1_set2: BUCK1 gpio pin 2 to set output voltage
  * @buck1_default_idx: Default for BUCK1 gpio pin 1, 2
@@ -103,12 +99,8 @@ struct max8998_platform_data {
 	unsigned int			irq_base;
 	int				ono;
 	bool				buck_voltage_lock;
-	int				buck1_voltage1;
-	int				buck1_voltage2;
-	int				buck1_voltage3;
-	int				buck1_voltage4;
-	int				buck2_voltage1;
-	int				buck2_voltage2;
+	int				buck1_voltage[4];
+	int				buck2_voltage[2];
 	int				buck1_set1;
 	int				buck1_set2;
 	int				buck1_default_idx;
-- 
1.8.2.1

