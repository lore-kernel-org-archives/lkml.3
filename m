Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaI3DKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:10:55 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.167]:34050 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbaI3DKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:10:53 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-15.tower-39.messagelabs.com!1412046636!21854481!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201409300310.s8U3AUfe031634@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Mon, 29 Sep 2014 16:59:20 +0900
Subject: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for fixing a bug about mask bit operation.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140926.

 drivers/regulator/da9211-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index f47adf3..c78d210 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -376,7 +376,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 
 		if (chip->chip_irq != 0) {
 			ret = regmap_update_bits(chip->regmap,
-				DA9211_REG_MASK_B, DA9211_M_OV_CURR_A << i, 1);
+				DA9211_REG_MASK_B, DA9211_M_OV_CURR_A << i, 0);
 			if (ret < 0) {
 				dev_err(chip->dev,
 					"Failed to update mask reg: %d\n", ret);
-- 
end-of-patch for regulator: DA9211 : Fix a bug in update of mask bit V1

