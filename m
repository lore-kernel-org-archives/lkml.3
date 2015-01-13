Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbbANA1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:27:52 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:49646 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbbANA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:27:50 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: lustre: declare internal symbols as static
Date: Tue, 13 Jan 2015 23:33:03 +0100
Message-Id: <1421188383-14216-2-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421188383-14216-1-git-send-email-luca@lucaceresoli.net>
References: <1421188383-14216-1-git-send-email-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes dozens of sparse warnings like:
  warning: symbol 'cfs_tracefile_sem' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lnet/lnet/module.c          |  2 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |  2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |  2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |  2 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  6 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |  2 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |  8 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  2 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        | 24 +++---
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  2 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |  4 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  2 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  4 +-
 drivers/staging/lustre/lustre/llite/file.c         |  3 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        | 87 +++++++++++-----------
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |  4 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 54 +++++++-------
 18 files changed, 110 insertions(+), 102 deletions(-)

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
diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index 5bc6153..fbff84c 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -721,7 +721,7 @@ lst_stat_query_ioctl(lstio_stat_args_t *args)
 	return rc;
 }
 
-int lst_test_add_ioctl(lstio_test_args_t *args)
+static int lst_test_add_ioctl(lstio_test_args_t *args)
 {
 	char		*batch_name;
 	char		*src_name = NULL;
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 9999b0d..77f02b7 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -703,7 +703,7 @@ lstcon_statrpc_prep(lstcon_node_t *nd, unsigned feats, lstcon_rpc_t **crpc)
 	return 0;
 }
 
-lnet_process_id_packed_t *
+static lnet_process_id_packed_t *
 lstcon_next_id(int idx, int nkiov, lnet_kiov_t *kiov)
 {
 	lnet_process_id_packed_t *pid;
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 49cb654..3bb47fa 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -1986,7 +1986,7 @@ static void lstcon_init_acceptor_service(void)
 
 extern int lstcon_ioctl_entry(unsigned int cmd, struct libcfs_ioctl_data *data);
 
-DECLARE_IOCTL_HANDLER(lstcon_ioctl_handler, lstcon_ioctl_entry);
+static DECLARE_IOCTL_HANDLER(lstcon_ioctl_handler, lstcon_ioctl_entry);
 
 /* initialize console */
 int
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
index 0d361ff..571b922 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -269,7 +269,7 @@ int fld_client_del_target(struct lu_client_fld *fld, __u64 idx)
 }
 EXPORT_SYMBOL(fld_client_del_target);
 
-struct proc_dir_entry *fld_type_proc_dir = NULL;
+static struct proc_dir_entry *fld_type_proc_dir = NULL;
 
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
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index a7a7ac6..7170088 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -115,7 +115,7 @@ static wait_queue_head_t debug_ctlwq;
 char libcfs_debug_file_path_arr[PATH_MAX] = LIBCFS_DEBUG_FILE_PATH_DEFAULT;
 
 /* We need to pass a pointer here, but elsewhere this must be a const */
-char *libcfs_debug_file_path;
+static char *libcfs_debug_file_path;
 module_param(libcfs_debug_file_path, charp, 0644);
 MODULE_PARM_DESC(libcfs_debug_file_path,
 		 "Path for dumping debug logs, set 'NONE' to prevent log dumping");
