Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaHLQPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:15:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43084 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaHLQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:14:44 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tgih.jun@samsung.com, jh80.chung@samsung.com, chris@printf.net,
        ulf.hansson@linaro.org, jarkko.lavinen@nokia.com, balajitk@ti.com,
        baohua@kernel.org, viresh.linux@gmail.com, ian.molton@codethink.co.uk,
        maxime.ripard@free-electrons.com, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, spear-devel@list.st.com,
        linux-tegra@vger.kernel.org, michal.simek@xilinx.com,
        swarren@wwwdotorg.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 4/5] mmc: sdhci-pci: Use SET_RUNTIME_PM_OPS macro to set runtime pm callbacks
Date: Tue, 12 Aug 2014 17:14:28 +0100
Message-Id: <1407860069-12706-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
References: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to get rid of the #else condition, as the macro compiles
away to nothing if not enabled.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/mmc/host/sdhci-pci.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 52c42fc..745629d 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1267,20 +1267,13 @@ static int sdhci_pci_runtime_idle(struct device *dev)
 	return 0;
 }
 
-#else
-
-#define sdhci_pci_runtime_suspend	NULL
-#define sdhci_pci_runtime_resume	NULL
-#define sdhci_pci_runtime_idle		NULL
-
 #endif
 
 static const struct dev_pm_ops sdhci_pci_pm_ops = {
 	.suspend = sdhci_pci_suspend,
 	.resume = sdhci_pci_resume,
-	.runtime_suspend = sdhci_pci_runtime_suspend,
-	.runtime_resume = sdhci_pci_runtime_resume,
-	.runtime_idle = sdhci_pci_runtime_idle,
+	SET_RUNTIME_PM_OPS(sdhci_pci_runtime_suspend,
+			sdhci_pci_runtime_resume, sdhci_pci_runtime_idle)
 };
 
 /*****************************************************************************\
-- 
1.9.1

