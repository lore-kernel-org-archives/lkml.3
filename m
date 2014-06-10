Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaFJStL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:49:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60681 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaFJStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:49:09 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-mmc@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-msm: Fix crash due to missing ops functions
Date: Tue, 10 Jun 2014 13:49:05 -0500
Message-Id: <1402426145-11180-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes in sdhci core need to get reflected in sdhci_msm_ops otherwise
we ended up dereferencing null pointers in the ops struct and crash.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/mmc/host/sdhci-msm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index acb0e9e..0d6cee0 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -467,7 +467,11 @@ static const struct of_device_id sdhci_msm_dt_match[] = {
 MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
 
 static struct sdhci_ops sdhci_msm_ops = {
+	.set_clock = sdhci_set_clock,
+	.set_bus_width = sdhci_set_bus_width,
 	.platform_execute_tuning = sdhci_msm_execute_tuning,
+	.reset = sdhci_reset,
+	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
 static int sdhci_msm_probe(struct platform_device *pdev)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

