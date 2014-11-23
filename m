Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaKWT3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:29:12 -0500
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:50405 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751956AbaKWT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:29:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:69:355:379:541:901:960:966:967:968:973:979:981:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2005:2194:2195:2196:2198:2199:2200:2201:2202:2393:2525:2538:2568:2627:2682:2685:2689:2690:2693:2828:2859:2892:2894:2895:2898:2899:2900:2901:2910:2913:2915:2922:2923:2924:2925:2926:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3165:3503:3504:3505:3608:3657:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4383:4384:4385:4395:4605:5007:6248:6261:7266:7619:7774:7862:7875:7903:7904:8603:8660:8828:8957:9010:9025:9121:9151:9163:9388:10004:10028:10049:10226:10848:11026:11232:11233:11657:11854:11876:11914:12043:12050:12294:12296:12438:12517:12519:12555:12660:12663:12698:12737:13019:13138:13141:13146:13148:13149:13230:13231:13869:13972:14394:21060:21080,0,RBL:none,CacheIP:none
X-HE-Tag: snake86_87f44482ae64d
X-Filterd-Recvd-Size: 216022
Message-ID: <1416770930.6651.52.camel@perches.com>
Subject: [PATCH V2] staging: lustre: Coalesce string fragments
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 23 Nov 2014 11:28:50 -0800
In-Reply-To: <20141122190306.GA663@kroah.com>
References: <1416527019.6651.25.camel@perches.com>
	 <20141122190306.GA663@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Join the string fragments to make it easier to grep.

