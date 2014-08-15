Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaHOLJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:09:52 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53280 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHOLJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:09:51 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, ldewangan@nvidia.com
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH] regulator: as3722: .name field initialized twice differently
Date: Fri, 15 Aug 2014 12:09:44 +0100
Message-Id: <1408100984-11757-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator AS3722_REGULATOR_ID_LDO3 and AS3722_REGULATOR_ID_LDO4
have there .name field initialised twice with different values.

Looking at the code the second entry should have been .sname
which is what this patch corrects.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/regulator/as3722-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index ad9e0c9..b68f05f 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -219,7 +219,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 	{
 		.regulator_id = AS3722_REGULATOR_ID_LDO3,
 		.name = "as3722-ldo3",
-		.name = "vin-ldo3-4",
+		.sname = "vin-ldo3-4",
 		.vsel_reg = AS3722_LDO3_VOLTAGE_REG,
 		.vsel_mask = AS3722_LDO3_VSEL_MASK,
 		.enable_reg = AS3722_LDOCONTROL0_REG,
@@ -231,7 +231,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 	{
 		.regulator_id = AS3722_REGULATOR_ID_LDO4,
 		.name = "as3722-ldo4",
-		.name = "vin-ldo3-4",
+		.sname = "vin-ldo3-4",
 		.vsel_reg = AS3722_LDO4_VOLTAGE_REG,
 		.vsel_mask = AS3722_LDO_VSEL_MASK,
 		.enable_reg = AS3722_LDOCONTROL0_REG,
-- 
1.9.1

