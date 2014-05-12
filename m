Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaELDhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:37:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62507 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbaELDhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:37:37 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/lustre: fix sparse warnings in o2iblnd_cb.c
Date: Sun, 11 May 2014 20:37:23 -0700
Message-Id: <1399865843-17098-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:44:1: warning: symbol 'kiblnd_tx_done' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:102:10: warning: symbol 'kiblnd_get_idle_tx' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:131:1: warning: symbol 'kiblnd_drop_rx' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:212:10: warning: symbol 'kiblnd_find_waiting_tx_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:238:1: warning: symbol 'kiblnd_handle_completion' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:277:1: warning: symbol 'kiblnd_send_completion' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:296:1: warning: symbol 'kiblnd_handle_rx' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:457:1: warning: symbol 'kiblnd_rx_complete' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:527:13: warning: symbol 'kiblnd_kvaddr_to_page' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:699:1: warning: symbol 'kiblnd_setup_rd_iov' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:752:1: warning: symbol 'kiblnd_setup_rd_kiov' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:792:1: warning: symbol 'kiblnd_post_tx_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:996:1: warning: symbol 'kiblnd_tx_complete' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1270:1: warning: symbol 'kiblnd_connect_peer' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1627:1: warning: symbol 'kiblnd_reply' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1814:1: warning: symbol 'kiblnd_thread_fini' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1828:1: warning: symbol 'kiblnd_peer_notify' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1934:1: warning: symbol 'kiblnd_handle_early_rxs' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1957:1: warning: symbol 'kiblnd_abort_txs' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:1993:1: warning: symbol 'kiblnd_finalise_conn' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2167:1: warning: symbol 'kiblnd_reject' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2178:1: warning: symbol 'kiblnd_passive_connect' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2452:1: warning: symbol 'kiblnd_reconnect' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2516:1: warning: symbol 'kiblnd_rejected' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2655:1: warning: symbol 'kiblnd_check_connreply' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:2754:1: warning: symbol 'kiblnd_active_connect' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:3025:1: warning: symbol 'kiblnd_check_conns' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:3108:1: warning: symbol 'kiblnd_disconnect_conn' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:3247:1: warning: symbol 'kiblnd_complete' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:904:20: warning: context imbalance in 'kiblnd_post_tx_locked' - unexpected unlock

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 60 +++++++++++-----------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 9bf6c94..dfd16e7 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -40,7 +40,7 @@
 
 #include "o2iblnd.h"
 
-void
+static void
 kiblnd_tx_done (lnet_ni_t *ni, kib_tx_t *tx)
 {
 	lnet_msg_t *lntmsg[2];
@@ -99,7 +99,7 @@ kiblnd_txlist_done (lnet_ni_t *ni, struct list_head *txlist, int status)
 	}
 }
 
-kib_tx_t *
+static kib_tx_t *
 kiblnd_get_idle_tx(lnet_ni_t *ni, lnet_nid_t target)
 {
 	kib_net_t		*net = (kib_net_t *)ni->ni_data;
@@ -127,7 +127,7 @@ kiblnd_get_idle_tx(lnet_ni_t *ni, lnet_nid_t target)
 	return tx;
 }
 
-void
+static void
 kiblnd_drop_rx(kib_rx_t *rx)
 {
 	kib_conn_t		*conn	= rx->rx_conn;
@@ -209,7 +209,7 @@ kiblnd_post_rx (kib_rx_t *rx, int credit)
 	return 0;
 }
 
-kib_tx_t *
+static kib_tx_t *
 kiblnd_find_waiting_tx_locked(kib_conn_t *conn, int txtype, __u64 cookie)
 {
 	struct list_head   *tmp;
@@ -234,7 +234,7 @@ kiblnd_find_waiting_tx_locked(kib_conn_t *conn, int txtype, __u64 cookie)
 	return NULL;
 }
 
