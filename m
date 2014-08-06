Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaHFROM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:14:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57254 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaHFROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:08 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 05/12] staging: lustre: Add missing spaces around operators and braces.
Date: Wed,  6 Aug 2014 22:42:55 +0530
Message-Id: <1407345182-709-5-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch errors:

ERROR: space required after that ',' (ctx:VxV)
ERROR: space required after that close brace '}'

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c     | 25 +++++++++++++------------
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   |  5 +++--
 drivers/staging/lustre/lustre/mdc/mdc_reint.c   |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c |  7 ++++---
 4 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 16e2e0b611d1..35ce2fdf696c 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -345,7 +345,8 @@ void mdc_setattr_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	struct mdt_ioepoch *epoch;
 	struct lov_user_md *lum = NULL;
 
-	CLASSERT(sizeof(struct mdt_rec_reint) ==sizeof(struct mdt_rec_setattr));
+	CLASSERT(sizeof(struct mdt_rec_reint) ==
+					sizeof(struct mdt_rec_setattr));
 	rec = req_capsule_client_get(&req->rq_pill, &RMF_REC_REINT);
 	mdc_setattr_pack_rec(rec, op_data);
 
@@ -385,18 +386,18 @@ void mdc_unlink_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
 	rec = req_capsule_client_get(&req->rq_pill, &RMF_REC_REINT);
 	LASSERT(rec != NULL);
 
-	rec->ul_opcode  = op_data->op_cli_flags & CLI_RM_ENTRY ?
+	rec->ul_opcode   = op_data->op_cli_flags & CLI_RM_ENTRY ?
 					REINT_RMENTRY : REINT_UNLINK;
-	rec->ul_fsuid   = op_data->op_fsuid;
-	rec->ul_fsgid   = op_data->op_fsgid;
-	rec->ul_cap     = op_data->op_cap;
-	rec->ul_mode    = op_data->op_mode;
-	rec->ul_suppgid1= op_data->op_suppgids[0];
-	rec->ul_suppgid2= -1;
-	rec->ul_fid1    = op_data->op_fid1;
-	rec->ul_fid2    = op_data->op_fid2;
-	rec->ul_time    = op_data->op_mod_time;
-	rec->ul_bias    = op_data->op_bias;
+	rec->ul_fsuid    = op_data->op_fsuid;
+	rec->ul_fsgid    = op_data->op_fsgid;
+	rec->ul_cap      = op_data->op_cap;
+	rec->ul_mode     = op_data->op_mode;
+	rec->ul_suppgid1 = op_data->op_suppgids[0];
+	rec->ul_suppgid2 = -1;
+	rec->ul_fid1     = op_data->op_fid1;
+	rec->ul_fid2     = op_data->op_fid2;
+	rec->ul_time     = op_data->op_mod_time;
+	rec->ul_bias     = op_data->op_bias;
 
 	mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 5de9e8862393..a5a2597616e9 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -621,7 +621,7 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 	 * function without doing so, and try to replay a failed create
 	 * (bug 3440) */
 	if (it->it_op & IT_OPEN && req->rq_replay &&
-	    (!it_disposition(it, DISP_OPEN_OPEN) ||intent->it_status != 0))
+	    (!it_disposition(it, DISP_OPEN_OPEN) || intent->it_status != 0))
 		mdc_clear_replay_flag(req, intent->it_status);
 
 	DEBUG_REQ(D_RPCTRACE, req, "op: %d disposition: %x, status: %d",
@@ -1047,7 +1047,8 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 			it->d.lustre.it_lock_handle = lockh->cookie;
 		}
 	}
-	CDEBUG(D_DENTRY,"D_IT dentry %.*s intent: %s status %d disp %x rc %d\n",
+	CDEBUG(D_DENTRY,
+	       "D_IT dentry %.*s intent: %s status %d disp %x rc %d\n",
 	       op_data->op_namelen, op_data->op_name, ldlm_it2str(it->it_op),
 	       it->d.lustre.it_status, it->d.lustre.it_disposition, rc);
 	return rc;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index c5420a42bc33..c40304bf0b62 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -71,7 +71,7 @@ int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
 			    __u64 bits)
 {
 	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
-	ldlm_policy_data_t policy = {{0}};
+	ldlm_policy_data_t policy = {{0} };
 	struct ldlm_res_id res_id;
 	struct ldlm_resource *res;
 	int count;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 5126262aa73d..6def92133227 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -326,7 +326,8 @@ static int mdc_is_subdir(struct obd_export *exp,
 	return rc;
 }
 
-static int mdc_xattr_common(struct obd_export *exp,const struct req_format *fmt,
+static int mdc_xattr_common(struct obd_export *exp,
+			    const struct req_format *fmt,
 			    const struct lu_fid *fid,
 			    struct obd_capa *oc, int opcode, obd_valid valid,
 			    const char *xattr_name, const char *input,
@@ -544,7 +545,7 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		int lmvsize;
 		struct lov_mds_md *lmv;
 
-		if(!S_ISDIR(md->body->mode)) {
+		if (!S_ISDIR(md->body->mode)) {
 			CDEBUG(D_INFO, "OBD_MD_FLDIREA set, should be a "
 			       "directory, but is not\n");
 			GOTO(out, rc = -EPROTO);
@@ -1536,7 +1537,7 @@ static int changelog_kkuc_cb(const struct lu_env *env, struct llog_handle *llh,
 	memcpy(lh + 1, &rec->cr, len - sizeof(*lh));
 
 	rc = libcfs_kkuc_msg_put(cs->cs_fp, lh);
-	CDEBUG(D_CHANGELOG, "kucmsg fp %p len %d rc %d\n", cs->cs_fp, len,rc);
+	CDEBUG(D_CHANGELOG, "kucmsg fp %p len %d rc %d\n", cs->cs_fp, len, rc);
 
 	return rc;
 }
-- 
1.9.3

