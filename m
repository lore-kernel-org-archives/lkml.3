Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaHFRO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:14:26 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60059 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbaHFROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:23 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 08/12] staging: lustre: fix multi line strings
Date: Wed,  6 Aug 2014 22:42:58 +0530
Message-Id: <1407345182-709-8-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:

WARNING: quoted string split across lines

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   |  9 +++----
 drivers/staging/lustre/lustre/mdc/mdc_reint.c   |  3 +--
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 36 ++++++++++++-------------
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 4d837d61be65..7f724e3c3f06 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -136,11 +136,10 @@ int mdc_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
 		struct inode *old_inode = lock->l_resource->lr_lvb_inode;
 
 		LASSERTF(old_inode->i_state & I_FREEING,
-			 "Found existing inode %p/%lu/%u state %lu in lock: "
-			 "setting data to %p/%lu/%u\n", old_inode,
-			 old_inode->i_ino, old_inode->i_generation,
-			 old_inode->i_state,
-			 new_inode, new_inode->i_ino, new_inode->i_generation);
+			 "Found existing inode %p/%lu/%u state %lu in lock: setting data to %p/%lu/%u\n",
+			 old_inode, old_inode->i_ino, old_inode->i_generation,
+			 old_inode->i_state, new_inode, new_inode->i_ino,
+			 new_inode->i_generation);
 	}
 	lock->l_resource->lr_lvb_inode = new_inode;
 	if (bits)
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index c40304bf0b62..6f78bffa9294 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -158,8 +158,7 @@ int mdc_setattr(struct obd_export *exp, struct md_op_data *op_data,
 
 		*mod = obd_mod_alloc();
 		if (*mod == NULL) {
-			DEBUG_REQ(D_ERROR, req, "Can't allocate "
-				  "md_open_data");
+			DEBUG_REQ(D_ERROR, req, "Can't allocate md_open_data");
 		} else {
 			req->rq_replay = 1;
 			req->rq_cb_data = *mod;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 57d903156917..6c691a4763b5 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -517,14 +517,14 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		struct lov_mds_md *lmm;
 
 		if (!S_ISREG(md->body->mode)) {
-			CDEBUG(D_INFO, "OBD_MD_FLEASIZE set, should be a "
-			       "regular file, but is not\n");
+			CDEBUG(D_INFO,
+			       "OBD_MD_FLEASIZE set, should be a regular file, but is not\n");
 			GOTO(out, rc = -EPROTO);
 		}
 
 		if (md->body->eadatasize == 0) {
-			CDEBUG(D_INFO, "OBD_MD_FLEASIZE set, "
-			       "but eadatasize 0\n");
+			CDEBUG(D_INFO,
+			       "OBD_MD_FLEASIZE set, but eadatasize 0\n");
 			GOTO(out, rc = -EPROTO);
 		}
 		lmmsize = md->body->eadatasize;
@@ -537,8 +537,8 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 			GOTO(out, rc);
 
 		if (rc < sizeof(*md->lsm)) {
-			CDEBUG(D_INFO, "lsm size too small: "
-			       "rc < sizeof (*md->lsm) (%d < %d)\n",
+			CDEBUG(D_INFO,
+			       "lsm size too small: rc < sizeof (*md->lsm) (%d < %d)\n",
 			       rc, (int)sizeof(*md->lsm));
 			GOTO(out, rc = -EPROTO);
 		}
@@ -548,14 +548,14 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 		struct lov_mds_md *lmv;
 
 		if (!S_ISDIR(md->body->mode)) {
-			CDEBUG(D_INFO, "OBD_MD_FLDIREA set, should be a "
-			       "directory, but is not\n");
+			CDEBUG(D_INFO,
+			       "OBD_MD_FLDIREA set, should be a directory, but is not\n");
 			GOTO(out, rc = -EPROTO);
 		}
 
 		if (md->body->eadatasize == 0) {
-			CDEBUG(D_INFO, "OBD_MD_FLDIREA is set, "
-			       "but eadatasize 0\n");
+			CDEBUG(D_INFO,
+			       "OBD_MD_FLDIREA is set, but eadatasize 0\n");
 			return -EPROTO;
 		}
 		if (md->body->valid & OBD_MD_MEA) {
@@ -571,8 +571,8 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 				GOTO(out, rc);
 
 			if (rc < sizeof(*md->mea)) {
-				CDEBUG(D_INFO, "size too small:  "
-				       "rc < sizeof(*md->mea) (%d < %d)\n",
+				CDEBUG(D_INFO,
+				       "size too small: rc < sizeof(*md->mea) (%d < %d)\n",
 					rc, (int)sizeof(*md->mea));
 				GOTO(out, rc = -EPROTO);
 			}
@@ -778,8 +778,8 @@ int mdc_set_open_replay_data(struct obd_export *exp,
 	rec->cr_old_handle.cookie = body->handle.cookie;
 	open_req->rq_replay_cb = mdc_replay_open;
 	if (!fid_is_sane(&body->fid1)) {
-		DEBUG_REQ(D_ERROR, open_req, "Saving replay request with "
-			  "insane fid");
+		DEBUG_REQ(D_ERROR, open_req,
+			  "Saving replay request with insane fid");
 		LBUG();
 	}
 
@@ -928,8 +928,8 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 
 		rc = lustre_msg_get_status(req->rq_repmsg);
 		if (lustre_msg_get_type(req->rq_repmsg) == PTL_RPC_MSG_ERR) {
-			DEBUG_REQ(D_ERROR, req, "type == PTL_RPC_MSG_ERR, err "
-				  "= %d", rc);
+			DEBUG_REQ(D_ERROR, req,
+				  "type == PTL_RPC_MSG_ERR, err = %d", rc);
 			if (rc > 0)
 				rc = -rc;
 		}
@@ -2055,8 +2055,8 @@ static int mdc_hsm_copytool_send(int len, void *val)
 		return -EPROTO;
 	}
 
-	CDEBUG(D_HSM, " Received message mg=%x t=%d m=%d l=%d actions=%d "
-	       "on %s\n",
+	CDEBUG(D_HSM,
+	       " Received message mg=%x t=%d m=%d l=%d actions=%d on %s\n",
 	       lh->kuc_magic, lh->kuc_transport, lh->kuc_msgtype,
 	       lh->kuc_msglen, hal->hal_count, hal->hal_fsname);
 
-- 
1.9.3

