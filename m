Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaIEUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:24027 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbaIEUJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="569066496"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 08/12] staging/lustre: remove unused OBD methods
Date: Fri, 5 Sep 2014 15:08:14 -0500
Message-ID: <1409947698-30781-9-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused OBD device methods:
    obd_brw()
    obd_cancel()
    obd_cancel_unused()
    obd_change_cbdata()
    obd_create_async()
    obd_enqueue()
    obd_enqueue_rqset()
    obd_extent_calc()
    obd_llog_connect()
    obd_llog_finish()
    obd_llog_init()
    obd_merge_lvb()
    obd_pin()
    obd_pin_observer()
    obd_ping()
    obd_precreate()
    obd_punch()
    obd_punch_rqset()
    obd_sync()
    obd_sync_rqset()
    obd_unpin()
    obd_unpin_observer()

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_log.h |    5 -
 drivers/staging/lustre/lustre/include/obd.h        |   47 ----
 drivers/staging/lustre/lustre/include/obd_class.h  |  279 --------------------
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |   25 --
 .../lustre/lustre/obdclass/lprocfs_status.c        |   20 --
 5 files changed, 376 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index 36a2ffb..c10029c 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -206,11 +206,6 @@ int llog_sync(struct llog_ctxt *ctxt, struct obd_export *exp, int flags);
 int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
 		struct llog_cookie *cookies, int flags);
 
-int obd_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-		  struct obd_device *disk_obd, int *idx);
-
-int obd_llog_finish(struct obd_device *obd, int count);
-
 /* llog_ioctl.c */
 int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 	       struct obd_ioctl_data *data);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 9f13878..66fc457 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1189,13 +1189,9 @@ struct obd_ops {
 			  struct lov_mds_md *disk_src, int disk_len);
 	int (*o_preallocate)(struct lustre_handle *, u32 *req, u64 *ids);
 	/* FIXME: add fid capability support for create & destroy! */
-	int (*o_precreate)(struct obd_export *exp);
 	int (*o_create)(const struct lu_env *env, struct obd_export *exp,
 			struct obdo *oa, struct lov_stripe_md **ea,
 			struct obd_trans_info *oti);
