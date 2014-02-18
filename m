Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaBRKr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:59 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46603 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbaBRKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:28 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 14/15] regulator: arizona-micsupp: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:10 +0530
Message-Id: <1392720071-13503-14-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/arizona-micsupp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 034ece707083..6fdd9bf6927f 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -204,10 +204,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	int ret;
 
 	micsupp = devm_kzalloc(&pdev->dev, sizeof(*micsupp), GFP_KERNEL);
-	if (micsupp == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!micsupp)
 		return -ENOMEM;
-	}
 
 	micsupp->arizona = arizona;
 	INIT_WORK(&micsupp->check_cp_work, arizona_micsupp_check_cp);
-- 
1.7.9.5

