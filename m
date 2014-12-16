Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaLPNsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:48:18 -0500
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:37966 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbaLPNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:48:16 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: linux@arm.linux.org.uk, chris@printf.net, ulf.hansson@linaro.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH] mmc: mmci: Get rid of unused variable and operations on it
Date: Tue, 16 Dec 2014 19:21:34 +0530
Message-Id: <1418737895-6404-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA configuration has been removed from function mmci_dma_setup but the
local mask variable was not removed. This remains unused hence remove
it from the function and operations on it

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/mmci.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index f31d702..08bbeb0 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -435,7 +435,6 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
 static void mmci_dma_setup(struct mmci_host *host)
 {
 	const char *rxname, *txname;
-	dma_cap_mask_t mask;
 	struct variant_data *variant = host->variant;
 
 	host->dma_rx_channel = dma_request_slave_channel(mmc_dev(host->mmc), "rx");
@@ -444,10 +443,6 @@ static void mmci_dma_setup(struct mmci_host *host)
 	/* initialize pre request cookie */
 	host->next_data.cookie = 1;
 
-	/* Try to acquire a generic DMA engine slave channel */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
 	/*
 	 * If only an RX channel is specified, the driver will
 	 * attempt to use it bidirectionally, however if it is
-- 
1.7.9.5

