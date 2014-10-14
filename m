Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaJNIGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:06:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54544 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaJNIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:05:59 -0400
X-AuditID: cbfee691-f79b86d000004a5a-7f-543cd9653afa
From: Thomas Abraham <thomas.ab@samsung.com>
To: lgirdwood@gmail.com, broonie@kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org, lee.jones@linaro.org
Subject: [PATCH] regulator: s2mps11: add support for S2MPS15 regulators
Date: Tue, 14 Oct 2014 13:47:43 +0530
Message-id: <1413274663-8836-1-git-send-email-thomas.ab@samsung.com>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWyRsSkWjf1pk2Iwfn1ahZTHz5hs+hdcJXN
	4v7Xo4wW3650MFlc3jWHzYHVY+esu+wem1Z1snncubaHzaNvyypGj8+b5AJYo7hsUlJzMstS
	i/TtErgydp3ew1xw2LriwKrvLA2MJ4y7GDk5JARMJBbuvMAIYYtJXLi3nq2LkYtDSGApo0TH
	5e+sMEXv+y6ygNhCAtMZJZr+RkAUtTFJ/Pk0A6ybTUBH4sab32C2iIC2xOyr58BsZgFfiZ0T
	voENEhZwl/i2cgNYnEVAVeLVkz3MIDavgIvEk80roJYpSWzoPcoEskBC4D2bxMJ321ghGgQk
	vk0+BHQFB1BCVmLTAWaIekmJgytusExgFFzAyLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cT
	IzBET/97NnEH4/0D1ocYBTgYlXh4CyNtQoRYE8uKK3MPMZoCbZjILCWanA+MhLySeENjMyML
	UxNTYyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgnBU731588JUX3/5oF
	OkKXt3sbHSo/Jcc2fd4C2cn6Sn27bny5KxK5iJHhlsILhpqJtsE7L9zeK20YzrHAvuh0/MZG
	hZMvdP7cfGV8I/LuMkGp5VsFH584Wu1ddnalmqu3578/DjZW39KOP+56ZrX/D9fmp7+c7fMO
	qqjve8SQ8erLXIaSE7mrlViKMxINtZiLihMBvS1kakwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xoG7qTZsQg+aLchZTHz5hs+hdcJXN
	4v7Xo4wW3650MFlc3jWHzYHVY+esu+wem1Z1snncubaHzaNvyypGj8+b5AJYoxoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM3ad3sNccNi64sCq7ywNjCeMuxg5OSQETCTe
	911kgbDFJC7cW88GYgsJTGeUaPob0cXIBWS3MUn8+TSDESTBJqAjcePNbzBbREBbYvbVc2A2
	s4CvxM4J31hBbGEBd4lvKzeAxVkEVCVePdnDDGLzCrhIPNm8ghVimZLEht6jTBMYuRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6AZ9I7GFc1WBxiFOBgVOLhLYi0CRFiTSwrrsw9
	xCjBwawkwmu8ECjEm5JYWZValB9fVJqTWnyI0RRo+0RmKdHkfGB05pXEGxqbmJsam1qaWJiY
	WSqJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYHTa/H3ml8UFyYtu+ZS8U2C63hEo0Jej//iy
	vXPmnJi39+YbykgcVAzqv6il3XHNV0GHa8rvVXLa1+wytszoyGN0neX5/9WMrTFFZjvidl67
	fTBIsWryW6Nl+btNn35sbKqP1D+xrmGWxnXd91u37Xg4R2sW44pVxi94L9pUpNxw3nvp5NFf
	HjpKLMUZiYZazEXFiQB56DmOlgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS15 PMIC is similar in functionality to S2MPS11/14 PMIC. It contains
27 LDO and 10 Buck regulators and allows programming these regulators via a
I2C interface. This patch adds initial support for LDO/Buck regulators of
S2MPS15 PMIC.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
---
 drivers/regulator/s2mps11.c |  133 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index adab82d..e176fbb 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mps15.h>
 #include <linux/mfd/samsung/s2mpu02.h>
 
 struct s2mps11_info {
@@ -529,6 +530,133 @@ static const struct regulator_desc s2mps14_regulators[] = {
 	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV),
 };
 
