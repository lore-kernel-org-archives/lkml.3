Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaIVOmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:42:01 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:42165 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaIVOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:40:37 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "open brace '{' following struct go on the same line" errors
Date: Mon, 22 Sep 2014 09:39:53 -0500
Message-Id: <1411396793-28322-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "open brace '{' following struct go on the same line" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_private.h   |  3 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    | 66 ++++++++--------------
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    | 24 +++-----
 3 files changed, 31 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
index 82a269c..2817112 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -453,8 +453,7 @@ int	 cfs_match_nid(lnet_nid_t nid, struct list_head *list);
  * Support for temporary event tracing with minimal Heisenberg effect.
  * -------------------------------------------------------------------- */
 
-struct libcfs_device_userstate
-{
+struct libcfs_device_userstate {
 	int	   ldu_memhog_pages;
 	struct page   *ldu_memhog_root_page;
 };
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index 4306d98..b02b4ec 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -79,8 +79,7 @@
 #define IBLND_N_SCHED			2
 #define IBLND_N_SCHED_HIGH		4
 
-typedef struct
-{
+typedef struct {
 	int	      *kib_dev_failover;     /* HCA failover */
 	unsigned int     *kib_service;	  /* IB service number */
 	int	      *kib_min_reconnect_interval; /* first failed connection retry... */
@@ -186,8 +185,7 @@ struct kib_hca_dev;
 #define KIB_IFNAME_SIZE	      256
 #endif
 
-typedef struct
-{
+typedef struct {
 	struct list_head	   ibd_list;	  /* chain on kib_devs */
 	struct list_head	   ibd_fail_list;     /* chain on kib_failed_devs */
 	__u32		ibd_ifip;	  /* IPoIB interface IP */
@@ -203,8 +201,7 @@ typedef struct
 	struct kib_hca_dev  *ibd_hdev;
 } kib_dev_t;
 
-typedef struct kib_hca_dev
-{
+typedef struct kib_hca_dev {
 	struct rdma_cm_id   *ibh_cmid;	  /* listener cmid */
 	struct ib_device    *ibh_ibdev;	 /* IB device */
 	int		  ibh_page_shift;    /* page shift of current HCA */
@@ -224,8 +221,7 @@ typedef struct kib_hca_dev
 /** # of seconds to retry if allocation failed */
 #define IBLND_POOL_RETRY	1
 
-typedef struct
-{
+typedef struct {
 	int		     ibp_npages;	     /* # pages */
 	struct page	    *ibp_pages[0];	   /* page array */
 } kib_pages_t;
@@ -254,8 +250,7 @@ struct kib_net;
 
 #define IBLND_POOL_NAME_LEN     32
 
-typedef struct kib_poolset
-{
+typedef struct kib_poolset {
 	spinlock_t		ps_lock;		/* serialize */
 	struct kib_net	 *ps_net;		 /* network it belongs to */
 	char		    ps_name[IBLND_POOL_NAME_LEN]; /* pool set name */
@@ -272,8 +267,7 @@ typedef struct kib_poolset
 	kib_ps_node_fini_t      ps_node_fini;	   /* finalize node */
 } kib_poolset_t;
 
-typedef struct kib_pool
-{
+typedef struct kib_pool {
 	struct list_head	      po_list;		/* chain on pool list */
 	struct list_head	      po_free_list;	   /* pre-allocated node */
 	kib_poolset_t	  *po_owner;	       /* pool_set of this pool */
@@ -304,8 +298,7 @@ typedef struct kib_pmr_pool {
 	kib_pool_t	      ppo_pool;	       /* pool */
 } kib_pmr_pool_t;
 
-typedef struct
-{
+typedef struct {
 	spinlock_t		fps_lock;		/* serialize */
 	struct kib_net	 *fps_net;		/* IB network */
 	struct list_head	      fps_pool_list;	  /* FMR pool list */
@@ -320,8 +313,7 @@ typedef struct
 	unsigned long		fps_next_retry;
 } kib_fmr_poolset_t;
 
-typedef struct
-{
+typedef struct {
 	struct list_head	      fpo_list;	       /* chain on pool list */
 	struct kib_hca_dev     *fpo_hdev;	       /* device for this pool */
 	kib_fmr_poolset_t      *fpo_owner;	      /* owner of this pool */
@@ -336,8 +328,7 @@ typedef struct {
 	kib_fmr_pool_t	 *fmr_pool;	       /* pool of FMR */
 } kib_fmr_t;
 
-typedef struct kib_net
-{
+typedef struct kib_net {
 	struct list_head	   ibn_list;	  /* chain on kib_dev_t::ibd_nets */
 	__u64		ibn_incarnation;   /* my epoch */
 	int		  ibn_init;	  /* initialisation state */
@@ -372,8 +363,7 @@ struct kib_sched_info {
 	int			ibs_cpt;	/* CPT id */
 };
 
-typedef struct
-{
+typedef struct {
 	int			kib_init;	/* initialisation state */
 	int			kib_shutdown;	/* shut down? */
 	struct list_head		kib_devs;	/* IB devices extant */
@@ -411,60 +401,51 @@ typedef struct
  * These are sent in sender's byte order (i.e. receiver flips).
  */
 
-typedef struct kib_connparams
-{
+typedef struct kib_connparams {
 	__u16	     ibcp_queue_depth;
 	__u16	     ibcp_max_frags;
 	__u32	     ibcp_max_msg_size;
 } WIRE_ATTR kib_connparams_t;
 
-typedef struct
-{
+typedef struct {
 	lnet_hdr_t	ibim_hdr;	     /* portals header */
 	char	      ibim_payload[0];      /* piggy-backed payload */
 } WIRE_ATTR kib_immediate_msg_t;
 
-typedef struct
-{
+typedef struct {
 	__u32	     rf_nob;	       /* # bytes this frag */
 	__u64	     rf_addr;	      /* CAVEAT EMPTOR: misaligned!! */
 } WIRE_ATTR kib_rdma_frag_t;
 
-typedef struct
-{
+typedef struct {
 	__u32	     rd_key;	       /* local/remote key */
 	__u32	     rd_nfrags;	    /* # fragments */
 	kib_rdma_frag_t   rd_frags[0];	  /* buffer frags */
 } WIRE_ATTR kib_rdma_desc_t;
 
-typedef struct
-{
+typedef struct {
 	lnet_hdr_t	ibprm_hdr;	    /* portals header */
 	__u64	     ibprm_cookie;	 /* opaque completion cookie */
 } WIRE_ATTR kib_putreq_msg_t;
 
-typedef struct
-{
+typedef struct {
 	__u64	     ibpam_src_cookie;     /* reflected completion cookie */
 	__u64	     ibpam_dst_cookie;     /* opaque completion cookie */
 	kib_rdma_desc_t   ibpam_rd;	     /* sender's sink buffer */
 } WIRE_ATTR kib_putack_msg_t;
 
-typedef struct
-{
+typedef struct {
 	lnet_hdr_t	ibgm_hdr;	     /* portals header */
 	__u64	     ibgm_cookie;	  /* opaque completion cookie */
 	kib_rdma_desc_t   ibgm_rd;	      /* rdma descriptor */
 } WIRE_ATTR kib_get_msg_t;
 
-typedef struct
-{
+typedef struct {
 	__u64	     ibcm_cookie;	  /* opaque completion cookie */
 	__s32	     ibcm_status;	  /* < 0 failure: >= 0 length */
 } WIRE_ATTR kib_completion_msg_t;
 
-typedef struct
-{
+typedef struct {
 	/* First 2 fields fixed FOR ALL TIME */
 	__u32	     ibm_magic;	    /* I'm an ibnal message */
 	__u16	     ibm_version;	  /* this is my version number */
@@ -574,14 +555,12 @@ typedef struct kib_tx			   /* transmit message */
 	int		       tx_dmadir;    /* dma direction */
 } kib_tx_t;
 
-typedef struct kib_connvars
-{
+typedef struct kib_connvars {
 	/* connection-in-progress variables */
 	kib_msg_t		 cv_msg;
 } kib_connvars_t;
 
-typedef struct kib_conn
-{
+typedef struct kib_conn {
 	struct kib_sched_info *ibc_sched;	/* scheduler information */
 	struct kib_peer     *ibc_peer;	  /* owning peer */
 	kib_hca_dev_t       *ibc_hdev;	  /* HCA bound on */
@@ -629,8 +608,7 @@ typedef struct kib_conn
 #define IBLND_CONN_CLOSING	    4	 /* being closed */
 #define IBLND_CONN_DISCONNECTED       5	 /* disconnected */
 
-typedef struct kib_peer
-{
+typedef struct kib_peer {
 	struct list_head	   ibp_list;	   /* stash on global peer list */
 	lnet_nid_t	   ibp_nid;	    /* who's on the other end(s) */
 	lnet_ni_t	   *ibp_ni;	     /* LNet interface */
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
index f7cce9d..a29d4da 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
@@ -93,8 +93,7 @@ typedef struct				  /* in-use interface */
 	char		ksni_name[IFNAMSIZ];	/* interface name */
 } ksock_interface_t;
 
-typedef struct
-{
+typedef struct {
 	/* "stuck" socket timeout (seconds) */
 	int	      *ksnd_timeout;
 	/* # scheduler threads in each pool while starting */
@@ -126,8 +125,7 @@ typedef struct
 	int	      *ksnd_zc_recv_min_nfrags; /* minimum # of fragments to enable ZC receive */
 } ksock_tunables_t;
 
-typedef struct
-{
+typedef struct {
 	__u64		  ksnn_incarnation;	/* my epoch */
 	spinlock_t	  ksnn_lock;		/* serialise */
 	struct list_head	  ksnn_list;		/* chain on global list */
@@ -142,8 +140,7 @@ typedef struct
 /** reserved thread for accepting & creating new connd */
 #define SOCKNAL_CONND_RESV     1
 
-typedef struct
-{
+typedef struct {
 	int			ksnd_init;	/* initialisation state */
 	int			ksnd_nnets;	/* # networks set up */
 	struct list_head		ksnd_nets;	/* list of nets */
@@ -257,8 +254,7 @@ typedef union {
 #define SOCKNAL_RX_LNET_PAYLOAD 5	       /* reading lnet payload (to deliver here) */
 #define SOCKNAL_RX_SLOP	 6	       /* skipping body */
 
-typedef struct ksock_conn
-{
+typedef struct ksock_conn {
 	struct ksock_peer  *ksnc_peer;	 /* owning peer */
 	struct ksock_route *ksnc_route;	/* owning route */
 	struct list_head	  ksnc_list;	 /* stash on peer's conn list */
@@ -313,8 +309,7 @@ typedef struct ksock_conn
 	unsigned long	    ksnc_tx_last_post;  /* time stamp of the last posted TX */
 } ksock_conn_t;
 
-typedef struct ksock_route
-{
+typedef struct ksock_route {
 	struct list_head	    ksnr_list;	/* chain on peer route list */
 	struct list_head	    ksnr_connd_list;  /* chain on ksnr_connd_routes */
 	struct ksock_peer    *ksnr_peer;	/* owning peer */
@@ -334,8 +329,7 @@ typedef struct ksock_route
 
 #define SOCKNAL_KEEPALIVE_PING	  1       /* cookie for keepalive ping */
 
-typedef struct ksock_peer
-{
+typedef struct ksock_peer {
 	struct list_head	    ksnp_list;	/* stash on global peer list */
 	unsigned long	    ksnp_last_alive;  /* when (in jiffies) I was last alive */
 	lnet_process_id_t     ksnp_id;       /* who's on the other end(s) */
@@ -358,8 +352,7 @@ typedef struct ksock_peer
 	__u32		 ksnp_passive_ips[LNET_MAX_INTERFACES]; /* preferred local interfaces */
 } ksock_peer_t;
 
-typedef struct ksock_connreq
-{
+typedef struct ksock_connreq {
 	struct list_head	    ksncr_list;     /* stash on ksnd_connd_connreqs */
 	lnet_ni_t	    *ksncr_ni;       /* chosen NI */
 	struct socket	 *ksncr_sock;     /* accepted socket */
@@ -372,8 +365,7 @@ extern ksock_tunables_t ksocknal_tunables;
 #define SOCKNAL_MATCH_YES       1	/* TX matches type of connection */
 #define SOCKNAL_MATCH_MAY       2	/* TX can be sent on the connection, but not preferred */
 
-typedef struct ksock_proto
-{
+typedef struct ksock_proto {
 	int	   pro_version;					      /* version number of protocol */
 	int	 (*pro_send_hello)(ksock_conn_t *, ksock_hello_msg_t *);     /* handshake function */
 	int	 (*pro_recv_hello)(ksock_conn_t *, ksock_hello_msg_t *, int);/* handshake function */
-- 
1.9.1

