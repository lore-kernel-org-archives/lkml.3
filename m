Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFJS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:27:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58774 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaFJS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:27:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@linaro.org>, Georgi Djakov <gdjakov@mm-sol.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] mmc: sdhci-msm: Fix fallout from sdhci refactoring
Date: Tue, 10 Jun 2014 11:27:19 -0700
Message-Id: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdhci core was refactored recently and some of those
refactorings required changes in every sdhci platform driver.
Those updates happened around the same time as when the msm
driver was merged so the refactorings missed the msm driver.
Hook in the basic library functions so that we can boot apq8074
dragonboards again instead of crashing when we try to jump to
NULL function pointers.

Reported-by: Kevin Hilman <khilman@linaro.org>
Cc: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Patch based on next-20140610

 drivers/mmc/host/sdhci-msm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index acb0e9eb55f1..40573a58486a 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -468,6 +468,10 @@ MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
 
 static struct sdhci_ops sdhci_msm_ops = {
 	.platform_execute_tuning = sdhci_msm_execute_tuning,
+	.reset = sdhci_reset,
+	.set_clock = sdhci_set_clock,
+	.set_bus_width = sdhci_set_bus_width,
+	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
 static int sdhci_msm_probe(struct platform_device *pdev)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

