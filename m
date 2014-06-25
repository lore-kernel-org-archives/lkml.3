Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaFYE6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:58:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59091 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaFYE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:58:38 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 3/4] staging: lustre: llite: dir.c - fixes indented labels in code
Date: Wed, 25 Jun 2014 14:57:29 +1000
Message-Id: <1403672250-19048-3-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403672250-19048-1-git-send-email-askb23@gmail.com>
References: <1403672250-19048-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixes "WARNING: labels should not be indented"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/llite/dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index ae6f61a..5d096d8 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1501,7 +1501,7 @@ out_rmdir:
 				GOTO(out_req, rc = -EFAULT);
 			rc = -EOVERFLOW;
 		}
-	skip_lmm:
+skip_lmm:
 		if (cmd == IOC_MDC_GETFILEINFO || cmd == LL_IOC_MDC_GETINFO) {
 			struct lov_user_mds_data *lmdp;
 			lstat_t st = { 0 };
@@ -1525,7 +1525,7 @@ out_rmdir:
 				GOTO(out_req, rc = -EFAULT);
 		}
 
-	out_req:
+out_req:
 		ptlrpc_req_finished(request);
 		if (filename)
 			ll_putname(filename);
@@ -1589,9 +1589,9 @@ out_rmdir:
 		if (copy_to_user(&lumd->lmd_st, &st, sizeof(st)))
 			GOTO(free_lsm, rc = -EFAULT);
 
-	free_lsm:
+free_lsm:
 		obd_free_memmd(sbi->ll_dt_exp, &lsm);
-	free_lmm:
+free_lmm:
 		OBD_FREE_LARGE(lmm, lmmsize);
 		return rc;
 	}
@@ -1653,7 +1653,7 @@ out_rmdir:
 				CDEBUG(D_QUOTA, "copy_to_user failed\n");
 			GOTO(out_poll, rc);
 		}
-	out_poll:
+out_poll:
 		OBD_FREE_PTR(check);
 		return rc;
 	}
@@ -1702,9 +1702,9 @@ out_rmdir:
 				rc = -EFAULT;
 		}
 
-	out_quotactl_20:
+out_quotactl_20:
 		OBD_FREE_PTR(qctl_20);
-	out_quotactl_18:
+out_quotactl_18:
 		OBD_FREE_PTR(qctl_18);
 		return rc;
 	}
@@ -1726,7 +1726,7 @@ out_rmdir:
 		if (rc == 0 && copy_to_user((void *)arg,qctl,sizeof(*qctl)))
 			rc = -EFAULT;
 
-	out_quotactl:
+out_quotactl:
 		OBD_FREE_PTR(qctl);
 		return rc;
 	}
-- 
1.9.0

