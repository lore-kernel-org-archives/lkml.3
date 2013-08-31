Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3HaL3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40113 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3HaL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:37 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:19 +0100
Message-Id: <1377948564-8383-4-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 04/11] regulator: s2mps11: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/s2mps11.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 5eba2ff..d7c241e 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -453,28 +453,11 @@ common_reg:
 			ret = PTR_ERR(s2mps11->rdev[i]);
 			dev_err(&pdev->dev, "regulator init failed for %d\n",
 				i);
-			s2mps11->rdev[i] = NULL;
-			goto err;
+			return ret;
 		}
 	}
 
 	return 0;
-err:
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++)
-		regulator_unregister(s2mps11->rdev[i]);
-
-	return ret;
-}
-
-static int s2mps11_pmic_remove(struct platform_device *pdev)
-{
-	struct s2mps11_info *s2mps11 = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++)
-		regulator_unregister(s2mps11->rdev[i]);
-
-	return 0;
 }
 
 static const struct platform_device_id s2mps11_pmic_id[] = {
@@ -489,7 +472,6 @@ static struct platform_driver s2mps11_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = s2mps11_pmic_probe,
-	.remove = s2mps11_pmic_remove,
 	.id_table = s2mps11_pmic_id,
 };
 
-- 
1.8.4.rc3

