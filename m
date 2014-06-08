Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaFHOrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 10:47:16 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54065 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaFHOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 10:47:15 -0400
Message-ID: <1402238830.32652.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Remove
 ab8500_regulator_debug_init/exit()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 08 Jun 2014 22:47:10 +0800
In-Reply-To: <1402238742.32652.1.camel@phoenix>
References: <1402238742.32652.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_REGULATOR_AB8500_DEBUG is always not defined.
ab8500_regulator_debug_init() is not called at all now,
ab8500_regulator_debug_exit() simply return 0, thus remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c       | 13 -------------
 include/linux/regulator/ab8500.h | 14 --------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 88da8626..1fda14e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3071,21 +3071,8 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ab8500_regulator_remove(struct platform_device *pdev)
-{
-	int err;
-
-	/* remove regulator debug */
-	err = ab8500_regulator_debug_exit(pdev);
-	if (err)
-		return err;
-
-	return 0;
-}
-
 static struct platform_driver ab8500_regulator_driver = {
 	.probe = ab8500_regulator_probe,
-	.remove = ab8500_regulator_remove,
 	.driver         = {
 		.name   = "ab8500-regulator",
 		.owner  = THIS_MODULE,
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7530744..d8ecefa 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -322,18 +322,4 @@ struct ab8500_regulator_platform_data {
 	struct regulator_init_data *ext_regulator;
 };
 
-#ifdef CONFIG_REGULATOR_AB8500_DEBUG
-int ab8500_regulator_debug_init(struct platform_device *pdev);
-int ab8500_regulator_debug_exit(struct platform_device *pdev);
-#else
-static inline int ab8500_regulator_debug_init(struct platform_device *pdev)
-{
-	return 0;
-}
-static inline int ab8500_regulator_debug_exit(struct platform_device *pdev)
-{
-	return 0;
-}
-#endif
-
 #endif
-- 
1.8.3.2



