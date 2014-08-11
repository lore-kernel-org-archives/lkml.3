Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaHKS33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:29:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61123 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHKS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:29:24 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 13/13] staging: lustre: Cleanup variable declarations in mdc_enqueue()
Date: Mon, 11 Aug 2014 23:57:39 +0530
Message-Id: <1407781659-728-13-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
- move const union vars to the top
- move rc to bottom
- do not initialize req
- set lvb_type to enum member instead of 0
- change __u64 to u64
- fix inconsistant columnization

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 These changes were suggested by Dan Carpenter <dan.carpenter@oracle.com>.

 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 288ce9119ed5..c64a38eaee3e 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -778,13 +778,8 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 		struct lookup_intent *it, struct md_op_data *op_data,
 		struct lustre_handle *lockh, void *lmm, int lmmsize,
-		struct ptlrpc_request **reqp, __u64 extra_lock_flags)
+		struct ptlrpc_request **reqp, u64 extra_lock_flags)
 {
-	struct obd_device     *obddev = class_exp2obd(exp);
-	struct ptlrpc_request *req = NULL;
-	__u64		  flags, saved_flags = extra_lock_flags;
-	int		    rc;
-	struct ldlm_res_id res_id;
 	static const ldlm_policy_data_t lookup_policy = {
 		.l_inodebits = { MDS_INODELOCK_LOOKUP }
 	};
@@ -798,9 +793,14 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 		.l_inodebits = { MDS_INODELOCK_XATTR }
 	};
 	ldlm_policy_data_t const *policy = &lookup_policy;
-	int		    generation, resends = 0;
-	struct ldlm_reply     *lockrep;
-	enum lvb_type	       lvb_type = 0;
+	struct obd_device *obddev = class_exp2obd(exp);
+	struct ptlrpc_request *req;
+	u64 flags, saved_flags = extra_lock_flags;
+	struct ldlm_res_id res_id;
+	int generation, resends = 0;
+	struct ldlm_reply *lockrep;
+	enum lvb_type lvb_type = LVB_T_NONE;
+	int rc;
 
 	LASSERTF(!it || einfo->ei_type == LDLM_IBITS, "lock type %d\n",
 		 einfo->ei_type);
-- 
1.9.3

