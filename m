Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaJLHoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 03:44:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41254 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaJLHoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 03:44:13 -0400
From: Akshay Sarode <akshaysarode21@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Akshay Sarode <akshaysarode21@gmail.com>
Subject: [PATCH 1/1] Octeon: Staging Driver: Remove coding warnings
Date: Sun, 12 Oct 2014 13:13:51 +0530
Message-Id: <1413099831-5127-1-git-send-email-akshaysarode21@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch coding warnings of 'Missing a blank line after declaration'

Signed-off-by: Akshay Sarode <akshaysarode21@gmail.com>
---
 drivers/staging/octeon/ethernet-tx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 4e54d85..b7a7854 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -77,6 +77,7 @@ static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, 0);
 static inline int32_t cvm_oct_adjust_skb_to_free(int32_t skb_to_free, int fau)
 {
	int32_t undo;
+
	undo = skb_to_free > 0 ? MAX_SKB_TO_FREE : skb_to_free +
						   MAX_SKB_TO_FREE;
	if (undo > 0)
@@ -89,6 +90,7 @@ static inline int32_t cvm_oct_adjust_skb_to_free(int32_t skb_to_free, int fau)
 static void cvm_oct_kick_tx_poll_watchdog(void)
 {
	union cvmx_ciu_timx ciu_timx;
+
	ciu_timx.u64 = 0;
	ciu_timx.s.one_shot = 1;
	ciu_timx.s.len = cvm_oct_tx_poll_interval;
@@ -118,9 +120,11 @@ static void cvm_oct_free_tx_skbs(struct net_device *dev)
		total_freed += skb_to_free;
		if (skb_to_free > 0) {
			struct sk_buff *to_free_list = NULL;
+
			spin_lock_irqsave(&priv->tx_free_list[qos].lock, flags);
			while (skb_to_free > 0) {
				struct sk_buff *t;
+
				t = __skb_dequeue(&priv->tx_free_list[qos]);
				t->next = to_free_list;
				to_free_list = t;
@@ -131,6 +135,7 @@ static void cvm_oct_free_tx_skbs(struct net_device *dev)
			/* Do the actual freeing outside of the lock. */
			while (to_free_list) {
				struct sk_buff *t = to_free_list;
+
				to_free_list = to_free_list->next;
				dev_kfree_skb_any(t);
			}
@@ -258,6 +263,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
			    cvmx_read_csr(CVMX_GMXX_PRTX_CFG(index, interface));
			if (gmx_prt_cfg.s.duplex == 0) {
				int add_bytes = 64 - skb->len;
+
				if ((skb_tail_pointer(skb) + add_bytes) <=
				    skb_end_pointer(skb))
					memset(__skb_put(skb, add_bytes), 0,
@@ -289,6 +295,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
		CVM_OCT_SKB_CB(skb)[0] = hw_buffer.u64;
		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
			struct skb_frag_struct *fs = skb_shinfo(skb)->frags + i;
+
			hw_buffer.s.addr = XKPHYS_TO_PHYS(
				(u64)(page_address(fs->page.p) +
				fs->page_offset));
@@ -495,6 +502,7 @@ skip_xmit:

	while (skb_to_free > 0) {
		struct sk_buff *t = __skb_dequeue(&priv->tx_free_list[qos]);
+
		t->next = to_free_list;
		to_free_list = t;
		skb_to_free--;
@@ -505,6 +513,7 @@ skip_xmit:
	/* Do the actual freeing outside of the lock. */
	while (to_free_list) {
		struct sk_buff *t = to_free_list;
+
		to_free_list = to_free_list->next;
		dev_kfree_skb_any(t);
	}
@@ -550,6 +559,7 @@ int cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev)

	/* Get a work queue entry */
	cvmx_wqe_t *work = cvmx_fpa_alloc(CVMX_FPA_WQE_POOL);
+
	if (unlikely(work == NULL)) {
		printk_ratelimited("%s: Failed to allocate a work queue entry\n",
				   dev->name);
@@ -713,6 +723,7 @@ static void cvm_oct_tx_do_cleanup(unsigned long arg)
	for (port = 0; port < TOTAL_NUMBER_OF_PORTS; port++) {
		if (cvm_oct_device[port]) {
			struct net_device *dev = cvm_oct_device[port];
+
			cvm_oct_free_tx_skbs(dev);
		}
	}
--
1.9.1
