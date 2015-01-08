Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbbAHCES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:04:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44307 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbAHCEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:04:16 -0500
X-AuditID: cbfee68f-f791c6d000004834-8f-54ade59de5f4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: sbkim73@samsung.com, lgirdwood@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] regulator: s2mps11: Fix wrong calculation of register offset
Date: Thu, 08 Jan 2015 11:04:07 +0900
Message-id: <1420682647-6461-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkWHfu07UhBleeGltMffiEzeL6l+es
	Fp1nnzBb3P96lNHi25UOJovLu+awWZzuZrW4uOILk8WCjY8YHTg9ds66y+6xaVUnm8eda3vY
	POadDPTo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujEVP+tkKzslVXO9/y9jAeEiyi5GTQ0LA
	ROLJyUdMELaYxIV769m6GLk4hASWMkp8fHORBabo0OUL7BCJRYwSN3teskA4TUwS/3beYAap
	YhPQktj/4gYbiC0CNOr2nE5mkCJmgcuMEqsaj7KCJIQFfCUOHelnB7FZBFQlXv3cCmbzCrhI
	PHm7mhlinYLEsuUzWUGaJQQms0s83H+NDaJBQOLb5ENAqzmAErISmw5A1UtKHFxxg2UCo+AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFBffrfs/4djHcPWB9iFOBgVOLh/XB/bYgQ
	a2JZcWXuIUZToA0TmaVEk/OBsZNXEm9obGZkYWpiamxkbmmmJM67UOpnsJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbGcp+M9AS5OVKnOmt3l9zjzvtzcVup29XmH+r7RZ6K93tumhjEK19p
	cq3+MV/WjxcRV5JuK24+tnTV8neZDZwtSlxLOaaZ+jzSWv+8ZeV83XqBl9ofLA582TN3Ruk9
	zyM345pWKjlV30s59uYSb4Dfv3/fdFIt2AyE9mpVVl0Oj1my4rGelwezEktxRqKhFnNRcSIA
	W9gPnmUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jAd25T9eGGPQ807SY+vAJm8X1L89Z
	LTrPPmG2uP/1KKPFtysdTBaXd81hszjdzWpxccUXJosFGx8xOnB67Jx1l91j06pONo871/aw
	ecw7GejRt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMW
	PelnKzgnV3G9/y1jA+MhyS5GTg4JAROJQ5cvsEPYYhIX7q1n62Lk4hASWMQocbPnJQuE08Qk
	8W/nDWaQKjYBLYn9L26wgdgiQB2353QygxQxC1xmlFjVeJQVJCEs4Ctx6Eg/2FgWAVWJVz+3
	gtm8Ai4ST96uZoZYpyCxbPlM1gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfM
	M+kdjKsaLA4xCnAwKvHwfri/NkSINbGsuDL3EKMEB7OSCG/yE6AQb0piZVVqUX58UWlOavEh
	RlOg7ROZpUST84HxnFcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnV
	wFhvsOdTjsjfmZ4JNiLvQvMmiOTrHIp792jPmh1K3YpTH8UJi/5yc9FprL4otWyCZamPYMy2
	y9Gezt/e/0vc/HRS2ZqNe5+UrnGK3+Openle26YtAUYJxoEfa4NjNi0SWfND48icIxW/fpnn
	q031Y3Q8ozJpatdUpicHynf4eilbXy7TEFQ1cVRiKc5INNRiLipOBAAJegn6rwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

This patch adds missing registers('BUCK7_SW' & 'LDO29_CTRL'). Since BUCK7 has
1 more register (BUCK7_SW) than others, register offset should
be added one more for which has bigger address than BUCK7 registers.

Fixes: 76b9840b24ae04(regulator: s2mps11: Add support S2MPS13 regulator device)
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: <stable@vger.kernel.org>
---
 drivers/regulator/s2mps11.c         | 42 +++++++++++++++++++++++++++++++++----
 include/linux/mfd/samsung/s2mps13.h |  2 ++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 2809ae0..ff82811 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -405,6 +405,40 @@ static struct regulator_ops s2mps14_reg_ops;
 	.enable_mask	= S2MPS14_ENABLE_MASK			\
 }
 
