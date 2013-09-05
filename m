Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3IEEJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:09:58 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39122 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3IEEJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:09:56 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org
Subject: [PATCH 2/2] regulator: Remove redundant NULL assignment
Date: Thu,  5 Sep 2013 09:22:03 +0530
Message-Id: <1378353123-29604-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378353123-29604-1-git-send-email-sachin.kamat@linaro.org>
References: <1378353123-29604-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL assignment corrupts the error pointer and is not
necessary.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max77686.c |    1 -
 drivers/regulator/max77693.c |    1 -
 drivers/regulator/max8997.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index de5b30e..ae001cc 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -483,7 +483,6 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		if (IS_ERR(max77686->rdev[i])) {
 			dev_err(&pdev->dev,
 				"regulator init failed for %d\n", i);
-			max77686->rdev[i] = NULL;
 			return PTR_ERR(max77686->rdev[i]);
 		}
 	}
diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 2054ae1..feb20bf 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -271,7 +271,6 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 		if (IS_ERR(max77693_pmic->rdev[i])) {
 			dev_err(max77693_pmic->dev,
 				"Failed to initialize regulator-%d\n", id);
-			max77693_pmic->rdev[i] = NULL;
 			return PTR_ERR(max77693_pmic->rdev[i]);
 		}
 	}
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 059e8ed..bcd2488 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1209,7 +1209,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		if (IS_ERR(rdev[i])) {
 			dev_err(max8997->dev, "regulator init failed for %d\n",
 					id);
-			rdev[i] = NULL;
 			return PTR_ERR(rdev[i]);
 		}
 	}
-- 
1.7.9.5

