Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaJKQUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:20:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaJKQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887820"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/6] dmaengine: add dmaengine_prep_dma_sg() helper
Date: Sat, 11 Oct 2014 21:16:43 +0530
Message-Id: <1413042408-28491-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
References: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was only prep API which didnt have an helper

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3d291f5..ce8a08e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -757,6 +757,16 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
 	return chan->device->device_prep_interleaved_dma(chan, xt, flags);
 }
 
+static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_sg(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags)
+{
+	return chan->device->device_prep_dma_sg(chan, dst_sg, dst_nents,
+			src_sg, src_nents, flags);
+}
+
 static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
 {
 	if (!chan || !caps)
-- 
1.7.0.4

