Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968128Ab3E3KZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:25:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44939 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968062Ab3E3KZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:25:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <balbi@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH] regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10
Date: Thu, 30 May 2013 15:55:09 +0530
Message-ID: <1369909509-25394-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_enable_regmap() uses enable_reg to enable the regulator.
But enable_reg for smps10 points to SMPS10_STATUS which is a
read-only register. Fixed the same by having enable_reg
set to SMPS10_CTRL.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 92ceed0..87d4f13 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -878,7 +878,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
-- 
1.7.10.4

