Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab3EWP2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:28:50 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43935 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759582Ab3EWPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/16] mfd: htc-egpio: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:12 +0100
Message-Id: <1369322717-30429-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/htc-egpio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index bbaec0c..f2e0ad4 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -270,7 +270,7 @@ static int __init egpio_probe(struct platform_device *pdev)
 	int               ret;
 
 	/* Initialize ei data structure. */
-	ei = kzalloc(sizeof(*ei), GFP_KERNEL);
+	ei = devm_kzalloc(&pdev->dev, sizeof(*ei), GFP_KERNEL);
 	if (!ei)
 		return -ENOMEM;
 
@@ -306,7 +306,9 @@ static int __init egpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ei);
 
 	ei->nchips = pdata->num_chips;
-	ei->chip = kzalloc(sizeof(struct egpio_chip) * ei->nchips, GFP_KERNEL);
+	ei->chip = devm_kzalloc(&pdev->dev,
+				sizeof(struct egpio_chip) * ei->nchips,
+				GFP_KERNEL);
 	if (!ei->chip) {
 		ret = -ENOMEM;
 		goto fail;
@@ -361,7 +363,6 @@ static int __init egpio_probe(struct platform_device *pdev)
 
 fail:
 	printk(KERN_ERR "EGPIO failed to setup\n");
-	kfree(ei);
 	return ret;
 }
 
@@ -380,8 +381,6 @@ static int __exit egpio_remove(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 0);
 	}
 	iounmap(ei->base_addr);
-	kfree(ei->chip);
-	kfree(ei);
 
 	return 0;
 }
-- 
1.7.10.4

