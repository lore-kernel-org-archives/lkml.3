Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaK1Ned (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:34:33 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56549 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaK1Nec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:34:32 -0500
Date: Fri, 28 Nov 2014 14:34:29 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        paul.gortmaker@windriver.com, eunb.song@samsung.com,
        gulsah.1004@gmail.com, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org
Subject: [PATCH v3] staging: octeon: Fix checkpatch 80 character limit
 warnings
Message-ID: <20141128133429.GA5840@ks395439.kimsufi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 80 character limit warnings in octeon/ethernet-rx.c

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/octeon/ethernet-rx.c | 49 ++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 1789a12..fcbe836 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -126,13 +126,15 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 
 			if (*ptr == 0xd5) {
 				/*
-				  printk_ratelimited("Port %d received 0xd5 preamble\n", work->ipprt);
+				  printk_ratelimited("Port %d received 0xd5 preamble\n",
+					  work->ipprt);
 				 */
 				work->packet_ptr.s.addr += i + 1;
 				work->len -= i + 5;
 			} else if ((*ptr & 0xf) == 0xd) {
 				/*
-				  printk_ratelimited("Port %d received 0x?d preamble\n", work->ipprt);
+				  printk_ratelimited("Port %d received 0x?d preamble\n",
+					  work->ipprt);
 				 */
 				work->packet_ptr.s.addr += i;
 				work->len -= i + 4;
@@ -218,11 +220,13 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			cvmx_write_csr(CVMX_POW_WQ_INT, wq_int.u64);
 			break;
 		}
-		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) - sizeof(void *));
+		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) -
+			sizeof(void *));
 		prefetch(pskb);
 
 		if (USE_ASYNC_IOBDMA && rx_count < (budget - 1)) {
-			cvmx_pow_work_request_async_nocheck(CVMX_SCR_SCRATCH, CVMX_POW_NO_WAIT);
+			cvmx_pow_work_request_async_nocheck(CVMX_SCR_SCRATCH,
+							    CVMX_POW_NO_WAIT);
 			did_work_request = 1;
 		}
 		rx_count++;
@@ -247,7 +251,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		 * buffer.
 		 */
 		if (likely(skb_in_hw)) {
-			skb->data = skb->head + work->packet_ptr.s.addr - cvmx_ptr_to_phys(skb->head);
+			skb->data = skb->head + work->packet_ptr.s.addr -
+				cvmx_ptr_to_phys(skb->head);
 			prefetch(skb->data);
 			skb->len = work->len;
 			skb_set_tail_pointer(skb, skb->len);
@@ -284,7 +289,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 				/* No packet buffers to free */
 			} else {
 				int segments = work->word2.s.bufs;
-				union cvmx_buf_ptr segment_ptr = work->packet_ptr;
+				union cvmx_buf_ptr segment_ptr =
+				    work->packet_ptr;
 				int len = work->len;
 
 				while (segments--) {
@@ -300,8 +306,11 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			 * one: int segment_size =
 			 * segment_ptr.s.size;
 			 */
-					int segment_size = CVMX_FPA_PACKET_POOL_SIZE -
-						(segment_ptr.s.addr - (((segment_ptr.s.addr >> 7) - segment_ptr.s.back) << 7));
+					int segment_size =
+					    CVMX_FPA_PACKET_POOL_SIZE -
+					    (segment_ptr.s.addr -
+					     (((segment_ptr.s.addr >> 7) -
+					       segment_ptr.s.back) << 7));
 					/*
 					 * Don't copy more than what
 					 * is left in the packet.
@@ -332,8 +341,10 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 				skb->protocol = eth_type_trans(skb, dev);
 				skb->dev = dev;
 
-				if (unlikely(work->word2.s.not_IP || work->word2.s.IP_exc ||
-					work->word2.s.L4_error || !work->word2.s.tcp_or_udp))
+				if (unlikely(work->word2.s.not_IP ||
+					     work->word2.s.IP_exc ||
+					     work->word2.s.L4_error ||
+					     !work->word2.s.tcp_or_udp))
 					skb->ip_summed = CHECKSUM_NONE;
 				else
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -341,11 +352,15 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 				/* Increment RX stats for virtual ports */
 				if (work->ipprt >= CVMX_PIP_NUM_INPUT_PORTS) {
 #ifdef CONFIG_64BIT
-					atomic64_add(1, (atomic64_t *)&priv->stats.rx_packets);
-					atomic64_add(skb->len, (atomic64_t *)&priv->stats.rx_bytes);
+					atomic64_add(1,
+						     (atomic64_t *)&priv->stats.rx_packets);
+					atomic64_add(skb->len,
+						     (atomic64_t *)&priv->stats.rx_bytes);
 #else
-					atomic_add(1, (atomic_t *)&priv->stats.rx_packets);
-					atomic_add(skb->len, (atomic_t *)&priv->stats.rx_bytes);
+					atomic_add(1,
+						   (atomic_t *)&priv->stats.rx_packets);
+					atomic_add(skb->len,
+						   (atomic_t *)&priv->stats.rx_bytes);
 #endif
 				}
 				netif_receive_skb(skb);
@@ -356,9 +371,11 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 					   dev->name);
 				*/
 #ifdef CONFIG_64BIT
-				atomic64_add(1, (atomic64_t *)&priv->stats.rx_dropped);
+				atomic64_add(1,
+					     (atomic64_t *)&priv->stats.rx_dropped);
 #else
-				atomic_add(1, (atomic_t *)&priv->stats.rx_dropped);
+				atomic_add(1,
+					   (atomic_t *)&priv->stats.rx_dropped);
 #endif
 				dev_kfree_skb_irq(skb);
 			}
-- 
2.1.3

