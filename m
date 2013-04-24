Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3DXMox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:44:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39797 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3DXMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:44:52 -0400
Message-ID: <1366807487.16547.3.camel@phoenix>
Subject: [PATCH 1/2] regulator: lp872x: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Apr 2013 20:44:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All regulators have ascendant voltage list in this driver.
Use regulator_map_voltage_ascend for them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp872x.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 8e3c7ae..f5fc4a1 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -478,6 +478,7 @@ static unsigned int lp872x_buck_get_mode(struct regulator_dev *rdev)
 
 static struct regulator_ops lp872x_ldo_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.enable = regulator_enable_regmap,
@@ -488,6 +489,7 @@ static struct regulator_ops lp872x_ldo_ops = {
 
 static struct regulator_ops lp8720_buck_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = lp872x_buck_set_voltage_sel,
 	.get_voltage_sel = lp872x_buck_get_voltage_sel,
 	.enable = regulator_enable_regmap,
@@ -500,6 +502,7 @@ static struct regulator_ops lp8720_buck_ops = {
 
 static struct regulator_ops lp8725_buck_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = lp872x_buck_set_voltage_sel,
 	.get_voltage_sel = lp872x_buck_get_voltage_sel,
 	.enable = regulator_enable_regmap,
-- 
1.7.10.4



