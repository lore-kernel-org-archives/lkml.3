Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaGHM2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:28:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36039 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaGHM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:28:13 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] regulator: s2mpxxx: Move regulator min/step voltages in common place
Date: Tue,  8 Jul 2014 17:57:58 +0530
Message-Id: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch and moves min/step voltages in a common samsung
header file so that they can be used by other s2mpxxx PMIC drivers. Only
few required macros are added currently and others can be added if needed.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/regulator/s2mpa01.c         | 32 ++++++++++++------------
 drivers/regulator/s2mps11.c         | 50 ++++++++++++++++++-------------------
 include/linux/mfd/samsung/core.h    | 21 ++++++++++++++++
 include/linux/mfd/samsung/s2mpa01.h | 12 ---------
 include/linux/mfd/samsung/s2mps11.h |  9 -------
 include/linux/mfd/samsung/s2mps14.h | 10 --------
 6 files changed, 62 insertions(+), 72 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index ee83b48..962c5f1 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -241,8 +241,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPA01_LDO_MIN,		\
-	.uV_step	= S2MPA01_LDO_STEP1,		\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_50_MV,			\
 	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
@@ -255,8 +255,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPA01_LDO_MIN,		\
-	.uV_step	= S2MPA01_LDO_STEP2,		\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_25_MV,			\
 	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
@@ -270,8 +270,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN1,			\
-	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B1CTRL2 + (num - 1) * 2,	\
@@ -286,8 +286,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN2,			\
-	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.min_uV		= MIN_800_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B5CTRL2,			\
@@ -302,8 +302,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN1,			\
-	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B6CTRL2 + (num - 6) * 2,	\
@@ -318,8 +318,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN2,			\
-	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.min_uV		= MIN_800_MV,				\
+	.uV_step	= STEP_12_5_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B8CTRL2,			\
@@ -334,8 +334,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN4,			\
-	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.min_uV		= MIN_1500_MV,				\
+	.uV_step	= STEP_12_5_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B9CTRL2,			\
@@ -350,8 +350,8 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPA01_BUCK_MIN3,			\
-	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.min_uV		= MIN_1000_MV,				\
+	.uV_step	= STEP_12_5_MV,				\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B10CTRL2,			\
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 02e2fb2..2098c3e 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -250,14 +250,14 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.set_ramp_delay		= s2mps11_set_ramp_delay,
 };
 
-#define regulator_desc_s2mps11_ldo1(num)	{		\
+#define regulator_desc_s2mps11_ldo1(num)	{	\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS11_LDO##num,		\
 	.ops		= &s2mps11_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPS11_LDO_MIN,		\
-	.uV_step	= S2MPS11_LDO_STEP1,		\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_50_MV,			\
 	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
@@ -270,8 +270,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPS11_LDO_MIN,		\
-	.uV_step	= S2MPS11_LDO_STEP2,		\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_25_MV,			\
 	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
@@ -285,8 +285,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS11_BUCK_MIN1,			\
-	.uV_step	= S2MPS11_BUCK_STEP1,			\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B1CTRL2 + (num - 1) * 2,	\
@@ -301,8 +301,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS11_BUCK_MIN1,			\
-	.uV_step	= S2MPS11_BUCK_STEP1,			\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B5CTRL2,			\
@@ -317,8 +317,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS11_BUCK_MIN1,			\
-	.uV_step	= S2MPS11_BUCK_STEP1,			\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B6CTRL2 + (num - 6) * 2,	\
@@ -333,8 +333,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS11_BUCK_MIN3,			\
-	.uV_step	= S2MPS11_BUCK_STEP3,			\
+	.min_uV		= MIN_3000_MV,				\
+	.uV_step	= STEP_25_MV,				\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
@@ -349,8 +349,8 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS11_BUCK_MIN2,			\
-	.uV_step	= S2MPS11_BUCK_STEP2,			\
+	.min_uV		= MIN_750_MV,				\
+	.uV_step	= STEP_12_5_MV,				\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B10CTRL2,			\
@@ -473,8 +473,8 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.ops		= &s2mps14_reg_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPS14_LDO_MIN_800MV,	\
-	.uV_step	= S2MPS14_LDO_STEP_25MV,	\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_25_MV,			\
 	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
@@ -487,8 +487,8 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.ops		= &s2mps14_reg_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPS14_LDO_MIN_1800MV,	\
-	.uV_step	= S2MPS14_LDO_STEP_25MV,	\
+	.min_uV		= MIN_1800_MV,			\
+	.uV_step	= STEP_25_MV,			\
 	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
@@ -501,8 +501,8 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.ops		= &s2mps14_reg_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= S2MPS14_LDO_MIN_800MV,	\
-	.uV_step	= S2MPS14_LDO_STEP_12_5MV,	\
+	.min_uV		= MIN_800_MV,			\
+	.uV_step	= STEP_12_5_MV,			\
 	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
@@ -515,8 +515,8 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.ops		= &s2mps14_reg_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS14_BUCK1235_MIN_600MV,		\
-	.uV_step	= S2MPS14_BUCK1235_STEP_6_25MV,		\
+	.min_uV		= MIN_600_MV,				\
+	.uV_step	= STEP_6_25_MV,				\
 	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
 	.linear_min_sel = S2MPS14_BUCK1235_START_SEL,		\
 	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
