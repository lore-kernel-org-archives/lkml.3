Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3FQSB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:01:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3FQRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 05/84] regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10
Date: Mon, 17 Jun 2013 10:30:09 -0700
Message-Id: <1371490288-23167-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit f232168df0c7e7414b70ac5d8fed83086d441c0b upstream.

regulator_enable_regmap() uses enable_reg to enable the regulator.
But enable_reg for smps10 points to SMPS10_STATUS which is a
read-only register. Fixed the same by having enable_reg
set to SMPS10_CTRL.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/regulator/palmas-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index c9e912f..3e82c81 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -679,7 +679,7 @@ static int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
-- 
1.8.1.2

