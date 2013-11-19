Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3KSN1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:27:53 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42648 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3KSN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:32 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 5/9] staging/lustre/lnet: coding style fix for lst_test_add_ioctl
Date: Tue, 19 Nov 2013 21:23:44 +0800
Message-Id: <1384867428-8395-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

To make the function a bit easier to read.

This is coding style fix part of original Lustre commit in external tree.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3093
Lustre-change: http://review.whamcloud.com/6092
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/conctl.c |   56 ++++++++++++-------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index bce3d3b..cbc416d 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -723,12 +723,12 @@ lst_stat_query_ioctl(lstio_stat_args_t *args)
 
 int lst_test_add_ioctl(lstio_test_args_t *args)
 {
-	char	   *name;
-	char	   *srcgrp = NULL;
-	char	   *dstgrp = NULL;
-	void	   *param = NULL;
-	int	     ret = 0;
-	int	     rc = -ENOMEM;
+	char		*batch_name;
+	char		*src_name = NULL;
+	char		*dst_name = NULL;
+	void		*param = NULL;
+	int		ret = 0;
+	int		rc = -ENOMEM;
 
 	if (args->lstio_tes_resultp == NULL ||
 	    args->lstio_tes_retp == NULL ||
@@ -755,16 +755,16 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 	     args->lstio_tes_param_len > PAGE_CACHE_SIZE - sizeof(lstcon_test_t)))
 		return -EINVAL;
 
-	LIBCFS_ALLOC(name, args->lstio_tes_bat_nmlen + 1);
-	if (name == NULL)
+	LIBCFS_ALLOC(batch_name, args->lstio_tes_bat_nmlen + 1);
+	if (batch_name == NULL)
 		return rc;
 
-	LIBCFS_ALLOC(srcgrp, args->lstio_tes_sgrp_nmlen + 1);
-	if (srcgrp == NULL)
+	LIBCFS_ALLOC(src_name, args->lstio_tes_sgrp_nmlen + 1);
+	if (src_name == NULL)
 		goto out;
 
-	LIBCFS_ALLOC(dstgrp, args->lstio_tes_dgrp_nmlen + 1);
-	 if (dstgrp == NULL)
+	LIBCFS_ALLOC(dst_name, args->lstio_tes_dgrp_nmlen + 1);
+	 if (dst_name == NULL)
 		goto out;
 
 	if (args->lstio_tes_param != NULL) {
@@ -774,39 +774,37 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 	}
 
 	rc = -EFAULT;
-	if (copy_from_user(name,
-			      args->lstio_tes_bat_name,
-			      args->lstio_tes_bat_nmlen) ||
-	    copy_from_user(srcgrp,
-			      args->lstio_tes_sgrp_name,
-			      args->lstio_tes_sgrp_nmlen) ||
-	    copy_from_user(dstgrp,
-			      args->lstio_tes_dgrp_name,
-			      args->lstio_tes_dgrp_nmlen) ||
+	if (copy_from_user(batch_name, args->lstio_tes_bat_name,
+			   args->lstio_tes_bat_nmlen) ||
+	    copy_from_user(src_name, args->lstio_tes_sgrp_name,
+			   args->lstio_tes_sgrp_nmlen) ||
+	    copy_from_user(dst_name, args->lstio_tes_dgrp_name,
+			   args->lstio_tes_dgrp_nmlen) ||
 	    copy_from_user(param, args->lstio_tes_param,
 			      args->lstio_tes_param_len))
 		goto out;
 
-	rc = lstcon_test_add(name,
+	rc = lstcon_test_add(batch_name,
 			    args->lstio_tes_type,
 			    args->lstio_tes_loop,
 			    args->lstio_tes_concur,
 			    args->lstio_tes_dist, args->lstio_tes_span,
-			    srcgrp, dstgrp, param, args->lstio_tes_param_len,
+			    src_name, dst_name, param,
+			    args->lstio_tes_param_len,
 			    &ret, args->lstio_tes_resultp);
 
 	if (ret != 0)
 		rc = (copy_to_user(args->lstio_tes_retp, &ret,
 				       sizeof(ret))) ? -EFAULT : 0;
 out:
-	if (name != NULL)
-		LIBCFS_FREE(name, args->lstio_tes_bat_nmlen + 1);
+	if (batch_name != NULL)
+		LIBCFS_FREE(batch_name, args->lstio_tes_bat_nmlen + 1);
 
-	if (srcgrp != NULL)
-		LIBCFS_FREE(srcgrp, args->lstio_tes_sgrp_nmlen + 1);
+	if (src_name != NULL)
+		LIBCFS_FREE(src_name, args->lstio_tes_sgrp_nmlen + 1);
 
-	if (dstgrp != NULL)
-		LIBCFS_FREE(dstgrp, args->lstio_tes_dgrp_nmlen + 1);
+	if (dst_name != NULL)
+		LIBCFS_FREE(dst_name, args->lstio_tes_dgrp_nmlen + 1);
 
 	if (param != NULL)
 		LIBCFS_FREE(param, args->lstio_tes_param_len);
-- 
1.7.9.5

