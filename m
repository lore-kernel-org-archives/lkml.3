Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaHUQIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:08:41 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:59676 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaHUQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:08:38 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: lustre: Fix "foo * bar" should be "foo *bar" errors
Date: Thu, 21 Aug 2014 11:07:42 -0500
Message-Id: <1408637262-20591-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "foo * bar" should be "foo *bar" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre/lustre_user.h |  4 ++--
 drivers/staging/lustre/lustre/include/lustre_net.h         |  2 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h         |  4 ++--
 drivers/staging/lustre/lustre/include/obd_class.h          | 12 ++++++------
 drivers/staging/lustre/lustre/llite/llite_internal.h       |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c            |  4 ++--
 drivers/staging/lustre/lustre/llite/llite_mmap.c           |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/import.c              |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/nrs.c                 |  6 +++---
 drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c            |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c                 |  6 +++---
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c            |  2 +-
 12 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 4c1b3cb..5a31304 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1111,7 +1111,7 @@ static inline int cfs_size_round (int val)
 #endif
 
 /* Return pointer to first hai in action list */
-static inline struct hsm_action_item * hai_zero(struct hsm_action_list *hal)
+static inline struct hsm_action_item *hai_zero(struct hsm_action_list *hal)
 {
 	return (struct hsm_action_item *)(hal->hal_fsname +
 					  cfs_size_round(strlen(hal-> \
@@ -1119,7 +1119,7 @@ static inline struct hsm_action_item * hai_zero(struct hsm_action_list *hal)
 							 + 1));
 }
 /* Return pointer to next hai */
-static inline struct hsm_action_item * hai_next(struct hsm_action_item *hai)
+static inline struct hsm_action_item *hai_next(struct hsm_action_item *hai)
 {
 	return (struct hsm_action_item *)((char *)hai +
 					  cfs_size_round(hai->hai_len));
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d6af2ca..7d54426 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -3173,7 +3173,7 @@ int ptlrpc_add_timeout_client(int time, enum timeout_event event,
 			      struct list_head *obd_list);
 int ptlrpc_del_timeout_client(struct list_head *obd_list,
 			      enum timeout_event event);
-struct ptlrpc_request * ptlrpc_prep_ping(struct obd_import *imp);
+struct ptlrpc_request *ptlrpc_prep_ping(struct obd_import *imp);
 int ptlrpc_obd_ping(struct obd_device *obd);
 void ping_evictor_start(void);
 void ping_evictor_stop(void);
diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index dc31bf9..c4669e2 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -885,7 +885,7 @@ enum sptlrpc_bulk_hash_alg {
 	BULK_HASH_ALG_MAX
 };
 
-const char * sptlrpc_get_hash_name(__u8 hash_alg);
+const char *sptlrpc_get_hash_name(__u8 hash_alg);
 __u8 sptlrpc_get_hash_alg(const char *algname);
 
 enum {
@@ -1060,7 +1060,7 @@ void sptlrpc_gc_del_sec(struct ptlrpc_sec *sec);
 void sptlrpc_gc_add_ctx(struct ptlrpc_cli_ctx *ctx);
 
 /* misc */
-const char * sec2target_str(struct ptlrpc_sec *sec);
+const char *sec2target_str(struct ptlrpc_sec *sec);
 /*
  * lprocfs
  */
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 3597226..2348b01 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -88,12 +88,12 @@ struct obd_device *class_name2obd(const char *name);
 int class_uuid2dev(struct obd_uuid *uuid);
 struct obd_device *class_uuid2obd(struct obd_uuid *uuid);
 void class_obd_list(void);
-struct obd_device * class_find_client_obd(struct obd_uuid *tgt_uuid,
-					  const char * typ_name,
+struct obd_device *class_find_client_obd(struct obd_uuid *tgt_uuid,
+					  const char *typ_name,
 					  struct obd_uuid *grp_uuid);
-struct obd_device * class_devices_in_group(struct obd_uuid *grp_uuid,
+struct obd_device *class_devices_in_group(struct obd_uuid *grp_uuid,
 					   int *next);
-struct obd_device * class_num2obd(int num);
+struct obd_device *class_num2obd(int num);
 int get_devices_count(void);
 
 int class_notify_sptlrpc_conf(const char *fsname, int namelen);
@@ -110,7 +110,7 @@ void obd_zombie_impexp_cull(void);
 void obd_zombie_barrier(void);
 void obd_exports_barrier(struct obd_device *obd);
 int kuc_len(int payload_len);
-struct kuc_hdr * kuc_ptr(void *p);
+struct kuc_hdr *kuc_ptr(void *p);
 int kuc_ispayload(void *p);
 void *kuc_alloc(int payload_len, int transport, int type);
 void kuc_free(void *p, int payload_len);
@@ -207,7 +207,7 @@ struct lustre_profile {
 	char	    *lp_md;
 };
 
-struct lustre_profile *class_get_profile(const char * prof);
+struct lustre_profile *class_get_profile(const char *prof);
 void class_del_profile(const char *prof);
 void class_del_profiles(void);
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index acfb078..8fc6847 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -995,7 +995,7 @@ int ll_close_thread_start(struct ll_close_queue **lcq_ret);
 /* llite/llite_mmap.c */
 
 int ll_teardown_mmaps(struct address_space *mapping, __u64 first, __u64 last);
-int ll_file_mmap(struct file * file, struct vm_area_struct * vma);
+int ll_file_mmap(struct file *file, struct vm_area_struct *vma);
 void policy_from_vma(ldlm_policy_data_t *policy,
 		struct vm_area_struct *vma, unsigned long addr, size_t count);
 struct vm_area_struct *our_vma(struct mm_struct *mm, unsigned long addr,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index ff375d3..bc0358d 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1139,7 +1139,7 @@ struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock)
 	/* NOTE: we depend on atomic igrab() -bzzz */
 	lock_res_and_lock(lock);
 	if (lock->l_resource->lr_lvb_inode) {
-		struct ll_inode_info * lli;
+		struct ll_inode_info *lli;
 		lli = ll_i2info(lock->l_resource->lr_lvb_inode);
 		if (lli->lli_inode_magic == LLI_INODE_MAGIC) {
 			inode = igrab(lock->l_resource->lr_lvb_inode);
@@ -2216,7 +2216,7 @@ int ll_process_config(struct lustre_cfg *lcfg)
 }
 
 /* this function prepares md_op_data hint for passing ot down to MD stack. */
-struct md_op_data * ll_prep_md_op_data(struct md_op_data *op_data,
+struct md_op_data *ll_prep_md_op_data(struct md_op_data *op_data,
 				       struct inode *i1, struct inode *i2,
 				       const char *name, int namelen,
 				       int mode, __u32 opc, void *data)
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index 5916648..5002488 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -426,7 +426,7 @@ static int ll_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
  *  To avoid cancel the locks covering mmapped region for lock cache pressure,
  *  we track the mapped vma count in ccc_object::cob_mmap_cnt.
  */
-static void ll_vm_open(struct vm_area_struct * vma)
+static void ll_vm_open(struct vm_area_struct *vma)
 {
 	struct inode *inode    = vma->vm_file->f_dentry->d_inode;
 	struct ccc_object *vob = cl_inode2ccc(inode);
@@ -472,7 +472,7 @@ static const struct vm_operations_struct ll_file_vm_ops = {
 	.close			= ll_vm_close,
 };
 
-int ll_file_mmap(struct file *file, struct vm_area_struct * vma)
+int ll_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	int rc;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 771b213..3e3fbfe 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -93,7 +93,7 @@ do {									\
 
 static int ptlrpc_connect_interpret(const struct lu_env *env,
 				    struct ptlrpc_request *request,
-				    void * data, int rc);
+				    void *data, int rc);
 int ptlrpc_import_recovery_state_machine(struct obd_import *imp);
 
 /* Only this function is allowed to change the import state when it is
@@ -1216,7 +1216,7 @@ out:
  */
 static int completed_replay_interpret(const struct lu_env *env,
 				      struct ptlrpc_request *req,
-				      void * data, int rc)
+				      void *data, int rc)
 {
 	atomic_dec(&req->rq_import->imp_replay_inflight);
 	if (req->rq_status == 0 &&
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index 9ea24f8..af5b987 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -327,7 +327,7 @@ static void nrs_policy_put(struct ptlrpc_nrs_policy *policy)
 /**
  * Find and return a policy by name.
  */
-static struct ptlrpc_nrs_policy * nrs_policy_find_locked(struct ptlrpc_nrs *nrs,
+static struct ptlrpc_nrs_policy *nrs_policy_find_locked(struct ptlrpc_nrs *nrs,
 							 char *name)
 {
 	struct ptlrpc_nrs_policy *tmp;
@@ -377,7 +377,7 @@ static void nrs_resource_put(struct ptlrpc_nrs_resource *res)
  * \see ptlrpc_nrs_pol_ops::op_res_get()
  */
 static
-struct ptlrpc_nrs_resource * nrs_resource_get(struct ptlrpc_nrs_policy *policy,
+struct ptlrpc_nrs_resource *nrs_resource_get(struct ptlrpc_nrs_policy *policy,
 					      struct ptlrpc_nrs_request *nrq,
 					      bool moving_req)
 {
@@ -530,7 +530,7 @@ static void nrs_resource_put_safe(struct ptlrpc_nrs_resource **resp)
  * \retval the NRS request to be handled
  */
 static inline
-struct ptlrpc_nrs_request * nrs_request_get(struct ptlrpc_nrs_policy *policy,
+struct ptlrpc_nrs_request *nrs_request_get(struct ptlrpc_nrs_policy *policy,
 					    bool peek, bool force)
 {
 	struct ptlrpc_nrs_request *nrq;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c b/drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c
index 2836330..eb40c01 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c
@@ -157,7 +157,7 @@ static int nrs_fifo_res_get(struct ptlrpc_nrs_policy *policy,
  * \see nrs_request_get()
  */
 static
-struct ptlrpc_nrs_request * nrs_fifo_req_get(struct ptlrpc_nrs_policy *policy,
+struct ptlrpc_nrs_request *nrs_fifo_req_get(struct ptlrpc_nrs_policy *policy,
 					     bool peek, bool force)
 {
 	struct nrs_fifo_head	  *head = policy->pol_private;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 5cff7ee..bf59f3e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -110,7 +110,7 @@ int sptlrpc_unregister_policy(struct ptlrpc_sec_policy *policy)
 EXPORT_SYMBOL(sptlrpc_unregister_policy);
 
 static
-struct ptlrpc_sec_policy * sptlrpc_wireflavor2policy(__u32 flavor)
+struct ptlrpc_sec_policy *sptlrpc_wireflavor2policy(__u32 flavor)
 {
 	static DEFINE_MUTEX(load_mutex);
 	static atomic_t       loaded = ATOMIC_INIT(0);
@@ -1267,7 +1267,7 @@ EXPORT_SYMBOL(sptlrpc_sec_put);
  * policy module is responsible for taking reference of import
  */
 static
-struct ptlrpc_sec * sptlrpc_sec_create(struct obd_import *imp,
+struct ptlrpc_sec *sptlrpc_sec_create(struct obd_import *imp,
 				       struct ptlrpc_svc_ctx *svc_ctx,
 				       struct sptlrpc_flavor *sf,
 				       enum lustre_sec_part sp)
@@ -2366,7 +2366,7 @@ EXPORT_SYMBOL(sptlrpc_unpack_user_desc);
  * misc helpers			 *
  ****************************************/
 
-const char * sec2target_str(struct ptlrpc_sec *sec)
+const char *sec2target_str(struct ptlrpc_sec *sec)
 {
 	if (!sec || !sec->ps_import || !sec->ps_import->imp_obd)
 		return "*";
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 874789b..ba4364c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -794,7 +794,7 @@ static int cfs_hash_alg_id[] = {
 	[BULK_HASH_ALG_SHA384]	= CFS_HASH_ALG_SHA384,
 	[BULK_HASH_ALG_SHA512]	= CFS_HASH_ALG_SHA512,
 };
-const char * sptlrpc_get_hash_name(__u8 hash_alg)
+const char *sptlrpc_get_hash_name(__u8 hash_alg)
 {
 	return cfs_crypto_hash_name(cfs_hash_alg_id[hash_alg]);
 }
-- 
1.9.1

