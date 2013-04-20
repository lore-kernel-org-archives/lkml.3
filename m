Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663Ab3DTCaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 22:30:24 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:35861 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965552Ab3DTCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 22:30:23 -0400
Message-ID: <1366425017.8200.1.camel@phoenix>
Subject: [PATCH] regulator: tps65910: Convert to use
 regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Date: Sat, 20 Apr 2013 10:30:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All regulators have ascendant voltage list in this driver.
Some regulators have more than 200 supported voltages.
e.g.
For TPS65910_REG_VDD1 and TPS65910_REG_VDD2:
n_voltages = VDD1_2_NUM_VOLT_FINE * VDD1_2_NUM_VOLT_COARSE
           = 73 * 3
           = 219

Thus it worth converting to regulator_map_voltage_ascend rather than use
default regulator_map_voltage_iterate.

For consistent, convert all regulators to regulator_map_voltage_ascend.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65910-regulator.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 6ba6931..45c1644 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -748,6 +748,7 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.set_voltage_sel	= tps65910_set_voltage_dcdc_sel,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.list_voltage		= tps65910_list_voltage_dcdc,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops tps65910_ops_vdd3 = {
@@ -758,6 +759,7 @@ static struct regulator_ops tps65910_ops_vdd3 = {
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_vdd3,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops tps65910_ops = {
@@ -769,6 +771,7 @@ static struct regulator_ops tps65910_ops = {
 	.get_voltage_sel	= tps65910_get_voltage_sel,
 	.set_voltage_sel	= tps65910_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops tps65911_ops = {
@@ -780,6 +783,7 @@ static struct regulator_ops tps65911_ops = {
 	.get_voltage_sel	= tps65911_get_voltage_sel,
 	.set_voltage_sel	= tps65911_set_voltage_sel,
 	.list_voltage		= tps65911_list_voltage,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
-- 
1.7.10.4



