Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaIPLO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:14:27 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:41796 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbaIPLOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:14:25 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/5] mmc: msm_sdcc: Replace pr_ with dev_
Date: Tue, 16 Sep 2014 16:47:46 +0530
Message-Id: <1410866268-15185-4-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces pr_* with dev_ for message logging and also does away
with printing function names in logs.

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/msm_sdcc.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 3e0536d..2111c03 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1177,7 +1177,7 @@ msmsdcc_probe(struct platform_device *pdev)
 
 	/* must have platform data */
 	if (!plat) {
-		pr_err("%s: Platform data not available\n", __func__);
+		dev_err(&pdev->dev, "Platform data not available\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1186,7 +1186,7 @@ msmsdcc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	if (pdev->resource == NULL || pdev->num_resources < 2) {
-		pr_err("%s: Invalid resource\n", __func__);
+		dev_err(&pdev->dev, "Invalid resource\n");
 		return -ENXIO;
 	}
 
@@ -1196,9 +1196,8 @@ msmsdcc_probe(struct platform_device *pdev)
 						  "cmd_irq");
 	stat_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
 						   "status_irq");
-
 	if (!cmd_irqres || !memres) {
-		pr_err("%s: Invalid resource\n", __func__);
+		dev_err(&pdev->dev, "Invalid resource\n");
 		return -ENXIO;
 	}
 
@@ -1264,7 +1263,7 @@ msmsdcc_probe(struct platform_device *pdev)
 
 	ret = clk_set_rate(host->clk, msmsdcc_fmin);
 	if (ret) {
-		pr_err("%s: Clock rate set failed (%d)\n", __func__, ret);
+		dev_err(&pdev->dev, "Clock rate set failed (%d)\n", ret);
 		goto dma_free;
 	}
 
@@ -1328,14 +1327,14 @@ msmsdcc_probe(struct platform_device *pdev)
 				  DRIVER_NAME " (slot)",
 				  host);
 		if (ret) {
-			pr_err("%s: Unable to get slot IRQ %d (%d)\n",
+			dev_err(&pdev->dev, "%s: Unable to get slot IRQ %d (%d)\n",
 			       mmc_hostname(mmc), host->stat_irq, ret);
 			goto clk_disable;
 		}
 	} else if (plat->register_status_notify) {
 		plat->register_status_notify(msmsdcc_status_notify_cb, host);
 	} else if (!plat->status)
-		pr_err("%s: No card detect facilities available\n",
+		dev_err(&pdev->dev, "%s: No card detect facilities available\n",
 		       mmc_hostname(mmc));
 	else {
 		init_timer(&host->timer);
@@ -1364,28 +1363,31 @@ msmsdcc_probe(struct platform_device *pdev)
 	mmc_set_drvdata(pdev, mmc);
 	mmc_add_host(mmc);
 
-	pr_info("%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
+	dev_info(&pdev->dev, "%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
 		mmc_hostname(mmc), (unsigned long long)memres->start,
 		(unsigned int) cmd_irqres->start,
 		(unsigned int) host->stat_irq, host->dma.channel);
-	pr_info("%s: 4 bit data mode %s\n", mmc_hostname(mmc),
+	dev_info(&pdev->dev, "%s: 4 bit data mode %s\n", mmc_hostname(mmc),
 		(mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled"));
-	pr_info("%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
+	dev_info(&pdev->dev, "%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
 		mmc_hostname(mmc), msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
-	pr_info("%s: Slot eject status = %d\n", mmc_hostname(mmc), host->eject);
-	pr_info("%s: Power save feature enable = %d\n",
+	dev_info(&pdev->dev, "%s: Slot eject status = %d\n", mmc_hostname(mmc),
+		host->eject);
+	dev_info(&pdev->dev, "%s: Power save feature enable = %d\n",
 		mmc_hostname(mmc), msmsdcc_pwrsave);
 
 	if (host->dma.channel != -1) {
-		pr_info("%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
+		dev_info(&pdev->dev, "%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
 			mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
-		pr_info("%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
+		dev_info(&pdev->dev, "%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
 			mmc_hostname(mmc), host->dma.cmd_busaddr,
 			host->dma.cmdptr_busaddr);
 	} else
-		pr_info("%s: PIO transfer enabled\n", mmc_hostname(mmc));
+		dev_info(&pdev->dev, "%s: PIO transfer enabled\n",
+			 mmc_hostname(mmc));
 	if (host->timer.function)
-		pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
+		dev_info(&pdev->dev, "%s: Polling status mode enabled\n",
+			 mmc_hostname(mmc));
 
 	return 0;
 
-- 
1.7.9.5

