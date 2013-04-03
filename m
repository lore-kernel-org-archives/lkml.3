Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab3DCCdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:33:32 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52660 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3DCCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:33:31 -0400
Message-ID: <1364956405.1328.4.camel@phoenix>
Subject: [PATCH 3/4] regulator: ab8500: Fix 'match_size' undeclared and
 missing semicolon
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 10:33:25 +0800
In-Reply-To: <1364956243.1328.1.camel@phoenix>
References: <1364956243.1328.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build errors:
  CC      drivers/regulator/ab8500.o
drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
drivers/regulator/ab8500.c:3018:3: error: 'match_size' undeclared (first use in this function)
drivers/regulator/ab8500.c:3018:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/regulator/ab8500.c:3019:2: error: expected ';' before '}' token
drivers/regulator/ab8500.c:3036:2: error: expected ';' before '}' token

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index bdd17e6..73d84d8 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3007,7 +3007,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	struct ab8500_regulator_info *regulator_info;
 	int regulator_info_size;
 	struct ab8500_reg_init *reg_init;
-	int reg_init_size;
+	int reg_init_size, match_size;
 
 	if (is_ab9540(ab8500)) {
 		regulator_info = ab9540_regulator_info;
@@ -3015,7 +3015,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		reg_init = ab9540_reg_init;
 		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
 		match = ab9540_regulator_match;
-		match_size = ARRAY_SIZE(ab9540_regulator_match)
+		match_size = ARRAY_SIZE(ab9540_regulator_match);
 	} else if (is_ab8505(ab8500)) {
 		regulator_info = ab8505_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
@@ -3032,7 +3032,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		reg_init = ab8500_reg_init;
 		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
 		match = ab8500_regulator_match;
-		match_size = ARRAY_SIZE(ab8500_regulator_match)
+		match_size = ARRAY_SIZE(ab8500_regulator_match);
 	}
 
 	if (np) {
-- 
1.7.10.4



