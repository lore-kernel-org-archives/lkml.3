Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063Ab3IDGtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:49:00 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40392 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab3IDGs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:48:58 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Subject: [PATCH 1/7] regulator: anatop-regulator: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:00:57 +0530
Message-Id: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This series is compile tested.
---
 drivers/regulator/anatop-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 0d4a8cc..e42bfd1 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -200,7 +200,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	config.regmap = sreg->anatop;
 
 	/* register regulator */
-	rdev = regulator_register(rdesc, &config);
+	rdev = devm_regulator_register(dev, rdesc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(dev, "failed to register %s\n",
 			rdesc->name);
@@ -223,7 +223,6 @@ static int anatop_regulator_remove(struct platform_device *pdev)
 	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
 	const char *name = sreg->name;
 
-	regulator_unregister(rdev);
 	kfree(name);
 
 	return 0;
-- 
1.7.9.5