+static struct regulator_ops s2mps15_reg_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+};
+
+static struct regulator_ops s2mps15_reg_buck_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+};
+
+#define regulator_desc_s2mps15_ldo(num, range) {	\
+	.name		= "LDO"#num,			\
+	.id		= S2MPS15_LDO##num,		\
+	.ops		= &s2mps15_reg_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.linear_ranges	= range,			\
+	.n_linear_ranges = ARRAY_SIZE(range),		\
+	.n_voltages	= S2MPS15_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPS15_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPS15_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPS15_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPS15_ENABLE_MASK		\
+}
+
+#define regulator_desc_s2mps15_buck(num, range) {			\
+	.name		= "BUCK"#num,					\
+	.id		= S2MPS15_BUCK##num,				\
+	.ops		= &s2mps15_reg_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.linear_ranges	= range,					\
+	.n_linear_ranges = ARRAY_SIZE(range),				\
+	.ramp_delay	= 12500,					\
+	.n_voltages	= S2MPS15_BUCK_N_VOLTAGES,			\
+	.vsel_reg	= S2MPS15_REG_B1CTRL2 + ((num - 1) * 2),	\
+	.vsel_mask	= S2MPS15_BUCK_VSEL_MASK,			\
+	.enable_reg	= S2MPS15_REG_B1CTRL1 + ((num - 1) * 2),	\
+	.enable_mask	= S2MPS14_ENABLE_MASK				\
+}
+
+/* voltage range for s2mps15 LDO 3, 5, 15, 16, 18, 20, 23 and 27 */
+static const struct regulator_linear_range s2mps15_ldo_voltage_ranges1[] = {
+	REGULATOR_LINEAR_RANGE(1000000, 0xc, 0x38, 25000),
+};
+
+/* voltage range for s2mps15 LDO 2, 6, 14, 17, 19, 21, 24 and 25 */
+static const struct regulator_linear_range s2mps15_ldo_voltage_ranges2[] = {
+	REGULATOR_LINEAR_RANGE(1800000, 0x0, 0x3f, 25000),
+};
+
+/* voltage range for s2mps15 LDO 4, 11, 12, 13, 22 and 26 */
+static const struct regulator_linear_range s2mps15_ldo_voltage_ranges3[] = {
+	REGULATOR_LINEAR_RANGE(700000, 0x0, 0x34, 12500),
+};
+
+/* voltage range for s2mps15 LDO 7, 8, 9 and 10 */
+static const struct regulator_linear_range s2mps15_ldo_voltage_ranges4[] = {
+	REGULATOR_LINEAR_RANGE(700000, 0xc, 0x18, 25000),
+};
+
+/* voltage range for s2mps15 LDO 1 */
+static const struct regulator_linear_range s2mps15_ldo_voltage_ranges5[] = {
+	REGULATOR_LINEAR_RANGE(500000, 0x0, 0x20, 12500),
+};
+
+/* voltage range for s2mps15 BUCK 1, 2, 3, 4, 5, 6 and 7 */
+static const struct regulator_linear_range s2mps15_buck_voltage_ranges1[] = {
+	REGULATOR_LINEAR_RANGE(500000, 0x10, 0xb0, 6250),
+};
+
+/* voltage range for s2mps15 BUCK 8, 9 and 10 */
+static const struct regulator_linear_range s2mps15_buck_voltage_ranges2[] = {
+	REGULATOR_LINEAR_RANGE(1000000, 0x20, 0xc0, 12500),
+};
+
+static const struct regulator_desc s2mps15_regulators[] = {
+	regulator_desc_s2mps15_ldo(1, s2mps15_ldo_voltage_ranges5),
+	regulator_desc_s2mps15_ldo(2, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(3, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(4, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(5, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(6, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(7, s2mps15_ldo_voltage_ranges4),
+	regulator_desc_s2mps15_ldo(8, s2mps15_ldo_voltage_ranges4),
+	regulator_desc_s2mps15_ldo(9, s2mps15_ldo_voltage_ranges4),
+	regulator_desc_s2mps15_ldo(10, s2mps15_ldo_voltage_ranges4),
+	regulator_desc_s2mps15_ldo(11, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(12, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(13, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(14, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(15, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(16, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(17, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(18, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(19, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(20, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(21, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(22, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(23, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_ldo(24, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(25, s2mps15_ldo_voltage_ranges2),
+	regulator_desc_s2mps15_ldo(26, s2mps15_ldo_voltage_ranges3),
+	regulator_desc_s2mps15_ldo(27, s2mps15_ldo_voltage_ranges1),
+	regulator_desc_s2mps15_buck(1, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(2, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(3, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(4, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(5, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(6, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(7, s2mps15_buck_voltage_ranges1),
+	regulator_desc_s2mps15_buck(8, s2mps15_buck_voltage_ranges2),
+	regulator_desc_s2mps15_buck(9, s2mps15_buck_voltage_ranges2),
+	regulator_desc_s2mps15_buck(10, s2mps15_buck_voltage_ranges2),
+};
+
 static int s2mps14_pmic_enable_ext_control(struct s2mps11_info *s2mps11,
 		struct regulator_dev *rdev)
 {
@@ -835,6 +963,10 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		s2mps11->rdev_num = ARRAY_SIZE(s2mps14_regulators);
 		regulators = s2mps14_regulators;
 		break;
+	case S2MPS15X:
+		s2mps11->rdev_num = ARRAY_SIZE(s2mps15_regulators);
+		regulators = s2mps15_regulators;
+		break;
 	case S2MPU02:
 		s2mps11->rdev_num = ARRAY_SIZE(s2mpu02_regulators);
 		regulators = s2mpu02_regulators;
@@ -928,6 +1060,7 @@ out:
 static const struct platform_device_id s2mps11_pmic_id[] = {
 	{ "s2mps11-pmic", S2MPS11X},
 	{ "s2mps14-pmic", S2MPS14X},
+	{ "s2mps15-pmic", S2MPS15X},
 	{ "s2mpu02-pmic", S2MPU02},
 	{ },
 };
-- 
1.6.6.rc2

