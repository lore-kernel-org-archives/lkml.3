Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaHSPqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:46:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51108 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaHSPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:46:18 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, amir.shehata@intel.com, green@linuxhacker.ru,
        massa.nomura@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] staging: lustre: lnet: socklnd_cb.c Fix sparse non-static symbol warning
Date: Tue, 19 Aug 2014 22:45:50 +0700
Message-Id: <1408463150-5494-1-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some non static function declarations that
cause sparse warning. Tested by compilation.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 5214399..c49b01e 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -107,7 +107,7 @@ ksocknal_free_tx (ksock_tx_t *tx)
 	}
 }
 
-int
+static int
 ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 {
 	struct iovec  *iov = tx->tx_iov;
@@ -144,7 +144,7 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 	return rc;
 }
 
-int
+static int
 ksocknal_send_kiov (ksock_conn_t *conn, ksock_tx_t *tx)
 {
 	lnet_kiov_t    *kiov = tx->tx_kiov;
@@ -182,7 +182,7 @@ ksocknal_send_kiov (ksock_conn_t *conn, ksock_tx_t *tx)
 	return rc;
 }
 
-int
+static int
 ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 {
 	int      rc;
@@ -248,7 +248,7 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	return rc;
 }
 
-int
+static int
 ksocknal_recv_iov (ksock_conn_t *conn)
 {
 	struct iovec *iov = conn->ksnc_rx_iov;
@@ -293,7 +293,7 @@ ksocknal_recv_iov (ksock_conn_t *conn)
 	return rc;
 }
 
-int
+static int
 ksocknal_recv_kiov (ksock_conn_t *conn)
 {
 	lnet_kiov_t   *kiov = conn->ksnc_rx_kiov;
@@ -337,7 +337,7 @@ ksocknal_recv_kiov (ksock_conn_t *conn)
 	return 1;
 }
 
-int
+static int
 ksocknal_receive (ksock_conn_t *conn)
 {
 	/* Return 1 on success, 0 on EOF, < 0 on error.
@@ -499,7 +499,7 @@ ksocknal_uncheck_zc_req(ksock_tx_t *tx)
 	ksocknal_tx_decref(tx);
 }
 
-int
+static int
 ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 {
 	int	    rc;
@@ -579,7 +579,7 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	return rc;
 }
 
-void
+static void
 ksocknal_launch_connection_locked (ksock_route_t *route)
 {
 
@@ -1109,7 +1109,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 	return 0;
 }
 
-int
+static int
 ksocknal_process_receive (ksock_conn_t *conn)
 {
 	lnet_hdr_t	*lhdr;
@@ -1608,7 +1608,7 @@ void ksocknal_write_callback (ksock_conn_t *conn)
 	spin_unlock_bh(&sched->kss_lock);
 }
 
-ksock_proto_t *
+static ksock_proto_t *
 ksocknal_parse_proto_version (ksock_hello_msg_t *hello)
 {
 	__u32   version = 0;
@@ -1672,7 +1672,7 @@ ksocknal_send_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	return conn->ksnc_proto->pro_send_hello(conn, hello);
 }
 
-int
+static int
 ksocknal_invert_type(int type)
 {
 	switch (type)
@@ -1837,7 +1837,7 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	return 0;
 }
 
-int
+static int
 ksocknal_connect (ksock_route_t *route)
 {
 	LIST_HEAD    (zombies);
@@ -2244,7 +2244,7 @@ ksocknal_connd (void *arg)
 	return 0;
 }
 
-ksock_conn_t *
+static ksock_conn_t *
 ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 {
 	/* We're called with a shared lock on ksnd_global_lock */
@@ -2354,7 +2354,7 @@ ksocknal_flush_stale_txs(ksock_peer_t *peer)
 	ksocknal_txlist_done(peer->ksnp_ni, &stale_txs, 1);
 }
 
-int
+static int
 ksocknal_send_keepalive_locked(ksock_peer_t *peer)
 {
 	ksock_sched_t  *sched;
@@ -2415,7 +2415,7 @@ ksocknal_send_keepalive_locked(ksock_peer_t *peer)
 }
 
 
-void
+static void
 ksocknal_check_peer_timeouts (int idx)
 {
 	struct list_head       *peers = &ksocknal_data.ksnd_peers[idx];
-- 
1.9.3

