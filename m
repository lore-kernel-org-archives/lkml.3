Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781Ab3BYLeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:34:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab3BYLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:34:14 -0500
Date: Mon, 25 Feb 2013 12:34:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: tps6586x: (cosmetic) simplify a conditional
Message-ID: <Pine.LNX.4.64.1302251232260.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:57JQqzh081YZZXPGfhBRPqJKw5M76CBESua3tmULn/z
 dZQQRWPQl0s0vhYxXCrGQLe198boyF6DEUHgs3ioDAr9poNkjT
 dOb/IvZ3pf/+mQTJkTbWogw9rmWCTkZFiC593Hab9tV7xUDYsv
 naoCa7rQxFI17dNspwIJaWduDkT8E0OGLFVXPsBtW7KOmPhE1V
 gUHDFpqjVwTr6Zd1ch2wSwUHY+UiUK7HLVRE+fskSYYKVAamlq
 unkxEXjt0q7u+w1Dd41v+oJnZ0nVG49zU20QFpweVIIOY29NUf
 7A4CE54YCpWMqXV6YOTBD6B2Kl/wJ9e1MK5aPaZoRkpdsMD7vJ
 R8jOq72zOaqpU1iDZeeArnwvy/GPpw1ZtE615P1RCT5BPZ0xsB
 uogqHUU5lleZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_node_put() is called on either branch of a conditional, simplify the
code by only calling it once.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/tps6586x-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index f86da67..1471ead 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -338,14 +338,12 @@ static struct tps6586x_platform_data *tps6586x_parse_regulator_dt(
 	}
 
 	err = of_regulator_match(&pdev->dev, regs, tps6586x_matches, num);
+	of_node_put(regs);
 	if (err < 0) {
 		dev_err(&pdev->dev, "Regulator match failed, e %d\n", err);
-		of_node_put(regs);
 		return NULL;
 	}
 
-	of_node_put(regs);
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
 		dev_err(&pdev->dev, "Memory alloction failed\n");
-- 
1.7.2.5

