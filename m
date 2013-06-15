Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3FOEyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 00:54:00 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:34708 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab3FOEx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 00:53:59 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <djbw@fb.com>, <vinod.koul@intel.com>, <zhangfei.gao@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH V2] dma: mmp_tdma: disable irq when disabling dma channel
Date: Sat, 15 Jun 2013 12:51:48 +0800
Message-ID: <1371271908-29596-2-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371271908-29596-1-git-send-email-zhouqiao@marvell.com>
References: <1371271908-29596-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mask dma irq when disabling dma channel, so that interrupt status
will not be set and interrupt won't come again.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 drivers/dma/mmp_tdma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 43d5a6c..9b93665 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -154,6 +154,10 @@ static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
 {
 	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
 					tdmac->reg_base + TDCR);
+
+	/* disable irq */
+	writel(0, tdmac->reg_base + TDIMR);
+
 	tdmac->status = DMA_SUCCESS;
 }
 
-- 
1.7.0.4

