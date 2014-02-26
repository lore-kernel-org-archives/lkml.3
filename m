Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaBZJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:18:21 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48147 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaBZJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:18:14 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, andreas.dilger@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: make functions as static
Date: Wed, 26 Feb 2014 18:17:59 +0900
Message-ID: <3395735.omIA0Togio@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These functions are only referenced in this file scope
so it can be marked static.
And remove space between function name and open parenthesis.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   94 ++++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 644a000..0c333cb 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -41,7 +41,7 @@
 #include "o2iblnd.h"
 #include <asm/div64.h>
 
-lnd_t the_o2iblnd = {
+static lnd_t the_o2iblnd = {
 	.lnd_type       = O2IBLND,
 	.lnd_startup    = kiblnd_startup,
 	.lnd_shutdown   = kiblnd_shutdown,
@@ -53,8 +53,8 @@ lnd_t the_o2iblnd = {
 
 kib_data_t	      kiblnd_data;
 
-__u32
-kiblnd_cksum (void *ptr, int nob)
+static __u32
+kiblnd_cksum(void *ptr, int nob)
 {
 	char  *c  = ptr;
 	__u32  sum = 0;
@@ -368,7 +368,7 @@ kiblnd_create_peer(lnet_ni_t *ni, kib_peer_t **peerp, lnet_nid_t nid)
 }
 
 void
-kiblnd_destroy_peer (kib_peer_t *peer)
+kiblnd_destroy_peer(kib_peer_t *peer)
 {
 	kib_net_t *net = peer->ibp_ni->ni_data;
 
@@ -390,7 +390,7 @@ kiblnd_destroy_peer (kib_peer_t *peer)
 }
 
 kib_peer_t *
-kiblnd_find_peer_locked (lnet_nid_t nid)
+kiblnd_find_peer_locked(lnet_nid_t nid)
 {
 	/* the caller is responsible for accounting the additional reference
 	 * that this creates */
@@ -419,7 +419,7 @@ kiblnd_find_peer_locked (lnet_nid_t nid)
 }
 
 void
-kiblnd_unlink_peer_locked (kib_peer_t *peer)
+kiblnd_unlink_peer_locked(kib_peer_t *peer)
 {
 	LASSERT (list_empty(&peer->ibp_conns));
 
@@ -429,8 +429,8 @@ kiblnd_unlink_peer_locked (kib_peer_t *peer)
 	kiblnd_peer_decref(peer);
 }
 
-int
-kiblnd_get_peer_info (lnet_ni_t *ni, int index,
+static int
+kiblnd_get_peer_info(lnet_ni_t *ni, int index,
 		      lnet_nid_t *nidp, int *count)
 {
 	kib_peer_t	    *peer;
@@ -468,8 +468,8 @@ kiblnd_get_peer_info (lnet_ni_t *ni, int index,
 	return -ENOENT;
 }
 
-void
-kiblnd_del_peer_locked (kib_peer_t *peer)
+static void
+kiblnd_del_peer_locked(kib_peer_t *peer)
 {
 	struct list_head	   *ctmp;
 	struct list_head	   *cnxt;
@@ -489,8 +489,8 @@ kiblnd_del_peer_locked (kib_peer_t *peer)
 	 * last ref on it. */
 }
 
-int
-kiblnd_del_peer (lnet_ni_t *ni, lnet_nid_t nid)
+static int
+kiblnd_del_peer(lnet_ni_t *ni, lnet_nid_t nid)
 {
 	LIST_HEAD	 (zombies);
 	struct list_head	    *ptmp;
@@ -543,8 +543,8 @@ kiblnd_del_peer (lnet_ni_t *ni, lnet_nid_t nid)
 	return rc;
 }
 
-kib_conn_t *
-kiblnd_get_conn_by_idx (lnet_ni_t *ni, int index)
+static kib_conn_t *
+kiblnd_get_conn_by_idx(lnet_ni_t *ni, int index)
 {
 	kib_peer_t	    *peer;
 	struct list_head	    *ptmp;
@@ -584,16 +584,16 @@ kiblnd_get_conn_by_idx (lnet_ni_t *ni, int index)
 	return NULL;
 }
 
-void
-kiblnd_debug_rx (kib_rx_t *rx)
+static void
+kiblnd_debug_rx(kib_rx_t *rx)
 {
 	CDEBUG(D_CONSOLE, "      %p status %d msg_type %x cred %d\n",
 	       rx, rx->rx_status, rx->rx_msg->ibm_type,
 	       rx->rx_msg->ibm_credits);
 }
 
-void
-kiblnd_debug_tx (kib_tx_t *tx)
+static void
+kiblnd_debug_tx(kib_tx_t *tx)
 {
 	CDEBUG(D_CONSOLE, "      %p snd %d q %d w %d rc %d dl %lx "
 	       "cookie "LPX64" msg %s%s type %x cred %d\n",
@@ -604,8 +604,8 @@ kiblnd_debug_tx (kib_tx_t *tx)
 	       tx->tx_msg->ibm_type, tx->tx_msg->ibm_credits);
 }
 
-void
-kiblnd_debug_conn (kib_conn_t *conn)
+static void
+kiblnd_debug_conn(kib_conn_t *conn)
 {
 	struct list_head	*tmp;
 	int		i;
@@ -920,7 +920,7 @@ kiblnd_create_conn(kib_peer_t *peer, struct rdma_cm_id *cmid,
 }
 
 void
-kiblnd_destroy_conn (kib_conn_t *conn)
+kiblnd_destroy_conn(kib_conn_t *conn)
 {
 	struct rdma_cm_id *cmid = conn->ibc_cmid;
 	kib_peer_t	*peer = conn->ibc_peer;
@@ -988,7 +988,7 @@ kiblnd_destroy_conn (kib_conn_t *conn)
 }
 
 int
-kiblnd_close_peer_conns_locked (kib_peer_t *peer, int why)
+kiblnd_close_peer_conns_locked(kib_peer_t *peer, int why)
 {
 	kib_conn_t	     *conn;
 	struct list_head	     *ctmp;
@@ -1011,7 +1011,7 @@ kiblnd_close_peer_conns_locked (kib_peer_t *peer, int why)
 }
 
 int
-kiblnd_close_stale_conns_locked (kib_peer_t *peer,
+kiblnd_close_stale_conns_locked(kib_peer_t *peer,
 				 int version, __u64 incarnation)
 {
 	kib_conn_t	     *conn;
@@ -1039,8 +1039,8 @@ kiblnd_close_stale_conns_locked (kib_peer_t *peer,
 	return count;
 }
 
-int
-kiblnd_close_matching_conns (lnet_ni_t *ni, lnet_nid_t nid)
+static int
+kiblnd_close_matching_conns(lnet_ni_t *ni, lnet_nid_t nid)
 {
 	kib_peer_t	     *peer;
 	struct list_head	     *ptmp;
@@ -1142,7 +1142,7 @@ kiblnd_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 }
 
 void
-kiblnd_query (lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
+kiblnd_query(lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
 {
 	cfs_time_t	last_alive = 0;
 	cfs_time_t	now = cfs_time_current();
@@ -1440,7 +1440,7 @@ kiblnd_find_rd_dma_mr(kib_hca_dev_t *hdev, kib_rdma_desc_t *rd)
 	return mr;
 }
 
-void
+static void
 kiblnd_destroy_fmr_pool(kib_fmr_pool_t *pool)
 {
 	LASSERT (pool->fpo_map_count == 0);
@@ -1454,7 +1454,7 @@ kiblnd_destroy_fmr_pool(kib_fmr_pool_t *pool)
 	LIBCFS_FREE(pool, sizeof(kib_fmr_pool_t));
 }
 
-void
+static void
 kiblnd_destroy_fmr_pool_list(struct list_head *head)
 {
 	kib_fmr_pool_t *pool;
@@ -1480,7 +1480,7 @@ static int kiblnd_fmr_flush_trigger(int ncpts)
 	return max(IBLND_FMR_POOL_FLUSH, size);
 }
 
-int
+static int
 kiblnd_create_fmr_pool(kib_fmr_poolset_t *fps, kib_fmr_pool_t **pp_fpo)
 {
 	/* FMR pool for RDMA */
@@ -1719,7 +1719,7 @@ kiblnd_init_pool(kib_poolset_t *ps, kib_pool_t *pool, int size)
 	pool->po_size     = size;
 }
 
-void
+static void
 kiblnd_destroy_pool_list(struct list_head *head)
 {
 	kib_pool_t *pool;
@@ -2192,7 +2192,7 @@ kiblnd_tx_init(kib_pool_t *pool, struct list_head *node)
 	tx->tx_cookie = tps->tps_next_tx_cookie ++;
 }
 
-void
+static void
 kiblnd_net_fini_pools(kib_net_t *net)
 {
 	int	i;
@@ -2234,7 +2234,7 @@ kiblnd_net_fini_pools(kib_net_t *net)
 	}
 }
 
-int
+static int
 kiblnd_net_init_pools(kib_net_t *net, __u32 *cpts, int ncpts)
 {
 	unsigned long	flags;
@@ -2408,7 +2408,7 @@ kiblnd_hdev_get_attr(kib_hca_dev_t *hdev)
 	return -EINVAL;
 }
 
-void
+static void
 kiblnd_hdev_cleanup_mrs(kib_hca_dev_t *hdev)
 {
 	int     i;
@@ -2442,7 +2442,7 @@ kiblnd_hdev_destroy(kib_hca_dev_t *hdev)
 	LIBCFS_FREE(hdev, sizeof(*hdev));
 }
 
-int
+static int
 kiblnd_hdev_setup_mrs(kib_hca_dev_t *hdev)
 {
 	struct ib_mr *mr;
@@ -2732,7 +2732,7 @@ kiblnd_dev_failover(kib_dev_t *dev)
 }
 
 void
-kiblnd_destroy_dev (kib_dev_t *dev)
+kiblnd_destroy_dev(kib_dev_t *dev)
 {
 	LASSERT (dev->ibd_nnets == 0);
 	LASSERT (list_empty(&dev->ibd_nets));
@@ -2746,7 +2746,7 @@ kiblnd_destroy_dev (kib_dev_t *dev)
 	LIBCFS_FREE(dev, sizeof(*dev));
 }
 
-kib_dev_t *
+static kib_dev_t *
 kiblnd_create_dev(char *ifname)
 {
 	struct net_device *netdev;
@@ -2800,7 +2800,7 @@ kiblnd_create_dev(char *ifname)
 	return dev;
 }
 
-void
+static void
 kiblnd_base_shutdown(void)
 {
 	struct kib_sched_info	*sched;
@@ -2868,7 +2868,7 @@ kiblnd_base_shutdown(void)
 }
 
 void
-kiblnd_shutdown (lnet_ni_t *ni)
+kiblnd_shutdown(lnet_ni_t *ni)
 {
 	kib_net_t	*net = ni->ni_data;
 	rwlock_t     *g_lock = &kiblnd_data.kib_global_lock;
@@ -2940,7 +2940,7 @@ out:
 	return;
 }
 
-int
+static int
 kiblnd_base_startup(void)
 {
 	struct kib_sched_info	*sched;
@@ -3030,7 +3030,7 @@ kiblnd_base_startup(void)
 	return -ENETDOWN;
 }
 
-int
+static int
 kiblnd_start_schedulers(struct kib_sched_info *sched)
 {
 	int	rc = 0;
@@ -3071,7 +3071,7 @@ kiblnd_start_schedulers(struct kib_sched_info *sched)
 	return rc;
 }
 
-int
+static int
 kiblnd_dev_start_threads(kib_dev_t *dev, int newdev, __u32 *cpts, int ncpts)
 {
 	int	cpt;
@@ -3097,7 +3097,7 @@ kiblnd_dev_start_threads(kib_dev_t *dev, int newdev, __u32 *cpts, int ncpts)
 	return 0;
 }
 
-kib_dev_t *
+static kib_dev_t *
 kiblnd_dev_search(char *ifname)
 {
 	kib_dev_t	*alias = NULL;
@@ -3131,7 +3131,7 @@ kiblnd_dev_search(char *ifname)
 }
 
 int
-kiblnd_startup (lnet_ni_t *ni)
+kiblnd_startup(lnet_ni_t *ni)
 {
 	char		     *ifname;
 	kib_dev_t		*ibdev = NULL;
@@ -3226,14 +3226,14 @@ failed:
 	return -ENETDOWN;
 }
 
-void __exit
-kiblnd_module_fini (void)
+static void __exit
+kiblnd_module_fini(void)
 {
 	lnet_unregister_lnd(&the_o2iblnd);
 }
 
-int __init
-kiblnd_module_init (void)
+static int __init
+kiblnd_module_init(void)
 {
 	int    rc;
 
-- 
1.7.9.5

---
