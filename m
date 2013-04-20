Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3DTQhC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:37:02 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37941 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3DTQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:37:00 -0400
Message-ID: <1366475816.7038.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp3972: Convert to use
 regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 21 Apr 2013 00:36:56 +0800
In-Reply-To: <1366475731.7038.1.camel@phoenix>
References: <1366475731.7038.1.camel@phoenix>
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
 drivers/regulator/lp3972.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 0baabcf..61e4cf9 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -309,6 +309,7 @@ static int lp3972_ldo_set_voltage_sel(struct regulator_dev *dev,
 
 static struct regulator_ops lp3972_ldo_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.is_enabled = lp3972_ldo_is_enabled,
 	.enable = lp3972_ldo_enable,
 	.disable = lp3972_ldo_disable,
@@ -389,6 +390,7 @@ static int lp3972_dcdc_set_voltage_sel(struct regulator_dev *dev,
 
 static struct regulator_ops lp3972_dcdc_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.is_enabled = lp3972_dcdc_is_enabled,
 	.enable = lp3972_dcdc_enable,
 	.disable = lp3972_dcdc_disable,
-- 
1.7.10.4



