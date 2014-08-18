Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHRNKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:10:30 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45372 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHRNK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:10:29 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, grant.likely@linaro.org,
        khilman@linaro.org, haojian.zhuang@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, axel.lin@ingics.com,
        zhangnian@huawei.com
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH v6 1/6] regulator: core: add const qualifier to ops in struct regulator_desc
Date: Mon, 18 Aug 2014 21:09:11 +0800
Message-Id: <1408367356-2628-2-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
References: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct regulator_ops *ops is a member in struct regulator_desc, which gets
its value from individual regulator driver upon regulator_register() and
is used by regulator core APIs. It's not allowed for regulator core to
modify any of these callbacks in *ops. Add 'const' qualifier to enforce that.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 drivers/regulator/core.c              | 32 ++++++++++++++++----------------
 drivers/regulator/mc13892-regulator.c | 11 +++++++----
 include/linux/regulator/driver.h      |  2 +-
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c3785..c4a13db 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -839,7 +839,7 @@ static void print_constraints(struct regulator_dev *rdev)
 static int machine_constraints_voltage(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
 
 	/* do we need to apply the constraint voltage */
@@ -938,7 +938,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 static int machine_constraints_current(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
 
 	if (!constraints->min_uA && !constraints->max_uA)
@@ -982,7 +982,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	const struct regulation_constraints *constraints)
 {
 	int ret = 0;
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 
 	if (constraints)
 		rdev->constraints = kmemdup(constraints, sizeof(*constraints),
@@ -2208,9 +2208,9 @@ EXPORT_SYMBOL_GPL(regulator_count_voltages);
  */
 int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
-	int			ret;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
+	int ret;
 
 	if (rdev->desc->fixed_uV && rdev->desc->n_voltages == 1 && !selector)
 		return rdev->desc->fixed_uV;
@@ -2270,8 +2270,8 @@ int regulator_get_hardware_vsel_register(struct regulator *regulator,
 					 unsigned *vsel_reg,
 					 unsigned *vsel_mask)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
 
 	if (ops->set_voltage_sel != regulator_set_voltage_sel_regmap)
 		return -EOPNOTSUPP;
@@ -2297,8 +2297,8 @@ EXPORT_SYMBOL_GPL(regulator_get_hardware_vsel_register);
 int regulator_list_hardware_vsel(struct regulator *regulator,
 				 unsigned selector)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
 
 	if (selector >= rdev->desc->n_voltages)
 		return -EINVAL;
@@ -2572,8 +2572,8 @@ EXPORT_SYMBOL_GPL(regulator_set_voltage);
 int regulator_set_voltage_time(struct regulator *regulator,
 			       int old_uV, int new_uV)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int old_sel = -1;
 	int new_sel = -1;
 	int voltage;
@@ -3336,9 +3336,9 @@ EXPORT_SYMBOL_GPL(regulator_mode_to_status);
  */
 static int add_regulator_attributes(struct regulator_dev *rdev)
 {
-	struct device		*dev = &rdev->dev;
-	struct regulator_ops	*ops = rdev->desc->ops;
-	int			status = 0;
+	struct device *dev = &rdev->dev;
+	const struct regulator_ops *ops = rdev->desc->ops;
+	int status = 0;
 
 	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
@@ -3905,7 +3905,7 @@ core_initcall(regulator_init);
 static int __init regulator_init_complete(void)
 {
 	struct regulator_dev *rdev;
-	struct regulator_ops *ops;
+	const struct regulator_ops *ops;
 	struct regulation_constraints *c;
 	int enabled, ret;
 
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index f374fa5..793b662 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -526,6 +526,7 @@ static unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
 	return REGULATOR_MODE_NORMAL;
 }
 
+static struct regulator_ops mc13892_vcam_ops;
 
 static int mc13892_regulator_probe(struct platform_device *pdev)
 {
@@ -582,10 +583,12 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 	}
 	mc13xxx_unlock(mc13892);
 
-	mc13892_regulators[MC13892_VCAM].desc.ops->set_mode
-		= mc13892_vcam_set_mode;
-	mc13892_regulators[MC13892_VCAM].desc.ops->get_mode
-		= mc13892_vcam_get_mode;
+	/* update mc13892_vcam ops */
+	memcpy(&mc13892_vcam_ops, mc13892_regulators[MC13892_VCAM].desc.ops,
+						sizeof(struct regulator_ops));
+	mc13892_vcam_ops.set_mode = mc13892_vcam_set_mode,
+	mc13892_vcam_ops.get_mode = mc13892_vcam_get_mode,
+	mc13892_regulators[MC13892_VCAM].desc.ops = &mc13892_vcam_ops;
 
 	mc13xxx_data = mc13xxx_parse_regulators_dt(pdev, mc13892_regulators,
 					ARRAY_SIZE(mc13892_regulators));
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bbe03a1..4b62813 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -245,7 +245,7 @@ struct regulator_desc {
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-	struct regulator_ops *ops;
+	const struct regulator_ops *ops;
 	int irq;
 	enum regulator_type type;
 	struct module *owner;
-- 
1.9.1

