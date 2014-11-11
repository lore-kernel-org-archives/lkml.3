Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKKEEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:04:21 -0500
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:50267 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKKEER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:04:17 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2014 23:04:17 EST
Date: Mon, 10 Nov 2014 22:55:26 -0500
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: Fix sparse warnings for static declarations
Message-ID: <20141111035526.GA22436@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the changes are against variables/functions that are only accessed from
within the same file. If the scope needs to change later on, the static keyword
can be removed.

Compile tested.

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
There are 73 such warnings remaining by my last count. They, however, require
moving declarations around etc. As I am not familiar with this driver, and I
didn't want to make a mess of the header files, I'll leave the non-trivial
changes to someone else.

 drivers/staging/lustre/lnet/lnet/module.c          |  2 +-
 drivers/staging/lustre/lnet/lnet/router.c          | 18 ++---
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  6 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |  2 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |  3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     | 16 ++--
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 14 ++--
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  4 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        | 22 +++---
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  2 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |  4 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  | 20 ++---
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  2 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  4 +-
 drivers/staging/lustre/lustre/llite/file.c         |  3 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        | 85 ++++++++++-----------
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |  4 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |  2 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |  8 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        | 24 +++---
 drivers/staging/lustre/lustre/lov/lov_object.c     |  2 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |  2 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |  4 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 88 +++++++++++-----------
 drivers/staging/lustre/lustre/mgc/mgc_request.c    | 15 ++--
 drivers/staging/lustre/lustre/obdclass/cl_object.c |  3 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  6 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    | 14 ++--
 .../lustre/lustre/obdclass/linux/linux-module.c    | 12 +--
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |  7 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        | 10 +--
 drivers/staging/lustre/lustre/obdclass/lu_object.c | 10 +--
 .../staging/lustre/lustre/obdclass/obd_config.c    |  8 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 14 ++--
 .../staging/lustre/lustre/obdecho/echo_client.c    |  4 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      | 10 +--
 drivers/staging/lustre/lustre/osc/osc_object.c     |  4 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  4 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  4 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |  4 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |  2 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    | 15 ++--
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |  2 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |  8 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      | 13 ++--
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  8 +-
 50 files changed, 270 insertions(+), 256 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/module.c b/drivers/staging/lustre/lnet/lnet/module.c
index 3c23677..72b7fbc 100644
--- a/drivers/staging/lustre/lnet/lnet/module.c
+++ b/drivers/staging/lustre/lnet/lnet/module.c
@@ -108,7 +108,7 @@ lnet_ioctl(unsigned int cmd, struct libcfs_ioctl_data *data)
 	}
 }

-DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);
+static DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);

 static int __init
 init_lnet(void)
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index b5b8fb5..778aa77 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -752,7 +752,7 @@ lnet_router_checker_event(lnet_event_t *event)
 	lnet_net_unlock(lp->lp_cpt);
 }

-void
+static void
 lnet_wait_known_routerstate(void)
 {
 	lnet_peer_t	 *rtr;
@@ -784,7 +784,7 @@ lnet_wait_known_routerstate(void)
 	}
 }

-void
+static void
 lnet_update_ni_status_locked(void)
 {
 	lnet_ni_t	*ni;
@@ -824,7 +824,7 @@ lnet_update_ni_status_locked(void)
 	}
 }

-void
+static void
 lnet_destroy_rc_data(lnet_rc_data_t *rcd)
 {
 	LASSERT(list_empty(&rcd->rcd_list));
@@ -845,7 +845,7 @@ lnet_destroy_rc_data(lnet_rc_data_t *rcd)
 	LIBCFS_FREE(rcd, sizeof(*rcd));
 }

-lnet_rc_data_t *
+static lnet_rc_data_t *
 lnet_create_rc_data_locked(lnet_peer_t *gateway)
 {
 	lnet_rc_data_t		*rcd = NULL;
@@ -1224,7 +1224,7 @@ rescan:
 	return 0;
 }

-void
+static void
 lnet_destroy_rtrbuf(lnet_rtrbuf_t *rb, int npages)
 {
 	int sz = offsetof(lnet_rtrbuf_t, rb_kiov[npages]);
@@ -1235,7 +1235,7 @@ lnet_destroy_rtrbuf(lnet_rtrbuf_t *rb, int npages)
 	LIBCFS_FREE(rb, sz);
 }

-lnet_rtrbuf_t *
+static lnet_rtrbuf_t *
 lnet_new_rtrbuf(lnet_rtrbufpool_t *rbp, int cpt)
 {
 	int	    npages = rbp->rbp_npages;
@@ -1270,7 +1270,7 @@ lnet_new_rtrbuf(lnet_rtrbufpool_t *rbp, int cpt)
 	return rb;
 }

-void
+static void
 lnet_rtrpool_free_bufs(lnet_rtrbufpool_t *rbp)
 {
 	int		npages = rbp->rbp_npages;
@@ -1299,7 +1299,7 @@ lnet_rtrpool_free_bufs(lnet_rtrbufpool_t *rbp)
 	rbp->rbp_nbuffers = rbp->rbp_credits = 0;
 }

-int
+static int
 lnet_rtrpool_alloc_bufs(lnet_rtrbufpool_t *rbp, int nbufs, int cpt)
 {
 	lnet_rtrbuf_t *rb;
@@ -1333,7 +1333,7 @@ lnet_rtrpool_alloc_bufs(lnet_rtrbufpool_t *rbp, int nbufs, int cpt)
 	return 0;
 }

-void
+static void
 lnet_rtrpool_init(lnet_rtrbufpool_t *rbp, int npages)
 {
 	INIT_LIST_HEAD(&rbp->rbp_msgs);
diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
index 5d95d0b..0d0a737 100644
--- a/drivers/staging/lustre/lustre/fld/fld_cache.c
+++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
@@ -257,9 +257,9 @@ void fld_cache_flush(struct fld_cache *cache)
  * entry accordingly.
  */

-void fld_cache_punch_hole(struct fld_cache *cache,
-			  struct fld_cache_entry *f_curr,
-			  struct fld_cache_entry *f_new)
+static void fld_cache_punch_hole(struct fld_cache *cache,
+				 struct fld_cache_entry *f_curr,
+				 struct fld_cache_entry *f_new)
 {
 	const struct lu_seq_range *range = &f_new->fce_range;
 	const u64 new_start  = range->lsr_start;
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 0d361ff..7801db0 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -269,7 +269,7 @@ int fld_client_del_target(struct lu_client_fld *fld, __u64 idx)
 }
 EXPORT_SYMBOL(fld_client_del_target);

-struct proc_dir_entry *fld_type_proc_dir = NULL;
+static struct proc_dir_entry *fld_type_proc_dir;

 #if defined (CONFIG_PROC_FS)
 static int fld_client_proc_init(struct lu_client_fld *fld)
diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index 95e7de1..ac9e80c 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -146,7 +146,7 @@ static int fld_proc_cache_flush_release(struct inode *inode, struct file *file)
 	return 0;
 }

-struct file_operations fld_proc_cache_flush_fops = {
+static struct file_operations fld_proc_cache_flush_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fld_proc_cache_flush_open,
 	.write		= fld_proc_cache_flush_write,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index c21e30a..384b096 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -656,7 +656,8 @@ int target_pack_pool_reply(struct ptlrpc_request *req)
 }
 EXPORT_SYMBOL(target_pack_pool_reply);

