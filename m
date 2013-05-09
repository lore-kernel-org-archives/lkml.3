Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3EIJVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:21:46 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:54425 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3EIJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:21:44 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 09/21] dw_dmac: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 13:19:40 +0400
Message-Id: <1368091192-10245-4-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/dma/dw_dmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 43a5329..a526bb9 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -574,14 +574,14 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
 
-inline dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan)
+dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 	return channel_readl(dwc, SAR);
 }
 EXPORT_SYMBOL(dw_dma_get_src_addr);
 
-inline dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
+dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 	return channel_readl(dwc, DAR);
-- 
1.8.1.4

