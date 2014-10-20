Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaJTQSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:18:36 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:51510 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaJTQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:18:30 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "'foo * bar' should be 'foo *bar'" errors
Date: Mon, 20 Oct 2014 11:18:12 -0500
Message-Id: <1413821892-2525-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "'foo * bar' should be 'foo *bar'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/dt_object.h           | 2 +-
 drivers/staging/lustre/lustre/include/lprocfs_status.h      | 2 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h          | 2 +-
 drivers/staging/lustre/lustre/llite/namei.c                 | 4 ++--
 drivers/staging/lustre/lustre/obdclass/genops.c             | 8 ++++----
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 4 ++--
 drivers/staging/lustre/lustre/obdclass/obd_config.c         | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/dt_object.h b/drivers/staging/lustre/lustre/include/dt_object.h
index c2e7622..be4c7d9 100644
--- a/drivers/staging/lustre/lustre/include/dt_object.h
+++ b/drivers/staging/lustre/lustre/include/dt_object.h
@@ -667,7 +667,7 @@ static inline int lu_device_is_dt(const struct lu_device *d)
 	return ergo(d != NULL, d->ld_type->ldt_tags & LU_DEVICE_DT);
 }
 
-static inline struct dt_device * lu2dt_dev(struct lu_device *l)
+static inline struct dt_device *lu2dt_dev(struct lu_device *l)
 {
 	LASSERT(lu_device_is_dt(l));
 	return container_of0(l, struct dt_device, dd_lu_dev);
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index ccb6cd4..ec16f6f 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -557,7 +557,7 @@ extern void lprocfs_free_obd_stats(struct obd_device *obddev);
 extern void lprocfs_free_md_stats(struct obd_device *obddev);
 struct obd_export;
 struct nid_stat;
-extern int lprocfs_add_clear_entry(struct obd_device * obd,
+extern int lprocfs_add_clear_entry(struct obd_device *obd,
 				   struct proc_dir_entry *entry);
 extern int lprocfs_exp_setup(struct obd_export *exp,
 			     lnet_nid_t *peer_nid, int *newnid);
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 14ac46f..83bc0a9 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1446,7 +1446,7 @@ static inline void check_res_locked(struct ldlm_resource *res)
 	assert_spin_locked(&res->lr_lock);
 }
 
-struct ldlm_resource * lock_res_and_lock(struct ldlm_lock *lock);
+struct ldlm_resource *lock_res_and_lock(struct ldlm_lock *lock);
 void unlock_res_and_lock(struct ldlm_lock *lock);
 
 /* ldlm_pool.c */
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 7a68c1e..2971a26 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -948,7 +948,7 @@ static int ll_mkdir_generic(struct inode *dir, struct qstr *name,
 
 /* Try to find the child dentry by its name.
    If found, put the result fid into @fid. */
-static void ll_get_child_fid(struct inode * dir, struct qstr *name,
+static void ll_get_child_fid(struct inode *dir, struct qstr *name,
 			     struct lu_fid *fid)
 {
 	struct dentry *parent, *child;
@@ -1190,7 +1190,7 @@ static int ll_mknod(struct inode *dir, struct dentry *dchild, ll_umode_t mode,
 				old_encode_dev(rdev), dchild);
 }
 
-static int ll_unlink(struct inode * dir, struct dentry *dentry)
+static int ll_unlink(struct inode *dir, struct dentry *dentry)
 {
 	return ll_unlink_generic(dir, NULL, dentry, &dentry->d_name);
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index c314e9c..b6592ee 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -524,8 +524,8 @@ void class_obd_list(void)
 /* Search for a client OBD connected to tgt_uuid.  If grp_uuid is
    specified, then only the client with that uuid is returned,
    otherwise any client connected to the tgt is returned. */
-struct obd_device * class_find_client_obd(struct obd_uuid *tgt_uuid,
-					  const char * typ_name,
+struct obd_device *class_find_client_obd(struct obd_uuid *tgt_uuid,
+					  const char *typ_name,
 					  struct obd_uuid *grp_uuid)
 {
 	int i;
@@ -557,7 +557,7 @@ EXPORT_SYMBOL(class_find_client_obd);
    searching at *next, and if a device is found, the next index to look
    at is saved in *next. If next is NULL, then the first matching device
    will always be returned. */
-struct obd_device * class_devices_in_group(struct obd_uuid *grp_uuid, int *next)
+struct obd_device *class_devices_in_group(struct obd_uuid *grp_uuid, int *next)
 {
 	int i;
 
@@ -1783,7 +1783,7 @@ EXPORT_SYMBOL(kuc_len);
  * @param p Pointer to payload area
  * @returns Pointer to kuc header
  */
-struct kuc_hdr * kuc_ptr(void *p)
+struct kuc_hdr *kuc_ptr(void *p)
 {
 	struct kuc_hdr *lh = ((struct kuc_hdr *)p) - 1;
 	LASSERT(lh->kuc_magic == KUC_MAGIC);
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 7eaaaa6..66ceab2 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -166,14 +166,14 @@ int obd_ioctl_popdata(void *arg, void *data, int len)
 EXPORT_SYMBOL(obd_ioctl_popdata);
 
 /*  opening /dev/obd */
-static int obd_class_open(struct inode * inode, struct file * file)
+static int obd_class_open(struct inode *inode, struct file *file)
 {
 	try_module_get(THIS_MODULE);
 	return 0;
 }
 
 /*  closing /dev/obd */
-static int obd_class_release(struct inode * inode, struct file * file)
+static int obd_class_release(struct inode *inode, struct file *file)
 {
 	module_put(THIS_MODULE);
 	return 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 5e7b3d7..47213a9 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -835,7 +835,7 @@ int class_del_conn(struct obd_device *obd, struct lustre_cfg *lcfg)
 
 LIST_HEAD(lustre_profile_list);
 
-struct lustre_profile *class_get_profile(const char * prof)
+struct lustre_profile *class_get_profile(const char *prof)
 {
 	struct lustre_profile *lprof;
 
-- 
1.9.1

