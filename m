Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3IZO5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:57:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52187 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3IZO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:14 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>
Subject: [PATCH 24/27] mmc: tmio: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:49 +0200
Message-Id: <1380207292-16968-25-git-send-email-ulf.hansson@linaro.org>
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

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc_pio.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index b380225..f3b2d8c 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -1145,12 +1145,9 @@ int tmio_mmc_host_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	int ret = mmc_suspend_host(mmc);
 
-	if (!ret)
-		tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
-
-	return ret;
+	tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
+	return 0;
 }
 EXPORT_SYMBOL(tmio_mmc_host_suspend);
 
@@ -1163,7 +1160,7 @@ int tmio_mmc_host_resume(struct device *dev)
 
 	/* The MMC core will perform the complete set up */
 	host->resuming = true;
-	return mmc_resume_host(mmc);
+	return 0;
 }
 EXPORT_SYMBOL(tmio_mmc_host_resume);
 
-- 
1.7.9.5

