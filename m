Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaAVLqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:46:22 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:35273 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbaAVLqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:46:13 -0500
From: Michael Trimarchi <michael@amarulasolutions.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Manjunathappa Prakash <prakash.pm@ti.com>
Subject: [RFC PATCH 2/3] ARM: mmc: davinci: Remove cast to the same type
Date: Wed, 22 Jan 2014 12:46:04 +0100
Message-Id: <1390391165-27906-3-git-send-email-michael@amarulasolutions.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390391165-27906-1-git-send-email-michael@amarulasolutions.com>
References: <1390391165-27906-1-git-send-email-michael@amarulasolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 drivers/mmc/host/davinci_mmc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 8ea09ef..13ac664 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -212,7 +212,7 @@ struct mmc_davinci_host {
 	bool active_request;
 
 	/* For PIO we walk scatterlists one segment at a time. */
-	unsigned int		sg_len;
+	unsigned int sg_len;
 	struct scatterlist *sg;
 
 	/* Version of the MMC/SD controller */
@@ -660,13 +660,11 @@ static unsigned int calculate_freq_for_card(struct mmc_davinci_host *host,
 
 	mmc_pclk = host->mmc_input_clk;
 	if (mmc_req_freq && mmc_pclk > (2 * mmc_req_freq))
-		mmc_push_pull_divisor = ((unsigned int)mmc_pclk
-				/ (2 * mmc_req_freq)) - 1;
+		mmc_push_pull_divisor = (mmc_pclk / (2 * mmc_req_freq)) - 1;
 	else
 		mmc_push_pull_divisor = 0;
 
-	mmc_freq = (unsigned int)mmc_pclk
-		/ (2 * (mmc_push_pull_divisor + 1));
+	mmc_freq = mmc_pclk / (2 * (mmc_push_pull_divisor + 1));
 
 	if (mmc_freq > mmc_req_freq)
 		mmc_push_pull_divisor = mmc_push_pull_divisor + 1;
@@ -693,7 +691,7 @@ static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 		/* Ignoring the init clock value passed for fixing the inter
 		 * operability with different cards.
 		 */
-		open_drain_freq = ((unsigned int)host->mmc_input_clk
+		open_drain_freq = (host->mmc_input_clk
 				/ (2 * MMCSD_INIT_CLOCK)) - 1;
 
 		if (open_drain_freq > 0xFF)
-- 
1.8.1.2