Ignored all the 80+ column lines.
Added many missing spaces when coalescing formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
> Doesn't apply to my staging-testing branch anymore due to other changes
> that were sent in before yours :(

Fixup rejects
Couple more lines coalesced, spaces added/deleted.

 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  12 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  34 ++---
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |   3 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  49 +++---
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |  89 +++++------
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |  15 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |  82 +++++-----
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |   3 +-
 drivers/staging/lustre/lnet/lnet/router.c          |  34 ++---
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   9 +-
 drivers/staging/lustre/lnet/selftest/console.c     |   6 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |  25 ++-
 drivers/staging/lustre/lnet/selftest/module.c      |   4 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |  29 ++--
 drivers/staging/lustre/lustre/include/linux/obd.h  |   3 +-
 .../staging/lustre/lustre/include/lustre_disk.h    |   3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     | 168 +++++++++------------
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |  11 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |  37 ++---
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |  19 +--
 drivers/staging/lustre/lustre/libcfs/debug.c       |   8 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |   3 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |  32 ++--
 .../lustre/lustre/libcfs/linux/linux-debug.c       |   6 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |   3 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  38 +++--
 drivers/staging/lustre/lustre/llite/dcache.c       |   6 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  25 ++-
 drivers/staging/lustre/lustre/llite/file.c         |  16 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |   3 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |  16 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |  12 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  58 +++----
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   9 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |   7 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   4 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |  29 ++--
 drivers/staging/lustre/lustre/llite/namei.c        |  14 +-
 drivers/staging/lustre/lustre/llite/rw.c           |  20 +--
 drivers/staging/lustre/lustre/llite/statahead.c    |  11 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |   4 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   5 +-
 drivers/staging/lustre/lustre/llite/vvp_page.c     |   3 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   3 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |   3 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   8 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  36 ++---
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   5 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  32 ++--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   6 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |   8 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   3 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |   3 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   6 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |  18 +--
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   5 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |   4 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |  10 +-
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |   3 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  10 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   3 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   9 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |  38 ++---
 .../staging/lustre/lustre/obdecho/echo_client.c    |   3 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   4 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |   6 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |   3 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  11 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  47 +++---
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  44 +++---
 drivers/staging/lustre/lustre/ptlrpc/events.c      |   7 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 115 ++++++--------
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |  24 ++-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |   3 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |  13 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   7 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |  33 ++--
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |  33 ++--
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  18 +--
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   7 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   7 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |  22 ++-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   3 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |   4 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  90 +++++------
 88 files changed, 688 insertions(+), 1013 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index bc479a7..62b575d 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -930,8 +930,7 @@ kiblnd_close_peer_conns_locked (kib_peer_t *peer, int why)
 	list_for_each_safe (ctmp, cnxt, &peer->ibp_conns) {
 		conn = list_entry(ctmp, kib_conn_t, ibc_list);
 
-		CDEBUG(D_NET, "Closing conn -> %s, "
-			      "version: %x, reason: %d\n",
+		CDEBUG(D_NET, "Closing conn -> %s, version: %x, reason: %d\n",
 		       libcfs_nid2str(peer->ibp_nid),
 		       conn->ibc_version, why);
 
@@ -958,8 +957,7 @@ kiblnd_close_stale_conns_locked (kib_peer_t *peer,
 		    conn->ibc_incarnation == incarnation)
 			continue;
 
-		CDEBUG(D_NET, "Closing stale conn -> %s version: %x, "
-			      "incarnation:%#llx(%x, %#llx)\n",
+		CDEBUG(D_NET, "Closing stale conn -> %s version: %x, incarnation:%#llx(%x, %#llx)\n",
 		       libcfs_nid2str(peer->ibp_nid),
 		       conn->ibc_version, conn->ibc_incarnation,
 		       version, incarnation);
@@ -1599,8 +1597,7 @@ kiblnd_fmr_pool_map(kib_fmr_poolset_t *fps, __u64 *pages, int npages,
 
 	if (fps->fps_increasing) {
 		spin_unlock(&fps->fps_lock);
-		CDEBUG(D_NET, "Another thread is allocating new "
-		       "FMR pool, waiting for her to complete\n");
+		CDEBUG(D_NET, "Another thread is allocating new FMR pool, waiting for her to complete\n");
 		schedule();
 		goto again;
 
@@ -1801,8 +1798,7 @@ kiblnd_pool_alloc_node(kib_poolset_t *ps)
 	if (ps->ps_increasing) {
 		/* another thread is allocating a new pool */
 		spin_unlock(&ps->ps_lock);
-		CDEBUG(D_NET, "Another thread is allocating new "
-		       "%s pool, waiting for her to complete\n",
+		CDEBUG(D_NET, "Another thread is allocating new %s pool, waiting for her to complete\n",
 		       ps->ps_name);
 		schedule();
 		goto again;
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 14c9c8d..b48d7ed 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1116,8 +1116,7 @@ kiblnd_init_rdma (kib_conn_t *conn, kib_tx_t *tx, int type,
 		}
 
 		if (tx->tx_nwrq == IBLND_RDMA_FRAGS(conn->ibc_version)) {
-			CERROR("RDMA too fragmented for %s (%d): "
-			       "%d/%d src %d/%d dst frags\n",
+			CERROR("RDMA too fragmented for %s (%d): %d/%d src %d/%d dst frags\n",
 			       libcfs_nid2str(conn->ibc_peer->ibp_nid),
 			       IBLND_RDMA_FRAGS(conn->ibc_version),
 			       srcidx, srcrd->rd_nfrags,
@@ -2254,8 +2253,8 @@ kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 	if (ni == NULL ||			 /* no matching net */
 	    ni->ni_nid != reqmsg->ibm_dstnid ||   /* right NET, wrong NID! */
 	    net->ibn_dev != ibdev) {	      /* wrong device */
-		CERROR("Can't accept %s on %s (%s:%d:%pI4h): "
-		       "bad dst nid %s\n", libcfs_nid2str(nid),
+		CERROR("Can't accept %s on %s (%s:%d:%pI4h): bad dst nid %s\n",
+		       libcfs_nid2str(nid),
 		       ni == NULL ? "NA" : libcfs_nid2str(ni->ni_nid),
 		       ibdev->ibd_ifname, ibdev->ibd_nnets,
 		       &ibdev->ibd_ifip,
@@ -2295,8 +2294,7 @@ kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 
 	if (reqmsg->ibm_u.connparams.ibcp_max_frags !=
 	    IBLND_RDMA_FRAGS(version)) {
-		CERROR("Can't accept %s(version %x): "
-		       "incompatible max_frags %d (%d wanted)\n",
+		CERROR("Can't accept %s(version %x): incompatible max_frags %d (%d wanted)\n",
 		       libcfs_nid2str(nid), version,
 		       reqmsg->ibm_u.connparams.ibcp_max_frags,
 		       IBLND_RDMA_FRAGS(version));
@@ -2502,8 +2500,7 @@ kiblnd_reconnect (kib_conn_t *conn, int version,
 		break;
 	}
 
-	CNETERR("%s: retrying (%s), %x, %x, "
-		"queue_dep: %d, max_frag: %d, msg_size: %d\n",
+	CNETERR("%s: retrying (%s), %x, %x, queue_dep: %d, max_frag: %d, msg_size: %d\n",
 		libcfs_nid2str(peer->ibp_nid),
 		reason, IBLND_MSG_VERSION, version,
 		cp != NULL? cp->ibcp_queue_depth :IBLND_MSG_QUEUE_SIZE(version),
@@ -2679,8 +2676,7 @@ kiblnd_check_connreply (kib_conn_t *conn, void *priv, int priv_nob)
 	}
 
 	if (ver != msg->ibm_version) {
-		CERROR("%s replied version %x is different with "
-		       "requested version %x\n",
+		CERROR("%s replied version %x is different with requested version %x\n",
 		       libcfs_nid2str(peer->ibp_nid), msg->ibm_version, ver);
 		rc = -EPROTO;
 		goto failed;
@@ -2724,8 +2720,7 @@ kiblnd_check_connreply (kib_conn_t *conn, void *priv, int priv_nob)
 	read_unlock_irqrestore(&kiblnd_data.kib_global_lock, flags);
 
 	if (rc != 0) {
-		CERROR("Bad connection reply from %s, rc = %d, "
-		       "version: %x max_frags: %d\n",
+		CERROR("Bad connection reply from %s, rc = %d, version: %x max_frags: %d\n",
 		       libcfs_nid2str(peer->ibp_nid), rc,
 		       msg->ibm_version, msg->ibm_u.connparams.ibcp_max_frags);
 		goto failed;
@@ -3060,8 +3055,7 @@ kiblnd_check_conns (int idx)
 			}
 
 			if (timedout) {
-				CERROR("Timed out RDMA with %s (%lu): "
-				       "c: %u, oc: %u, rc: %u\n",
+				CERROR("Timed out RDMA with %s (%lu): c: %u, oc: %u, rc: %u\n",
 				       libcfs_nid2str(peer->ibp_nid),
 				       cfs_duration_sec(cfs_time_current() -
 							peer->ibp_last_alive),
@@ -3334,10 +3328,8 @@ kiblnd_scheduler(void *arg)
 
 	rc = cfs_cpt_bind(lnet_cpt_table(), sched->ibs_cpt);
 	if (rc != 0) {
-		CWARN("Failed to bind on CPT %d, please verify whether "
-		      "all CPUs are healthy and reload modules if necessary, "
-		      "otherwise your system might under risk of low "
-		      "performance\n", sched->ibs_cpt);
+		CWARN("Failed to bind on CPT %d, please verify whether all CPUs are healthy and reload modules if necessary, otherwise your system might under risk of low performance\n",
+		      sched->ibs_cpt);
 	}
 
 	spin_lock_irqsave(&sched->ibs_lock, flags);
@@ -3369,8 +3361,7 @@ kiblnd_scheduler(void *arg)
 				rc = ib_req_notify_cq(conn->ibc_cq,
 						      IB_CQ_NEXT_COMP);
 				if (rc < 0) {
-					CWARN("%s: ib_req_notify_cq failed: %d, "
-					      "closing connection\n",
+					CWARN("%s: ib_req_notify_cq failed: %d, closing connection\n",
 					      libcfs_nid2str(conn->ibc_peer->ibp_nid), rc);
 					kiblnd_close_conn(conn, -EIO);
 					kiblnd_conn_decref(conn);
@@ -3383,8 +3374,7 @@ kiblnd_scheduler(void *arg)
 			}
 
 			if (rc < 0) {
-				CWARN("%s: ib_poll_cq failed: %d, "
-				      "closing connection\n",
+				CWARN("%s: ib_poll_cq failed: %d, closing connection\n",
 				      libcfs_nid2str(conn->ibc_peer->ibp_nid),
 				      rc);
 				kiblnd_close_conn(conn, -EIO);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
index cefdfb6..8b4a8e9 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
@@ -222,8 +222,7 @@ kiblnd_tunables_init (void)
 		*kiblnd_tunables.kib_concurrent_sends = *kiblnd_tunables.kib_peertxcredits / 2;
 
 	if (*kiblnd_tunables.kib_concurrent_sends < *kiblnd_tunables.kib_peertxcredits) {
-		CWARN("Concurrent sends %d is lower than message queue size: %d, "
-		      "performance may drop slightly.\n",
+		CWARN("Concurrent sends %d is lower than message queue size: %d, performance may drop slightly.\n",
 		      *kiblnd_tunables.kib_concurrent_sends, *kiblnd_tunables.kib_peertxcredits);
 	}
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 8ac6410..9188b34 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -337,8 +337,7 @@ ksocknal_associate_route_conn_locked(ksock_route_t *route, ksock_conn_t *conn)
 			       &route->ksnr_ipaddr,
 			       &conn->ksnc_myipaddr);
 		} else {
-			CDEBUG(D_NET, "Rebinding %s %pI4h from "
-			       "%pI4h to %pI4h\n",
+			CDEBUG(D_NET, "Rebinding %s %pI4h from %pI4h to %pI4h\n",
 			       libcfs_id2str(peer->ksnp_id),
 			       &route->ksnr_ipaddr,
 			       &route->ksnr_myipaddr,
@@ -974,8 +973,7 @@ ksocknal_accept (lnet_ni_t *ni, struct socket *sock)
 
 	LIBCFS_ALLOC(cr, sizeof(*cr));
 	if (cr == NULL) {
-		LCONSOLE_ERROR_MSG(0x12f, "Dropping connection request from "
-				   "%pI4h: memory exhausted\n",
+		LCONSOLE_ERROR_MSG(0x12f, "Dropping connection request from %pI4h: memory exhausted\n",
 				   &peer_ip);
 		return -ENOMEM;
 	}
@@ -1288,8 +1286,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	 *	socket callbacks.
 	 */
 
-	CDEBUG(D_NET, "New conn %s p %d.x %pI4h -> %pI4h/%d"
-	       " incarnation:%lld sched[%d:%d]\n",
+	CDEBUG(D_NET, "New conn %s p %d.x %pI4h -> %pI4h/%d incarnation:%lld sched[%d:%d]\n",
 	       libcfs_id2str(peerid), conn->ksnc_proto->pro_version,
 	       &conn->ksnc_myipaddr, &conn->ksnc_ipaddr,
 	       conn->ksnc_port, incarnation, cpt,
@@ -1638,37 +1635,32 @@ ksocknal_destroy_conn (ksock_conn_t *conn)
 	case SOCKNAL_RX_LNET_PAYLOAD:
 		last_rcv = conn->ksnc_rx_deadline -
 			   cfs_time_seconds(*ksocknal_tunables.ksnd_timeout);
-		CERROR("Completing partial receive from %s[%d]"
-		       ", ip %pI4h:%d, with error, wanted: %d, left: %d, "
-		       "last alive is %ld secs ago\n",
+		CERROR("Completing partial receive from %s[%d], ip %pI4h:%d, with error, wanted: %d, left: %d, last alive is %ld secs ago\n",
 		       libcfs_id2str(conn->ksnc_peer->ksnp_id), conn->ksnc_type,
 		       &conn->ksnc_ipaddr, conn->ksnc_port,
 		       conn->ksnc_rx_nob_wanted, conn->ksnc_rx_nob_left,
 		       cfs_duration_sec(cfs_time_sub(cfs_time_current(),
-					last_rcv)));
+						     last_rcv)));
 		lnet_finalize (conn->ksnc_peer->ksnp_ni,
 			       conn->ksnc_cookie, -EIO);
 		break;
 	case SOCKNAL_RX_LNET_HEADER:
 		if (conn->ksnc_rx_started)
-			CERROR("Incomplete receive of lnet header from %s"
-			       ", ip %pI4h:%d, with error, protocol: %d.x.\n",
+			CERROR("Incomplete receive of lnet header from %s, ip %pI4h:%d, with error, protocol: %d.x.\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
 			       &conn->ksnc_ipaddr, conn->ksnc_port,
 			       conn->ksnc_proto->pro_version);
 		break;
 	case SOCKNAL_RX_KSM_HEADER:
 		if (conn->ksnc_rx_started)
-			CERROR("Incomplete receive of ksock message from %s"
-			       ", ip %pI4h:%d, with error, protocol: %d.x.\n",
+			CERROR("Incomplete receive of ksock message from %s, ip %pI4h:%d, with error, protocol: %d.x.\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
 			       &conn->ksnc_ipaddr, conn->ksnc_port,
 			       conn->ksnc_proto->pro_version);
 		break;
 	case SOCKNAL_RX_SLOP:
 		if (conn->ksnc_rx_started)
-			CERROR("Incomplete receive of slops from %s"
-			       ", ip %pI4h:%d, with error\n",
+			CERROR("Incomplete receive of slops from %s, ip %pI4h:%d, with error\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
 			       &conn->ksnc_ipaddr, conn->ksnc_port);
 	       break;
@@ -2511,22 +2503,21 @@ ksocknal_debug_peerhash (lnet_ni_t *ni)
 		ksock_route_t *route;
 		ksock_conn_t  *conn;
 
-		CWARN ("Active peer on shutdown: %s, ref %d, scnt %d, "
-		       "closing %d, accepting %d, err %d, zcookie %llu, "
-		       "txq %d, zc_req %d\n", libcfs_id2str(peer->ksnp_id),
-		       atomic_read(&peer->ksnp_refcount),
-		       peer->ksnp_sharecount, peer->ksnp_closing,
-		       peer->ksnp_accepting, peer->ksnp_error,
-		       peer->ksnp_zc_next_cookie,
-		       !list_empty(&peer->ksnp_tx_queue),
-		       !list_empty(&peer->ksnp_zc_req_list));
+		CWARN("Active peer on shutdown: %s, ref %d, scnt %d, closing %d, accepting %d, err %d, zcookie %llu, txq %d, zc_req %d\n",
+		      libcfs_id2str(peer->ksnp_id),
+		      atomic_read(&peer->ksnp_refcount),
+		      peer->ksnp_sharecount, peer->ksnp_closing,
+		      peer->ksnp_accepting, peer->ksnp_error,
+		      peer->ksnp_zc_next_cookie,
+		      !list_empty(&peer->ksnp_tx_queue),
+		      !list_empty(&peer->ksnp_zc_req_list));
 
 		list_for_each (tmp, &peer->ksnp_routes) {
 			route = list_entry(tmp, ksock_route_t, ksnr_list);
-			CWARN ("Route: ref %d, schd %d, conn %d, cnted %d, "
-			       "del %d\n", atomic_read(&route->ksnr_refcount),
-			       route->ksnr_scheduled, route->ksnr_connecting,
-			       route->ksnr_connected, route->ksnr_deleted);
+			CWARN("Route: ref %d, schd %d, conn %d, cnted %d, del %d\n",
+			      atomic_read(&route->ksnr_refcount),
+			      route->ksnr_scheduled, route->ksnr_connecting,
+			      route->ksnr_connected, route->ksnr_deleted);
 		}
 
 		list_for_each (tmp, &peer->ksnp_conns) {
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index d29f5f1..e6c1d36 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -551,19 +551,16 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	if (!conn->ksnc_closing) {
 		switch (rc) {
 		case -ECONNRESET:
-			LCONSOLE_WARN("Host %pI4h reset our connection "
-				      "while we were sending data; it may have "
-				      "rebooted.\n",
+			LCONSOLE_WARN("Host %pI4h reset our connection while we were sending data; it may have rebooted.\n",
 				      &conn->ksnc_ipaddr);
 			break;
 		default:
-			LCONSOLE_WARN("There was an unexpected network error "
-				      "while writing to %pI4h: %d.\n",
+			LCONSOLE_WARN("There was an unexpected network error while writing to %pI4h: %d.\n",
 				      &conn->ksnc_ipaddr, rc);
 			break;
 		}
-		CDEBUG(D_NET, "[%p] Error %d on write to %s"
-		       " ip %pI4h:%d\n", conn, rc,
+		CDEBUG(D_NET, "[%p] Error %d on write to %s ip %pI4h:%d\n",
+		       conn, rc,
 		       libcfs_id2str(conn->ksnc_peer->ksnp_id),
 		       &conn->ksnc_ipaddr,
 		       conn->ksnc_port);
@@ -799,8 +796,7 @@ ksocknal_find_connectable_route_locked (ksock_peer_t *peer)
 		if (!(route->ksnr_retry_interval == 0 || /* first attempt */
 		      cfs_time_aftereq(now, route->ksnr_timeout))) {
 			CDEBUG(D_NET,
-			       "Too soon to retry route %pI4h "
-			       "(cnted %d, interval %ld, %ld secs later)\n",
+			       "Too soon to retry route %pI4h (cnted %d, interval %ld, %ld secs later)\n",
 			       &route->ksnr_ipaddr,
 			       route->ksnr_connected,
 			       route->ksnr_retry_interval,
@@ -874,8 +870,8 @@ ksocknal_launch_packet (lnet_ni_t *ni, ksock_tx_t *tx, lnet_process_id_t id)
 		write_unlock_bh(g_lock);
 
 		if ((id.pid & LNET_PID_USERFLAG) != 0) {
-			CERROR("Refusing to create a connection to "
-			       "userspace process %s\n", libcfs_id2str(id));
+			CERROR("Refusing to create a connection to userspace process %s\n",
+			       libcfs_id2str(id));
 			return -EHOSTUNREACH;
 		}
 
@@ -1132,18 +1128,17 @@ ksocknal_process_receive (ksock_conn_t *conn)
 			LASSERT (rc != -EAGAIN);
 
 			if (rc == 0)
-				CDEBUG(D_NET, "[%p] EOF from %s"
-					" ip %pI4h:%d\n", conn,
-					libcfs_id2str(conn->ksnc_peer->ksnp_id),
-					&conn->ksnc_ipaddr,
-					conn->ksnc_port);
+				CDEBUG(D_NET, "[%p] EOF from %s ip %pI4h:%d\n",
+				       conn,
+				       libcfs_id2str(conn->ksnc_peer->ksnp_id),
+				       &conn->ksnc_ipaddr,
+				       conn->ksnc_port);
 			else if (!conn->ksnc_closing)
-				CERROR("[%p] Error %d on read from %s"
-					" ip %pI4h:%d\n",
-					conn, rc,
-					libcfs_id2str(conn->ksnc_peer->ksnp_id),
-					&conn->ksnc_ipaddr,
-					conn->ksnc_port);
+				CERROR("[%p] Error %d on read from %s ip %pI4h:%d\n",
+				       conn, rc,
+				       libcfs_id2str(conn->ksnc_peer->ksnp_id),
+				       &conn->ksnc_ipaddr,
+				       conn->ksnc_port);
 
 			/* it's not an error if conn is being closed */
 			ksocknal_close_conn_and_siblings (conn,
@@ -1724,10 +1719,10 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	    hello->kshm_magic != __swab32(LNET_PROTO_MAGIC) &&
 	    hello->kshm_magic != le32_to_cpu (LNET_PROTO_TCP_MAGIC)) {
 		/* Unexpected magic! */
-		CERROR("Bad magic(1) %#08x (%#08x expected) from "
-			"%pI4h\n", __cpu_to_le32 (hello->kshm_magic),
-			LNET_PROTO_TCP_MAGIC,
-			&conn->ksnc_ipaddr);
+		CERROR("Bad magic(1) %#08x (%#08x expected) from %pI4h\n",
+		       __cpu_to_le32 (hello->kshm_magic),
+		       LNET_PROTO_TCP_MAGIC,
+		       &conn->ksnc_ipaddr);
 		return -EPROTO;
 	}
 
@@ -1755,10 +1750,9 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 			ksocknal_send_hello(ni, conn, ni->ni_nid, hello);
 		}
 
-		CERROR("Unknown protocol version (%d.x expected)"
-			" from %pI4h\n",
-			conn->ksnc_proto->pro_version,
-			&conn->ksnc_ipaddr);
+		CERROR("Unknown protocol version (%d.x expected) from %pI4h\n",
+		       conn->ksnc_proto->pro_version,
+		       &conn->ksnc_ipaddr);
 
 		return -EPROTO;
 	}
@@ -1778,8 +1772,8 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	*incarnation = hello->kshm_src_incarnation;
 
 	if (hello->kshm_src_nid == LNET_NID_ANY) {
-		CERROR("Expecting a HELLO hdr with a NID, but got LNET_NID_ANY"
-		       "from %pI4h\n", &conn->ksnc_ipaddr);
+		CERROR("Expecting a HELLO hdr with a NID, but got LNET_NID_ANY from %pI4h\n",
+		       &conn->ksnc_ipaddr);
 		return -EPROTO;
 	}
 
@@ -1810,10 +1804,7 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 
 	if (peerid->pid != recv_id.pid ||
 	    peerid->nid != recv_id.nid) {
-		LCONSOLE_ERROR_MSG(0x130, "Connected successfully to %s on host"
-				   " %pI4h, but they claimed they were "
-				   "%s; please check your Lustre "
-				   "configuration.\n",
+		LCONSOLE_ERROR_MSG(0x130, "Connected successfully to %s on host %pI4h, but they claimed they were %s; please check your Lustre configuration.\n",
 				   libcfs_id2str(*peerid),
 				   &conn->ksnc_ipaddr,
 				   libcfs_id2str(recv_id));
@@ -2199,8 +2190,7 @@ ksocknal_connd (void *arg)
 			if (ksocknal_connect(route)) {
 				/* consecutive retry */
 				if (cons_retry++ > SOCKNAL_INSANITY_RECONN) {
-					CWARN("massive consecutive "
-					      "re-connecting to %pI4h\n",
+					CWARN("massive consecutive re-connecting to %pI4h\n",
 					      &route->ksnr_ipaddr);
 					cons_retry = 0;
 				}
@@ -2264,25 +2254,20 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 
 			switch (error) {
 			case ECONNRESET:
-				CNETERR("A connection with %s "
-					"(%pI4h:%d) was reset; "
-					"it may have rebooted.\n",
+				CNETERR("A connection with %s (%pI4h:%d) was reset; it may have rebooted.\n",
 					libcfs_id2str(peer->ksnp_id),
 					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 				break;
 			case ETIMEDOUT:
-				CNETERR("A connection with %s "
-					"(%pI4h:%d) timed out; the "
-					"network or node may be down.\n",
+				CNETERR("A connection with %s (%pI4h:%d) timed out; the network or node may be down.\n",
 					libcfs_id2str(peer->ksnp_id),
 					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 				break;
 			default:
-				CNETERR("An unexpected network error %d "
-					"occurred with %s "
-					"(%pI4h:%d\n", error,
+				CNETERR("An unexpected network error %d occurred with %s (%pI4h:%d\n",
+					error,
 					libcfs_id2str(peer->ksnp_id),
 					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
@@ -2297,8 +2282,7 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 				     conn->ksnc_rx_deadline)) {
 			/* Timed out incomplete incoming message */
 			ksocknal_conn_addref(conn);
-			CNETERR("Timeout receiving from %s (%pI4h:%d), "
-				"state %d wanted %d left %d\n",
+			CNETERR("Timeout receiving from %s (%pI4h:%d), state %d wanted %d left %d\n",
 				libcfs_id2str(peer->ksnp_id),
 				&conn->ksnc_ipaddr,
 				conn->ksnc_port,
@@ -2315,8 +2299,7 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 			/* Timed out messages queued for sending or
 			 * buffered in the socket's send buffer */
 			ksocknal_conn_addref(conn);
-			CNETERR("Timeout sending data to %s (%pI4h:%d) "
-				"the network or that node may be down.\n",
+			CNETERR("Timeout sending data to %s (%pI4h:%d) the network or that node may be down.\n",
 				libcfs_id2str(peer->ksnp_id),
 				&conn->ksnc_ipaddr,
 				conn->ksnc_port);
@@ -2500,9 +2483,7 @@ ksocknal_check_peer_timeouts (int idx)
 		spin_unlock(&peer->ksnp_lock);
 		read_unlock(&ksocknal_data.ksnd_global_lock);
 
-		CERROR("Total %d stale ZC_REQs for peer %s detected; the "
-		       "oldest(%p) timed out %ld secs ago, "
-		       "resid: %d, wmem: %d\n",
+		CERROR("Total %d stale ZC_REQs for peer %s detected; the oldest(%p) timed out %ld secs ago, resid: %d, wmem: %d\n",
 		       n, libcfs_nid2str(peer->ksnp_id.nid), tx,
 		       cfs_duration_sec(cfs_time_current() - deadline),
 		       resid, conn->ksnc_sock->sk->sk_wmem_queued);
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
index 9dde548..ea9d80f 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
@@ -515,8 +515,8 @@ ksocknal_send_hello_v1 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 			       hello->kshm_nips * sizeof(__u32),
 			       lnet_acceptor_timeout());
 	if (rc != 0) {
-		CNETERR("Error %d sending HELLO payload (%d)"
-			" to %pI4h/%d\n", rc, hello->kshm_nips,
+		CNETERR("Error %d sending HELLO payload (%d) to %pI4h/%d\n",
+			rc, hello->kshm_nips,
 			&conn->ksnc_ipaddr, conn->ksnc_port);
 	}
 out:
@@ -560,8 +560,8 @@ ksocknal_send_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 			       hello->kshm_nips * sizeof(__u32),
 			       lnet_acceptor_timeout());
 	if (rc != 0) {
-		CNETERR("Error %d sending HELLO payload (%d)"
-			" to %pI4h/%d\n", rc, hello->kshm_nips,
+		CNETERR("Error %d sending HELLO payload (%d) to %pI4h/%d\n",
+			rc, hello->kshm_nips,
 			&conn->ksnc_ipaddr, conn->ksnc_port);
 	}
 
@@ -595,10 +595,9 @@ ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,
 
 	/* ...and check we got what we expected */
 	if (hdr->type != cpu_to_le32 (LNET_MSG_HELLO)) {
-		CERROR("Expecting a HELLO hdr,"
-			" but got type %d from %pI4h\n",
-			le32_to_cpu (hdr->type),
-			&conn->ksnc_ipaddr);
+		CERROR("Expecting a HELLO hdr, but got type %d from %pI4h\n",
+		       le32_to_cpu(hdr->type),
+		       &conn->ksnc_ipaddr);
 		rc = -EPROTO;
 		goto out;
 	}
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 5754725..c8c1ed8 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -668,8 +668,7 @@ lnet_ni_eager_recv(lnet_ni_t *ni, lnet_msg_t *msg)
 	rc = (ni->ni_lnd->lnd_eager_recv)(ni, msg->msg_private, msg,
 					  &msg->msg_private);
 	if (rc != 0) {
-		CERROR("recv from %s / send to %s aborted: "
-		       "eager_recv failed %d\n",
+		CERROR("recv from %s / send to %s aborted: eager_recv failed %d\n",
 		       libcfs_nid2str(msg->msg_rxpeer->lp_nid),
 		       libcfs_id2str(msg->msg_target), rc);
 		LASSERT(rc < 0); /* required by my callers */
@@ -753,8 +752,7 @@ lnet_peer_alive_locked(lnet_peer_t *lp)
 
 		if (time_before(now, next_query)) {
 			if (lp->lp_alive)
-				CWARN("Unexpected aliveness of peer %s: "
-				      "%d < %d (%d/%d)\n",
+				CWARN("Unexpected aliveness of peer %s: %d < %d (%d/%d)\n",
 				      libcfs_nid2str(lp->lp_nid),
 				      (int)now, (int)next_query,
 				      lnet_queryinterval,
@@ -817,8 +815,7 @@ lnet_post_send_locked(lnet_msg_t *msg, int do_send)
 	    (msg->msg_md->md_flags & LNET_MD_FLAG_ABORTED) != 0) {
 		lnet_net_unlock(cpt);
 
-		CNETERR("Aborting message for %s: LNetM[DE]Unlink() already "
-			"called on the MD/ME.\n",
+		CNETERR("Aborting message for %s: LNetM[DE]Unlink() already called on the MD/ME.\n",
 			libcfs_id2str(msg->msg_target));
 		if (do_send)
 			lnet_finalize(ni, msg, -ECANCELED);
@@ -1220,8 +1217,8 @@ lnet_send(lnet_nid_t src_nid, lnet_msg_t *msg, lnet_nid_t rtr_nid)
 		src_ni = lnet_nid2ni_locked(src_nid, cpt);
 		if (src_ni == NULL) {
 			lnet_net_unlock(cpt);
-			LCONSOLE_WARN("Can't send to %s: src %s is not a "
-				      "local nid\n", libcfs_nid2str(dst_nid),
+			LCONSOLE_WARN("Can't send to %s: src %s is not a local nid\n",
+				      libcfs_nid2str(dst_nid),
 				      libcfs_nid2str(src_nid));
 			return -EINVAL;
 		}
@@ -1283,8 +1280,7 @@ lnet_send(lnet_nid_t src_nid, lnet_msg_t *msg, lnet_nid_t rtr_nid)
 				lnet_ni_decref_locked(src_ni, cpt);
 			lnet_net_unlock(cpt);
 
-			LCONSOLE_WARN("No route to %s via %s "
-				      "(all routers down)\n",
+			LCONSOLE_WARN("No route to %s via %s (all routers down)\n",
 				      libcfs_id2str(msg->msg_target),
 				      libcfs_nid2str(src_nid));
 			return -EHOSTUNREACH;
@@ -1676,8 +1672,7 @@ lnet_print_hdr(lnet_hdr_t *hdr)
 		break;
 
 	case LNET_MSG_PUT:
-		CWARN("    Ptl index %d, ack md %#llx.%#llx, "
-		      "match bits %llu\n",
+		CWARN("    Ptl index %d, ack md %#llx.%#llx, match bits %llu\n",
 		      hdr->msg.put.ptl_index,
 		      hdr->msg.put.ack_wmd.wh_interface_cookie,
 		      hdr->msg.put.ack_wmd.wh_object_cookie,
@@ -1688,8 +1683,8 @@ lnet_print_hdr(lnet_hdr_t *hdr)
 		break;
 
 	case LNET_MSG_GET:
-		CWARN("    Ptl index %d, return md %#llx.%#llx, "
-		      "match bits %llu\n", hdr->msg.get.ptl_index,
+		CWARN("    Ptl index %d, return md %#llx.%#llx, match bits %llu\n",
+		      hdr->msg.get.ptl_index,
 		      hdr->msg.get.return_wmd.wh_interface_cookie,
 		      hdr->msg.get.return_wmd.wh_object_cookie,
 		      hdr->msg.get.match_bits);
@@ -1699,16 +1694,14 @@ lnet_print_hdr(lnet_hdr_t *hdr)
 		break;
 
 	case LNET_MSG_ACK:
-		CWARN("    dst md %#llx.%#llx, "
-		      "manipulated length %d\n",
+		CWARN("    dst md %#llx.%#llx, manipulated length %d\n",
 		      hdr->msg.ack.dst_wmd.wh_interface_cookie,
 		      hdr->msg.ack.dst_wmd.wh_object_cookie,
 		      hdr->msg.ack.mlength);
 		break;
 
 	case LNET_MSG_REPLY:
-		CWARN("    dst md %#llx.%#llx, "
-		      "length %d\n",
+		CWARN("    dst md %#llx.%#llx, length %d\n",
 		      hdr->msg.reply.dst_wmd.wh_interface_cookie,
 		      hdr->msg.reply.dst_wmd.wh_object_cookie,
 		      hdr->payload_length);
@@ -1757,8 +1750,7 @@ lnet_parse(lnet_ni_t *ni, lnet_hdr_t *hdr, lnet_nid_t from_nid,
 	case LNET_MSG_REPLY:
 		if (payload_length >
 		   (__u32)(for_me ? LNET_MAX_PAYLOAD : LNET_MTU)) {
-			CERROR("%s, src %s: bad %s payload %d "
-			       "(%d max expected)\n",
+			CERROR("%s, src %s: bad %s payload %d (%d max expected)\n",
 			       libcfs_nid2str(from_nid),
 			       libcfs_nid2str(src_nid),
 			       lnet_msgtyp2str(type),
@@ -1794,40 +1786,36 @@ lnet_parse(lnet_ni_t *ni, lnet_hdr_t *hdr, lnet_nid_t from_nid,
 	if (!for_me) {
 		if (LNET_NIDNET(dest_nid) == LNET_NIDNET(ni->ni_nid)) {
 			/* should have gone direct */
-			CERROR("%s, src %s: Bad dest nid %s "
-				"(should have been sent direct)\n",
-				libcfs_nid2str(from_nid),
-				libcfs_nid2str(src_nid),
-				libcfs_nid2str(dest_nid));
+			CERROR("%s, src %s: Bad dest nid %s (should have been sent direct)\n",
+			       libcfs_nid2str(from_nid),
+			       libcfs_nid2str(src_nid),
+			       libcfs_nid2str(dest_nid));
 			return -EPROTO;
 		}
 
 		if (lnet_islocalnid(dest_nid)) {
 			/* dest is another local NI; sender should have used
 			 * this node's NID on its own network */
-			CERROR("%s, src %s: Bad dest nid %s "
-				"(it's my nid but on a different network)\n",
-				libcfs_nid2str(from_nid),
-				libcfs_nid2str(src_nid),
-				libcfs_nid2str(dest_nid));
+			CERROR("%s, src %s: Bad dest nid %s (it's my nid but on a different network)\n",
+			       libcfs_nid2str(from_nid),
+			       libcfs_nid2str(src_nid),
+			       libcfs_nid2str(dest_nid));
 			return -EPROTO;
 		}
 
 		if (rdma_req && type == LNET_MSG_GET) {
-			CERROR("%s, src %s: Bad optimized GET for %s "
-				"(final destination must be me)\n",
-				libcfs_nid2str(from_nid),
-				libcfs_nid2str(src_nid),
-				libcfs_nid2str(dest_nid));
+			CERROR("%s, src %s: Bad optimized GET for %s (final destination must be me)\n",
+			       libcfs_nid2str(from_nid),
+			       libcfs_nid2str(src_nid),
+			       libcfs_nid2str(dest_nid));
 			return -EPROTO;
 		}
 
 		if (!the_lnet.ln_routing) {
-			CERROR("%s, src %s: Dropping message for %s "
-				"(routing not enabled)\n",
-				libcfs_nid2str(from_nid),
-				libcfs_nid2str(src_nid),
-				libcfs_nid2str(dest_nid));
+			CERROR("%s, src %s: Dropping message for %s (routing not enabled)\n",
+			       libcfs_nid2str(from_nid),
+			       libcfs_nid2str(src_nid),
+			       libcfs_nid2str(dest_nid));
 			goto drop;
 		}
 	}
@@ -1882,8 +1870,7 @@ lnet_parse(lnet_ni_t *ni, lnet_hdr_t *hdr, lnet_nid_t from_nid,
 	rc = lnet_nid2peer_locked(&msg->msg_rxpeer, from_nid, cpt);
 	if (rc != 0) {
 		lnet_net_unlock(cpt);
-		CERROR("%s, src %s: Dropping %s "
-		       "(error %d looking up sender)\n",
+		CERROR("%s, src %s: Dropping %s (error %d looking up sender)\n",
 		       libcfs_nid2str(from_nid), libcfs_nid2str(src_nid),
 		       lnet_msgtyp2str(type), rc);
 		lnet_msg_free(msg);
@@ -2003,12 +1990,11 @@ lnet_recv_delayed_msg_list(struct list_head *head)
 		LASSERT(msg->msg_rxpeer != NULL);
 		LASSERT(msg->msg_hdr.type == LNET_MSG_PUT);
 
-		CDEBUG(D_NET, "Resuming delayed PUT from %s portal %d "
-		       "match %llu offset %d length %d.\n",
-			libcfs_id2str(id), msg->msg_hdr.msg.put.ptl_index,
-			msg->msg_hdr.msg.put.match_bits,
-			msg->msg_hdr.msg.put.offset,
-			msg->msg_hdr.payload_length);
+		CDEBUG(D_NET, "Resuming delayed PUT from %s portal %d match %llu offset %d length %d.\n",
+		       libcfs_id2str(id), msg->msg_hdr.msg.put.ptl_index,
+		       msg->msg_hdr.msg.put.match_bits,
+		       msg->msg_hdr.msg.put.offset,
+		       msg->msg_hdr.payload_length);
 
 		lnet_recv_put(msg->msg_rxpeer->lp_ni, msg);
 	}
diff --git a/drivers/staging/lustre/lnet/lnet/lib-ptl.c b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
index 720c73b..19ed696 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-ptl.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
@@ -192,8 +192,7 @@ lnet_try_match_md(lnet_libmd_t *md,
 	}
 
 	/* Commit to this ME/MD */
-	CDEBUG(D_NET, "Incoming %s index %x from %s of "
-	       "length %d/%d into md %#llx [%d] + %d\n",
+	CDEBUG(D_NET, "Incoming %s index %x from %s of length %d/%d into md %#llx [%d] + %d\n",
 	       (info->mi_opc == LNET_MD_OP_PUT) ? "put" : "get",
 	       info->mi_portal, libcfs_id2str(info->mi_id), mlength,
 	       info->mi_rlength, md->md_lh.lh_cookie, md->md_niov, offset);
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index b5b8fb5..59fb6bf 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -457,8 +457,7 @@ lnet_check_routes(void)
 
 				lnet_net_unlock(cpt);
 
-				CERROR("Routes to %s via %s and %s not "
-				       "supported\n",
+				CERROR("Routes to %s via %s and %s not supported\n",
 				       libcfs_net2str(net),
 				       libcfs_nid2str(nid1),
 				       libcfs_nid2str(nid2));
@@ -959,8 +958,7 @@ lnet_ping_router_locked (lnet_peer_t *rtr)
 	secs = lnet_router_check_interval(rtr);
 
 	CDEBUG(D_NET,
-	       "rtr %s %d: deadline %lu ping_notsent %d alive %d "
-	       "alive_count %d lp_ping_timestamp %lu\n",
+	       "rtr %s %d: deadline %lu ping_notsent %d alive %d alive_count %d lp_ping_timestamp %lu\n",
 	       libcfs_nid2str(rtr->lp_nid), secs,
 	       rtr->lp_ping_deadline, rtr->lp_ping_notsent,
 	       rtr->lp_alive, rtr->lp_alive_count, rtr->lp_ping_timestamp);
@@ -1010,9 +1008,7 @@ lnet_router_checker_start(void)
 
 	if (check_routers_before_use &&
 	    dead_router_check_interval <= 0) {
-		LCONSOLE_ERROR_MSG(0x10a, "'dead_router_check_interval' must be"
-				   " set if 'check_routers_before_use' is set"
-				   "\n");
+		LCONSOLE_ERROR_MSG(0x10a, "'dead_router_check_interval' must be set if 'check_routers_before_use' is set\n");
 		return -EINVAL;
 	}
 
@@ -1370,8 +1366,8 @@ lnet_nrb_tiny_calculate(int npages)
 
 	if (tiny_router_buffers < 0) {
 		LCONSOLE_ERROR_MSG(0x10c,
-				   "tiny_router_buffers=%d invalid when "
-				   "routing enabled\n", tiny_router_buffers);
+				   "tiny_router_buffers=%d invalid when routing enabled\n",
+				   tiny_router_buffers);
 		return -1;
 	}
 
@@ -1389,8 +1385,8 @@ lnet_nrb_small_calculate(int npages)
 
 	if (small_router_buffers < 0) {
 		LCONSOLE_ERROR_MSG(0x10c,
-				   "small_router_buffers=%d invalid when "
-				   "routing enabled\n", small_router_buffers);
+				   "small_router_buffers=%d invalid when routing enabled\n",
+				   small_router_buffers);
 		return -1;
 	}
 
@@ -1408,8 +1404,8 @@ lnet_nrb_large_calculate(int npages)
 
 	if (large_router_buffers < 0) {
 		LCONSOLE_ERROR_MSG(0x10c,
-				   "large_router_buffers=%d invalid when "
-				   "routing enabled\n", large_router_buffers);
+				   "large_router_buffers=%d invalid when routing enabled\n",
+				   large_router_buffers);
 		return -1;
 	}
 
@@ -1442,8 +1438,7 @@ lnet_rtrpools_alloc(int im_a_router)
 	} else if (!strcmp(forwarding, "enabled")) {
 		/* explicitly enabled */
 	} else {
-		LCONSOLE_ERROR_MSG(0x10b, "'forwarding' not set to either "
-				   "'enabled' or 'disabled'\n");
+		LCONSOLE_ERROR_MSG(0x10b, "'forwarding' not set to either 'enabled' or 'disabled'\n");
 		return -EINVAL;
 	}
 
@@ -1520,11 +1515,10 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, unsigned long when)
 
 	/* can't do predictions... */
 	if (cfs_time_after(when, now)) {
-		CWARN ("Ignoring prediction from %s of %s %s "
-		       "%ld seconds in the future\n",
-		       (ni == NULL) ? "userspace" : libcfs_nid2str(ni->ni_nid),
-		       libcfs_nid2str(nid), alive ? "up" : "down",
-		       cfs_duration_sec(cfs_time_sub(when, now)));
+		CWARN("Ignoring prediction from %s of %s %s %ld seconds in the future\n",
+		      (ni == NULL) ? "userspace" : libcfs_nid2str(ni->ni_nid),
+		      libcfs_nid2str(nid), alive ? "up" : "down",
+		      cfs_duration_sec(cfs_time_sub(when, now)));
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index d9645f6..46cde70 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -791,20 +791,17 @@ static struct lnet_portal_rotors	portal_rotors[] = {
 	{
 		.pr_value = LNET_PTL_ROTOR_ON,
 		.pr_name  = "ON",
-		.pr_desc  = "round-robin dispatch all PUT messages for "
-			    "wildcard portals"
+		.pr_desc  = "round-robin dispatch all PUT messages for wildcard portals"
 	},
 	{
 		.pr_value = LNET_PTL_ROTOR_RR_RT,
 		.pr_name  = "RR_RT",
-		.pr_desc  = "round-robin dispatch routed PUT message for "
-			    "wildcard portals"
+		.pr_desc  = "round-robin dispatch routed PUT message for wildcard portals"
 	},
 	{
 		.pr_value = LNET_PTL_ROTOR_HASH_RT,
 		.pr_name  = "HASH_RT",
-		.pr_desc  = "dispatch routed PUT message by hashing source "
-			    "NID for wildcard portals"
+		.pr_desc  = "dispatch routed PUT message by hashing source NID for wildcard portals"
 	},
 	{
 		.pr_value = -1,
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 5dad9f1..49cb654 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -1208,8 +1208,7 @@ again:
 
 		lstcon_rpc_trans_destroy(trans);
 		/* return if any error */
-		CDEBUG(D_NET, "Failed to add test %s, "
-			      "RPC error %d, framework error %d\n",
+		CDEBUG(D_NET, "Failed to add test %s, RPC error %d, framework error %d\n",
 		       transop == LST_TRANS_TSBCLIADD ? "client" : "server",
 		       lstcon_trans_stat()->trs_rpc_errno,
 		       lstcon_trans_stat()->trs_fwk_errno);
@@ -1885,8 +1884,7 @@ lstcon_session_feats_check(unsigned feats)
 	spin_unlock(&console_session.ses_rpc_lock);
 
 	if (rc != 0) {
-		CERROR("remote features %x do not match with "
-		       "session features %x of console\n",
+		CERROR("remote features %x do not match with session features %x of console\n",
 		       feats, console_session.ses_features);
 	}
 
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 82cc94b..cc9d182 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -291,8 +291,7 @@ sfw_server_rpc_done(struct srpc_server_rpc *rpc)
 	int			status	= rpc->srpc_status;
 
 	CDEBUG (D_NET,
-		"Incoming framework RPC done: "
-		"service %s, peer %s, status %s:%d\n",
+		"Incoming framework RPC done: service %s, peer %s, status %s:%d\n",
 		sv->sv_name, libcfs_id2str(rpc->srpc_peer),
 		swi_state2str(rpc->srpc_wi.swi_state),
 		status);
@@ -310,8 +309,7 @@ sfw_client_rpc_fini (srpc_client_rpc_t *rpc)
 	LASSERT (atomic_read(&rpc->crpc_refcount) == 0);
 
 	CDEBUG (D_NET,
-		"Outgoing framework RPC done: "
-		"service %d, peer %s, status %s:%d:%d\n",
+		"Outgoing framework RPC done: service %d, peer %s, status %s:%d:%d\n",
 		rpc->crpc_service, libcfs_id2str(rpc->crpc_dest),
 		swi_state2str(rpc->crpc_wi.swi_state),
 		rpc->crpc_aborted, rpc->crpc_status);
@@ -575,8 +573,8 @@ sfw_load_test(struct sfw_test_instance *tsi)
 
 	rc = srpc_service_add_buffers(svc, nbuf);
 	if (rc != 0) {
-		CWARN("Failed to reserve enough buffers: "
-		      "service %s, %d needed: %d\n", svc->sv_name, nbuf, rc);
+		CWARN("Failed to reserve enough buffers: service %s, %d needed: %d\n",
+		      svc->sv_name, nbuf, rc);
 		/* NB: this error handler is not strictly correct, because
 		 * it may release more buffers than already allocated,
 		 * but it doesn't matter because request portal should
@@ -1270,8 +1268,7 @@ sfw_handle_server_rpc(struct srpc_server_rpc *rpc)
 
 		if (sn != NULL &&
 		    sn->sn_features != request->msg_ses_feats) {
-			CNETERR("Features of framework RPC don't match "
-				"features of current session: %x/%x\n",
+			CNETERR("Features of framework RPC don't match features of current session: %x/%x\n",
 				request->msg_ses_feats, sn->sn_features);
 			reply->msg_body.reply.status = EPROTO;
 			reply->msg_body.reply.sid    = sn->sn_id;
@@ -1348,8 +1345,7 @@ sfw_bulk_ready(struct srpc_server_rpc *rpc, int status)
 	spin_lock(&sfw_data.fw_lock);
 
 	if (status != 0) {
-		CERROR("Bulk transfer failed for RPC: "
-		       "service %s, peer %s, status %d\n",
+		CERROR("Bulk transfer failed for RPC: service %s, peer %s, status %d\n",
 		       sv->sv_name, libcfs_id2str(rpc->srpc_peer), status);
 		spin_unlock(&sfw_data.fw_lock);
 		return -EIO;
@@ -1664,12 +1660,10 @@ sfw_startup (void)
 	}
 
 	if (session_timeout == 0)
-		CWARN ("Zero session_timeout specified "
-		       "- test sessions never expire.\n");
+		CWARN("Zero session_timeout specified - test sessions never expire.\n");
 
 	if (rpc_timeout == 0)
-		CWARN ("Zero rpc_timeout specified "
-		       "- test RPC never expire.\n");
+		CWARN("Zero rpc_timeout specified - test RPC never expire.\n");
 
 	memset(&sfw_data, 0, sizeof(struct smoketest_framework));
 
@@ -1727,8 +1721,7 @@ sfw_startup (void)
 
 		rc = srpc_service_add_buffers(sv, sv->sv_wi_total);
 		if (rc != 0) {
-			CWARN("Failed to reserve enough buffers: "
-			      "service %s, %d needed: %d\n",
+			CWARN("Failed to reserve enough buffers: service %s, %d needed: %d\n",
 			      sv->sv_name, sv->sv_wi_total, rc);
 			error = -ENOMEM;
 		}
diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
index 92520c2..c6ef5b0 100644
--- a/drivers/staging/lustre/lnet/selftest/module.c
+++ b/drivers/staging/lustre/lnet/selftest/module.c
@@ -119,8 +119,8 @@ lnet_selftest_init(void)
 		rc = cfs_wi_sched_create("lst_t", lnet_cpt_table(), i,
 					 nthrs, &lst_sched_test[i]);
 		if (rc != 0) {
-			CERROR("Failed to create CPT affinity WI scheduler "
-			       "%d for LST\n", i);
+			CERROR("Failed to create CPT affinity WI scheduler %d for LST\n",
+			       i);
 			goto error;
 		}
 	}
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index c9a1a45..f753add 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -678,9 +678,7 @@ srpc_finish_service(struct srpc_service *sv)
 
 		rpc = list_entry(scd->scd_rpc_active.next,
 				     struct srpc_server_rpc, srpc_list);
-		CNETERR("Active RPC %p on shutdown: sv %s, peer %s, "
-			"wi %s scheduled %d running %d, "
-			"ev fired %d type %d status %d lnet %d\n",
+		CNETERR("Active RPC %p on shutdown: sv %s, peer %s, wi %s scheduled %d running %d, ev fired %d type %d status %d lnet %d\n",
 			rpc, sv->sv_name, libcfs_id2str(rpc->srpc_peer),
 			swi_state2str(rpc->srpc_wi.swi_state),
 			rpc->srpc_wi.swi_workitem.wi_scheduled,
@@ -1236,20 +1234,18 @@ srpc_send_rpc (swi_workitem_t *wi)
 		if (reply->msg_type != type ||
 		    (reply->msg_magic != SRPC_MSG_MAGIC &&
 		     reply->msg_magic != __swab32(SRPC_MSG_MAGIC))) {
-			CWARN ("Bad message from %s: type %u (%d expected),"
-			       " magic %u (%d expected).\n",
-			       libcfs_id2str(rpc->crpc_dest),
-			       reply->msg_type, type,
-			       reply->msg_magic, SRPC_MSG_MAGIC);
+			CWARN("Bad message from %s: type %u (%d expected), magic %u (%d expected).\n",
+			      libcfs_id2str(rpc->crpc_dest),
+			      reply->msg_type, type,
+			      reply->msg_magic, SRPC_MSG_MAGIC);
 			rc = -EBADMSG;
 			break;
 		}
 
 		if (do_bulk && reply->msg_body.reply.status != 0) {
-			CWARN ("Remote error %d at %s, unlink bulk buffer in "
-			       "case peer didn't initiate bulk transfer\n",
-			       reply->msg_body.reply.status,
-			       libcfs_id2str(rpc->crpc_dest));
+			CWARN("Remote error %d at %s, unlink bulk buffer in case peer didn't initiate bulk transfer\n",
+			      reply->msg_body.reply.status,
+			      libcfs_id2str(rpc->crpc_dest));
 			LNetMDUnlink(rpc->crpc_bulk.bk_mdh);
 		}
 
@@ -1504,11 +1500,10 @@ srpc_lnet_ev_handler(lnet_event_t *ev)
 		     msg->msg_type != __swab32(type)) ||
 		    (msg->msg_magic != SRPC_MSG_MAGIC &&
 		     msg->msg_magic != __swab32(SRPC_MSG_MAGIC))) {
-			CERROR ("Dropping RPC (%s) from %s: "
-				"status %d mlength %d type %u magic %u.\n",
-				sv->sv_name, libcfs_id2str(ev->initiator),
-				ev->status, ev->mlength,
-				msg->msg_type, msg->msg_magic);
+			CERROR("Dropping RPC (%s) from %s: status %d mlength %d type %u magic %u.\n",
+			       sv->sv_name, libcfs_id2str(ev->initiator),
+			       ev->status, ev->mlength,
+			       msg->msg_type, msg->msg_magic);
 
 			/* NB can't call srpc_service_recycle_buffer here since
 			 * it may call LNetM[DE]Attach. The invalid magic tells
diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index 9d7e28a..9cd8683 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -87,8 +87,7 @@ static inline void __client_obd_list_lock(client_obd_lock_t *lock,
 			if (task == NULL)
 				continue;
 
-			LCONSOLE_WARN("%s:%d: lock %p was acquired"
-				      " by <%s:%d:%s:%d> for %lu seconds.\n",
+			LCONSOLE_WARN("%s:%d: lock %p was acquired by <%s:%d:%s:%d> for %lu seconds.\n",
 				      current->comm, current->pid,
 				      lock, task->comm, task->pid,
 				      lock->func, lock->line,
diff --git a/drivers/staging/lustre/lustre/include/lustre_disk.h b/drivers/staging/lustre/lustre/include/lustre_disk.h
index 515b835..9b28331 100644
--- a/drivers/staging/lustre/lustre/include/lustre_disk.h
+++ b/drivers/staging/lustre/lustre/include/lustre_disk.h
@@ -368,8 +368,7 @@ static inline void check_lcd(char *obd_name, int index,
 	if (strnlen((char*)lcd->lcd_uuid, length) == length) {
 		lcd->lcd_uuid[length - 1] = '\0';
 
-		LCONSOLE_ERROR("the client UUID (%s) on %s for exports"
-			       "stored in last_rcvd(index = %d) is bad!\n",
+		LCONSOLE_ERROR("the client UUID (%s) on %s for exports stored in last_rcvd(index = %d) is bad!\n",
 			       lcd->lcd_uuid, obd_name, index);
 	}
 }
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index b798daa..e00478b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -619,8 +619,7 @@ ldlm_flock_completion_ast(struct ldlm_lock *lock, __u64 flags, void *data)
 		return 0;
 	}
 
-	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, "
-		   "sleeping");
+	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, sleeping");
 	fwd.fwd_lock = lock;
 	obd = class_exp2obd(lock->l_conn_export);
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index c21e30a..249f311 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -858,8 +858,8 @@ void ldlm_dump_export_locks(struct obd_export *exp)
 	if (!list_empty(&exp->exp_locks_list)) {
 		struct ldlm_lock *lock;
 
-		CERROR("dumping locks for export %p,"
-		       "ignore if the unmount doesn't hang\n", exp);
+		CERROR("dumping locks for export %p,ignore if the unmount doesn't hang\n",
+		       exp);
 		list_for_each_entry(lock, &exp->exp_locks_list,
 					l_exp_refs_link)
 			LDLM_ERROR(lock, "lock:");
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 6140130..2c4af89 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -811,8 +811,7 @@ void ldlm_lock_decref_internal(struct ldlm_lock *lock, __u32 mode)
 		/* If we received a blocked AST and this was the last reference,
 		 * run the callback. */
 		if ((lock->l_flags & LDLM_FL_NS_SRV) && lock->l_export)
-			CERROR("FL_CBPENDING set on non-local lock--just a "
-			       "warning\n");
+			CERROR("FL_CBPENDING set on non-local lock--just a warning\n");
 
 		LDLM_DEBUG(lock, "final decref done on cbpending lock");
 
@@ -1641,8 +1640,7 @@ ldlm_error_t ldlm_lock_enqueue(struct ldlm_namespace *ns,
 			ldlm_grant_lock(lock, NULL);
 		goto out;
 	} else {
-		CERROR("This is client-side-only module, cannot handle "
-		       "LDLM_NAMESPACE_SERVER resource type lock.\n");
+		CERROR("This is client-side-only module, cannot handle LDLM_NAMESPACE_SERVER resource type lock.\n");
 		LBUG();
 	}
 
@@ -1904,8 +1902,7 @@ void ldlm_reprocess_all(struct ldlm_resource *res)
 	LIST_HEAD(rpc_list);
 
 	if (!ns_is_client(ldlm_res_to_ns(res))) {
-		CERROR("This is client-side-only module, cannot handle "
-		       "LDLM_NAMESPACE_SERVER resource type lock.\n");
+		CERROR("This is client-side-only module, cannot handle LDLM_NAMESPACE_SERVER resource type lock.\n");
 		LBUG();
 	}
 }
@@ -2038,8 +2035,7 @@ int ldlm_cancel_locks_for_export_cb(struct cfs_hash *hs, struct cfs_hash_bd *bd,
 	ecl->ecl_loop++;
 	if ((ecl->ecl_loop & -ecl->ecl_loop) == ecl->ecl_loop) {
 		CDEBUG(D_INFO,
-		       "Cancel lock %p for export %p (loop %d), still have "
-		       "%d locks left on hash table.\n",
+		       "Cancel lock %p for export %p (loop %d), still have %d locks left on hash table.\n",
 		       lock, exp, ecl->ecl_loop,
 		       atomic_read(&hs->hs_count));
 	}
@@ -2169,8 +2165,7 @@ struct ldlm_resource *ldlm_lock_convert(struct ldlm_lock *lock, int new_mode,
 				lock->l_completion_ast(lock, 0, NULL);
 		}
 	} else {
-		CERROR("This is client-side-only module, cannot handle "
-		       "LDLM_NAMESPACE_SERVER resource type lock.\n");
+		CERROR("This is client-side-only module, cannot handle LDLM_NAMESPACE_SERVER resource type lock.\n");
 		LBUG();
 	}
 	unlock_res_and_lock(lock);
@@ -2229,18 +2224,15 @@ void _ldlm_lock_debug(struct ldlm_lock *lock,
 
 	if (resource == NULL) {
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-		       " ns: \?\? lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s "
-		       "res: \?\? rrc=\?\? type: \?\?\? flags: %#llx nid: %s "
-		       "remote: %#llx expref: %d pid: %u timeout: %lu "
-		       "lvb_type: %d\n",
-		       lock,
-		       lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
-		       lock->l_readers, lock->l_writers,
-		       ldlm_lockname[lock->l_granted_mode],
-		       ldlm_lockname[lock->l_req_mode],
-		       lock->l_flags, nid, lock->l_remote_handle.cookie,
-		       exp ? atomic_read(&exp->exp_refcount) : -99,
-		       lock->l_pid, lock->l_callback_timeout, lock->l_lvb_type);
+				   " ns: \?\? lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s res: \?\? rrc=\?\? type: \?\?\? flags: %#llx nid: %s remote: %#llx expref: %d pid: %u timeout: %lu lvb_type: %d\n",
+				   lock,
+				   lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
+				   lock->l_readers, lock->l_writers,
+				   ldlm_lockname[lock->l_granted_mode],
+				   ldlm_lockname[lock->l_req_mode],
+				   lock->l_flags, nid, lock->l_remote_handle.cookie,
+				   exp ? atomic_read(&exp->exp_refcount) : -99,
+				   lock->l_pid, lock->l_callback_timeout, lock->l_lvb_type);
 		va_end(args);
 		return;
 	}
@@ -2248,90 +2240,78 @@ void _ldlm_lock_debug(struct ldlm_lock *lock,
 	switch (resource->lr_type) {
 	case LDLM_EXTENT:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-			" ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s "
-			"res: "DLDLMRES" rrc: %d type: %s [%llu->%llu] "
-			"(req %llu->%llu) flags: %#llx nid: %s remote: "
-			"%#llx expref: %d pid: %u timeout: %lu lvb_type: %d\n",
-			ldlm_lock_to_ns_name(lock), lock,
-			lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
-			lock->l_readers, lock->l_writers,
-			ldlm_lockname[lock->l_granted_mode],
-			ldlm_lockname[lock->l_req_mode],
-			PLDLMRES(resource),
-			atomic_read(&resource->lr_refcount),
-			ldlm_typename[resource->lr_type],
-			lock->l_policy_data.l_extent.start,
-			lock->l_policy_data.l_extent.end,
-			lock->l_req_extent.start, lock->l_req_extent.end,
-			lock->l_flags, nid, lock->l_remote_handle.cookie,
-			exp ? atomic_read(&exp->exp_refcount) : -99,
-			lock->l_pid, lock->l_callback_timeout,
-			lock->l_lvb_type);
+				   " ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s res: " DLDLMRES " rrc: %d type: %s [%llu->%llu] (req %llu->%llu) flags: %#llx nid: %s remote: %#llx expref: %d pid: %u timeout: %lu lvb_type: %d\n",
+				   ldlm_lock_to_ns_name(lock), lock,
+				   lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
+				   lock->l_readers, lock->l_writers,
+				   ldlm_lockname[lock->l_granted_mode],
+				   ldlm_lockname[lock->l_req_mode],
+				   PLDLMRES(resource),
+				   atomic_read(&resource->lr_refcount),
+				   ldlm_typename[resource->lr_type],
+				   lock->l_policy_data.l_extent.start,
+				   lock->l_policy_data.l_extent.end,
+				   lock->l_req_extent.start, lock->l_req_extent.end,
+				   lock->l_flags, nid, lock->l_remote_handle.cookie,
+				   exp ? atomic_read(&exp->exp_refcount) : -99,
+				   lock->l_pid, lock->l_callback_timeout,
+				   lock->l_lvb_type);
 		break;
 
 	case LDLM_FLOCK:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-			" ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s "
-			"res: "DLDLMRES" rrc: %d type: %s pid: %d "
-			"[%llu->%llu] flags: %#llx nid: %s "
-			"remote: %#llx expref: %d pid: %u timeout: %lu\n",
-			ldlm_lock_to_ns_name(lock), lock,
-			lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
-			lock->l_readers, lock->l_writers,
-			ldlm_lockname[lock->l_granted_mode],
-			ldlm_lockname[lock->l_req_mode],
-			PLDLMRES(resource),
-			atomic_read(&resource->lr_refcount),
-			ldlm_typename[resource->lr_type],
-			lock->l_policy_data.l_flock.pid,
-			lock->l_policy_data.l_flock.start,
-			lock->l_policy_data.l_flock.end,
-			lock->l_flags, nid, lock->l_remote_handle.cookie,
-			exp ? atomic_read(&exp->exp_refcount) : -99,
-			lock->l_pid, lock->l_callback_timeout);
+				   " ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s res: " DLDLMRES " rrc: %d type: %s pid: %d [%llu->%llu] flags: %#llx nid: %s remote: %#llx expref: %d pid: %u timeout: %lu\n",
+				   ldlm_lock_to_ns_name(lock), lock,
+				   lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
+				   lock->l_readers, lock->l_writers,
+				   ldlm_lockname[lock->l_granted_mode],
+				   ldlm_lockname[lock->l_req_mode],
+				   PLDLMRES(resource),
+				   atomic_read(&resource->lr_refcount),
+				   ldlm_typename[resource->lr_type],
+				   lock->l_policy_data.l_flock.pid,
+				   lock->l_policy_data.l_flock.start,
+				   lock->l_policy_data.l_flock.end,
+				   lock->l_flags, nid, lock->l_remote_handle.cookie,
+				   exp ? atomic_read(&exp->exp_refcount) : -99,
+				   lock->l_pid, lock->l_callback_timeout);
 		break;
 
 	case LDLM_IBITS:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-			" ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s "
-			"res: "DLDLMRES" bits %#llx rrc: %d type: %s "
-			"flags: %#llx nid: %s remote: %#llx expref: %d "
-			"pid: %u timeout: %lu lvb_type: %d\n",
-			ldlm_lock_to_ns_name(lock),
-			lock, lock->l_handle.h_cookie,
-			atomic_read(&lock->l_refc),
-			lock->l_readers, lock->l_writers,
-			ldlm_lockname[lock->l_granted_mode],
-			ldlm_lockname[lock->l_req_mode],
-			PLDLMRES(resource),
-			lock->l_policy_data.l_inodebits.bits,
-			atomic_read(&resource->lr_refcount),
-			ldlm_typename[resource->lr_type],
-			lock->l_flags, nid, lock->l_remote_handle.cookie,
-			exp ? atomic_read(&exp->exp_refcount) : -99,
-			lock->l_pid, lock->l_callback_timeout,
-			lock->l_lvb_type);
+				   " ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s res: " DLDLMRES " bits %#llx rrc: %d type: %s flags: %#llx nid: %s remote: %#llx expref: %d pid: %u timeout: %lu lvb_type: %d\n",
+				   ldlm_lock_to_ns_name(lock),
+				   lock, lock->l_handle.h_cookie,
+				   atomic_read(&lock->l_refc),
+				   lock->l_readers, lock->l_writers,
+				   ldlm_lockname[lock->l_granted_mode],
+				   ldlm_lockname[lock->l_req_mode],
+				   PLDLMRES(resource),
+				   lock->l_policy_data.l_inodebits.bits,
+				   atomic_read(&resource->lr_refcount),
+				   ldlm_typename[resource->lr_type],
+				   lock->l_flags, nid, lock->l_remote_handle.cookie,
+				   exp ? atomic_read(&exp->exp_refcount) : -99,
+				   lock->l_pid, lock->l_callback_timeout,
+				   lock->l_lvb_type);
 		break;
 
 	default:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-			" ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s "
-			"res: "DLDLMRES" rrc: %d type: %s flags: %#llx "
-			"nid: %s remote: %#llx expref: %d pid: %u "
-			"timeout: %lu lvb_type: %d\n",
-			ldlm_lock_to_ns_name(lock),
-			lock, lock->l_handle.h_cookie,
-			atomic_read(&lock->l_refc),
-			lock->l_readers, lock->l_writers,
-			ldlm_lockname[lock->l_granted_mode],
-			ldlm_lockname[lock->l_req_mode],
-			PLDLMRES(resource),
-			atomic_read(&resource->lr_refcount),
-			ldlm_typename[resource->lr_type],
-			lock->l_flags, nid, lock->l_remote_handle.cookie,
-			exp ? atomic_read(&exp->exp_refcount) : -99,
-			lock->l_pid, lock->l_callback_timeout,
-			lock->l_lvb_type);
+				   " ns: %s lock: %p/%#llx lrc: %d/%d,%d mode: %s/%s res: " DLDLMRES " rrc: %d type: %s flags: %#llx nid: %s remote: %#llx expref: %d pid: %u timeout: %lu lvb_type: %d\n",
+				   ldlm_lock_to_ns_name(lock),
+				   lock, lock->l_handle.h_cookie,
+				   atomic_read(&lock->l_refc),
+				   lock->l_readers, lock->l_writers,
+				   ldlm_lockname[lock->l_granted_mode],
+				   ldlm_lockname[lock->l_req_mode],
+				   PLDLMRES(resource),
+				   atomic_read(&resource->lr_refcount),
+				   ldlm_typename[resource->lr_type],
+				   lock->l_flags, nid, lock->l_remote_handle.cookie,
+				   exp ? atomic_read(&exp->exp_refcount) : -99,
+				   lock->l_pid, lock->l_callback_timeout,
+				   lock->l_lvb_type);
 		break;
 	}
 	va_end(args);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 91cf7eb..5fb9d84 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -210,9 +210,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 			LASSERT(lock->l_lvb_data != NULL);
 
 			if (unlikely(lock->l_lvb_len < lvb_len)) {
-				LDLM_ERROR(lock, "Replied LVB is larger than "
-					   "expectation, expected = %d, "
-					   "replied = %d",
+				LDLM_ERROR(lock, "Replied LVB is larger than expectation, expected = %d, replied = %d",
 					   lock->l_lvb_len, lvb_len);
 				rc = -EINVAL;
 				goto out;
@@ -639,8 +637,8 @@ static int ldlm_callback_handler(struct ptlrpc_request *req)
 
 	lock = ldlm_handle2lock_long(&dlm_req->lock_handle[0], 0);
 	if (!lock) {
-		CDEBUG(D_DLMTRACE, "callback on lock %#llx - lock "
-		       "disappeared\n", dlm_req->lock_handle[0].cookie);
+		CDEBUG(D_DLMTRACE, "callback on lock %#llx - lock disappeared\n",
+		       dlm_req->lock_handle[0].cookie);
 		rc = ldlm_callback_reply(req, -EINVAL);
 		ldlm_callback_errmsg(req, "Operate with invalid parameter", rc,
 				     &dlm_req->lock_handle[0]);
@@ -663,8 +661,7 @@ static int ldlm_callback_handler(struct ptlrpc_request *req)
 		if (((lock->l_flags & LDLM_FL_CANCELING) &&
 		    (lock->l_flags & LDLM_FL_BL_DONE)) ||
 		    (lock->l_flags & LDLM_FL_FAILED)) {
-			LDLM_DEBUG(lock, "callback on lock "
-				   "%#llx - lock disappeared\n",
+			LDLM_DEBUG(lock, "callback on lock %#llx - lock disappeared\n",
 				   dlm_req->lock_handle[0].cookie);
 			unlock_res_and_lock(lock);
 			LDLM_LOCK_RELEASE(lock);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index c80c76a..0e1ab06 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -614,8 +614,8 @@ int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
 			lprocfs_counter_add(pl->pl_stats,
 					    LDLM_POOL_SHRINK_FREED_STAT,
 					    cancel);
-			CDEBUG(D_DLMTRACE, "%s: request to shrink %d locks, "
-			       "shrunk %d\n", pl->pl_name, nr, cancel);
+			CDEBUG(D_DLMTRACE, "%s: request to shrink %d locks, shrunk %d\n",
+			       pl->pl_name, nr, cancel);
 		}
 	}
 	return cancel;
@@ -1194,10 +1194,8 @@ int ldlm_pools_recalc(ldlm_side_t client)
 		 * of limit.
 		 */
 		if (nr_l >= 2 * (LDLM_POOL_HOST_L / 3)) {
-			CWARN("\"Modest\" pools eat out 2/3 of server locks "
-			      "limit (%d of %lu). This means that you have too "
-			      "many clients for this amount of server RAM. "
-			      "Upgrade server!\n", nr_l, LDLM_POOL_HOST_L);
+			CWARN("\"Modest\" pools eat out 2/3 of server locks limit (%d of %lu). This means that you have too many clients for this amount of server RAM. Upgrade server!\n",
+			      nr_l, LDLM_POOL_HOST_L);
 			equal = 1;
 		}
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 9ce437b..95e71a0 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -102,9 +102,7 @@ int ldlm_expired_completion_wait(void *data)
 			      lock->l_last_activity,
 			      cfs_time_sub(get_seconds(),
 					   lock->l_last_activity));
-		LDLM_DEBUG(lock, "lock timed out (enqueued at "CFS_TIME_T", "
-			   CFS_DURATION_T"s ago); not entering recovery in "
-			   "server code, just going back to sleep",
+		LDLM_DEBUG(lock, "lock timed out (enqueued at " CFS_TIME_T ", " CFS_DURATION_T "s ago); not entering recovery in server code, just going back to sleep",
 			   lock->l_last_activity,
 			   cfs_time_sub(get_seconds(),
 					lock->l_last_activity));
@@ -191,8 +189,7 @@ int ldlm_completion_ast_async(struct ldlm_lock *lock, __u64 flags, void *data)
 		return ldlm_completion_tail(lock);
 	}
 
-	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, "
-		   "going forward");
+	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, going forward");
 	ldlm_reprocess_all(lock->l_resource);
 	return 0;
 }
@@ -240,8 +237,7 @@ int ldlm_completion_ast(struct ldlm_lock *lock, __u64 flags, void *data)
 		return 0;
 	}
 
-	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, "
-		   "sleeping");
+	LDLM_DEBUG(lock, "client-side enqueue returned a blocked lock, sleeping");
 
 noreproc:
 
@@ -324,8 +320,7 @@ int ldlm_blocking_ast_nocheck(struct ldlm_lock *lock)
 		if (rc < 0)
 			CERROR("ldlm_cli_cancel: %d\n", rc);
 	} else {
-		LDLM_DEBUG(lock, "Lock still has references, will be "
-			   "cancelled later");
+		LDLM_DEBUG(lock, "Lock still has references, will be cancelled later");
 	}
 	return 0;
 }
@@ -483,8 +478,7 @@ static void failed_lock_cleanup(struct ldlm_namespace *ns,
 
 	if (need_cancel)
 		LDLM_DEBUG(lock,
-			   "setting FL_LOCAL_ONLY | LDLM_FL_FAILED | "
-			   "LDLM_FL_ATOMIC_CB | LDLM_FL_CBPENDING");
+			   "setting FL_LOCAL_ONLY | LDLM_FL_FAILED | LDLM_FL_ATOMIC_CB | LDLM_FL_CBPENDING");
 	else
 		LDLM_DEBUG(lock, "lock was granted or failed in race");
 
@@ -557,8 +551,7 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 			rc = size;
 			goto cleanup;
 		} else if (unlikely(size > lvb_len)) {
-			LDLM_ERROR(lock, "Replied LVB is larger than "
-				   "expectation, expected = %d, replied = %d",
+			LDLM_ERROR(lock, "Replied LVB is larger than expectation, expected = %d, replied = %d",
 				   lvb_len, size);
 			rc = -EINVAL;
 			goto cleanup;
@@ -1107,8 +1100,7 @@ static __u64 ldlm_cli_cancel_local(struct ldlm_lock *lock)
 		unlock_res_and_lock(lock);
 
 		if (local_only) {
-			CDEBUG(D_DLMTRACE, "not sending request (at caller's "
-			       "instruction)\n");
+			CDEBUG(D_DLMTRACE, "not sending request (at caller's instruction)\n");
 			rc = LDLM_FL_LOCAL_ONLY;
 		}
 		ldlm_lock_cancel(lock);
@@ -1223,8 +1215,7 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 			rc = ptlrpc_queue_wait(req);
 		}
 		if (rc == LUSTRE_ESTALE) {
-			CDEBUG(D_DLMTRACE, "client/server (nid %s) "
-			       "out of sync -- not fatal\n",
+			CDEBUG(D_DLMTRACE, "client/server (nid %s) out of sync -- not fatal\n",
 			       libcfs_nid2str(req->rq_import->
 					      imp_connection->c_peer.nid));
 			rc = 0;
@@ -1235,8 +1226,8 @@ int ldlm_cli_cancel_req(struct obd_export *exp, struct list_head *cancels,
 		} else if (rc != ELDLM_OK) {
 			/* -ESHUTDOWN is common on umount */
 			CDEBUG_LIMIT(rc == -ESHUTDOWN ? D_DLMTRACE : D_ERROR,
-				     "Got rc %d from cancel RPC: "
-				     "canceling anyway\n", rc);
+				     "Got rc %d from cancel RPC: canceling anyway\n",
+				     rc);
 			break;
 		}
 		sent = count;
@@ -2114,8 +2105,7 @@ static int replay_lock_interpret(const struct lu_env *env,
 
 	lock = ldlm_handle2lock(&aa->lock_handle);
 	if (!lock) {
-		CERROR("received replay ack for unknown local cookie %#llx"
-		       " remote cookie %#llx from server %s id %s\n",
+		CERROR("received replay ack for unknown local cookie %#llx remote cookie %#llx from server %s id %s\n",
 		       aa->lock_handle.cookie, reply->lock_handle.cookie,
 		       req->rq_export->exp_client_uuid.uuid,
 		       libcfs_id2str(req->rq_peer));
@@ -2243,9 +2233,8 @@ static void ldlm_cancel_unused_locks_for_replay(struct ldlm_namespace *ns)
 	int canceled;
 	LIST_HEAD(cancels);
 
-	CDEBUG(D_DLMTRACE, "Dropping as many unused locks as possible before"
-			   "replay for namespace %s (%d)\n",
-			   ldlm_ns_name(ns), ns->ns_nr_unused);
+	CDEBUG(D_DLMTRACE, "Dropping as many unused locks as possible before replay for namespace %s (%d)\n",
+	       ldlm_ns_name(ns), ns->ns_nr_unused);
 
 	/* We don't need to care whether or not LRU resize is enabled
 	 * because the LDLM_CANCEL_NO_WAIT policy doesn't use the
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 8b20a83..397adbe 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -215,8 +215,8 @@ static ssize_t lprocfs_lru_size_seq_write(struct file *file,
 						   LDLM_CANCEL_PASSED);
 			if (canceled < unused) {
 				CDEBUG(D_DLMTRACE,
-				       "not all requested locks are canceled, "
-				       "requested: %d, canceled: %d\n", unused,
+				       "not all requested locks are canceled, requested: %d, canceled: %d\n",
+				       unused,
 				       canceled);
 				return -EINVAL;
 			}
@@ -735,8 +735,7 @@ static void cleanup_resource(struct ldlm_resource *res, struct list_head *q,
 		} else {
 			ldlm_resource_unlink_lock(lock);
 			unlock_res(res);
-			LDLM_DEBUG(lock, "Freeing a lock still held by a "
-				   "client node");
+			LDLM_DEBUG(lock, "Freeing a lock still held by a client node");
 			ldlm_lock_destroy(lock);
 		}
 		LDLM_LOCK_RELEASE(lock);
@@ -818,16 +817,14 @@ force_wait:
 		/* Forced cleanups should be able to reclaim all references,
 		 * so it's safe to wait forever... we can't leak locks... */
 		if (force && rc == -ETIMEDOUT) {
-			LCONSOLE_ERROR("Forced cleanup waiting for %s "
-				       "namespace with %d resources in use, "
-				       "(rc=%d)\n", ldlm_ns_name(ns),
+			LCONSOLE_ERROR("Forced cleanup waiting for %s namespace with %d resources in use, (rc=%d)\n",
+				       ldlm_ns_name(ns),
 				       atomic_read(&ns->ns_bref), rc);
 			goto force_wait;
 		}
 
 		if (atomic_read(&ns->ns_bref)) {
-			LCONSOLE_ERROR("Cleanup waiting for %s namespace "
-				       "with %d resources in use, (rc=%d)\n",
+			LCONSOLE_ERROR("Cleanup waiting for %s namespace with %d resources in use, (rc=%d)\n",
 				       ldlm_ns_name(ns),
 				       atomic_read(&ns->ns_bref), rc);
 			return ELDLM_NAMESPACE_EXISTS;
@@ -1404,8 +1401,8 @@ void ldlm_resource_dump(int level, struct ldlm_resource *res)
 			LDLM_DEBUG_LIMIT(level, lock, "###");
 			if (!(level & D_CANTMASK) &&
 			    ++granted > ldlm_dump_granted_max) {
-				CDEBUG(level, "only dump %d granted locks to "
-				       "avoid DDOS.\n", granted);
+				CDEBUG(level, "only dump %d granted locks to avoid DDOS.\n",
+				       granted);
 				break;
 			}
 		}
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 2c15a9e..5b976aa 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -318,9 +318,7 @@ libcfs_debug_str2mask(int *mask, const char *str, int is_subsys)
 	if (t >= 1 && matched == n) {
 		/* don't print warning for lctl set_param debug=0 or -1 */
 		if (m != 0 && m != -1)
-			CWARN("You are trying to use a numerical value for the "
-			      "mask - this will be deprecated in a future "
-			      "release.\n");
+			CWARN("You are trying to use a numerical value for the mask - this will be deprecated in a future release.\n");
 		*mask = m;
 		return 0;
 	}
@@ -375,8 +373,8 @@ void libcfs_debug_dumplog(void)
 			     (void *)(long)current_pid(),
 			     "libcfs_debug_dumper");
 	if (IS_ERR(dumper))
-		pr_err("LustreError: cannot start log dump thread:"
-		       " %ld\n", PTR_ERR(dumper));
+		pr_err("LustreError: cannot start log dump thread: %ld\n",
+		       PTR_ERR(dumper));
 	else
 		schedule();
 
diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 32da783..2d1e672 100644
--- a/drivers/staging/lustre/lustre/libcfs/hash.c
+++ b/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -1121,8 +1121,7 @@ cfs_hash_destroy(struct cfs_hash *hs)
 		cfs_hash_bd_for_each_hlist(hs, &bd, hhead) {
 			hlist_for_each_safe(hnode, pos, hhead) {
 				LASSERTF(!cfs_hash_with_assert_empty(hs),
-					 "hash %s bucket %u(%u) is not "
-					 " empty: %u items left\n",
+					 "hash %s bucket %u(%u) is not empty: %u items left\n",
 					 hs->hs_name, bd.bd_bucket->hsb_index,
 					 bd.bd_offset, bd.bd_bucket->hsb_count);
 				/* can't assert key valicate, because we
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index 224c65b..05f7595 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -333,8 +333,8 @@ cfs_cpt_unset_cpu(struct cfs_cpt_table *cptab, int cpt, int cpu)
 		/* caller doesn't know the partition ID */
 		cpt = cptab->ctb_cpu2cpt[cpu];
 		if (cpt < 0) { /* not set in this CPT-table */
-			CDEBUG(D_INFO, "Try to unset cpu %d which is "
-				       "not in CPT-table %p\n", cpt, cptab);
+			CDEBUG(D_INFO, "Try to unset cpu %d which is not in CPT-table %p\n",
+			       cpt, cptab);
 			return;
 		}
 
@@ -384,8 +384,8 @@ cfs_cpt_set_cpumask(struct cfs_cpt_table *cptab, int cpt, cpumask_t *mask)
 	int	i;
 
 	if (cpus_weight(*mask) == 0 || any_online_cpu(*mask) == NR_CPUS) {
-		CDEBUG(D_INFO, "No online CPU is found in the CPU mask "
-			       "for CPU partition %d\n", cpt);
+		CDEBUG(D_INFO, "No online CPU is found in the CPU mask for CPU partition %d\n",
+		       cpt);
 		return 0;
 	}
 
@@ -579,9 +579,8 @@ cfs_cpt_bind(struct cfs_cpt_table *cptab, int cpt)
 	}
 
 	if (any_online_cpu(*cpumask) == NR_CPUS) {
-		CERROR("No online CPU found in CPU partition %d, did someone "
-		       "do CPU hotplug on system? You might need to reload "
-		       "Lustre modules to keep system working well.\n", cpt);
+		CERROR("No online CPU found in CPU partition %d, did someone do CPU hotplug on system? You might need to reload Lustre modules to keep system working well.\n",
+		       cpt);
 		return -EINVAL;
 	}
 
@@ -737,16 +736,12 @@ cfs_cpt_table_create(int ncpt)
 		ncpt = rc;
 
 	if (ncpt > num_online_cpus() || ncpt > 4 * rc) {
-		CWARN("CPU partition number %d is larger than suggested "
-		      "value (%d), your system may have performance"
-		      "issue or run out of memory while under pressure\n",
+		CWARN("CPU partition number %d is larger than suggested value (%d), your system may have performance issue or run out of memory while under pressure\n",
 		      ncpt, rc);
 	}
 
 	if (num_online_cpus() % ncpt != 0) {
-		CERROR("CPU number %d is not multiple of cpu_npartition %d, "
-		       "please try different cpu_npartitions value or"
-		       "set pattern string by cpu_pattern=STRING\n",
+		CERROR("CPU number %d is not multiple of cpu_npartition %d, please try different cpu_npartitions value or set pattern string by cpu_pattern=STRING\n",
 		       (int)num_online_cpus(), ncpt);
 		goto failed;
 	}
@@ -796,8 +791,7 @@ cfs_cpt_table_create(int ncpt)
 
 	if (cpt != ncpt ||
 	    num != cpus_weight(*cptab->ctb_parts[ncpt - 1].cpt_cpumask)) {
-		CERROR("Expect %d(%d) CPU partitions but got %d(%d), "
-		       "CPU hotplug/unplug while setting?\n",
+		CERROR("Expect %d(%d) CPU partitions but got %d(%d), CPU hotplug/unplug while setting?\n",
 		       cptab->ctb_nparts, num, cpt,
 		       cpus_weight(*cptab->ctb_parts[ncpt - 1].cpt_cpumask));
 		goto failed;
@@ -808,8 +802,7 @@ cfs_cpt_table_create(int ncpt)
 	return cptab;
 
  failed:
-	CERROR("Failed to setup CPU-partition-table with %d "
-	       "CPU-partitions, online HW nodes: %d, HW cpus: %d.\n",
+	CERROR("Failed to setup CPU-partition-table with %d CPU-partitions, online HW nodes: %d, HW cpus: %d.\n",
 	       ncpt, num_online_nodes(), num_online_cpus());
 
 	if (mask != NULL)
@@ -975,9 +968,8 @@ cfs_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		warn = any_online_cpu(*cpt_data.cpt_cpumask) >= nr_cpu_ids;
 		mutex_unlock(&cpt_data.cpt_mutex);
 		CDEBUG(warn ? D_WARNING : D_INFO,
-		       "Lustre: can't support CPU plug-out well now, "
-		       "performance and stability could be impacted "
-		       "[CPU %u action: %lx]\n", cpu, action);
+		       "Lustre: can't support CPU plug-out well now, performance and stability could be impacted [CPU %u action: %lx]\n",
+		       cpu, action);
 	}
 
 	return NOTIFY_OK;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index 3298ddf..12005a7 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -87,8 +87,7 @@ void libcfs_run_debug_log_upcall(char *file)
 
 	rc = call_usermodehelper(argv[0], argv, envp, 1);
 	if (rc < 0 && rc != -ENOENT) {
-		CERROR("Error %d invoking LNET debug log upcall %s %s; "
-		       "check /proc/sys/lnet/debug_log_upcall\n",
+		CERROR("Error %d invoking LNET debug log upcall %s %s; check /proc/sys/lnet/debug_log_upcall\n",
 		       rc, argv[0], argv[1]);
 	} else {
 		CDEBUG(D_HA, "Invoked LNET debug log upcall %s %s\n",
@@ -114,8 +113,7 @@ void libcfs_run_upcall(char **argv)
 
 	rc = call_usermodehelper(argv[0], argv, envp, 1);
 	if (rc < 0 && rc != -ENOENT) {
-		CERROR("Error %d invoking LNET upcall %s %s%s%s%s%s%s%s%s; "
-		       "check /proc/sys/lnet/upcall\n",
+		CERROR("Error %d invoking LNET upcall %s %s%s%s%s%s%s%s%s; check /proc/sys/lnet/upcall\n",
 		       rc, argv[0], argv[1],
 		       argc < 3 ? "" : ",", argc < 3 ? "" : argv[2],
 		       argc < 4 ? "" : ",", argc < 4 ? "" : argv[3],
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index 939b33d..b91a1f9 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -279,8 +279,7 @@ libcfs_sock_write (struct socket *sock, void *buffer, int nob, int timeout)
 			rc = kernel_setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO,
 					     (char *)&tv, sizeof(tv));
 			if (rc != 0) {
-				CERROR("Can't set socket send timeout "
-				       "%ld.%06d: %d\n",
+				CERROR("Can't set socket send timeout %ld.%06d: %d\n",
 				       (long)tv.tv_sec, (int)tv.tv_usec, rc);
 				return rc;
 			}
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 7e3f6a4..5fded5a 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -196,8 +196,7 @@ static void cfs_tcd_shrink(struct cfs_trace_cpu_data *tcd)
 	 */
 
 	if (printk_ratelimit())
-		printk(KERN_WARNING "debug daemon buffer overflowed; "
-		       "discarding 10%% of pages (%d of %ld)\n",
+		printk(KERN_WARNING "debug daemon buffer overflowed; discarding 10%% of pages (%d of %ld)\n",
 		       pgcount + 1, tcd->tcd_cur_pages);
 
 	INIT_LIST_HEAD(&pc.pc_pages);
@@ -357,8 +356,8 @@ int libcfs_debug_vmsg2(struct libcfs_debug_msg_data *msgdata,
 	}
 
 	if (*(string_buf+needed-1) != '\n')
-		printk(KERN_INFO "format at %s:%d:%s doesn't end in "
-		       "newline\n", file, msgdata->msg_line, msgdata->msg_fn);
+		printk(KERN_INFO "format at %s:%d:%s doesn't end in newline\n",
+		       file, msgdata->msg_line, msgdata->msg_fn);
 
 	header.ph_len = known_size + needed;
 	debug_buf = (char *)page_address(tage->page) + tage->used;
@@ -715,8 +714,8 @@ int cfs_tracefile_dump_all_pages(char *filename)
 		kunmap(tage->page);
 
 		if (rc != (int)tage->used) {
-			printk(KERN_WARNING "wanted to write %u but wrote "
-			       "%d\n", tage->used, rc);
+			printk(KERN_WARNING "wanted to write %u but wrote %d\n",
+			       tage->used, rc);
 			put_pages_back(&pc);
 			__LASSERT(list_empty(&pc.pc_pages));
 			break;
@@ -875,8 +874,8 @@ int cfs_trace_daemon_command(char *str)
 		strcpy(cfs_tracefile, str);
 
 		printk(KERN_INFO
-		       "Lustre: debug daemon will attempt to start writing "
-		       "to %s (%lukB max)\n", cfs_tracefile,
+		       "Lustre: debug daemon will attempt to start writing to %s (%lukB max)\n",
+		       cfs_tracefile,
 		       (long)(cfs_tracefile_size >> 10));
 
 		cfs_trace_start_thread();
@@ -914,15 +913,15 @@ int cfs_trace_set_debug_mb(int mb)
 
 	if (mb < num_possible_cpus()) {
 		printk(KERN_WARNING
-		       "Lustre: %d MB is too small for debug buffer size, "
-		       "setting it to %d MB.\n", mb, num_possible_cpus());
+		       "Lustre: %d MB is too small for debug buffer size, setting it to %d MB.\n",
+		       mb, num_possible_cpus());
 		mb = num_possible_cpus();
 	}
 
 	if (mb > limit) {
 		printk(KERN_WARNING
-		       "Lustre: %d MB is too large for debug buffer size, "
-		       "setting it to %d MB.\n", mb, limit);
+		       "Lustre: %d MB is too large for debug buffer size, setting it to %d MB.\n",
+		       mb, limit);
 		mb = limit;
 	}
 
@@ -1004,8 +1003,8 @@ static int tracefiled(void *arg)
 			if (IS_ERR(filp)) {
 				rc = PTR_ERR(filp);
 				filp = NULL;
-				printk(KERN_WARNING "couldn't open %s: "
-				       "%d\n", cfs_tracefile, rc);
+				printk(KERN_WARNING "couldn't open %s: %d\n",
+				       cfs_tracefile, rc);
 			}
 		}
 		cfs_tracefile_read_unlock();
@@ -1034,8 +1033,8 @@ static int tracefiled(void *arg)
 			kunmap(tage->page);
 
 			if (rc != (int)tage->used) {
-				printk(KERN_WARNING "wanted to write %u "
-				       "but wrote %d\n", tage->used, rc);
+				printk(KERN_WARNING "wanted to write %u but wrote %d\n",
+				       tage->used, rc);
 				put_pages_back(&pc);
 				__LASSERT(list_empty(&pc.pc_pages));
 			}
@@ -1047,8 +1046,7 @@ static int tracefiled(void *arg)
 		if (!list_empty(&pc.pc_pages)) {
 			int i;
 
-			printk(KERN_ALERT "Lustre: trace pages aren't "
-			       " empty\n");
+			printk(KERN_ALERT "Lustre: trace pages aren't empty\n");
 			printk(KERN_ERR "total cpus(%d): ",
 			       num_possible_cpus());
 			for (i = 0; i < num_possible_cpus(); i++)
@@ -1061,8 +1059,8 @@ static int tracefiled(void *arg)
 			i = 0;
 			list_for_each_entry_safe(tage, tmp, &pc.pc_pages,
 						     linkage)
-				printk(KERN_ERR "page %d belongs to cpu "
-				       "%d\n", ++i, tage->cpu);
+				printk(KERN_ERR "page %d belongs to cpu %d\n",
+				       ++i, tage->cpu);
 			printk(KERN_ERR "There are %d pages unwritten\n",
 			       i);
 		}
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index 439e487..5f03c5f 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -259,9 +259,9 @@ void ll_invalidate_aliases(struct inode *inode)
 
 	ll_lock_dcache(inode);
 	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
-		CDEBUG(D_DENTRY, "dentry in drop %.*s (%p) parent %p "
-		       "inode %p flags %d\n", dentry->d_name.len,
-		       dentry->d_name.name, dentry, dentry->d_parent,
+		CDEBUG(D_DENTRY, "dentry in drop %.*s (%p) parent %p inode %p flags %d\n",
+		       dentry->d_name.len, dentry->d_name.name,
+		       dentry, dentry->d_parent,
 		       dentry->d_inode, dentry->d_flags);
 
 		if (unlikely(dentry == dentry->d_sb->s_root)) {
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 661b2cf..1f181c8 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -228,8 +228,8 @@ static int ll_dir_filler(void *_hash, struct page *page0)
 			if (ll_pagevec_add(&lru_pvec, page) == 0)
 				ll_pagevec_lru_add_file(&lru_pvec);
 		} else {
-			CDEBUG(D_VFSTRACE, "page %lu add to page cache failed:"
-			       " %d\n", offset, ret);
+			CDEBUG(D_VFSTRACE, "page %lu add to page cache failed: %d\n",
+			       offset, ret);
 		}
 		page_cache_release(page);
 	}
@@ -600,8 +600,8 @@ static int ll_readdir(struct file *filp, struct dir_context *ctx)
 	int			api32	= ll_need_32bit_api(sbi);
 	int			rc;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p) pos %lu/%llu "
-	       " 32bit_api %d\n", inode->i_ino, inode->i_generation,
+	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p) pos %lu/%llu 32bit_api %d\n",
+	       inode->i_ino, inode->i_generation,
 	       inode, (unsigned long)lfd->lfd_pos, i_size_read(inode), api32);
 
 	if (lfd->lfd_pos == MDS_DIR_END_OFF) {
@@ -715,10 +715,9 @@ int ll_dir_setstripe(struct inode *inode, struct lov_user_md *lump,
 			break;
 		}
 		default: {
-			CDEBUG(D_IOCTL, "bad userland LOV MAGIC:"
-					" %#08x != %#08x nor %#08x\n",
-					lump->lmm_magic, LOV_USER_MAGIC_V1,
-					LOV_USER_MAGIC_V3);
+			CDEBUG(D_IOCTL, "bad userland LOV MAGIC: %#08x != %#08x nor %#08x\n",
+			       lump->lmm_magic, LOV_USER_MAGIC_V1,
+			       LOV_USER_MAGIC_V3);
 			return -EINVAL;
 		}
 		}
@@ -814,8 +813,8 @@ int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
 	rc = md_getattr(sbi->ll_md_exp, op_data, &req);
 	ll_finish_md_op_data(op_data);
 	if (rc < 0) {
-		CDEBUG(D_INFO, "md_getattr failed on inode "
-		       "%lu/%u: rc %d\n", inode->i_ino,
+		CDEBUG(D_INFO, "md_getattr failed on inode %lu/%u: rc %d\n",
+		       inode->i_ino,
 		       inode->i_generation, rc);
 		goto out;
 	}
@@ -1013,8 +1012,7 @@ static int ll_ioc_copy_end(struct super_block *sb, struct hsm_copy *copy)
 				     copy->hc_hai.hai_action == HSMA_ARCHIVE);
 		iput(inode);
 		if (rc) {
-			CDEBUG(D_HSM, "Could not read file data version. "
-				      "Request could not be confirmed.\n");
+			CDEBUG(D_HSM, "Could not read file data version. Request could not be confirmed.\n");
 			if (hpk.hpk_errval == 0)
 				hpk.hpk_errval = -rc;
 			goto progress;
@@ -1028,8 +1026,7 @@ static int ll_ioc_copy_end(struct super_block *sb, struct hsm_copy *copy)
 		 * to check anyway. */
 		if ((copy->hc_hai.hai_action == HSMA_ARCHIVE) &&
 		    (copy->hc_data_version != data_version)) {
-			CDEBUG(D_HSM, "File data version mismatched. "
-			      "File content was changed during archiving. "
+			CDEBUG(D_HSM, "File data version mismatched. File content was changed during archiving. "
 			       DFID", start:%#llx current:%#llx\n",
 			       PFID(&copy->hc_hai.hai_fid),
 			       copy->hc_data_version, data_version);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index a5acc98..234c714 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -170,8 +170,8 @@ static int ll_close_inode_openhandle(struct obd_export *md_exp,
 		 * OSTs and send setattr to back to MDS. */
 		rc = ll_som_update(inode, op_data);
 		if (rc) {
-			CERROR("inode %lu mdc Size-on-MDS update failed: "
-			       "rc = %d\n", inode->i_ino, rc);
+			CERROR("inode %lu mdc Size-on-MDS update failed: rc = %d\n",
+			       inode->i_ino, rc);
 			rc = 0;
 		}
 	} else if (rc) {
@@ -989,8 +989,8 @@ int ll_inode_getattr(struct inode *inode, struct obdo *obdo,
 		struct ost_id *oi = lsm ? &lsm->lsm_oi : &obdo->o_oi;
 
 		obdo_refresh_inode(inode, obdo, obdo->o_valid);
-		CDEBUG(D_INODE, "objid "DOSTID" size %llu, blocks %llu,"
-		       " blksize %lu\n", POSTID(oi), i_size_read(inode),
+		CDEBUG(D_INODE, "objid " DOSTID " size %llu, blocks %llu, blksize %lu\n",
+		       POSTID(oi), i_size_read(inode),
 		       (unsigned long long)inode->i_blocks,
 		       1UL << inode->i_blkbits);
 	}
@@ -1418,8 +1418,8 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 	rc = md_getattr_name(sbi->ll_md_exp, op_data, &req);
 	ll_finish_md_op_data(op_data);
 	if (rc < 0) {
-		CDEBUG(D_INFO, "md_getattr_name failed "
-		       "on %s: rc %d\n", filename, rc);
+		CDEBUG(D_INFO, "md_getattr_name failed on %s: rc %d\n",
+		       filename, rc);
 		goto out;
 	}
 
@@ -2233,8 +2233,8 @@ ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (cmd == LL_IOC_SETFLAGS) {
 			if ((flags & LL_FILE_IGNORE_LOCK) &&
 			    !(file->f_flags & O_DIRECT)) {
-				CERROR("%s: unable to disable locking on "
-				       "non-O_DIRECT file\n", current->comm);
+				CERROR("%s: unable to disable locking on non-O_DIRECT file\n",
+				       current->comm);
 				return -EINVAL;
 			}
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_capa.c b/drivers/staging/lustre/lustre/llite/llite_capa.c
index b1e39ee..aec9a44 100644
--- a/drivers/staging/lustre/lustre/llite/llite_capa.c
+++ b/drivers/staging/lustre/lustre/llite/llite_capa.c
@@ -540,8 +540,7 @@ static int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa)
 			if (rc == -EIO && !capa_is_expired(ocapa)) {
 				delay_capa_renew(ocapa, 120);
 				DEBUG_CAPA(D_ERROR, &ocapa->c_capa,
-					   "renewal failed: -EIO, "
-					   "retry in 2 mins");
+					   "renewal failed: -EIO, retry in 2 mins");
 				ll_capa_renewal_retries++;
 				goto retry;
 			} else {
diff --git a/drivers/staging/lustre/lustre/llite/llite_close.c b/drivers/staging/lustre/lustre/llite/llite_close.c
index 84e0003..21b4a50 100644
--- a/drivers/staging/lustre/lustre/llite/llite_close.c
+++ b/drivers/staging/lustre/lustre/llite/llite_close.c
@@ -90,8 +90,7 @@ void ll_queue_done_writing(struct inode *inode, unsigned long flags)
 		struct ll_close_queue *lcq = ll_i2sbi(inode)->ll_lcq;
 
 		if (lli->lli_flags & LLIF_MDS_SIZE_LOCK)
-			CWARN("ino %lu/%u(flags %u) som valid it just after "
-			      "recovery\n",
+			CWARN("ino %lu/%u(flags %u) som valid it just after recovery\n",
 			      inode->i_ino, inode->i_generation,
 			      lli->lli_flags);
 		/* DONE_WRITING is allowed and inode has no dirty page. */
@@ -124,8 +123,8 @@ void ll_done_writing_attr(struct inode *inode, struct md_op_data *op_data)
 	op_data->op_flags |= MF_SOM_CHANGE;
 	/* Check if Size-on-MDS attributes are valid. */
 	if (lli->lli_flags & LLIF_MDS_SIZE_LOCK)
-		CERROR("ino %lu/%u(flags %u) som valid it just after "
-		       "recovery\n", inode->i_ino, inode->i_generation,
+		CERROR("ino %lu/%u(flags %u) som valid it just after recovery\n",
+		       inode->i_ino, inode->i_generation,
 		       lli->lli_flags);
 
 	if (!cl_local_size(inode)) {
@@ -218,8 +217,8 @@ int ll_som_update(struct inode *inode, struct md_op_data *op_data)
 
 	LASSERT(op_data != NULL);
 	if (lli->lli_flags & LLIF_MDS_SIZE_LOCK)
-		CERROR("ino %lu/%u(flags %u) som valid it just after "
-		       "recovery\n", inode->i_ino, inode->i_generation,
+		CERROR("ino %lu/%u(flags %u) som valid it just after recovery\n",
+		       inode->i_ino, inode->i_generation,
 		       lli->lli_flags);
 
 	OBDO_ALLOC(oa);
@@ -238,9 +237,8 @@ int ll_som_update(struct inode *inode, struct md_op_data *op_data)
 		if (rc) {
 			oa->o_valid = 0;
 			if (rc != -ENOENT)
-				CERROR("inode_getattr failed (%d): unable to "
-				       "send a Size-on-MDS attribute update "
-				       "for inode %lu/%u\n", rc, inode->i_ino,
+				CERROR("inode_getattr failed (%d): unable to send a Size-on-MDS attribute update for inode %lu/%u\n",
+				       rc, inode->i_ino,
 				       inode->i_generation);
 		} else {
 			CDEBUG(D_INODE, "Size-on-MDS update on "DFID"\n",
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 2845aab..79fc29b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -1435,8 +1435,8 @@ static inline void ll_set_lock_data(struct obd_export *exp, struct inode *inode,
 		 * case the dcache being cleared */
 		if (it->d.lustre.it_remote_lock_mode) {
 			handle.cookie = it->d.lustre.it_remote_lock_handle;
-			CDEBUG(D_DLMTRACE, "setting l_data to inode %p"
-			       "(%lu/%u) for remote lock %#llx\n", inode,
+			CDEBUG(D_DLMTRACE, "setting l_data to inode %p(%lu/%u) for remote lock %#llx\n",
+			       inode,
 			       inode->i_ino, inode->i_generation,
 			       handle.cookie);
 			md_set_lock_data(exp, &handle.cookie, inode, NULL);
@@ -1444,8 +1444,8 @@ static inline void ll_set_lock_data(struct obd_export *exp, struct inode *inode,
 
 		handle.cookie = it->d.lustre.it_lock_handle;
 
-		CDEBUG(D_DLMTRACE, "setting l_data to inode %p (%lu/%u)"
-		       " for lock %#llx\n", inode, inode->i_ino,
+		CDEBUG(D_DLMTRACE, "setting l_data to inode %p (%lu/%u) for lock %#llx\n",
+		       inode, inode->i_ino,
 		       inode->i_generation, handle.cookie);
 
 		md_set_lock_data(exp, &handle.cookie, inode,
@@ -1489,8 +1489,8 @@ static inline void __d_lustre_invalidate(struct dentry *dentry)
  */
 static inline void d_lustre_invalidate(struct dentry *dentry, int nested)
 {
-	CDEBUG(D_DENTRY, "invalidate dentry %.*s (%p) parent %p inode %p "
-	       "refc %d\n", dentry->d_name.len, dentry->d_name.name, dentry,
+	CDEBUG(D_DENTRY, "invalidate dentry %.*s (%p) parent %p inode %p refc %d\n",
+	       dentry->d_name.len, dentry->d_name.name, dentry,
 	       dentry->d_parent, dentry->d_inode, d_count(dentry));
 
 	spin_lock_nested(&dentry->d_lock,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index afb433a..3b03360 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -253,10 +253,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	err = obd_connect(NULL, &sbi->ll_md_exp, obd, &sbi->ll_sb_uuid,
 			  data, NULL);
 	if (err == -EBUSY) {
-		LCONSOLE_ERROR_MSG(0x14f, "An MDT (md %s) is performing "
-				   "recovery, of which this client is not a "
-				   "part. Please wait for recovery to complete,"
-				   " abort, or time out.\n", md);
+		LCONSOLE_ERROR_MSG(0x14f, "An MDT (md %s) is performing recovery, of which this client is not a part. Please wait for recovery to complete, abort, or time out.\n",
+				   md);
 		goto out;
 	} else if (err) {
 		CERROR("cannot connect to %s: rc = %d\n", md, err);
@@ -268,8 +266,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	err = obd_fid_init(sbi->ll_md_exp->exp_obd, sbi->ll_md_exp,
 			   LUSTRE_SEQ_METADATA);
 	if (err) {
-		CERROR("%s: Can't init metadata layer FID infrastructure, "
-		       "rc = %d\n", sbi->ll_md_exp->exp_obd->obd_name, err);
+		CERROR("%s: Can't init metadata layer FID infrastructure, rc = %d\n",
+		       sbi->ll_md_exp->exp_obd->obd_name, err);
 		goto out_md;
 	}
 
@@ -297,10 +295,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		buf = kzalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
 		obd_connect_flags2str(buf, PAGE_CACHE_SIZE,
 				      valid ^ CLIENT_CONNECT_MDT_REQD, ",");
-		LCONSOLE_ERROR_MSG(0x170, "Server %s does not support "
-				   "feature(s) needed for correct operation "
-				   "of this client (%s). Please upgrade "
-				   "server or downgrade client.\n",
+		LCONSOLE_ERROR_MSG(0x170, "Server %s does not support feature(s) needed for correct operation of this client (%s). Please upgrade server or downgrade client.\n",
 				   sbi->ll_md_exp->exp_obd->obd_name, buf);
 		OBD_FREE(buf, PAGE_CACHE_SIZE);
 		err = -EPROTO;
@@ -326,8 +321,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 
 	if ((sbi->ll_flags & LL_SBI_USER_XATTR) &&
 	    !(data->ocd_connect_flags & OBD_CONNECT_XATTR)) {
-		LCONSOLE_INFO("Disabling user_xattr feature because "
-			      "it is not supported on the server\n");
+		LCONSOLE_INFO("Disabling user_xattr feature because it is not supported on the server\n");
 		sbi->ll_flags &= ~LL_SBI_USER_XATTR;
 	}
 
@@ -352,8 +346,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	} else {
 		if (sbi->ll_flags & LL_SBI_RMT_CLIENT) {
 			sbi->ll_flags &= ~LL_SBI_RMT_CLIENT;
-			LCONSOLE_INFO("client claims to be remote, but server "
-				      "rejected, forced to be local.\n");
+			LCONSOLE_INFO("client claims to be remote, but server rejected, forced to be local.\n");
 		}
 	}
 
@@ -430,8 +423,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (sbi->ll_flags & LL_SBI_RMT_CLIENT)
 		data->ocd_connect_flags |= OBD_CONNECT_RMT_CLIENT_FORCE;
 
-	CDEBUG(D_RPCTRACE, "ocd_connect_flags: %#llx ocd_version: %d "
-	       "ocd_grant: %d\n", data->ocd_connect_flags,
+	CDEBUG(D_RPCTRACE, "ocd_connect_flags: %#llx ocd_version: %d ocd_grant: %d\n",
+	       data->ocd_connect_flags,
 	       data->ocd_version, data->ocd_grant);
 
 	obd->obd_upcall.onu_owner = &sbi->ll_lco;
@@ -442,10 +435,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	err = obd_connect(NULL, &sbi->ll_dt_exp, obd, &sbi->ll_sb_uuid, data,
 			  NULL);
 	if (err == -EBUSY) {
-		LCONSOLE_ERROR_MSG(0x150, "An OST (dt %s) is performing "
-				   "recovery, of which this client is not a "
-				   "part.  Please wait for recovery to "
-				   "complete, abort, or time out.\n", dt);
+		LCONSOLE_ERROR_MSG(0x150, "An OST (dt %s) is performing recovery, of which this client is not a part.  Please wait for recovery to complete, abort, or time out.\n",
+				   dt);
 		goto out_md;
 	} else if (err) {
 		CERROR("%s: Cannot connect to %s: rc = %d\n",
@@ -458,8 +449,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	err = obd_fid_init(sbi->ll_dt_exp->exp_obd, sbi->ll_dt_exp,
 			   LUSTRE_SEQ_METADATA);
 	if (err) {
-		CERROR("%s: Can't init data layer FID infrastructure, "
-		       "rc = %d\n", sbi->ll_dt_exp->exp_obd->obd_name, err);
+		CERROR("%s: Can't init data layer FID infrastructure, rc = %d\n",
+		       sbi->ll_dt_exp->exp_obd->obd_name, err);
 		goto out_dt;
 	}
 
@@ -699,8 +690,8 @@ void lustre_dump_dentry(struct dentry *dentry, int recur)
 	list_for_each(tmp, &dentry->d_subdirs)
 		subdirs++;
 
-	CERROR("dentry %p dump: name=%.*s parent=%.*s (%p), inode=%p, count=%u,"
-	       " flags=0x%x, fsdata=%p, %d subdirs\n", dentry,
+	CERROR("dentry %p dump: name=%.*s parent=%.*s (%p), inode=%p, count=%u, flags=0x%x, fsdata=%p, %d subdirs\n",
+	       dentry,
 	       dentry->d_name.len, dentry->d_name.name,
 	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
 	       dentry->d_parent, dentry->d_inode, d_count(dentry),
@@ -1023,9 +1014,8 @@ int ll_fill_super(struct super_block *sb, struct vfsmount *mnt)
 	/* Profile set with LCFG_MOUNTOPT so we can find our mdc and osc obds */
 	lprof = class_get_profile(profilenm);
 	if (lprof == NULL) {
-		LCONSOLE_ERROR_MSG(0x156, "The client profile '%s' could not be"
-				   " read from the MGS.  Does that filesystem "
-				   "exist?\n", profilenm);
+		LCONSOLE_ERROR_MSG(0x156, "The client profile '%s' could not be read from the MGS.  Does that filesystem exist?\n",
+				   profilenm);
 		err = -EINVAL;
 		goto out_free;
 	}
@@ -1141,8 +1131,7 @@ struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock)
 		} else {
 			inode = lock->l_resource->lr_lvb_inode;
 			LDLM_DEBUG_LIMIT(inode->i_state & I_FREEING ?  D_INFO :
-					 D_WARNING, lock, "lr_lvb_inode %p is "
-					 "bogus: magic %08x",
+					 D_WARNING, lock, "lr_lvb_inode %p is bogus: magic %08x",
 					 lock->l_resource->lr_lvb_inode,
 					 lli->lli_inode_magic);
 			inode = NULL;
@@ -1763,9 +1752,7 @@ void ll_update_inode(struct inode *inode, struct lustre_md *md)
 				if (lli->lli_flags & (LLIF_DONE_WRITING |
 						      LLIF_EPOCH_PENDING |
 						      LLIF_SOM_DIRTY)) {
-					CERROR("ino %lu flags %u still has "
-					       "size authority! do not trust "
-					       "the size got from MDS\n",
+					CERROR("ino %lu flags %u still has size authority! do not trust the size got from MDS\n",
 					       inode->i_ino, lli->lli_flags);
 				} else {
 					/* Use old size assignment to avoid
@@ -1867,8 +1854,7 @@ void ll_delete_inode(struct inode *inode)
 		spin_lock_irq(&inode->i_data.tree_lock);
 		spin_unlock_irq(&inode->i_data.tree_lock);
 		LASSERTF(inode->i_data.nrpages == 0,
-			 "inode=%lu/%u(%p) nrpages=%lu, see "
-			 "http://jira.whamcloud.com/browse/LU-118\n",
+			 "inode=%lu/%u(%p) nrpages=%lu, see http://jira.whamcloud.com/browse/LU-118\n",
 			 inode->i_ino, inode->i_generation, inode,
 			 inode->i_data.nrpages);
 	}
@@ -2418,8 +2404,8 @@ void ll_dirty_page_discard_warn(struct page *page, int ioret)
 	}
 
 	CDEBUG(D_WARNING,
-	       "%s: dirty page discard: %s/fid: "DFID"/%s may get corrupted "
-	       "(rc %d)\n", ll_get_fsname(page->mapping->host->i_sb, NULL, 0),
+	       "%s: dirty page discard: %s/fid: " DFID "/%s may get corrupted (rc %d)\n",
+	       ll_get_fsname(page->mapping->host->i_sb, NULL, 0),
 	       s2lsi(page->mapping->host->i_sb)->lsi_lmd->lmd_dev,
 	       PFID(&obj->cob_header.coh_lu.loh_fid),
 	       (path && !IS_ERR(path)) ? path : "", ioret);
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index ae605a6..e72b14d 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -234,8 +234,7 @@ static int ll_page_mkwrite0(struct vm_area_struct *vma, struct page *vmpage,
 			 */
 			unlock_page(vmpage);
 
-			CDEBUG(D_MMAP, "Race on page_mkwrite %p/%lu, page has "
-			       "been written out, retry.\n",
+			CDEBUG(D_MMAP, "Race on page_mkwrite %p/%lu, page has been written out, retry.\n",
 			       vmpage, vmpage->index);
 
 			*retry = true;
@@ -366,8 +365,7 @@ restart:
 			vmf->page = NULL;
 
 			if (!printed && ++count > 16) {
-				CWARN("the page is under heavy contention,"
-				      "maybe your app(%s) needs revising :-)\n",
+				CWARN("the page is under heavy contention, maybe your app(%s) needs revising :-)\n",
 				      current->comm);
 				printed = true;
 			}
@@ -393,8 +391,7 @@ static int ll_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		result = ll_page_mkwrite0(vma, vmf->page, &retry);
 
 		if (!printed && ++count > 16) {
-			CWARN("app(%s): the page %lu of file %lu is under heavy"
-			      " contention.\n",
+			CWARN("app(%s): the page %lu of file %lu is under heavy contention.\n",
 			      current->comm, vmf->pgoff,
 			      vma->vm_file->f_dentry->d_inode->i_ino);
 			printed = true;
diff --git a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
index 586f49a..f4da156 100644
--- a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
+++ b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
@@ -131,8 +131,8 @@ int rct_add(struct rmtacl_ctl_table *rct, pid_t key, int ops)
 	spin_lock(&rct->rct_lock);
 	e = __rct_search(rct, key);
 	if (unlikely(e != NULL)) {
-		CWARN("Unexpected stale rmtacl_entry found: "
-		      "[key: %d] [ops: %d]\n", (int)key, ops);
+		CWARN("Unexpected stale rmtacl_entry found: [key: %d] [ops: %d]\n",
+		      (int)key, ops);
 		rce_free(e);
 	}
 	list_add_tail(&rce->rce_list, &rct->rct_entries[rce_hashfunc(key)]);
@@ -263,8 +263,7 @@ int ee_add(struct eacl_table *et, pid_t key, struct lu_fid *fid, int type,
 	spin_lock(&et->et_lock);
 	e = __et_search_del(et, key, fid, type);
 	if (unlikely(e != NULL)) {
-		CWARN("Unexpected stale eacl_entry found: "
-		      "[key: %d] [fid: "DFID"] [type: %d]\n",
+		CWARN("Unexpected stale eacl_entry found: [key: %d] [fid: " DFID "] [type: %d]\n",
 		      (int)key, PFID(fid), type);
 		ee_free(e);
 	}
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index e0f39fe..b6325c0 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -778,8 +778,8 @@ static int __init lloop_init(void)
 
 	if (max_loop < 1 || max_loop > 256) {
 		max_loop = MAX_LOOP_DEFAULT;
-		CWARN("lloop: invalid max_loop (must be between"
-		      " 1 and 256), using default (%u)\n", max_loop);
+		CWARN("lloop: invalid max_loop (must be between 1 and 256), using default (%u)\n",
+		      max_loop);
 	}
 
 	lloop_major = register_blkdev(0, "lloop");
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 4dc1bfa..e6a909e 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -284,8 +284,7 @@ static ssize_t ll_max_readahead_per_file_mb_seq_write(struct file *file,
 
 	if (pages_number < 0 ||
 		pages_number > sbi->ll_ra_info.ra_max_pages) {
-		CERROR("can't set file readahead more than"
-		       "max_read_ahead_mb %lu MB\n",
+		CERROR("can't set file readahead more than max_read_ahead_mb %lu MB\n",
 		       sbi->ll_ra_info.ra_max_pages);
 		return -ERANGE;
 	}
@@ -330,9 +329,8 @@ static ssize_t ll_max_read_ahead_whole_mb_seq_write(struct file *file,
 	 * algorithm does this anyway so it's pointless to set it larger. */
 	if (pages_number < 0 ||
 	    pages_number > sbi->ll_ra_info.ra_max_pages_per_file) {
-		CERROR("can't set max_read_ahead_whole_mb more than "
-		       "max_read_ahead_per_file_mb: %lu\n",
-			sbi->ll_ra_info.ra_max_pages_per_file >> (20 - PAGE_CACHE_SHIFT));
+		CERROR("can't set max_read_ahead_whole_mb more than max_read_ahead_per_file_mb: %lu\n",
+		       sbi->ll_ra_info.ra_max_pages_per_file >> (20 - PAGE_CACHE_SHIFT));
 		return -ERANGE;
 	}
 
@@ -619,8 +617,8 @@ static ssize_t ll_statahead_max_seq_write(struct file *file,
 	if (val >= 0 && val <= LL_SA_RPC_MAX)
 		sbi->ll_sa_max = val;
 	else
-		CERROR("Bad statahead_max value %d. Valid values are in the "
-		       "range [0, %d]\n", val, LL_SA_RPC_MAX);
+		CERROR("Bad statahead_max value %d. Valid values are in the range [0, %d]\n",
+		       val, LL_SA_RPC_MAX);
 
 	return count;
 }
@@ -770,8 +768,8 @@ static int ll_sbi_flags_seq_show(struct seq_file *m, void *v)
 
 	while (flags != 0) {
 		if (ARRAY_SIZE(str) <= i) {
-			CERROR("%s: Revise array LL_SBI_FLAGS to match sbi "
-				"flags please.\n", ll_get_fsname(sb, NULL, 0));
+			CERROR("%s: Revise array LL_SBI_FLAGS to match sbi flags please.\n",
+			       ll_get_fsname(sb, NULL, 0));
 			return -EINVAL;
 		}
 
@@ -1143,8 +1141,8 @@ static void ll_display_extents_info(struct ll_rw_extents_info *io_extents,
 		read_cum += r;
 		write_cum += w;
 		end = 1 << (i + LL_HIST_START - units);
-		seq_printf(seq, "%4lu%c - %4lu%c%c: %14lu %4lu %4lu  | "
-			   "%14lu %4lu %4lu\n", start, *unitp, end, *unitp,
+		seq_printf(seq, "%4lu%c - %4lu%c%c: %14lu %4lu %4lu  | %14lu %4lu %4lu\n",
+			   start, *unitp, end, *unitp,
 			   (i == LL_HIST_MAX - 1) ? '+' : ' ',
 			   r, pct(r, read_tot), pct(read_cum, read_tot),
 			   w, pct(w, write_tot), pct(write_cum, write_tot));
@@ -1170,8 +1168,7 @@ static int ll_rw_extents_stats_pp_seq_show(struct seq_file *seq, void *v)
 
 	if (!sbi->ll_rw_stats_on) {
 		seq_printf(seq, "disabled\n"
-				"write anything in this file to activate, "
-				"then 0 or \"[D/d]isabled\" to deactivate\n");
+			   "write anything in this file to activate, then 0 or \"[D/d]isabled\" to deactivate\n");
 		return 0;
 	}
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
@@ -1249,8 +1246,7 @@ static int ll_rw_extents_stats_seq_show(struct seq_file *seq, void *v)
 
 	if (!sbi->ll_rw_stats_on) {
 		seq_printf(seq, "disabled\n"
-				"write anything in this file to activate, "
-				"then 0 or \"[D/d]isabled\" to deactivate\n");
+			   "write anything in this file to activate, then 0 or \"[D/d]isabled\" to deactivate\n");
 		return 0;
 	}
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
@@ -1428,8 +1424,7 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 
 	if (!sbi->ll_rw_stats_on) {
 		seq_printf(seq, "disabled\n"
-				"write anything in this file to activate, "
-				"then 0 or \"[D/d]isabled\" to deactivate\n");
+			   "write anything in this file to activate, then 0 or \"[D/d]isabled\" to deactivate\n");
 		return 0;
 	}
 	spin_lock(&sbi->ll_process_lock);
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 2971a26..671d0cd 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -104,8 +104,8 @@ static int ll_set_inode(struct inode *inode, void *opaque)
 
 	lli->lli_fid = body->fid1;
 	if (unlikely(!(body->valid & OBD_MD_FLTYPE))) {
-		CERROR("Can not initialize inode "DFID" without object type: "
-		       "valid = %#llx\n", PFID(&lli->lli_fid), body->valid);
+		CERROR("Can not initialize inode " DFID " without object type: valid = %#llx\n",
+		       PFID(&lli->lli_fid), body->valid);
 		return -EINVAL;
 	}
 
@@ -619,8 +619,7 @@ static int ll_atomic_open(struct inode *dir, struct dentry *dentry,
 	long long lookup_flags = LOOKUP_OPEN;
 	int rc = 0;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:name=%.*s,dir=%lu/%u(%p),file %p,"
-			   "open_flags %x,mode %x opened %d\n",
+	CDEBUG(D_VFSTRACE, "VFS Op:name=%.*s,dir=%lu/%u(%p),file %p,open_flags %x,mode %x opened %d\n",
 	       dentry->d_name.len, dentry->d_name.name, dir->i_ino,
 	       dir->i_generation, dir, file, open_flags, mode, *opened);
 
@@ -863,8 +862,7 @@ static int ll_create_nd(struct inode *dir, struct dentry *dentry,
 {
 	int rc;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:name=%.*s,dir=%lu/%u(%p),"
-			   "flags=%u, excl=%d\n",
+	CDEBUG(D_VFSTRACE, "VFS Op:name=%.*s,dir=%lu/%u(%p),flags=%u, excl=%d\n",
 	       dentry->d_name.len, dentry->d_name.name, dir->i_ino,
 	       dir->i_generation, dir, mode, want_excl);
 
@@ -1151,8 +1149,8 @@ static int ll_rename_generic(struct inode *src, struct dentry *src_dparent,
 	int err;
 
 	CDEBUG(D_VFSTRACE,
-	       "VFS Op:oldname=%.*s,src_dir=%lu/%u(%p),newname=%.*s,"
-	       "tgt_dir=%lu/%u(%p)\n", src_name->len, src_name->name,
+	       "VFS Op:oldname=%.*s,src_dir=%lu/%u(%p),newname=%.*s,tgt_dir=%lu/%u(%p)\n",
+	       src_name->len, src_name->name,
 	       src->i_ino, src->i_generation, src, tgt_name->len,
 	       tgt_name->name, tgt->i_ino, tgt->i_generation, tgt);
 
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index 613d772..10a0421 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -121,8 +121,8 @@ static struct ll_cl_context *ll_cl_init(struct file *file,
 			/* this is too bad. Someone is trying to write the
 			 * page w/o holding inode mutex. This means we can
 			 * add dirty pages into cache during truncate */
-			CERROR("Proc %s is dirting page w/o inode lock, this"
-			       "will break truncate.\n", current->comm);
+			CERROR("Proc %s is dirtying page w/o inode lock, this will break truncate\n",
+			       current->comm);
 			dump_stack();
 			LBUG();
 			return ERR_PTR(-EIO);
@@ -606,8 +606,8 @@ stride_pg_count(pgoff_t st_off, unsigned long st_len, unsigned long st_pgs,
 	else
 		pg_count = start_left + st_pgs * (end - start - 1) + end_left;
 
-	CDEBUG(D_READA, "st_off %lu, st_len %lu st_pgs %lu off %lu length %lu"
-	       "pgcount %lu\n", st_off, st_len, st_pgs, off, length, pg_count);
+	CDEBUG(D_READA, "st_off %lu, st_len %lu st_pgs %lu off %lu length %lu pgcount %lu\n",
+	       st_off, st_len, st_pgs, off, length, pg_count);
 
 	return pg_count;
 }
@@ -667,10 +667,10 @@ static int ll_read_ahead_pages(const struct lu_env *env,
 			/* FIXME: This assertion only is valid when it is for
 			 * forward read-ahead, it will be fixed when backward
 			 * read-ahead is implemented */
-			LASSERTF(page_idx > ria->ria_stoff, "Invalid page_idx %lu"
-				"rs %lu re %lu ro %lu rl %lu rp %lu\n", page_idx,
-				ria->ria_start, ria->ria_end, ria->ria_stoff,
-				ria->ria_length, ria->ria_pages);
+			LASSERTF(page_idx > ria->ria_stoff, "Invalid page_idx %lu rs %lu re %lu ro %lu rl %lu rp %lu\n",
+				 page_idx,
+				 ria->ria_start, ria->ria_end, ria->ria_stoff,
+				 ria->ria_length, ria->ria_pages);
 			offset = page_idx - ria->ria_stoff;
 			offset = offset % (ria->ria_length);
 			if (offset > ria->ria_pages) {
@@ -927,8 +927,8 @@ static void ras_stride_increase_window(struct ll_readahead_state *ras,
 
 	LASSERT(ras->ras_stride_length > 0);
 	LASSERTF(ras->ras_window_start + ras->ras_window_len
-		 >= ras->ras_stride_offset, "window_start %lu, window_len %lu"
-		 " stride_offset %lu\n", ras->ras_window_start,
+		 >= ras->ras_stride_offset, "window_start %lu, window_len %lu stride_offset %lu\n",
+		 ras->ras_window_start,
 		 ras->ras_window_len, ras->ras_stride_offset);
 
 	stride_len = ras->ras_window_start + ras->ras_window_len -
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 85d451f..c4bd09e 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -1491,10 +1491,7 @@ ll_sai_unplug(struct ll_statahead_info *sai, struct ll_sa_entry *entry)
 		sai->sai_consecutive_miss++;
 		if (sa_low_hit(sai) && thread_is_running(thread)) {
 			atomic_inc(&sbi->ll_sa_wrong);
-			CDEBUG(D_READA, "Statahead for dir "DFID" hit "
-			       "ratio too low: hit/miss %llu/%llu"
-			       ", sent/replied %llu/%llu, stopping "
-			       "statahead thread\n",
+			CDEBUG(D_READA, "Statahead for dir " DFID " hit ratio too low: hit/miss %llu/%llu, sent/replied %llu/%llu, stopping statahead thread\n",
 			       PFID(&lli->lli_fid), sai->sai_hit,
 			       sai->sai_miss, sai->sai_sent,
 			       sai->sai_replied);
@@ -1612,8 +1609,7 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 				} else if ((*dentryp)->d_inode != inode) {
 					/* revalidate, but inode is recreated */
 					CDEBUG(D_READA,
-					      "stale dentry %.*s inode %lu/%u, "
-					      "statahead inode %lu/%u\n",
+					      "stale dentry %.*s inode %lu/%u, statahead inode %lu/%u\n",
 					      (*dentryp)->d_name.len,
 					      (*dentryp)->d_name.name,
 					      (*dentryp)->d_inode->i_ino,
@@ -1666,8 +1662,7 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 	if (unlikely(sai->sai_inode != parent->d_inode)) {
 		struct ll_inode_info *nlli = ll_i2info(parent->d_inode);
 
-		CWARN("Race condition, someone changed %.*s just now: "
-		      "old parent "DFID", new parent "DFID"\n",
+		CWARN("Race condition, someone changed %.*s just now: old parent " DFID ", new parent " DFID "\n",
 		      (*dentryp)->d_name.len, (*dentryp)->d_name.name,
 		      PFID(&lli->lli_fid), PFID(&nlli->lli_fid));
 		dput(parent);
diff --git a/drivers/staging/lustre/lustre/llite/symlink.c b/drivers/staging/lustre/lustre/llite/symlink.c
index eccd3a7..686b6a5 100644
--- a/drivers/staging/lustre/lustre/llite/symlink.c
+++ b/drivers/staging/lustre/lustre/llite/symlink.c
@@ -100,8 +100,8 @@ static int ll_readlink_internal(struct inode *inode,
 	if (*symname == NULL ||
 	    strnlen(*symname, symlen) != symlen - 1) {
 		/* not full/NULL terminated */
-		CERROR("inode %lu: symlink not NULL terminated string"
-			"of length %d\n", inode->i_ino, symlen - 1);
+		CERROR("inode %lu: symlink not NULL terminated string of length %d\n",
+		       inode->i_ino, symlen - 1);
 		rc = -EPROTO;
 		goto failed;
 	}
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 168aafb..5675ff0 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -720,9 +720,8 @@ static int vvp_io_fault_start(const struct lu_env *env,
 		last_index = cl_index(obj, size - 1);
 		if (last_index < fio->ft_index) {
 			CDEBUG(D_PAGE,
-				"llite: mkwrite and truncate race happened: "
-				"%p: 0x%lx 0x%lx\n",
-				vmpage->mapping, fio->ft_index, last_index);
+			       "llite: mkwrite and truncate race happened: %p: 0x%lx 0x%lx\n",
+			       vmpage->mapping, fio->ft_index, last_index);
 			/*
 			 * We need to return if we are
 			 * passed the end of the file. This will propagate
diff --git a/drivers/staging/lustre/lustre/llite/vvp_page.c b/drivers/staging/lustre/lustre/llite/vvp_page.c
index 4626346..954ed08 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_page.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_page.c
@@ -376,8 +376,7 @@ static int vvp_page_print(const struct lu_env *env,
 	struct ccc_page *vp = cl2ccc_page(slice);
 	struct page      *vmpage = vp->cpg_page;
 
-	(*printer)(env, cookie, LUSTRE_VVP_NAME"-page@%p(%d:%d:%d) "
-		   "vm@%p ",
+	(*printer)(env, cookie, LUSTRE_VVP_NAME "-page@%p(%d:%d:%d) vm@%p ",
 		   vp, vp->cpg_defer_uptodate, vp->cpg_ra_used,
 		   vp->cpg_write_queued, vmpage);
 	if (vmpage != NULL) {
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 3ad9796..56ab3e6 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -201,8 +201,7 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 #endif
 	if (rc) {
 		if (rc == -EOPNOTSUPP && xattr_type == XATTR_USER_T) {
-			LCONSOLE_INFO("Disabling user_xattr feature because "
-				      "it is not supported on the server\n");
+			LCONSOLE_INFO("Disabling user_xattr feature because it is not supported on the server\n");
 			sbi->ll_flags &= ~LL_SBI_USER_XATTR;
 		}
 		return rc;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_fld.c b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
index e8421f0..ee23592 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_fld.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
@@ -75,8 +75,7 @@ int lmv_fld_lookup(struct lmv_obd *lmv,
 	       *mds, PFID(fid));
 
 	if (*mds >= lmv->desc.ld_tgt_count) {
-		CERROR("FLD lookup got invalid mds #%x (max: %x) "
-		       "for fid="DFID"\n", *mds, lmv->desc.ld_tgt_count,
+		CERROR("FLD lookup got invalid mds #%x (max: %x) for fid=" DFID "\n", *mds, lmv->desc.ld_tgt_count,
 		       PFID(fid));
 		rc = -EINVAL;
 	}
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index 5106124..d22d57b 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -186,8 +186,8 @@ int lmv_intent_open(struct obd_export *exp, struct md_op_data *op_data,
 			return rc;
 	}
 
-	CDEBUG(D_INODE, "OPEN_INTENT with fid1="DFID", fid2="DFID","
-	       " name='%s' -> mds #%d\n", PFID(&op_data->op_fid1),
+	CDEBUG(D_INODE, "OPEN_INTENT with fid1=" DFID ", fid2=" DFID ", name='%s' -> mds #%d\n",
+	       PFID(&op_data->op_fid1),
 	       PFID(&op_data->op_fid2), op_data->op_name, tgt->ltd_idx);
 
 	rc = md_intent_lock(tgt->ltd_exp, op_data, lmm, lmmsize, it, flags,
@@ -226,8 +226,8 @@ int lmv_intent_open(struct obd_export *exp, struct md_op_data *op_data,
 		 * this is normal situation, we should not print error here,
 		 * only debug info.
 		 */
-		CDEBUG(D_INODE, "Can't handle remote %s: dir "DFID"("DFID"):"
-		       "%*s: %d\n", LL_IT2STR(it), PFID(&op_data->op_fid2),
+		CDEBUG(D_INODE, "Can't handle remote %s: dir " DFID "(" DFID "):%*s: %d\n",
+		       LL_IT2STR(it), PFID(&op_data->op_fid2),
 		       PFID(&op_data->op_fid1), op_data->op_namelen,
 		       op_data->op_name, rc);
 		return rc;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 9543c15..d129f53 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -325,8 +325,8 @@ static int lmv_init_ea_size(struct obd_export *exp, int easize,
 		rc = md_init_ea_size(lmv->tgts[i]->ltd_exp, easize, def_easize,
 				     cookiesize, def_cookiesize);
 		if (rc) {
-			CERROR("%s: obd_init_ea_size() failed on MDT target %d:"
-			       " rc = %d.\n", obd->obd_name, i, rc);
+			CERROR("%s: obd_init_ea_size() failed on MDT target %d: rc = %d.\n",
+			       obd->obd_name, i, rc);
 			break;
 		}
 	}
@@ -427,8 +427,7 @@ int lmv_connect_mdc(struct obd_device *obd, struct lmv_tgt_desc *tgt)
 						  mdc_obd->obd_type->typ_name,
 						  mdc_obd->obd_name);
 		if (mdc_symlink == NULL) {
-			CERROR("Could not register LMV target "
-			       "/proc/fs/lustre/%s/%s/target_obds/%s.",
+			CERROR("Could not register LMV target /proc/fs/lustre/%s/%s/target_obds/%s.",
 			       obd->obd_type->typ_name, obd->obd_name,
 			       mdc_obd->obd_name);
 			lprocfs_remove(&lmv_proc_dir);
@@ -474,8 +473,8 @@ static int lmv_add_target(struct obd_device *obd, struct obd_uuid *uuidp,
 
 	if ((index < lmv->tgts_size) && (lmv->tgts[index] != NULL)) {
 		tgt = lmv->tgts[index];
-		CERROR("%s: UUID %s already assigned at LOV target index %d:"
-		       " rc = %d\n", obd->obd_name,
+		CERROR("%s: UUID %s already assigned at LOV target index %d: rc = %d\n",
+		       obd->obd_name,
 		       obd_uuid2str(&tgt->ltd_uuid), index, -EEXIST);
 		lmv_init_unlock(lmv);
 		return -EEXIST;
@@ -600,8 +599,7 @@ int lmv_check_connect(struct obd_device *obd)
 			--lmv->desc.ld_active_tgt_count;
 			rc2 = obd_disconnect(tgt->ltd_exp);
 			if (rc2) {
-				CERROR("LMV target %s disconnect on "
-				       "MDC idx %d: error %d\n",
+				CERROR("LMV target %s disconnect on MDC idx %d: error %d\n",
 				       tgt->ltd_uuid.uuid, i, rc2);
 			}
 		}
@@ -865,10 +863,9 @@ static int lmv_hsm_ct_register(struct lmv_obd *lmv, unsigned int cmd, int len,
 		if (err) {
 			if (lmv->tgts[i]->ltd_active) {
 				/* permanent error */
-				CERROR("error: iocontrol MDC %s on MDT"
-				       "idx %d cmd %x: err = %d\n",
-					lmv->tgts[i]->ltd_uuid.uuid,
-					i, cmd, err);
+				CERROR("error: iocontrol MDC %s on MDTidx %d cmd %x: err = %d\n",
+				       lmv->tgts[i]->ltd_uuid.uuid,
+				       i, cmd, err);
 				rc = err;
 				lk->lk_flags |= LK_FLG_STOP;
 				/* unregister from previous MDS */
@@ -1147,10 +1144,9 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 				return err;
 			} else if (err) {
 				if (lmv->tgts[i]->ltd_active) {
-					CERROR("error: iocontrol MDC %s on MDT"
-					       "idx %d cmd %x: err = %d\n",
-						lmv->tgts[i]->ltd_uuid.uuid,
-						i, cmd, err);
+					CERROR("error: iocontrol MDC %s on MDTidx %d cmd %x: err = %d\n",
+					       lmv->tgts[i]->ltd_uuid.uuid,
+					       i, cmd, err);
 					if (!rc)
 						rc = err;
 				}
@@ -1234,8 +1230,8 @@ static int lmv_placement_policy(struct obd_device *obd,
 		if (lum->lum_type == LMV_STRIPE_TYPE &&
 		    lum->lum_stripe_offset != -1) {
 			if (lum->lum_stripe_offset >= lmv->desc.ld_tgt_count) {
-				CERROR("%s: Stripe_offset %d > MDT count %d:"
-				       " rc = %d\n", obd->obd_name,
+				CERROR("%s: Stripe_offset %d > MDT count %d: rc = %d\n",
+				       obd->obd_name,
 				       lum->lum_stripe_offset,
 				       lmv->desc.ld_tgt_count, -ERANGE);
 				return -ERANGE;
@@ -1298,8 +1294,8 @@ int lmv_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 
 	rc = lmv_placement_policy(obd, op_data, &mds);
 	if (rc) {
-		CERROR("Can't get target for allocating fid, "
-		       "rc %d\n", rc);
+		CERROR("Can't get target for allocating fid, rc %d\n",
+		       rc);
 		return rc;
 	}
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index 9e21e5e..e9ec39c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -348,9 +348,8 @@ const struct lsm_operations lsm_v3_ops = {
 
 void dump_lsm(unsigned int level, const struct lov_stripe_md *lsm)
 {
-	CDEBUG(level, "lsm %p, objid "DOSTID", maxbytes %#llx, magic 0x%08X,"
-	       " stripe_size %u, stripe_count %u, refc: %d,"
-	       " layout_gen %u, pool ["LOV_POOLNAMEF"]\n", lsm,
+	CDEBUG(level, "lsm %p, objid " DOSTID ", maxbytes %#llx, magic 0x%08X, stripe_size %u, stripe_count %u, refc: %d, layout_gen %u, pool [" LOV_POOLNAMEF "]\n",
+	       lsm,
 	       POSTID(&lsm->lsm_oi), lsm->lsm_maxbytes, lsm->lsm_magic,
 	       lsm->lsm_stripe_size, lsm->lsm_stripe_count,
 	       atomic_read(&lsm->lsm_refc), lsm->lsm_layout_gen,
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 71ad166..ea503d2 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -168,8 +168,8 @@ int lov_connect_obd(struct obd_device *obd, __u32 index, int activate,
 
 
 	if (imp->imp_invalid) {
-		CDEBUG(D_CONFIG, "not connecting OSC %s; administratively "
-		       "disabled\n", obd_uuid2str(tgt_uuid));
+		CDEBUG(D_CONFIG, "not connecting OSC %s; administratively disabled\n",
+		       obd_uuid2str(tgt_uuid));
 		return 0;
 	}
 
@@ -201,10 +201,9 @@ int lov_connect_obd(struct obd_device *obd, __u32 index, int activate,
 						  osc_obd->obd_type->typ_name,
 						  osc_obd->obd_name);
 		if (osc_symlink == NULL) {
-			CERROR("could not register LOV target "
-				"/proc/fs/lustre/%s/%s/target_obds/%s.",
-				obd->obd_type->typ_name, obd->obd_name,
-				osc_obd->obd_name);
+			CERROR("could not register LOV target /proc/fs/lustre/%s/%s/target_obds/%s.",
+			       obd->obd_type->typ_name, obd->obd_name,
+			       osc_obd->obd_name);
 			lprocfs_remove(&lov_proc_dir);
 			obd->obd_proc_private = NULL;
 		}
@@ -726,8 +725,7 @@ void lov_fix_desc_stripe_size(__u64 *val)
 {
 	if (*val < LOV_MIN_STRIPE_SIZE) {
 		if (*val != 0)
-			LCONSOLE_INFO("Increasing default stripe size to "
-				      "minimum %u\n",
+			LCONSOLE_INFO("Increasing default stripe size to minimum %u\n",
 				      LOV_DESC_STRIPE_SIZE_DEFAULT);
 		*val = LOV_DESC_STRIPE_SIZE_DEFAULT;
 	} else if (*val & (LOV_MIN_STRIPE_SIZE - 1)) {
@@ -899,8 +897,7 @@ static int lov_cleanup(struct obd_device *obd)
 			    /* We should never get here - these
 			       should have been removed in the
 			     disconnect. */
-				CERROR("lov tgt %d not cleaned!"
-				       " deathrow=%d, lovrc=%d\n",
+				CERROR("lov tgt %d not cleaned! deathrow=%d, lovrc=%d\n",
 				       i, lov->lov_death_row,
 				       atomic_read(&lov->lov_refcount));
 			lov_del_target(obd, i, NULL, 0);
@@ -1175,8 +1172,8 @@ static int lov_getattr_async(struct obd_export *exp, struct obd_info *oinfo,
 	list_for_each(pos, &lovset->set_list) {
 		req = list_entry(pos, struct lov_request, rq_link);
 
-		CDEBUG(D_INFO, "objid "DOSTID"[%d] has subobj "DOSTID" at idx"
-		       "%u\n", POSTID(&oinfo->oi_oa->o_oi), req->rq_stripe,
+		CDEBUG(D_INFO, "objid " DOSTID "[%d] has subobj " DOSTID " at idx%u\n",
+		       POSTID(&oinfo->oi_oa->o_oi), req->rq_stripe,
 		       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx);
 		rc = obd_getattr_async(lov->lov_tgts[req->rq_idx]->ltd_exp,
 				       &req->rq_oi, rqset);
@@ -1255,8 +1252,8 @@ static int lov_setattr_async(struct obd_export *exp, struct obd_info *oinfo,
 		if (oinfo->oi_oa->o_valid & OBD_MD_FLCOOKIE)
 			oti->oti_logcookies = set->set_cookies + req->rq_stripe;
 
-		CDEBUG(D_INFO, "objid "DOSTID"[%d] has subobj "DOSTID" at idx"
-		       "%u\n", POSTID(&oinfo->oi_oa->o_oi), req->rq_stripe,
+		CDEBUG(D_INFO, "objid " DOSTID "[%d] has subobj " DOSTID " at idx%u\n",
+		       POSTID(&oinfo->oi_oa->o_oi), req->rq_stripe,
 		       POSTID(&req->rq_oi.oi_oa->o_oi), req->rq_idx);
 
 		rc = obd_setattr_async(lov->lov_tgts[req->rq_idx]->ltd_exp,
@@ -1567,8 +1564,7 @@ static int lov_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 				if (lov->lov_tgts[i]->ltd_active) {
 					CDEBUG(err == -ENOTTY ?
 					       D_IOCTL : D_WARNING,
-					       "iocontrol OSC %s on OST "
-					       "idx %d cmd %x: err = %d\n",
+					       "iocontrol OSC %s on OST idx %d cmd %x: err = %d\n",
 					       lov_uuid2str(lov, i),
 					       i, cmd, err);
 					if (!rc)
@@ -2265,8 +2261,8 @@ static int lov_quotacheck(struct obd_device *obd, struct obd_export *exp,
 
 		/* Skip quota check on the administratively disabled OSTs. */
 		if (!lov->lov_tgts[i]->ltd_activate) {
-			CWARN("lov idx %d was administratively disabled, "
-			      "skip quotacheck on it.\n", i);
+			CWARN("lov idx %d was administratively disabled, skip quotacheck on it.\n",
+			      i);
 			continue;
 		}
 
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index bbef5c9..60d2b0f 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -734,8 +734,7 @@ static int mgc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 		rc = PTR_ERR(kthread_run(mgc_requeue_thread, NULL,
 					     "ll_cfg_requeue"));
 		if (IS_ERR_VALUE(rc)) {
-			CERROR("%s: Cannot start requeue thread (%d),"
-			       "no more log updates!\n",
+			CERROR("%s: Cannot start requeue thread (%d),no more log updates!\n",
 			       obd->obd_name, rc);
 			goto err_cleanup;
 		}
@@ -1019,8 +1018,7 @@ int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
 
 			sptlrpc_flavor2name(&cli->cl_flvr_mgc,
 					    str, sizeof(str));
-			LCONSOLE_ERROR("asking sptlrpc flavor %s to MGS but "
-				       "currently %s is in use\n",
+			LCONSOLE_ERROR("asking sptlrpc flavor %s to MGS but currently %s is in use\n",
 				       (char *) val, str);
 			rc = -EPERM;
 		}
diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index 8d80ea4..d206b10 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -272,8 +272,7 @@ int capa_hmac(__u8 *hmac, struct lustre_capa *capa, __u8 *key)
 
 	tfm = crypto_alloc_hash(alg->ha_name, 0, 0);
 	if (IS_ERR(tfm)) {
-		CERROR("crypto_alloc_tfm failed, check whether your kernel"
-		       "has crypto support!\n");
+		CERROR("crypto_alloc_tfm failed, check whether your kernel has crypto support!\n");
 		return PTR_ERR(tfm);
 	}
 	keylen = alg->ha_keylen;
@@ -412,9 +411,8 @@ void _debug_capa(struct lustre_capa *c,
 	va_list args;
 	va_start(args, fmt);
 	libcfs_debug_vmsg2(msgdata, fmt, args,
-			   " capability@%p fid "DFID" opc %#llx uid %llu"
-			   " gid %llu flags %u alg %d keyid %u timeout %u "
-			   "expiry %u\n", c, PFID(capa_fid(c)), capa_opc(c),
+			   " capability@%p fid " DFID " opc %#llx uid %llu gid %llu flags %u alg %d keyid %u timeout %u expiry %u\n",
+			   c, PFID(capa_fid(c)), capa_opc(c),
 			   capa_uid(c), capa_gid(c), capa_flags(c),
 			   capa_alg(c), capa_keyid(c), capa_timeout(c),
 			   capa_expiry(c));
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index f2383a4..3141b60 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -1622,8 +1622,7 @@ int cl_sync_io_wait(const struct lu_env *env, struct cl_io *io,
 			  atomic_read(&anchor->csi_sync_nr) == 0,
 			  &lwi);
 	if (rc < 0) {
-		CERROR("SYNC IO failed with error: %d, try to cancel "
-		       "%d remaining pages\n",
+		CERROR("SYNC IO failed with error: %d, try to cancel %d remaining pages\n",
 		       rc, atomic_read(&anchor->csi_sync_nr));
 
 		(void)cl_io_cancel(env, io, queue);
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index b204531..b081167 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -129,8 +129,7 @@ static void cl_lock_trace0(int level, const struct lu_env *env,
 			   const char *func, const int line)
 {
 	struct cl_object_header *h = cl_object_header(lock->cll_descr.cld_obj);
-	CDEBUG(level, "%s: %p@(%d %p %d %d %d %d %d %lx)"
-		      "(%p/%d/%d) at %s():%d\n",
+	CDEBUG(level, "%s: %p@(%d %p %d %d %d %d %d %lx)(%p/%d/%d) at %s():%d\n",
 	       prefix, lock, atomic_read(&lock->cll_ref),
 	       lock->cll_guarder, lock->cll_depth,
 	       lock->cll_state, lock->cll_error, lock->cll_holds,
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 7265ecb..89a3fb2 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -144,13 +144,11 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 		CERROR("%s%salloc of %s (%llu bytes) failed at %s:%d\n",
 		       ptr ? "force " :"", type, name, (__u64)size, file,
 		       line);
-		CERROR("%llu total bytes and %llu total pages "
-		       "(%llu bytes) allocated by Lustre, "
-		       "%d total bytes by LNET\n",
+		CERROR("%llu total bytes and %llu total pages (%llu bytes) allocated by Lustre, %d total bytes by LNET\n",
 		       obd_memory_sum(),
 		       obd_pages_sum() << PAGE_CACHE_SHIFT,
 		       obd_pages_sum(),
-			atomic_read(&libcfs_kmemory));
+		       atomic_read(&libcfs_kmemory));
 		return 1;
 	}
 	return 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index ac8db2f..736ca41 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -1087,8 +1087,7 @@ void __class_export_del_lock_ref(struct obd_export *exp, struct ldlm_lock *lock)
 	spin_lock(&exp->exp_locks_list_guard);
 	LASSERT(lock->l_exp_refs_nr > 0);
 	if (lock->l_exp_refs_target != exp) {
-		LCONSOLE_WARN("lock %p, "
-			      "mismatching export pointers: %p, %p\n",
+		LCONSOLE_WARN("lock %p, mismatching export pointers: %p, %p\n",
 			      lock, lock->l_exp_refs_target, exp);
 	}
 	if (-- lock->l_exp_refs_nr == 0) {
@@ -1259,8 +1258,7 @@ static void class_disconnect_export_list(struct list_head *list,
 		}
 
 		class_export_get(exp);
-		CDEBUG(D_HA, "%s: disconnecting export at %s (%p), "
-		       "last request at "CFS_TIME_T"\n",
+		CDEBUG(D_HA, "%s: disconnecting export at %s (%p), last request at " CFS_TIME_T "\n",
 		       exp->exp_obd->obd_name, obd_export_nid2str(exp),
 		       exp, exp->exp_last_request_time);
 		/* release one export reference anyway */
@@ -1284,8 +1282,8 @@ void class_disconnect_exports(struct obd_device *obd)
 	spin_unlock(&obd->obd_dev_lock);
 
 	if (!list_empty(&work_list)) {
-		CDEBUG(D_HA, "OBD device %d (%p) has exports, "
-		       "disconnecting them\n", obd->obd_minor, obd);
+		CDEBUG(D_HA, "OBD device %d (%p) has exports, disconnecting them\n",
+		       obd->obd_minor, obd);
 		class_disconnect_export_list(&work_list,
 					     exp_flags_from_obd(obd));
 	} else
@@ -1422,8 +1420,8 @@ int obd_export_evict_by_nid(struct obd_device *obd, const char *nid)
 		LASSERTF(doomed_exp != obd->obd_self_export,
 			 "self-export is hashed by NID?\n");
 		exports_evicted++;
-		LCONSOLE_WARN("%s: evicting %s (at %s) by administrative "
-			      "request\n", obd->obd_name,
+		LCONSOLE_WARN("%s: evicting %s (at %s) by administrative request\n",
+			      obd->obd_name,
 			      obd_uuid2str(&doomed_exp->exp_client_uuid),
 			      obd_export_nid2str(doomed_exp));
 		class_fail_export(doomed_exp);
@@ -1546,9 +1544,7 @@ void obd_exports_barrier(struct obd_device *obd)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(cfs_time_seconds(waited));
 		if (waited > 5 && IS_PO2(waited)) {
-			LCONSOLE_WARN("%s is waiting for obd_unlinked_exports "
-				      "more than %d seconds. "
-				      "The obd refcount = %d. Is it stuck?\n",
+			LCONSOLE_WARN("%s is waiting for obd_unlinked_exports more than %d seconds. The obd refcount = %d. Is it stuck?\n",
 				      obd->obd_name, waited,
 				      atomic_read(&obd->obd_refcount));
 			dump_exports(obd, 1);
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index 38a9b31..dd46e73 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -202,9 +202,8 @@ static int proc_max_dirty_pages_in_mb(struct ctl_table *table, int write,
 		/* Don't allow them to let dirty pages exceed 90% of system
 		 * memory and set a hard minimum of 4MB. */
 		if (obd_max_dirty_pages > ((totalram_pages / 10) * 9)) {
-			CERROR("Refusing to set max dirty pages to %u, which "
-			       "is more than 90%% of available RAM; setting "
-			       "to %lu\n", obd_max_dirty_pages,
+			CERROR("Refusing to set max dirty pages to %u, which is more than 90%% of available RAM; setting to %lu\n",
+			       obd_max_dirty_pages,
 			       ((totalram_pages / 10) * 9));
 			obd_max_dirty_pages = ((totalram_pages / 10) * 9);
 		} else if (obd_max_dirty_pages < 4 << (20 - PAGE_CACHE_SHIFT)) {
diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index 3ab0529..114be4a 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -346,8 +346,8 @@ repeat:
 			}
 			if (rec->lrh_len == 0 ||
 			    rec->lrh_len > LLOG_CHUNK_SIZE) {
-				CWARN("invalid length %d in llog record for "
-				      "index %d/%d\n", rec->lrh_len,
+				CWARN("invalid length %d in llog record for index %d/%d\n",
+				      rec->lrh_len,
 				      rec->lrh_index, index);
 				rc = -EINVAL;
 				goto out;
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_cat.c b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
index 6e139cf..4b850fc 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_cat.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
@@ -228,8 +228,7 @@ int llog_cat_close(const struct lu_env *env, struct llog_handle *cathandle)
 		    (llh->llh_count == 1)) {
 			rc = llog_destroy(env, loghandle);
 			if (rc)
-				CERROR("%s: failure destroying log during "
-				       "cleanup: rc = %d\n",
+				CERROR("%s: failure destroying log during cleanup: rc = %d\n",
 				       loghandle->lgh_ctxt->loc_obd->obd_name,
 				       rc);
 
@@ -746,8 +745,7 @@ int llog_cat_cleanup(const struct lu_env *env, struct llog_handle *cathandle,
 	llog_cat_set_first_idx(cathandle, index);
 	rc = llog_cancel_rec(env, cathandle, index);
 	if (rc == 0)
-		CDEBUG(D_HA, "cancel plain log at index"
-		       " %u of catalog "DOSTID"\n",
+		CDEBUG(D_HA, "cancel plain log at index %u of catalog " DOSTID "\n",
 		       index, POSTID(&cathandle->lgh_id.lgl_oi));
 	return rc;
 }
@@ -810,8 +808,8 @@ int llog_cat_init_and_process(const struct lu_env *env,
 
 	rc = llog_process_or_fork(env, llh, cat_cancel_cb, NULL, NULL, false);
 	if (rc)
-		CERROR("%s: llog_process() with cat_cancel_cb failed: rc = "
-		       "%d\n", llh->lgh_ctxt->loc_obd->obd_name, rc);
+		CERROR("%s: llog_process() with cat_cancel_cb failed: rc = %d\n",
+		       llh->lgh_ctxt->loc_obd->obd_name, rc);
 	return 0;
 }
 EXPORT_SYMBOL(llog_cat_init_and_process);
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_swab.c b/drivers/staging/lustre/lustre/obdclass/llog_swab.c
index bfac838..d3ec90e 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_swab.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_swab.c
@@ -400,8 +400,7 @@ void lustre_swab_cfg_marker(struct cfg_marker *marker, int swab, int size)
 		}
 		marker->cm_createtime = createtime;
 		marker->cm_canceltime = canceltime;
-		CDEBUG(D_CONFIG, "Find old cfg_marker(Srv32b,Clt64b) "
-		       "for target %s, converting\n",
+		CDEBUG(D_CONFIG, "Find old cfg_marker(Srv32b,Clt64b) for target %s, converting\n",
 		       marker->cm_tgtname);
 	} else if (swab) {
 		__swab64s(&marker->cm_createtime);
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 686bc18..3b7dfc3 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1400,8 +1400,8 @@ int lprocfs_alloc_obd_stats(struct obd_device *obd, unsigned num_private_stats)
 		 * LPROCFS_OBD_OP_INIT(.., .., opname)
 		 * is missing from the list above. */
 		LASSERTF(stats->ls_cnt_header[i].lc_name != NULL,
-			 "Missing obd_stat initializer obd_op "
-			 "operation at offset %d.\n", i - num_private_stats);
+			 "Missing obd_stat initializer obd_op operation at offset %d.\n",
+			 i - num_private_stats);
 	}
 	rc = lprocfs_register_stats(obd->obd_proc_entry, "stats", stats);
 	if (rc < 0) {
@@ -1486,8 +1486,7 @@ int lprocfs_alloc_md_stats(struct obd_device *obd,
 
 	for (i = num_private_stats; i < num_stats; i++) {
 		if (stats->ls_cnt_header[i].lc_name == NULL) {
-			CERROR("Missing md_stat initializer md_op "
-			       "operation at offset %d. Aborting.\n",
+			CERROR("Missing md_stat initializer md_op operation at offset %d. Aborting.\n",
 			       i - num_private_stats);
 			LBUG();
 		}
@@ -1607,8 +1606,7 @@ LPROC_SEQ_FOPS_RO(lproc_exp_hash);
 int lprocfs_nid_stats_clear_read(struct seq_file *m, void *data)
 {
 	return seq_printf(m, "%s\n",
-			"Write into this file to clear all nid stats and "
-			"stale nid entries");
+			  "Write into this file to clear all nid stats and stale nid entries");
 }
 EXPORT_SYMBOL(lprocfs_nid_stats_clear_read);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 2fc037c..83bf168 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -866,8 +866,7 @@ static int lu_htable_order(void)
 
 	/* clear off unreasonable cache setting. */
 	if (lu_cache_percent == 0 || lu_cache_percent > LU_CACHE_PERCENT_MAX) {
-		CWARN("obdclass: invalid lu_cache_percent: %u, it must be in"
-		      " the range of (0, %u]. Will use default value: %u.\n",
+		CWARN("obdclass: invalid lu_cache_percent: %u, it must be in the range of (0, %u]. Will use default value: %u.\n",
 		      lu_cache_percent, LU_CACHE_PERCENT_MAX,
 		      LU_CACHE_PERCENT_DEFAULT);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 47213a9..6ce9adc 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1443,8 +1443,7 @@ int class_config_llog_handler(const struct lu_env *env,
 		if (!(clli->cfg_flags & CFG_F_COMPAT146) &&
 		    !(clli->cfg_flags & CFG_F_MARKER) &&
 		    (lcfg->lcfg_command != LCFG_MARKER)) {
-			CWARN("Config not inside markers, ignoring! "
-			      "(inst: %p, uuid: %s, flags: %#x)\n",
+			CWARN("Config not inside markers, ignoring! (inst: %p, uuid: %s, flags: %#x)\n",
 			      clli->cfg_instance,
 			      clli->cfg_uuid.uuid, clli->cfg_flags);
 			clli->cfg_flags |= CFG_F_SKIP;
@@ -1467,14 +1466,12 @@ int class_config_llog_handler(const struct lu_env *env,
 
 			if ((lcfg->lcfg_command == LCFG_ATTACH && typename &&
 			     strcmp(typename, "mds") == 0)) {
-				CWARN("For 1.8 interoperability, rename obd "
-				       "type from mds to mdt\n");
+				CWARN("For 1.8 interoperability, rename obd type from mds to mdt\n");
 				typename[2] = 't';
 			}
 			if ((lcfg->lcfg_command == LCFG_SETUP && index &&
 			     strcmp(index, "type") == 0)) {
-				CDEBUG(D_INFO, "For 1.8 interoperability, "
-				       "set this index to '0'\n");
+				CDEBUG(D_INFO, "For 1.8 interoperability, set this index to '0'\n");
 				index[0] = '0';
 				index[1] = 0;
 			}
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 1260c87..4f39cdee 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -100,19 +100,12 @@ int lustre_process_log(struct super_block *sb, char *logname,
 	OBD_FREE_PTR(bufs);
 
 	if (rc == -EINVAL)
-		LCONSOLE_ERROR_MSG(0x15b, "%s: The configuration from log '%s'"
-				   "failed from the MGS (%d).  Make sure this "
-				   "client and the MGS are running compatible "
-				   "versions of Lustre.\n",
+		LCONSOLE_ERROR_MSG(0x15b, "%s: The configuration from log '%s' failed from the MGS (%d).  Make sure this client and the MGS are running compatible versions of Lustre.\n",
 				   mgc->obd_name, logname, rc);
 
 	if (rc)
-		LCONSOLE_ERROR_MSG(0x15c, "%s: The configuration from log '%s' "
-				   "failed (%d). This may be the result of "
-				   "communication errors between this node and "
-				   "the MGS, a bad configuration, or other "
-				   "errors. See the syslog for more "
-				   "information.\n", mgc->obd_name, logname,
+		LCONSOLE_ERROR_MSG(0x15c, "%s: The configuration from log '%s' failed (%d). This may be the result of communication errors between this node and the MGS, a bad configuration, or other errors. See the syslog for more information.\n",
+				   mgc->obd_name, logname,
 				   rc);
 
 	/* class_obd_list(); */
@@ -297,11 +290,8 @@ int lustre_start_mgc(struct super_block *sb)
 			if (has_ir ^ !(*flags & LMD_FLG_NOIR)) {
 				/* LMD_FLG_NOIR is for test purpose only */
 				LCONSOLE_WARN(
-				    "Trying to mount a client with IR setting "
-				    "not compatible with current mgc. "
-				    "Force to use current mgc setting that is "
-				    "IR %s.\n",
-				    has_ir ? "enabled" : "disabled");
+					"Trying to mount a client with IR setting not compatible with current mgc. Force to use current mgc setting that is IR %s.\n",
+					has_ir ? "enabled" : "disabled");
 				if (has_ir)
 					*flags &= ~LMD_FLG_NOIR;
 				else
@@ -998,16 +988,14 @@ static int lmd_parse(char *options, struct lustre_mount_data *lmd)
 
 	LASSERT(lmd);
 	if (!options) {
-		LCONSOLE_ERROR_MSG(0x162, "Missing mount data: check that "
-				   "/sbin/mount.lustre is installed.\n");
+		LCONSOLE_ERROR_MSG(0x162, "Missing mount data: check that /sbin/mount.lustre is installed.\n");
 		return -EINVAL;
 	}
 
 	/* Options should be a string - try to detect old lmd data */
 	if ((raw->lmd_magic & 0xffffff00) == (LMD_MAGIC & 0xffffff00)) {
-		LCONSOLE_ERROR_MSG(0x163, "You're using an old version of "
-				   "/sbin/mount.lustre.  Please install "
-				   "version %s\n", LUSTRE_VERSION_STRING);
+		LCONSOLE_ERROR_MSG(0x163, "You're using an old version of /sbin/mount.lustre.  Please install version %s\n",
+				   LUSTRE_VERSION_STRING);
 		return -EINVAL;
 	}
 	lmd->lmd_magic = LMD_MAGIC;
@@ -1139,8 +1127,7 @@ static int lmd_parse(char *options, struct lustre_mount_data *lmd)
 	}
 
 	if (!devname) {
-		LCONSOLE_ERROR_MSG(0x164, "Can't find the device name "
-				   "(need mount option 'device=...')\n");
+		LCONSOLE_ERROR_MSG(0x164, "Can't find the device name (need mount option 'device=...')\n");
 		goto invalid;
 	}
 
@@ -1232,9 +1219,7 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 		if (client_fill_super == NULL)
 			request_module("lustre");
 		if (client_fill_super == NULL) {
-			LCONSOLE_ERROR_MSG(0x165, "Nothing registered for "
-					   "client mount! Is the 'lustre' "
-					   "module loaded?\n");
+			LCONSOLE_ERROR_MSG(0x165, "Nothing registered for client mount! Is the 'lustre' module loaded?\n");
 			lustre_put_lsi(sb);
 			rc = -ENODEV;
 		} else {
@@ -1249,8 +1234,7 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 			/* c_f_s will call lustre_common_put_super on failure */
 		}
 	} else {
-		CERROR("This is client-side-only module, "
-		       "cannot handle server mount.\n");
+		CERROR("This is client-side-only module, cannot handle server mount.\n");
 		rc = -EINVAL;
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index a6ad875..5f6d944 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -871,8 +871,7 @@ static struct lu_device *echo_device_free(const struct lu_env *env,
 	spin_lock(&ec->ec_lock);
 	while (!list_empty(&ec->ec_objects)) {
 		spin_unlock(&ec->ec_lock);
-		CERROR("echo_client still has objects at cleanup time, "
-		       "wait for 1 second\n");
+		CERROR("echo_client still has objects at cleanup time, wait for 1 second\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(cfs_time_seconds(1));
 		lu_site_purge(env, &ed->ed_site->cs_lu, -1);
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index ec04935..31d4a1f 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1560,8 +1560,8 @@ void osc_wake_cache_waiters(struct client_obd *cli)
 		if ((cli->cl_dirty + PAGE_CACHE_SIZE > cli->cl_dirty_max) ||
 		    (atomic_read(&obd_dirty_pages) + 1 >
 		     obd_max_dirty_pages)) {
-			CDEBUG(D_CACHE, "no dirty room: dirty: %ld "
-			       "osc max %ld, sys max %d\n", cli->cl_dirty,
+			CDEBUG(D_CACHE, "no dirty room: dirty: %ld osc max %ld, sys max %d\n",
+			       cli->cl_dirty,
 			       cli->cl_dirty_max, obd_max_dirty_pages);
 			goto wakeup;
 		}
diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index 8138856..a7f08bc 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -1067,14 +1067,12 @@ static int osc_lock_enqueue_wait(const struct lu_env *env,
 			 * conflicts, we do not wait but return 0 so the
 			 * request is send to the server
 			 */
-			CDEBUG(D_DLMTRACE, "group lock %p is conflicted "
-					   "with %p, no wait, send to server\n",
+			CDEBUG(D_DLMTRACE, "group lock %p is conflicted with %p, no wait, send to server\n",
 			       lock, conflict);
 			cl_lock_put(env, conflict);
 			rc = 0;
 		} else {
-			CDEBUG(D_DLMTRACE, "lock %p is conflicted with %p, "
-					   "will wait\n",
+			CDEBUG(D_DLMTRACE, "lock %p is conflicted with %p, will wait\n",
 			       lock, conflict);
 			LASSERT(lock->cll_conflict == NULL);
 			lu_ref_add(&conflict->cll_reference, "cancel-wait",
diff --git a/drivers/staging/lustre/lustre/osc/osc_object.c b/drivers/staging/lustre/lustre/osc/osc_object.c
index 6900058..92c202f 100644
--- a/drivers/staging/lustre/lustre/osc/osc_object.c
+++ b/drivers/staging/lustre/lustre/osc/osc_object.c
@@ -140,8 +140,7 @@ static int osc_object_print(const struct lu_env *env, void *cookie,
 	struct lov_oinfo    *oinfo = osc->oo_oinfo;
 	struct osc_async_rc *ar    = &oinfo->loi_ar;
 
-	(*p)(env, cookie, "id: "DOSTID" "
-	     "idx: %d gen: %d kms_valid: %u kms %llu rc: %d force_sync: %d min_xid: %llu ",
+	(*p)(env, cookie, "id: " DOSTID " idx: %d gen: %d kms_valid: %u kms %llu rc: %d force_sync: %d min_xid: %llu ",
 	     POSTID(&oinfo->loi_oi), oinfo->loi_ost_idx,
 	     oinfo->loi_ost_gen, oinfo->loi_kms_valid, oinfo->loi_kms,
 	     ar->ar_rc, ar->ar_force_sync, ar->ar_min_xid);
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index fcd079b..76ba58b 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -369,12 +369,7 @@ static int osc_page_print(const struct lu_env *env,
 	struct osc_object     *obj = cl2osc(slice->cpl_obj);
 	struct client_obd     *cli = &osc_export(obj)->exp_obd->u.cli;
 
-	return (*printer)(env, cookie, LUSTRE_OSC_NAME"-page@%p: "
-			  "1< %#x %d %u %s %s > "
-			  "2< %llu %u %u %#x %#x | %p %p %p > "
-			  "3< %s %p %d %lu %d > "
-			  "4< %d %d %d %lu %s | %s %s %s %s > "
-			  "5< %s %s %s %s | %d %s | %d %s %s>\n",
+	return (*printer)(env, cookie, LUSTRE_OSC_NAME "-page@%p: 1< %#x %d %u %s %s > 2< %llu %u %u %#x %#x | %p %p %p > 3< %s %p %d %lu %d > 4< %d %d %d %lu %s | %s %s %s %s > 5< %s %s %s %s | %d %s | %d %s %s>\n",
 			  opg,
 			  /* 1 */
 			  oap->oap_magic, oap->oap_cmd,
@@ -550,8 +545,8 @@ void osc_page_submit(const struct lu_env *env, struct osc_page *opg,
 	LINVRNT(osc_page_protected(env, opg,
 				   crt == CRT_WRITE ? CLM_WRITE : CLM_READ, 1));
 
-	LASSERTF(oap->oap_magic == OAP_MAGIC, "Bad oap magic: oap %p, "
-		 "magic 0x%x\n", oap, oap->oap_magic);
+	LASSERTF(oap->oap_magic == OAP_MAGIC, "Bad oap magic: oap %p, magic 0x%x\n",
+		 oap, oap->oap_magic);
 	LASSERT(oap->oap_async_flags & ASYNC_READY);
 	LASSERT(oap->oap_async_flags & ASYNC_COUNT_STABLE);
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index ca16c08..b9450b9 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -1078,9 +1078,9 @@ static void osc_init_grant(struct client_obd *cli, struct obd_connect_data *ocd)
 	cli->cl_chunkbits = max_t(int, PAGE_CACHE_SHIFT, ocd->ocd_blocksize);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 
-	CDEBUG(D_CACHE, "%s, setting cl_avail_grant: %ld cl_lost_grant: %ld."
-		"chunk bits: %d.\n", cli->cl_import->imp_obd->obd_name,
-		cli->cl_avail_grant, cli->cl_lost_grant, cli->cl_chunkbits);
+	CDEBUG(D_CACHE, "%s, setting cl_avail_grant: %ld cl_lost_grant: %ld chunk bits: %d\n",
+	       cli->cl_import->imp_obd->obd_name,
+	       cli->cl_avail_grant, cli->cl_lost_grant, cli->cl_chunkbits);
 
 	if (ocd->ocd_connect_flags & OBD_CONNECT_GRANT_SHRINK &&
 	    list_empty(&cli->cl_grant_shrink_list))
@@ -1171,8 +1171,7 @@ static inline int can_merge_pages(struct brw_page *p1, struct brw_page *p2)
 		/* warn if we try to combine flags that we don't know to be
 		 * safe to combine */
 		if (unlikely((p1->flag & mask) != (p2->flag & mask))) {
-			CWARN("Saw flags 0x%x and 0x%x in the same brw, please "
-			      "report this at http://bugs.whamcloud.com/\n",
+			CWARN("Saw flags 0x%x and 0x%x in the same brw, please report this at http://bugs.whamcloud.com/\n",
 			      p1->flag, p2->flag);
 		}
 		return 0;
@@ -1343,8 +1342,7 @@ static int osc_brw_prep_request(int cmd, struct client_obd *cli,
 			 "i: %d/%d pg: %p off: %llu, count: %u\n",
 			 i, page_count, pg, pg->off, pg->count);
 		LASSERTF(i == 0 || pg->off > pg_prev->off,
-			 "i %d p_c %u pg %p [pri %lu ind %lu] off %llu"
-			 " prev_pg %p [pri %lu ind %lu] off %llu\n",
+			 "i %d p_c %u pg %p [pri %lu ind %lu] off %llu prev_pg %p [pri %lu ind %lu] off %llu\n",
 			 i, page_count,
 			 pg->pg, page_private(pg->pg), pg->pg->index, pg->off,
 			 pg_prev->pg, page_private(pg_prev->pg),
@@ -1467,16 +1465,16 @@ static int check_write_checksum(struct obdo *oa, const lnet_process_id_t *peer,
 				      cksum_type);
 
 	if (cksum_type != client_cksum_type)
-		msg = "the server did not use the checksum type specified in "
-		      "the original request - likely a protocol problem";
+		msg = "the server did not use the checksum type specified in the original request - likely a protocol problem"
+			;
 	else if (new_cksum == server_cksum)
-		msg = "changed on the client after we checksummed it - "
-		      "likely false positive due to mmap IO (bug 11742)";
+		msg = "changed on the client after we checksummed it - likely false positive due to mmap IO (bug 11742)"
+			;
 	else if (new_cksum == client_cksum)
 		msg = "changed in transit before arrival at OST";
 	else
-		msg = "changed in transit AND doesn't match the original - "
-		      "likely false positive due to mmap IO (bug 11742)";
+		msg = "changed in transit AND doesn't match the original - likely false positive due to mmap IO (bug 11742)"
+			;
 
 	LCONSOLE_ERROR_MSG(0x132, "BAD WRITE CHECKSUM: %s: from %s inode "DFID
 			   " object "DOSTID" extent [%llu-%llu]\n",
@@ -1486,8 +1484,8 @@ static int check_write_checksum(struct obdo *oa, const lnet_process_id_t *peer,
 			   oa->o_valid & OBD_MD_FLFID ? oa->o_parent_ver : 0,
 			   POSTID(&oa->o_oi), pga[0]->off,
 			   pga[page_count-1]->off + pga[page_count-1]->count - 1);
-	CERROR("original client csum %x (type %x), server csum %x (type %x), "
-	       "client csum now %x\n", client_cksum, client_cksum_type,
+	CERROR("original client csum %x (type %x), server csum %x (type %x), client csum now %x\n",
+	       client_cksum, client_cksum_type,
 	       server_cksum, cksum_type, new_cksum);
 	return 1;
 }
@@ -1601,23 +1599,21 @@ static int osc_brw_fini_request(struct ptlrpc_request *req, int rc)
 		}
 
 		if (server_cksum != client_cksum) {
-			LCONSOLE_ERROR_MSG(0x133, "%s: BAD READ CHECKSUM: from "
-					   "%s%s%s inode "DFID" object "DOSTID
-					   " extent [%llu-%llu]\n",
+			LCONSOLE_ERROR_MSG(0x133, "%s: BAD READ CHECKSUM: from %s%s%s inode " DFID " object " DOSTID " extent [%llu-%llu]\n",
 					   req->rq_import->imp_obd->obd_name,
 					   libcfs_nid2str(peer->nid),
 					   via, router,
 					   body->oa.o_valid & OBD_MD_FLFID ?
-						body->oa.o_parent_seq : (__u64)0,
+					   body->oa.o_parent_seq : (__u64)0,
 					   body->oa.o_valid & OBD_MD_FLFID ?
-						body->oa.o_parent_oid : 0,
+					   body->oa.o_parent_oid : 0,
 					   body->oa.o_valid & OBD_MD_FLFID ?
-						body->oa.o_parent_ver : 0,
+					   body->oa.o_parent_ver : 0,
 					   POSTID(&body->oa.o_oi),
 					   aa->aa_ppga[0]->off,
 					   aa->aa_ppga[aa->aa_page_count-1]->off +
 					   aa->aa_ppga[aa->aa_page_count-1]->count -
-									1);
+					   1);
 			CERROR("client %x, server %x, cksum_type %x\n",
 			       client_cksum, server_cksum, cksum_type);
 			cksum_counter = 0;
@@ -1771,8 +1767,7 @@ static int brw_interpret(const struct lu_env *env,
 	if (osc_recoverable_error(rc)) {
 		if (req->rq_import_generation !=
 		    req->rq_import->imp_generation) {
-			CDEBUG(D_HA, "%s: resend cross eviction for object: "
-			       ""DOSTID", rc = %d.\n",
+			CDEBUG(D_HA, "%s: resend cross eviction for object: " DOSTID ", rc = %d.\n",
 			       req->rq_import->imp_obd->obd_name,
 			       POSTID(&aa->aa_oa->o_oi), rc);
 		} else if (rc == -EINPROGRESS ||
@@ -3013,8 +3008,8 @@ static int osc_reconnect(const struct lu_env *env,
 		cli->cl_lost_grant = 0;
 		client_obd_list_unlock(&cli->cl_loi_list_lock);
 
-		CDEBUG(D_RPCTRACE, "ocd_connect_flags: %#llx ocd_version: %d"
-		       " ocd_grant: %d, lost: %ld.\n", data->ocd_connect_flags,
+		CDEBUG(D_RPCTRACE, "ocd_connect_flags: %#llx ocd_version: %d ocd_grant: %d, lost: %ld.\n",
+		       data->ocd_connect_flags,
 		       data->ocd_version, data->ocd_grant, lost_grant);
 	}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 38cc931..b69f02e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -265,8 +265,7 @@ static void ptlrpc_at_adj_service(struct ptlrpc_request *req,
 	   so just keep minimal history here */
 	oldse = at_measured(&at->iat_service_estimate[idx], serv_est);
 	if (oldse != 0)
-		CDEBUG(D_ADAPTTO, "The RPC service estimate for %s ptl %d "
-		       "has changed from %d to %d\n",
+		CDEBUG(D_ADAPTTO, "The RPC service estimate for %s ptl %d has changed from %d to %d\n",
 		       req->rq_import->imp_obd->obd_name, req->rq_request_portal,
 		       oldse, at_get(&at->iat_service_estimate[idx]));
 }
@@ -297,8 +296,7 @@ static void ptlrpc_at_adj_net_latency(struct ptlrpc_request *req,
 
 	oldnl = at_measured(&at->iat_net_latency, nl);
 	if (oldnl != 0)
-		CDEBUG(D_ADAPTTO, "The network latency for %s (nid %s) "
-		       "has changed from %d to %d\n",
+		CDEBUG(D_ADAPTTO, "The network latency for %s (nid %s) has changed from %d to %d\n",
 		       req->rq_import->imp_obd->obd_name,
 		       obd_uuid2str(
 			       &req->rq_import->imp_connection->c_remote_uuid),
@@ -371,8 +369,8 @@ static int ptlrpc_at_recv_early_reply(struct ptlrpc_request *req)
 			   ptlrpc_at_get_net_latency(req);
 
 	DEBUG_REQ(D_ADAPTTO, req,
-		  "Early reply #%d, new deadline in "CFS_DURATION_T"s "
-		  "("CFS_DURATION_T"s)", req->rq_early_count,
+		  "Early reply #%d, new deadline in " CFS_DURATION_T "s (" CFS_DURATION_T "s)",
+		  req->rq_early_count,
 		  cfs_time_sub(req->rq_deadline, get_seconds()),
 		  cfs_time_sub(req->rq_deadline, olddl));
 
@@ -445,8 +443,8 @@ void ptlrpc_add_rqs_to_pool(struct ptlrpc_request_pool *pool, int num_rq)
 
 	LASSERTF(list_empty(&pool->prp_req_list) ||
 		 size == pool->prp_rq_size,
-		 "Trying to change pool size with nonempty pool "
-		 "from %d to %d bytes\n", pool->prp_rq_size, size);
+		 "Trying to change pool size with nonempty pool from %d to %d bytes\n",
+		 pool->prp_rq_size, size);
 
 	spin_lock(&pool->prp_lock);
 	pool->prp_rq_size = size;
@@ -1146,11 +1144,10 @@ static int ptlrpc_check_status(struct ptlrpc_request *req)
 		struct obd_import *imp = req->rq_import;
 		__u32 opc = lustre_msg_get_opc(req->rq_reqmsg);
 		if (ptlrpc_console_allow(req))
-			LCONSOLE_ERROR_MSG(0x011, "%s: Communicating with %s,"
-					   " operation %s failed with %d.\n",
+			LCONSOLE_ERROR_MSG(0x011, "%s: Communicating with %s, operation %s failed with %d.\n",
 					   imp->imp_obd->obd_name,
 					   libcfs_nid2str(
-					   imp->imp_connection->c_peer.nid),
+						   imp->imp_connection->c_peer.nid),
 					   ll_opcode2str(opc), err);
 		return err < 0 ? err : -EINVAL;
 	}
@@ -1206,8 +1203,7 @@ static int after_reply(struct ptlrpc_request *req)
 
 	if (req->rq_reply_truncate) {
 		if (ptlrpc_no_resend(req)) {
-			DEBUG_REQ(D_ERROR, req, "reply buffer overflow,"
-				  " expected: %d, actual size: %d",
+			DEBUG_REQ(D_ERROR, req, "reply buffer overflow, expected: %d, actual size: %d",
 				  req->rq_nob_received, req->rq_repbuf_len);
 			return -EOVERFLOW;
 		}
@@ -1259,8 +1255,7 @@ static int after_reply(struct ptlrpc_request *req)
 			/* new xid is already allocated for bulk in
 			 * ptlrpc_check_set() */
 			req->rq_xid = ptlrpc_next_xid();
-			DEBUG_REQ(D_RPCTRACE, req, "Allocating new xid for "
-				  "resend on EINPROGRESS");
+			DEBUG_REQ(D_RPCTRACE, req, "Allocating new xid for resend on EINPROGRESS");
 		}
 
 		/* Readjust the timeout for current conditions */
@@ -1412,8 +1407,8 @@ static int ptlrpc_send_new_req(struct ptlrpc_request *req)
 		req->rq_waiting = 1;
 		spin_unlock(&req->rq_lock);
 
-		DEBUG_REQ(D_HA, req, "req from PID %d waiting for recovery: "
-			  "(%s != %s)", lustre_msg_get_status(req->rq_reqmsg),
+		DEBUG_REQ(D_HA, req, "req from PID %d waiting for recovery: (%s != %s)",
+			  lustre_msg_get_status(req->rq_reqmsg),
 			  ptlrpc_import_state_name(req->rq_send_state),
 			  ptlrpc_import_state_name(imp->imp_state));
 		LASSERT(list_empty(&req->rq_list));
@@ -1450,8 +1445,8 @@ static int ptlrpc_send_new_req(struct ptlrpc_request *req)
 		}
 	}
 
-	CDEBUG(D_RPCTRACE, "Sending RPC pname:cluuid:pid:xid:nid:opc"
-	       " %s:%s:%d:%llu:%s:%d\n", current_comm(),
+	CDEBUG(D_RPCTRACE, "Sending RPC pname:cluuid:pid:xid:nid:opc %s:%s:%d:%llu:%s:%d\n",
+	       current_comm(),
 	       imp->imp_obd->obd_uuid.uuid,
 	       lustre_msg_get_status(req->rq_reqmsg), req->rq_xid,
 	       libcfs_nid2str(imp->imp_connection->c_peer.nid),
@@ -1828,12 +1823,11 @@ interpret:
 		ptlrpc_rqphase_move(req, RQ_PHASE_COMPLETE);
 
 		CDEBUG(req->rq_reqmsg != NULL ? D_RPCTRACE : 0,
-			"Completed RPC pname:cluuid:pid:xid:nid:"
-			"opc %s:%s:%d:%llu:%s:%d\n",
-			current_comm(), imp->imp_obd->obd_uuid.uuid,
-			lustre_msg_get_status(req->rq_reqmsg), req->rq_xid,
-			libcfs_nid2str(imp->imp_connection->c_peer.nid),
-			lustre_msg_get_opc(req->rq_reqmsg));
+		       "Completed RPC pname:cluuid:pid:xid:nid:opc %s:%s:%d:%llu:%s:%d\n",
+		       current_comm(), imp->imp_obd->obd_uuid.uuid,
+		       lustre_msg_get_status(req->rq_reqmsg), req->rq_xid,
+		       libcfs_nid2str(imp->imp_connection->c_peer.nid),
+		       lustre_msg_get_opc(req->rq_reqmsg));
 
 		spin_lock(&imp->imp_lock);
 		/* Request already may be not on sending or delaying list. This
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index 32dfffa..7f8644e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -128,8 +128,8 @@ void reply_in_callback(lnet_event_t *ev)
 	    ((lustre_msghdr_get_flags(req->rq_reqmsg) & MSGHDR_AT_SUPPORT))) {
 		/* Early reply */
 		DEBUG_REQ(D_ADAPTTO, req,
-			  "Early reply received: mlen=%u offset=%d replen=%d "
-			  "replied=%d unlinked=%d", ev->mlength, ev->offset,
+			  "Early reply received: mlen=%u offset=%d replen=%d replied=%d unlinked=%d",
+			  ev->mlength, ev->offset,
 			  req->rq_replen, req->rq_replied, ev->unlinked);
 
 		req->rq_early_count++; /* number received, client side */
@@ -313,8 +313,7 @@ void request_in_callback(lnet_event_t *ev)
 		}
 		req = ptlrpc_request_cache_alloc(GFP_ATOMIC);
 		if (req == NULL) {
-			CERROR("Can't allocate incoming request descriptor: "
-			       "Dropping %s RPC from %s\n",
+			CERROR("Can't allocate incoming request descriptor: Dropping %s RPC from %s\n",
 			       service->srv_name,
 			       libcfs_id2str(ev->initiator));
 			return;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 2e7e717..4ceb90d 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -157,18 +157,14 @@ int ptlrpc_set_import_discon(struct obd_import *imp, __u32 conn_cnt)
 			  &target_start, &target_len);
 
 		if (imp->imp_replayable) {
-			LCONSOLE_WARN("%s: Connection to %.*s (at %s) was "
-			       "lost; in progress operations using this "
-			       "service will wait for recovery to complete\n",
-			       imp->imp_obd->obd_name, target_len, target_start,
-			       libcfs_nid2str(imp->imp_connection->c_peer.nid));
+			LCONSOLE_WARN("%s: Connection to %.*s (at %s) was lost; in progress operations using this service will wait for recovery to complete\n",
+				      imp->imp_obd->obd_name, target_len, target_start,
+				      libcfs_nid2str(imp->imp_connection->c_peer.nid));
 		} else {
-			LCONSOLE_ERROR_MSG(0x166, "%s: Connection to "
-			       "%.*s (at %s) was lost; in progress "
-			       "operations using this service will fail\n",
-			       imp->imp_obd->obd_name,
-			       target_len, target_start,
-			       libcfs_nid2str(imp->imp_connection->c_peer.nid));
+			LCONSOLE_ERROR_MSG(0x166, "%s: Connection to %.*s (at %s) was lost; in progress operations using this service will fail\n",
+					   imp->imp_obd->obd_name,
+					   target_len, target_start,
+					   libcfs_nid2str(imp->imp_connection->c_peer.nid));
 		}
 		IMPORT_SET_STATE_NOLOCK(imp, LUSTRE_IMP_DISCON);
 		spin_unlock(&imp->imp_lock);
@@ -328,8 +324,8 @@ void ptlrpc_invalidate_import(struct obd_import *imp)
 				 * sluggish nets). Let's check this. If there
 				 * is no inflight and unregistering != 0, this
 				 * is bug. */
-				LASSERTF(count == 0, "Some RPCs are still "
-					 "unregistering: %d\n", count);
+				LASSERTF(count == 0, "Some RPCs are still unregistering: %d\n",
+					 count);
 
 				/* Let's save one loop as soon as inflight have
 				 * dropped to zero. No new inflights possible at
@@ -353,12 +349,11 @@ void ptlrpc_invalidate_import(struct obd_import *imp)
 						  "still on delayed list");
 				}
 
-				CERROR("%s: RPCs in \"%s\" phase found (%d). "
-				       "Network is sluggish? Waiting them "
-				       "to error out.\n", cli_tgt,
+				CERROR("%s: RPCs in \"%s\" phase found (%d). Network is sluggish? Waiting them to error out.\n",
+				       cli_tgt,
 				       ptlrpc_phase2str(RQ_PHASE_UNREGISTERING),
 				       atomic_read(&imp->
-						       imp_unregistering));
+						   imp_unregistering));
 			}
 			spin_unlock(&imp->imp_lock);
 		  }
@@ -413,8 +408,7 @@ void ptlrpc_fail_import(struct obd_import *imp, __u32 conn_cnt)
 
 	if (ptlrpc_set_import_discon(imp, conn_cnt)) {
 		if (!imp->imp_replayable) {
-			CDEBUG(D_HA, "import %s@%s for %s not replayable, "
-			       "auto-deactivating\n",
+			CDEBUG(D_HA, "import %s@%s for %s not replayable, auto-deactivating\n",
 			       obd2cli_tgt(imp->imp_obd),
 			       imp->imp_connection->c_remote_uuid.uuid,
 			       imp->imp_obd->obd_name);
@@ -541,8 +535,8 @@ static int import_select_connection(struct obd_import *imp)
 				at_reset(at, CONNECTION_SWITCH_MAX);
 		}
 		LASSERT(imp_conn->oic_last_attempt);
-		CDEBUG(D_HA, "%s: tried all connections, increasing latency "
-			"to %ds\n", imp->imp_obd->obd_name, at_get(at));
+		CDEBUG(D_HA, "%s: tried all connections, increasing latency to %ds\n",
+		       imp->imp_obd->obd_name, at_get(at));
 	}
 
 	imp_conn->oic_last_attempt = cfs_time_current_64();
@@ -564,8 +558,7 @@ static int import_select_connection(struct obd_import *imp)
 			deuuidify(obd2cli_tgt(imp->imp_obd), NULL,
 				  &target_start, &target_len);
 
-			CDEBUG(D_HA, "%s: Connection changing to"
-			       " %.*s (at %s)\n",
+			CDEBUG(D_HA, "%s: Connection changing to %.*s (at %s)\n",
 			       imp->imp_obd->obd_name,
 			       target_len, target_start,
 			       libcfs_nid2str(imp_conn->oic_conn->c_peer.nid));
@@ -935,14 +928,13 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 				       lustre_msg_get_handle(
 				       request->rq_repmsg)->cookie);
 			} else {
-				LCONSOLE_WARN("Evicted from %s (at %s) "
-					      "after server handle changed from %#llx to %#llx\n",
+				LCONSOLE_WARN("Evicted from %s (at %s) after server handle changed from %#llx to %#llx\n",
 					      obd2cli_tgt(imp->imp_obd),
 					      imp->imp_connection-> \
 					      c_remote_uuid.uuid,
 					      imp->imp_remote_handle.cookie,
 					      lustre_msg_get_handle(
-					      request->rq_repmsg)->cookie);
+						      request->rq_repmsg)->cookie);
 			}
 
 
@@ -962,8 +954,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		}
 
 		if (imp->imp_invalid) {
-			CDEBUG(D_HA, "%s: reconnected but import is invalid; "
-			       "marking evicted\n", imp->imp_obd->obd_name);
+			CDEBUG(D_HA, "%s: reconnected but import is invalid; marking evicted\n",
+			       imp->imp_obd->obd_name);
 			IMPORT_SET_STATE(imp, LUSTRE_IMP_EVICTED);
 		} else if (MSG_CONNECT_RECOVERING & msg_flags) {
 			CDEBUG(D_HA, "%s: reconnected to %s during replay\n",
@@ -985,8 +977,8 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 		imp->imp_last_replay_transno = 0;
 		IMPORT_SET_STATE(imp, LUSTRE_IMP_REPLAY);
 	} else {
-		DEBUG_REQ(D_HA, request, "%s: evicting (reconnect/recover flags"
-			  " not set: %x)", imp->imp_obd->obd_name, msg_flags);
+		DEBUG_REQ(D_HA, request, "%s: evicting (reconnect/recover flags not set: %x)",
+			  imp->imp_obd->obd_name, msg_flags);
 		imp->imp_remote_handle =
 				*lustre_msg_get_handle(request->rq_repmsg);
 		IMPORT_SET_STATE(imp, LUSTRE_IMP_EVICTED);
@@ -994,17 +986,13 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 
 	/* Sanity checks for a reconnected import. */
 	if (!(imp->imp_replayable) != !(msg_flags & MSG_CONNECT_REPLAYABLE)) {
-		CERROR("imp_replayable flag does not match server "
-		       "after reconnect. We should LBUG right here.\n");
+		CERROR("imp_replayable flag does not match server after reconnect. We should LBUG right here.\n");
 	}
 
 	if (lustre_msg_get_last_committed(request->rq_repmsg) > 0 &&
 	    lustre_msg_get_last_committed(request->rq_repmsg) <
 	    aa->pcaa_peer_committed) {
-		CERROR("%s went back in time (transno %lld"
-		       " was previously committed, server now claims %lld"
-		       ")!  See https://bugzilla.lustre.org/show_bug.cgi?"
-		       "id=9646\n",
+		CERROR("%s went back in time (transno %lld was previously committed, server now claims %lld)!  See https://bugzilla.lustre.org/show_bug.cgi?id=9646\n",
 		       obd2cli_tgt(imp->imp_obd), aa->pcaa_peer_committed,
 		       lustre_msg_get_last_committed(request->rq_repmsg));
 	}
@@ -1013,8 +1001,7 @@ finish:
 	rc = ptlrpc_import_recovery_state_machine(imp);
 	if (rc != 0) {
 		if (rc == -ENOTCONN) {
-			CDEBUG(D_HA, "evicted/aborted by %s@%s during recovery;"
-			       "invalidating and reconnecting\n",
+			CDEBUG(D_HA, "evicted/aborted by %s@%s during recovery; invalidating and reconnecting\n",
 			       obd2cli_tgt(imp->imp_obd),
 			       imp->imp_connection->c_remote_uuid.uuid);
 			ptlrpc_connect_import(imp);
@@ -1034,9 +1021,7 @@ finish:
 
 		if ((imp->imp_connect_flags_orig & OBD_CONNECT_IBITS) &&
 		    !(ocd->ocd_connect_flags & OBD_CONNECT_IBITS)) {
-			LCONSOLE_WARN("%s: MDS %s does not support ibits "
-				      "lock, either very old or invalid: "
-				      "requested %llx, replied %llx\n",
+			LCONSOLE_WARN("%s: MDS %s does not support ibits lock, either very old or invalid: requested %llx, replied %llx\n",
 				      imp->imp_obd->obd_name,
 				      imp->imp_connection->c_remote_uuid.uuid,
 				      imp->imp_connect_flags_orig,
@@ -1052,13 +1037,12 @@ finish:
 					LUSTRE_VERSION_OFFSET_WARN)) {
 			/* Sigh, some compilers do not like #ifdef in the middle
 			   of macro arguments */
-			const char *older = "older. Consider upgrading server "
-					    "or downgrading client";
-			const char *newer = "newer than client version. "
-					    "Consider upgrading client";
+			const char *older = "older. Consider upgrading server or downgrading client"
+				;
+			const char *newer = "newer than client version. Consider upgrading client"
+					    ;
 
-			LCONSOLE_WARN("Server %s version (%d.%d.%d.%d) "
-				      "is much %s (%s)\n",
+			LCONSOLE_WARN("Server %s version (%d.%d.%d.%d) is much %s (%s)\n",
 				      obd2cli_tgt(imp->imp_obd),
 				      OBD_OCD_VERSION_MAJOR(ocd->ocd_version),
 				      OBD_OCD_VERSION_MINOR(ocd->ocd_version),
@@ -1095,10 +1079,7 @@ finish:
 			 * the checksum types it doesn't support */
 			if ((ocd->ocd_cksum_types &
 			     cksum_types_supported_client()) == 0) {
-				LCONSOLE_WARN("The negotiation of the checksum "
-					      "algorithm to use with server %s "
-					      "failed (%x/%x), disabling "
-					      "checksums\n",
+				LCONSOLE_WARN("The negotiation of the checksum algorithm to use with server %s failed (%x/%x), disabling checksums\n",
 					      obd2cli_tgt(imp->imp_obd),
 					      ocd->ocd_cksum_types,
 					      cksum_types_supported_client());
@@ -1191,17 +1172,13 @@ out:
 				 * connection from liblustre clients, so we
 				 * should never see this from VFS context
 				 */
-				LCONSOLE_ERROR_MSG(0x16a, "Server %s version "
-					"(%d.%d.%d.%d)"
-					" refused connection from this client "
-					"with an incompatible version (%s).  "
-					"Client must be recompiled\n",
-					obd2cli_tgt(imp->imp_obd),
-					OBD_OCD_VERSION_MAJOR(ocd->ocd_version),
-					OBD_OCD_VERSION_MINOR(ocd->ocd_version),
-					OBD_OCD_VERSION_PATCH(ocd->ocd_version),
-					OBD_OCD_VERSION_FIX(ocd->ocd_version),
-					LUSTRE_VERSION_STRING);
+				LCONSOLE_ERROR_MSG(0x16a, "Server %s version (%d.%d.%d.%d) refused connection from this client with an incompatible version (%s).  Client must be recompiled\n",
+						   obd2cli_tgt(imp->imp_obd),
+						   OBD_OCD_VERSION_MAJOR(ocd->ocd_version),
+						   OBD_OCD_VERSION_MINOR(ocd->ocd_version),
+						   OBD_OCD_VERSION_PATCH(ocd->ocd_version),
+						   OBD_OCD_VERSION_FIX(ocd->ocd_version),
+						   LUSTRE_VERSION_STRING);
 				ptlrpc_deactivate_import(imp);
 				IMPORT_SET_STATE(imp, LUSTRE_IMP_CLOSED);
 			}
@@ -1237,8 +1214,7 @@ static int completed_replay_interpret(const struct lu_env *env,
 			       "%s: version recovery fails, reconnecting\n",
 			       req->rq_import->imp_obd->obd_name);
 		} else {
-			CDEBUG(D_HA, "%s: LAST_REPLAY message error: %d, "
-				     "reconnecting\n",
+			CDEBUG(D_HA, "%s: LAST_REPLAY message error: %d, reconnecting\n",
 			       req->rq_import->imp_obd->obd_name,
 			       req->rq_status);
 		}
@@ -1343,9 +1319,7 @@ int ptlrpc_import_recovery_state_machine(struct obd_import *imp)
 		/* Don't care about MGC eviction */
 		if (strcmp(imp->imp_obd->obd_type->typ_name,
 			   LUSTRE_MGC_NAME) != 0) {
-			LCONSOLE_ERROR_MSG(0x167, "%s: This client was evicted "
-					   "by %.*s; in progress operations "
-					   "using this service will fail.\n",
+			LCONSOLE_ERROR_MSG(0x167, "%s: This client was evicted by %.*s; in progress operations using this service will fail.\n",
 					   imp->imp_obd->obd_name, target_len,
 					   target_start);
 		}
@@ -1455,8 +1429,7 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 		break;
 	default:
 		rc = -EINVAL;
-		CERROR("%s: don't know how to disconnect from %s "
-		       "(connect_op %d): rc = %d\n",
+		CERROR("%s: don't know how to disconnect from %s (connect_op %d): rc = %d\n",
 		       imp->imp_obd->obd_name, obd2cli_tgt(imp->imp_obd),
 		       imp->imp_connect_op, rc);
 		return rc;
@@ -1607,8 +1580,8 @@ int at_measured(struct adaptive_timeout *at, unsigned int val)
 	at->at_current =  max(at->at_current, at_min);
 
 	if (at->at_current != old)
-		CDEBUG(D_OTHER, "AT %p change: old=%u new=%u delta=%d "
-		       "(val=%u) hist %u %u %u %u\n", at,
+		CDEBUG(D_OTHER, "AT %p change: old=%u new=%u delta=%d (val=%u) hist %u %u %u %u\n",
+		       at,
 		       old, at->at_current, at->at_current - old, val,
 		       at->at_hist[0], at->at_hist[1], at->at_hist[2],
 		       at->at_hist[3]);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 78364ec..252f3e1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -1886,8 +1886,8 @@ swabber_dumper_helper(struct req_capsule *pill,
 		swabber(value);
 		ptlrpc_buf_set_swabbed(pill->rc_req, inout, offset);
 		if (dump) {
-			CDEBUG(D_RPCTRACE, "Dump of swabbed field %s "
-			       "follows\n", field->rmf_name);
+			CDEBUG(D_RPCTRACE, "Dump of swabbed field %s follows\n",
+			       field->rmf_name);
 			field->rmf_dumper(value);
 		}
 
@@ -1903,8 +1903,7 @@ swabber_dumper_helper(struct req_capsule *pill,
 	     i < n;
 	     i++, p += field->rmf_size) {
 		if (dump) {
-			CDEBUG(D_RPCTRACE, "Dump of %sarray field %s, "
-			       "element %d follows\n",
+			CDEBUG(D_RPCTRACE, "Dump of %sarray field %s, element %d follows\n",
 			       do_swab ? "unswabbed " : "", field->rmf_name, i);
 			field->rmf_dumper(p);
 		}
@@ -1912,8 +1911,8 @@ swabber_dumper_helper(struct req_capsule *pill,
 			continue;
 		swabber(p);
 		if (dump) {
-			CDEBUG(D_RPCTRACE, "Dump of swabbed array field %s, "
-			       "element %d follows\n", field->rmf_name, i);
+			CDEBUG(D_RPCTRACE, "Dump of swabbed array field %s, element %d follows\n",
+			       field->rmf_name, i);
 			field->rmf_dumper(value);
 		}
 	}
@@ -1972,8 +1971,7 @@ static void *__req_capsule_get(struct req_capsule *pill,
 		 */
 		len = lustre_msg_buflen(msg, offset);
 		if ((len % field->rmf_size) != 0) {
-			CERROR("%s: array field size mismatch "
-			       "%d modulo %d != 0 (%d)\n",
+			CERROR("%s: array field size mismatch %d modulo %d != 0 (%d)\n",
 			       field->rmf_name, len, field->rmf_size, loc);
 			return NULL;
 		}
@@ -1986,8 +1984,7 @@ static void *__req_capsule_get(struct req_capsule *pill,
 
 	if (value == NULL) {
 		DEBUG_REQ(D_ERROR, pill->rc_req,
-			  "Wrong buffer for field `%s' (%d of %d) "
-			  "in format `%s': %d vs. %d (%s)\n",
+			  "Wrong buffer for field `%s' (%d of %d) in format `%s': %d vs. %d (%s)\n",
 			  field->rmf_name, offset, lustre_msg_bufcount(msg),
 			  fmt->rf_name, lustre_msg_buflen(msg, offset), len,
 			  rcl_names[loc]);
@@ -2020,8 +2017,8 @@ void __req_capsule_dump(struct req_capsule *pill, enum req_location loc)
 			 * have a specific dumper
 			 */
 			len = req_capsule_get_size(pill, field, loc);
-			CDEBUG(D_RPCTRACE, "Field %s has no dumper function;"
-			       "field size is %d\n", field->rmf_name, len);
+			CDEBUG(D_RPCTRACE, "Field %s has no dumper function; field size is %d\n",
+			       field->rmf_name, len);
 		} else {
 			/* It's the dumping side-effect that we're interested in */
 			(void) __req_capsule_get(pill, field, loc, NULL, 1);
@@ -2173,8 +2170,7 @@ void req_capsule_set_size(struct req_capsule *pill,
 	    (size > 0)) {
 		if ((field->rmf_flags & RMF_F_STRUCT_ARRAY) &&
 		    (size % field->rmf_size != 0)) {
-			CERROR("%s: array field size mismatch "
-			       "%d %% %d != 0 (%d)\n",
+			CERROR("%s: array field size mismatch %d %% %d != 0 (%d)\n",
 			       field->rmf_name, size, field->rmf_size, loc);
 			LBUG();
 		} else if (!(field->rmf_flags & RMF_F_STRUCT_ARRAY) &&
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
index 56f825f..e9baf5b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
@@ -334,8 +334,7 @@ static int llog_client_read_header(const struct lu_env *env,
 		       llh_hdr->lrh_type, LLOG_HDR_MAGIC);
 		rc = -EIO;
 	} else if (llh_hdr->lrh_len != LLOG_CHUNK_SIZE) {
-		CERROR("incorrectly sized log header: %#x "
-		       "(expecting %#x)\n",
+		CERROR("incorrectly sized log header: %#x (expecting %#x)\n",
 		       llh_hdr->lrh_len, LLOG_CHUNK_SIZE);
 		CERROR("you may need to re-run lconf --write_conf.\n");
 		rc = -EIO;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 0c3f667..4011e00 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -745,8 +745,7 @@ ptlrpc_lprocfs_svc_req_history_seek(struct ptlrpc_service_part *svcpt,
 			 svcpt->scp_service->srv_name, svcpt->scp_cpt,
 			 srhi->srhi_seq, srhi->srhi_req->rq_history_seq);
 		LASSERTF(!list_empty(&svcpt->scp_hist_reqs),
-			 "%s:%d: seek offset %llu, request seq %llu, "
-			 "last culled %llu\n",
+			 "%s:%d: seek offset %llu, request seq %llu, last culled %llu\n",
 			 svcpt->scp_service->srv_name, svcpt->scp_cpt,
 			 seq, srhi->srhi_seq, svcpt->scp_hist_seq_culled);
 		e = &srhi->srhi_req->rq_history_list;
@@ -813,8 +812,8 @@ ptlrpc_lprocfs_svc_req_history_start(struct seq_file *s, loff_t *pos)
 	int				i;
 
 	if (sizeof(loff_t) != sizeof(__u64)) { /* can't support */
-		CWARN("Failed to read request history because size of loff_t "
-		      "%d can't match size of u64\n", (int)sizeof(loff_t));
+		CWARN("Failed to read request history because size of loff_t %d can't match size of u64\n",
+		      (int)sizeof(loff_t));
 		return NULL;
 	}
 
@@ -1297,14 +1296,12 @@ int lprocfs_wr_import(struct file *file, const char *buffer,
 		if (*endptr) {
 			CERROR("config: wrong instance # %s\n", ptr);
 		} else if (inst != imp->imp_connect_data.ocd_instance) {
-			CDEBUG(D_INFO, "IR: %s is connecting to an obsoleted "
-			       "target(%u/%u), reconnecting...\n",
+			CDEBUG(D_INFO, "IR: %s is connecting to an obsoleted target(%u/%u), reconnecting...\n",
 			       imp->imp_obd->obd_name,
 			       imp->imp_connect_data.ocd_instance, inst);
 			do_reconn = 1;
 		} else {
-			CDEBUG(D_INFO, "IR: %s has already been connecting to "
-			       "new target(%u)\n",
+			CDEBUG(D_INFO, "IR: %s has already been connecting to new target(%u)\n",
 			       imp->imp_obd->obd_name, inst);
 		}
 	}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index c1e8aa4..f715e9a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -224,8 +224,8 @@ int ptlrpc_register_bulk(struct ptlrpc_request *req)
 		      total_md - desc->bd_md_count);
 	spin_unlock(&desc->bd_lock);
 
-	CDEBUG(D_NET, "Setup %u bulk %s buffers: %u pages %u bytes, "
-	       "xid x%#llx-%#llx, portal %u\n", desc->bd_md_count,
+	CDEBUG(D_NET, "Setup %u bulk %s buffers: %u pages %u bytes, xid x%#llx-%#llx, portal %u\n",
+	       desc->bd_md_count,
 	       desc->bd_type == BULK_GET_SOURCE ? "get-source" : "put-sink",
 	       desc->bd_iov_count, desc->bd_nob,
 	       desc->bd_last_xid, req->rq_xid, desc->bd_portal);
@@ -337,8 +337,7 @@ static void ptlrpc_at_set_reply(struct ptlrpc_request *req, int flags)
 
 	if (req->rq_reqmsg &&
 	    !(lustre_msghdr_get_flags(req->rq_reqmsg) & MSGHDR_AT_SUPPORT)) {
-		CDEBUG(D_ADAPTTO, "No early reply support: flags=%#x "
-		       "req_flags=%#x magic=%d:%x/%x len=%d\n",
+		CDEBUG(D_ADAPTTO, "No early reply support: flags=%#x req_flags=%#x magic=%d:%x/%x len=%d\n",
 		       flags, lustre_msg_get_flags(req->rq_reqmsg),
 		       lustre_msg_is_v1(req->rq_reqmsg),
 		       lustre_msg_get_magic(req->rq_reqmsg),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index 181301b..d5fd721 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -770,8 +770,8 @@ static int nrs_policy_register(struct ptlrpc_nrs *nrs,
 
 	tmp = nrs_policy_find_locked(nrs, policy->pol_desc->pd_name);
 	if (tmp != NULL) {
-		CERROR("NRS policy %s has been registered, can't register it "
-		       "for %s\n", policy->pol_desc->pd_name,
+		CERROR("NRS policy %s has been registered, can't register it for %s\n",
+		       policy->pol_desc->pd_name,
 		       svcpt->scp_service->srv_name);
 		nrs_policy_put_locked(tmp);
 
@@ -882,8 +882,7 @@ static int nrs_register_policies_locked(struct ptlrpc_nrs *nrs)
 		if (nrs_policy_compatible(svc, desc)) {
 			rc = nrs_policy_register(nrs, desc);
 			if (rc != 0) {
-				CERROR("Failed to register NRS policy %s for "
-				       "partition %d of service %s: %d\n",
+				CERROR("Failed to register NRS policy %s for partition %d of service %s: %d\n",
 				       desc->pd_name, svcpt->scp_cpt,
 				       svc->srv_name, rc);
 				/**
@@ -1082,8 +1081,7 @@ again:
 			if (rc == -ENOENT) {
 				rc = 0;
 			} else if (rc != 0) {
-				CERROR("Failed to unregister NRS policy %s for "
-				       "partition %d of service %s: %d\n",
+				CERROR("Failed to unregister NRS policy %s for partition %d of service %s: %d\n",
 				       desc->pd_name, svcpt->scp_cpt,
 				       svcpt->scp_service->srv_name, rc);
 				return rc;
@@ -1145,18 +1143,15 @@ int ptlrpc_nrs_policy_register(struct ptlrpc_nrs_pol_conf *conf)
 	if ((conf->nc_flags & PTLRPC_NRS_FL_REG_EXTERN) &&
 	    (conf->nc_flags & (PTLRPC_NRS_FL_FALLBACK |
 			       PTLRPC_NRS_FL_REG_START))) {
-		CERROR("NRS: failing to register policy %s. Please check "
-		       "policy flags; external policies cannot act as fallback "
-		       "policies, or be started immediately upon registration "
-		       "without interaction with lprocfs\n", conf->nc_name);
+		CERROR("NRS: failing to register policy %s. Please check policy flags; external policies cannot act as fallback policies, or be started immediately upon registration without interaction with lprocfs\n",
+		       conf->nc_name);
 		return -EINVAL;
 	}
 
 	mutex_lock(&nrs_core.nrs_mutex);
 
 	if (nrs_policy_find_desc_locked(conf->nc_name) != NULL) {
-		CERROR("NRS: failing to register policy %s which has already "
-		       "been registered with NRS core!\n",
+		CERROR("NRS: failing to register policy %s which has already been registered with NRS core!\n",
 		       conf->nc_name);
 		rc = -EEXIST;
 		goto fail;
@@ -1209,8 +1204,7 @@ again:
 			nrs = nrs_svcpt2nrs(svcpt, hp);
 			rc = nrs_policy_register(nrs, desc);
 			if (rc != 0) {
-				CERROR("Failed to register NRS policy %s for "
-				       "partition %d of service %s: %d\n",
+				CERROR("Failed to register NRS policy %s for partition %d of service %s: %d\n",
 				       desc->pd_name, svcpt->scp_cpt,
 				       svcpt->scp_service->srv_name, rc);
 
@@ -1281,8 +1275,7 @@ int ptlrpc_nrs_policy_unregister(struct ptlrpc_nrs_pol_conf *conf)
 	LASSERT(conf != NULL);
 
 	if (conf->nc_flags & PTLRPC_NRS_FL_FALLBACK) {
-		CERROR("Unable to unregister a fallback policy, unless the "
-		       "PTLRPC service is stopping.\n");
+		CERROR("Unable to unregister a fallback policy, unless the PTLRPC service is stopping.\n");
 		return -EPERM;
 	}
 
@@ -1292,8 +1285,7 @@ int ptlrpc_nrs_policy_unregister(struct ptlrpc_nrs_pol_conf *conf)
 
 	desc = nrs_policy_find_desc_locked(conf->nc_name);
 	if (desc == NULL) {
-		CERROR("Failing to unregister NRS policy %s which has "
-		       "not been registered with NRS core!\n",
+		CERROR("Failing to unregister NRS policy %s which has not been registered with NRS core!\n",
 		       conf->nc_name);
 		rc = -ENOENT;
 		goto not_exist;
@@ -1304,9 +1296,8 @@ int ptlrpc_nrs_policy_unregister(struct ptlrpc_nrs_pol_conf *conf)
 	rc = nrs_policy_unregister_locked(desc);
 	if (rc < 0) {
 		if (rc == -EBUSY)
-			CERROR("Please first stop policy %s on all service "
-			       "partitions and then retry to unregister the "
-			       "policy.\n", conf->nc_name);
+			CERROR("Please first stop policy %s on all service partitions and then retry to unregister the policy.\n",
+			       conf->nc_name);
 		goto fail;
 	}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 60552f4..2f45f765 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -412,8 +412,8 @@ void *lustre_msg_buf_v2(struct lustre_msg_v2 *m, int n, int min_size)
 
 	buflen = m->lm_buflens[n];
 	if (unlikely(buflen < min_size)) {
-		CERROR("msg %p buffer[%d] size %d too small "
-		       "(required %d, opc=%d)\n", m, n, buflen, min_size,
+		CERROR("msg %p buffer[%d] size %d too small (required %d, opc=%d)\n",
+		       m, n, buflen, min_size,
 		       n == MSG_PTLRPC_BODY_OFF ? -1 : lustre_msg_get_opc(m));
 		return NULL;
 	}
@@ -749,21 +749,19 @@ char *lustre_msg_string(struct lustre_msg *m, int index, int max_len)
 	slen = strnlen(str, blen);
 
 	if (slen == blen) {		     /* not NULL terminated */
-		CERROR("can't unpack non-NULL terminated string in "
-			"msg %p buffer[%d] len %d\n", m, index, blen);
+		CERROR("can't unpack non-NULL terminated string in msg %p buffer[%d] len %d\n",
+		       m, index, blen);
 		return NULL;
 	}
 
 	if (max_len == 0) {
 		if (slen != blen - 1) {
-			CERROR("can't unpack short string in msg %p "
-			       "buffer[%d] len %d: strlen %d\n",
+			CERROR("can't unpack short string in msg %p buffer[%d] len %d: strlen %d\n",
 			       m, index, blen, slen);
 			return NULL;
 		}
 	} else if (slen > max_len) {
-		CERROR("can't unpack oversized string in msg %p "
-		       "buffer[%d] len %d strlen %d: max %d expected\n",
+		CERROR("can't unpack oversized string in msg %p buffer[%d] len %d strlen %d: max %d expected\n",
 		       m, index, blen, slen, max_len);
 		return NULL;
 	}
@@ -2258,8 +2256,8 @@ void lustre_swab_quota_body(struct quota_body *b)
 void dump_ioo(struct obd_ioobj *ioo)
 {
 	CDEBUG(D_RPCTRACE,
-	       "obd_ioobj: ioo_oid="DOSTID", ioo_max_brw=%#x, "
-	       "ioo_bufct=%d\n", POSTID(&ioo->ioo_oid), ioo->ioo_max_brw,
+	       "obd_ioobj: ioo_oid=" DOSTID ", ioo_max_brw=%#x, ioo_bufct=%d\n",
+	       POSTID(&ioo->ioo_oid), ioo->ioo_max_brw,
 	       ioo->ioo_bufcnt);
 }
 EXPORT_SYMBOL(dump_ioo);
@@ -2330,8 +2328,7 @@ void dump_obdo(struct obdo *oa)
 		CDEBUG(D_RPCTRACE, "obdo: o_handle = %lld\n",
 		       oa->o_handle.cookie);
 	if (valid & OBD_MD_FLCOOKIE)
-		CDEBUG(D_RPCTRACE, "obdo: o_lcookie = "
-		       "(llog_cookie dumping not yet implemented)\n");
+		CDEBUG(D_RPCTRACE, "obdo: o_lcookie = (llog_cookie dumping not yet implemented)\n");
 }
 EXPORT_SYMBOL(dump_obdo);
 
@@ -2395,17 +2392,15 @@ void _debug_req(struct ptlrpc_request *req,
 
 	va_start(args, fmt);
 	libcfs_debug_vmsg2(msgdata, fmt, args,
-			   " req@%p x%llu/t%lld(%lld) o%d->%s@%s:%d/%d"
-			   " lens %d/%d e %d to %d dl "CFS_TIME_T" ref %d "
-			   "fl "REQ_FLAGS_FMT"/%x/%x rc %d/%d\n",
+			   " req@%p x%llu/t%lld(%lld) o%d->%s@%s:%d/%d lens %d/%d e %d to %d dl " CFS_TIME_T " ref %d fl " REQ_FLAGS_FMT "/%x/%x rc %d/%d\n",
 			   req, req->rq_xid, req->rq_transno,
 			   req_ok ? lustre_msg_get_transno(req->rq_reqmsg) : 0,
 			   req_ok ? lustre_msg_get_opc(req->rq_reqmsg) : -1,
 			   req->rq_import ?
-				req->rq_import->imp_obd->obd_name :
-				req->rq_export ?
-				     req->rq_export->exp_client_uuid.uuid :
-				     "<?>",
+			   req->rq_import->imp_obd->obd_name :
+			   req->rq_export ?
+			   req->rq_export->exp_client_uuid.uuid :
+			   "<?>",
 			   libcfs_nid2str(nid),
 			   req->rq_request_portal, req->rq_reply_portal,
 			   req->rq_reqlen, req->rq_replen,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index b9cbbbd5..340d98a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -206,8 +206,7 @@ static void ptlrpc_pinger_process_import(struct obd_import *imp,
 
 	spin_unlock(&imp->imp_lock);
 
-	CDEBUG(level == LUSTRE_IMP_FULL ? D_INFO : D_HA, "%s->%s: level %s/%u "
-	       "force %u force_next %u deactive %u pingable %u suppress %u\n",
+	CDEBUG(level == LUSTRE_IMP_FULL ? D_INFO : D_HA, "%s->%s: level %s/%u force %u force_next %u deactive %u pingable %u suppress %u\n",
 	       imp->imp_obd->obd_uuid.uuid, obd2cli_tgt(imp->imp_obd),
 	       ptlrpc_import_state_name(level), level, force, force_next,
 	       imp->imp_deactive, imp->imp_pingable, suppress);
@@ -220,8 +219,7 @@ static void ptlrpc_pinger_process_import(struct obd_import *imp,
 	} else if (level != LUSTRE_IMP_FULL ||
 		   imp->imp_obd->obd_no_recov ||
 		   imp_is_deactive(imp)) {
-		CDEBUG(D_HA, "%s->%s: not pinging (in recovery "
-		       "or recovery disabled: %s)\n",
+		CDEBUG(D_HA, "%s->%s: not pinging (in recovery or recovery disabled: %s)\n",
 		       imp->imp_obd->obd_uuid.uuid, obd2cli_tgt(imp->imp_obd),
 		       ptlrpc_import_state_name(level));
 		if (force) {
@@ -334,11 +332,7 @@ int ptlrpc_start_pinger(void)
 		     thread_is_running(&pinger_thread), &lwi);
 
 	if (suppress_pings)
-		CWARN("Pings will be suppressed at the request of the "
-		      "administrator.  The configuration shall meet the "
-		      "additional requirements described in the manual.  "
-		      "(Search for the \"suppress_pings\" kernel module "
-		      "parameter.)\n");
+		CWARN("Pings will be suppressed at the request of the administrator.  The configuration shall meet the additional requirements described in the manual.  (Search for the \"suppress_pings\" kernel module parameter.)\n");
 
 	return 0;
 }
@@ -623,11 +617,7 @@ static int ping_evictor_main(void *arg)
 			if (expire_time > exp->exp_last_request_time) {
 				class_export_get(exp);
 				spin_unlock(&obd->obd_dev_lock);
-				LCONSOLE_WARN("%s: haven't heard from client %s"
-					      " (at %s) in %ld seconds. I think"
-					      " it's dead, and I am evicting"
-					      " it. exp %p, cur %ld expire %ld"
-					      " last %ld\n",
+				LCONSOLE_WARN("%s: haven't heard from client %s (at %s) in %ld seconds. I think it's dead, and I am evicting it. exp %p, cur %ld expire %ld last %ld\n",
 					      obd->obd_name,
 					      obd_uuid2str(&exp->exp_client_uuid),
 					      obd_export_nid2str(exp),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index 357ea9f..cbcc541 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -356,10 +356,9 @@ static int ptlrpcd_check(struct lu_env *env, struct ptlrpcd_ctl *pc)
 				if (atomic_read(&ps->set_new_count)) {
 					rc = ptlrpcd_steal_rqset(set, ps);
 					if (rc > 0)
-						CDEBUG(D_RPCTRACE, "transfer %d"
-						       " async RPCs [%d->%d]\n",
-							rc, partner->pc_index,
-							pc->pc_index);
+						CDEBUG(D_RPCTRACE, "transfer %d async RPCs [%d->%d]\n",
+						       rc, partner->pc_index,
+						       pc->pc_index);
 				}
 				ptlrpc_reqset_put(ps);
 			} while (rc == 0 && pc->pc_cursor != first);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/recover.c b/drivers/staging/lustre/lustre/ptlrpc/recover.c
index e1bc77b..7b1d729 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/recover.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/recover.c
@@ -237,8 +237,7 @@ void ptlrpc_request_handle_notconn(struct ptlrpc_request *failed_req)
 	if (ptlrpc_set_import_discon(imp,
 			      lustre_msg_get_conn_cnt(failed_req->rq_reqmsg))) {
 		if (!imp->imp_replayable) {
-			CDEBUG(D_HA, "import %s@%s for %s not replayable, "
-			       "auto-deactivating\n",
+			CDEBUG(D_HA, "import %s@%s for %s not replayable, auto-deactivating\n",
 			       obd2cli_tgt(imp->imp_obd),
 			       imp->imp_connection->c_remote_uuid.uuid,
 			       imp->imp_obd->obd_name);
@@ -274,8 +273,8 @@ int ptlrpc_set_import_active(struct obd_import *imp, int active)
 	/* When deactivating, mark import invalid, and abort in-flight
 	 * requests. */
 	if (!active) {
-		LCONSOLE_WARN("setting import %s INACTIVE by administrator "
-			      "request\n", obd2cli_tgt(imp->imp_obd));
+		LCONSOLE_WARN("setting import %s INACTIVE by administrator request\n",
+			      obd2cli_tgt(imp->imp_obd));
 
 		/* set before invalidate to avoid messages about imp_inval
 		 * set without imp_deactive in ptlrpc_import_delay_req */
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 6ac8a83..21e9dc9 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -456,8 +456,8 @@ int sptlrpc_req_ctx_switch(struct ptlrpc_request *req,
 	LASSERT(req->rq_reqlen);
 	LASSERT(req->rq_replen);
 
-	CDEBUG(D_SEC, "req %p: switch ctx %p(%u->%s) -> %p(%u->%s), "
-	       "switch sec %p(%s) -> %p(%s)\n", req,
+	CDEBUG(D_SEC, "req %p: switch ctx %p(%u->%s) -> %p(%u->%s), switch sec %p(%s) -> %p(%s)\n",
+	       req,
 	       oldctx, oldctx->cc_vcred.vc_uid, sec2target_str(oldctx->cc_sec),
 	       newctx, newctx->cc_vcred.vc_uid, sec2target_str(newctx->cc_sec),
 	       oldctx->cc_sec, oldctx->cc_sec->ps_policy->sp_name,
@@ -1841,8 +1841,8 @@ int sptlrpc_target_export_check(struct obd_export *exp,
 							req->rq_svc_ctx,
 							&flavor);
 		} else {
-			CDEBUG(D_SEC, "exp %p (%x|%x|%x): is current flavor, "
-			       "install rvs ctx\n", exp, exp->exp_flvr.sf_rpc,
+			CDEBUG(D_SEC, "exp %p (%x|%x|%x): is current flavor, install rvs ctx\n",
+			       exp, exp->exp_flvr.sf_rpc,
 			       exp->exp_flvr_old[0].sf_rpc,
 			       exp->exp_flvr_old[1].sf_rpc);
 			spin_unlock(&exp->exp_lock);
@@ -1855,13 +1855,12 @@ int sptlrpc_target_export_check(struct obd_export *exp,
 	if (exp->exp_flvr_expire[0]) {
 		if (exp->exp_flvr_expire[0] >= get_seconds()) {
 			if (flavor_allowed(&exp->exp_flvr_old[0], req)) {
-				CDEBUG(D_SEC, "exp %p (%x|%x|%x): match the "
-				       "middle one ("CFS_DURATION_T")\n", exp,
+				CDEBUG(D_SEC, "exp %p (%x|%x|%x): match the middle one (" CFS_DURATION_T ")\n", exp,
 				       exp->exp_flvr.sf_rpc,
 				       exp->exp_flvr_old[0].sf_rpc,
 				       exp->exp_flvr_old[1].sf_rpc,
 				       exp->exp_flvr_expire[0] -
-						get_seconds());
+				       get_seconds());
 				spin_unlock(&exp->exp_lock);
 				return 0;
 			}
@@ -1880,13 +1879,13 @@ int sptlrpc_target_export_check(struct obd_export *exp,
 	if (exp->exp_flvr_changed == 0 && exp->exp_flvr_expire[1]) {
 		if (exp->exp_flvr_expire[1] >= get_seconds()) {
 			if (flavor_allowed(&exp->exp_flvr_old[1], req)) {
-				CDEBUG(D_SEC, "exp %p (%x|%x|%x): match the "
-				       "oldest one ("CFS_DURATION_T")\n", exp,
+				CDEBUG(D_SEC, "exp %p (%x|%x|%x): match the oldest one (" CFS_DURATION_T ")\n",
+				       exp,
 				       exp->exp_flvr.sf_rpc,
 				       exp->exp_flvr_old[0].sf_rpc,
 				       exp->exp_flvr_old[1].sf_rpc,
 				       exp->exp_flvr_expire[1] -
-						get_seconds());
+				       get_seconds());
 				spin_unlock(&exp->exp_lock);
 				return 0;
 			}
@@ -1906,8 +1905,7 @@ int sptlrpc_target_export_check(struct obd_export *exp,
 
 	spin_unlock(&exp->exp_lock);
 
-	CWARN("exp %p(%s): req %p (%u|%u|%u|%u|%u|%u) with "
-	      "unauthorized flavor %x, expect %x|%x(%+ld)|%x(%+ld)\n",
+	CWARN("exp %p(%s): req %p (%u|%u|%u|%u|%u|%u) with unauthorized flavor %x, expect %x|%x(%+ld)|%x(%+ld)\n",
 	      exp, exp->exp_obd->obd_name,
 	      req, req->rq_auth_gss, req->rq_ctx_init, req->rq_ctx_fini,
 	      req->rq_auth_usr_root, req->rq_auth_usr_mdt, req->rq_auth_usr_ost,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index cc68a1c..0dabd83 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -772,8 +772,7 @@ void sptlrpc_enc_pool_fini(void)
 
 	if (page_pools.epp_st_access > 0) {
 		CDEBUG(D_SEC,
-		       "max pages %lu, grows %u, grow fails %u, shrinks %u, "
-		       "access %lu, missing %lu, max qlen %u, max wait "
+		       "max pages %lu, grows %u, grow fails %u, shrinks %u, access %lu, missing %lu, max qlen %u, max wait "
 		       CFS_TIME_T"/%d\n",
 		       page_pools.epp_st_max_pages, page_pools.epp_st_grows,
 		       page_pools.epp_st_grow_fails,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
index 3d72b81..a79cd53 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
@@ -938,8 +938,8 @@ int plain_svc_wrap_bulk(struct ptlrpc_request *req,
 	rc = plain_generate_bulk_csum(desc, req->rq_flvr.u_bulk.hash.hash_alg,
 				      tokenv);
 	if (rc) {
-		CERROR("bulk read: server failed to compute "
-		       "checksum: %d\n", rc);
+		CERROR("bulk read: server failed to compute checksum: %d\n",
+		       rc);
 	} else {
 		if (OBD_FAIL_CHECK(OBD_FAIL_OSC_CHECKSUM_RECEIVE))
 			corrupt_bulk_data(desc);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index a8df8a7..635b12b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -580,8 +580,7 @@ ptlrpc_server_nthreads_check(struct ptlrpc_service *svc,
 	svc->srv_nthrs_cpt_init = init;
 
 	if (nthrs * svc->srv_ncpts > tc->tc_nthrs_max) {
-		CDEBUG(D_OTHER, "%s: This service may have more threads (%d) "
-		       "than the given soft limit (%d)\n",
+		CDEBUG(D_OTHER, "%s: This service may have more threads (%d) than the given soft limit (%d)\n",
 		       svc->srv_name, nthrs * svc->srv_ncpts,
 		       tc->tc_nthrs_max);
 	}
@@ -1251,8 +1250,8 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	/* deadline is when the client expects us to reply, margin is the
 	   difference between clients' and servers' expectations */
 	DEBUG_REQ(D_ADAPTTO, req,
-		  "%ssending early reply (deadline %+lds, margin %+lds) for "
-		  "%d+%d", AT_OFF ? "AT off - not " : "",
+		  "%ssending early reply (deadline %+lds, margin %+lds) for %d+%d",
+		  AT_OFF ? "AT off - not " : "",
 		  olddl, olddl - at_get(&svcpt->scp_at_estimate),
 		  at_get(&svcpt->scp_at_estimate), at_extra);
 
@@ -1260,17 +1259,15 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 		return 0;
 
 	if (olddl < 0) {
-		DEBUG_REQ(D_WARNING, req, "Already past deadline (%+lds), "
-			  "not sending early reply. Consider increasing "
-			  "at_early_margin (%d)?", olddl, at_early_margin);
+		DEBUG_REQ(D_WARNING, req, "Already past deadline (%+lds), not sending early reply. Consider increasing at_early_margin (%d)?",
+			  olddl, at_early_margin);
 
 		/* Return an error so we're not re-added to the timed list. */
 		return -ETIMEDOUT;
 	}
 
 	if (!(lustre_msghdr_get_flags(req->rq_reqmsg) & MSGHDR_AT_SUPPORT)) {
-		DEBUG_REQ(D_INFO, req, "Wanted to ask client for more time, "
-			  "but no AT support");
+		DEBUG_REQ(D_INFO, req, "Wanted to ask client for more time, but no AT support");
 		return -ENOSYS;
 	}
 
@@ -1296,8 +1293,7 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 		 * we may be past adaptive_max */
 		if (req->rq_deadline >= req->rq_arrival_time.tv_sec +
 		    at_get(&svcpt->scp_at_estimate)) {
-			DEBUG_REQ(D_WARNING, req, "Couldn't add any time "
-				  "(%ld/%ld), not sending early reply\n",
+			DEBUG_REQ(D_WARNING, req, "Couldn't add any time (%ld/%ld), not sending early reply\n",
 				  olddl, req->rq_arrival_time.tv_sec +
 				  at_get(&svcpt->scp_at_estimate) -
 				  get_seconds());
@@ -1329,8 +1325,7 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	LASSERT(atomic_read(&req->rq_refcount));
 	/** if it is last refcount then early reply isn't needed */
 	if (atomic_read(&req->rq_refcount) == 1) {
-		DEBUG_REQ(D_ADAPTTO, reqcopy, "Normal reply already sent out, "
-			  "abort sending early reply\n");
+		DEBUG_REQ(D_ADAPTTO, reqcopy, "Normal reply already sent out, abort sending early reply\n");
 		rc = -EINVAL;
 		goto out;
 	}
@@ -1454,16 +1449,14 @@ static int ptlrpc_at_check_timed(struct ptlrpc_service_part *svcpt)
 
 	spin_unlock(&svcpt->scp_at_lock);
 
-	CDEBUG(D_ADAPTTO, "timeout in %+ds, asking for %d secs on %d early "
-	       "replies\n", first, at_extra, counter);
+	CDEBUG(D_ADAPTTO, "timeout in %+ds, asking for %d secs on %d early replies\n",
+	       first, at_extra, counter);
 	if (first < 0) {
 		/* We're already past request deadlines before we even get a
 		   chance to send early replies */
-		LCONSOLE_WARN("%s: This server is not able to keep up with "
-			      "request traffic (cpu-bound).\n",
+		LCONSOLE_WARN("%s: This server is not able to keep up with request traffic (cpu-bound).\n",
 			      svcpt->scp_service->srv_name);
-		CWARN("earlyQ=%d reqQ=%d recA=%d, svcEst=%d, "
-		      "delay="CFS_DURATION_T"(jiff)\n",
+		CWARN("earlyQ=%d reqQ=%d recA=%d, svcEst=%d, delay=" CFS_DURATION_T "(jiff)\n",
 		      counter, svcpt->scp_nreqs_incoming,
 		      svcpt->scp_nreqs_active,
 		      at_get(&svcpt->scp_at_estimate), delay);
@@ -1825,8 +1818,7 @@ ptlrpc_server_handle_req_in(struct ptlrpc_service_part *svcpt,
 		if (rc == 0) {
 			rc = sptlrpc_target_export_check(req->rq_export, req);
 			if (rc)
-				DEBUG_REQ(D_ERROR, req, "DROPPING req with "
-					  "illegal security flavor,");
+				DEBUG_REQ(D_ERROR, req, "DROPPING req with illegal security flavor,");
 		}
 
 		if (rc)
@@ -1942,18 +1934,17 @@ ptlrpc_server_handle_request(struct ptlrpc_service_part *svcpt,
 	/* Discard requests queued for longer than the deadline.
 	   The deadline is increased if we send an early reply. */
 	if (get_seconds() > request->rq_deadline) {
-		DEBUG_REQ(D_ERROR, request, "Dropping timed-out request from %s"
-			  ": deadline "CFS_DURATION_T":"CFS_DURATION_T"s ago\n",
+		DEBUG_REQ(D_ERROR, request, "Dropping timed-out request from %s: deadline " CFS_DURATION_T ":" CFS_DURATION_T "s ago\n",
 			  libcfs_id2str(request->rq_peer),
 			  cfs_time_sub(request->rq_deadline,
-			  request->rq_arrival_time.tv_sec),
+				       request->rq_arrival_time.tv_sec),
 			  cfs_time_sub(get_seconds(),
-			  request->rq_deadline));
+				       request->rq_deadline));
 		goto put_conn;
 	}
 
-	CDEBUG(D_RPCTRACE, "Handling RPC pname:cluuid+ref:pid:xid:nid:opc "
-	       "%s:%s+%d:%d:x%llu:%s:%d\n", current_comm(),
+	CDEBUG(D_RPCTRACE, "Handling RPC pname:cluuid+ref:pid:xid:nid:opc %s:%s+%d:%d:x%llu:%s:%d\n",
+	       current_comm(),
 	       (request->rq_export ?
 		(char *)request->rq_export->exp_client_uuid.uuid : "0"),
 	       (request->rq_export ?
@@ -1986,26 +1977,24 @@ put_conn:
 
 	do_gettimeofday(&work_end);
 	timediff = cfs_timeval_sub(&work_end, &work_start, NULL);
-	CDEBUG(D_RPCTRACE, "Handled RPC pname:cluuid+ref:pid:xid:nid:opc "
-	       "%s:%s+%d:%d:x%llu:%s:%d Request processed in "
-	       "%ldus (%ldus total) trans %llu rc %d/%d\n",
-		current_comm(),
-		(request->rq_export ?
-		 (char *)request->rq_export->exp_client_uuid.uuid : "0"),
-		(request->rq_export ?
-		 atomic_read(&request->rq_export->exp_refcount) : -99),
-		lustre_msg_get_status(request->rq_reqmsg),
-		request->rq_xid,
-		libcfs_id2str(request->rq_peer),
-		lustre_msg_get_opc(request->rq_reqmsg),
-		timediff,
-		cfs_timeval_sub(&work_end, &request->rq_arrival_time, NULL),
-		(request->rq_repmsg ?
-		 lustre_msg_get_transno(request->rq_repmsg) :
-		 request->rq_transno),
-		request->rq_status,
-		(request->rq_repmsg ?
-		 lustre_msg_get_status(request->rq_repmsg) : -999));
+	CDEBUG(D_RPCTRACE, "Handled RPC pname:cluuid+ref:pid:xid:nid:opc %s:%s+%d:%d:x%llu:%s:%d Request processed in %ldus (%ldus total) trans %llu rc %d/%d\n",
+	       current_comm(),
+	       (request->rq_export ?
+		(char *)request->rq_export->exp_client_uuid.uuid : "0"),
+	       (request->rq_export ?
+		atomic_read(&request->rq_export->exp_refcount) : -99),
+	       lustre_msg_get_status(request->rq_reqmsg),
+	       request->rq_xid,
+	       libcfs_id2str(request->rq_peer),
+	       lustre_msg_get_opc(request->rq_reqmsg),
+	       timediff,
+	       cfs_timeval_sub(&work_end, &request->rq_arrival_time, NULL),
+	       (request->rq_repmsg ?
+		lustre_msg_get_transno(request->rq_repmsg) :
+		request->rq_transno),
+	       request->rq_status,
+	       (request->rq_repmsg ?
+		lustre_msg_get_status(request->rq_repmsg) : -999));
 	if (likely(svc->srv_stats != NULL && request->rq_reqmsg != NULL)) {
 		__u32 op = lustre_msg_get_opc(request->rq_reqmsg);
 		int opc = opcode_offset(op);
@@ -2557,8 +2546,8 @@ static int ptlrpc_start_hr_threads(void)
 		if (!IS_ERR_VALUE(rc))
 			continue;
 
-		CERROR("Reply handling thread %d:%d Failed on starting: "
-		       "rc = %d\n", i, j, rc);
+		CERROR("Reply handling thread %d:%d Failed on starting: rc = %d\n",
+		       i, j, rc);
 		ptlrpc_stop_hr_threads();
 		return rc;
 	}
@@ -2920,8 +2909,7 @@ ptlrpc_service_unlink_rqbd(struct ptlrpc_service *svc)
 			rc = l_wait_event(svcpt->scp_waitq,
 					  svcpt->scp_nrqbds_posted == 0, &lwi);
 			if (rc == -ETIMEDOUT) {
-				CWARN("Service %s waiting for "
-				      "request buffers\n",
+				CWARN("Service %s waiting for request buffers\n",
 				      svcpt->scp_service->srv_name);
 			}
 			spin_lock(&svcpt->scp_lock);



