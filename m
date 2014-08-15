Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaHOJMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:12:47 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49756 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaHOJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:12:45 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        zhangfei.gao@marvell.com, prakity@marvell.com,
        rmk+kernel@arm.linux.org.uk
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH] mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently
Date: Fri, 15 Aug 2014 10:12:38 +0100
Message-Id: <1408093958-26058-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.set_uhs_signaling field is currently initialised twice once to the
arch specific callback pxav3_set_uhs_signaling, and also to the generic
sdhci_set_uhs_signaling callback.

This means that uhs is currently broken for this platform currently, as pxav3
has some special constriants which means it can't use the generic callback.

This happened in
commit 96d7b78cfc2f ("mmc: sdhci: convert sdhci_set_uhs_signaling() into a library function")
commit a702c8abb2a9 ("mmc: host: split up sdhci-pxa, create sdhci-pxav3.c")'

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/mmc/host/sdhci-pxav3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 6f842fb..3f350ea 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -229,7 +229,6 @@ static const struct sdhci_ops pxav3_sdhci_ops = {
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = pxav3_reset,
-	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
 static struct sdhci_pltfm_data sdhci_pxav3_pdata = {
-- 
1.9.1

