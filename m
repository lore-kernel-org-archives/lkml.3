Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030492Ab3HIH3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:29:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34036 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401Ab3HIH3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:29:34 -0400
Message-ID: <1376033367.29104.2.camel@phoenix>
Subject: [PATCH] regulator: core: Move
 list_voltage_{linear,linear_range,table} to helpers.c
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 09 Aug 2013 15:29:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move regulator_list_voltage_{linear,linear_range,table} helper functions to
helpers.c.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c    | 86 ---------------------------------------------
 drivers/regulator/helpers.c | 86 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 78b8dea..77943ed 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2049,92 +2049,6 @@ int regulator_count_voltages(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
 /**
- * regulator_list_voltage_linear - List voltages with simple calculation
- *
- * @rdev: Regulator device
- * @selector: Selector to convert into a voltage
- *
- * Regulators with a simple linear mapping between voltages and
- * selectors can set min_uV and uV_step in the regulator descriptor
- * and then use this function as their list_voltage() operation,
- */
-int regulator_list_voltage_linear(struct regulator_dev *rdev,
-				  unsigned int selector)
-{
-	if (selector >= rdev->desc->n_voltages)
-		return -EINVAL;
-	if (selector < rdev->desc->linear_min_sel)
-		return 0;
-
-	selector -= rdev->desc->linear_min_sel;
-
-	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
-}
-EXPORT_SYMBOL_GPL(regulator_list_voltage_linear);
-
-/**
- * regulator_list_voltage_linear_range - List voltages for linear ranges
- *
- * @rdev: Regulator device
- * @selector: Selector to convert into a voltage
- *
- * Regulators with a series of simple linear mappings between voltages
- * and selectors can set linear_ranges in the regulator descriptor and
- * then use this function as their list_voltage() operation,
- */
-int regulator_list_voltage_linear_range(struct regulator_dev *rdev,
-					unsigned int selector)
-{
-	const struct regulator_linear_range *range;
-	int i;
-
-	if (!rdev->desc->n_linear_ranges) {
-		BUG_ON(!rdev->desc->n_linear_ranges);
-		return -EINVAL;
-	}
-
-	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
-		range = &rdev->desc->linear_ranges[i];
-
-		if (!(selector >= range->min_sel &&
-		      selector <= range->max_sel))
-			continue;
-
-		selector -= range->min_sel;
-
-		return range->min_uV + (range->uV_step * selector);
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(regulator_list_voltage_linear_range);
-
-/**
- * regulator_list_voltage_table - List voltages with table based mapping
- *
- * @rdev: Regulator device
- * @selector: Selector to convert into a voltage
- *
- * Regulators with table based mapping between voltages and
- * selectors can set volt_table in the regulator descriptor
- * and then use this function as their list_voltage() operation.
- */
-int regulator_list_voltage_table(struct regulator_dev *rdev,
-				 unsigned int selector)
-{
-	if (!rdev->desc->volt_table) {
-		BUG_ON(!rdev->desc->volt_table);
-		return -EINVAL;
-	}
-
-	if (selector >= rdev->desc->n_voltages)
-		return -EINVAL;
-
-	return rdev->desc->volt_table[selector];
-}
-EXPORT_SYMBOL_GPL(regulator_list_voltage_table);
-
-/**
  * regulator_list_voltage - enumerate supported voltages
  * @regulator: regulator source
  * @selector: identify voltage to list
diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
index d13cf8f..6e30df1 100644
--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -320,6 +320,92 @@ int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
 EXPORT_SYMBOL_GPL(regulator_map_voltage_linear_range);
 
 /**
+ * regulator_list_voltage_linear - List voltages with simple calculation
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with a simple linear mapping between voltages and
+ * selectors can set min_uV and uV_step in the regulator descriptor
+ * and then use this function as their list_voltage() operation,
+ */
+int regulator_list_voltage_linear(struct regulator_dev *rdev,
+				  unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+	if (selector < rdev->desc->linear_min_sel)
+		return 0;
+
+	selector -= rdev->desc->linear_min_sel;
+
+	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_linear);
+
+/**
+ * regulator_list_voltage_linear_range - List voltages for linear ranges
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with a series of simple linear mappings between voltages
+ * and selectors can set linear_ranges in the regulator descriptor and
+ * then use this function as their list_voltage() operation,
+ */
+int regulator_list_voltage_linear_range(struct regulator_dev *rdev,
+					unsigned int selector)
+{
+	const struct regulator_linear_range *range;
+	int i;
+
+	if (!rdev->desc->n_linear_ranges) {
+		BUG_ON(!rdev->desc->n_linear_ranges);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
+		range = &rdev->desc->linear_ranges[i];
+
+		if (!(selector >= range->min_sel &&
+		      selector <= range->max_sel))
+			continue;
+
+		selector -= range->min_sel;
+
+		return range->min_uV + (range->uV_step * selector);
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_linear_range);
+
+/**
+ * regulator_list_voltage_table - List voltages with table based mapping
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with table based mapping between voltages and
+ * selectors can set volt_table in the regulator descriptor
+ * and then use this function as their list_voltage() operation.
+ */
+int regulator_list_voltage_table(struct regulator_dev *rdev,
+				 unsigned int selector)
+{
+	if (!rdev->desc->volt_table) {
+		BUG_ON(!rdev->desc->volt_table);
+		return -EINVAL;
+	}
+
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	return rdev->desc->volt_table[selector];
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_table);
+
+/**
  * regulator_set_bypass_regmap - Default set_bypass() using regmap
  *
  * @rdev: device to operate on.
-- 
1.8.1.2



