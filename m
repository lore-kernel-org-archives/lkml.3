Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3IZO7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:59:41 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46217 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3IZOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:57 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/27] mmc: s3cmci: Remove redundant suspend and resume callbacks
Date: Thu, 26 Sep 2013 16:54:43 +0200
Message-Id: <1380207292-16968-19-git-send-email-ulf.hansson@linaro.org>
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

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/s3cmci.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 8d6794c..2fce5ea 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1949,39 +1949,10 @@ static struct platform_device_id s3cmci_driver_ids[] = {
 
 MODULE_DEVICE_TABLE(platform, s3cmci_driver_ids);
 
-
-#ifdef CONFIG_PM
-
-static int s3cmci_suspend(struct device *dev)
-{
-	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
-
-	return mmc_suspend_host(mmc);
-}
-
-static int s3cmci_resume(struct device *dev)
-{
-	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
-
-	return mmc_resume_host(mmc);
-}
-
-static const struct dev_pm_ops s3cmci_pm = {
-	.suspend	= s3cmci_suspend,
-	.resume		= s3cmci_resume,
-};
-
-#define s3cmci_pm_ops &s3cmci_pm
-#else /* CONFIG_PM */
-#define s3cmci_pm_ops NULL
-#endif /* CONFIG_PM */
-
-
 static struct platform_driver s3cmci_driver = {
 	.driver	= {
 		.name	= "s3c-sdi",
 		.owner	= THIS_MODULE,
-		.pm	= s3cmci_pm_ops,
 	},
 	.id_table	= s3cmci_driver_ids,
 	.probe		= s3cmci_probe,
-- 
1.7.9.5

