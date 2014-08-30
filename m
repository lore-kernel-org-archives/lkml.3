Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaH3UPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:15:20 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14457 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbaH3UPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:15:18 -0400
X-IronPort-AV: E=Sophos;i="5.04,432,1406584800"; 
   d="scan'208";a="92273146"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: adjust spacing within pointer casts
Date: Sat, 30 Aug 2014 22:11:37 +0200
Message-Id: <1409429497-16402-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression e;
@@
 (
- T *
+ T *
 )
 e
// </smpl>

This semantic patch just removes the cast and adds it back, but when it
does so, it follows the spacing conventions of Linux.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This should be applied after the first set of GOTO patches.

 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c          |    4 ++--
 drivers/staging/lustre/lustre/llite/file.c              |    4 ++--
 drivers/staging/lustre/lustre/llite/llite_lib.c         |    2 +-
 drivers/staging/lustre/lustre/llite/lloop.c             |    2 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c      |    2 +-
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/obd_config.c     |    2 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c           |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/connection.c       |    2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 3143222..0cb098e 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -1746,7 +1746,7 @@ ldlm_work_revoke_ast_lock(struct ptlrpc_request_set *rqset, void *opaq)
 	desc.l_req_mode = LCK_EX;
 	desc.l_granted_mode = 0;
 
-	rc = lock->l_blocking_ast(lock, &desc, (void*)arg, LDLM_CB_BLOCKING);
+	rc = lock->l_blocking_ast(lock, &desc, (void *)arg, LDLM_CB_BLOCKING);
 	LDLM_LOCK_RELEASE(lock);
 
 	return rc;
@@ -1775,7 +1775,7 @@ int ldlm_work_gl_ast_lock(struct ptlrpc_request_set *rqset, void *opaq)
 	arg->gl_desc = gl_work->gl_desc;
 
 	/* invoke the actual glimpse callback */
-	if (lock->l_glimpse_ast(lock, (void*)arg) == 0)
+	if (lock->l_glimpse_ast(lock, (void *)arg) == 0)
 		rc = 1;
 
 	LDLM_LOCK_RELEASE(lock);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 531e062..098deaf 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1489,7 +1489,7 @@ static int ll_lov_setea(struct inode *inode, struct file *file,
 	if (lump == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(lump, (struct lov_user_md  *)arg, lum_size)) {
+	if (copy_from_user(lump, (struct lov_user_md *)arg, lum_size)) {
 		OBD_FREE_LARGE(lump, lum_size);
 		return -EFAULT;
 	}
@@ -2323,7 +2323,7 @@ ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (mdtidx < 0)
 			return mdtidx;
 
-		if (put_user((int)mdtidx, (int*)arg))
+		if (put_user((int)mdtidx, (int *)arg))
 			return -EFAULT;
 
 		return 0;
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 5e39e3a..dc87bfe 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -2173,7 +2173,7 @@ int ll_obd_statfs(struct inode *inode, void *arg)
 	if (rc)
 		goto out_statfs;
 
-	data = (void*)buf;
+	data = (void *)buf;
 	if (!data->ioc_inlbuf1 || !data->ioc_inlbuf2 ||
 	    !data->ioc_pbuf1 || !data->ioc_pbuf2) {
 		rc = -EINVAL;
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 177137a..a5a4115 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -705,7 +705,7 @@ static enum llioc_iter lloop_ioctl(struct inode *unused, struct file *file,
 		dev = MKDEV(lloop_major, lo->lo_number);
 
 		/* quit if the used pointer is writable */
-		if (put_user((long)old_encode_dev(dev), (long*)arg)) {
+		if (put_user((long)old_encode_dev(dev), (long *)arg)) {
 			err = -EFAULT;
 			goto out;
 		}
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 701c6a7..b3c16bc 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -208,7 +208,7 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 
 	/* only for debugging */
 	if (cmd == LIBCFS_IOC_DEBUG_MASK) {
-		debug_data = (struct libcfs_debug_ioctl_data*)arg;
+		debug_data = (struct libcfs_debug_ioctl_data *)arg;
 		libcfs_subsystem_debug = debug_data->subs;
 		libcfs_debug = debug_data->debug;
 		return 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 90a1e11..11c7913 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -927,7 +927,7 @@ EXPORT_SYMBOL(lprocfs_rd_num_exports);
 
 int lprocfs_rd_numrefs(struct seq_file *m, void *data)
 {
-	struct obd_type *class = (struct obd_type*) data;
+	struct obd_type *class = (struct obd_type *) data;
 
 	LASSERT(class != NULL);
 	return seq_printf(m, "%d\n", class->typ_refcnt);
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 0d81d32..a88d67d 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1361,7 +1361,7 @@ int class_config_llog_handler(const struct lu_env *env,
 {
 	struct config_llog_instance *clli = data;
 	int cfg_len = rec->lrh_len;
-	char *cfg_buf = (char*) (rec + 1);
+	char *cfg_buf = (char *) (rec + 1);
 	int rc = 0;
 
 	//class_config_dump_handler(handle, rec, data);
diff --git a/drivers/staging/lustre/lustre/osc/osc_quota.c b/drivers/staging/lustre/lustre/osc/osc_quota.c
index db4540a..6987261 100644
--- a/drivers/staging/lustre/lustre/osc/osc_quota.c
+++ b/drivers/staging/lustre/lustre/osc/osc_quota.c
@@ -138,7 +138,7 @@ int osc_quota_setdq(struct client_obd *cli, const unsigned int qid[],
 static unsigned
 oqi_hashfn(struct cfs_hash *hs, const void *key, unsigned mask)
 {
-	return cfs_hash_u32_hash(*((__u32*)key), mask);
+	return cfs_hash_u32_hash(*((__u32 *)key), mask);
 }
 
 static int
diff --git a/drivers/staging/lustre/lustre/ptlrpc/connection.c b/drivers/staging/lustre/lustre/ptlrpc/connection.c
index 62154c4..6f63333 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/connection.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/connection.c
@@ -173,7 +173,7 @@ conn_keycmp(const void *key, struct hlist_node *hnode)
 	const lnet_process_id_t *conn_key;
 
 	LASSERT(key != NULL);
-	conn_key = (lnet_process_id_t*)key;
+	conn_key = (lnet_process_id_t *)key;
 	conn = hlist_entry(hnode, struct ptlrpc_connection, c_hash);
 
 	return conn_key->nid == conn->c_peer.nid &&

