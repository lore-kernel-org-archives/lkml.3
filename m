Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3F2D16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 23:27:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63647 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3F2D15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:27:57 -0400
Message-ID: <1372476470.8773.1.camel@phoenix>
Subject: [PATCH] palmas: Simplify regulator_desc setting for
 SMPS10_[OUT1|OUT2]
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 29 Jun 2013 11:27:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_desc setting for SMPS10-OUT1 and SMPS10-OUT2 are very similar,
only enable_mask is different.
Make the switch case fall through to simplify the code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 50ca8c0..de25d20 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -879,23 +879,6 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 		switch (id) {
 		case PALMAS_REG_SMPS10_OUT1:
-			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
-			pmic->desc[id].ops = &palmas_ops_smps10;
-			pmic->desc[id].vsel_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].vsel_mask = SMPS10_VSEL;
-			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
-			pmic->desc[id].bypass_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
-			pmic->desc[id].min_uV = 3750000;
-			pmic->desc[id].uV_step = 1250000;
-			break;
 		case PALMAS_REG_SMPS10_OUT2:
 			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
 			pmic->desc[id].ops = &palmas_ops_smps10;
@@ -906,7 +889,10 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
 							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
+			if (id == PALMAS_REG_SMPS10_OUT1)
+				pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
+			else
+				pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].bypass_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
 							PALMAS_SMPS10_CTRL);
-- 
1.8.1.2



