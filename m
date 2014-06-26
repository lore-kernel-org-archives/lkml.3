Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaFZVxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:53:45 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20002 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaFZVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:53:44 -0400
X-IronPort-AV: E=Sophos;i="5.01,555,1400050800"; 
   d="scan'208";a="36733575"
From: Markus Mayer <markus.mayer@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Matt Porter" <mporter@linaro.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v5] mmc: sdhci: Replace host->mmc with mmc where possible
Date: Thu, 26 Jun 2014 14:53:35 -0700
Message-ID: <1403819615-9253-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the switch to the MMC core regulator infrastucture, we already
have a local "mmc" pointer in various functions. There is no longer a
need to access the data structure via host->mmc.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---

This patch was posted before as part 2/2 of a series
(https://lkml.org/lkml/2014/6/13/449). Part 1/2 has since been
accepted.

Please note that checkpatch still complains about the wrapped strings,
but issue is not introduced by this patch, nor is it confined to the
lines changed by this patch. (There are several other locations in
sdhci.c where strings are wrapped across lines.)

Changes from v4:
  - Rebased on Ulf's current mmc-next branch.

 drivers/mmc/host/sdhci.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5cf4a86..26639bf 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1228,7 +1228,7 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 
 	if (!IS_ERR(mmc->supply.vmmc)) {
 		spin_unlock_irq(&host->lock);
-		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
+		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
 		spin_lock_irq(&host->lock);
 		return;
 	}
@@ -1450,7 +1450,7 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 		spin_unlock_irqrestore(&host->lock, flags);
 		if (!IS_ERR(mmc->supply.vmmc) &&
 		    ios->power_mode == MMC_POWER_OFF)
-			mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, 0);
+			mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, 0);
 		return;
 	}
 
@@ -1734,7 +1734,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 						    3600000);
 			if (ret) {
 				pr_warning("%s: Switching to 3.3V signalling voltage "
-						" failed\n", mmc_hostname(host->mmc));
+						" failed\n", mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -1747,7 +1747,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 			return 0;
 
 		pr_warning("%s: 3.3V regulator output did not became stable\n",
-				mmc_hostname(host->mmc));
+				mmc_hostname(mmc));
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -1756,7 +1756,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 					1700000, 1950000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.8V signalling voltage "
-						" failed\n", mmc_hostname(host->mmc));
+						" failed\n", mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -1777,7 +1777,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 			return 0;
 
 		pr_warning("%s: 1.8V regulator output did not became stable\n",
-				mmc_hostname(host->mmc));
+				mmc_hostname(mmc));
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_120:
@@ -1786,7 +1786,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 						    1300000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.2V signalling voltage "
-						" failed\n", mmc_hostname(host->mmc));
+						" failed\n", mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -2825,12 +2825,12 @@ int sdhci_add_host(struct sdhci_host *host)
 		 * (128) and potentially one alignment transfer for
 		 * each of those entries.
 		 */
-		host->adma_desc = dma_alloc_coherent(mmc_dev(host->mmc),
+		host->adma_desc = dma_alloc_coherent(mmc_dev(mmc),
 						     ADMA_SIZE, &host->adma_addr,
 						     GFP_KERNEL);
 		host->align_buffer = kmalloc(128 * 4, GFP_KERNEL);
 		if (!host->adma_desc || !host->align_buffer) {
-			dma_free_coherent(mmc_dev(host->mmc), ADMA_SIZE,
+			dma_free_coherent(mmc_dev(mmc), ADMA_SIZE,
 					  host->adma_desc, host->adma_addr);
 			kfree(host->align_buffer);
 			pr_warning("%s: Unable to allocate ADMA "
@@ -2843,7 +2843,7 @@ int sdhci_add_host(struct sdhci_host *host)
 			pr_warning("%s: unable to allocate aligned ADMA descriptor\n",
 				   mmc_hostname(mmc));
 			host->flags &= ~SDHCI_USE_ADMA;
-			dma_free_coherent(mmc_dev(host->mmc), ADMA_SIZE,
+			dma_free_coherent(mmc_dev(mmc), ADMA_SIZE,
 					  host->adma_desc, host->adma_addr);
 			kfree(host->align_buffer);
 			host->adma_desc = NULL;
@@ -2858,7 +2858,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	 */
 	if (!(host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))) {
 		host->dma_mask = DMA_BIT_MASK(64);
-		mmc_dev(host->mmc)->dma_mask = &host->dma_mask;
+		mmc_dev(mmc)->dma_mask = &host->dma_mask;
 	}
 
 	if (host->version >= SDHCI_SPEC_300)
@@ -2964,7 +2964,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
 
 	if ((host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
-	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
+	    !(mmc->caps & MMC_CAP_NONREMOVABLE))
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
 	/* If there are external regulators, get them */
@@ -3261,7 +3261,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 		if (host->mrq) {
 			pr_err("%s: Controller removed during "
-				" transfer!\n", mmc_hostname(host->mmc));
+				" transfer!\n", mmc_hostname(mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
 			tasklet_schedule(&host->finish_tasklet);
@@ -3272,7 +3272,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	sdhci_disable_card_detection(host);
 
-	mmc_remove_host(host->mmc);
+	mmc_remove_host(mmc);
 
 #ifdef SDHCI_USE_LEDS_CLASS
 	led_classdev_unregister(&host->led);
@@ -3296,7 +3296,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 		regulator_disable(mmc->supply.vqmmc);
 
 	if (host->adma_desc)
-		dma_free_coherent(mmc_dev(host->mmc), ADMA_SIZE,
+		dma_free_coherent(mmc_dev(mmc), ADMA_SIZE,
 				  host->adma_desc, host->adma_addr);
 	kfree(host->align_buffer);
 
-- 
1.9.1

