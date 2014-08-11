Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaHKS3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:29:12 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54424 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHKS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:29:08 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 10/13] staging: lustre: Fix misplaced opening brace warnings
Date: Mon, 11 Aug 2014 23:57:36 +0530
Message-Id: <1407781659-728-10-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:

ERROR: that open brace { should be on the previous line

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   | 18 +++++++++++-------
 drivers/staging/lustre/lustre/mdc/mdc_reint.c   |  3 +--
 drivers/staging/lustre/lustre/mdc/mdc_request.c |  7 +++++--
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index c03d77c9c5b8..288ce9119ed5 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -785,14 +785,18 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 	__u64		  flags, saved_flags = extra_lock_flags;
 	int		    rc;
 	struct ldlm_res_id res_id;
-	static const ldlm_policy_data_t lookup_policy =
-			    { .l_inodebits = { MDS_INODELOCK_LOOKUP } };
-	static const ldlm_policy_data_t update_policy =
-			    { .l_inodebits = { MDS_INODELOCK_UPDATE } };
-	static const ldlm_policy_data_t layout_policy =
-			    { .l_inodebits = { MDS_INODELOCK_LAYOUT } };
+	static const ldlm_policy_data_t lookup_policy = {
+		.l_inodebits = { MDS_INODELOCK_LOOKUP }
+	};
+	static const ldlm_policy_data_t update_policy = {
+		.l_inodebits = { MDS_INODELOCK_UPDATE }
+	};
+	static const ldlm_policy_data_t layout_policy = {
+		.l_inodebits = { MDS_INODELOCK_LAYOUT }
+	};
 	static const ldlm_policy_data_t getxattr_policy = {
-			      .l_inodebits = { MDS_INODELOCK_XATTR } };
+		.l_inodebits = { MDS_INODELOCK_XATTR }
+	};
 	ldlm_policy_data_t const *policy = &lookup_policy;
 	int		    generation, resends = 0;
 	struct ldlm_reply     *lockrep;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index 46800335ca7d..01af30ac1a52 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -152,8 +152,7 @@ int mdc_setattr(struct obd_export *exp, struct md_op_data *op_data,
 
 	ptlrpc_request_set_replen(req);
 	if (mod && (op_data->op_flags & MF_EPOCH_OPEN) &&
-	    req->rq_import->imp_replayable)
-	{
+	    req->rq_import->imp_replayable) {
 		LASSERT(*mod == NULL);
 
 		*mod = obd_mod_alloc();
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 6c691a4763b5..bf2dcf50afd4 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1794,8 +1794,11 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 	case OBD_IOC_CHANGELOG_CLEAR: {
 		struct ioc_changelog *icc = karg;
-		struct changelog_setinfo cs =
-			{.cs_recno = icc->icc_recno, .cs_id = icc->icc_id};
+		struct changelog_setinfo cs = {
+			.cs_recno = icc->icc_recno,
+			.cs_id = icc->icc_id
+		};
+
 		rc = obd_set_info_async(NULL, exp, strlen(KEY_CHANGELOG_CLEAR),
 					KEY_CHANGELOG_CLEAR, sizeof(cs), &cs,
 					NULL);
-- 
1.9.3