-	int (*o_create_async)(struct obd_export *exp,  struct obd_info *oinfo,
-			      struct lov_stripe_md **ea,
-			      struct obd_trans_info *oti);
 	int (*o_destroy)(const struct lu_env *env, struct obd_export *exp,
 			 struct obdo *oa, struct lov_stripe_md *ea,
 			 struct obd_trans_info *oti, struct obd_export *md_exp,
@@ -1209,28 +1205,8 @@ struct obd_ops {
 			 struct obd_info *oinfo);
 	int (*o_getattr_async)(struct obd_export *exp, struct obd_info *oinfo,
 			       struct ptlrpc_request_set *set);
-	int (*o_brw)(int rw, struct obd_export *exp, struct obd_info *oinfo,
-		     u32 oa_bufs, struct brw_page *pgarr,
-		     struct obd_trans_info *oti);
-	int (*o_merge_lvb)(struct obd_export *exp, struct lov_stripe_md *lsm,
-			   struct ost_lvb *lvb, int kms_only);
 	int (*o_adjust_kms)(struct obd_export *exp, struct lov_stripe_md *lsm,
 			    u64 size, int shrink);
-	int (*o_punch)(const struct lu_env *, struct obd_export *exp,
-		       struct obd_info *oinfo, struct obd_trans_info *oti,
-		       struct ptlrpc_request_set *rqset);
-	int (*o_sync)(const struct lu_env *env, struct obd_export *exp,
-		      struct obd_info *oinfo, u64 start, u64 end,
-		      struct ptlrpc_request_set *set);
-	int (*o_migrate)(struct lustre_handle *conn, struct lov_stripe_md *dst,
-			 struct lov_stripe_md *src, u64 start,
-			 u64 end, struct obd_trans_info *oti);
-	int (*o_copy)(struct lustre_handle *dstconn, struct lov_stripe_md *dst,
-		      struct lustre_handle *srconn, struct lov_stripe_md *src,
-		      u64 start, u64 end, struct obd_trans_info *);
-	int (*o_iterate)(struct lustre_handle *conn,
-			 int (*)(u64, u64, void *),
-			 u64 *startid, u64 seq, void *data);
 	int (*o_preprw)(const struct lu_env *env, int cmd,
 			struct obd_export *exp, struct obdo *oa, int objcount,
 			struct obd_ioobj *obj, struct niobuf_remote *remote,
@@ -1242,33 +1218,12 @@ struct obd_ops {
 			  struct niobuf_remote *remote, int pages,
 			  struct niobuf_local *local,
 			  struct obd_trans_info *oti, int rc);
-	int (*o_enqueue)(struct obd_export *, struct obd_info *oinfo,
-			 struct ldlm_enqueue_info *einfo,
-			 struct ptlrpc_request_set *rqset);
-	int (*o_change_cbdata)(struct obd_export *, struct lov_stripe_md *,
-			       ldlm_iterator_t it, void *data);
 	int (*o_find_cbdata)(struct obd_export *, struct lov_stripe_md *,
 			     ldlm_iterator_t it, void *data);
-	int (*o_cancel)(struct obd_export *, struct lov_stripe_md *md,
-			__u32 mode, struct lustre_handle *);
-	int (*o_cancel_unused)(struct obd_export *, struct lov_stripe_md *,
-			       ldlm_cancel_flags_t flags, void *opaque);
 	int (*o_init_export)(struct obd_export *exp);
 	int (*o_destroy_export)(struct obd_export *exp);
-	int (*o_extent_calc)(struct obd_export *, struct lov_stripe_md *,
-			     int cmd, u64 *);
-
-	/* llog related obd_methods */
-	int (*o_llog_init)(struct obd_device *obd, struct obd_llog_group *grp,
-			   struct obd_device *disk_obd, int *idx);
-	int (*o_llog_finish)(struct obd_device *obd, int count);
-	int (*o_llog_connect)(struct obd_export *, struct llogd_conn_body *);
 
 	/* metadata-only methods */
-	int (*o_pin)(struct obd_export *, const struct lu_fid *fid,
-		     struct obd_capa *, struct obd_client_handle *, int flag);
-	int (*o_unpin)(struct obd_export *, struct obd_client_handle *, int);
-
 	int (*o_import_event)(struct obd_device *, struct obd_import *,
 			      enum obd_import_event);
 
@@ -1284,8 +1239,6 @@ struct obd_ops {
 	int (*o_quotactl)(struct obd_device *, struct obd_export *,
 			  struct obd_quotactl *);
 
-	int (*o_ping)(const struct lu_env *, struct obd_export *exp);
-
 	/* pools methods */
 	int (*o_pool_new)(struct obd_device *obd, char *poolname);
 	int (*o_pool_del)(struct obd_device *obd, char *poolname);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 65143ab..9030171 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -776,31 +776,6 @@ static inline int obd_free_memmd(struct obd_export *exp,
 	return rc;
 }
 
-static inline int obd_precreate(struct obd_export *exp)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, precreate);
-	OBD_COUNTER_INCREMENT(exp->exp_obd, precreate);
-
-	rc = OBP(exp->exp_obd, precreate)(exp);
-	return rc;
-}
-
-static inline int obd_create_async(struct obd_export *exp,
-				   struct obd_info *oinfo,
-				   struct lov_stripe_md **ea,
-				   struct obd_trans_info *oti)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, create_async);
-	EXP_COUNTER_INCREMENT(exp, create_async);
-
-	rc = OBP(exp->exp_obd, create_async)(exp, oinfo, ea, oti);
-	return rc;
-}
-
 static inline int obd_create(const struct lu_env *env, struct obd_export *exp,
 			     struct obdo *obdo, struct lov_stripe_md **ea,
 			     struct obd_trans_info *oti)
@@ -1037,17 +1012,6 @@ static inline int obd_fid_alloc(struct obd_export *exp,
 	return rc;
 }
 
