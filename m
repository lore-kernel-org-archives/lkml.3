Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaJCPRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:17:51 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33530 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaJCPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:17:48 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "else should follow close brace '}'" errors
Date: Fri,  3 Oct 2014 10:17:22 -0500
Message-Id: <1412349442-11254-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "else should follow close brace '}'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/linux/lustre_compat25.h | 6 ++----
 drivers/staging/lustre/lustre/llite/dir.c                     | 3 +--
 drivers/staging/lustre/lustre/lov/lov_pack.c                  | 3 +--
 drivers/staging/lustre/lustre/obdclass/dt_object.c            | 3 +--
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c           | 3 +--
 5 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index e94ab34..24c53cf 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -139,8 +139,7 @@ ll_quota_on(struct super_block *sb, int off, int ver, char *name, int remount)
 					   );
 		path_put(&path);
 		return rc;
-	}
-	else
+	} else
 		return -ENOSYS;
 }
 
@@ -149,8 +148,7 @@ static inline int ll_quota_off(struct super_block *sb, int off, int remount)
 	if (sb->s_qcop->quota_off) {
 		return sb->s_qcop->quota_off(sb, off
 					    );
-	}
-	else
+	} else
 		return -ENOSYS;
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index b0bb709..7225dd2 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1509,8 +1509,7 @@ out_rmdir:
 					       cmd == LL_IOC_MDC_GETINFO)) {
 				rc = 0;
 				goto skip_lmm;
-			}
-			else
+			} else
 				goto out_req;
 		}
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 5edd6a3..5356d53 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -438,8 +438,7 @@ int lov_getstripe(struct obd_export *exp, struct lov_stripe_md *lsm,
 	if (copy_from_user(&lum, lump, lum_size)) {
 		rc = -EFAULT;
 		goto out_set;
-	}
-	else if ((lum.lmm_magic != LOV_USER_MAGIC) &&
+	} else if ((lum.lmm_magic != LOV_USER_MAGIC) &&
 		 (lum.lmm_magic != LOV_USER_MAGIC_V3)) {
 		rc = -EINVAL;
 		goto out_set;
diff --git a/drivers/staging/lustre/lustre/obdclass/dt_object.c b/drivers/staging/lustre/lustre/obdclass/dt_object.c
index 52256c2..182c1fa 100644
--- a/drivers/staging/lustre/lustre/obdclass/dt_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/dt_object.c
@@ -332,8 +332,7 @@ static struct dt_object *dt_reg_open(const struct lu_env *env,
 	result = dt_lookup_dir(env, p, name, fid);
 	if (result == 0){
 		o = dt_locate(env, dt, fid);
-	}
-	else
+	} else
 		o = ERR_PTR(result);
 
 	return o;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 87b9764a..1f4e768 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -694,8 +694,7 @@ default_queue:
 	if (queue == PTLRPC_NRS_QUEUE_HP && !nrs_svc_has_hp(svc)) {
 		rc = -ENODEV;
 		goto out;
-	}
-	else if (queue == PTLRPC_NRS_QUEUE_BOTH && !nrs_svc_has_hp(svc))
+	} else if (queue == PTLRPC_NRS_QUEUE_BOTH && !nrs_svc_has_hp(svc))
 		queue = PTLRPC_NRS_QUEUE_REG;
 
 	/**
-- 
1.9.1

