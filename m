Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaIPLOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:14:30 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:36837 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863AbaIPLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:14:27 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/5] mmc: msm_sdcc: Remove duplicate check around dmares
Date: Tue, 16 Sep 2014 16:47:47 +0530
Message-Id: <1410866268-15185-5-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes duplicate check on host->dmares. As function
msmsdcc_init_dma() is called only after host->dmares is found
true, it is unnecessary to recheck inside the function.

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/msm_sdcc.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 2111c03..5025364 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1143,9 +1143,6 @@ msmsdcc_init_dma(struct msmsdcc_host *host)
 	host->dma.host = host;
 	host->dma.channel = -1;
 
-	if (!host->dmares)
-		return -ENODEV;
-
 	host->dma.nc = dma_alloc_coherent(NULL,
 					  sizeof(struct msmsdcc_nc_dmadata),
 					  &host->dma.nc_busaddr,
-- 
1.7.9.5

