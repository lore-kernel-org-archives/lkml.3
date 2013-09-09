Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3IILtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:49:35 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:40876 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3IILte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:49:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] regulator: da9063: Add missing initialization of da9063_reg_matches
Date: Mon,  9 Sep 2013 13:49:27 +0200
Message-Id: <1378727367-8941-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378727367-8941-1-git-send-email-geert@linux-m68k.org>
References: <1378727367-8941-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.1.2:

drivers/regulator/da9063-regulator.c: In function ‘da9063_regulator_probe’:
drivers/regulator/da9063-regulator.c:847: warning: ‘da9063_reg_matches’ is used
uninitialized in this function

If the parent device already has platform data, da9063_reg_matches will
not be initialized.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Can this happen? Or will any of the b*_merged flags be set in this case, so
the while loop continues and we never get to the place where
da9063_reg_matches is used? The code is too convoluted for me to see...

 drivers/regulator/da9063-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index b9f2653..3d910f4 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -717,7 +717,7 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 {
 	struct da9063 *da9063 = dev_get_drvdata(pdev->dev.parent);
 	struct da9063_pdata *da9063_pdata = dev_get_platdata(da9063->dev);
-	struct of_regulator_match *da9063_reg_matches;
+	struct of_regulator_match *da9063_reg_matches = NULL;
 	struct da9063_regulators_pdata *regl_pdata;
 	const struct da9063_dev_model *model;
 	struct da9063_regulators *regulators;
-- 
1.7.9.5

