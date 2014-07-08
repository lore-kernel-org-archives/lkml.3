Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaGHTKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:10:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49316 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaGHTJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:09:47 -0400
From: Felipe Balbi <balbi@ti.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/3] regulator: tps65218: drop unneeded field from our regulator macro
Date: Tue, 8 Jul 2014 14:09:13 -0500
Message-ID: <1404846554-4095-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-Reply-To: <1404846554-4095-1-git-send-email-balbi@ti.com>
References: <1404846554-4095-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

volt table is always NULL for all regulators,
might as well drop the argument.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/regulator/tps65218-regulator.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 8b7a0a9..7fc8b3a 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -29,7 +29,7 @@
 
 enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 
-#define TPS65218_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _er, _em, _t, \
+#define TPS65218_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _er, _em, \
 			    _lr, _nlr, _delay)			\
 	{							\
 		.name			= _name,		\
@@ -42,7 +42,7 @@ enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 		.vsel_mask		= _vm,			\
 		.enable_reg		= _er,			\
 		.enable_mask		= _em,			\
-		.volt_table		= _t,			\
+		.volt_table		= NULL,			\
 		.linear_ranges		= _lr,			\
 		.n_linear_ranges	= _nlr,			\
 		.ramp_delay		= _delay,		\
@@ -185,33 +185,32 @@ static const struct regulator_desc regulators[] = {
 	TPS65218_REGULATOR("DCDC1", TPS65218_DCDC_1, tps65218_dcdc12_ops, 64,
 			   TPS65218_REG_CONTROL_DCDC1,
 			   TPS65218_CONTROL_DCDC1_MASK,
-			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC1_EN, NULL,
+			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC1_EN,
 			   dcdc1_dcdc2_ranges, 2, 4000),
 	TPS65218_REGULATOR("DCDC2", TPS65218_DCDC_2, tps65218_dcdc12_ops, 64,
 			   TPS65218_REG_CONTROL_DCDC2,
 			   TPS65218_CONTROL_DCDC2_MASK,
-			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC2_EN, NULL,
+			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC2_EN,
 			   dcdc1_dcdc2_ranges, 2, 4000),
 	TPS65218_REGULATOR("DCDC3", TPS65218_DCDC_3, tps65218_ldo1_dcdc34_ops,
 			   64, TPS65218_REG_CONTROL_DCDC3,
 			   TPS65218_CONTROL_DCDC3_MASK, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC3_EN, NULL,
-			   ldo1_dcdc3_ranges, 2, 0),
+			   TPS65218_ENABLE1_DC3_EN, ldo1_dcdc3_ranges, 2, 0),
 	TPS65218_REGULATOR("DCDC4", TPS65218_DCDC_4, tps65218_ldo1_dcdc34_ops,
 			   53, TPS65218_REG_CONTROL_DCDC4,
 			   TPS65218_CONTROL_DCDC4_MASK,
-			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC4_EN, NULL,
+			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC4_EN,
 			   dcdc4_ranges, 2, 0),
 	TPS65218_REGULATOR("DCDC5", TPS65218_DCDC_5, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC5_EN, NULL, NULL, 0, 0),
+			   TPS65218_ENABLE1_DC5_EN, NULL, 0, 0),
 	TPS65218_REGULATOR("DCDC6", TPS65218_DCDC_6, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0, 0),
+			   TPS65218_ENABLE1_DC6_EN, NULL, 0, 0),
 	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
 			   TPS65218_REG_CONTROL_LDO1,
 			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
-			   TPS65218_ENABLE2_LDO1_EN, NULL, ldo1_dcdc3_ranges,
+			   TPS65218_ENABLE2_LDO1_EN, ldo1_dcdc3_ranges,
 			   2, 0),
 };
 
-- 
2.0.0.390.gcb682f8