-static inline int obd_ping(const struct lu_env *env, struct obd_export *exp)
-{
-	int rc;
-
-	OBD_CHECK_DT_OP(exp->exp_obd, ping, 0);
-	EXP_COUNTER_INCREMENT(exp, ping);
-
-	rc = OBP(exp->exp_obd, ping)(env, exp);
-	return rc;
-}
-
 static inline int obd_pool_new(struct obd_device *obd, char *poolname)
 {
 	int rc;
@@ -1126,17 +1090,6 @@ static inline int obd_destroy_export(struct obd_export *exp)
 	return 0;
 }
 
-static inline int obd_extent_calc(struct obd_export *exp,
-				  struct lov_stripe_md *md,
-				  int cmd, u64 *offset)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, extent_calc);
-	rc = OBP(exp->exp_obd, extent_calc)(exp, md, cmd, offset);
-	return rc;
-}
-
 static inline struct dentry *
 obd_lvfs_fid2dentry(struct obd_export *exp, struct ost_id *oi, __u32 gen)
 {
@@ -1244,92 +1197,6 @@ static inline int obd_statfs(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }
 
-static inline int obd_sync_rqset(struct obd_export *exp, struct obd_info *oinfo,
-				 u64 start, u64 end)
-{
-	struct ptlrpc_request_set *set = NULL;
-	int rc;
-
-	OBD_CHECK_DT_OP(exp->exp_obd, sync, -EOPNOTSUPP);
-	EXP_COUNTER_INCREMENT(exp, sync);
-
-	set =  ptlrpc_prep_set();
-	if (set == NULL)
-		return -ENOMEM;
-
-	rc = OBP(exp->exp_obd, sync)(NULL, exp, oinfo, start, end, set);
-	if (rc == 0)
-		rc = ptlrpc_set_wait(set);
-	ptlrpc_set_destroy(set);
-	return rc;
-}
-
-static inline int obd_sync(const struct lu_env *env, struct obd_export *exp,
-			   struct obd_info *oinfo, u64 start, u64 end,
-			   struct ptlrpc_request_set *set)
-{
-	int rc;
-
-	OBD_CHECK_DT_OP(exp->exp_obd, sync, -EOPNOTSUPP);
-	EXP_COUNTER_INCREMENT(exp, sync);
-
-	rc = OBP(exp->exp_obd, sync)(env, exp, oinfo, start, end, set);
-	return rc;
-}
-
-static inline int obd_punch_rqset(struct obd_export *exp,
-				  struct obd_info *oinfo,
-				  struct obd_trans_info *oti)
-{
-	struct ptlrpc_request_set *set = NULL;
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, punch);
-	EXP_COUNTER_INCREMENT(exp, punch);
-
-	set =  ptlrpc_prep_set();
-	if (set == NULL)
-		return -ENOMEM;
-
-	rc = OBP(exp->exp_obd, punch)(NULL, exp, oinfo, oti, set);
-	if (rc == 0)
-		rc = ptlrpc_set_wait(set);
-	ptlrpc_set_destroy(set);
-	return rc;
-}
-
-static inline int obd_punch(const struct lu_env *env, struct obd_export *exp,
-			    struct obd_info *oinfo, struct obd_trans_info *oti,
-			    struct ptlrpc_request_set *rqset)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, punch);
-	EXP_COUNTER_INCREMENT(exp, punch);
-
-	rc = OBP(exp->exp_obd, punch)(env, exp, oinfo, oti, rqset);
-	return rc;
-}
-
-static inline int obd_brw(int cmd, struct obd_export *exp,
-			  struct obd_info *oinfo, u32 oa_bufs,
-			  struct brw_page *pg, struct obd_trans_info *oti)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, brw);
-	EXP_COUNTER_INCREMENT(exp, brw);
-
-	if (!(cmd & (OBD_BRW_RWMASK | OBD_BRW_CHECK))) {
-		CERROR("obd_brw: cmd must be OBD_BRW_READ, OBD_BRW_WRITE, "
-		       "or OBD_BRW_CHECK\n");
-		LBUG();
-	}
-
-	rc = OBP(exp->exp_obd, brw)(cmd, exp, oinfo, oa_bufs, pg, oti);
-	return rc;
-}
-
 static inline int obd_preprw(const struct lu_env *env, int cmd,
 			     struct obd_export *exp, struct obdo *oa,
 			     int objcount, struct obd_ioobj *obj,
@@ -1363,19 +1230,6 @@ static inline int obd_commitrw(const struct lu_env *env, int cmd,
 	return rc;
 }
 
-static inline int obd_merge_lvb(struct obd_export *exp,
-				struct lov_stripe_md *lsm,
-				struct ost_lvb *lvb, int kms_only)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, merge_lvb);
-	EXP_COUNTER_INCREMENT(exp, merge_lvb);
-
-	rc = OBP(exp->exp_obd, merge_lvb)(exp, lsm, lvb, kms_only);
-	return rc;
-}
-
 static inline int obd_adjust_kms(struct obd_export *exp,
 				 struct lov_stripe_md *lsm, u64 size,
 				 int shrink)
