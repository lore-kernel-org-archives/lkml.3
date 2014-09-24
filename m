Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaIXQrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:49593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbaIXQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749540"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Balaji T K <balajitk@ti.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 16/27] mmc: omap_hsmmc: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:06 +0530
Message-Id: <1411575342-31048-17-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code
This patch also changes return value from macro rather than 0 always!

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/mmc/host/omap_hsmmc.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9656726..2a2affc 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1823,10 +1823,7 @@ static int omap_hsmmc_disable_fclk(struct mmc_host *mmc)
 {
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	pm_runtime_mark_last_busy(host->dev);
-	pm_runtime_put_autosuspend(host->dev);
-
-	return 0;
+	return pm_runtime_last_busy_and_autosuspend(host->dev);
 }
 
 static const struct mmc_host_ops omap_hsmmc_ops = {
@@ -1877,10 +1874,7 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 	seq_printf(s, "CAPA:\t\t0x%08x\n",
 			OMAP_HSMMC_READ(host->base, CAPA));
 
-	pm_runtime_mark_last_busy(host->dev);
-	pm_runtime_put_autosuspend(host->dev);
-
-	return 0;
+	return pm_runtime_last_busy_and_autosuspend(host->dev);
 }
 
 static int omap_hsmmc_regs_open(struct inode *inode, struct file *file)
@@ -2258,10 +2252,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	}
 
 	omap_hsmmc_debugfs(mmc);
-	pm_runtime_mark_last_busy(host->dev);
-	pm_runtime_put_autosuspend(host->dev);
-
-	return 0;
+	return pm_runtime_last_busy_and_autosuspend(host->dev);
 
 err_slot_name:
 	mmc_remove_host(mmc);
@@ -2386,9 +2377,7 @@ static int omap_hsmmc_resume(struct device *dev)
 	    !(host->mmc->pm_flags & MMC_PM_WAKE_SDIO_IRQ))
 		enable_irq(host->wake_irq);
 
-	pm_runtime_mark_last_busy(host->dev);
-	pm_runtime_put_autosuspend(host->dev);
-	return 0;
+	return pm_runtime_last_busy_and_autosuspend(host->dev);
 }
 
 #else
-- 
1.7.0.4

