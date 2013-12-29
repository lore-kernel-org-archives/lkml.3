Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3L2JA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 04:00:28 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51957 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3L2JA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 04:00:26 -0500
Message-ID: <1388307620.15300.1.camel@phoenix>
Subject: [PATCH v2] regulator: tps65910: Simplify setting enable_mask for
 regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 29 Dec 2013 17:00:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BBCH_BBCHEN_MASK is equivalent to TPS65910_SUPPLY_STATE_ENABLED.
So all regulators have the same enable_mask setting.

BBCH_BBCHEN_MASK and BBCH_BBCHEN_SHIFT are not used now, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: (Base on Markus' comment) remove unused BBCH_BBCHEN_* in tps65910.h.
 drivers/regulator/tps65910-regulator.c | 16 +---------------
 include/linux/mfd/tps65910.h           |  2 --
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 979ea0a..f50dd84 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1207,21 +1207,7 @@ static int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 		pmic->desc[i].enable_reg = pmic->get_ctrl_reg(i);
-
-		switch (i) {
-		case TPS65910_REG_VBB:
-			if (tps65910_chip_id(tps65910) == TPS65910)
-				pmic->desc[i].enable_mask = BBCH_BBCHEN_MASK;
-			else
-				pmic->desc[i].enable_mask =
-					TPS65910_SUPPLY_STATE_ENABLED;
-			break;
-
-		default:
-			pmic->desc[i].enable_mask =
-				TPS65910_SUPPLY_STATE_ENABLED;
-			break;
-		}
+		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
 
 		config.dev = tps65910->dev;
 		config.init_data = reg_data;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 1adeee1..16c2335 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -358,8 +358,6 @@
 /*Register BBCH  (0x80) register.RegisterDescription */
 #define BBCH_BBSEL_MASK					0x06
 #define BBCH_BBSEL_SHIFT				1
-#define BBCH_BBCHEN_MASK				0x01
-#define BBCH_BBCHEN_SHIFT				0
 
 
 /*Register DCDCCTRL  (0x80) register.RegisterDescription */
-- 
1.8.1.2