@@ -1401,54 +1255,6 @@ static inline int obd_iocontrol(unsigned int cmd, struct obd_export *exp,
 	return rc;
 }
 
-static inline int obd_enqueue_rqset(struct obd_export *exp,
-				    struct obd_info *oinfo,
-				    struct ldlm_enqueue_info *einfo)
-{
-	struct ptlrpc_request_set *set = NULL;
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, enqueue);
-	EXP_COUNTER_INCREMENT(exp, enqueue);
-
-	set =  ptlrpc_prep_set();
-	if (set == NULL)
-		return -ENOMEM;
-
-	rc = OBP(exp->exp_obd, enqueue)(exp, oinfo, einfo, set);
-	if (rc == 0)
-		rc = ptlrpc_set_wait(set);
-	ptlrpc_set_destroy(set);
-	return rc;
-}
-
-static inline int obd_enqueue(struct obd_export *exp,
-			      struct obd_info *oinfo,
-			      struct ldlm_enqueue_info *einfo,
-			      struct ptlrpc_request_set *set)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, enqueue);
-	EXP_COUNTER_INCREMENT(exp, enqueue);
-
-	rc = OBP(exp->exp_obd, enqueue)(exp, oinfo, einfo, set);
-	return rc;
-}
-
-static inline int obd_change_cbdata(struct obd_export *exp,
-				    struct lov_stripe_md *lsm,
-				    ldlm_iterator_t it, void *data)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, change_cbdata);
-	EXP_COUNTER_INCREMENT(exp, change_cbdata);
-
-	rc = OBP(exp->exp_obd, change_cbdata)(exp, lsm, it, data);
-	return rc;
-}
-
 static inline int obd_find_cbdata(struct obd_export *exp,
 				  struct lov_stripe_md *lsm,
 				  ldlm_iterator_t it, void *data)
@@ -1462,59 +1268,6 @@ static inline int obd_find_cbdata(struct obd_export *exp,
 	return rc;
 }
 
-static inline int obd_cancel(struct obd_export *exp,
-			     struct lov_stripe_md *ea, __u32 mode,
-			     struct lustre_handle *lockh)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, cancel);
-	EXP_COUNTER_INCREMENT(exp, cancel);
-
-	rc = OBP(exp->exp_obd, cancel)(exp, ea, mode, lockh);
-	return rc;
-}
-
-static inline int obd_cancel_unused(struct obd_export *exp,
-				    struct lov_stripe_md *ea,
-				    ldlm_cancel_flags_t flags,
-				    void *opaque)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, cancel_unused);
-	EXP_COUNTER_INCREMENT(exp, cancel_unused);
-
-	rc = OBP(exp->exp_obd, cancel_unused)(exp, ea, flags, opaque);
-	return rc;
-}
-
-static inline int obd_pin(struct obd_export *exp, const struct lu_fid *fid,
-			  struct obd_capa *oc, struct obd_client_handle *handle,
-			  int flag)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, pin);
-	EXP_COUNTER_INCREMENT(exp, pin);
-
-	rc = OBP(exp->exp_obd, pin)(exp, fid, oc, handle, flag);
-	return rc;
-}
-
-static inline int obd_unpin(struct obd_export *exp,
-			    struct obd_client_handle *handle, int flag)
-{
-	int rc;
-
-	EXP_CHECK_DT_OP(exp, unpin);
-	EXP_COUNTER_INCREMENT(exp, unpin);
-
-	rc = OBP(exp->exp_obd, unpin)(exp, handle, flag);
-	return rc;
-}
-
-
 static inline void obd_import_event(struct obd_device *obd,
 				    struct obd_import *imp,
 				    enum obd_import_event event)
