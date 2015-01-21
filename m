Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbbAUKRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:17:23 -0500
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:51198 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbbAUKRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:17:13 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH RESEND] mmc: mmci: Get rid of dead code in mmci_dma_setup
Date: Wed, 21 Jan 2015 15:47:17 +0530
Message-Id: <1421835437-26259-1-git-send-email-pramod.gurav@smartplayin.com>
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
index 47dcece..122a751 100644
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

