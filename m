Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaHLQOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:14:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34534 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaHLQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:14:48 -0400
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
Subject: [PATCH 5/5] mmc: sdhci-acpi.c: Use SET_RUNTIME_PM_OPS macro to set runtime pm callbacks
Date: Tue, 12 Aug 2014 17:14:29 +0100
Message-Id: <1407860069-12706-6-git-send-email-peter.griffin@linaro.org>
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
 drivers/mmc/host/sdhci-acpi.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 8ce3c28..3a42540 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -383,20 +383,13 @@ static int sdhci_acpi_runtime_idle(struct device *dev)
 	return 0;
 }
 
-#else
-
-#define sdhci_acpi_runtime_suspend	NULL
-#define sdhci_acpi_runtime_resume	NULL
-#define sdhci_acpi_runtime_idle		NULL
-
 #endif
 
 static const struct dev_pm_ops sdhci_acpi_pm_ops = {
 	.suspend		= sdhci_acpi_suspend,
 	.resume			= sdhci_acpi_resume,
-	.runtime_suspend	= sdhci_acpi_runtime_suspend,
-	.runtime_resume		= sdhci_acpi_runtime_resume,
-	.runtime_idle		= sdhci_acpi_runtime_idle,
+	SET_RUNTIME_PM_OPS(sdhci_acpi_runtime_suspend,
+			sdhci_acpi_runtime_resume, sdhci_acpi_runtime_idle)
 };
 
 static struct platform_driver sdhci_acpi_driver = {
-- 
1.9.1