@@ -1529,19 +1282,6 @@ static inline void obd_import_event(struct obd_device *obd,
 	}
 }
 
-static inline int obd_llog_connect(struct obd_export *exp,
-				   struct llogd_conn_body *body)
-{
-	int rc;
-
-	OBD_CHECK_DT_OP(exp->exp_obd, llog_connect, 0);
-	EXP_COUNTER_INCREMENT(exp, llog_connect);
-
-	rc = OBP(exp->exp_obd, llog_connect)(exp, body);
-	return rc;
-}
-
-
 static inline int obd_notify(struct obd_device *obd,
 			     struct obd_device *watched,
 			     enum obd_notify_event ev,
@@ -1661,25 +1401,6 @@ static inline int obd_register_observer(struct obd_device *obd,
 	return 0;
 }
 
-static inline int obd_pin_observer(struct obd_device *obd,
-				   struct obd_device **observer)
-{
-	down_read(&obd->obd_observer_link_sem);
-	if (!obd->obd_observer) {
-		*observer = NULL;
-		up_read(&obd->obd_observer_link_sem);
-		return -ENOENT;
-	}
-	*observer = obd->obd_observer;
-	return 0;
-}
-
-static inline int obd_unpin_observer(struct obd_device *obd)
-{
-	up_read(&obd->obd_observer_link_sem);
-	return 0;
-}
-
 #if 0
 static inline int obd_register_page_removal_cb(struct obd_export *exp,
 					       obd_page_removal_cb_t cb,
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_obd.c b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
index 8ff01d3..da769db 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_obd.c
@@ -242,31 +242,6 @@ int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
 }
 EXPORT_SYMBOL(llog_cancel);
 
-int obd_llog_init(struct obd_device *obd, struct obd_llog_group *olg,
-		  struct obd_device *disk_obd, int *index)
-{
-	int rc;
-
-	OBD_CHECK_DT_OP(obd, llog_init, 0);
-	OBD_COUNTER_INCREMENT(obd, llog_init);
-
-	rc = OBP(obd, llog_init)(obd, olg, disk_obd, index);
-	return rc;
-}
-EXPORT_SYMBOL(obd_llog_init);
-
-int obd_llog_finish(struct obd_device *obd, int count)
-{
-	int rc;
-
-	OBD_CHECK_DT_OP(obd, llog_finish, 0);
-	OBD_COUNTER_INCREMENT(obd, llog_finish);
-
-	rc = OBP(obd, llog_finish)(obd, count);
-	return rc;
-}
-EXPORT_SYMBOL(obd_llog_finish);
-
 /* context key constructor/destructor: llog_key_init, llog_key_fini */
 LU_KEY_INIT_FINI(llog, struct llog_thread_info);
 /* context key: llog_thread_key */
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 7893c2d..f315ec7 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1309,44 +1309,24 @@ void lprocfs_init_ops_stats(int num_private_stats, struct lprocfs_stats *stats)
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, packmd);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, unpackmd);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, preallocate);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, precreate);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, create);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, create_async);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, destroy);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, setattr);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, setattr_async);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, getattr);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, getattr_async);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, brw);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, merge_lvb);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, adjust_kms);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, punch);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, sync);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, migrate);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, copy);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, iterate);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, preprw);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, commitrw);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, enqueue);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, change_cbdata);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, find_cbdata);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, cancel);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, cancel_unused);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, init_export);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, destroy_export);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, extent_calc);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, llog_init);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, llog_connect);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, llog_finish);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, pin);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, unpin);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, import_event);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, notify);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, health_check);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, get_uuid);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, quotacheck);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, quotactl);
-	LPROCFS_OBD_OP_INIT(num_private_stats, stats, ping);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, pool_new);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, pool_rem);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, pool_add);
-- 
1.7.9.5

