Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3IZO4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:23 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38865 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3IZO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:16 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>
Subject: [PATCH 25/27] mmc: via-sdmmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:50 +0200
Message-Id: <1380207292-16968-26-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Cc: Bruce Chang <brucechang@via.com.tw>
Cc: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/via-sdmmc.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 4f84586..63fac78 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1269,21 +1269,18 @@ static void via_init_sdc_pm(struct via_crdr_mmc_host *host)
 static int via_sd_suspend(struct pci_dev *pcidev, pm_message_t state)
 {
 	struct via_crdr_mmc_host *host;
-	int ret = 0;
 
 	host = pci_get_drvdata(pcidev);
 
 	via_save_pcictrlreg(host);
 	via_save_sdcreg(host);
 
-	ret = mmc_suspend_host(host->mmc);
-
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
 	pci_disable_device(pcidev);
 	pci_set_power_state(pcidev, pci_choose_state(pcidev, state));
 
-	return ret;
+	return 0;
 }
 
 static int via_sd_resume(struct pci_dev *pcidev)
@@ -1316,8 +1313,6 @@ static int via_sd_resume(struct pci_dev *pcidev)
 	via_restore_pcictrlreg(sdhost);
 	via_init_sdc_pm(sdhost);
 
-	ret = mmc_resume_host(sdhost->mmc);
-
 	return ret;
 }
 
-- 
1.7.9.5

