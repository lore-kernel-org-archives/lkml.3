Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBQJJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:08 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41538 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaBQJJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:03 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 1/9] regulator: act8865: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:29 +0530
Message-Id: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/act8865-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index c9f98b061307..2d2c3b004ab7 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -221,6 +221,7 @@ static int act8865_pdata_from_dt(struct device *dev,
 
 	matched = of_regulator_match(dev, np,
 				act8865_matches, ARRAY_SIZE(act8865_matches));
+	of_node_put(np);
 	if (matched <= 0)
 		return matched;
 
-- 
1.7.9.5

