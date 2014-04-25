Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaDYJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:42:20 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61130 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaDYJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:42:14 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 2/3] Staging: lustre: ops structs should be declared static
Date: Fri, 25 Apr 2014 11:41:42 +0200
Message-Id: <1398418903-13315-3-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following sparse complaints:

drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:549:22:
	warning: symbol 'ldlm_srv_pool_ops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:555:22:
	warning: symbol 'ldlm_cli_pool_ops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:681:1:
	warning: symbol 'lprocfs_pool_state_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:697:1:
	warning: symbol 'lprocfs_grant_plan_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:700:1:
	warning: symbol 'lprocfs_wr_recalc_period' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:708:1:
	warning: symbol 'lprocfs_recalc_period_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:710:1:
	warning: symbol 'ldlm_pool_u64_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:711:1:
	warning: symbol 'ldlm_pool_atomic_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:712:1:
	warning: symbol 'ldlm_pool_rw_atomic_fops' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:714:1:
	warning: symbol 'lprocfs_grant_speed_fops' was not declared. Should it be static?

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/lustre/lustre/include/lprocfs_status.h | 4 ++--
 drivers/staging/lustre/lustre/include/lustre_dlm.h     | 2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h     | 2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c         | 4 ++--
 drivers/staging/lustre/lustre/llite/lproc_llite.c      | 6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 428e3e4..9ce12c7 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -687,7 +687,7 @@ static int name##_single_open(cfs_inode_t *inode, struct file *file)	\
 {									\
 	return single_open(file, name##_seq_show, PDE_DATA(inode));	\
 }									\
-struct file_operations name##_fops = {				     \
+static struct file_operations name##_fops = {				\
 	.owner   = THIS_MODULE,					    \
 	.open    = name##_single_open,				     \
 	.read    = seq_read,					       \
@@ -730,7 +730,7 @@ struct file_operations name##_fops = {				     \
 	{								\
 		return single_open(file, NULL, PDE_DATA(inode));	\
 	}								\
-	struct file_operations name##_##type##_fops = {			\
+	static struct file_operations name##_##type##_fops = {	\
 		.open	= name##_##type##_open,				\
 		.write	= name##_##type##_write,			\
 		.release = lprocfs_single_release,			\
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index ed10313..154b1e1 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -260,7 +260,7 @@ struct ldlm_pool {
 	/** Recalculation period for pool. */
 	time_t			pl_recalc_period;
 	/** Recalculation and shrink operations. */
-	struct ldlm_pool_ops	*pl_ops;
+	const struct ldlm_pool_ops	*pl_ops;
 	/** Number of planned locks for next period. */
 	int			pl_grant_plan;
 	/** Pool statistics. */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
index 8cd7963..f997566 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
@@ -247,7 +247,7 @@ typedef enum ldlm_policy_res ldlm_policy_res_t;
 	struct __##var##__dummy_read {;} /* semicolon catcher */
 
 #define LDLM_POOL_PROC_WRITER(var, type)				    \
-	int lprocfs_wr_##var(struct file *file, const char *buffer,	    \
+	static int lprocfs_wr_##var(struct file *file, const char *buffer,  \
 			     unsigned long count, void *data)		    \
 	{								    \
 		struct ldlm_pool *pl = data;				    \
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 5fa9ef4..ccb1e04 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -546,13 +546,13 @@ static int ldlm_cli_pool_shrink(struct ldlm_pool *pl,
 		return ldlm_cancel_lru(ns, nr, LCF_ASYNC, LDLM_CANCEL_SHRINK);
 }
 
-struct ldlm_pool_ops ldlm_srv_pool_ops = {
+static const struct ldlm_pool_ops ldlm_srv_pool_ops = {
 	.po_recalc = ldlm_srv_pool_recalc,
 	.po_shrink = ldlm_srv_pool_shrink,
 	.po_setup  = ldlm_srv_pool_setup
 };
 
-struct ldlm_pool_ops ldlm_cli_pool_ops = {
+static const struct ldlm_pool_ops ldlm_cli_pool_ops = {
 	.po_recalc = ldlm_cli_pool_recalc,
 	.po_shrink = ldlm_cli_pool_shrink
 };
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index a9a104a..021deb9 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -44,9 +44,9 @@
 
 /* /proc/lustre/llite mount point registration */
 extern struct file_operations vvp_dump_pgcache_file_ops;
-struct file_operations ll_rw_extents_stats_fops;
-struct file_operations ll_rw_extents_stats_pp_fops;
-struct file_operations ll_rw_offset_stats_fops;
+static struct file_operations ll_rw_extents_stats_fops;
+static struct file_operations ll_rw_extents_stats_pp_fops;
+static struct file_operations ll_rw_offset_stats_fops;
 
 static int ll_blksize_seq_show(struct seq_file *m, void *v)
 {
-- 
1.9.1