@@ -124,7 +124,7 @@ int libcfs_panic_in_progress;
 
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
+static const char *
 libcfs_debug_subsys2str(int subsys)
 {
 	switch (1 << subsys) {
@@ -185,7 +185,7 @@ libcfs_debug_subsys2str(int subsys)
 
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
+static const char *
 libcfs_debug_dbg2str(int debug)
 {
 	switch (1 << debug) {
@@ -350,7 +350,7 @@ void libcfs_debug_dumplog_internal(void *arg)
 	current->journal_info = journal_info;
 }
 
-int libcfs_debug_dumplog_thread(void *arg)
+static int libcfs_debug_dumplog_thread(void *arg)
 {
 	libcfs_debug_dumplog_internal(arg);
 	wake_up(&debug_ctlwq);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 9515347..277f6b8 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -82,7 +82,7 @@ int cfs_cap_raised(cfs_cap_t cap)
 	return cap_raised(current_cap(), cap);
 }
 
-void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
+static void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 {
 	/* XXX lost high byte */
 	*cap = kcap.cap[0];
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index 83d3f08..c539e37 100644
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
@@ -324,16 +326,18 @@ int proc_console_backoff(struct ctl_table *table, int write,
 	return rc;
 }
 
-int libcfs_force_lbug(struct ctl_table *table, int write, void __user *buffer,
-		      size_t *lenp, loff_t *ppos)
+static int libcfs_force_lbug(struct ctl_table *table, int write,
+			     void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
 {
 	if (write)
 		LBUG();
 	return 0;
 }
 
-int proc_fail_loc(struct ctl_table *table, int write, void __user *buffer,
-		  size_t *lenp, loff_t *ppos)
+static int proc_fail_loc(struct ctl_table *table, int write,
+			 void __user *buffer,
+			 size_t *lenp, loff_t *ppos)
 {
 	int rc;
 	long old_fail_loc = cfs_fail_loc;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index b91a1f9..cd2fc01 100644
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
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 5917c31..d18de04 100644
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
index 1ac7a70..babba60 100644
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
index 35a2df0..ca270f4 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1587,7 +1587,8 @@ ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg)
 	return 0;
 }
 
-int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg)
+static int ll_put_grouplock(struct inode *inode, struct file *file,
+			    unsigned long arg)
 {
 	struct ll_inode_info   *lli = ll_i2info(inode);
 	struct ll_file_data    *fd = LUSTRE_FPRIVATE(file);
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 9f38374..b779f47 100644
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
@@ -1663,10 +1663,10 @@ struct lmv_tgt_desc
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
@@ -2387,9 +2387,9 @@ static int lmv_get_info(const struct lu_env *env, struct obd_export *exp,
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
@@ -2425,8 +2425,8 @@ int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
 	return -EINVAL;
 }
 
-int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
-	       struct lov_stripe_md *lsm)
+static int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
+		      struct lov_stripe_md *lsm)
 {
 	struct obd_device	 *obd = class_exp2obd(exp);
 	struct lmv_obd	    *lmv = &obd->u.lmv;
@@ -2473,8 +2473,8 @@ int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
 	return mea_size;
 }
 
-int lmv_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
-		 struct lov_mds_md *lmm, int lmm_size)
+static int lmv_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
+			struct lov_mds_md *lmm, int lmm_size)
 {
 	struct obd_device	  *obd = class_exp2obd(exp);
 	struct lmv_stripe_md      **tmea = (struct lmv_stripe_md **)lsmp;
@@ -2551,8 +2551,8 @@ static int lmv_cancel_unused(struct obd_export *exp, const struct lu_fid *fid,
 	return rc;
 }
 
-int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
-		      __u64 *bits)
+static int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
+			     __u64 *bits)
 {
 	struct lmv_obd	  *lmv = &exp->exp_obd->u.lmv;
 	int		      rc;
@@ -2561,10 +2561,10 @@ int lmv_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
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
@@ -2594,16 +2594,18 @@ ldlm_mode_t lmv_lock_match(struct obd_export *exp, __u64 flags,
 	return 0;
 }
 
-int lmv_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
-		      struct obd_export *dt_exp, struct obd_export *md_exp,
-		      struct lustre_md *md)
+static int lmv_get_lustre_md(struct obd_export *exp,
+			     struct ptlrpc_request *req,
+			     struct obd_export *dt_exp,
+			     struct obd_export *md_exp,
+			     struct lustre_md *md)
 {
 	struct lmv_obd	  *lmv = &exp->exp_obd->u.lmv;
 
 	return md_get_lustre_md(lmv->tgts[0]->ltd_exp, req, dt_exp, md_exp, md);
 }
 
-int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
+static int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2613,9 +2615,9 @@ int lmv_free_lustre_md(struct obd_export *exp, struct lustre_md *md)
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
@@ -2628,8 +2630,8 @@ int lmv_set_open_replay_data(struct obd_export *exp,
 	return md_set_open_replay_data(tgt->ltd_exp, och, it);
 }
 
-int lmv_clear_open_replay_data(struct obd_export *exp,
-			       struct obd_client_handle *och)
+static int lmv_clear_open_replay_data(struct obd_export *exp,
+				      struct obd_client_handle *och)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2684,17 +2686,18 @@ static int lmv_renew_capa(struct obd_export *exp, struct obd_capa *oc,
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
@@ -2714,8 +2717,8 @@ int lmv_intent_getattr_async(struct obd_export *exp,
 	return rc;
 }
 
-int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
-			struct lu_fid *fid, __u64 *bits)
+static int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
+			       struct lu_fid *fid, __u64 *bits)
 {
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
@@ -2739,8 +2742,8 @@ int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
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
@@ -2786,8 +2789,8 @@ int lmv_quotactl(struct obd_device *unused, struct obd_export *exp,
 	return rc;
 }
 
-int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
-		   struct obd_quotactl *oqctl)
+static int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
+			  struct obd_quotactl *oqctl)
 {
 	struct obd_device   *obd = class_exp2obd(exp);
 	struct lmv_obd      *lmv = &obd->u.lmv;
@@ -2810,7 +2813,7 @@ int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
 	return rc;
 }
 
