Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3DXMpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:45:42 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54628 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3DXMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:45:41 -0400
Message-ID: <1366807537.16547.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp8788-buck: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Apr 2013 20:45:37 +0800
In-Reply-To: <1366807487.16547.3.camel@phoenix>
References: <1366807487.16547.3.camel@phoenix>
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
 drivers/regulator/lp8788-buck.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 97891a7..eb1e1e8 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -346,6 +346,7 @@ static unsigned int lp8788_buck_get_mode(struct regulator_dev *rdev)
 
 static struct regulator_ops lp8788_buck12_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = lp8788_buck12_set_voltage_sel,
 	.get_voltage_sel = lp8788_buck12_get_voltage_sel,
 	.enable = regulator_enable_regmap,
@@ -358,6 +359,7 @@ static struct regulator_ops lp8788_buck12_ops = {
 
 static struct regulator_ops lp8788_buck34_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.enable = regulator_enable_regmap,
-- 
1.7.10.4



