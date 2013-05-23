Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3EWPZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:49 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60696 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EWPZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/16] mfd: davinci_voicecodec: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:11 +0100
Message-Id: <1369322717-30429-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/davinci_voicecodec.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index c60ab0c..b6e2973 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -50,7 +50,8 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	struct mfd_cell *cell = NULL;
 	int ret;
 
-	davinci_vc = kzalloc(sizeof(struct davinci_vc), GFP_KERNEL);
+	davinci_vc = devm_kzalloc(&pdev->dev,
+				  sizeof(struct davinci_vc), GFP_KERNEL);
 	if (!davinci_vc) {
 		dev_dbg(&pdev->dev,
 			    "could not allocate memory for private data\n");
@@ -61,8 +62,7 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	if (IS_ERR(davinci_vc->clk)) {
 		dev_dbg(&pdev->dev,
 			    "could not get the clock for voice codec\n");
-		ret = -ENODEV;
-		goto fail1;
+		return -ENODEV;
 	}
 	clk_enable(davinci_vc->clk);
 
@@ -145,8 +145,6 @@ fail2:
 	clk_disable(davinci_vc->clk);
 	clk_put(davinci_vc->clk);
 	davinci_vc->clk = NULL;
-fail1:
-	kfree(davinci_vc);
 
 	return ret;
 }
@@ -164,8 +162,6 @@ static int davinci_vc_remove(struct platform_device *pdev)
 	clk_put(davinci_vc->clk);
 	davinci_vc->clk = NULL;
 
-	kfree(davinci_vc);
-
 	return 0;
 }
 
-- 
1.7.10.4

