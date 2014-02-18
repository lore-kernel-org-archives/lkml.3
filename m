Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaBRKrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:11 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64192 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaBRKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:09 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 09/15] regulator: da9063: Do not hardcode return values
Date: Tue, 18 Feb 2014 16:11:05 +0530
Message-Id: <1392720071-13503-9-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error values returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/da9063-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index a61b5d997a08..22ba992e73f2 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -365,7 +365,7 @@ static int da9063_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 
 	sel = regulator_map_voltage_linear(rdev, uV, uV);
 	if (sel < 0)
-		return -EINVAL;
+		return sel;
 
 	sel <<= ffs(rdev->desc->vsel_mask) - 1;
 
@@ -757,7 +757,7 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Error while reading BUCKs configuration\n");
-		return -EIO;
+		return ret;
 	}
 	bcores_merged = val & DA9063_BCORE_MERGE;
 	bmem_bio_merged = val & DA9063_BUCK_MERGE;
-- 
1.7.9.5

