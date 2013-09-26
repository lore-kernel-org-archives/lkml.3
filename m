Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3IZO4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:12 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34865 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3IZO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:05 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Wei WANG <wei_wang@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 21/27] mmc: rtsx: Remove redundant suspend and resume callbacks
Date: Thu, 26 Sep 2013 16:54:46 +0200
Message-Id: <1380207292-16968-22-git-send-email-ulf.hansson@linaro.org>
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

Cc: Wei WANG <wei_wang@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index e2ab124..c46feda 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1197,37 +1197,6 @@ static const struct mmc_host_ops realtek_pci_sdmmc_ops = {
 	.execute_tuning = sdmmc_execute_tuning,
 };
 
-#ifdef CONFIG_PM
-static int rtsx_pci_sdmmc_suspend(struct platform_device *pdev,
-		pm_message_t state)
-{
-	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
-	struct mmc_host *mmc = host->mmc;
-	int err;
-
-	dev_dbg(sdmmc_dev(host), "--> %s\n", __func__);
-
-	err = mmc_suspend_host(mmc);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-static int rtsx_pci_sdmmc_resume(struct platform_device *pdev)
-{
-	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
-	struct mmc_host *mmc = host->mmc;
-
-	dev_dbg(sdmmc_dev(host), "--> %s\n", __func__);
-
-	return mmc_resume_host(mmc);
-}
-#else /* CONFIG_PM */
-#define rtsx_pci_sdmmc_suspend NULL
-#define rtsx_pci_sdmmc_resume NULL
-#endif /* CONFIG_PM */
-
 static void init_extra_caps(struct realtek_pci_sdmmc *host)
 {
 	struct mmc_host *mmc = host->mmc;
@@ -1367,8 +1336,6 @@ static struct platform_driver rtsx_pci_sdmmc_driver = {
 	.probe		= rtsx_pci_sdmmc_drv_probe,
 	.remove		= rtsx_pci_sdmmc_drv_remove,
 	.id_table       = rtsx_pci_sdmmc_ids,
-	.suspend	= rtsx_pci_sdmmc_suspend,
-	.resume		= rtsx_pci_sdmmc_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRV_NAME_RTSX_PCI_SDMMC,
-- 
1.7.9.5

