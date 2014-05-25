Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaEYWYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:24:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51523 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaEYWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:24:15 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, green@linuxhacker.ru
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: lustre: lnet: klnds: Fix coding style in socklnd.c
Date: Sun, 25 May 2014 23:24:12 +0100
Message-Id: <1401056652-596-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prohibited space between function name and
open parenthesis to meet kernel coding style.
Also fix indenting due to changes to keep readability.

-since v2:
None. This is the resend of v2 as v2 failed to apply

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  242 ++++++++++----------
 1 file changed, 120 insertions(+), 122 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..39b607f 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -65,15 +65,15 @@ ksocknal_ip2iface(lnet_ni_t *ni, __u32 ip)
 }
 
 ksock_route_t *
-ksocknal_create_route (__u32 ipaddr, int port)
+ksocknal_create_route(__u32 ipaddr, int port)
 {
 	ksock_route_t *route;
 
-	LIBCFS_ALLOC (route, sizeof (*route));
+	LIBCFS_ALLOC(route, sizeof(*route));
 	if (route == NULL)
 		return (NULL);
 
-	atomic_set (&route->ksnr_refcount, 1);
+	atomic_set(&route->ksnr_refcount, 1);
 	route->ksnr_peer = NULL;
 	route->ksnr_retry_interval = 0;	 /* OK to connect at any time */
 	route->ksnr_ipaddr = ipaddr;
@@ -89,27 +89,27 @@ ksocknal_create_route (__u32 ipaddr, int port)
 }
 
 void
-ksocknal_destroy_route (ksock_route_t *route)
+ksocknal_destroy_route(ksock_route_t *route)
 {
-	LASSERT (atomic_read(&route->ksnr_refcount) == 0);
+	LASSERT(atomic_read(&route->ksnr_refcount) == 0);
 
 	if (route->ksnr_peer != NULL)
 		ksocknal_peer_decref(route->ksnr_peer);
 
-	LIBCFS_FREE (route, sizeof (*route));
+	LIBCFS_FREE(route, sizeof(*route));
 }
 
 int
