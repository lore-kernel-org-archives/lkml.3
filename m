Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaLCVn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:43:57 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38136 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaLCVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:43:54 -0500
From: Jamie Lawler <jamie.lawler@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: octeon: Added several blank lines after declarations
Date: Wed,  3 Dec 2014 21:43:51 +0000
Message-Id: <1417643031-26190-1-git-send-email-jamie.lawler@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've added blank lines after several declarations that were
previously missing them, reducing the number of warnings from
checkpatch.pl.

Regards,
Jamie Lawler

Signed-off-by: Jamie Lawler <jamie.lawler@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c |  4 ++++
 drivers/staging/octeon/ethernet-tx.c | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index b2b6c3c..758b4d9 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -84,6 +84,7 @@ static int cvm_irq_cpu;
 static void cvm_oct_enable_napi(void *_)
 {
 	int cpu = smp_processor_id();
+
 	napi_schedule(&cvm_oct_napi[cpu].napi);
 }
 
@@ -169,6 +170,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 		int interface = cvmx_helper_get_interface_num(work->ipprt);
 		int index = cvmx_helper_get_interface_index_num(work->ipprt);
 		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
+
 		gmxx_rxx_frm_ctl.u64 =
 		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
 		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
@@ -272,6 +274,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		did_work_request = 0;
 		if (work == NULL) {
 			union cvmx_pow_wq_int wq_int;
+
 			wq_int.u64 = 0;
 			wq_int.s.iq_dis = 1 << pow_receive_group;
 			wq_int.s.wq_int = 1 << pow_receive_group;
@@ -295,6 +298,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			union cvmx_pow_wq_int_cntx counts;
 			int backlog;
 			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
+
 			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
 			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
 			if (backlog > budget * cores_in_use && napi != NULL)
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
2.1.0

