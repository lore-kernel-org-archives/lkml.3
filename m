Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaGHKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:23:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52517 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbaGHKXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:23:45 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 6/7] regulator: tps65218: Add get_voltage ops for dcdc5 and dcdc6
Date: Tue, 8 Jul 2014 15:46:36 +0530
Message-ID: <1404814597-4404-7-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add get_voltage ops for dcdc5 and dcdc6. Both dcdc5 and 6 are fixed regulators
and hence return min_uV (or max_uV).

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/regulator/tps65218-regulator.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 9effe48..700c652 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -151,6 +151,14 @@ static int tps65218_pmic_disable(struct regulator_dev *dev)
 				   dev->desc->enable_mask, TPS65218_PROTECT_L1);
 }
 
+static int tps65218_pmic_dcdc56_get_voltage(struct regulator_dev *dev)
+{
+	struct tps65218 *tps = rdev_get_drvdata(dev);
+	unsigned int rid = rdev_get_id(dev);
+
+	return tps->info[rid]->min_uV;
+}
+
 /* Operations permitted on DCDC1, DCDC2 */
 static struct regulator_ops tps65218_dcdc12_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -179,6 +187,7 @@ static struct regulator_ops tps65218_dcdc56_pmic_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= tps65218_pmic_enable,
 	.disable		= tps65218_pmic_disable,
+	.get_voltage		= tps65218_pmic_dcdc56_get_voltage,
 };
 
 static const struct regulator_desc regulators[] = {
-- 
1.7.9.5

