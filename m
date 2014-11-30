Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaK3KI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:08:26 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60307 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaK3KIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:08:25 -0500
From: Janet Liu <jianhua.ljh@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv1] staging: lustre: fixed sparse warnings related to static declarations
Date: Sun, 30 Nov 2014 18:08:10 +0800
Message-Id: <1417342090-8012-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/lustre/lustre/mdc/mdc_request.c:63:5: warning: symbol 'mdc_unpack_capa' was not declared. Should it be static?
drivers/staging/lustre/lustre/mdc/mdc_request.c:150:5: warning: symbol 'mdc_getstatus' was not declared. Should it be static?
drivers/staging/lustre/lustre/mdc/mdc_request.c:217:5: warning: symbol 'mdc_getattr' was not declared. Should it be static?
drivers/staging/lustre/lustre/mdc/mdc_request.c:261:5: warning: symbol 'mdc_getattr_name' was not declared. Should it be static?
drivers/staging/lustre/lustre/mdc/mdc_request.c:444:5: warning: symbol 'mdc_setxattr' was not declared. Should it be static?
drivers/staging/lustre/lustre/mdc/mdc_request.c:455:5: warning: symbol 'mdc_getxattr' was not declared. Should it be static?

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 14e1ba1..3b0f245 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -60,7 +60,7 @@ struct mdc_renew_capa_args {
 
 static int mdc_cleanup(struct obd_device *obd);
 
-int mdc_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
+static int mdc_unpack_capa(struct obd_export *exp, struct ptlrpc_request *req,
 		    const struct req_msg_field *field, struct obd_capa **oc)
 {
 	struct lustre_capa *capa;
@@ -147,7 +147,7 @@ out:
 }
 
 /* This should be mdc_get_info("rootfid") */
-int mdc_getstatus(struct obd_export *exp, struct lu_fid *rootfid,
+static int mdc_getstatus(struct obd_export *exp, struct lu_fid *rootfid,
 		  struct obd_capa **pc)
 {
 	return send_getstatus(class_exp2cliimp(exp), rootfid, pc,
@@ -214,7 +214,7 @@ static int mdc_getattr_common(struct obd_export *exp,
 	return 0;
 }
 
-int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
+static int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
 		struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
@@ -258,7 +258,7 @@ int mdc_getattr(struct obd_export *exp, struct md_op_data *op_data,
 	return rc;
 }
 
-int mdc_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
+static int mdc_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
 		     struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
@@ -441,7 +441,7 @@ static int mdc_xattr_common(struct obd_export *exp,
 	return rc;
 }
 
-int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
+static int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
 		 struct obd_capa *oc, u64 valid, const char *xattr_name,
 		 const char *input, int input_size, int output_size,
 		 int flags, __u32 suppgid, struct ptlrpc_request **request)
@@ -452,7 +452,7 @@ int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
 				suppgid, request);
 }
 
-int mdc_getxattr(struct obd_export *exp, const struct lu_fid *fid,
+static int mdc_getxattr(struct obd_export *exp, const struct lu_fid *fid,
 		 struct obd_capa *oc, u64 valid, const char *xattr_name,
 		 const char *input, int input_size, int output_size,
 		 int flags, struct ptlrpc_request **request)
-- 
1.7.9.5

