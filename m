Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaHYM1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:27:04 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59403 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaHYM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:44 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 12/12] mmc: tmio: Remove library functions for system PM
Date: Mon, 25 Aug 2014 14:26:04 +0200
Message-Id: <1408969564-6335-13-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These library functions aren't used and nor needed, let's remove them.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc.h     |  5 -----
 drivers/mmc/host/tmio_mmc_pio.c | 23 -----------------------
 2 files changed, 28 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 2ad52d6..a34ecbe 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -144,11 +144,6 @@ static inline void tmio_mmc_abort_dma(struct tmio_mmc_host *host)
 }
 #endif
 
-#ifdef CONFIG_PM_SLEEP
-int tmio_mmc_host_suspend(struct device *dev);
-int tmio_mmc_host_resume(struct device *dev);
-#endif
-
 #ifdef CONFIG_PM
 int tmio_mmc_host_runtime_suspend(struct device *dev);
 int tmio_mmc_host_runtime_resume(struct device *dev);
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index 494ecc5..a993208 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -1139,29 +1139,6 @@ void tmio_mmc_host_remove(struct tmio_mmc_host *host)
 }
 EXPORT_SYMBOL(tmio_mmc_host_remove);
 
-#ifdef CONFIG_PM_SLEEP
-int tmio_mmc_host_suspend(struct device *dev)
-{
-	struct mmc_host *mmc = dev_get_drvdata(dev);
-	struct tmio_mmc_host *host = mmc_priv(mmc);
-
-	tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
-	return 0;
-}
-EXPORT_SYMBOL(tmio_mmc_host_suspend);
-
-int tmio_mmc_host_resume(struct device *dev)
-{
-	struct mmc_host *mmc = dev_get_drvdata(dev);
-	struct tmio_mmc_host *host = mmc_priv(mmc);
-
-	tmio_mmc_enable_dma(host, true);
-
-	return 0;
-}
-EXPORT_SYMBOL(tmio_mmc_host_resume);
-#endif
-
 #ifdef CONFIG_PM
 int tmio_mmc_host_runtime_suspend(struct device *dev)
 {
-- 
1.9.1

