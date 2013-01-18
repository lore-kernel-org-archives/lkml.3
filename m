Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3ARD7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:59:39 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34067 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3ARD7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:59:37 -0500
Message-ID: <1358481572.25899.7.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm8994: Merge wm8994_ldo1_ops and
 wm8994_ldo2_ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 11:59:32 +0800
In-Reply-To: <1358481513.25899.6.camel@phoenix>
References: <1358481513.25899.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8994_ldo1_ops and wm8994_ldo2_ops are the same after converting
wm8994_ldo2_ops to use regulator_list_voltage_linear, merge them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/wm8994-regulator.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index fef2692..98edfe0 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -32,14 +32,7 @@ struct wm8994_ldo {
 #define WM8994_LDO1_MAX_SELECTOR 0x7
 #define WM8994_LDO2_MAX_SELECTOR 0x3
 
-static struct regulator_ops wm8994_ldo1_ops = {
-	.list_voltage = regulator_list_voltage_linear,
-	.map_voltage = regulator_map_voltage_linear,
-	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-};
-
-static struct regulator_ops wm8994_ldo2_ops = {
+static struct regulator_ops wm8994_ldo_ops = {
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
@@ -54,7 +47,7 @@ static struct regulator_desc wm8994_ldo_desc[] = {
 		.n_voltages = WM8994_LDO1_MAX_SELECTOR + 1,
 		.vsel_reg = WM8994_LDO_1,
 		.vsel_mask = WM8994_LDO1_VSEL_MASK,
-		.ops = &wm8994_ldo1_ops,
+		.ops = &wm8994_ldo_ops,
 		.min_uV = 2400000,
 		.uV_step = 100000,
 		.enable_time = 3000,
@@ -67,7 +60,7 @@ static struct regulator_desc wm8994_ldo_desc[] = {
 		.n_voltages = WM8994_LDO2_MAX_SELECTOR + 1,
 		.vsel_reg = WM8994_LDO_2,
 		.vsel_mask = WM8994_LDO2_VSEL_MASK,
-		.ops = &wm8994_ldo2_ops,
+		.ops = &wm8994_ldo_ops,
 		.enable_time = 3000,
 		.owner = THIS_MODULE,
 	},
-- 
1.7.9.5



