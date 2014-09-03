Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaICBPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:15:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46022 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaICBPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:15:35 -0400
Message-ID: <1409706930.12827.1.camel@phoenix>
Subject: [PATCH] regulator: da9211: Fix missing config.of_node setting
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: James Ban <james.ban.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 03 Sep 2014 09:15:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9211-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 9722728..044c36c 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -364,6 +364,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 		config.dev = chip->dev;
 		config.driver_data = chip;
 		config.regmap = chip->regmap;
+		config.of_node = chip->dev->of_node;
 
 		chip->rdev[i] = devm_regulator_register(chip->dev,
 			&da9211_regulators[i], &config);
-- 
1.9.1



