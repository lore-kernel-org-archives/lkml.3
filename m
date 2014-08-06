Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaHFROO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:14:14 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63437 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaHFROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:03 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 04/12] staging: lustre: fix lines over 80 chars
Date: Wed,  6 Aug 2014 22:42:54 +0530
Message-Id: <1407345182-709-4-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following  checkpatch warning:

WARNING: line over 80 characters

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c   | 6 ++++--
 drivers/staging/lustre/lustre/mdc/mdc_lib.c     | 9 ++++++---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   | 7 ++++---
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 6 ++++--
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index f883d9c28f20..16341c818358 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -56,7 +56,8 @@ static ssize_t mdc_max_rpcs_in_flight_seq_write(struct file *file,
 						size_t count,
 						loff_t *off)
 {
-	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
+	struct obd_device *dev =
+			((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &dev->u.cli;
 	int val, rc;
 
@@ -84,7 +85,8 @@ static int mdc_kuc_open(struct inode *inode, struct file *file)
 static ssize_t mdc_kuc_write(struct file *file, const char *buffer,
 			     size_t count, loff_t *off)
 {
-	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
+	struct obd_device *obd =
+			((struct seq_file *)file->private_data)->private;
 	struct kuc_hdr		*lh;
 	struct hsm_action_list	*hal;
 	struct hsm_action_item	*hai;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index daaa7422c03f..16e2e0b611d1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -52,7 +52,8 @@ static void __mdc_pack_body(struct mdt_body *b, __u32 suppgid)
 	b->capability = cfs_curproc_cap_pack();
 }
 
-void mdc_pack_capa(struct ptlrpc_request *req, const struct req_msg_field *field,
+void mdc_pack_capa(struct ptlrpc_request *req,
+		   const struct req_msg_field *field,
 		   struct obd_capa *oc)
 {
 	struct req_capsule *pill = &req->rq_pill;
@@ -317,7 +318,8 @@ static void mdc_setattr_pack_rec(struct mdt_rec_setattr *rec,
 	rec->sa_atime  = LTIME_S(op_data->op_attr.ia_atime);
 	rec->sa_mtime  = LTIME_S(op_data->op_attr.ia_mtime);
 	rec->sa_ctime  = LTIME_S(op_data->op_attr.ia_ctime);
-	rec->sa_attr_flags = ((struct ll_iattr *)&op_data->op_attr)->ia_attr_flags;
+	rec->sa_attr_flags =
+			((struct ll_iattr *)&op_data->op_attr)->ia_attr_flags;
 	if ((op_data->op_attr.ia_valid & ATTR_GID) &&
 	    in_group_p(op_data->op_attr.ia_gid))
 		rec->sa_suppgid =
@@ -552,7 +554,8 @@ int mdc_enter_request(struct client_obd *cli)
 		list_add_tail(&mcw.mcw_entry, &cli->cl_cache_waiters);
 		init_waitqueue_head(&mcw.mcw_waitq);
 		client_obd_list_unlock(&cli->cl_loi_list_lock);
-		rc = l_wait_event(mcw.mcw_waitq, mdc_req_avail(cli, &mcw), &lwi);
+		rc = l_wait_event(mcw.mcw_waitq, mdc_req_avail(cli, &mcw),
+				  &lwi);
 		if (rc) {
 			client_obd_list_lock(&cli->cl_loi_list_lock);
 			if (list_empty(&mcw.mcw_entry))
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 88b43823c632..5de9e8862393 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -450,8 +450,8 @@ static struct ptlrpc_request *mdc_intent_unlink_pack(struct obd_export *exp,
 }
 
 static struct ptlrpc_request *mdc_intent_getattr_pack(struct obd_export *exp,
-						      struct lookup_intent *it,
-						      struct md_op_data *op_data)
+						    struct lookup_intent *it,
+						    struct md_op_data *op_data)
 {
 	struct ptlrpc_request *req;
 	struct obd_device     *obddev = class_exp2obd(exp);
@@ -1039,7 +1039,8 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 
 		memcpy(&old_lock, lockh, sizeof(*lockh));
 		if (ldlm_lock_match(NULL, LDLM_FL_BLOCK_GRANTED, NULL,
-				    LDLM_IBITS, &policy, LCK_NL, &old_lock, 0)) {
+				    LDLM_IBITS, &policy, LCK_NL,
+				    &old_lock, 0)) {
 			ldlm_lock_decref_and_cancel(lockh,
 						    it->d.lustre.it_lock_mode);
 			memcpy(lockh, &old_lock, sizeof(old_lock));
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 0bcf624620ce..5126262aa73d 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -897,7 +897,8 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 		mod->mod_open_req->rq_replay = 0;
 		spin_unlock(&mod->mod_open_req->rq_lock);
 	} else {
-		 CDEBUG(D_HA, "couldn't find open req; expecting close error\n");
+		 CDEBUG(D_HA,
+			"couldn't find open req; expecting close error\n");
 	}
 
 	mdc_close_pack(req, op_data);
@@ -1084,7 +1085,8 @@ restart_bulk:
 			CERROR("too many resend retries, returning error\n");
 			return -EIO;
 		}
-		lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(resends), NULL, NULL, NULL);
+		lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(resends),
+				       NULL, NULL, NULL);
 		l_wait_event(waitq, 0, &lwi);
 
 		goto restart_bulk;
-- 
1.9.3

