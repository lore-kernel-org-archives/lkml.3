Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3FGLmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:42:49 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:53895 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab3FGLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:42:46 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>, <zhangfei.gao@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH] dma: mmp_tdma: kill tasklet when free dma channel
Date: Fri, 7 Jun 2013 19:40:40 +0800
Message-ID: <1370605240-19768-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill tasklet task when free dam channel, otherwise the task may
run after related resource is released, then unknown things may
happen.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 drivers/dma/mmp_tdma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 43d5a6c..2622b2a 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -333,6 +333,9 @@ static void mmp_tdma_free_chan_resources(struct dma_chan *chan)
 
 	if (tdmac->irq)
 		devm_free_irq(tdmac->dev, tdmac->irq, tdmac);
+
+	tasklet_kill(&tdmac->tasklet);
+
 	mmp_tdma_free_descriptor(tdmac);
 	return;
 }
-- 
1.7.0.4

