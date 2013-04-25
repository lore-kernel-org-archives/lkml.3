Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3DYDcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 23:32:47 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41540 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3DYDcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 23:32:46 -0400
Message-ID: <1366860760.18788.2.camel@phoenix>
Subject: [PATCH 2/3] regulator: tps65023: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Thu, 25 Apr 2013 11:32:40 +0800
In-Reply-To: <1366860702.18788.1.camel@phoenix>
References: <1366860702.18788.1.camel@phoenix>
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
 drivers/regulator/tps65023-regulator.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 42fea2c..9d053e2 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -180,6 +180,7 @@ static struct regulator_ops tps65023_dcdc_ops = {
 	.get_voltage_sel = tps65023_dcdc_get_voltage_sel,
 	.set_voltage_sel = tps65023_dcdc_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 };
 
 /* Operations permitted on LDOx */
@@ -190,6 +191,7 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 };
 
 static struct regmap_config tps65023_regmap_config = {
-- 
1.7.10.4