-void
+static void
 kiblnd_handle_completion(kib_conn_t *conn, int txtype, int status, __u64 cookie)
 {
 	kib_tx_t    *tx;
@@ -273,7 +273,7 @@ kiblnd_handle_completion(kib_conn_t *conn, int txtype, int status, __u64 cookie)
 		kiblnd_tx_done(ni, tx);
 }
 
-void
+static void
 kiblnd_send_completion(kib_conn_t *conn, int type, int status, __u64 cookie)
 {
 	lnet_ni_t   *ni = conn->ibc_peer->ibp_ni;
@@ -292,7 +292,7 @@ kiblnd_send_completion(kib_conn_t *conn, int type, int status, __u64 cookie)
 	kiblnd_queue_tx(tx, conn);
 }
 
-void
+static void
 kiblnd_handle_rx (kib_rx_t *rx)
 {
 	kib_msg_t    *msg = rx->rx_msg;
@@ -453,7 +453,7 @@ kiblnd_handle_rx (kib_rx_t *rx)
 		kiblnd_post_rx(rx, post_credit);
 }
 
-void
+static void
 kiblnd_rx_complete (kib_rx_t *rx, int status, int nob)
 {
 	kib_msg_t    *msg = rx->rx_msg;
@@ -524,7 +524,7 @@ kiblnd_rx_complete (kib_rx_t *rx, int status, int nob)
 	kiblnd_drop_rx(rx);		     /* Don't re-post rx. */
 }
 
