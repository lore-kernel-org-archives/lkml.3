Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbbAROI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:08:28 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:54570 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbbAROIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:12 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: lustre: lmv: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:48 +0100
Message-Id: <1421590012-7082-3-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
References: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
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

Fixes sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c   | 87 ++++++++++++++-------------
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c |  4 +-
 2 files changed, 47 insertions(+), 44 deletions(-)

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
-- 
1.9.1

