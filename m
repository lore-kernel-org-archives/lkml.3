Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3H3MIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:08:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51452 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3H3MIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:08:47 -0400
Message-ID: <1377864522.12097.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: da9063: Use IS_ERR to check return value of
 regulator_register()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 20:08:42 +0800
In-Reply-To: <1377864458.12097.2.camel@phoenix>
References: <1377864458.12097.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_register() does not return NULL, it returns ERR_PTR on error.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9063-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index f29e729..139ad45 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -848,7 +848,7 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 			config.of_node = da9063_reg_matches[id].of_node;
 		config.regmap = da9063->regmap;
 		regl->rdev = regulator_register(&regl->desc, &config);
-		if (IS_ERR_OR_NULL(regl->rdev)) {
+		if (IS_ERR(regl->rdev)) {
 			dev_err(&pdev->dev,
 				"Failed to register %s regulator\n",
 				regl->desc.name);
-- 
1.8.1.2



