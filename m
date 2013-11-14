Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3KNQle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3KNQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:23 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 30/39] staging/lustre/build: build error with gcc 4.7.0 20110509
Date: Fri, 15 Nov 2013 00:32:53 +0800
Message-Id: <1384446782-13741-31-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Fixed the error: 'tgt' and 'nf' may be used uninitialized in
this function. Also fixed comparison signed and unsigned
indexes.

Lustre-change: http://review.whamcloud.com/7382
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3775
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c |   50 +++++++++++++++------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 9d36014..2587f1a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -257,9 +257,9 @@ static int lmv_connect(const struct lu_env *env,
 
 static void lmv_set_timeouts(struct obd_device *obd)
 {
-	struct lmv_tgt_desc   *tgt;
-	struct lmv_obd	*lmv;
-	int		    i;
+	struct lmv_tgt_desc	*tgt;
+	struct lmv_obd		*lmv;
+	__u32			 i;
 
 	lmv = &obd->u.lmv;
 	if (lmv->server_timeout == 0)
@@ -283,7 +283,7 @@ static int lmv_init_ea_size(struct obd_export *exp, int easize,
 {
 	struct obd_device   *obd = exp->exp_obd;
 	struct lmv_obd      *lmv = &obd->u.lmv;
-	int		  i;
+	__u32			 i;
 	int		  rc = 0;
 	int		  change = 0;
 
@@ -540,7 +540,7 @@ int lmv_check_connect(struct obd_device *obd)
 {
 	struct lmv_obd       *lmv = &obd->u.lmv;
 	struct lmv_tgt_desc  *tgt;
-	int		   i;
+	__u32			 i;
 	int		   rc;
 	int		   easize;
 
@@ -652,7 +652,7 @@ static int lmv_disconnect(struct obd_export *exp)
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct lmv_obd	*lmv = &obd->u.lmv;
 	int		    rc;
-	int		    i;
+	__u32		    i;
 
 	if (!lmv->tgts)
 		goto out_local;
@@ -776,8 +776,9 @@ static int lmv_hsm_req_count(struct lmv_obd *lmv,
 			     const struct hsm_user_request *hur,
 			     const struct lmv_tgt_desc *tgt_mds)
 {
-	int			i, nr = 0;
-	struct lmv_tgt_desc    *curr_tgt;
+	__u32			 i;
+	int			 nr = 0;
+	struct lmv_tgt_desc	*curr_tgt;
 
 	/* count how many requests must be sent to the given target */
 	for (i = 0; i < hur->hur_request.hr_itemcount; i++) {
@@ -793,8 +794,8 @@ static void lmv_hsm_req_build(struct lmv_obd *lmv,
 			      const struct lmv_tgt_desc *tgt_mds,
 			      struct hsm_user_request *hur_out)
 {
-	int			i, nr_out;
-	struct lmv_tgt_desc    *curr_tgt;
+	__u32			 i, nr_out;
+	struct lmv_tgt_desc	*curr_tgt;
 
 	/* build the hsm_user_request for the given target */
 	hur_out->hur_request = hur_in->hur_request;
@@ -816,7 +817,8 @@ static void lmv_hsm_req_build(struct lmv_obd *lmv,
 static int lmv_hsm_ct_unregister(struct lmv_obd *lmv, unsigned int cmd, int len,
 				 struct lustre_kernelcomm *lk, void *uarg)
 {
-	int	i, rc = 0;
+	__u32	i;
+	int	rc;
 
 	/* unregister request (call from llapi_hsm_copytool_fini) */
 	for (i = 0; i < lmv->desc.ld_tgt_count; i++) {
@@ -837,8 +839,8 @@ static int lmv_hsm_ct_register(struct lmv_obd *lmv, unsigned int cmd, int len,
 			       struct lustre_kernelcomm *lk, void *uarg)
 {
 	struct file	*filp;
-	int		 i, j, err;
-	int		 rc = 0;
+	__u32		 i, j;
+	int		 err, rc;
 	bool		 any_set = false;
 
 	/* All or nothing: try to register to all MDS.
@@ -895,10 +897,10 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 {
 	struct obd_device    *obddev = class_exp2obd(exp);
 	struct lmv_obd       *lmv = &obddev->u.lmv;
-	int		   i = 0;
+	__u32		   i = 0;
 	int		   rc = 0;
 	int		   set = 0;
-	int		   count = lmv->desc.ld_tgt_count;
+	__u32		   count = lmv->desc.ld_tgt_count;
 
 	if (count == 0)
 		return -ENOTTY;
@@ -1414,7 +1416,7 @@ static int lmv_statfs(const struct lu_env *env, struct obd_export *exp,
 	struct lmv_obd	*lmv = &obd->u.lmv;
 	struct obd_statfs     *temp;
 	int		    rc = 0;
-	int		    i;
+	__u32		    i;
 
 	rc = lmv_check_connect(obd);
 	if (rc)
@@ -1584,7 +1586,7 @@ static int lmv_find_cbdata(struct obd_export *exp, const struct lu_fid *fid,
 {
 	struct obd_device   *obd = exp->exp_obd;
 	struct lmv_obd      *lmv = &obd->u.lmv;
-	int		  i;
+	__u32                i;
 	int		  rc;
 
 	rc = lmv_check_connect(obd);
@@ -2410,7 +2412,7 @@ int lmv_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
 	struct lmv_stripe_md      *meap;
 	struct lmv_stripe_md      *lsmp;
 	int			mea_size;
-	int			i;
+	__u32                      i;
 
 	mea_size = lmv_get_easize(lmv);
 	if (!lmmp)
@@ -2458,7 +2460,7 @@ int lmv_unpackmd(struct obd_export *exp, struct lov_stripe_md **lsmp,
 	struct lmv_stripe_md       *mea = (struct lmv_stripe_md *)lmm;
 	struct lmv_obd	     *lmv = &obd->u.lmv;
 	int			 mea_size;
-	int			 i;
+	__u32                       i;
 	__u32		       magic;
 
 	mea_size = lmv_get_easize(lmv);
@@ -2512,7 +2514,7 @@ static int lmv_cancel_unused(struct obd_export *exp, const struct lu_fid *fid,
 	struct lmv_obd	  *lmv = &obd->u.lmv;
 	int		      rc = 0;
 	int		      err;
-	int		      i;
+	__u32                    i;
 
 	LASSERT(fid != NULL);
 
@@ -2547,7 +2549,7 @@ ldlm_mode_t lmv_lock_match(struct obd_export *exp, __u64 flags,
 	struct obd_device       *obd = exp->exp_obd;
 	struct lmv_obd	  *lmv = &obd->u.lmv;
 	ldlm_mode_t	      rc;
-	int		      i;
+	__u32                    i;
 
 	CDEBUG(D_INODE, "Lock match for "DFID"\n", PFID(fid));
 
@@ -2723,7 +2725,8 @@ int lmv_quotactl(struct obd_device *unused, struct obd_export *exp,
 	struct obd_device   *obd = class_exp2obd(exp);
 	struct lmv_obd      *lmv = &obd->u.lmv;
 	struct lmv_tgt_desc *tgt = lmv->tgts[0];
-	int		  rc = 0, i;
+	int                  rc = 0;
+	__u32                i;
 	__u64		curspace, curinodes;
 
 	if (!lmv->desc.ld_tgt_count || !tgt->ltd_active) {
@@ -2770,7 +2773,8 @@ int lmv_quotacheck(struct obd_device *unused, struct obd_export *exp,
 	struct obd_device   *obd = class_exp2obd(exp);
 	struct lmv_obd      *lmv = &obd->u.lmv;
 	struct lmv_tgt_desc *tgt;
-	int		  i, rc = 0;
+	int		    rc = 0;
+	__u32		    i;
 
 	for (i = 0; i < lmv->desc.ld_tgt_count; i++) {
 		int err;
-- 
1.7.9.5

