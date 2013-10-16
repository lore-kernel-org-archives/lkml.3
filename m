Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536Ab3JPRXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:50861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab3JPRXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851435"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 28/28] net: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:46 +0530
Message-Id: <1381940926-25564-29-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: "David S. Miller" <davem@davemloft.net>
---
David pls ack this as it has dependency on my tree

 net/ipv4/tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6e5617b..d2652fb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1429,7 +1429,7 @@ static void tcp_service_net_dma(struct sock *sk, bool wait)
 	do {
 		if (dma_async_is_tx_complete(tp->ucopy.dma_chan,
 					      last_issued, &done,
-					      &used) == DMA_SUCCESS) {
+					      &used) == DMA_COMPLETE) {
 			/* Safe to free early-copied skbs now */
 			__skb_queue_purge(&sk->sk_async_wait_queue);
 			break;
@@ -1437,7 +1437,7 @@ static void tcp_service_net_dma(struct sock *sk, bool wait)
 			struct sk_buff *skb;
 			while ((skb = skb_peek(&sk->sk_async_wait_queue)) &&
 			       (dma_async_is_complete(skb->dma_cookie, done,
-						      used) == DMA_SUCCESS)) {
+						      used) == DMA_COMPLETE)) {
 				__skb_dequeue(&sk->sk_async_wait_queue);
 				kfree_skb(skb);
 			}
-- 
1.7.0.4

