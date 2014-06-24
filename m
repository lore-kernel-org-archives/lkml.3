Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaFXI2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:28:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54804 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaFXI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:28:01 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: ldewangan@nvidia.com, broonie@kernel.org, lgirdwood@gmail.com,
        spk.linux@gmail.com
Subject: [PATCH 1/1] regulator: as3722: Fix incorrect parameter initialization
Date: Tue, 24 Jun 2014 13:54:43 +0530
Message-Id: <1403598283-21099-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'name' field was re-initialized and getting overwritten in some
cases possibly due to a typo. Code inspection says the second time
it should be 'sname' instead of 'name'. Replace it.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
Compile tested only.
---
 drivers/regulator/as3722-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index ad9e0c9b7daf..b68f05f38537 100644
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
1.7.9.5