-struct page *
+static struct page *
 kiblnd_kvaddr_to_page (unsigned long vaddr)
 {
 	struct page *page;
@@ -695,7 +695,7 @@ kiblnd_map_tx(lnet_ni_t *ni, kib_tx_t *tx,
 }
 
 
-int
+static int
 kiblnd_setup_rd_iov(lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
 		    unsigned int niov, struct iovec *iov, int offset, int nob)
 {
@@ -748,7 +748,7 @@ kiblnd_setup_rd_iov(lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
 	return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
 }
 
-int
+static int
 kiblnd_setup_rd_kiov (lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
 		      int nkiov, lnet_kiov_t *kiov, int offset, int nob)
 {
@@ -788,8 +788,10 @@ kiblnd_setup_rd_kiov (lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
 	return kiblnd_map_tx(ni, tx, rd, sg - tx->tx_frags);
 }
 
-int
+static int
 kiblnd_post_tx_locked (kib_conn_t *conn, kib_tx_t *tx, int credit)
+	__releases(conn->ibc_lock)
+	__acquires(conn->ibc_lock)
 {
 	kib_msg_t	 *msg = tx->tx_msg;
 	kib_peer_t	*peer = conn->ibc_peer;
@@ -992,7 +994,7 @@ kiblnd_check_sends (kib_conn_t *conn)
 	kiblnd_conn_decref(conn); /* ...until here */
 }
 
-void
+static void
 kiblnd_tx_complete (kib_tx_t *tx, int status)
 {
 	int	   failed = (status != IB_WC_SUCCESS);
@@ -1266,7 +1268,7 @@ static int kiblnd_resolve_addr(struct rdma_cm_id *cmid,
 	return rc;
 }
 
-void
+static void
 kiblnd_connect_peer (kib_peer_t *peer)
 {
 	struct rdma_cm_id *cmid;
@@ -1623,7 +1625,7 @@ kiblnd_send (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 	return 0;
 }
 
-void
+static void
 kiblnd_reply (lnet_ni_t *ni, kib_rx_t *rx, lnet_msg_t *lntmsg)
 {
 	lnet_process_id_t target = lntmsg->msg_target;
@@ -1810,7 +1812,7 @@ kiblnd_thread_start(int (*fn)(void *arg), void *arg, char *name)
 	return 0;
 }
 
-void
+static void
 kiblnd_thread_fini (void)
 {
 	atomic_dec (&kiblnd_data.kib_nthreads);
@@ -1824,7 +1826,7 @@ kiblnd_peer_alive (kib_peer_t *peer)
 	mb();
 }
 
-void
+static void
 kiblnd_peer_notify (kib_peer_t *peer)
 {
 	int	   error = 0;
@@ -1930,7 +1932,7 @@ kiblnd_close_conn(kib_conn_t *conn, int error)
 	write_unlock_irqrestore(&kiblnd_data.kib_global_lock, flags);
 }
 
-void
+static void
 kiblnd_handle_early_rxs(kib_conn_t *conn)
 {
 	unsigned long    flags;
@@ -1953,7 +1955,7 @@ kiblnd_handle_early_rxs(kib_conn_t *conn)
 	write_unlock_irqrestore(&kiblnd_data.kib_global_lock, flags);
 }
 
-void
+static void
 kiblnd_abort_txs(kib_conn_t *conn, struct list_head *txs)
 {
 	LIST_HEAD       (zombies);
@@ -1989,7 +1991,7 @@ kiblnd_abort_txs(kib_conn_t *conn, struct list_head *txs)
 	kiblnd_txlist_done(conn->ibc_peer->ibp_ni, &zombies, -ECONNABORTED);
 }
 
-void
+static void
 kiblnd_finalise_conn (kib_conn_t *conn)
 {
 	LASSERT (!in_interrupt());
@@ -2163,7 +2165,7 @@ kiblnd_connreq_done(kib_conn_t *conn, int status)
 	kiblnd_handle_early_rxs(conn);
 }
 
-void
+static void
 kiblnd_reject(struct rdma_cm_id *cmid, kib_rej_t *rej)
 {
 	int	  rc;
@@ -2174,7 +2176,7 @@ kiblnd_reject(struct rdma_cm_id *cmid, kib_rej_t *rej)
 		CWARN("Error %d sending reject\n", rc);
 }
 
-int
+static int
 kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 {
 	rwlock_t		*g_lock = &kiblnd_data.kib_global_lock;
@@ -2448,7 +2450,7 @@ kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 	return -ECONNREFUSED;
 }
 
-void
+static void
 kiblnd_reconnect (kib_conn_t *conn, int version,
 		  __u64 incarnation, int why, kib_connparams_t *cp)
 {
@@ -2512,7 +2514,7 @@ kiblnd_reconnect (kib_conn_t *conn, int version,
 	kiblnd_connect_peer(peer);
 }
 
-void
+static void
 kiblnd_rejected (kib_conn_t *conn, int reason, void *priv, int priv_nob)
 {
 	kib_peer_t    *peer = conn->ibc_peer;
@@ -2651,7 +2653,7 @@ kiblnd_rejected (kib_conn_t *conn, int reason, void *priv, int priv_nob)
 	kiblnd_connreq_done(conn, -ECONNREFUSED);
 }
 
-void
+static void
 kiblnd_check_connreply (kib_conn_t *conn, void *priv, int priv_nob)
 {
 	kib_peer_t    *peer = conn->ibc_peer;
@@ -2750,7 +2752,7 @@ kiblnd_check_connreply (kib_conn_t *conn, void *priv, int priv_nob)
 	kiblnd_connreq_done(conn, 0);
 }
 
-int
+static int
 kiblnd_active_connect (struct rdma_cm_id *cmid)
 {
 	kib_peer_t	      *peer = (kib_peer_t *)cmid->context;
@@ -3021,7 +3023,7 @@ kiblnd_conn_timed_out_locked(kib_conn_t *conn)
 		kiblnd_check_txs_locked(conn, &conn->ibc_active_txs);
 }
 
-void
+static void
 kiblnd_check_conns (int idx)
 {
 	LIST_HEAD (closes);
@@ -3104,7 +3106,7 @@ kiblnd_check_conns (int idx)
 	}
 }
 
-void
+static void
 kiblnd_disconnect_conn (kib_conn_t *conn)
 {
 	LASSERT (!in_interrupt());
@@ -3243,7 +3245,7 @@ kiblnd_qp_event(struct ib_event *event, void *arg)
 	}
 }
 
-void
+static void
 kiblnd_complete (struct ib_wc *wc)
 {
 	switch (kiblnd_wreqid2type(wc->wr_id)) {
-- 
1.9.1

