Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708Ab3DTDfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 23:35:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42347 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965593Ab3DTDfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 23:35:20 -0400
Message-ID: <1366428913.17937.1.camel@phoenix>
Subject: [PATCH] regulator: tps6586x: Convert to use
 regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 20 Apr 2013 11:35:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All regulators have ascendant voltage list in this driver.
Thus use regulator_map_voltage_ascend is more efficient than the default
regulator_map_voltage_iterate.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index b813d21..d8fa37d 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -70,6 +70,7 @@ static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 
 static struct regulator_ops tps6586x_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 
-- 
1.7.10.4



