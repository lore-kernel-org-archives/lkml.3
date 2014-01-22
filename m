Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaAVLqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:46:15 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34827 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaAVLqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:46:12 -0500
From: Michael Trimarchi <michael@amarulasolutions.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Manjunathappa Prakash <prakash.pm@ti.com>
Subject: [RFC PATCH 1/3] ARM: mmc: davinci: remove unused variable mmc_pclk and fix opendrain clock calculation
Date: Wed, 22 Jan 2014 12:46:03 +0100
Message-Id: <1390391165-27906-2-git-send-email-michael@amarulasolutions.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390391165-27906-1-git-send-email-michael@amarulasolutions.com>
References: <1390391165-27906-1-git-send-email-michael@amarulasolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 drivers/mmc/host/davinci_mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index e9fa87d..8ea09ef 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -683,7 +683,7 @@ static unsigned int calculate_freq_for_card(struct mmc_davinci_host *host,
 
 static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	unsigned int open_drain_freq = 0, mmc_pclk = 0;
+	unsigned int open_drain_freq = 0;
 	unsigned int mmc_push_pull_freq = 0;
 	struct mmc_davinci_host *host = mmc_priv(mmc);
 
@@ -693,7 +693,7 @@ static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 		/* Ignoring the init clock value passed for fixing the inter
 		 * operability with different cards.
 		 */
-		open_drain_freq = ((unsigned int)mmc_pclk
+		open_drain_freq = ((unsigned int)host->mmc_input_clk
 				/ (2 * MMCSD_INIT_CLOCK)) - 1;
 
 		if (open_drain_freq > 0xFF)
-- 
1.8.1.2

