Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3DYDbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 23:31:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50445 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3DYDbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 23:31:49 -0400
Message-ID: <1366860702.18788.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: tps65023: Merge tps65020 ldo1 and ldo2 vsel
 table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Thu, 25 Apr 2013 11:31:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tps65020 ldo1 and ldo2 vsel tables are identical, merge them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65023-regulator.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 21a890a..42fea2c 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -107,12 +107,7 @@ static const unsigned int DCDC_FIXED_1800000_VSEL_table[] = {
 };
 
 /* Supported voltage values for LDO regulators for tps65020 */
-static const unsigned int TPS65020_LDO1_VSEL_table[] = {
-	1000000, 1050000, 1100000, 1300000,
-	1800000, 2500000, 3000000, 3300000,
-};
-
-static const unsigned int TPS65020_LDO2_VSEL_table[] = {
+static const unsigned int TPS65020_LDO_VSEL_table[] = {
 	1000000, 1050000, 1100000, 1300000,
 	1800000, 2500000, 3000000, 3300000,
 };
@@ -334,13 +329,13 @@ static const struct tps_info tps65020_regs[] = {
 	},
 	{
 		.name = "LDO1",
-		.table_len = ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
-		.table = TPS65020_LDO1_VSEL_table,
+		.table_len = ARRAY_SIZE(TPS65020_LDO_VSEL_table),
+		.table = TPS65020_LDO_VSEL_table,
 	},
 	{
 		.name = "LDO2",
-		.table_len = ARRAY_SIZE(TPS65020_LDO2_VSEL_table),
-		.table = TPS65020_LDO2_VSEL_table,
+		.table_len = ARRAY_SIZE(TPS65020_LDO_VSEL_table),
+		.table = TPS65020_LDO_VSEL_table,
 	},
 };
 
-- 
1.7.10.4



