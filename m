Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaC0X1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:27:11 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:47769 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaC0X1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:27:09 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2014 19:27:08 EDT
From: Christoph Jaeger <email@christophjaeger.info>
To: standby24x7@gmail.com, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, bergwolf@gmail.com, green@linuxhacker.ru,
        sachin.kamat@linaro.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH] taging: lustre: use __func__ instead of __FUNCTION__
Date: Fri, 28 Mar 2014 00:21:07 +0100
Message-Id: <1395962467-18225-1-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.8.5.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc specific; use __func__ instead.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h  | 4 ++--
 drivers/staging/lustre/lustre/include/linux/obd.h           | 2 +-
 drivers/staging/lustre/lustre/include/lu_ref.h              | 4 ++--
 drivers/staging/lustre/lustre/include/lustre_dlm.h          | 4 ++--
 drivers/staging/lustre/lustre/obdclass/cl_lock.c            | 2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c             | 4 ++--
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 4 ++--
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c         | 4 ++--
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
index 2bd4885..b270d84 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
@@ -183,7 +183,7 @@ struct libcfs_debug_msg_data {
 do {								\
 	(data)->msg_subsys = DEBUG_SUBSYSTEM;			\
 	(data)->msg_file   = __FILE__;				\
-	(data)->msg_fn     = __FUNCTION__;			\
+	(data)->msg_fn     = __func__;				\
 	(data)->msg_line   = __LINE__;				\
 	(data)->msg_cdls   = (cdls);				\
 	(data)->msg_mask   = (mask);				\
@@ -193,7 +193,7 @@ do {								\
 	static struct libcfs_debug_msg_data dataname = {	\
 	       .msg_subsys = DEBUG_SUBSYSTEM,			\
 	       .msg_file   = __FILE__,				\
-	       .msg_fn     = __FUNCTION__,			\
+	       .msg_fn     = __func__,				\
 	       .msg_line   = __LINE__,				\
 	       .msg_cdls   = (cdls)	 };			\
 	dataname.msg_mask   = (mask);
diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index dc36f75e..fea7e6c 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -104,7 +104,7 @@ static inline void __client_obd_list_lock(client_obd_lock_t *lock,
 }
 
 #define client_obd_list_lock(lock) \
-	__client_obd_list_lock(lock, __FUNCTION__, __LINE__)
+	__client_obd_list_lock(lock, __func__, __LINE__)
 
 static inline void client_obd_list_unlock(client_obd_lock_t *lock)
 {
diff --git a/drivers/staging/lustre/lustre/include/lu_ref.h b/drivers/staging/lustre/lustre/include/lu_ref.h
index 50a2a7f..b451a88 100644
--- a/drivers/staging/lustre/lustre/include/lu_ref.h
+++ b/drivers/staging/lustre/lustre/include/lu_ref.h
@@ -69,12 +69,12 @@
  *
  *	// current thread acquired a temporary reference to foo.
  *	foo_get(foo);
- *	lu_ref_add(&foo->reference, __FUNCTION__, current);
+ *	lu_ref_add(&foo->reference, __func__, current);
  *
  *	...
  *
  *	// temporary reference is released.
- *	lu_ref_del(&foo->reference, __FUNCTION__, current);
+ *	lu_ref_del(&foo->reference, __func__, current);
  *	foo_put(foo);
  * \endcode
  *
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 3e25f00..ed10313 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1312,11 +1312,11 @@ int ldlm_lock_change_resource(struct ldlm_namespace *, struct ldlm_lock *,
 			      const struct ldlm_res_id *);
 
 #define LDLM_RESOURCE_ADDREF(res) do {				  \
-	lu_ref_add_atomic(&(res)->lr_reference, __FUNCTION__, current);  \
+	lu_ref_add_atomic(&(res)->lr_reference, __func__, current);  \
 } while (0)
 
 #define LDLM_RESOURCE_DELREF(res) do {				  \
-	lu_ref_del(&(res)->lr_reference, __FUNCTION__, current);  \
+	lu_ref_del(&(res)->lr_reference, __func__, current);	  \
 } while (0)
 
 /* ldlm_request.c */
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index d795cef..8eb1785 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -139,7 +139,7 @@ static void cl_lock_trace0(int level, const struct lu_env *env,
 	       func, line);
 }
 #define cl_lock_trace(level, env, prefix, lock)			 \
-	cl_lock_trace0(level, env, prefix, lock, __FUNCTION__, __LINE__)
+	cl_lock_trace0(level, env, prefix, lock, __func__, __LINE__)
 
 #define RETIP ((unsigned long)__builtin_return_address(0))
 
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index f2bdea3..350b6f0 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -615,13 +615,13 @@ int class_notify_sptlrpc_conf(const char *fsname, int namelen)
 		if (strncmp(obd->obd_name, fsname, namelen))
 			continue;
 
-		class_incref(obd, __FUNCTION__, obd);
+		class_incref(obd, __func__, obd);
 		read_unlock(&obd_dev_lock);
 		rc2 = obd_set_info_async(NULL, obd->obd_self_export,
 					 sizeof(KEY_SPTLRPC_CONF),
 					 KEY_SPTLRPC_CONF, 0, NULL, NULL);
 		rc = rc ? rc : rc2;
-		class_decref(obd, __FUNCTION__, obd);
+		class_decref(obd, __func__, obd);
 		read_lock(&obd_dev_lock);
 	}
 	read_unlock(&obd_dev_lock);
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index ba20776..e4e94cc 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -244,7 +244,7 @@ static int obd_proc_health_seq_show(struct seq_file *m, void *v)
 		if (obd->obd_stopping)
 			continue;
 
-		class_incref(obd, __FUNCTION__, current);
+		class_incref(obd, __func__, current);
 		read_unlock(&obd_dev_lock);
 
 		if (obd_health_check(NULL, obd)) {
@@ -252,7 +252,7 @@ static int obd_proc_health_seq_show(struct seq_file *m, void *v)
 				      obd->obd_name);
 			rc++;
 		}
-		class_decref(obd, __FUNCTION__, current);
+		class_decref(obd, __func__, current);
 		read_lock(&obd_dev_lock);
 	}
 	read_unlock(&obd_dev_lock);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 58f1c8b..7a422ff 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -1190,7 +1190,7 @@ int lprocfs_wr_evict_client(struct file *file, const char *buffer,
 	 * the proc entries under the being destroyed export{}, so I have
 	 * to drop the lock at first here.
 	 * - jay, jxiong@clusterfs.com */
-	class_incref(obd, __FUNCTION__, current);
+	class_incref(obd, __func__, current);
 
 	if (strncmp(tmpbuf, "nid:", 4) == 0)
 		obd_export_evict_by_nid(obd, tmpbuf + 4);
@@ -1199,7 +1199,7 @@ int lprocfs_wr_evict_client(struct file *file, const char *buffer,
 	else
 		obd_export_evict_by_uuid(obd, tmpbuf);
 
-	class_decref(obd, __FUNCTION__, current);
+	class_decref(obd, __func__, current);
 
 out:
 	OBD_FREE(kbuf, BUFLEN);
-- 
1.8.5.3

