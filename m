Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3IBIcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:32:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62517 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3IBIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:32:47 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, vinod.koul@intel.com,
        linus.walleij@linaro.org
Subject: [PATCH 2/2] dma: ste_dma40: Fix potential null pointer dereference
Date: Mon,  2 Sep 2013 13:44:59 +0530
Message-Id: <1378109699-25245-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378109699-25245-1-git-send-email-sachin.kamat@linaro.org>
References: <1378109699-25245-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc can return NULL. Check the pointer before dereferencing.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/ste_dma40.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index df0a606..82d2b97 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2591,6 +2591,9 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 	int i;
 
 	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_NOWAIT);
+	if (!sg)
+		return NULL;
+
 	for (i = 0; i < periods; i++) {
 		sg_dma_address(&sg[i]) = dma_addr;
 		sg_dma_len(&sg[i]) = period_len;
-- 
1.7.9.5

