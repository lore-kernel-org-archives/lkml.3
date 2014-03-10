Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaCJKDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:03:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65306 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaCJKDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:03:47 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH Resend 2/2] regulator: s2mps11: Add missing of_node_put
Date: Mon, 10 Mar 2014 15:27:41 +0530
Message-Id: <1394445461-17532-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394445461-17532-1-git-send-email-sachin.kamat@linaro.org>
References: <1394445461-17532-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s2mps11.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 0f6177b..6eaf69b 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -446,6 +446,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
+	of_node_put(reg_np);
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
-- 
1.7.9.5

