Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3IZO6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:58:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61850 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3IZO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:00 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 19/27] mmc: pxamci: Remove redundant suspend and resume callbacks
Date: Thu, 26 Sep 2013 16:54:44 +0200
Message-Id: <1380207292-16968-20-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are handled by the protocol layer and
consequently the mmc_suspend|resume_host APIs are marked as deprecated.

While moving away from using the deprecated APIs, there are nothing
left to be done for the suspend and resume callbacks, so remove them.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/pxamci.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 1956a3d..32fe113 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -880,35 +880,6 @@ static int pxamci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int pxamci_suspend(struct device *dev)
-{
-	struct mmc_host *mmc = dev_get_drvdata(dev);
-	int ret = 0;
-
-	if (mmc)
-		ret = mmc_suspend_host(mmc);
-
-	return ret;
-}
-
-static int pxamci_resume(struct device *dev)
-{
-	struct mmc_host *mmc = dev_get_drvdata(dev);
-	int ret = 0;
-
-	if (mmc)
-		ret = mmc_resume_host(mmc);
-
-	return ret;
-}
-
-static const struct dev_pm_ops pxamci_pm_ops = {
-	.suspend	= pxamci_suspend,
-	.resume		= pxamci_resume,
-};
-#endif
-
 static struct platform_driver pxamci_driver = {
 	.probe		= pxamci_probe,
 	.remove		= pxamci_remove,
@@ -916,9 +887,6 @@ static struct platform_driver pxamci_driver = {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(pxa_mmc_dt_ids),
-#ifdef CONFIG_PM
-		.pm	= &pxamci_pm_ops,
-#endif
 	},
 };
 
-- 
1.7.9.5

