Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaEUWXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:23:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57026 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEUWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:23:37 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, green@linuxhacker.ru
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: lustre: lnet: klnds: Remove prohibited space in socklnd.c
Date: Wed, 21 May 2014 23:23:33 +0100
Message-Id: <1400711013-15957-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space between function name and open parenthesis
to meet kernel coding style. Also, fix indenting due to changes.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  230 ++++++++++----------
 1 file changed, 116 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index a391d13..6354491 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -1351,8 +1351,8 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 
  failed_2:
 	if (!peer->ksnp_closing &&
-	    list_empty (&peer->ksnp_conns) &&
-	    list_empty (&peer->ksnp_routes)) {
+	    list_empty(&peer->ksnp_conns) &&
+	    list_empty(&peer->ksnp_routes)) {
 		list_add(&zombies, &peer->ksnp_tx_queue);
 		list_del_init(&peer->ksnp_tx_queue);
 		ksocknal_unlink_peer_locked(peer);
@@ -1391,7 +1391,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		LIBCFS_FREE(hello, offsetof(ksock_hello_msg_t,
 					    kshm_ips[LNET_MAX_INTERFACES]));
 
-	LIBCFS_FREE (conn, sizeof(*conn));
+	LIBCFS_FREE(conn, sizeof(*conn));
 
  failed_0:
 	libcfs_sock_release(sock);
@@ -1399,7 +1399,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 }
 
 void
