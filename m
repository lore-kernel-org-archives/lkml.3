Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbbAROIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:08:18 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:54568 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbbAROIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:10 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: lustre: mdc: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:47 +0100
Message-Id: <1421590012-7082-2-git-send-email-luca@lucaceresoli.net>
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
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 54 ++++++++++++-------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 05d05ce..ef27447 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -855,8 +855,8 @@ static void mdc_close_handle_reply(struct ptlrpc_request *req,
 	}
 }
 
-int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
-	      struct md_open_data *mod, struct ptlrpc_request **request)
+static int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
+		     struct md_open_data *mod, struct ptlrpc_request **request)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -974,8 +974,8 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 	return rc < 0 ? rc : saved_rc;
 }
 
-int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
-		     struct md_open_data *mod)
+static int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
+			    struct md_open_data *mod)
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct ptlrpc_request *req;
@@ -1044,8 +1044,8 @@ int mdc_done_writing(struct obd_export *exp, struct md_op_data *op_data,
 }
 
 
-int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
-		 struct page **pages, struct ptlrpc_request **request)
+static int mdc_readpage(struct obd_export *exp, struct md_op_data *op_data,
+			struct page **pages, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request   *req;
 	struct ptlrpc_bulk_desc *desc;
@@ -1974,9 +1974,9 @@ out:
 	return rc;
 }
 
-int mdc_get_info_rpc(struct obd_export *exp,
-		     u32 keylen, void *key,
-		     int vallen, void *val)
+static int mdc_get_info_rpc(struct obd_export *exp,
+			    u32 keylen, void *key,
+			    int vallen, void *val)
 {
 	struct obd_import      *imp = class_exp2cliimp(exp);
 	struct ptlrpc_request  *req;
@@ -2148,11 +2148,11 @@ static int mdc_kuc_reregister(struct obd_import *imp)
 					 (void *)imp);
 }
 
-int mdc_set_info_async(const struct lu_env *env,
-		       struct obd_export *exp,
-		       u32 keylen, void *key,
-		       u32 vallen, void *val,
-		       struct ptlrpc_request_set *set)
+static int mdc_set_info_async(const struct lu_env *env,
+			      struct obd_export *exp,
+			      u32 keylen, void *key,
+			      u32 vallen, void *val,
+			      struct ptlrpc_request_set *set)
 {
 	struct obd_import	*imp = class_exp2cliimp(exp);
 	int			 rc;
@@ -2199,9 +2199,9 @@ int mdc_set_info_async(const struct lu_env *env,
 	return -EINVAL;
 }
 
-int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
-		 __u32 keylen, void *key, __u32 *vallen, void *val,
-		 struct lov_stripe_md *lsm)
+static int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
+			__u32 keylen, void *key, __u32 *vallen, void *val,
+			struct lov_stripe_md *lsm)
 {
 	int rc = -EINVAL;
 
@@ -2263,8 +2263,8 @@ int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
 	return rc;
 }
 
-int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
-	     struct obd_capa *oc, struct ptlrpc_request **request)
+static int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
+		    struct obd_capa *oc, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -2356,7 +2356,7 @@ int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 	return seq_client_alloc_fid(NULL, seq, fid);
 }
 
-struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
+static struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
 {
 	struct client_obd *cli = &exp->exp_obd->u.cli;
 
@@ -2390,7 +2390,7 @@ static int mdc_resource_inode_free(struct ldlm_resource *res)
 	return 0;
 }
 
-struct ldlm_valblock_ops inode_lvbo = {
+static struct ldlm_valblock_ops inode_lvbo = {
 	.lvbo_free = mdc_resource_inode_free,
 };
 
@@ -2550,9 +2550,9 @@ static int mdc_process_config(struct obd_device *obd, u32 len, void *buf)
 
 
 /* get remote permission for current user on fid */
-int mdc_get_remote_perm(struct obd_export *exp, const struct lu_fid *fid,
-			struct obd_capa *oc, __u32 suppgid,
-			struct ptlrpc_request **request)
+static int mdc_get_remote_perm(struct obd_export *exp, const struct lu_fid *fid,
+			       struct obd_capa *oc, __u32 suppgid,
+			       struct ptlrpc_request **request)
 {
 	struct ptlrpc_request  *req;
 	int		    rc;
@@ -2647,7 +2647,7 @@ static int mdc_renew_capa(struct obd_export *exp, struct obd_capa *oc,
 	return 0;
 }
 
-struct obd_ops mdc_obd_ops = {
+static struct obd_ops mdc_obd_ops = {
 	.o_owner	    = THIS_MODULE,
 	.o_setup	    = mdc_setup,
 	.o_precleanup       = mdc_precleanup,
@@ -2670,7 +2670,7 @@ struct obd_ops mdc_obd_ops = {
 	.o_quotacheck       = mdc_quotacheck
 };
 
-struct md_ops mdc_md_ops = {
+static struct md_ops mdc_md_ops = {
 	.m_getstatus	= mdc_getstatus,
 	.m_null_inode	    = mdc_null_inode,
 	.m_find_cbdata      = mdc_find_cbdata,
@@ -2705,7 +2705,7 @@ struct md_ops mdc_md_ops = {
 	.m_revalidate_lock      = mdc_revalidate_lock
 };
 
-int __init mdc_init(void)
+static int __init mdc_init(void)
 {
 	int rc;
 	struct lprocfs_static_vars lvars = { NULL };
-- 
1.9.1

