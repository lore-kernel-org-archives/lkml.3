Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHaWkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:40:37 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:54392 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:40:34 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix return is not a function, parentheses are not required errors
Date: Sun, 31 Aug 2014 17:40:17 -0500
Message-Id: <1409524817-11080-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl return is not a function, parentheses are not required errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre_log.h | 2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     | 2 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   | 2 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       | 2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index ed97887..2f50b81 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -447,7 +447,7 @@ static inline int llog_group_ctxt_null(struct obd_llog_group *olg, int index)
 
 static inline int llog_ctxt_null(struct obd_device *obd, int index)
 {
-	return (llog_group_ctxt_null(&obd->obd_olg, index));
+	return llog_group_ctxt_null(&obd->obd_olg, index);
 }
 
 static inline int llog_destroy(const struct lu_env *env,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 150b44d..a0d3925 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -631,7 +631,7 @@ EXPORT_SYMBOL(ldlm_pool_shrink);
 int ldlm_pool_setup(struct ldlm_pool *pl, int limit)
 {
 	if (pl->pl_ops->po_setup != NULL)
-		return(pl->pl_ops->po_setup(pl, limit));
+		return pl->pl_ops->po_setup(pl, limit);
 	return 0;
 }
 EXPORT_SYMBOL(ldlm_pool_setup);
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 1b96fac..c61db3a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -140,7 +140,7 @@ static inline struct lov_lock_handles *
 lov_handle2llh(struct lustre_handle *handle)
 {
 	LASSERT(handle != NULL);
-	return(class_handle2object(handle->cookie));
+	return class_handle2object(handle->cookie);
 }
 
 static inline void lov_llh_put(struct lov_lock_handles *llh)
diff --git a/drivers/staging/lustre/lustre/lov/lov_pool.c b/drivers/staging/lustre/lustre/lov/lov_pool.c
index 91b3509..ec48ea4 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pool.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pool.c
@@ -107,7 +107,7 @@ static void *pool_key(struct hlist_node *hnode)
 	struct pool_desc *pool;
 
 	pool = hlist_entry(hnode, struct pool_desc, pool_hash);
-	return (pool->pool_name);
+	return pool->pool_name;
 }
 
 static int pool_hashkey_keycmp(const void *key, struct hlist_node *compared_hnode)
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index e3feb21..d9f7249 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -1120,7 +1120,7 @@ static int check_write_rcs(struct ptlrpc_request *req,
 	/* return error if any niobuf was in error */
 	for (i = 0; i < niocount; i++) {
 		if ((int)remote_rcs[i] < 0)
-			return(remote_rcs[i]);
+			return remote_rcs[i];
 
 		if (remote_rcs[i] != 0) {
 			CDEBUG(D_INFO, "rc[%d] invalid (%d) req %p\n",
-- 
1.9.1

