Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3DKEEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:04:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52720 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3DKEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:04:24 -0400
Message-ID: <1365653058.17060.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: ab8500-ext: Make the return type of
 ab8500_ext_regulator_exit() void
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 12:04:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ab8500_ext_regulator_exit() never fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c   |    4 +---
 drivers/regulator/ab8500.c       |    9 +++------
 include/linux/regulator/ab8500.h |    2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index dd582be..861ab04 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -385,7 +385,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 	return 0;
 }
 
-int ab8500_ext_regulator_exit(struct platform_device *pdev)
+void ab8500_ext_regulator_exit(struct platform_device *pdev)
 {
 	int i;
 
@@ -398,8 +398,6 @@ int ab8500_ext_regulator_exit(struct platform_device *pdev)
 
 		regulator_unregister(info->rdev);
 	}
-
-	return 0;
 }
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 9ebd131..c200f8b 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3194,12 +3194,9 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 		regulator_unregister(info->regulator);
 	}
 
-	if (!is_ab8505(ab8500)) {
-		/* remove external regulators (after Vaux1, 2 and 3) */
-		err = ab8500_ext_regulator_exit(pdev);
-		if (err)
-			return err;
-	}
+	/* remove external regulators (after Vaux1, 2 and 3) */
+	if (!is_ab8505(ab8500))
+		ab8500_ext_regulator_exit(pdev);
 
 	/* remove regulator debug */
 	err = ab8500_regulator_debug_exit(pdev);
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 90b8b5a..7c5ff0c 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -338,6 +338,6 @@ static inline int ab8500_regulator_debug_exit(struct platform_device *pdev)
 
 /* AB8500 external regulator functions. */
 int ab8500_ext_regulator_init(struct platform_device *pdev);
-int ab8500_ext_regulator_exit(struct platform_device *pdev);
+void ab8500_ext_regulator_exit(struct platform_device *pdev);
 
 #endif
-- 
1.7.10.4



