Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaIXQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:53:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:49593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbaIXQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749520"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 15/27] mmc: mmci: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:05 +0530
Message-Id: <1411575342-31048-16-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/mmc/host/mmci.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e4d4707..27dcfba 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -223,8 +223,7 @@ static int mmci_card_busy(struct mmc_host *mmc)
 		busy = 1;
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	pm_runtime_mark_last_busy(mmc_dev(mmc));
-	pm_runtime_put_autosuspend(mmc_dev(mmc));
+	pm_runtime_last_busy_and_autosuspend(mmc_dev(mmc));
 
 	return busy;
 }
@@ -372,8 +371,7 @@ mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
 
 	mmc_request_done(host->mmc, mrq);
 
-	pm_runtime_mark_last_busy(mmc_dev(host->mmc));
-	pm_runtime_put_autosuspend(mmc_dev(host->mmc));
+	pm_runtime_last_busy_and_autosuspend(mmc_dev(host->mmc));
 }
 
 static void mmci_set_mask1(struct mmci_host *host, unsigned int mask)
@@ -1397,8 +1395,7 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	pm_runtime_mark_last_busy(mmc_dev(mmc));
-	pm_runtime_put_autosuspend(mmc_dev(mmc));
+	pm_runtime_last_busy_and_autosuspend(mmc_dev(mmc));
 }
 
 static int mmci_get_cd(struct mmc_host *mmc)
@@ -1442,8 +1439,7 @@ static int mmci_sig_volt_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 		if (ret)
 			dev_warn(mmc_dev(mmc), "Voltage switch failed\n");
 
-		pm_runtime_mark_last_busy(mmc_dev(mmc));
-		pm_runtime_put_autosuspend(mmc_dev(mmc));
+		pm_runtime_last_busy_and_autosuspend(mmc_dev(mmc));
 	}
 
 	return ret;
-- 
1.7.0.4

