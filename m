Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3DDLNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:13:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56538 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659Ab3DDLNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:13:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm8994: Convert to module_platform_driver()
Date: Thu,  4 Apr 2013 12:12:55 +0100
Message-Id: <1365073975-30998-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators can only be used to supply the CODEC so we don't need to
worry about users that still need fudges for init ordering issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 6ff8723..5115881 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -162,23 +162,7 @@ static struct platform_driver wm8994_ldo_driver = {
 	},
 };
 
-static int __init wm8994_ldo_init(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&wm8994_ldo_driver);
-	if (ret != 0)
-		pr_err("Failed to register Wm8994 GP LDO driver: %d\n", ret);
-
-	return ret;
-}
-subsys_initcall(wm8994_ldo_init);
-
-static void __exit wm8994_ldo_exit(void)
-{
-	platform_driver_unregister(&wm8994_ldo_driver);
-}
-module_exit(wm8994_ldo_exit);
+module_platform_driver(wm8994_ldo_driver);
 
 /* Module information */
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
-- 
1.7.10.4