+#define regulator_desc_s2mps13_buck7(num, min, step, min_sel) {	\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPS13_BUCK##num,			\
+	.ops		= &s2mps14_reg_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= min,					\
+	.uV_step	= step,					\
+	.linear_min_sel	= min_sel,				\
+	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS13_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPS13_REG_B1OUT + (num) * 2 - 1,	\
+	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPS13_REG_B1CTRL + (num - 1) * 2,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK			\
+}
+
+#define regulator_desc_s2mps13_buck8_10(num, min, step, min_sel) {	\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPS13_BUCK##num,			\
+	.ops		= &s2mps14_reg_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= min,					\
+	.uV_step	= step,					\
+	.linear_min_sel	= min_sel,				\
+	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS13_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPS13_REG_B1OUT + (num) * 2 - 1,	\
+	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPS13_REG_B1CTRL + (num) * 2 - 1,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK			\
+}
+
 static const struct regulator_desc s2mps13_regulators[] = {
 	regulator_desc_s2mps13_ldo(1,  MIN_800_MV,  STEP_12_5_MV, 0x00),
 	regulator_desc_s2mps13_ldo(2,  MIN_1400_MV, STEP_50_MV,   0x0C),
@@ -452,10 +486,10 @@ static const struct regulator_desc s2mps13_regulators[] = {
 	regulator_desc_s2mps13_buck(4,  MIN_500_MV,  STEP_6_25_MV, 0x10),
 	regulator_desc_s2mps13_buck(5,  MIN_500_MV,  STEP_6_25_MV, 0x10),
 	regulator_desc_s2mps13_buck(6,  MIN_500_MV,  STEP_6_25_MV, 0x10),
-	regulator_desc_s2mps13_buck(7,  MIN_500_MV,  STEP_6_25_MV, 0x10),
-	regulator_desc_s2mps13_buck(8,  MIN_1000_MV, STEP_12_5_MV, 0x20),
-	regulator_desc_s2mps13_buck(9,  MIN_1000_MV, STEP_12_5_MV, 0x20),
-	regulator_desc_s2mps13_buck(10, MIN_500_MV,  STEP_6_25_MV, 0x10),
+	regulator_desc_s2mps13_buck7(7,  MIN_500_MV,  STEP_6_25_MV, 0x10),
+	regulator_desc_s2mps13_buck8_10(8,  MIN_1000_MV, STEP_12_5_MV, 0x20),
+	regulator_desc_s2mps13_buck8_10(9,  MIN_1000_MV, STEP_12_5_MV, 0x20),
+	regulator_desc_s2mps13_buck8_10(10, MIN_500_MV,  STEP_6_25_MV, 0x10),
 };
 
 static int s2mps14_regulator_enable(struct regulator_dev *rdev)
diff --git a/include/linux/mfd/samsung/s2mps13.h b/include/linux/mfd/samsung/s2mps13.h
index ce5dda8..b1fd675 100644
--- a/include/linux/mfd/samsung/s2mps13.h
+++ b/include/linux/mfd/samsung/s2mps13.h
@@ -59,6 +59,7 @@ enum s2mps13_reg {
 	S2MPS13_REG_B6CTRL,
 	S2MPS13_REG_B6OUT,
 	S2MPS13_REG_B7CTRL,
+	S2MPS13_REG_B7SW,
 	S2MPS13_REG_B7OUT,
 	S2MPS13_REG_B8CTRL,
 	S2MPS13_REG_B8OUT,
@@ -102,6 +103,7 @@ enum s2mps13_reg {
 	S2MPS13_REG_L26CTRL,
 	S2MPS13_REG_L27CTRL,
 	S2MPS13_REG_L28CTRL,
+	S2MPS13_REG_L29CTRL,
 	S2MPS13_REG_L30CTRL,
 	S2MPS13_REG_L31CTRL,
 	S2MPS13_REG_L32CTRL,
-- 
1.8.5.5