-ksocknal_create_peer (ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
+ksocknal_create_peer(ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 {
 	ksock_net_t   *net = ni->ni_data;
 	ksock_peer_t  *peer;
 
-	LASSERT (id.nid != LNET_NID_ANY);
-	LASSERT (id.pid != LNET_PID_ANY);
-	LASSERT (!in_interrupt());
+	LASSERT(id.nid != LNET_NID_ANY);
+	LASSERT(id.pid != LNET_PID_ANY);
+	LASSERT(!in_interrupt());
 
-	LIBCFS_ALLOC (peer, sizeof (*peer));
+	LIBCFS_ALLOC(peer, sizeof(*peer));
 	if (peer == NULL)
 		return -ENOMEM;
 
@@ -117,17 +117,17 @@ ksocknal_create_peer (ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 
 	peer->ksnp_ni = ni;
 	peer->ksnp_id = id;
-	atomic_set (&peer->ksnp_refcount, 1);   /* 1 ref for caller */
+	atomic_set(&peer->ksnp_refcount, 1);   /* 1 ref for caller */
 	peer->ksnp_closing = 0;
 	peer->ksnp_accepting = 0;
 	peer->ksnp_proto = NULL;
 	peer->ksnp_last_alive = 0;
 	peer->ksnp_zc_next_cookie = SOCKNAL_KEEPALIVE_PING + 1;
 
-	INIT_LIST_HEAD (&peer->ksnp_conns);
-	INIT_LIST_HEAD (&peer->ksnp_routes);
-	INIT_LIST_HEAD (&peer->ksnp_tx_queue);
-	INIT_LIST_HEAD (&peer->ksnp_zc_req_list);
+	INIT_LIST_HEAD(&peer->ksnp_conns);
+	INIT_LIST_HEAD(&peer->ksnp_routes);
+	INIT_LIST_HEAD(&peer->ksnp_tx_queue);
+	INIT_LIST_HEAD(&peer->ksnp_zc_req_list);
 	spin_lock_init(&peer->ksnp_lock);
 
 	spin_lock_bh(&net->ksnn_lock);
@@ -149,21 +149,21 @@ ksocknal_create_peer (ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 }
 
 void
-ksocknal_destroy_peer (ksock_peer_t *peer)
+ksocknal_destroy_peer(ksock_peer_t *peer)
 {
 	ksock_net_t    *net = peer->ksnp_ni->ni_data;
 
-	CDEBUG (D_NET, "peer %s %p deleted\n",
-		libcfs_id2str(peer->ksnp_id), peer);
+	CDEBUG(D_NET, "peer %s %p deleted\n",
+	       libcfs_id2str(peer->ksnp_id), peer);
 
-	LASSERT (atomic_read (&peer->ksnp_refcount) == 0);
-	LASSERT (peer->ksnp_accepting == 0);
-	LASSERT (list_empty (&peer->ksnp_conns));
-	LASSERT (list_empty (&peer->ksnp_routes));
-	LASSERT (list_empty (&peer->ksnp_tx_queue));
-	LASSERT (list_empty (&peer->ksnp_zc_req_list));
+	LASSERT(atomic_read(&peer->ksnp_refcount) == 0);
+	LASSERT(peer->ksnp_accepting == 0);
+	LASSERT(list_empty(&peer->ksnp_conns));
+	LASSERT(list_empty(&peer->ksnp_routes));
+	LASSERT(list_empty(&peer->ksnp_tx_queue));
+	LASSERT(list_empty(&peer->ksnp_zc_req_list));
 
-	LIBCFS_FREE (peer, sizeof (*peer));
+	LIBCFS_FREE(peer, sizeof(*peer));
 
 	/* NB a peer's connections and routes keep a reference on their peer
 	 * until they are destroyed, so we can be assured that _all_ state to
@@ -175,17 +175,17 @@ ksocknal_destroy_peer (ksock_peer_t *peer)
 }
 
 ksock_peer_t *
-ksocknal_find_peer_locked (lnet_ni_t *ni, lnet_process_id_t id)
+ksocknal_find_peer_locked(lnet_ni_t *ni, lnet_process_id_t id)
 {
 	struct list_head       *peer_list = ksocknal_nid2peerlist(id.nid);
 	struct list_head       *tmp;
 	ksock_peer_t     *peer;
 
-	list_for_each (tmp, peer_list) {
+	list_for_each(tmp, peer_list) {
 
-		peer = list_entry (tmp, ksock_peer_t, ksnp_list);
+		peer = list_entry(tmp, ksock_peer_t, ksnp_list);
 
-		LASSERT (!peer->ksnp_closing);
+		LASSERT(!peer->ksnp_closing);
 
 		if (peer->ksnp_ni != ni)
 			continue;
@@ -203,7 +203,7 @@ ksocknal_find_peer_locked (lnet_ni_t *ni, lnet_process_id_t id)
 }
 
 ksock_peer_t *
-ksocknal_find_peer (lnet_ni_t *ni, lnet_process_id_t id)
+ksocknal_find_peer(lnet_ni_t *ni, lnet_process_id_t id)
 {
 	ksock_peer_t     *peer;
 
@@ -217,39 +217,39 @@ ksocknal_find_peer (lnet_ni_t *ni, lnet_process_id_t id)
 }
 
 void
-ksocknal_unlink_peer_locked (ksock_peer_t *peer)
+ksocknal_unlink_peer_locked(ksock_peer_t *peer)
 {
 	int		i;
 	__u32	      ip;
 	ksock_interface_t *iface;
 
 	for (i = 0; i < peer->ksnp_n_passive_ips; i++) {
-		LASSERT (i < LNET_MAX_INTERFACES);
+		LASSERT(i < LNET_MAX_INTERFACES);
 		ip = peer->ksnp_passive_ips[i];
 
 		iface = ksocknal_ip2iface(peer->ksnp_ni, ip);
 		/* All IPs in peer->ksnp_passive_ips[] come from the
 		 * interface list, therefore the call must succeed. */
-		LASSERT (iface != NULL);
+		LASSERT(iface != NULL);
 
 		CDEBUG(D_NET, "peer=%p iface=%p ksni_nroutes=%d\n",
 		       peer, iface, iface->ksni_nroutes);
 		iface->ksni_npeers--;
 	}
 
-	LASSERT (list_empty(&peer->ksnp_conns));
-	LASSERT (list_empty(&peer->ksnp_routes));
-	LASSERT (!peer->ksnp_closing);
+	LASSERT(list_empty(&peer->ksnp_conns));
+	LASSERT(list_empty(&peer->ksnp_routes));
+	LASSERT(!peer->ksnp_closing);
 	peer->ksnp_closing = 1;
-	list_del (&peer->ksnp_list);
+	list_del(&peer->ksnp_list);
 	/* lose peerlist's ref */
 	ksocknal_peer_decref(peer);
 }
 
 int
-ksocknal_get_peer_info (lnet_ni_t *ni, int index,
-			lnet_process_id_t *id, __u32 *myip, __u32 *peer_ip,
-			int *port, int *conn_count, int *share_count)
+ksocknal_get_peer_info(lnet_ni_t *ni, int index,
+		       lnet_process_id_t *id, __u32 *myip, __u32 *peer_ip,
+		       int *port, int *conn_count, int *share_count)
 {
 	ksock_peer_t      *peer;
 	struct list_head	*ptmp;
@@ -263,8 +263,8 @@ ksocknal_get_peer_info (lnet_ni_t *ni, int index,
 
 	for (i = 0; i < ksocknal_data.ksnd_peer_hash_size; i++) {
 
-		list_for_each (ptmp, &ksocknal_data.ksnd_peers[i]) {
-			peer = list_entry (ptmp, ksock_peer_t, ksnp_list);
+		list_for_each(ptmp, &ksocknal_data.ksnd_peers[i]) {
+			peer = list_entry(ptmp, ksock_peer_t, ksnp_list);
 
 			if (peer->ksnp_ni != ni)
 				continue;
@@ -298,7 +298,7 @@ ksocknal_get_peer_info (lnet_ni_t *ni, int index,
 				goto out;
 			}
 
-			list_for_each (rtmp, &peer->ksnp_routes) {
+			list_for_each(rtmp, &peer->ksnp_routes) {
 				if (index-- > 0)
 					continue;
 
@@ -367,17 +367,17 @@ ksocknal_associate_route_conn_locked(ksock_route_t *route, ksock_conn_t *conn)
 }
 
 void
-ksocknal_add_route_locked (ksock_peer_t *peer, ksock_route_t *route)
+ksocknal_add_route_locked(ksock_peer_t *peer, ksock_route_t *route)
 {
 	struct list_head	*tmp;
 	ksock_conn_t      *conn;
 	ksock_route_t     *route2;
 
-	LASSERT (!peer->ksnp_closing);
-	LASSERT (route->ksnr_peer == NULL);
-	LASSERT (!route->ksnr_scheduled);
-	LASSERT (!route->ksnr_connecting);
-	LASSERT (route->ksnr_connected == 0);
+	LASSERT(!peer->ksnp_closing);
+	LASSERT(route->ksnr_peer == NULL);
+	LASSERT(!route->ksnr_scheduled);
+	LASSERT(!route->ksnr_connecting);
+	LASSERT(route->ksnr_connected == 0);
 
 	/* LASSERT(unique) */
 	list_for_each(tmp, &peer->ksnp_routes) {
@@ -408,7 +408,7 @@ ksocknal_add_route_locked (ksock_peer_t *peer, ksock_route_t *route)
 }
 
 void
-ksocknal_del_route_locked (ksock_route_t *route)
+ksocknal_del_route_locked(ksock_route_t *route)
 {
 	ksock_peer_t      *peer = route->ksnr_peer;
 	ksock_interface_t *iface;
@@ -416,16 +416,16 @@ ksocknal_del_route_locked (ksock_route_t *route)
 	struct list_head	*ctmp;
 	struct list_head	*cnxt;
 
-	LASSERT (!route->ksnr_deleted);
+	LASSERT(!route->ksnr_deleted);
 
 	/* Close associated conns */
-	list_for_each_safe (ctmp, cnxt, &peer->ksnp_conns) {
+	list_for_each_safe(ctmp, cnxt, &peer->ksnp_conns) {
 		conn = list_entry(ctmp, ksock_conn_t, ksnc_list);
 
 		if (conn->ksnc_route != route)
 			continue;
 
-		ksocknal_close_conn_locked (conn, 0);
+		ksocknal_close_conn_locked(conn, 0);
 	}
 
 	if (route->ksnr_myipaddr != 0) {
@@ -436,19 +436,19 @@ ksocknal_del_route_locked (ksock_route_t *route)
 	}
 
 	route->ksnr_deleted = 1;
-	list_del (&route->ksnr_list);
+	list_del(&route->ksnr_list);
 	ksocknal_route_decref(route);	     /* drop peer's ref */
 
-	if (list_empty (&peer->ksnp_routes) &&
-	    list_empty (&peer->ksnp_conns)) {
+	if (list_empty(&peer->ksnp_routes) &&
+	    list_empty(&peer->ksnp_conns)) {
 		/* I've just removed the last route to a peer with no active
 		 * connections */
-		ksocknal_unlink_peer_locked (peer);
+		ksocknal_unlink_peer_locked(peer);
 	}
 }
 
 int
-ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
+ksocknal_add_peer(lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 {
 	struct list_head	*tmp;
 	ksock_peer_t      *peer;
@@ -466,7 +466,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 	if (rc != 0)
 		return rc;
 
-	route = ksocknal_create_route (ipaddr, port);
+	route = ksocknal_create_route(ipaddr, port);
 	if (route == NULL) {
 		ksocknal_peer_decref(peer);
 		return (-ENOMEM);
@@ -475,20 +475,19 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 	write_lock_bh(&ksocknal_data.ksnd_global_lock);
 
 	/* always called with a ref on ni, so shutdown can't have started */
-	LASSERT (((ksock_net_t *) ni->ni_data)->ksnn_shutdown == 0);
+	LASSERT(((ksock_net_t *) ni->ni_data)->ksnn_shutdown == 0);
 
-	peer2 = ksocknal_find_peer_locked (ni, id);
+	peer2 = ksocknal_find_peer_locked(ni, id);
 	if (peer2 != NULL) {
 		ksocknal_peer_decref(peer);
 		peer = peer2;
 	} else {
 		/* peer table takes my ref on peer */
-		list_add_tail (&peer->ksnp_list,
-				   ksocknal_nid2peerlist (id.nid));
+		list_add_tail(&peer->ksnp_list, ksocknal_nid2peerlist(id.nid));
 	}
 
 	route2 = NULL;
-	list_for_each (tmp, &peer->ksnp_routes) {
+	list_for_each(tmp, &peer->ksnp_routes) {
 		route2 = list_entry(tmp, ksock_route_t, ksnr_list);
 
 		if (route2->ksnr_ipaddr == ipaddr)
@@ -510,7 +509,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 }
 
 void
-ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
+ksocknal_del_peer_locked(ksock_peer_t *peer, __u32 ip)
 {
 	ksock_conn_t     *conn;
 	ksock_route_t    *route;
@@ -518,12 +517,12 @@ ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 	struct list_head       *nxt;
 	int	       nshared;
 
-	LASSERT (!peer->ksnp_closing);
+	LASSERT(!peer->ksnp_closing);
 
 	/* Extra ref prevents peer disappearing until I'm done with it */
 	ksocknal_peer_addref(peer);
 
-	list_for_each_safe (tmp, nxt, &peer->ksnp_routes) {
+	list_for_each_safe(tmp, nxt, &peer->ksnp_routes) {
 		route = list_entry(tmp, ksock_route_t, ksnr_list);
 
 		/* no match */
@@ -532,11 +531,11 @@ ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 
 		route->ksnr_share_count = 0;
 		/* This deletes associated conns too */
-		ksocknal_del_route_locked (route);
+		ksocknal_del_route_locked(route);
 	}
 
 	nshared = 0;
-	list_for_each_safe (tmp, nxt, &peer->ksnp_routes) {
+	list_for_each_safe(tmp, nxt, &peer->ksnp_routes) {
 		route = list_entry(tmp, ksock_route_t, ksnr_list);
 		nshared += route->ksnr_share_count;
 	}
@@ -545,15 +544,15 @@ ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 		/* remove everything else if there are no explicit entries
 		 * left */
 
-		list_for_each_safe (tmp, nxt, &peer->ksnp_routes) {
+		list_for_each_safe(tmp, nxt, &peer->ksnp_routes) {
 			route = list_entry(tmp, ksock_route_t, ksnr_list);
 
 			/* we should only be removing auto-entries */
 			LASSERT(route->ksnr_share_count == 0);
-			ksocknal_del_route_locked (route);
+			ksocknal_del_route_locked(route);
 		}
 
-		list_for_each_safe (tmp, nxt, &peer->ksnp_conns) {
+		list_for_each_safe(tmp, nxt, &peer->ksnp_conns) {
 			conn = list_entry(tmp, ksock_conn_t, ksnc_list);
 
 			ksocknal_close_conn_locked(conn, 0);
@@ -565,7 +564,7 @@ ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 }
 
 int
-ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
+ksocknal_del_peer(lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 {
 	LIST_HEAD     (zombies);
 	struct list_head	*ptmp;
@@ -586,9 +585,8 @@ ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 	}
 
 	for (i = lo; i <= hi; i++) {
-		list_for_each_safe (ptmp, pnxt,
-					&ksocknal_data.ksnd_peers[i]) {
-			peer = list_entry (ptmp, ksock_peer_t, ksnp_list);
+		list_for_each_safe(ptmp, pnxt, &ksocknal_data.ksnd_peers[i]) {
+			peer = list_entry(ptmp, ksock_peer_t, ksnp_list);
 
 			if (peer->ksnp_ni != ni)
 				continue;
@@ -599,12 +597,12 @@ ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 
 			ksocknal_peer_addref(peer);     /* a ref for me... */
 
-			ksocknal_del_peer_locked (peer, ip);
+			ksocknal_del_peer_locked(peer, ip);
 
 			if (peer->ksnp_closing &&
 			    !list_empty(&peer->ksnp_tx_queue)) {
-				LASSERT (list_empty(&peer->ksnp_conns));
-				LASSERT (list_empty(&peer->ksnp_routes));
+				LASSERT(list_empty(&peer->ksnp_conns));
+				LASSERT(list_empty(&peer->ksnp_routes));
 
 				list_splice_init(&peer->ksnp_tx_queue,
 						     &zombies);
@@ -624,7 +622,7 @@ ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 }
 
 ksock_conn_t *
-ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
+ksocknal_get_conn_by_idx(lnet_ni_t *ni, int index)
 {
 	ksock_peer_t      *peer;
 	struct list_head	*ptmp;
@@ -635,20 +633,20 @@ ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
 	read_lock(&ksocknal_data.ksnd_global_lock);
 
 	for (i = 0; i < ksocknal_data.ksnd_peer_hash_size; i++) {
-		list_for_each (ptmp, &ksocknal_data.ksnd_peers[i]) {
-			peer = list_entry (ptmp, ksock_peer_t, ksnp_list);
+		list_for_each(ptmp, &ksocknal_data.ksnd_peers[i]) {
+			peer = list_entry(ptmp, ksock_peer_t, ksnp_list);
 
-			LASSERT (!peer->ksnp_closing);
+			LASSERT(!peer->ksnp_closing);
 
 			if (peer->ksnp_ni != ni)
 				continue;
 
-			list_for_each (ctmp, &peer->ksnp_conns) {
+			list_for_each(ctmp, &peer->ksnp_conns) {
 				if (index-- > 0)
 					continue;
 
-				conn = list_entry (ctmp, ksock_conn_t,
-						       ksnc_list);
+				conn = list_entry(ctmp, ksock_conn_t,
+							   ksnc_list);
 				ksocknal_conn_addref(conn);
 				read_unlock(&ksocknal_data. \
 						 ksnd_global_lock);
@@ -685,7 +683,7 @@ ksocknal_choose_scheduler_locked(unsigned int cpt)
 }
 
 int
-ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
+ksocknal_local_ipvec(lnet_ni_t *ni, __u32 *ipaddrs)
 {
 	ksock_net_t       *net = ni->ni_data;
 	int		i;
@@ -694,7 +692,7 @@ ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 	read_lock(&ksocknal_data.ksnd_global_lock);
 
 	nip = net->ksnn_ninterfaces;
-	LASSERT (nip <= LNET_MAX_INTERFACES);
+	LASSERT(nip <= LNET_MAX_INTERFACES);
 
 	/* Only offer interfaces for additional connections if I have
 	 * more than one. */
@@ -705,7 +703,7 @@ ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 
 	for (i = 0; i < nip; i++) {
 		ipaddrs[i] = net->ksnn_interfaces[i].ksni_ipaddr;
-		LASSERT (ipaddrs[i] != 0);
+		LASSERT(ipaddrs[i] != 0);
 	}
 
 	read_unlock(&ksocknal_data.ksnd_global_lock);
@@ -713,7 +711,7 @@ ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 }
 
 int
-ksocknal_match_peerip (ksock_interface_t *iface, __u32 *ips, int nips)
+ksocknal_match_peerip(ksock_interface_t *iface, __u32 *ips, int nips)
 {
 	int   best_netmatch = 0;
 	int   best_xor      = 0;
@@ -740,7 +738,7 @@ ksocknal_match_peerip (ksock_interface_t *iface, __u32 *ips, int nips)
 		best_xor = this_xor;
 	}
 
-	LASSERT (best >= 0);
+	LASSERT(best >= 0);
 	return (best);
 }
 
@@ -771,8 +769,8 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 
 	write_lock_bh(global_lock);
 
-	LASSERT (n_peerips <= LNET_MAX_INTERFACES);
-	LASSERT (net->ksnn_ninterfaces <= LNET_MAX_INTERFACES);
+	LASSERT(n_peerips <= LNET_MAX_INTERFACES);
+	LASSERT(net->ksnn_ninterfaces <= LNET_MAX_INTERFACES);
 
 	/* Only match interfaces for additional connections
 	 * if I have > 1 interface */
@@ -797,7 +795,7 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 			LASSERT(best_iface != NULL);
 		} else {
 			/* choose a new interface */
-			LASSERT (i == peer->ksnp_n_passive_ips);
+			LASSERT(i == peer->ksnp_n_passive_ips);
 
 			best_iface = NULL;
 			best_netmatch = 0;
@@ -835,7 +833,7 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 			peer->ksnp_n_passive_ips = i+1;
 		}
 
-		LASSERT (best_iface != NULL);
+		LASSERT(best_iface != NULL);
 
 		/* mark the best matching peer IP used */
 		j = ksocknal_match_peerip(best_iface, peerips, n_peerips);
@@ -882,7 +880,7 @@ ksocknal_create_routes(ksock_peer_t *peer, int port,
 		return;
 	}
 
-	LASSERT (npeer_ipaddrs <= LNET_MAX_INTERFACES);
+	LASSERT(npeer_ipaddrs <= LNET_MAX_INTERFACES);
 
 	for (i = 0; i < npeer_ipaddrs; i++) {
 		if (newroute != NULL) {
@@ -919,7 +917,7 @@ ksocknal_create_routes(ksock_peer_t *peer, int port,
 		best_nroutes = 0;
 		best_netmatch = 0;
 
-		LASSERT (net->ksnn_ninterfaces <= LNET_MAX_INTERFACES);
+		LASSERT(net->ksnn_ninterfaces <= LNET_MAX_INTERFACES);
 
 		/* Select interface to connect from */
 		for (j = 0; j < net->ksnn_ninterfaces; j++) {
@@ -969,7 +967,7 @@ ksocknal_create_routes(ksock_peer_t *peer, int port,
 }
 
 int
-ksocknal_accept (lnet_ni_t *ni, socket_t *sock)
+ksocknal_accept(lnet_ni_t *ni, socket_t *sock)
 {
 	ksock_connreq_t    *cr;
 	int		 rc;
@@ -977,7 +975,7 @@ ksocknal_accept (lnet_ni_t *ni, socket_t *sock)
 	int		 peer_port;
 
 	rc = libcfs_sock_getaddr(sock, 1, &peer_ip, &peer_port);
-	LASSERT (rc == 0);		      /* we succeeded before */
+	LASSERT(rc == 0);		      /* we succeeded before */
 
 	LIBCFS_ALLOC(cr, sizeof(*cr));
 	if (cr == NULL) {
@@ -1001,11 +999,11 @@ ksocknal_accept (lnet_ni_t *ni, socket_t *sock)
 }
 
 int
-ksocknal_connecting (ksock_peer_t *peer, __u32 ipaddr)
+ksocknal_connecting(ksock_peer_t *peer, __u32 ipaddr)
 {
 	ksock_route_t   *route;
 
-	list_for_each_entry (route, &peer->ksnp_routes, ksnr_list) {
+	list_for_each_entry(route, &peer->ksnp_routes, ksnr_list) {
 
 		if (route->ksnr_ipaddr == ipaddr)
 			return route->ksnr_connecting;
@@ -1014,8 +1012,8 @@ ksocknal_connecting (ksock_peer_t *peer, __u32 ipaddr)
 }
 
 int
-ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
-		      socket_t *sock, int type)
+ksocknal_create_conn(lnet_ni_t *ni, ksock_route_t *route,
+		     socket_t *sock, int type)
 {
 	rwlock_t		*global_lock = &ksocknal_data.ksnd_global_lock;
 	LIST_HEAD     (zombies);
@@ -1037,7 +1035,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 
 	active = (route != NULL);
 
-	LASSERT (active == (type != SOCKLND_CONN_NONE));
+	LASSERT(active == (type != SOCKLND_CONN_NONE));
 
 	LIBCFS_ALLOC(conn, sizeof(*conn));
 	if (conn == NULL) {
@@ -1052,19 +1050,19 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	conn->ksnc_sock = sock;
 	/* 2 ref, 1 for conn, another extra ref prevents socket
 	 * being closed before establishment of connection */
-	atomic_set (&conn->ksnc_sock_refcount, 2);
+	atomic_set(&conn->ksnc_sock_refcount, 2);
 	conn->ksnc_type = type;
 	ksocknal_lib_save_callback(sock, conn);
-	atomic_set (&conn->ksnc_conn_refcount, 1); /* 1 ref for me */
+	atomic_set(&conn->ksnc_conn_refcount, 1); /* 1 ref for me */
 
 	conn->ksnc_rx_ready = 0;
 	conn->ksnc_rx_scheduled = 0;
 
-	INIT_LIST_HEAD (&conn->ksnc_tx_queue);
+	INIT_LIST_HEAD(&conn->ksnc_tx_queue);
 	conn->ksnc_tx_ready = 0;
 	conn->ksnc_tx_scheduled = 0;
 	conn->ksnc_tx_carrier = NULL;
-	atomic_set (&conn->ksnc_tx_nob, 0);
+	atomic_set(&conn->ksnc_tx_nob, 0);
 
 	LIBCFS_ALLOC(hello, offsetof(ksock_hello_msg_t,
 				     kshm_ips[LNET_MAX_INTERFACES]));
@@ -1074,7 +1072,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	}
 
 	/* stash conn's local and remote addrs */
-	rc = ksocknal_lib_get_conn_addrs (conn);
+	rc = ksocknal_lib_get_conn_addrs(conn);
 	if (rc != 0)
 		goto failed_1;
 
@@ -1105,7 +1103,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 #endif
 		}
 
-		rc = ksocknal_send_hello (ni, conn, peerid.nid, hello);
+		rc = ksocknal_send_hello(ni, conn, peerid.nid, hello);
 		if (rc != 0)
 			goto failed_1;
 	} else {
@@ -1116,13 +1114,13 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		conn->ksnc_proto = NULL;
 	}
 
-	rc = ksocknal_recv_hello (ni, conn, hello, &peerid, &incarnation);
+	rc = ksocknal_recv_hello(ni, conn, hello, &peerid, &incarnation);
 	if (rc < 0)
 		goto failed_1;
 
-	LASSERT (rc == 0 || active);
-	LASSERT (conn->ksnc_proto != NULL);
-	LASSERT (peerid.nid != LNET_NID_ANY);
+	LASSERT(rc == 0 || active);
+	LASSERT(conn->ksnc_proto != NULL);
+	LASSERT(peerid.nid != LNET_NID_ANY);
 
 	cpt = lnet_cpt_of_nid(peerid.nid);
 
@@ -1137,7 +1135,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		write_lock_bh(global_lock);
 
 		/* called with a ref on ni, so shutdown can't have started */
-		LASSERT (((ksock_net_t *) ni->ni_data)->ksnn_shutdown == 0);
+		LASSERT(((ksock_net_t *) ni->ni_data)->ksnn_shutdown == 0);
 
 		peer2 = ksocknal_find_peer_locked(ni, peerid);
 		if (peer2 == NULL) {
@@ -1177,7 +1175,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		 * NB recv_hello may have returned EPROTO to signal my peer
 		 * wants a different protocol than the one I asked for.
 		 */
-		LASSERT (list_empty(&peer->ksnp_conns));
+		LASSERT(list_empty(&peer->ksnp_conns));
 
 		peer->ksnp_proto = conn->ksnc_proto;
 		peer->ksnp_incarnation = incarnation;
@@ -1222,7 +1220,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 
 			/* Reply on a passive connection attempt so the peer
 			 * realises we're connected. */
-			LASSERT (rc == 0);
+			LASSERT(rc == 0);
 			if (!active)
 				rc = EALREADY;
 
@@ -1246,7 +1244,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	 * create an association.  This allows incoming connections created
 	 * by routes in my peer to match my own route entries so I don't
 	 * continually create duplicate routes. */
-	list_for_each (tmp, &peer->ksnp_routes) {
+	list_for_each(tmp, &peer->ksnp_routes) {
 		route = list_entry(tmp, ksock_route_t, ksnr_list);
 
 		if (route->ksnr_ipaddr != conn->ksnc_ipaddr)
@@ -1271,7 +1269,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	conn->ksnc_tx_deadline = cfs_time_shift(*ksocknal_tunables.ksnd_timeout);
 	mb();   /* order with adding to peer's conn list */
 
-	list_add (&conn->ksnc_list, &peer->ksnp_conns);
+	list_add(&conn->ksnc_list, &peer->ksnp_conns);
 	ksocknal_conn_addref(conn);
 
 	ksocknal_new_packet(conn, 0);
@@ -1283,8 +1281,8 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		if (conn->ksnc_proto->pro_match_tx(conn, tx, tx->tx_nonblk) == SOCKNAL_MATCH_NO)
 				continue;
 
-		list_del (&tx->tx_list);
-		ksocknal_queue_tx_locked (tx, conn);
+		list_del(&tx->tx_list);
+		ksocknal_queue_tx_locked(tx, conn);
 	}
 
 	write_unlock_bh(global_lock);
-- 
1.7.9.5

