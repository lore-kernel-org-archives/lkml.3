Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab3KNQ4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:56:40 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34353 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3KNQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:20 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 13/39] staging/lustre/lmv: update coding style
Date: Fri, 15 Nov 2013 00:32:36 +0800
Message-Id: <1384446782-13741-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

in lmv_obd.c:
- Correct wrong coding styles introduced by HSM (and others)
- Remove useless include

Lustre-change: http://review.whamcloud.com/7252
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3709
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c |   42 +++++++++++++--------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index c286604..9d36014 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -43,7 +43,6 @@
 #include <asm/div64.h>
 #include <linux/seq_file.h>
 #include <linux/namei.h>
-#include <asm/uaccess.h>
 
 #include <lustre/lustre_idl.h>
 #include <obd_support.h>
@@ -802,10 +801,10 @@ static void lmv_hsm_req_build(struct lmv_obd *lmv,
 	nr_out = 0;
 	for (i = 0; i < hur_in->hur_request.hr_itemcount; i++) {
 		curr_tgt = lmv_find_target(lmv,
-					&hur_in->hur_user_item[i].hui_fid);
+					   &hur_in->hur_user_item[i].hui_fid);
 		if (obd_uuid_equals(&curr_tgt->ltd_uuid, &tgt_mds->ltd_uuid)) {
 			hur_out->hur_user_item[nr_out] =
-				hur_in->hur_user_item[i];
+						hur_in->hur_user_item[i];
 			nr_out++;
 		}
 	}
@@ -851,17 +850,18 @@ static int lmv_hsm_ct_register(struct lmv_obd *lmv, unsigned int cmd, int len,
 		if (err) {
 			if (lmv->tgts[i]->ltd_active) {
 				/* permanent error */
-				CERROR("error: iocontrol MDC %s on MDT"
-				       "idx %d cmd %x: err = %d\n",
-					lmv->tgts[i]->ltd_uuid.uuid,
-					i, cmd, err);
+				CERROR("%s: iocontrol MDC %s on MDT"
+				       " idx %d cmd %x: err = %d\n",
+				       class_exp2obd(lmv->exp)->obd_name,
+				       lmv->tgts[i]->ltd_uuid.uuid,
+				       i, cmd, err);
 				rc = err;
 				lk->lk_flags |= LK_FLG_STOP;
 				/* unregister from previous MDS */
 				for (j = 0; j < i; j++)
 					obd_iocontrol(cmd,
-						  lmv->tgts[j]->ltd_exp,
-						  len, lk, uarg);
+						      lmv->tgts[j]->ltd_exp,
+						      len, lk, uarg);
 				return rc;
 			}
 			/* else: transient error.
@@ -924,8 +924,8 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 
 		/* copy UUID */
 		if (copy_to_user(data->ioc_pbuf2, obd2cli_tgt(mdc_obd),
-				     min((int) data->ioc_plen2,
-					 (int) sizeof(struct obd_uuid))))
+				 min((int) data->ioc_plen2,
+				     (int) sizeof(struct obd_uuid))))
 			return -EFAULT;
 
 		rc = obd_statfs(NULL, lmv->tgts[index]->ltd_exp, &stat_buf,
@@ -934,8 +934,8 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 		if (rc)
 			return rc;
 		if (copy_to_user(data->ioc_pbuf1, &stat_buf,
-				     min((int) data->ioc_plen1,
-					 (int) sizeof(stat_buf))))
+				 min((int) data->ioc_plen1,
+				     (int) sizeof(stat_buf))))
 			return -EFAULT;
 		break;
 	}
@@ -1020,10 +1020,10 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 
 		tgt = lmv_find_target(lmv, &op_data->op_fid1);
 		if (IS_ERR(tgt))
-				return PTR_ERR(tgt);
+			return PTR_ERR(tgt);
 
 		if (tgt->ltd_exp == NULL)
-				return -EINVAL;
+			return -EINVAL;
 
 		rc = obd_iocontrol(cmd, tgt->ltd_exp, len, karg, uarg);
 		break;
@@ -1069,7 +1069,7 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 				/* build a request with fids for this MDS */
 				reqlen = offsetof(typeof(*hur),
 						  hur_user_item[nr])
-					 + hur->hur_request.hr_data_len;
+						+ hur->hur_request.hr_data_len;
 				OBD_ALLOC_LARGE(req, reqlen);
 				if (req == NULL)
 					return -ENOMEM;
@@ -1134,9 +1134,9 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 			} else if (err) {
 				if (lmv->tgts[i]->ltd_active) {
 					CERROR("error: iocontrol MDC %s on MDT"
-					       "idx %d cmd %x: err = %d\n",
-						lmv->tgts[i]->ltd_uuid.uuid,
-						i, cmd, err);
+					       " idx %d cmd %x: err = %d\n",
+					       lmv->tgts[i]->ltd_uuid.uuid,
+					       i, cmd, err);
 					if (!rc)
 						rc = err;
 				}
@@ -1342,8 +1342,8 @@ static int lmv_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 					0444, &lmv_proc_target_fops, obd);
 		if (rc)
 			CWARN("%s: error adding LMV target_obd file: rc = %d\n",
-			       obd->obd_name, rc);
-       }
+			      obd->obd_name, rc);
+	}
 #endif
 	rc = fld_client_init(&lmv->lmv_fld, obd->obd_name,
 			     LUSTRE_CLI_FLD_HASH_DHT);
-- 
1.7.9.5