-ksocknal_close_conn_locked (ksock_conn_t *conn, int error)
+ksocknal_close_conn_locked(ksock_conn_t *conn, int error)
 {
 	/* This just does the immmediate housekeeping, and queues the
 	 * connection for the reaper to terminate.
@@ -1409,18 +1409,18 @@ ksocknal_close_conn_locked (ksock_conn_t *conn, int error)
 	ksock_conn_t      *conn2;
 	struct list_head	*tmp;
 
-	LASSERT (peer->ksnp_error == 0);
-	LASSERT (!conn->ksnc_closing);
+	LASSERT(peer->ksnp_error == 0);
+	LASSERT(!conn->ksnc_closing);
 	conn->ksnc_closing = 1;
 
 	/* ksnd_deathrow_conns takes over peer's ref */
-	list_del (&conn->ksnc_list);
+	list_del(&conn->ksnc_list);
 
 	route = conn->ksnc_route;
 	if (route != NULL) {
 		/* dissociate conn from route... */
-		LASSERT (!route->ksnr_deleted);
-		LASSERT ((route->ksnr_connected & (1 << conn->ksnc_type)) != 0);
+		LASSERT(!route->ksnr_deleted);
+		LASSERT((route->ksnr_connected & (1 << conn->ksnc_type)) != 0);
 
 		conn2 = NULL;
 		list_for_each(tmp, &peer->ksnp_conns) {
@@ -1439,19 +1439,19 @@ ksocknal_close_conn_locked (ksock_conn_t *conn, int error)
 
 #if 0	   /* irrelevant with only eager routes */
 		/* make route least favourite */
-		list_del (&route->ksnr_list);
-		list_add_tail (&route->ksnr_list, &peer->ksnp_routes);
+		list_del(&route->ksnr_list);
+		list_add_tail(&route->ksnr_list, &peer->ksnp_routes);
 #endif
 		ksocknal_route_decref(route);     /* drop conn's ref on route */
 	}
 
-	if (list_empty (&peer->ksnp_conns)) {
+	if (list_empty(&peer->ksnp_conns)) {
 		/* No more connections to this peer */
 
 		if (!list_empty(&peer->ksnp_tx_queue)) {
 			ksock_tx_t *tx;
 
-			LASSERT (conn->ksnc_proto == &ksocknal_protocol_v3x);
+			LASSERT(conn->ksnc_proto == &ksocknal_protocol_v3x);
 
 			/* throw them to the last connection...,
 			 * these TXs will be send to /dev/null by scheduler */
@@ -1468,10 +1468,10 @@ ksocknal_close_conn_locked (ksock_conn_t *conn, int error)
 		peer->ksnp_proto = NULL;	/* renegotiate protocol version */
 		peer->ksnp_error = error;       /* stash last conn close reason */
 
-		if (list_empty (&peer->ksnp_routes)) {
+		if (list_empty(&peer->ksnp_routes)) {
 			/* I've just closed last conn belonging to a
 			 * peer with no routes to it */
-			ksocknal_unlink_peer_locked (peer);
+			ksocknal_unlink_peer_locked(peer);
 		}
 	}
 
@@ -1485,7 +1485,7 @@ ksocknal_close_conn_locked (ksock_conn_t *conn, int error)
 }
 
 void
-ksocknal_peer_failed (ksock_peer_t *peer)
+ksocknal_peer_failed(ksock_peer_t *peer)
 {
 	int	notify = 0;
 	cfs_time_t last_alive = 0;
@@ -1507,8 +1507,8 @@ ksocknal_peer_failed (ksock_peer_t *peer)
 	read_unlock(&ksocknal_data.ksnd_global_lock);
 
 	if (notify)
-		lnet_notify (peer->ksnp_ni, peer->ksnp_id.nid, 0,
-			     last_alive);
+		lnet_notify(peer->ksnp_ni, peer->ksnp_id.nid, 0,
+			    last_alive);
 }
 
 void
@@ -1521,7 +1521,7 @@ ksocknal_finalize_zcreq(ksock_conn_t *conn)
 
 	/* NB safe to finalize TXs because closing of socket will
 	 * abort all buffered data */
-	LASSERT (conn->ksnc_sock == NULL);
+	LASSERT(conn->ksnc_sock == NULL);
 
 	spin_lock(&peer->ksnp_lock);
 
@@ -1529,7 +1529,7 @@ ksocknal_finalize_zcreq(ksock_conn_t *conn)
 		if (tx->tx_conn != conn)
 			continue;
 
-		LASSERT (tx->tx_msg.ksm_zc_cookies[0] != 0);
+		LASSERT(tx->tx_msg.ksm_zc_cookies[0] != 0);
 
 		tx->tx_msg.ksm_zc_cookies[0] = 0;
 		tx->tx_zc_aborted = 1; /* mark it as not-acked */
@@ -1548,7 +1548,7 @@ ksocknal_finalize_zcreq(ksock_conn_t *conn)
 }
 
 void
-ksocknal_terminate_conn (ksock_conn_t *conn)
+ksocknal_terminate_conn(ksock_conn_t *conn)
 {
 	/* This gets called by the reaper (guaranteed thread context) to
 	 * disengage the socket from its callbacks and close it.
@@ -1568,13 +1568,13 @@ ksocknal_terminate_conn (ksock_conn_t *conn)
 
 	if (!conn->ksnc_tx_scheduled &&
 	    !list_empty(&conn->ksnc_tx_queue)){
-		list_add_tail (&conn->ksnc_tx_list,
-			       &sched->kss_tx_conns);
+		list_add_tail(&conn->ksnc_tx_list,
+			      &sched->kss_tx_conns);
 		conn->ksnc_tx_scheduled = 1;
 		/* extra ref for scheduler */
 		ksocknal_conn_addref(conn);
 
-		wake_up (&sched->kss_waitq);
+		wake_up(&sched->kss_waitq);
 	}
 
 	spin_unlock_bh(&sched->kss_lock);
@@ -1590,7 +1590,7 @@ ksocknal_terminate_conn (ksock_conn_t *conn)
 
 	if (peer->ksnp_error != 0) {
 		/* peer's last conn closed in error */
-		LASSERT (list_empty (&peer->ksnp_conns));
+		LASSERT(list_empty(&peer->ksnp_conns));
 		failed = 1;
 		peer->ksnp_error = 0;     /* avoid multiple notifications */
 	}
@@ -1609,7 +1609,7 @@ ksocknal_terminate_conn (ksock_conn_t *conn)
 }
 
 void
-ksocknal_queue_zombie_conn (ksock_conn_t *conn)
+ksocknal_queue_zombie_conn(ksock_conn_t *conn)
 {
 	/* Queue the conn for the reaper to destroy */
 
@@ -1623,20 +1623,20 @@ ksocknal_queue_zombie_conn (ksock_conn_t *conn)
 }
 
 void
-ksocknal_destroy_conn (ksock_conn_t *conn)
+ksocknal_destroy_conn(ksock_conn_t *conn)
 {
 	cfs_time_t      last_rcv;
 
 	/* Final coup-de-grace of the reaper */
-	CDEBUG (D_NET, "connection %p\n", conn);
+	CDEBUG(D_NET, "connection %p\n", conn);
 
-	LASSERT (atomic_read (&conn->ksnc_conn_refcount) == 0);
-	LASSERT (atomic_read (&conn->ksnc_sock_refcount) == 0);
-	LASSERT (conn->ksnc_sock == NULL);
-	LASSERT (conn->ksnc_route == NULL);
-	LASSERT (!conn->ksnc_tx_scheduled);
-	LASSERT (!conn->ksnc_rx_scheduled);
-	LASSERT (list_empty(&conn->ksnc_tx_queue));
+	LASSERT(atomic_read(&conn->ksnc_conn_refcount) == 0);
+	LASSERT(atomic_read(&conn->ksnc_sock_refcount) == 0);
+	LASSERT(conn->ksnc_sock == NULL);
+	LASSERT(conn->ksnc_route == NULL);
+	LASSERT(!conn->ksnc_tx_scheduled);
+	LASSERT(!conn->ksnc_rx_scheduled);
+	LASSERT(list_empty(&conn->ksnc_tx_queue));
 
 	/* complete current receive if any */
 	switch (conn->ksnc_rx_state) {
@@ -1651,8 +1651,8 @@ ksocknal_destroy_conn (ksock_conn_t *conn)
 		       conn->ksnc_rx_nob_wanted, conn->ksnc_rx_nob_left,
 		       cfs_duration_sec(cfs_time_sub(cfs_time_current(),
 					last_rcv)));
-		lnet_finalize (conn->ksnc_peer->ksnp_ni,
-			       conn->ksnc_cookie, -EIO);
+		lnet_finalize(conn->ksnc_peer->ksnp_ni,
+			      conn->ksnc_cookie, -EIO);
 		break;
 	case SOCKNAL_RX_LNET_HEADER:
 		if (conn->ksnc_rx_started)
@@ -1684,24 +1684,24 @@ ksocknal_destroy_conn (ksock_conn_t *conn)
 
 	ksocknal_peer_decref(conn->ksnc_peer);
 
-	LIBCFS_FREE (conn, sizeof (*conn));
+	LIBCFS_FREE(conn, sizeof(*conn));
 }
 
 int
-ksocknal_close_peer_conns_locked (ksock_peer_t *peer, __u32 ipaddr, int why)
+ksocknal_close_peer_conns_locked(ksock_peer_t *peer, __u32 ipaddr, int why)
 {
 	ksock_conn_t       *conn;
 	struct list_head	 *ctmp;
 	struct list_head	 *cnxt;
 	int		 count = 0;
 
-	list_for_each_safe (ctmp, cnxt, &peer->ksnp_conns) {
-		conn = list_entry (ctmp, ksock_conn_t, ksnc_list);
+	list_for_each_safe(ctmp, cnxt, &peer->ksnp_conns) {
+		conn = list_entry(ctmp, ksock_conn_t, ksnc_list);
 
 		if (ipaddr == 0 ||
 		    conn->ksnc_ipaddr == ipaddr) {
 			count++;
-			ksocknal_close_conn_locked (conn, why);
+			ksocknal_close_conn_locked(conn, why);
 		}
 	}
 
@@ -1709,7 +1709,7 @@ ksocknal_close_peer_conns_locked (ksock_peer_t *peer, __u32 ipaddr, int why)
 }
 
 int
-ksocknal_close_conn_and_siblings (ksock_conn_t *conn, int why)
+ksocknal_close_conn_and_siblings(ksock_conn_t *conn, int why)
 {
 	ksock_peer_t     *peer = conn->ksnc_peer;
 	__u32	     ipaddr = conn->ksnc_ipaddr;
@@ -1717,7 +1717,7 @@ ksocknal_close_conn_and_siblings (ksock_conn_t *conn, int why)
 
 	write_lock_bh(&ksocknal_data.ksnd_global_lock);
 
-	count = ksocknal_close_peer_conns_locked (peer, ipaddr, why);
+	count = ksocknal_close_peer_conns_locked(peer, ipaddr, why);
 
 	write_unlock_bh(&ksocknal_data.ksnd_global_lock);
 
@@ -1725,7 +1725,7 @@ ksocknal_close_conn_and_siblings (ksock_conn_t *conn, int why)
 }
 
 int
-ksocknal_close_matching_conns (lnet_process_id_t id, __u32 ipaddr)
+ksocknal_close_matching_conns(lnet_process_id_t id, __u32 ipaddr)
 {
 	ksock_peer_t       *peer;
 	struct list_head	 *ptmp;
@@ -1745,16 +1745,17 @@ ksocknal_close_matching_conns (lnet_process_id_t id, __u32 ipaddr)
 	}
 
 	for (i = lo; i <= hi; i++) {
-		list_for_each_safe (ptmp, pnxt,
+		list_for_each_safe(ptmp, pnxt,
 					&ksocknal_data.ksnd_peers[i]) {
 
-			peer = list_entry (ptmp, ksock_peer_t, ksnp_list);
+			peer = list_entry(ptmp, ksock_peer_t, ksnp_list);
 
 			if (!((id.nid == LNET_NID_ANY || id.nid == peer->ksnp_id.nid) &&
 			      (id.pid == LNET_PID_ANY || id.pid == peer->ksnp_id.pid)))
 				continue;
 
-			count += ksocknal_close_peer_conns_locked (peer, ipaddr, 0);
+			count += ksocknal_close_peer_conns_locked(peer,
+								  ipaddr, 0);
 		}
 	}
 
@@ -1771,7 +1772,7 @@ ksocknal_close_matching_conns (lnet_process_id_t id, __u32 ipaddr)
 }
 
 void
-ksocknal_notify (lnet_ni_t *ni, lnet_nid_t gw_nid, int alive)
+ksocknal_notify(lnet_ni_t *ni, lnet_nid_t gw_nid, int alive)
 {
 	/* The router is telling me she's been notified of a change in
 	 * gateway state.... */
@@ -1780,12 +1781,12 @@ ksocknal_notify (lnet_ni_t *ni, lnet_nid_t gw_nid, int alive)
 	id.nid = gw_nid;
 	id.pid = LNET_PID_ANY;
 
-	CDEBUG (D_NET, "gw %s %s\n", libcfs_nid2str(gw_nid),
-		alive ? "up" : "down");
+	CDEBUG(D_NET, "gw %s %s\n", libcfs_nid2str(gw_nid),
+	       alive ? "up" : "down");
 
 	if (!alive) {
 		/* If the gateway crashed, close all open connections... */
-		ksocknal_close_matching_conns (id, 0);
+		ksocknal_close_matching_conns(id, 0);
 		return;
 	}
 
@@ -1794,7 +1795,7 @@ ksocknal_notify (lnet_ni_t *ni, lnet_nid_t gw_nid, int alive)
 }
 
 void
-ksocknal_query (lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
+ksocknal_query(lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
 {
 	int		connect = 1;
 	cfs_time_t	 last_alive = 0;
@@ -1811,7 +1812,7 @@ ksocknal_query (lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
 		ksock_conn_t     *conn;
 		int	       bufnob;
 
-		list_for_each (tmp, &peer->ksnp_conns) {
+		list_for_each(tmp, &peer->ksnp_conns) {
 			conn = list_entry(tmp, ksock_conn_t, ksnc_list);
 			bufnob = cfs_sock_wmem_queued(conn->ksnc_sock);
 
@@ -1855,7 +1856,7 @@ ksocknal_query (lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
 }
 
 void
-ksocknal_push_peer (ksock_peer_t *peer)
+ksocknal_push_peer(ksock_peer_t *peer)
 {
 	int	       index;
 	int	       i;
@@ -1868,9 +1869,9 @@ ksocknal_push_peer (ksock_peer_t *peer)
 		i = 0;
 		conn = NULL;
 
-		list_for_each (tmp, &peer->ksnp_conns) {
+		list_for_each(tmp, &peer->ksnp_conns) {
 			if (i++ == index) {
-				conn = list_entry (tmp, ksock_conn_t,
+				conn = list_entry(tmp, ksock_conn_t,
 						       ksnc_list);
 				ksocknal_conn_addref(conn);
 				break;
@@ -1882,13 +1883,13 @@ ksocknal_push_peer (ksock_peer_t *peer)
 		if (conn == NULL)
 			break;
 
-		ksocknal_lib_push_conn (conn);
+		ksocknal_lib_push_conn(conn);
 		ksocknal_conn_decref(conn);
 	}
 }
 
 int
-ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
+ksocknal_push(lnet_ni_t *ni, lnet_process_id_t id)
 {
 	ksock_peer_t      *peer;
 	struct list_head	*tmp;
@@ -1904,7 +1905,7 @@ ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
 			index = 0;
 			peer = NULL;
 
-			list_for_each (tmp, &ksocknal_data.ksnd_peers[i]) {
+			list_for_each(tmp, &ksocknal_data.ksnd_peers[i]) {
 				peer = list_entry(tmp, ksock_peer_t,
 						      ksnp_list);
 
@@ -1926,7 +1927,7 @@ ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
 
 			if (peer != NULL) {
 				rc = 0;
-				ksocknal_push_peer (peer);
+				ksocknal_push_peer(peer);
 				ksocknal_peer_decref(peer);
 			}
 		}
@@ -2018,7 +2019,7 @@ ksocknal_peer_del_interface_locked(ksock_peer_t *peer, __u32 ipaddr)
 		}
 
 	list_for_each_safe(tmp, nxt, &peer->ksnp_routes) {
-		route = list_entry (tmp, ksock_route_t, ksnr_list);
+		route = list_entry(tmp, ksock_route_t, ksnr_list);
 
 		if (route->ksnr_myipaddr != ipaddr)
 			continue;
@@ -2035,7 +2036,7 @@ ksocknal_peer_del_interface_locked(ksock_peer_t *peer, __u32 ipaddr)
 		conn = list_entry(tmp, ksock_conn_t, ksnc_list);
 
 		if (conn->ksnc_myipaddr == ipaddr)
-			ksocknal_close_conn_locked (conn, 0);
+			ksocknal_close_conn_locked(conn, 0);
 	}
 }
 
@@ -2152,21 +2153,22 @@ ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 	case IOC_LIBCFS_ADD_PEER:
 		id.nid = data->ioc_nid;
 		id.pid = LUSTRE_SRV_LNET_PID;
-		return ksocknal_add_peer (ni, id,
-					  data->ioc_u32[0], /* IP */
-					  data->ioc_u32[1]); /* port */
+		return ksocknal_add_peer(ni, id,
+					 data->ioc_u32[0], /* IP */
+					 data->ioc_u32[1]); /* port */
 
 	case IOC_LIBCFS_DEL_PEER:
 		id.nid = data->ioc_nid;
 		id.pid = LNET_PID_ANY;
-		return ksocknal_del_peer (ni, id,
-					  data->ioc_u32[0]); /* IP */
+		return ksocknal_del_peer(ni, id,
+					 data->ioc_u32[0]); /* IP */
 
 	case IOC_LIBCFS_GET_CONN: {
 		int	   txmem;
 		int	   rxmem;
 		int	   nagle;
-		ksock_conn_t *conn = ksocknal_get_conn_by_idx (ni, data->ioc_count);
+		ksock_conn_t *conn = ksocknal_get_conn_by_idx(ni,
+							      data->ioc_count);
 
 		if (conn == NULL)
 			return -ENOENT;
@@ -2190,8 +2192,8 @@ ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 	case IOC_LIBCFS_CLOSE_CONNECTION:
 		id.nid = data->ioc_nid;
 		id.pid = LNET_PID_ANY;
-		return ksocknal_close_matching_conns (id,
-						      data->ioc_u32[0]);
+		return ksocknal_close_matching_conns(id,
+						     data->ioc_u32[0]);
 
 	case IOC_LIBCFS_REGISTER_MYNID:
 		/* Ignore if this is a noop */
@@ -2215,9 +2217,9 @@ ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 }
 
 void
-ksocknal_free_buffers (void)
+ksocknal_free_buffers(void)
 {
-	LASSERT (atomic_read(&ksocknal_data.ksnd_nactive_txs) == 0);
+	LASSERT(atomic_read(&ksocknal_data.ksnd_nactive_txs) == 0);
 
 	if (ksocknal_data.ksnd_sched_info != NULL) {
 		struct ksock_sched_info	*info;
@@ -2233,9 +2235,9 @@ ksocknal_free_buffers (void)
 		cfs_percpt_free(ksocknal_data.ksnd_sched_info);
 	}
 
-	LIBCFS_FREE (ksocknal_data.ksnd_peers,
-		     sizeof (struct list_head) *
-		     ksocknal_data.ksnd_peer_hash_size);
+	LIBCFS_FREE(ksocknal_data.ksnd_peers,
+		    sizeof(struct list_head) *
+		    ksocknal_data.ksnd_peer_hash_size);
 
 	spin_lock(&ksocknal_data.ksnd_tx_lock);
 
@@ -2266,25 +2268,25 @@ ksocknal_base_shutdown(void)
 	int			j;
 
 	CDEBUG(D_MALLOC, "before NAL cleanup: kmem %d\n",
-	       atomic_read (&libcfs_kmemory));
-	LASSERT (ksocknal_data.ksnd_nnets == 0);
+	       atomic_read(&libcfs_kmemory));
+	LASSERT(ksocknal_data.ksnd_nnets == 0);
 
 	switch (ksocknal_data.ksnd_init) {
 	default:
-		LASSERT (0);
+		LASSERT(0);
 
 	case SOCKNAL_INIT_ALL:
 	case SOCKNAL_INIT_DATA:
-		LASSERT (ksocknal_data.ksnd_peers != NULL);
+		LASSERT(ksocknal_data.ksnd_peers != NULL);
 		for (i = 0; i < ksocknal_data.ksnd_peer_hash_size; i++) {
-			LASSERT (list_empty (&ksocknal_data.ksnd_peers[i]));
+			LASSERT(list_empty(&ksocknal_data.ksnd_peers[i]));
 		}
 
 		LASSERT(list_empty(&ksocknal_data.ksnd_nets));
-		LASSERT (list_empty (&ksocknal_data.ksnd_enomem_conns));
-		LASSERT (list_empty (&ksocknal_data.ksnd_zombie_conns));
-		LASSERT (list_empty (&ksocknal_data.ksnd_connd_connreqs));
-		LASSERT (list_empty (&ksocknal_data.ksnd_connd_routes));
+		LASSERT(list_empty(&ksocknal_data.ksnd_enomem_conns));
+		LASSERT(list_empty(&ksocknal_data.ksnd_zombie_conns));
+		LASSERT(list_empty(&ksocknal_data.ksnd_connd_connreqs));
+		LASSERT(list_empty(&ksocknal_data.ksnd_connd_routes));
 
 		if (ksocknal_data.ksnd_sched_info != NULL) {
 			cfs_percpt_for_each(info, i,
@@ -2345,13 +2347,13 @@ ksocknal_base_shutdown(void)
 	}
 
 	CDEBUG(D_MALLOC, "after NAL cleanup: kmem %d\n",
-	       atomic_read (&libcfs_kmemory));
+	       atomic_read(&libcfs_kmemory));
 
 	module_put(THIS_MODULE);
 }
 
 __u64
-ksocknal_new_incarnation (void)
+ksocknal_new_incarnation(void)
 {
 	struct timeval tv;
 
@@ -2372,8 +2374,8 @@ ksocknal_base_startup(void)
 	int			rc;
 	int			i;
 
-	LASSERT (ksocknal_data.ksnd_init == SOCKNAL_INIT_NOTHING);
-	LASSERT (ksocknal_data.ksnd_nnets == 0);
+	LASSERT(ksocknal_data.ksnd_init == SOCKNAL_INIT_NOTHING);
+	LASSERT(ksocknal_data.ksnd_nnets == 0);
 
 	memset (&ksocknal_data, 0, sizeof (ksocknal_data)); /* zero pointers */
 
@@ -2391,18 +2393,18 @@ ksocknal_base_startup(void)
 	INIT_LIST_HEAD(&ksocknal_data.ksnd_nets);
 
 	spin_lock_init(&ksocknal_data.ksnd_reaper_lock);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_enomem_conns);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_zombie_conns);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_deathrow_conns);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_enomem_conns);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_zombie_conns);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_deathrow_conns);
 	init_waitqueue_head(&ksocknal_data.ksnd_reaper_waitq);
 
 	spin_lock_init(&ksocknal_data.ksnd_connd_lock);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_connd_connreqs);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_connd_routes);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_connd_connreqs);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_connd_routes);
 	init_waitqueue_head(&ksocknal_data.ksnd_connd_waitq);
 
 	spin_lock_init(&ksocknal_data.ksnd_tx_lock);
-	INIT_LIST_HEAD (&ksocknal_data.ksnd_idle_noop_txs);
+	INIT_LIST_HEAD(&ksocknal_data.ksnd_idle_noop_txs);
 
 	/* NB memset above zeros whole of ksocknal_data */
 
@@ -2483,7 +2485,7 @@ ksocknal_base_startup(void)
 
 	rc = ksocknal_thread_start(ksocknal_reaper, NULL, "socknal_reaper");
 	if (rc != 0) {
-		CERROR ("Can't spawn socknal reaper: %d\n", rc);
+		CERROR("Can't spawn socknal reaper: %d\n", rc);
 		goto failed;
 	}
 
@@ -2498,7 +2500,7 @@ ksocknal_base_startup(void)
 }
 
 void
-ksocknal_debug_peerhash (lnet_ni_t *ni)
+ksocknal_debug_peerhash(lnet_ni_t *ni)
 {
 	ksock_peer_t	*peer = NULL;
 	struct list_head	*tmp;
@@ -2507,8 +2509,8 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 	read_lock(&ksocknal_data.ksnd_global_lock);
 
 	for (i = 0; i < ksocknal_data.ksnd_peer_hash_size; i++) {
-		list_for_each (tmp, &ksocknal_data.ksnd_peers[i]) {
-			peer = list_entry (tmp, ksock_peer_t, ksnp_list);
+		list_for_each(tmp, &ksocknal_data.ksnd_peers[i]) {
+			peer = list_entry(tmp, ksock_peer_t, ksnp_list);
 
 			if (peer->ksnp_ni == ni) break;
 
@@ -2530,7 +2532,7 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 		       !list_empty(&peer->ksnp_tx_queue),
 		       !list_empty(&peer->ksnp_zc_req_list));
 
-		list_for_each (tmp, &peer->ksnp_routes) {
+		list_for_each(tmp, &peer->ksnp_routes) {
 			route = list_entry(tmp, ksock_route_t, ksnr_list);
 			CWARN ("Route: ref %d, schd %d, conn %d, cnted %d, "
 			       "del %d\n", atomic_read(&route->ksnr_refcount),
@@ -2538,12 +2540,12 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 			       route->ksnr_connected, route->ksnr_deleted);
 		}
 
-		list_for_each (tmp, &peer->ksnp_conns) {
+		list_for_each(tmp, &peer->ksnp_conns) {
 			conn = list_entry(tmp, ksock_conn_t, ksnc_list);
-			CWARN ("Conn: ref %d, sref %d, t %d, c %d\n",
-			       atomic_read(&conn->ksnc_conn_refcount),
-			       atomic_read(&conn->ksnc_sock_refcount),
-			       conn->ksnc_type, conn->ksnc_closing);
+			CWARN("Conn: ref %d, sref %d, t %d, c %d\n",
+			      atomic_read(&conn->ksnc_conn_refcount),
+			      atomic_read(&conn->ksnc_sock_refcount),
+			      conn->ksnc_type, conn->ksnc_closing);
 		}
 	}
 
@@ -2552,7 +2554,7 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 }
 
 void
-ksocknal_shutdown (lnet_ni_t *ni)
+ksocknal_shutdown(lnet_ni_t *ni)
 {
 	ksock_net_t      *net = ni->ni_data;
 	int	       i;
@@ -2591,8 +2593,8 @@ ksocknal_shutdown (lnet_ni_t *ni)
 	spin_unlock_bh(&net->ksnn_lock);
 
 	for (i = 0; i < net->ksnn_ninterfaces; i++) {
-		LASSERT (net->ksnn_interfaces[i].ksni_npeers == 0);
-		LASSERT (net->ksnn_interfaces[i].ksni_nroutes == 0);
+		LASSERT(net->ksnn_interfaces[i].ksni_npeers == 0);
+		LASSERT(net->ksnn_interfaces[i].ksni_nroutes == 0);
 	}
 
 	list_del(&net->ksnn_list);
@@ -2775,13 +2777,13 @@ ksocknal_net_start_threads(ksock_net_t *net, __u32 *cpts, int ncpts)
 }
 
 int
-ksocknal_startup (lnet_ni_t *ni)
+ksocknal_startup(lnet_ni_t *ni)
 {
 	ksock_net_t  *net;
 	int	   rc;
 	int	   i;
 
-	LASSERT (ni->ni_lnd == &the_ksocklnd);
+	LASSERT(ni->ni_lnd == &the_ksocklnd);
 
 	if (ksocknal_data.ksnd_init == SOCKNAL_INIT_NOTHING) {
 		rc = ksocknal_base_startup();
@@ -2861,19 +2863,19 @@ ksocknal_startup (lnet_ni_t *ni)
 
 
 void __exit
-ksocknal_module_fini (void)
+ksocknal_module_fini(void)
 {
 	lnet_unregister_lnd(&the_ksocklnd);
 }
 
 int __init
-ksocknal_module_init (void)
+ksocknal_module_init(void)
 {
 	int    rc;
 
 	/* check ksnr_connected/connecting field large enough */
-	CLASSERT (SOCKLND_CONN_NTYPES <= 4);
-	CLASSERT (SOCKLND_CONN_ACK == SOCKLND_CONN_BULK_IN);
+	CLASSERT(SOCKLND_CONN_NTYPES <= 4);
+	CLASSERT(SOCKLND_CONN_ACK == SOCKLND_CONN_BULK_IN);
 
 	/* initialize the_ksocklnd */
 	the_ksocklnd.lnd_type     = SOCKLND;
-- 
1.7.9.5

