Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaAWK4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:56:44 -0500
Received: from smtp2.macqel.be ([109.135.2.61]:60369 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaAWK4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:56:43 -0500
From: Philippe De Muyter <phdm@macqel.be>
To: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] mmc: sdhci: Remove useless string-split's
Date: Thu, 23 Jan 2014 11:55:56 +0100
Message-Id: <1390474556-4157-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some error or warning messages that appear on one line in the kernel
log are split on two lines in sdhci.c although they are not too long
to fit on one 80-characters line.
This impairs grep'ping for them, so unsplit them.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 drivers/mmc/host/sdhci.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index bd8a098..9aa6483 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1226,8 +1226,8 @@ clock_set:
 	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
 		& SDHCI_CLOCK_INT_STABLE)) {
 		if (timeout == 0) {
-			pr_err("%s: Internal clock never "
-				"stabilised.\n", mmc_hostname(host->mmc));
+			pr_err("%s: Internal clock never stabilised.\n",
+				mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			return;
 		}
@@ -1993,9 +1993,8 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		err = -EIO;
 	} else {
 		if (!(ctrl & SDHCI_CTRL_TUNED_CLK)) {
-			pr_info(DRIVER_NAME ": Tuning procedure"
-				" failed, falling back to fixed sampling"
-				" clock\n");
+			pr_info(DRIVER_NAME ": Tuning procedure failed,"
+				" falling back to fixed sampling clock\n");
 			err = -EIO;
 		}
 	}
@@ -2192,8 +2191,8 @@ static void sdhci_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->mrq) {
-		pr_err("%s: Timeout waiting for hardware "
-			"interrupt.\n", mmc_hostname(host->mmc));
+		pr_err("%s: Timeout waiting for hardware interrupt.\n",
+			mmc_hostname(host->mmc));
 		sdhci_dumpregs(host);
 
 		if (host->data) {
@@ -2825,8 +2824,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma) {
 			if (host->ops->enable_dma(host)) {
-				pr_warning("%s: No suitable DMA "
-					"available. Falling back to PIO.\n",
+				pr_warn("%s: No suitable DMA available."
+					" Falling back to PIO.\n",
 					mmc_hostname(mmc));
 				host->flags &=
 					~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
@@ -2845,8 +2844,8 @@ int sdhci_add_host(struct sdhci_host *host)
 		if (!host->adma_desc || !host->align_buffer) {
 			kfree(host->adma_desc);
 			kfree(host->align_buffer);
-			pr_warning("%s: Unable to allocate ADMA "
-				"buffers. Falling back to standard DMA.\n",
+			pr_warn("%s: Unable to allocate ADMA buffers."
+				" Falling back to standard DMA.\n",
 				mmc_hostname(mmc));
 			host->flags &= ~SDHCI_USE_ADMA;
 		}
@@ -3138,8 +3137,8 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
 
 	if (mmc->ocr_avail == 0) {
-		pr_err("%s: Hardware doesn't report any "
-			"support voltages.\n", mmc_hostname(mmc));
+		pr_err("%s: Hardware doesn't report any support voltages.\n",
+			mmc_hostname(mmc));
 		return -ENODEV;
 	}
 
@@ -3286,8 +3285,8 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 		host->flags |= SDHCI_DEVICE_DEAD;
 
 		if (host->mrq) {
-			pr_err("%s: Controller removed during "
-				" transfer!\n", mmc_hostname(host->mmc));
+			pr_err("%s: Controller removed during transfer!\n",
+				mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
 			tasklet_schedule(&host->finish_tasklet);
-- 
1.7.5.3

