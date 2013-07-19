Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab3GSFGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:06:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64197 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3GSFG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:06:29 -0400
Message-ID: <1374210382.895.2.camel@phoenix>
Subject: [PATCH] regulator: 88pm800: Add missing n_voltages setting for bucks
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Joseph(Yossi) Hanin" <yhanin@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 13:06:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulator APIs are broken if n_voltages setting is not set.
e.g. regulator_count_voltages(), regulator_list_voltage(), and
regulator_can_change_voltage() do not work if n_voltages setting is missing.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm800.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index fc0c352..b4c29b1 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -91,8 +91,9 @@ struct pm800_regulators {
  * amax - the current
  * Buck has 2 kinds of voltage steps. It is easy to find voltage by ranges,
  * not the constant voltage table.
+ * n_volt - Number of available selectors
  */
-#define PM800_BUCK(vreg, ereg, ebit, amax, volt_ranges)			\
+#define PM800_BUCK(vreg, ereg, ebit, amax, volt_ranges, n_volt)		\
 {									\
 	.desc	= {							\
 		.name	= #vreg,					\
@@ -100,6 +101,7 @@ struct pm800_regulators {
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= PM800_ID_##vreg,				\
 		.owner	= THIS_MODULE,					\
+		.n_voltages		= n_volt,			\
 		.linear_ranges		= volt_ranges,			\
 		.n_linear_ranges	= ARRAY_SIZE(volt_ranges),	\
 		.vsel_reg		= PM800_##vreg,			\
@@ -204,11 +206,11 @@ static struct regulator_ops pm800_volt_table_ops = {
 
 /* The array is indexed by id(PM800_ID_XXX) */
 static struct pm800_regulator_info pm800_regulator_info[] = {
-	PM800_BUCK(BUCK1, BUCK_ENA, 0, 3000000, buck1_volt_range),
-	PM800_BUCK(BUCK2, BUCK_ENA, 1, 1200000, buck2_5_volt_range),
-	PM800_BUCK(BUCK3, BUCK_ENA, 2, 1200000, buck2_5_volt_range),
-	PM800_BUCK(BUCK4, BUCK_ENA, 3, 1200000, buck2_5_volt_range),
-	PM800_BUCK(BUCK5, BUCK_ENA, 4, 1200000, buck2_5_volt_range),
+	PM800_BUCK(BUCK1, BUCK_ENA, 0, 3000000, buck1_volt_range, 0x55),
+	PM800_BUCK(BUCK2, BUCK_ENA, 1, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(BUCK3, BUCK_ENA, 2, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(BUCK4, BUCK_ENA, 3, 1200000, buck2_5_volt_range, 0x73),
+	PM800_BUCK(BUCK5, BUCK_ENA, 4, 1200000, buck2_5_volt_range, 0x73),
 
 	PM800_LDO(LDO1, LDO_ENA1_1, 0, 200000, ldo1_volt_table),
 	PM800_LDO(LDO2, LDO_ENA1_1, 1, 10000, ldo2_volt_table),
-- 
1.8.1.2



