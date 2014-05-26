Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaEZJ4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:56:20 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42200 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaEZJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:56:19 -0400
Message-ID: <1401098173.12646.1.camel@phoenix>
Subject: [RFT][PATCH] regulator: pfuze100: Support enable/disable for fixed
 regulator
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 17:56:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has .enable_reg and .enable_mask settings, but the implementation
for corresponding callbacks are missing. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Robin,
Can you review and test this patch?
Thanks,
Axel

 drivers/regulator/pfuze100-regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 67e678c..b6b4529 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -125,6 +125,9 @@ static struct regulator_ops pfuze100_ldo_regulator_ops = {
 };
 
 static struct regulator_ops pfuze100_fixed_regulator_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.list_voltage = regulator_list_voltage_linear,
 };
 
-- 
1.8.3.2