-int target_send_reply_msg(struct ptlrpc_request *req, int rc, int fail_id)
+static int target_send_reply_msg(struct ptlrpc_request *req, int rc,
+				 int fail_id)
 {
 	if (OBD_FAIL_CHECK_ORSET(fail_id & ~OBD_FAIL_ONCE, OBD_FAIL_ONCE)) {
 		DEBUG_REQ(D_ERROR, req, "dropping reply");
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 6140130..067302c 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -327,7 +327,7 @@ void ldlm_lock_touch_in_lru(struct ldlm_lock *lock)
  * ldlm_lock_destroy, you can never drop your final references on this lock.
  * Because it's not in the hash table anymore.  -phil
  */
-int ldlm_lock_destroy_internal(struct ldlm_lock *lock)
+static int ldlm_lock_destroy_internal(struct ldlm_lock *lock)
 {
 	if (lock->l_readers || lock->l_writers) {
 		LDLM_ERROR(lock, "lock still has references");
@@ -416,7 +416,7 @@ static void lock_handle_free(void *lock, int size)
 	OBD_SLAB_FREE(lock, ldlm_lock_slab, size);
 }

-struct portals_handle_ops lock_handle_ops = {
+static struct portals_handle_ops lock_handle_ops = {
 	.hop_addref = lock_handle_addref,
 	.hop_free   = lock_handle_free,
 };
@@ -627,8 +627,8 @@ EXPORT_SYMBOL(ldlm_lock2desc);
  *
  * Only add if we have not sent a blocking AST to the lock yet.
  */
-void ldlm_add_bl_work_item(struct ldlm_lock *lock, struct ldlm_lock *new,
-			   struct list_head *work_list)
+static void ldlm_add_bl_work_item(struct ldlm_lock *lock, struct ldlm_lock *new,
+				  struct list_head *work_list)
 {
 	if ((lock->l_flags & LDLM_FL_AST_SENT) == 0) {
 		LDLM_DEBUG(lock, "lock incompatible; sending blocking AST.");
@@ -648,7 +648,8 @@ void ldlm_add_bl_work_item(struct ldlm_lock *lock, struct ldlm_lock *new,
 /**
  * Add a lock to list of just granted locks to send completion AST to.
  */
-void ldlm_add_cp_work_item(struct ldlm_lock *lock, struct list_head *work_list)
+static void ldlm_add_cp_work_item(struct ldlm_lock *lock,
+				  struct list_head *work_list)
 {
 	if ((lock->l_flags & LDLM_FL_CP_REQD) == 0) {
 		lock->l_flags |= LDLM_FL_CP_REQD;
@@ -2016,8 +2017,9 @@ struct export_cl_data {
  * Iterator function for ldlm_cancel_locks_for_export.
  * Cancels passed locks.
  */
-int ldlm_cancel_locks_for_export_cb(struct cfs_hash *hs, struct cfs_hash_bd *bd,
-				    struct hlist_node *hnode, void *data)
+static int ldlm_cancel_locks_for_export_cb(struct cfs_hash *hs,
+					   struct cfs_hash_bd *bd,
+					   struct hlist_node *hnode, void *data)

 {
 	struct export_cl_data	*ecl = (struct export_cl_data *)data;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 8b20a83..02fa0aa 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -69,7 +69,7 @@ extern unsigned int ldlm_cancel_unused_locks_before_replay;

 /* during debug dump certain amount of granted locks for one resource to avoid
  * DDOS. */
-unsigned int ldlm_dump_granted_max = 256;
+static unsigned int ldlm_dump_granted_max = 256;

 #if defined (CONFIG_PROC_FS)
 static ssize_t lprocfs_wr_dump_ns(struct file *file, const char *buffer,
@@ -306,7 +306,7 @@ static ssize_t lprocfs_elc_seq_write(struct file *file, const char *buffer,
 }
 LPROC_SEQ_FOPS(lprocfs_elc);

-void ldlm_namespace_proc_unregister(struct ldlm_namespace *ns)
+static void ldlm_namespace_proc_unregister(struct ldlm_namespace *ns)
 {
 	if (ns->ns_proc_dir_entry == NULL)
 		CERROR("dlm namespace %s has no procfs dir?\n",
@@ -326,7 +326,7 @@ void ldlm_namespace_proc_unregister(struct ldlm_namespace *ns)
 		lprocfs_add_vars(ns_pde, lock_vars, NULL);	\
 	} while (0)

-int ldlm_namespace_proc_register(struct ldlm_namespace *ns)
+static int ldlm_namespace_proc_register(struct ldlm_namespace *ns)
 {
 	struct lprocfs_vars lock_vars[2];
 	char lock_name[MAX_STRING_SIZE + 1];
@@ -479,7 +479,7 @@ static void ldlm_res_hop_put(struct cfs_hash *hs, struct hlist_node *hnode)
 	ldlm_resource_putref(res);
 }

-cfs_hash_ops_t ldlm_ns_hash_ops = {
+static cfs_hash_ops_t ldlm_ns_hash_ops = {
 	.hs_hash	= ldlm_res_hop_hash,
 	.hs_key	 = ldlm_res_hop_key,
 	.hs_keycmp      = ldlm_res_hop_keycmp,
@@ -490,7 +490,7 @@ cfs_hash_ops_t ldlm_ns_hash_ops = {
 	.hs_put	 = ldlm_res_hop_put
 };

-cfs_hash_ops_t ldlm_ns_fid_hash_ops = {
+static cfs_hash_ops_t ldlm_ns_fid_hash_ops = {
 	.hs_hash	= ldlm_res_hop_fid_hash,
 	.hs_key	 = ldlm_res_hop_key,
 	.hs_keycmp      = ldlm_res_hop_keycmp,
@@ -511,7 +511,7 @@ struct ldlm_ns_hash_def {
 	cfs_hash_ops_t *nsd_hops;
 };

-struct ldlm_ns_hash_def ldlm_ns_hash_defs[] = {
+static struct ldlm_ns_hash_def ldlm_ns_hash_defs[] = {
 	{
 		.nsd_type       = LDLM_NS_TYPE_MDC,
 		.nsd_bkt_bits   = 11,
@@ -941,7 +941,7 @@ void ldlm_namespace_get(struct ldlm_namespace *ns)
 EXPORT_SYMBOL(ldlm_namespace_get);

 /* This is only for callers that care about refcount */
-int ldlm_namespace_get_return(struct ldlm_namespace *ns)
+static int ldlm_namespace_get_return(struct ldlm_namespace *ns)
 {
 	return atomic_inc_return(&ns->ns_bref);
 }
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index d71ad5e..11379c9 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -82,13 +82,13 @@ int cfs_cap_raised(cfs_cap_t cap)
 	return cap_raised(current_cap(), cap);
 }

-void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
+static void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 {
 	/* XXX lost high byte */
 	*cap = kcap.cap[0];
 }

-void cfs_kernel_cap_unpack(kernel_cap_t *kcap, cfs_cap_t cap)
+static void cfs_kernel_cap_unpack(kernel_cap_t *kcap, cfs_cap_t cap)
 {
 	kcap->cap[0] = cap;
 }
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index 83d3f08..2d72a06 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -232,8 +232,9 @@ static int proc_debug_mb(struct ctl_table *table, int write,
 				 __proc_debug_mb);
 }

-int proc_console_max_delay_cs(struct ctl_table *table, int write,
-			      void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_max_delay_cs(struct ctl_table *table, int write,
+				     void __user *buffer, size_t *lenp,
+				     loff_t *ppos)
 {
 	int rc, max_delay_cs;
 	struct ctl_table dummy = *table;
@@ -264,8 +265,9 @@ int proc_console_max_delay_cs(struct ctl_table *table, int write,
 	return rc;
 }

-int proc_console_min_delay_cs(struct ctl_table *table, int write,
-			      void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_min_delay_cs(struct ctl_table *table, int write,
+				     void __user *buffer, size_t *lenp,
+				     loff_t *ppos)
 {
 	int rc, min_delay_cs;
 	struct ctl_table dummy = *table;
@@ -296,8 +298,8 @@ int proc_console_min_delay_cs(struct ctl_table *table, int write,
 	return rc;
 }

-int proc_console_backoff(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_backoff(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc, backoff;
 	struct ctl_table dummy = *table;
@@ -324,16 +326,16 @@ int proc_console_backoff(struct ctl_table *table, int write,
 	return rc;
 }

-int libcfs_force_lbug(struct ctl_table *table, int write, void __user *buffer,
-		      size_t *lenp, loff_t *ppos)
+static int libcfs_force_lbug(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (write)
 		LBUG();
 	return 0;
 }

-int proc_fail_loc(struct ctl_table *table, int write, void __user *buffer,
-		  size_t *lenp, loff_t *ppos)
+static int proc_fail_loc(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc;
 	long old_fail_loc = cfs_fail_loc;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index 939b33d..43f88b6 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -43,7 +43,7 @@
 /* For sys_open & sys_close */
 #include <linux/syscalls.h>

-int
+static int
 libcfs_sock_ioctl(int cmd, unsigned long arg)
 {
 	mm_segment_t	oldmm = get_fs();
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 2c4fc74..0018f1d 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -42,7 +42,7 @@
 #include "../../include/linux/lnet/lnet.h"
 #include "tracefile.h"

-void
+static void
 kportal_memhog_free (struct libcfs_device_userstate *ldu)
 {
 	struct page **level0p = &ldu->ldu_memhog_root_page;
@@ -86,7 +86,7 @@ kportal_memhog_free (struct libcfs_device_userstate *ldu)
 	LASSERT (ldu->ldu_memhog_pages == 0);
 }

-int
+static int
 kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
 		     gfp_t flags)
 {
diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 47c239f..b9205bc 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -197,16 +197,16 @@ static struct netstrfns  libcfs_netstrfns[] = {
 	{/* .nf_type      */  -1},
 };

-const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);
+static const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);

-int
+static int
 libcfs_lo_str2addr(const char *str, int nob, __u32 *addr)
 {
 	*addr = 0;
 	return 1;
 }

-void
+static void
 libcfs_ip_addr2str(__u32 addr, char *str)
 {
 #if 0   /* never lookup */
@@ -223,7 +223,7 @@ libcfs_ip_addr2str(__u32 addr, char *str)
  * fine, if it doesn't, then the scan ended at the end of the string, which is
  * fine too :) */

-int
+static int
 libcfs_ip_str2addr(const char *str, int nob, __u32 *addr)
 {
 	unsigned int	a;
@@ -244,19 +244,19 @@ libcfs_ip_str2addr(const char *str, int nob, __u32 *addr)
 	return 0;
 }

-void
+static void
 libcfs_decnum_addr2str(__u32 addr, char *str)
 {
 	snprintf(str, LNET_NIDSTR_SIZE, "%u", addr);
 }

-void
+static void
 libcfs_hexnum_addr2str(__u32 addr, char *str)
 {
 	snprintf(str, LNET_NIDSTR_SIZE, "0x%x", addr);
 }

-int
+static int
 libcfs_num_str2addr(const char *str, int nob, __u32 *addr)
 {
 	int     n;
@@ -276,7 +276,7 @@ libcfs_num_str2addr(const char *str, int nob, __u32 *addr)
 	return 0;
 }

-struct netstrfns *
+static struct netstrfns *
 libcfs_lnd2netstrfns(int lnd)
 {
 	int    i;
@@ -289,7 +289,7 @@ libcfs_lnd2netstrfns(int lnd)
 	return NULL;
 }

-struct netstrfns *
+static struct netstrfns *
 libcfs_namenum2netstrfns(const char *name)
 {
 	struct netstrfns *nf;
@@ -304,7 +304,7 @@ libcfs_namenum2netstrfns(const char *name)
 	return NULL;
 }

-struct netstrfns *
+static struct netstrfns *
 libcfs_name2netstrfns(const char *name)
 {
 	int    i;
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 7561030..b22260e 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -55,7 +55,7 @@ static struct tracefiled_ctl trace_tctl;
 struct mutex cfs_trace_thread_mutex;
 static int thread_running = 0;

-atomic_t cfs_tage_allocated = ATOMIC_INIT(0);
+static atomic_t cfs_tage_allocated = ATOMIC_INIT(0);

 static void put_pages_on_tcd_daemon_list(struct page_collection *pc,
 					 struct cfs_trace_cpu_data *tcd);
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index f5ee725..1999bb8 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -652,8 +652,8 @@ static int ll_send_mgc_param(struct obd_export *mgc, char *string)
 	return rc;
 }

-int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
-			char *filename)
+static int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
+			       char *filename)
 {
 	struct ptlrpc_request *request = NULL;
 	struct md_op_data *op_data;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 9f2466b..d35fe3f 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1588,7 +1588,8 @@ ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg)
 	return 0;
 }

-int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg)
+static int ll_put_grouplock(struct inode *inode, struct file *file,
+			    unsigned long arg)
 {
 	struct ll_inode_info   *lli = ll_i2info(inode);
 	struct ll_file_data    *fd = LUSTRE_FPRIVATE(file);
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 9543c15..78ddac7 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -128,7 +128,7 @@ static int lmv_set_mdc_active(struct lmv_obd *lmv, struct obd_uuid *uuid,
 	return rc;
 }

-struct obd_uuid *lmv_get_uuid(struct obd_export *exp)
+static struct obd_uuid *lmv_get_uuid(struct obd_export *exp)
 {
 	struct lmv_obd *lmv = &exp->exp_obd->u.lmv;

@@ -335,7 +335,7 @@ static int lmv_init_ea_size(struct obd_export *exp, int easize,

 #define MAX_STRING_SIZE 128

-int lmv_connect_mdc(struct obd_device *obd, struct lmv_tgt_desc *tgt)
+static int lmv_connect_mdc(struct obd_device *obd, struct lmv_tgt_desc *tgt)
 {
 	struct proc_dir_entry   *lmv_proc_dir;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -1667,10 +1667,10 @@ struct lmv_tgt_desc
 	return tgt;
 }

-int lmv_create(struct obd_export *exp, struct md_op_data *op_data,
-	       const void *data, int datalen, int mode, __u32 uid,
-	       __u32 gid, cfs_cap_t cap_effective, __u64 rdev,
-	       struct ptlrpc_request **request)
+static int lmv_create(struct obd_export *exp, struct md_op_data *op_data,
+		      const void *data, int datalen, int mode, __u32 uid,
+		      __u32 gid, cfs_cap_t cap_effective, __u64 rdev,
+		      struct ptlrpc_request **request)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2391,9 +2391,9 @@ static int lmv_get_info(const struct lu_env *env, struct obd_export *exp,
 	return -EINVAL;
 }

-int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
-		       u32 keylen, void *key, u32 vallen,
-		       void *val, struct ptlrpc_request_set *set)
+static int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
+			      u32 keylen, void *key, u32 vallen,
+			      void *val, struct ptlrpc_request_set *set)
 {
 	struct lmv_tgt_desc    *tgt;
 	struct obd_device      *obd;
@@ -2429,8 +2429,8 @@ int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	return -EINVAL;
 }

-int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
-	       struct lov_stripe_md *lsm)
+static int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
+		      struct lov_stripe_md *lsm)
 {
 	struct obd_device	 *obd = class_exp2obd(exp);
 	struct lmv_obd	    *lmv = &obd->u.lmv;
@@ -2477,8 +2477,8 @@ int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
 	return mea_size;
 }

-int lmv_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
-		 struct lov_mds_md *lmm, int lmm_size)
+static int lmv_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
+			struct lov_mds_md *lmm, int lmm_size)
 {
 	struct obd_device	  *obd = class_exp2obd(exp);
 	struct lmv_stripe_md      **tmea = (struct lmv_stripe_md **)lsmp;
@@ -2555,8 +2555,8 @@ static int lmv_cancel_unused(struct obd_export *exp, const struct lu_fid *fid,
 	return rc;
 }

-int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
-		      __u64 *bits)
+static int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
+			     __u64 *bits)
 {
 	struct lmv_obd	  *lmv = &exp->exp_obd->u.lmv;
 	int		      rc;
@@ -2565,10 +2565,10 @@ int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
 	return rc;
 }

-ldlm_mode_t lmv_lock_match(struct obd_export *exp, __u64 flags,
-			   const struct lu_fid *fid, ldlm_type_t type,
-			   ldlm_policy_data_t *policy, ldlm_mode_t mode,
-			   struct lustre_handle *lockh)
+static ldlm_mode_t lmv_lock_match(struct obd_export *exp, __u64 flags,
+				  const struct lu_fid *fid, ldlm_type_t type,
+				  ldlm_policy_data_t *policy, ldlm_mode_t mode,
+				  struct lustre_handle *lockh)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2598,16 +2598,16 @@ ldlm_mode_t lmv_lock_match(struct obd_export *exp, __u64 flags,
 	return 0;
 }

-int lmv_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
-		      struct obd_export *dt_exp, struct obd_export *md_exp,
-		      struct lustre_md *md)
+static int lmv_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
+			     struct obd_export *dt_exp,
+			     struct obd_export *md_exp, struct lustre_md *md)
 {
 	struct lmv_obd	  *lmv = &exp->exp_obd->u.lmv;

 	return md_get_lustre_md(lmv->tgts[0]->ltd_exp, req, dt_exp, md_exp, md);
 }

-int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
+static int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2617,9 +2617,9 @@ int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
 	return md_free_lustre_md(lmv->tgts[0]->ltd_exp, md);
 }

-int lmv_set_open_replay_data(struct obd_export *exp,
-			     struct obd_client_handle *och,
-			     struct lookup_intent *it)
+static int lmv_set_open_replay_data(struct obd_export *exp,
+				    struct obd_client_handle *och,
+				    struct lookup_intent *it)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2632,8 +2632,8 @@ int lmv_set_open_replay_data(struct obd_export *exp,
 	return md_set_open_replay_data(tgt->ltd_exp, och, it);
 }

-int lmv_clear_open_replay_data(struct obd_export *exp,
-			       struct obd_client_handle *och)
+static int lmv_clear_open_replay_data(struct obd_export *exp,
+				      struct obd_client_handle *och)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2688,17 +2688,18 @@ static int lmv_renew_capa(struct obd_export *exp, struct obd_capa *oc,
 	return rc;
 }

-int lmv_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
-		    const struct req_msg_field *field, struct obd_capa **oc)
+static int lmv_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
+			   const struct req_msg_field *field,
+			   struct obd_capa **oc)
 {
 	struct lmv_obd *lmv = &exp->exp_obd->u.lmv;

 	return md_unpack_capa(lmv->tgts[0]->ltd_exp, req, field, oc);
 }

-int lmv_intent_getattr_async(struct obd_export *exp,
-			     struct md_enqueue_info *minfo,
-			     struct ldlm_enqueue_info *einfo)
+static int lmv_intent_getattr_async(struct obd_export *exp,
+				    struct md_enqueue_info *minfo,
+				    struct ldlm_enqueue_info *einfo)
 {
 	struct md_op_data       *op_data = &minfo->mi_data;
 	struct obd_device       *obd = exp->exp_obd;
@@ -2718,8 +2719,8 @@ int lmv_intent_getattr_async(struct obd_export *exp,
 	return rc;
 }

-int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
-			struct lu_fid *fid, __u64 *bits)
+static int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
+			       struct lu_fid *fid, __u64 *bits)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2743,8 +2744,8 @@ int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
  * process with other slave MDTs. The only exception is Q_GETOQUOTA for which
  * we directly fetch data from the slave MDTs.
  */
-int lmv_quotactl(struct obd_device *unused, struct obd_export *exp,
-		 struct obd_quotactl *oqctl)
+static int lmv_quotactl(struct obd_device *unused, struct obd_export *exp,
+			struct obd_quotactl *oqctl)
 {
 	struct obd_device   *obd = class_exp2obd(exp);
 	struct lmv_obd      *lmv = &obd->u.lmv;
@@ -2790,8 +2791,8 @@ int lmv_quotactl(struct obd_device *unused, struct obd_export *exp,
 	return rc;
 }

-int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
-		   struct obd_quotactl *oqctl)
+static int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
+			  struct obd_quotactl *oqctl)
 {
 	struct obd_device   *obd = class_exp2obd(exp);
 	struct lmv_obd      *lmv = &obd->u.lmv;
@@ -2814,7 +2815,7 @@ int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
 	return rc;
 }

-struct obd_ops lmv_obd_ops = {
+static struct obd_ops lmv_obd_ops = {
 	.o_owner		= THIS_MODULE,
 	.o_setup		= lmv_setup,
 	.o_cleanup	      = lmv_cleanup,
@@ -2834,7 +2835,7 @@ struct obd_ops lmv_obd_ops = {
 	.o_quotactl	     = lmv_quotactl
 };

-struct md_ops lmv_md_ops = {
+static struct md_ops lmv_md_ops = {
 	.m_getstatus	    = lmv_getstatus,
 	.m_null_inode		= lmv_null_inode,
 	.m_find_cbdata	  = lmv_find_cbdata,
@@ -2868,7 +2869,7 @@ struct md_ops lmv_md_ops = {
 	.m_revalidate_lock      = lmv_revalidate_lock
 };

-int __init lmv_init(void)
+static int __init lmv_init(void)
 {
 	struct lprocfs_static_vars lvars;
 	int			rc;
diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index 1170020..5be4176 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -175,7 +175,7 @@ static int lmv_tgt_seq_show(struct seq_file *p, void *v)
 			  tgt->ltd_uuid.uuid, tgt->ltd_active ? "" : "IN");
 }

-struct seq_operations lmv_tgt_sops = {
+static struct seq_operations lmv_tgt_sops = {
 	.start		 = lmv_tgt_seq_start,
 	.stop		  = lmv_tgt_seq_stop,
 	.next		  = lmv_tgt_seq_next,
@@ -199,7 +199,7 @@ static int lmv_target_seq_open(struct inode *inode, struct file *file)

 LPROC_SEQ_FOPS_RO_TYPE(lmv, uuid);

-struct lprocfs_vars lprocfs_lmv_obd_vars[] = {
+static struct lprocfs_vars lprocfs_lmv_obd_vars[] = {
 	{ "numobd",	  &lmv_numobd_fops,	  NULL, 0 },
 	{ "placement",	  &lmv_placement_fops,    NULL, 0 },
 	{ "activeobd",	  &lmv_activeobd_fops,    NULL, 0 },
diff --git a/drivers/staging/lustre/lustre/lov/lov_dev.c b/drivers/staging/lustre/lustre/lov/lov_dev.c
index 796a015..711b837 100644
--- a/drivers/staging/lustre/lustre/lov/lov_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lov_dev.c
@@ -60,7 +60,7 @@ struct kmem_cache *lovsub_req_kmem;
 struct kmem_cache *lov_lock_link_kmem;

 /** Lock class of lov_device::ld_mutex. */
-struct lock_class_key cl_lov_device_mutex_class;
+static struct lock_class_key cl_lov_device_mutex_class;

 struct lu_kmem_descr lov_caches[] = {
 	{
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index 9e21e5e..c00164c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -209,8 +209,8 @@ static int lsm_lmm_verify_v1(struct lov_mds_md_v1 *lmm, int lmm_bytes,
 	return lsm_lmm_verify_common(lmm, lmm_bytes, *stripe_count);
 }

-int lsm_unpackmd_v1(struct lov_obd *lov, struct lov_stripe_md *lsm,
-		    struct lov_mds_md_v1 *lmm)
+static int lsm_unpackmd_v1(struct lov_obd *lov, struct lov_stripe_md *lsm,
+			   struct lov_mds_md_v1 *lmm)
 {
 	struct lov_oinfo *loi;
 	int i;
@@ -287,8 +287,8 @@ static int lsm_lmm_verify_v3(struct lov_mds_md *lmmv1, int lmm_bytes,
 				     *stripe_count);
 }

-int lsm_unpackmd_v3(struct lov_obd *lov, struct lov_stripe_md *lsm,
-		    struct lov_mds_md *lmmv1)
+static int lsm_unpackmd_v3(struct lov_obd *lov, struct lov_stripe_md *lsm,
+			   struct lov_mds_md *lmmv1)
 {
 	struct lov_mds_md_v3 *lmm;
 	struct lov_oinfo *loi;
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 71ad166..dfdb719 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -1605,9 +1605,9 @@ static int lov_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
  * \param fm_end logical end of mapping
  * \param start_stripe starting stripe will be returned in this
  */
-u64 fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
-				   struct lov_stripe_md *lsm, u64 fm_start,
-				   u64 fm_end, int *start_stripe)
+static u64 fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
+				     struct lov_stripe_md *lsm, u64 fm_start,
+				     u64 fm_end, int *start_stripe)
 {
 	u64 local_end = fiemap->fm_extents[0].fe_logical;
 	u64 lun_start, lun_end;
@@ -1662,9 +1662,9 @@ u64 fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
  *
  * \retval last_stripe return the last stripe of the mapping
  */
-int fiemap_calc_last_stripe(struct lov_stripe_md *lsm, u64 fm_start,
-			    u64 fm_end, int start_stripe,
-			    int *stripe_count)
+static int fiemap_calc_last_stripe(struct lov_stripe_md *lsm, u64 fm_start,
+				   u64 fm_end, int start_stripe,
+				   int *stripe_count)
 {
 	int last_stripe;
 	u64 obd_start, obd_end;
@@ -1698,10 +1698,10 @@ int fiemap_calc_last_stripe(struct lov_stripe_md *lsm, u64 fm_start,
  * \param ext_count number of extents to be copied
  * \param current_extent where to start copying in main extent array
  */
-void fiemap_prepare_and_copy_exts(struct ll_user_fiemap *fiemap,
-				  struct ll_fiemap_extent *lcl_fm_ext,
-				  int ost_index, unsigned int ext_count,
-				  int current_extent)
+static void fiemap_prepare_and_copy_exts(struct ll_user_fiemap *fiemap,
+					 struct ll_fiemap_extent *lcl_fm_ext,
+					 int ost_index, unsigned int ext_count,
+					 int current_extent)
 {
 	char *to;
 	int ext;
@@ -2294,7 +2294,7 @@ out:
 	return rc;
 }

-struct obd_ops lov_obd_ops = {
+static struct obd_ops lov_obd_ops = {
 	.o_owner	       = THIS_MODULE,
 	.o_setup	       = lov_setup,
 	.o_precleanup	  = lov_precleanup,
@@ -2328,7 +2328,7 @@ struct obd_ops lov_obd_ops = {

 struct kmem_cache *lov_oinfo_slab;

-int __init lov_init(void)
+static int __init lov_init(void)
 {
 	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index 4cab730..d69a035 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -563,7 +563,7 @@ static const struct lov_layout_operations lov_dispatch[] = {
 /**
  * Return lov_layout_type associated with a given lsm
  */
-enum lov_layout_type lov_type(struct lov_stripe_md *lsm)
+static enum lov_layout_type lov_type(struct lov_stripe_md *lsm)
 {
 	if (lsm == NULL)
 		return LLT_EMPTY;
diff --git a/drivers/staging/lustre/lustre/lov/lov_pool.c b/drivers/staging/lustre/lustre/lov/lov_pool.c
index 0e0ea60..d96163d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pool.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pool.c
@@ -71,7 +71,7 @@ void lov_pool_putref(struct pool_desc *pool)
 	}
 }

-void lov_pool_putref_locked(struct pool_desc *pool)
+static void lov_pool_putref_locked(struct pool_desc *pool)
 {
 	CDEBUG(D_INFO, "pool %p\n", pool);
 	LASSERT(atomic_read(&pool->pool_refcount) > 1);
diff --git a/drivers/staging/lustre/lustre/lov/lproc_lov.c b/drivers/staging/lustre/lustre/lov/lproc_lov.c
index c993f25..66774c9 100644
--- a/drivers/staging/lustre/lustre/lov/lproc_lov.c
+++ b/drivers/staging/lustre/lustre/lov/lproc_lov.c
@@ -229,7 +229,7 @@ static int lov_tgt_seq_show(struct seq_file *p, void *v)
 			  tgt->ltd_active ? "" : "IN");
 }

-struct seq_operations lov_tgt_sops = {
+static struct seq_operations lov_tgt_sops = {
 	.start = lov_tgt_seq_start,
 	.stop = lov_tgt_seq_stop,
 	.next = lov_tgt_seq_next,
@@ -258,7 +258,7 @@ LPROC_SEQ_FOPS_RO_TYPE(lov, kbytestotal);
 LPROC_SEQ_FOPS_RO_TYPE(lov, kbytesfree);
 LPROC_SEQ_FOPS_RO_TYPE(lov, kbytesavail);

-struct lprocfs_vars lprocfs_lov_obd_vars[] = {
+static struct lprocfs_vars lprocfs_lov_obd_vars[] = {
 	{ "uuid",	  &lov_uuid_fops,	  NULL, 0 },
 	{ "stripesize",   &lov_stripesize_fops,   NULL },
 	{ "stripeoffset", &lov_stripeoffset_fops, NULL },
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index 16341c8..36e257c 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -143,7 +143,7 @@ static ssize_t mdc_kuc_write(struct file *file, const char *buffer,
 	return count;
 }

-struct file_operations mdc_kuc_fops = {
+static struct file_operations mdc_kuc_fops = {
 	.open		= mdc_kuc_open,
 	.write		= mdc_kuc_write,
 	.release	= single_release,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 14e1ba1..d953afe 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -60,8 +60,9 @@ struct mdc_renew_capa_args {

 static int mdc_cleanup(struct obd_device *obd);

-int mdc_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
-		    const struct req_msg_field *field, struct obd_capa **oc)
+static int mdc_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
+			   const struct req_msg_field *field,
+			   struct obd_capa **oc)
 {
 	struct lustre_capa *capa;
 	struct obd_capa *c;
@@ -147,8 +148,8 @@ out:
 }

 /* This should be mdc_get_info("rootfid") */
-int mdc_getstatus(struct obd_export *exp, struct lu_fid *rootfid,
-		  struct obd_capa **pc)
+static int mdc_getstatus(struct obd_export *exp, struct lu_fid *rootfid,
+			 struct obd_capa **pc)
 {
 	return send_getstatus(class_exp2cliimp(exp), rootfid, pc,
 			      LUSTRE_IMP_FULL, 0);
@@ -214,8 +215,8 @@ static int mdc_getattr_common(struct obd_export *exp,
 	return 0;
 }

-int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
-		struct ptlrpc_request **request)
+static int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
+		       struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -258,8 +259,8 @@ int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
 	return rc;
 }

-int mdc_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
-		     struct ptlrpc_request **request)
+static int mdc_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
+			    struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -441,10 +442,11 @@ static int mdc_xattr_common(struct obd_export *exp,
 	return rc;
 }

-int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
-		 struct obd_capa *oc, u64 valid, const char *xattr_name,
-		 const char *input, int input_size, int output_size,
-		 int flags, __u32 suppgid, struct ptlrpc_request **request)
+static int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
+			struct obd_capa *oc, u64 valid, const char *xattr_name,
+			const char *input, int input_size, int output_size,
+			int flags, __u32 suppgid,
+			struct ptlrpc_request **request)
 {
 	return mdc_xattr_common(exp, &RQF_MDS_REINT_SETXATTR,
 				fid, oc, MDS_REINT, valid, xattr_name,
@@ -452,10 +454,10 @@ int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
 				suppgid, request);
 }

-int mdc_getxattr(struct obd_export *exp, const struct lu_fid *fid,
-		 struct obd_capa *oc, u64 valid, const char *xattr_name,
-		 const char *input, int input_size, int output_size,
-		 int flags, struct ptlrpc_request **request)
+static int mdc_getxattr(struct obd_export *exp, const struct lu_fid *fid,
+			struct obd_capa *oc, u64 valid, const char *xattr_name,
+			const char *input, int input_size, int output_size,
+			int flags, struct ptlrpc_request **request)
 {
 	return mdc_xattr_common(exp, &RQF_MDS_GETXATTR,
 				fid, oc, MDS_GETXATTR, valid, xattr_name,
@@ -855,8 +857,8 @@ static void mdc_close_handle_reply(struct ptlrpc_request *req,
 	}
 }

-int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
-	      struct md_open_data *mod, struct ptlrpc_request **request)
+static int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
+		     struct md_open_data *mod, struct ptlrpc_request **request)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -974,8 +976,8 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 	return rc < 0 ? rc : saved_rc;
 }

-int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
-		     struct md_open_data *mod)
+static int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
+			    struct md_open_data *mod)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -1044,8 +1046,8 @@ int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
 }


-int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
-		 struct page **pages, struct ptlrpc_request **request)
+static int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
+			struct page **pages, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request   *req;
 	struct ptlrpc_bulk_desc *desc;
@@ -1974,9 +1976,9 @@ out:
 	return rc;
 }

-int mdc_get_info_rpc(struct obd_export *exp,
-		     u32 keylen, void *key,
-		     int vallen, void *val)
+static int mdc_get_info_rpc(struct obd_export *exp,
+			    u32 keylen, void *key,
+			    int vallen, void *val)
 {
 	struct obd_import      *imp = class_exp2cliimp(exp);
 	struct ptlrpc_request  *req;
@@ -2148,11 +2150,11 @@ static int mdc_kuc_reregister(struct obd_import *imp)
 					 (void *)imp);
 }

-int mdc_set_info_async(const struct lu_env *env,
-		       struct obd_export *exp,
-		       u32 keylen, void *key,
-		       u32 vallen, void *val,
-		       struct ptlrpc_request_set *set)
+static int mdc_set_info_async(const struct lu_env *env,
+			      struct obd_export *exp,
+			      u32 keylen, void *key,
+			      u32 vallen, void *val,
+			      struct ptlrpc_request_set *set)
 {
 	struct obd_import	*imp = class_exp2cliimp(exp);
 	int			 rc;
@@ -2199,9 +2201,9 @@ int mdc_set_info_async(const struct lu_env *env,
 	return -EINVAL;
 }

-int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
-		 __u32 keylen, void *key, __u32 *vallen, void *val,
-		 struct lov_stripe_md *lsm)
+static int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
+			__u32 keylen, void *key, __u32 *vallen, void *val,
+			struct lov_stripe_md *lsm)
 {
 	int rc = -EINVAL;

@@ -2263,8 +2265,8 @@ int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }

-int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
-	     struct obd_capa *oc, struct ptlrpc_request **request)
+static int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
+		    struct obd_capa *oc, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -2356,7 +2358,7 @@ int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 	return seq_client_alloc_fid(NULL, seq, fid);
 }

-struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
+static struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
 {
 	struct client_obd *cli = &exp->exp_obd->u.cli;

@@ -2390,7 +2392,7 @@ static int mdc_resource_inode_free(struct ldlm_resource *res)
 	return 0;
 }

-struct ldlm_valblock_ops inode_lvbo = {
+static struct ldlm_valblock_ops inode_lvbo = {
 	.lvbo_free = mdc_resource_inode_free,
 };

@@ -2550,9 +2552,9 @@ static int mdc_process_config(struct obd_device *obd, u32 len, void *buf)


 /* get remote permission for current user on fid */
-int mdc_get_remote_perm(struct obd_export *exp, const struct lu_fid *fid,
-			struct obd_capa *oc, __u32 suppgid,
-			struct ptlrpc_request **request)
+static int mdc_get_remote_perm(struct obd_export *exp, const struct lu_fid *fid,
+			       struct obd_capa *oc, __u32 suppgid,
+			       struct ptlrpc_request **request)
 {
 	struct ptlrpc_request  *req;
 	int		    rc;
@@ -2647,7 +2649,7 @@ static int mdc_renew_capa(struct obd_export *exp, struct obd_capa *oc,
 	return 0;
 }

-struct obd_ops mdc_obd_ops = {
+static struct obd_ops mdc_obd_ops = {
 	.o_owner	    = THIS_MODULE,
 	.o_setup	    = mdc_setup,
 	.o_precleanup       = mdc_precleanup,
@@ -2670,7 +2672,7 @@ struct obd_ops mdc_obd_ops = {
 	.o_quotacheck       = mdc_quotacheck
 };

-struct md_ops mdc_md_ops = {
+static struct md_ops mdc_md_ops = {
 	.m_getstatus	= mdc_getstatus,
 	.m_null_inode	    = mdc_null_inode,
 	.m_find_cbdata      = mdc_find_cbdata,
@@ -2705,7 +2707,7 @@ struct md_ops mdc_md_ops = {
 	.m_revalidate_lock      = mdc_revalidate_lock
 };

-int __init mdc_init(void)
+static int __init mdc_init(void)
 {
 	int rc;
 	struct lprocfs_static_vars lvars = { NULL };
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index bbef5c9..a992e79 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -95,7 +95,8 @@ int mgc_fsname2resid(char *fsname, struct ldlm_res_id *res_id, int type)
 }
 EXPORT_SYMBOL(mgc_fsname2resid);

-int mgc_logname2resid(char *logname, struct ldlm_res_id *res_id, int type)
+static int mgc_logname2resid(char *logname, struct ldlm_res_id *res_id,
+			     int type)
 {
 	char *name_end;
 	int len;
@@ -377,7 +378,7 @@ out_err:
 	return rc;
 }

-DEFINE_MUTEX(llog_process_lock);
+static DEFINE_MUTEX(llog_process_lock);

 /** Stop watching for updates on this log.
  */
@@ -952,9 +953,9 @@ static int mgc_target_register(struct obd_export *exp,
 	return rc;
 }

-int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
-		       u32 keylen, void *key, u32 vallen,
-		       void *val, struct ptlrpc_request_set *set)
+static int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
+			      u32 keylen, void *key, u32 vallen,
+			      void *val, struct ptlrpc_request_set *set)
 {
 	int rc = -EINVAL;

@@ -1712,7 +1713,7 @@ out:
 	return rc;
 }

-struct obd_ops mgc_obd_ops = {
+static struct obd_ops mgc_obd_ops = {
 	.o_owner	= THIS_MODULE,
 	.o_setup	= mgc_setup,
 	.o_precleanup   = mgc_precleanup,
@@ -1729,7 +1730,7 @@ struct obd_ops mgc_obd_ops = {
 	.o_process_config = mgc_process_config,
 };

-int __init mgc_init(void)
+static int __init mgc_init(void)
 {
 	return class_register_type(&mgc_obd_ops, NULL, NULL,
 				   LUSTRE_MGC_NAME, NULL);
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index ce96bd2..9ce3f71 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -386,7 +386,8 @@ void cache_stats_init(struct cache_stats *cs, const char *name)
 		atomic_set(&cs->cs_stats[i], 0);
 }

-int cache_stats_print(const struct cache_stats *cs, struct seq_file *m, int h)
+static int cache_stats_print(const struct cache_stats *cs, struct seq_file *m,
+			     int h)
 {
 	int i;
 	/*
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 7265ecb..eb9bf7d 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -61,7 +61,7 @@ __u64 obd_alloc;
 EXPORT_SYMBOL(obd_alloc);
 __u64 obd_pages;
 EXPORT_SYMBOL(obd_pages);
-DEFINE_SPINLOCK(obd_updatemax_lock);
+static DEFINE_SPINLOCK(obd_updatemax_lock);

 /* The following are visible and mutable through /proc/sys/lustre/. */
 unsigned int obd_alloc_fail_rate = 0;
@@ -170,7 +170,7 @@ static inline void obd_conn2data(struct obd_ioctl_data *data,
 	data->ioc_cookie = conn->cookie;
 }

-int class_resolve_dev_name(__u32 len, const char *name)
+static int class_resolve_dev_name(__u32 len, const char *name)
 {
 	int rc;
 	int dev;
@@ -442,7 +442,7 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 extern struct miscdevice obd_psdev;

 #define OBD_INIT_CHECK
-int obd_init_checks(void)
+static int obd_init_checks(void)
 {
 	__u64 u64val, div64val;
 	char buf[64];
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index ac8db2f..2e6d61d 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -46,14 +46,14 @@
 extern struct list_head obd_types;
 spinlock_t obd_types_lock;

-struct kmem_cache *obd_device_cachep;
+static struct kmem_cache *obd_device_cachep;
 struct kmem_cache *obdo_cachep;
 EXPORT_SYMBOL(obdo_cachep);
-struct kmem_cache *import_cachep;
+static struct kmem_cache *import_cachep;

-struct list_head      obd_zombie_imports;
-struct list_head      obd_zombie_exports;
-spinlock_t  obd_zombie_impexp_lock;
+static struct list_head      obd_zombie_imports;
+static struct list_head      obd_zombie_exports;
+static spinlock_t  obd_zombie_impexp_lock;
 static void obd_zombie_impexp_notify(void);
 static void obd_zombie_export_add(struct obd_export *exp);
 static void obd_zombie_import_add(struct obd_import *imp);
@@ -930,7 +930,7 @@ void class_unlink_export(struct obd_export *exp)
 EXPORT_SYMBOL(class_unlink_export);

 /* Import management functions */
-void class_import_destroy(struct obd_import *imp)
+static void class_import_destroy(struct obd_import *imp)
 {
 	CDEBUG(D_IOCTL, "destroying import %p for %s\n", imp,
 		imp->imp_obd->obd_name);
@@ -1128,7 +1128,7 @@ int class_connect(struct lustre_handle *conn, struct obd_device *obd,
 EXPORT_SYMBOL(class_connect);

 /* if export is involved in recovery then clean up related things */
-void class_export_recovery_cleanup(struct obd_export *exp)
+static void class_export_recovery_cleanup(struct obd_export *exp)
 {
 	struct obd_device *obd = exp->exp_obd;

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 66ceab2..d6f6dee 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -73,7 +73,7 @@
 #include "../../include/lustre_ver.h"
 #include "../../include/lustre/lustre_build_version.h"

-int proc_version;
+static int proc_version;

 /* buffer MUST be at least the size of obd_ioctl_hdr */
 int obd_ioctl_getdata(char **buf, int *len, void *arg)
@@ -213,7 +213,7 @@ struct miscdevice obd_psdev = {


 #if defined (CONFIG_PROC_FS)
-int obd_proc_version_seq_show(struct seq_file *m, void *v)
+static int obd_proc_version_seq_show(struct seq_file *m, void *v)
 {
 	return seq_printf(m, "lustre: %s\nkernel: %s\nbuild:  %s\n",
 			LUSTRE_VERSION_STRING, "patchless_client",
@@ -221,7 +221,7 @@ int obd_proc_version_seq_show(struct seq_file *m, void *v)
 }
 LPROC_SEQ_FOPS_RO(obd_proc_version);

-int obd_proc_pinger_seq_show(struct seq_file *m, void *v)
+static int obd_proc_pinger_seq_show(struct seq_file *m, void *v)
 {
 	return seq_printf(m, "%s\n", "on");
 }
@@ -321,7 +321,7 @@ LPROC_SEQ_FOPS(obd_proc_jobid_name);
 struct proc_dir_entry *proc_lustre_root = NULL;
 EXPORT_SYMBOL(proc_lustre_root);

-struct lprocfs_vars lprocfs_base[] = {
+static struct lprocfs_vars lprocfs_base[] = {
 	{ "version", &obd_proc_version_fops },
 	{ "pinger", &obd_proc_pinger_fops },
 	{ "health_check", &obd_proc_health_fops },
@@ -379,7 +379,7 @@ static int obd_device_list_seq_show(struct seq_file *p, void *v)
 			  atomic_read(&obd->obd_refcount));
 }

-struct seq_operations obd_device_list_sops = {
+static struct seq_operations obd_device_list_sops = {
 	.start = obd_device_list_seq_start,
 	.stop = obd_device_list_seq_stop,
 	.next = obd_device_list_seq_next,
@@ -400,7 +400,7 @@ static int obd_device_list_open(struct inode *inode, struct file *file)
 	return 0;
 }

-struct file_operations obd_device_list_fops = {
+static struct file_operations obd_device_list_fops = {
 	.owner   = THIS_MODULE,
 	.open    = obd_device_list_open,
 	.read    = seq_read,
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_cat.c b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
index 6e139cf..e0f15d7 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_cat.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
@@ -527,8 +527,9 @@ int llog_cat_cancel_records(const struct lu_env *env,
 }
 EXPORT_SYMBOL(llog_cat_cancel_records);

-int llog_cat_process_cb(const struct lu_env *env, struct llog_handle *cat_llh,
-			struct llog_rec_hdr *rec, void *data)
+static int llog_cat_process_cb(const struct lu_env *env,
+			       struct llog_handle *cat_llh,
+			       struct llog_rec_hdr *rec, void *data)
 {
 	struct llog_process_data *d = data;
 	struct llog_logid_rec *lir = (struct llog_logid_rec *)rec;
@@ -692,7 +693,7 @@ int llog_cat_reverse_process(const struct lu_env *env,
 }
 EXPORT_SYMBOL(llog_cat_reverse_process);

-int llog_cat_set_first_idx(struct llog_handle *cathandle, int index)
+static int llog_cat_set_first_idx(struct llog_handle *cathandle, int index)
 {
 	struct llog_log_hdr *llh = cathandle->lgh_hdr;
 	int i, bitmap_size, idx;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 686bc18..2edbd49 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1256,7 +1256,7 @@ static int lprocfs_stats_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }

-struct file_operations lprocfs_stats_seq_fops = {
+static struct file_operations lprocfs_stats_seq_fops = {
 	.owner   = THIS_MODULE,
 	.open    = lprocfs_stats_seq_open,
 	.read    = seq_read,
@@ -1538,8 +1538,8 @@ void lprocfs_init_ldlm_stats(struct lprocfs_stats *ldlm_stats)
 }
 EXPORT_SYMBOL(lprocfs_init_ldlm_stats);

-int lprocfs_exp_print_uuid(struct cfs_hash *hs, struct cfs_hash_bd *bd,
-			   struct hlist_node *hnode, void *data)
+static int lprocfs_exp_print_uuid(struct cfs_hash *hs, struct cfs_hash_bd *bd,
+				  struct hlist_node *hnode, void *data)

 {
 	struct obd_export *exp = cfs_hash_object(hs, hnode);
@@ -1569,8 +1569,8 @@ struct exp_hash_cb_data {
 	bool		first;
 };

-int lprocfs_exp_print_hash(struct cfs_hash *hs, struct cfs_hash_bd *bd,
-			   struct hlist_node *hnode, void *cb_data)
+static int lprocfs_exp_print_hash(struct cfs_hash *hs, struct cfs_hash_bd *bd,
+				  struct hlist_node *hnode, void *cb_data)

 {
 	struct exp_hash_cb_data *data = (struct exp_hash_cb_data *)cb_data;
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 2fc037c..e2c817a 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -427,7 +427,7 @@ LU_KEY_INIT_FINI(lu_global, struct lu_cdebug_data);
  * Key, holding temporary buffer. This key is registered very early by
  * lu_global_init().
  */
-struct lu_context_key lu_global_key = {
+static struct lu_context_key lu_global_key = {
 	.lct_tags = LCT_MD_THREAD | LCT_DT_THREAD |
 		    LCT_MG_THREAD | LCT_CL_THREAD | LCT_LOCAL,
 	.lct_init = lu_global_key_init,
@@ -942,7 +942,7 @@ static void lu_obj_hop_put_locked(struct cfs_hash *hs, struct hlist_node *hnode)
 	LBUG(); /* we should never called it */
 }

-cfs_hash_ops_t lu_site_hash_ops = {
+static cfs_hash_ops_t lu_site_hash_ops = {
 	.hs_hash	= lu_obj_hop_hash,
 	.hs_key	 = lu_obj_hop_key,
 	.hs_keycmp      = lu_obj_hop_keycmp,
@@ -1912,13 +1912,13 @@ static unsigned long lu_cache_shrink_scan(struct shrinker *sk,
 /**
  * Environment to be used in debugger, contains all tags.
  */
-struct lu_env lu_debugging_env;
+static struct lu_env lu_debugging_env;

 /**
  * Debugging printer function using printk().
  */
-int lu_printk_printer(const struct lu_env *env,
-		      void *unused, const char *format, ...)
+static int lu_printk_printer(const struct lu_env *env,
+			     void *unused, const char *format, ...)
 {
 	va_list args;

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 47213a9..3913fd6 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -804,7 +804,7 @@ EXPORT_SYMBOL(class_add_conn);

 /** Remove a failover nid location.
  */
-int class_del_conn(struct obd_device *obd, struct lustre_cfg *lcfg)
+static int class_del_conn(struct obd_device *obd, struct lustre_cfg *lcfg)
 {
 	struct obd_import *imp;
 	struct obd_uuid uuid;
@@ -833,7 +833,7 @@ int class_del_conn(struct obd_device *obd, struct lustre_cfg *lcfg)
 	return rc;
 }

-LIST_HEAD(lustre_profile_list);
+static LIST_HEAD(lustre_profile_list);

 struct lustre_profile *class_get_profile(const char *prof)
 {
@@ -852,8 +852,8 @@ EXPORT_SYMBOL(class_get_profile);
  * This defines the mdc and osc names to use for a client.
  * This also is used to define the lov to be used by a mdt.
  */
-int class_add_profile(int proflen, char *prof, int osclen, char *osc,
-		      int mdclen, char *mdc)
+static int class_add_profile(int proflen, char *prof, int osclen, char *osc,
+			     int mdclen, char *mdc)
 {
 	struct lustre_profile *lprof;
 	int err = 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 1260c87..ea389ee 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -200,7 +200,7 @@ int lustre_start_simple(char *obdname, char *type, char *uuid,
 	return rc;
 }

-DEFINE_MUTEX(mgc_start_lock);
+static DEFINE_MUTEX(mgc_start_lock);

 /** Set up a mgc obd to process startup logs
  *
@@ -553,7 +553,7 @@ out:

 /***************** lustre superblock **************/

-struct lustre_sb_info *lustre_init_lsi(struct super_block *sb)
+static struct lustre_sb_info *lustre_init_lsi(struct super_block *sb)
 {
 	struct lustre_sb_info *lsi;

@@ -1195,7 +1195,7 @@ struct lustre_mount_data2 {
  * and this is where we start setting things up.
  * @param data Mount options (e.g. -o flock,abort_recov)
  */
-int lustre_fill_super(struct super_block *sb, void *data, int silent)
+static int lustre_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct lustre_mount_data *lmd;
 	struct lustre_mount_data2 *lmd2 = data;
@@ -1286,8 +1286,8 @@ void lustre_register_kill_super_cb(void (*cfs)(struct super_block *sb))
 EXPORT_SYMBOL(lustre_register_kill_super_cb);

 /***************** FS registration ******************/
-struct dentry *lustre_mount(struct file_system_type *fs_type, int flags,
-				const char *devname, void *data)
+static struct dentry *lustre_mount(struct file_system_type *fs_type, int flags,
+				   const char *devname, void *data)
 {
 	struct lustre_mount_data2 lmd2 = {
 		.lmd2_data = data,
@@ -1297,7 +1297,7 @@ struct dentry *lustre_mount(struct file_system_type *fs_type, int flags,
 	return mount_nodev(fs_type, flags, &lmd2, lustre_fill_super);
 }

-void lustre_kill_super(struct super_block *sb)
+static void lustre_kill_super(struct super_block *sb)
 {
 	struct lustre_sb_info *lsi = s2lsi(sb);

@@ -1309,7 +1309,7 @@ void lustre_kill_super(struct super_block *sb)

 /** Register the "lustre" fs type
  */
-struct file_system_type lustre_fs_type = {
+static struct file_system_type lustre_fs_type = {
 	.owner	= THIS_MODULE,
 	.name	 = "lustre",
 	.mount	= lustre_mount,
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index a6ad875..7ea28e7 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -2131,7 +2131,7 @@ static struct obd_ops echo_client_obd_ops = {
 	.o_disconnect  = echo_client_disconnect
 };

-int echo_client_init(void)
+static int echo_client_init(void)
 {
 	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
@@ -2150,7 +2150,7 @@ int echo_client_init(void)
 	return rc;
 }

-void echo_client_exit(void)
+static void echo_client_exit(void)
 {
 	class_unregister_type(LUSTRE_ECHO_CLIENT_NAME);
 	lu_kmem_fini(echo_caches);
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index ec04935..9d3a6e0 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -581,9 +581,9 @@ static inline int overlapped(struct osc_extent *ex1, struct osc_extent *ex2)
  * Find or create an extent which includes @index, core function to manage
  * extent tree.
  */
-struct osc_extent *osc_extent_find(const struct lu_env *env,
-				   struct osc_object *obj, pgoff_t index,
-				   int *grants)
+static struct osc_extent *osc_extent_find(const struct lu_env *env,
+					  struct osc_object *obj, pgoff_t index,
+					  int *grants)

 {
 	struct client_obd *cli = osc_cli(obj);
@@ -1374,8 +1374,8 @@ static void __osc_unreserve_grant(struct client_obd *cli,
 	}
 }

-void osc_unreserve_grant(struct client_obd *cli,
-			 unsigned int reserved, unsigned int unused)
+static void osc_unreserve_grant(struct client_obd *cli,
+				unsigned int reserved, unsigned int unused)
 {
 	client_obd_list_lock(&cli->cl_loi_list_lock);
 	__osc_unreserve_grant(cli, reserved, unused);
diff --git a/drivers/staging/lustre/lustre/osc/osc_object.c b/drivers/staging/lustre/lustre/osc/osc_object.c
index 6900058..359a34fe 100644
--- a/drivers/staging/lustre/lustre/osc/osc_object.c
+++ b/drivers/staging/lustre/lustre/osc/osc_object.c
@@ -160,8 +160,8 @@ static int osc_attr_get(const struct lu_env *env, struct cl_object *obj,
 	return 0;
 }

-int osc_attr_set(const struct lu_env *env, struct cl_object *obj,
-		 const struct cl_attr *attr, unsigned valid)
+static int osc_attr_set(const struct lu_env *env, struct cl_object *obj,
+			const struct cl_attr *attr, unsigned valid)
 {
 	struct lov_oinfo *oinfo = cl2osc(obj)->oo_oinfo;
 	struct ost_lvb   *lvb   = &oinfo->loi_lvb;
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index fcd079b..7b3578e 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -439,8 +439,8 @@ static void osc_page_delete(const struct lu_env *env,
 	osc_lru_del(osc_cli(obj), opg, true);
 }

-void osc_page_clip(const struct lu_env *env, const struct cl_page_slice *slice,
-		   int from, int to)
+static void osc_page_clip(const struct lu_env *env,
+			  const struct cl_page_slice *slice, int from, int to)
 {
 	struct osc_page       *opg = cl2osc_page(slice);
 	struct osc_async_page *oap = &opg->ops_oap;
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index ca16c08..aca461f 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -3303,7 +3303,7 @@ static int osc_process_config(struct obd_device *obd, u32 len, void *buf)
 	return osc_process_config_base(obd, buf);
 }

-struct obd_ops osc_obd_ops = {
+static struct obd_ops osc_obd_ops = {
 	.o_owner		= THIS_MODULE,
 	.o_setup		= osc_setup,
 	.o_precleanup	   = osc_precleanup,
@@ -3337,7 +3337,7 @@ extern struct lu_kmem_descr osc_caches[];
 extern spinlock_t osc_ast_guard;
 extern struct lock_class_key osc_ast_guard_class;

-int __init osc_init(void)
+static int __init osc_init(void)
 {
 	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 38cc931..0b07443 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -379,7 +379,7 @@ static int ptlrpc_at_recv_early_reply(struct ptlrpc_request *req)
 	return rc;
 }

-struct kmem_cache *request_cache;
+static struct kmem_cache *request_cache;

 int ptlrpc_request_cache_init(void)
 {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index 32dfffa..8d3ad2a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -486,7 +486,7 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
 	return rc;
 }

-void ptlrpc_ni_fini(void)
+static void ptlrpc_ni_fini(void)
 {
 	wait_queue_head_t	 waitq;
 	struct l_wait_info  lwi;
@@ -530,7 +530,7 @@ lnet_pid_t ptl_get_pid(void)
 	return pid;
 }

-int ptlrpc_ni_init(void)
+static int ptlrpc_ni_init(void)
 {
 	int	      rc;
 	lnet_pid_t       pid;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 78364ec..a2950dc 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -2002,7 +2002,7 @@ static void *__req_capsule_get(struct req_capsule *pill,
 /**
  * Dump a request and/or reply
  */
-void __req_capsule_dump(struct req_capsule *pill, enum req_location loc)
+static void __req_capsule_dump(struct req_capsule *pill, enum req_location loc)
 {
 	const struct    req_format *fmt;
 	const struct    req_msg_field *field;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 0c3f667..8bc4541 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -45,7 +45,7 @@
 #include "ptlrpc_internal.h"


-struct ll_rpc_opcode {
+static struct ll_rpc_opcode {
 	__u32       opcode;
 	const char *opname;
 } ll_rpc_opcode_table[LUSTRE_MAX_OPCODES] = {
@@ -136,7 +136,7 @@ struct ll_rpc_opcode {
 	{ UPDATE_OBJ,	    "update_obj" },
 };

-struct ll_eopcode {
+static struct ll_eopcode {
 	__u32       opcode;
 	const char *opname;
 } ll_eopcode_table[EXTRA_LAST_OPC] = {
@@ -175,15 +175,16 @@ const char *ll_opcode2str(__u32 opcode)
 	return ll_rpc_opcode_table[offset].opname;
 }

-const char *ll_eopcode2str(__u32 opcode)
+static const char *ll_eopcode2str(__u32 opcode)
 {
 	LASSERT(ll_eopcode_table[opcode].opcode == opcode);
 	return ll_eopcode_table[opcode].opname;
 }
 #if defined (CONFIG_PROC_FS)
-void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
-			     char *name, struct proc_dir_entry **procroot_ret,
-			     struct lprocfs_stats **stats_ret)
+static void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
+				    char *name,
+				    struct proc_dir_entry **procroot_ret,
+				    struct lprocfs_stats **stats_ret)
 {
 	struct proc_dir_entry *svc_procroot;
 	struct lprocfs_stats *svc_stats;
@@ -723,7 +724,7 @@ struct ptlrpc_srh_iterator {
 	struct ptlrpc_request	*srhi_req;
 };

-int
+static int
 ptlrpc_lprocfs_svc_req_history_seek(struct ptlrpc_service_part *svcpt,
 				    struct ptlrpc_srh_iterator *srhi,
 				    __u64 seq)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index 181301b..96f6ba2 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -54,7 +54,7 @@ extern struct list_head ptlrpc_all_services;
 /**
  * NRS core object.
  */
-struct nrs_core nrs_core;
+static struct nrs_core nrs_core;

 static int nrs_policy_init(struct ptlrpc_nrs_policy *policy)
 {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 60552f4..c195043 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -437,8 +437,8 @@ void *lustre_msg_buf(struct lustre_msg *m, int n, int min_size)
 }
 EXPORT_SYMBOL(lustre_msg_buf);

-int lustre_shrink_msg_v2(struct lustre_msg_v2 *msg, int segment,
-			 unsigned int newlen, int move_data)
+static int lustre_shrink_msg_v2(struct lustre_msg_v2 *msg, int segment,
+				unsigned int newlen, int move_data)
 {
 	char   *tail = NULL, *newpos;
 	int     tail_len = 0, n;
@@ -1979,7 +1979,7 @@ void lustre_swab_fid2path(struct getinfo_fid2path *gf)
 }
 EXPORT_SYMBOL(lustre_swab_fid2path);

-void lustre_swab_fiemap_extent(struct ll_fiemap_extent *fm_extent)
+static void lustre_swab_fiemap_extent(struct ll_fiemap_extent *fm_extent)
 {
 	__swab64s(&fm_extent->fe_logical);
 	__swab64s(&fm_extent->fe_physical);
@@ -2458,7 +2458,7 @@ void lustre_swab_hsm_state_set(struct hsm_state_set *hss)
 }
 EXPORT_SYMBOL(lustre_swab_hsm_state_set);

-void lustre_swab_hsm_extent(struct hsm_extent *extent)
+static void lustre_swab_hsm_extent(struct hsm_extent *extent)
 {
 	__swab64s(&extent->offset);
 	__swab64s(&extent->length);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index b9cbbbd5..2f9787e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -91,7 +91,7 @@ int ptlrpc_obd_ping(struct obd_device *obd)
 }
 EXPORT_SYMBOL(ptlrpc_obd_ping);

-int ptlrpc_ping(struct obd_import *imp)
+static int ptlrpc_ping(struct obd_import *imp)
 {
 	struct ptlrpc_request *req;

@@ -110,7 +110,7 @@ int ptlrpc_ping(struct obd_import *imp)
 	return 0;
 }

-void ptlrpc_update_next_ping(struct obd_import *imp, int soon)
+static void ptlrpc_update_next_ping(struct obd_import *imp, int soon)
 {
 	int time = soon ? PING_INTERVAL_SHORT : PING_INTERVAL;
 	if (imp->imp_state == LUSTRE_IMP_DISCON) {
@@ -141,7 +141,7 @@ static inline int ptlrpc_next_reconnect(struct obd_import *imp)
 		return cfs_time_shift(obd_timeout);
 }

-long pinger_check_timeout(unsigned long time)
+static long pinger_check_timeout(unsigned long time)
 {
 	struct timeout_item *item;
 	unsigned long timeout = PING_INTERVAL;
@@ -428,8 +428,9 @@ EXPORT_SYMBOL(ptlrpc_pinger_del_import);
  * Register a timeout callback to the pinger list, and the callback will
  * be called when timeout happens.
  */
-struct timeout_item *ptlrpc_new_timeout(int time, enum timeout_event event,
-					timeout_cb_t cb, void *data)
+static struct timeout_item *ptlrpc_new_timeout(int time,
+					       enum timeout_event event,
+					       timeout_cb_t cb, void *data)
 {
 	struct timeout_item *ti;

@@ -554,7 +555,7 @@ void ptlrpc_pinger_wake_up(void)
 static int	       pet_refcount = 0;
 static int	       pet_state;
 static wait_queue_head_t       pet_waitq;
-LIST_HEAD(pet_list);
+static LIST_HEAD(pet_list);
 static DEFINE_SPINLOCK(pet_lock);

 int ping_evictor_wake(struct obd_export *exp)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
index 5268887..deef36f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
@@ -51,7 +51,7 @@ extern spinlock_t ptlrpc_rs_debug_lock;
 extern struct mutex pinger_mutex;
 extern struct mutex ptlrpcd_mutex;

-__init int ptlrpc_init(void)
+static __init int ptlrpc_init(void)
 {
 	int rc, cleanup_phase = 0;

diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index a8df8a7..56c420e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -69,7 +69,7 @@ LIST_HEAD(ptlrpc_all_services);
 /** Used to protect the \e ptlrpc_all_services list */
 struct mutex ptlrpc_all_services_mutex;

-struct ptlrpc_request_buffer_desc *
+static struct ptlrpc_request_buffer_desc *
 ptlrpc_alloc_rqbd(struct ptlrpc_service_part *svcpt)
 {
 	struct ptlrpc_service		  *svc = svcpt->scp_service;
@@ -99,7 +99,7 @@ ptlrpc_alloc_rqbd(struct ptlrpc_service_part *svcpt)
 	return rqbd;
 }

-void
+static void
 ptlrpc_free_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 {
 	struct ptlrpc_service_part *svcpt = rqbd->rqbd_svcpt;
@@ -116,7 +116,7 @@ ptlrpc_free_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 	OBD_FREE_PTR(rqbd);
 }

-int
+static int
 ptlrpc_grow_req_bufs(struct ptlrpc_service_part *svcpt, int post)
 {
 	struct ptlrpc_service		  *svc = svcpt->scp_service;
@@ -3067,7 +3067,7 @@ EXPORT_SYMBOL(ptlrpc_unregister_service);
  * Right now, it just checks to make sure that requests aren't languishing
  * in the queue.  We'll use this health check to govern whether a node needs
  * to be shot, so it's intentionally non-aggressive. */
-int ptlrpc_svcpt_health_check(struct ptlrpc_service_part *svcpt)
+static int ptlrpc_svcpt_health_check(struct ptlrpc_service_part *svcpt)
 {
 	struct ptlrpc_request		*request = NULL;
 	struct timeval			right_now;
--
2.1.2

