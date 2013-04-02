Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3DBAkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:40:00 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62842 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3DBAj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:39:58 -0400
Message-ID: <1364863193.15806.3.camel@phoenix>
Subject: [PATCH RFT] regulator: ab8500: Fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 08:39:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes 'delay' field which does not exist in struct
ab8500_regulator_info. ( The 'delay' field was removed because fixed regulator
does not need to implement set_voltage_time_sel. )
Fix missing semicolon and declare match_size to fix below build error.
Also setup match pointer and match_size for ab8505 and ab8540.

  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c:825:3: error: unknown field 'delay' specified in initializer
drivers/regulator/ab8500.c:825:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/regulator/ab8500.c:825:3: warning: (near initialization for 'ab8505_regulator_info[7].regulator') [enabled by default]
drivers/regulator/ab8500.c:1067:3: error: unknown field 'delay' specified in initializer
drivers/regulator/ab8500.c:1067:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/regulator/ab8500.c:1067:3: warning: (near initialization for 'ab9540_regulator_info[5].regulator') [enabled by default]
drivers/regulator/ab8500.c:1309:3: error: unknown field 'delay' specified in initializer
drivers/regulator/ab8500.c:1309:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/regulator/ab8500.c:1309:3: warning: (near initialization for 'ab8540_regulator_info[5].regulator') [enabled by default]
drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
drivers/regulator/ab8500.c:2703:3: error: 'match_size' undeclared (first use in this function)
drivers/regulator/ab8500.c:2703:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/regulator/ab8500.c:2704:2: error: expected ';' before '}' token
drivers/regulator/ab8500.c:2721:2: error: expected ';' before '}' token
drivers/regulator/ab8500.c:2747:8: warning: assignment from incompatible pointer type [enabled by default]
drivers/regulator/ab8500.c: At top level:
drivers/regulator/ab8500.c:2619:34: warning: 'ab8505_regulator_match' defined but not used [-Wunused-variable]
drivers/regulator/ab8500.c:2635:34: warning: 'ab8540_regulator_match' defined but not used [-Wunused-variable]
make[2]: *** [drivers/regulator/ab8500.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 16f5cf7..09eea32 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -822,7 +822,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1064,7 +1063,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1306,7 +1304,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -2692,7 +2689,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	struct ab8500_regulator_info *regulator_info;
 	int regulator_info_size;
 	struct ab8500_reg_init *reg_init;
-	int reg_init_size;
+	int reg_init_size, match_size;
 
 	if (is_ab9540(ab8500)) {
 		regulator_info = ab9540_regulator_info;
@@ -2700,24 +2697,28 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		reg_init = ab9540_reg_init;
 		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
 		match = ab9540_regulator_match;
-		match_size = ARRAY_SIZE(ab9540_regulator_match)
+		match_size = ARRAY_SIZE(ab9540_regulator_match);
 	} else if (is_ab8505(ab8500)) {
 		regulator_info = ab8505_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
 		reg_init = ab8505_reg_init;
 		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
+		match = ab8505_regulator_match;
+		match_size = ARRAY_SIZE(ab8505_regulator_match);
 	} else if (is_ab8540(ab8500)) {
 		regulator_info = ab8540_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
 		reg_init = ab8540_reg_init;
 		reg_init_size = AB8540_NUM_REGULATOR_REGISTERS;
+		match = ab8540_regulator_match;
+		match_size = ARRAY_SIZE(ab8540_regulator_match);
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
 		reg_init = ab8500_reg_init;
 		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
 		match = ab8500_regulator_match;
-		match_size = ARRAY_SIZE(ab8500_regulator_match)
+		match_size = ARRAY_SIZE(ab8500_regulator_match);
 	}
 
 	if (np) {
-- 
1.7.10.4



