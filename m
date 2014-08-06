Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaHFRNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:13:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60501 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaHFRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:13:52 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 01/12] staging: lustre: remove space between function name and and open parenthesis
Date: Wed,  6 Aug 2014 22:42:51 +0530
Message-Id: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes following checkpatch warning:

WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_internal.h |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c      |  4 ++--
 drivers/staging/lustre/lustre/mdc/mdc_locks.c    |  2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c  | 14 +++++++-------
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index e8235559e27f..f4da8f3523d2 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -40,7 +40,7 @@
 #include "../include/lustre_mdc.h"
 #include "../include/lustre_mds.h"
 
-#if defined (CONFIG_PROC_FS)
+#if defined CONFIG_PROC_FS
 void lprocfs_mdc_init_vars(struct lprocfs_static_vars *lvars);
 #else
 static inline void lprocfs_mdc_init_vars(struct lprocfs_static_vars *lvars)
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index f54dd90c7e50..60217ba440aa 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -42,7 +42,7 @@
 
 static void __mdc_pack_body(struct mdt_body *b, __u32 suppgid)
 {
-	LASSERT (b != NULL);
+	LASSERT(b != NULL);
 
 	b->suppgid = suppgid;
 	b->uid = from_kuid(&init_user_ns, current_uid());
@@ -409,7 +409,7 @@ void mdc_link_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
 
 	CLASSERT(sizeof(struct mdt_rec_reint) == sizeof(struct mdt_rec_link));
 	rec = req_capsule_client_get(&req->rq_pill, &RMF_REC_REINT);
-	LASSERT (rec != NULL);
+	LASSERT(rec != NULL);
 
 	rec->lk_opcode   = REINT_LINK;
 	rec->lk_fsuid    = op_data->op_fsuid;//current->fsuid;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 71219b90e22b..88b43823c632 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -633,7 +633,7 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 
 		body = req_capsule_server_get(pill, &RMF_MDT_BODY);
 		if (body == NULL) {
-			CERROR ("Can't swab mdt_body\n");
+			CERROR("Can't swab mdt_body\n");
 			return -EPROTO;
 		}
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 4a1cc4eb73d5..0b517e550477 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1702,7 +1702,7 @@ static int mdc_quotactl(struct obd_device *unused, struct obd_export *exp,
 		if (oqc) {
 			*oqctl = *oqc;
 		} else if (!rc) {
-			CERROR ("Can't unpack obd_quotactl\n");
+			CERROR("Can't unpack obd_quotactl\n");
 			rc = -EPROTO;
 		}
 	} else if (!rc) {
@@ -2426,14 +2426,14 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
 
-	OBD_ALLOC(cli->cl_rpc_lock, sizeof (*cli->cl_rpc_lock));
+	OBD_ALLOC(cli->cl_rpc_lock, sizeof(*cli->cl_rpc_lock));
 	if (!cli->cl_rpc_lock)
 		return -ENOMEM;
 	mdc_init_rpc_lock(cli->cl_rpc_lock);
 
 	ptlrpcd_addref();
 
-	OBD_ALLOC(cli->cl_close_lock, sizeof (*cli->cl_close_lock));
+	OBD_ALLOC(cli->cl_close_lock, sizeof(*cli->cl_close_lock));
 	if (!cli->cl_close_lock)
 		GOTO(err_rpc_lock, rc = -ENOMEM);
 	mdc_init_rpc_lock(cli->cl_close_lock);
@@ -2459,9 +2459,9 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 	return rc;
 
 err_close_lock:
-	OBD_FREE(cli->cl_close_lock, sizeof (*cli->cl_close_lock));
+	OBD_FREE(cli->cl_close_lock, sizeof(*cli->cl_close_lock));
 err_rpc_lock:
-	OBD_FREE(cli->cl_rpc_lock, sizeof (*cli->cl_rpc_lock));
+	OBD_FREE(cli->cl_rpc_lock, sizeof(*cli->cl_rpc_lock));
 	ptlrpcd_decref();
 	return rc;
 }
@@ -2523,8 +2523,8 @@ static int mdc_cleanup(struct obd_device *obd)
 {
 	struct client_obd *cli = &obd->u.cli;
 
-	OBD_FREE(cli->cl_rpc_lock, sizeof (*cli->cl_rpc_lock));
-	OBD_FREE(cli->cl_close_lock, sizeof (*cli->cl_close_lock));
+	OBD_FREE(cli->cl_rpc_lock, sizeof(*cli->cl_rpc_lock));
+	OBD_FREE(cli->cl_close_lock, sizeof(*cli->cl_close_lock));
 
 	ptlrpcd_decref();
 
-- 
1.9.3

