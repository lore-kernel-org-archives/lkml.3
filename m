Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaBRKq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:46:59 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43155 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaBRKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:56 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 05/15] regulator: max8925: Do not hardcode return value
Date: Tue, 18 Feb 2014 16:11:01 +0530
Message-Id: <1392720071-13503-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error value returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8925-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 5b939894bfc4..9c859ed4131b 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -264,7 +264,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 				&max8925_regulator_matches[ridx], 1);
 	of_node_put(np);
 	if (rcount < 0)
-		return -ENODEV;
+		return rcount;
 	config->init_data =	max8925_regulator_matches[ridx].init_data;
 	config->of_node = max8925_regulator_matches[ridx].of_node;
 
-- 
1.7.9.5

