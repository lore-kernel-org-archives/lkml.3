Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3CYGyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:54:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52550 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3CYGyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:54:09 -0400
Message-ID: <1364194430.25717.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: ab8500: Fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 14:53:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c:500:23: error: 'ab8500_regulator_fixed_ops' undeclared here (not in a function)
drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
drivers/regulator/ab8500.c:972:8: warning: assignment from incompatible pointer type [enabled by default]
make[2]: *** [drivers/regulator/ab8500.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f7d1f53..a2d19c6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -494,10 +494,14 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
+
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
@@ -508,10 +512,6 @@ static struct ab8500_regulator_info
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
 	},
-
-	/*
-	 * Regulators with fixed voltage and normal mode
-	 */
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
-- 
1.7.10.4



