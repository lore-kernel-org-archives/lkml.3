Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaGIKZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:25:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45629 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbaGIKZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:25:11 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v4] regulator: tps65218: Add fixed_uV fields for dcdc5 and dcdc6
Date: Wed, 9 Jul 2014 15:52:59 +0530
Message-ID: <1404901379-30135-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
References: <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fixed_uV fields for dcdc5 and dcdc6.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
Changes from V3:

  * Rebased to Latest for/tps65218 branch.

 drivers/regulator/tps65218-regulator.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index e610dad..f0a4028 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -30,7 +30,7 @@
 enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 
 #define TPS65218_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _er, _em, \
-			    _lr, _nlr, _delay)			\
+			    _lr, _nlr, _delay, _fuv)		\
 	{							\
 		.name			= _name,		\
 		.id			= _id,			\
@@ -46,6 +46,7 @@ enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 		.linear_ranges		= _lr,			\
 		.n_linear_ranges	= _nlr,			\
 		.ramp_delay		= _delay,		\
+		.fixed_uV		= _fuv			\
 	}							\
 
 #define TPS65218_INFO(_id, _nm, _min, _max)	\
@@ -186,32 +187,32 @@ static const struct regulator_desc regulators[] = {
 			   TPS65218_REG_CONTROL_DCDC1,
 			   TPS65218_CONTROL_DCDC1_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC1_EN,
-			   dcdc1_dcdc2_ranges, 2, 4000),
+			   dcdc1_dcdc2_ranges, 2, 4000, 0),
 	TPS65218_REGULATOR("DCDC2", TPS65218_DCDC_2, tps65218_dcdc12_ops, 64,
 			   TPS65218_REG_CONTROL_DCDC2,
 			   TPS65218_CONTROL_DCDC2_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC2_EN,
-			   dcdc1_dcdc2_ranges, 2, 4000),
+			   dcdc1_dcdc2_ranges, 2, 4000, 0),
 	TPS65218_REGULATOR("DCDC3", TPS65218_DCDC_3, tps65218_ldo1_dcdc34_ops,
 			   64, TPS65218_REG_CONTROL_DCDC3,
 			   TPS65218_CONTROL_DCDC3_MASK, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC3_EN, ldo1_dcdc3_ranges, 2, 0),
+			   TPS65218_ENABLE1_DC3_EN, ldo1_dcdc3_ranges, 2, 0, 0),
 	TPS65218_REGULATOR("DCDC4", TPS65218_DCDC_4, tps65218_ldo1_dcdc34_ops,
 			   53, TPS65218_REG_CONTROL_DCDC4,
 			   TPS65218_CONTROL_DCDC4_MASK,
 			   TPS65218_REG_ENABLE1, TPS65218_ENABLE1_DC4_EN,
-			   dcdc4_ranges, 2, 0),
+			   dcdc4_ranges, 2, 0, 0),
 	TPS65218_REGULATOR("DCDC5", TPS65218_DCDC_5, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC5_EN, NULL, 0, 0),
+			   TPS65218_ENABLE1_DC5_EN, NULL, 0, 0, 1000000),
 	TPS65218_REGULATOR("DCDC6", TPS65218_DCDC_6, tps65218_dcdc56_pmic_ops,
 			   1, -1, -1, TPS65218_REG_ENABLE1,
-			   TPS65218_ENABLE1_DC6_EN, NULL, 0, 0),
+			   TPS65218_ENABLE1_DC6_EN, NULL, 0, 0, 1800000),
 	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
 			   TPS65218_REG_CONTROL_LDO1,
 			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
 			   TPS65218_ENABLE2_LDO1_EN, ldo1_dcdc3_ranges,
-			   2, 0),
+			   2, 0, 0),
 };
 
 static int tps65218_regulator_probe(struct platform_device *pdev)
-- 
1.7.9.5

