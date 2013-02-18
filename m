Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3BRC6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 21:58:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56748 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3BRC6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 21:58:08 -0500
Message-ID: <1361156277.24231.1.camel@phoenix>
Subject: [RFT][PATCH 1/2] regulator: ab8500: Fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 10:57:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This build error is introduced by commit 6a9fe8319
"regulator: ab8500: Added get_optimum_mode on regulators with idle mode".

  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c:500:23: error: 'ab8500_regulator_fixed_ops' undeclared here (not in a function)
drivers/regulator/ab8500.c:510:3: error: unknown field 'update_val_enable' specified in initializer
make[2]: *** [drivers/regulator/ab8500.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index d0ce436..ffabff7 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -494,10 +494,13 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
+	/*
+	 * Regulators with fixed voltage and normal mode
+	 */
 	[AB8500_LDO_USB] = {
 		.desc = {
 			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_fixed_ops,
+			.ops            = &ab8500_regulator_ops,
 			.type           = REGULATOR_VOLTAGE,
 			.id             = AB8500_LDO_USB,
 			.owner          = THIS_MODULE,
@@ -507,12 +510,8 @@ static struct ab8500_regulator_info
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
-		.update_val_enable      = 0x01,
+		.update_val             = 0x01,
 	},
-
-	/*
-	 * Regulators with fixed voltage and normal mode
-	 */
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
-- 
1.7.9.5



