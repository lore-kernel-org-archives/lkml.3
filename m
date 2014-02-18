Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaBRKrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:17 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44862 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaBRKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:15 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 10/15] regulator: da9055: Do not hardcode return value
Date: Tue, 18 Feb 2014 16:11:06 +0530
Message-Id: <1392720071-13503-10-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error value returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/da9055-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 126e7c6d2c12..9516317e1a9f 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -567,7 +567,7 @@ static int da9055_regulator_dt_init(struct platform_device *pdev,
 	of_node_put(nproot);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error matching regulator: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 
 	config->init_data = da9055_reg_matches[regid].init_data;
-- 
1.7.9.5

