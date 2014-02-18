Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaBRKrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:25 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53518 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaBRKrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:21 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 12/15] regulator: act8865: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:08 +0530
Message-Id: <1392720071-13503-12-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/act8865-regulator.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index 2d2c3b004ab7..a5ff30c8a1e3 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -228,11 +228,8 @@ static int act8865_pdata_from_dt(struct device *dev,
 	pdata->regulators = devm_kzalloc(dev,
 				sizeof(struct act8865_regulator_data) *
 				ARRAY_SIZE(act8865_matches), GFP_KERNEL);
-	if (!pdata->regulators) {
-		dev_err(dev, "%s: failed to allocate act8865 registor\n",
-						__func__);
+	if (!pdata->regulators)
 		return -ENOMEM;
-	}
 
 	pdata->num_regulators = matched;
 	regulator = pdata->regulators;
-- 
1.7.9.5