@@ -531,8 +531,8 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.ops		= &s2mps14_reg_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= S2MPS14_BUCK4_MIN_1400MV,		\
-	.uV_step	= S2MPS14_BUCK4_STEP_12_5MV,		\
+	.min_uV		= MIN_1400_MV,				\
+	.uV_step	= STEP_12_5_MV,				\
 	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
 	.linear_min_sel = S2MPS14_BUCK4_START_SEL,		\
 	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 47d8424..a4118aa 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -14,6 +14,27 @@
 #ifndef __LINUX_MFD_SEC_CORE_H
 #define __LINUX_MFD_SEC_CORE_H
 
+/* Macros to represent minimum voltages for LDO/BUCK */
+#define MIN_3000_MV		3000000
+#define MIN_2500_MV		2500000
+#define MIN_2000_MV		2000000
+#define MIN_1800_MV		1800000
+#define MIN_1500_MV		1500000
+#define MIN_1400_MV		1400000
+#define MIN_1000_MV		1000000
+
+#define MIN_900_MV		900000
+#define MIN_850_MV		850000
+#define MIN_800_MV		800000
+#define MIN_750_MV		750000
+#define MIN_600_MV		600000
+
+/* Macros to represent steps for LDO/BUCK */
+#define STEP_50_MV		50000
+#define STEP_25_MV		25000
+#define STEP_12_5_MV		12500
+#define STEP_6_25_MV		6250
+
 enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
diff --git a/include/linux/mfd/samsung/s2mpa01.h b/include/linux/mfd/samsung/s2mpa01.h
index fbc63bc..2766108 100644
--- a/include/linux/mfd/samsung/s2mpa01.h
+++ b/include/linux/mfd/samsung/s2mpa01.h
@@ -155,18 +155,6 @@ enum s2mpa01_regulators {
 	S2MPA01_REGULATOR_MAX,
 };
 
-#define S2MPA01_BUCK_MIN1	600000
-#define S2MPA01_BUCK_MIN2	800000
-#define S2MPA01_BUCK_MIN3	1000000
-#define S2MPA01_BUCK_MIN4	1500000
-#define S2MPA01_LDO_MIN		800000
-
-#define S2MPA01_BUCK_STEP1	6250
-#define S2MPA01_BUCK_STEP2	12500
-
-#define S2MPA01_LDO_STEP1	50000
-#define S2MPA01_LDO_STEP2	25000
-
 #define S2MPA01_LDO_VSEL_MASK	0x3F
 #define S2MPA01_BUCK_VSEL_MASK	0xFF
 #define S2MPA01_ENABLE_MASK	(0x03 << S2MPA01_ENABLE_SHIFT)
diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
index b3ddf98..7981a9d 100644
--- a/include/linux/mfd/samsung/s2mps11.h
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -171,15 +171,6 @@ enum s2mps11_regulators {
 	S2MPS11_REGULATOR_MAX,
 };
 
-#define S2MPS11_BUCK_MIN1	600000
-#define S2MPS11_BUCK_MIN2	750000
-#define S2MPS11_BUCK_MIN3	3000000
-#define S2MPS11_LDO_MIN	800000
-#define S2MPS11_BUCK_STEP1	6250
-#define S2MPS11_BUCK_STEP2	12500
-#define S2MPS11_BUCK_STEP3	25000
-#define S2MPS11_LDO_STEP1	50000
-#define S2MPS11_LDO_STEP2	25000
 #define S2MPS11_LDO_VSEL_MASK	0x3F
 #define S2MPS11_BUCK_VSEL_MASK	0xFF
 #define S2MPS11_ENABLE_MASK	(0x03 << S2MPS11_ENABLE_SHIFT)
diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
index 900cd7a..c92f478 100644
--- a/include/linux/mfd/samsung/s2mps14.h
+++ b/include/linux/mfd/samsung/s2mps14.h
@@ -123,10 +123,6 @@ enum s2mps14_regulators {
 };
 
 /* Regulator constraints for BUCKx */
-#define S2MPS14_BUCK1235_MIN_600MV	600000
-#define S2MPS14_BUCK4_MIN_1400MV	1400000
-#define S2MPS14_BUCK1235_STEP_6_25MV	6250
-#define S2MPS14_BUCK4_STEP_12_5MV	12500
 #define S2MPS14_BUCK1235_START_SEL	0x20
 #define S2MPS14_BUCK4_START_SEL		0x40
 /*
@@ -136,12 +132,6 @@ enum s2mps14_regulators {
  */
 #define S2MPS14_BUCK_RAMP_DELAY		12500
 
-/* Regulator constraints for different types of LDOx */
-#define S2MPS14_LDO_MIN_800MV		800000
-#define S2MPS14_LDO_MIN_1800MV		1800000
-#define S2MPS14_LDO_STEP_12_5MV		12500
-#define S2MPS14_LDO_STEP_25MV		25000
-
 #define S2MPS14_LDO_VSEL_MASK		0x3F
 #define S2MPS14_BUCK_VSEL_MASK		0xFF
 #define S2MPS14_ENABLE_MASK		(0x03 << S2MPS14_ENABLE_SHIFT)
-- 
1.9.1

