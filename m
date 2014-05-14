Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaENDZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:25:46 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57764 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaENDZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:25:41 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, jassisinghbrar@gmail.com
Subject: [PATCH] dma: pl330: Add support for DMA_PAUSE command
Date: Wed, 14 May 2014 08:53:50 +0530
Message-Id: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing back audio, pmc_dmaengine requests the DMA channel to
stop DMA transmission through DMA_PAUSE command.

Currently PL330 driver doesn't support DMA pause command, leaving
the DMA state inconsistent when the system resumes. Instead, it would
be better to terminate the DMA transfer during suspend and restart
again during resume.

Tested with audio playback across a suspend-resume cycle.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/dma/pl330.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 73fa9b7..cd70f42 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2362,6 +2362,7 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 	LIST_HEAD(list);
 
 	switch (cmd) {
+	case DMA_PAUSE:
 	case DMA_TERMINATE_ALL:
 		spin_lock_irqsave(&pch->lock, flags);
 
-- 
1.7.9.5

