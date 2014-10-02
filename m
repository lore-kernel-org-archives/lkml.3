Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaJBXLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:11:14 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63970 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaJBXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:11:13 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "'foo* bar' should be 'foo *bar'" errors
Date: Thu,  2 Oct 2014 18:10:23 -0500
Message-Id: <1412291423-27283-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "'foo* bar' should be 'foo *bar'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/dt_object.h   | 2 +-
 drivers/staging/lustre/lustre/include/lu_object.h   | 4 ++--
 drivers/staging/lustre/lustre/include/lustre_lib.h  | 2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h  | 2 +-
 drivers/staging/lustre/lustre/include/obd_class.h   | 2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c     | 2 +-
 drivers/staging/lustre/lustre/llite/statahead.c     | 2 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c   | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c       | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/dt_object.h b/drivers/staging/lustre/lustre/include/dt_object.h
index 212ebae..c2e7622 100644
--- a/drivers/staging/lustre/lustre/include/dt_object.h
+++ b/drivers/staging/lustre/lustre/include/dt_object.h
@@ -617,7 +617,7 @@ struct dt_index_operations {
 		int	   (*load)(const struct lu_env *env,
 				      const struct dt_it *di, __u64 hash);
 		int	(*key_rec)(const struct lu_env *env,
-				      const struct dt_it *di, void* key_rec);
+				      const struct dt_it *di, void *key_rec);
 	} dio_it;
 };
 
diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index 6015ee5..2ddb2b0 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -1120,7 +1120,7 @@ struct lu_context_key {
 };
 
 #define LU_KEY_INIT(mod, type)				    \
-	static void* mod##_key_init(const struct lu_context *ctx, \
+	static void *mod##_key_init(const struct lu_context *ctx, \
 				    struct lu_context_key *key)   \
 	{							 \
 		type *value;				      \
@@ -1137,7 +1137,7 @@ struct lu_context_key {
 
 #define LU_KEY_FINI(mod, type)					      \
 	static void mod##_key_fini(const struct lu_context *ctx,	    \
-				    struct lu_context_key *key, void* data) \
+				    struct lu_context_key *key, void *data) \
 	{								   \
 		type *info = data;					  \
 									    \
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 12c7590..bf13563 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -85,7 +85,7 @@ void target_send_reply(struct ptlrpc_request *req, int rc, int fail_id);
 
 /* client.c */
 
-int client_sanobd_setup(struct obd_device *obddev, struct lustre_cfg* lcfg);
+int client_sanobd_setup(struct obd_device *obddev, struct lustre_cfg *lcfg);
 struct client_obd *client_conn2cli(struct lustre_handle *conn);
 
 struct md_open_data;
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 0a024d3..d4da243 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -2951,7 +2951,7 @@ void ptlrpcd_decref(void);
  * procfs output related functions
  * @{
  */
-const char* ll_opcode2str(__u32 opcode);
+const char *ll_opcode2str(__u32 opcode);
 #if defined (CONFIG_PROC_FS)
 void ptlrpc_lprocfs_register_obd(struct obd_device *obd);
 void ptlrpc_lprocfs_unregister_obd(struct obd_device *obd);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 882e40b..4a29261 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -414,7 +414,7 @@ do {							    \
 #define EXP_MD_COUNTER_INCREMENT(exp, op)
 #endif
 
-static inline int lprocfs_nid_ldlm_stats_init(struct nid_stat* tmp)
+static inline int lprocfs_nid_ldlm_stats_init(struct nid_stat *tmp)
 {
 	/* Always add in ldlm_stats */
 	tmp->nid_ldlm_stats = lprocfs_alloc_stats(LDLM_LAST_OPC - LDLM_FIRST_OPC
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index a8bcc51..061483f 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -2398,7 +2398,7 @@ char *ll_get_fsname(struct super_block *sb, char *buf, int buflen)
 	return buf;
 }
 
-static char* ll_d_path(struct dentry *dentry, char *buf, int bufsize)
+static char *ll_d_path(struct dentry *dentry, char *buf, int bufsize)
 {
 	char *path = NULL;
 
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 06b71bc..85d451f 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -915,7 +915,7 @@ static int do_sa_revalidate(struct inode *dir, struct ll_sa_entry *entry,
 	return rc;
 }
 
-static void ll_statahead_one(struct dentry *parent, const char* entry_name,
+static void ll_statahead_one(struct dentry *parent, const char *entry_name,
 			     int entry_name_len)
 {
 	struct inode	     *dir    = parent->d_inode;
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_obd.c b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
index da769db..978d886 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
@@ -42,7 +42,7 @@
 #include "llog_internal.h"
 
 /* helper functions for calling the llog obd methods */
-static struct llog_ctxt* llog_new_ctxt(struct obd_device *obd)
+static struct llog_ctxt *llog_new_ctxt(struct obd_device *obd)
 {
 	struct llog_ctxt *ctxt;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 87b9764a..cb99e19 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -175,7 +175,7 @@ const char *ll_opcode2str(__u32 opcode)
 	return ll_rpc_opcode_table[offset].opname;
 }
 
-const char* ll_eopcode2str(__u32 opcode)
+const char *ll_eopcode2str(__u32 opcode)
 {
 	LASSERT(ll_eopcode_table[opcode].opcode == opcode);
 	return ll_eopcode_table[opcode].opname;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 20341b2..18d617c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -428,7 +428,7 @@ EXPORT_SYMBOL(ptlrpc_pinger_del_import);
  * Register a timeout callback to the pinger list, and the callback will
  * be called when timeout happens.
  */
-struct timeout_item* ptlrpc_new_timeout(int time, enum timeout_event event,
+struct timeout_item *ptlrpc_new_timeout(int time, enum timeout_event event,
 					timeout_cb_t cb, void *data)
 {
 	struct timeout_item *ti;
-- 
1.9.1

