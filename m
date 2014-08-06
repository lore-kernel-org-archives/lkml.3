Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbaHFROX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:14:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42097 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaHFROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:18 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 07/12] staging: lustre: add blank lines after declarations
Date: Wed,  6 Aug 2014 22:42:57 +0530
Message-Id: <1407345182-709-7-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:

WARNING: Missing a blank line after declarations

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c     | 1 +
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   | 3 +++
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 7f9b6eb51860..95fe62da26e2 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -490,6 +490,7 @@ void mdc_getattr_pack(struct ptlrpc_request *req, __u64 valid, int flags,
 
 	if (op_data->op_name) {
 		char *tmp = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
+
 		LOGL0(op_data->op_name, op_data->op_namelen, tmp);
 
 	}
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index a5a2597616e9..4d837d61be65 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -134,6 +134,7 @@ int mdc_set_lock_data(struct obd_export *exp, __u64 *lockh, void *data,
 	if (lock->l_resource->lr_lvb_inode &&
 	    lock->l_resource->lr_lvb_inode != data) {
 		struct inode *old_inode = lock->l_resource->lr_lvb_inode;
+
 		LASSERTF(old_inode->i_state & I_FREEING,
 			 "Found existing inode %p/%lu/%u state %lu in lock: "
 			 "setting data to %p/%lu/%u\n", old_inode,
@@ -678,6 +679,7 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 			 */
 			if ((it->it_op & IT_OPEN) && req->rq_replay) {
 				void *lmm;
+
 				if (req_capsule_get_size(pill, &RMF_EADATA,
 							 RCL_CLIENT) <
 				    body->eadatasize)
@@ -1029,6 +1031,7 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 	lock = ldlm_handle2lock(lockh);
 	if (lock) {
 		ldlm_policy_data_t policy = lock->l_policy_data;
+
 		LDLM_DEBUG(lock, "matching against this");
 
 		LASSERTF(fid_res_name_eq(&mdt_body->fid1,
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 6def92133227..57d903156917 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -203,6 +203,7 @@ static int mdc_getattr_common(struct obd_export *exp,
 
 	if (body->valid & OBD_MD_FLMDSCAPA) {
 		struct lustre_capa *capa;
+
 		capa = req_capsule_server_get(pill, &RMF_CAPA1);
 		if (capa == NULL)
 			return -EPROTO;
@@ -283,6 +284,7 @@ int mdc_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
 
 	if (op_data->op_name) {
 		char *name = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
+
 		LASSERT(strnlen(op_data->op_name, op_data->op_namelen) ==
 				op_data->op_namelen);
 		memcpy(name, op_data->op_name, op_data->op_namelen);
@@ -696,6 +698,7 @@ void mdc_replay_open(struct ptlrpc_request *req)
 void mdc_commit_open(struct ptlrpc_request *req)
 {
 	struct md_open_data *mod = req->rq_cb_data;
+
 	if (mod == NULL)
 		return;
 
@@ -2390,6 +2393,7 @@ int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
 {
 	struct client_obd *cli = &exp->exp_obd->u.cli;
+
 	return &cli->cl_target_uuid;
 }
 
@@ -2742,6 +2746,7 @@ int __init mdc_init(void)
 {
 	int rc;
 	struct lprocfs_static_vars lvars = { NULL };
+
 	lprocfs_mdc_init_vars(&lvars);
 
 	rc = class_register_type(&mdc_obd_ops, &mdc_md_ops, lvars.module_vars,
-- 
1.9.3

