Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3JBMtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:49:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52945 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3JBMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:49:34 -0400
Message-ID: <1380718169.7307.3.camel@phoenix>
Subject: [PATCH v2 2/2] regulator: as3722: Fix off-by-one n_voltages setting
 for SDx
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 20:49:29 +0800
In-Reply-To: <1380718076.7307.1.camel@phoenix>
References: <1380718076.7307.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AS3722_SDx_VSEL_MAX means the maximum selecter, the n_voltages should be
AS3722_SDx_VSEL_MAX + 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
---
v2: no code change, add Laxman's Ack.

 drivers/regulator/as3722-regulator.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 01a8b17..d7b71a9 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -99,7 +99,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD0_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD0_CONTROL_REG,
 		.mode_mask = AS3722_SD0_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX,
+		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD1,
@@ -112,7 +112,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD1_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD1_CONTROL_REG,
 		.mode_mask = AS3722_SD1_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX,
+		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD2,
@@ -126,7 +126,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD2_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD23_CONTROL_REG,
 		.mode_mask = AS3722_SD2_MODE_FAST,
-		.n_voltages = AS3722_SD2_VSEL_MAX,
+		.n_voltages = AS3722_SD2_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD3,
@@ -140,7 +140,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD3_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD23_CONTROL_REG,
 		.mode_mask = AS3722_SD3_MODE_FAST,
-		.n_voltages = AS3722_SD2_VSEL_MAX,
+		.n_voltages = AS3722_SD2_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD4,
@@ -154,7 +154,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD4_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD4_CONTROL_REG,
 		.mode_mask = AS3722_SD4_MODE_FAST,
-		.n_voltages = AS3722_SD2_VSEL_MAX,
+		.n_voltages = AS3722_SD2_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD5,
@@ -168,7 +168,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD5_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD5_CONTROL_REG,
 		.mode_mask = AS3722_SD5_MODE_FAST,
-		.n_voltages = AS3722_SD2_VSEL_MAX,
+		.n_voltages = AS3722_SD2_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_SD6,
@@ -181,7 +181,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
 		.sleep_ctrl_mask = AS3722_SD6_EXT_ENABLE_MASK,
 		.control_reg = AS3722_SD6_CONTROL_REG,
 		.mode_mask = AS3722_SD6_MODE_FAST,
-		.n_voltages = AS3722_SD0_VSEL_MAX,
+		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
 	},
 	{
 		.regulator_id = AS3722_REGULATOR_ID_LDO0,
-- 
1.8.1.2