-struct obd_ops lmv_obd_ops = {
+static struct obd_ops lmv_obd_ops = {
 	.o_owner		= THIS_MODULE,
 	.o_setup		= lmv_setup,
 	.o_cleanup	      = lmv_cleanup,
@@ -2830,7 +2833,7 @@ struct obd_ops lmv_obd_ops = {
 	.o_quotactl	     = lmv_quotactl
 };
 
-struct md_ops lmv_md_ops = {
+static struct md_ops lmv_md_ops = {
 	.m_getstatus	    = lmv_getstatus,
 	.m_null_inode		= lmv_null_inode,
 	.m_find_cbdata	  = lmv_find_cbdata,
@@ -2864,7 +2867,7 @@ struct md_ops lmv_md_ops = {
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
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 3b0f245..478c137 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -855,8 +855,8 @@ static void mdc_close_handle_reply(struct ptlrpc_request *req,
 	}
 }
 
-int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
-	      struct md_open_data *mod, struct ptlrpc_request **request)
+static int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
+		     struct md_open_data *mod, struct ptlrpc_request **request)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -974,8 +974,8 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 	return rc < 0 ? rc : saved_rc;
 }
 
-int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
-		     struct md_open_data *mod)
+static int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
+			    struct md_open_data *mod)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -1044,8 +1044,8 @@ int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
 }
 
 
-int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
-		 struct page **pages, struct ptlrpc_request **request)
+static int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
+			struct page **pages, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request   *req;
 	struct ptlrpc_bulk_desc *desc;
@@ -1974,9 +1974,9 @@ out:
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
@@ -2148,11 +2148,11 @@ static int mdc_kuc_reregister(struct obd_import *imp)
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
@@ -2199,9 +2199,9 @@ int mdc_set_info_async(const struct lu_env *env,
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
 
@@ -2263,8 +2263,8 @@ int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }
 
-int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
-	     struct obd_capa *oc, struct ptlrpc_request **request)
+static int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
+		    struct obd_capa *oc, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -2356,7 +2356,7 @@ int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 	return seq_client_alloc_fid(NULL, seq, fid);
 }
 
-struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
+static struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
 {
 	struct client_obd *cli = &exp->exp_obd->u.cli;
 
@@ -2390,7 +2390,7 @@ static int mdc_resource_inode_free(struct ldlm_resource *res)
 	return 0;
 }
 
-struct ldlm_valblock_ops inode_lvbo = {
+static struct ldlm_valblock_ops inode_lvbo = {
 	.lvbo_free = mdc_resource_inode_free,
 };
 
@@ -2550,9 +2550,9 @@ static int mdc_process_config(struct obd_device *obd, u32 len, void *buf)
 
 
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
@@ -2647,7 +2647,7 @@ static int mdc_renew_capa(struct obd_export *exp, struct obd_capa *oc,
 	return 0;
 }
 
-struct obd_ops mdc_obd_ops = {
+static struct obd_ops mdc_obd_ops = {
 	.o_owner	    = THIS_MODULE,
 	.o_setup	    = mdc_setup,
 	.o_precleanup       = mdc_precleanup,
@@ -2670,7 +2670,7 @@ struct obd_ops mdc_obd_ops = {
 	.o_quotacheck       = mdc_quotacheck
 };
 
-struct md_ops mdc_md_ops = {
+static struct md_ops mdc_md_ops = {
 	.m_getstatus	= mdc_getstatus,
 	.m_null_inode	    = mdc_null_inode,
 	.m_find_cbdata      = mdc_find_cbdata,
@@ -2705,7 +2705,7 @@ struct md_ops mdc_md_ops = {
 	.m_revalidate_lock      = mdc_revalidate_lock
 };
 
-int __init mdc_init(void)
+static int __init mdc_init(void)
 {
 	int rc;
 	struct lprocfs_static_vars lvars = { NULL };
-- 
1.9.1

