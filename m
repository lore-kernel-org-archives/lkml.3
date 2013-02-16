Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3BPChm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:37:42 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60334 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3BPChl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:37:41 -0500
Message-ID: <1360982253.6332.3.camel@phoenix>
Subject: [PATCH] regulator: twl: Convert fixed voltage to use
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 10:37:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index d62604c0..2b3dc5b 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -612,15 +612,8 @@ static struct regulator_ops twl6030ldo_ops = {
 /*
  * Fixed voltage LDOs don't have a VSEL field to update.
  */
-static int twlfixed_list_voltage(struct regulator_dev *rdev, unsigned index)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return info->min_mV * 1000;
-}
-
 static struct regulator_ops twl4030fixed_ops = {
-	.list_voltage	= twlfixed_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
@@ -632,7 +625,7 @@ static struct regulator_ops twl4030fixed_ops = {
 };
 
 static struct regulator_ops twl6030fixed_ops = {
-	.list_voltage	= twlfixed_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
@@ -935,6 +928,7 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 		.name = #label, \
 		.id = family##_REG_##label, \
 		.n_voltages = 1, \
+		.min_uV = mVolts * 1000, \
 		.ops = &operations, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
-- 
1.7.9.5



