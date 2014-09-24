Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaIXQrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:49616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbaIXQrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749614"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 18/27] mmc: sdhci: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:08 +0530
Message-Id: <1411575342-31048-19-git-send-email-vinod.koul@intel.com>
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
 drivers/mmc/host/sdhci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 37b2a9a..862346a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2623,8 +2623,7 @@ static int sdhci_runtime_pm_get(struct sdhci_host *host)
 
 static int sdhci_runtime_pm_put(struct sdhci_host *host)
 {
-	pm_runtime_mark_last_busy(host->mmc->parent);
-	return pm_runtime_put_autosuspend(host->mmc->parent);
+	return pm_runtime_last_busy_and_autosuspend(host->mmc->parent);
 }
 
 static void sdhci_runtime_pm_bus_on(struct sdhci_host *host)
-- 
1.7.0.4

