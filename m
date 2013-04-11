Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936363Ab3DKPTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:19:45 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51988 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936073Ab3DKPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:19:44 -0400
Message-ID: <1365693578.4218.2.camel@phoenix>
Subject: [RESEND][PATCH 2/3] regulator: twl: Convert fixed voltage to use
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 23:19:38 +0800
In-Reply-To: <1365693520.4218.1.camel@phoenix>
References: <1365693520.4218.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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
1.7.10.4



