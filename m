Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaIALhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:37:06 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:61290 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaIALhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:37:04 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix 'do not use C99 // comments' errors
Date: Mon,  1 Sep 2014 06:36:14 -0500
Message-Id: <1409571374-12658-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl 'do not use C99 // comments' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c   | 4 ++--
 drivers/staging/lustre/lustre/include/lustre_cfg.h       | 2 +-
 drivers/staging/lustre/lustre/include/lustre_disk.h      | 2 +-
 drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c | 2 +-
 drivers/staging/lustre/lustre/llite/dir.c                | 2 +-
 drivers/staging/lustre/lustre/llite/llite_internal.h     | 6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index b82ba99..6c8b1e1 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -1594,8 +1594,8 @@ void ksocknal_write_callback (ksock_conn_t *conn)
 
 	conn->ksnc_tx_ready = 1;
 
-	if (!conn->ksnc_tx_scheduled && // not being progressed
-	    !list_empty(&conn->ksnc_tx_queue)){//packets to send
+	if (!conn->ksnc_tx_scheduled && /* not being progressed */
+	    !list_empty(&conn->ksnc_tx_queue)) { /* packets to send */
 		list_add_tail (&conn->ksnc_tx_list,
 				   &sched->kss_tx_conns);
 		conn->ksnc_tx_scheduled = 1;
diff --git a/drivers/staging/lustre/lustre/include/lustre_cfg.h b/drivers/staging/lustre/lustre/include/lustre_cfg.h
index 03017fe..7b385b8 100644
--- a/drivers/staging/lustre/lustre/include/lustre_cfg.h
+++ b/drivers/staging/lustre/lustre/include/lustre_cfg.h
@@ -290,4 +290,4 @@ static inline int lustre_cfg_sanity_check(void *buf, int len)
 
 /** @} cfg */
 
-#endif // _LUSTRE_CFG_H
+#endif /* _LUSTRE_CFG_H */
diff --git a/drivers/staging/lustre/lustre/include/lustre_disk.h b/drivers/staging/lustre/lustre/include/lustre_disk.h
index 7f191ee..515b835 100644
--- a/drivers/staging/lustre/lustre/include/lustre_disk.h
+++ b/drivers/staging/lustre/lustre/include/lustre_disk.h
@@ -545,4 +545,4 @@ int mgc_fsname2resid(char *fsname, struct ldlm_res_id *res_id, int type);
 
 /** @} disk */
 
-#endif // _LUSTRE_DISK_H
+#endif /* _LUSTRE_DISK_H */
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index eaa423d..be6a144 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -82,7 +82,7 @@ void libcfs_run_debug_log_upcall(char *file)
 	argv[0] = lnet_debug_log_upcall;
 
 	LASSERTF(file != NULL, "called on a null filename\n");
-	argv[1] = file; //only need to pass the path of the file
+	argv[1] = file; /* only need to pass the path of the file */
 
 	argv[2] = NULL;
 
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 55b5291..b4e46eb 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -42,7 +42,7 @@
 #include <linux/pagemap.h>
 #include <linux/mm.h>
 #include <asm/uaccess.h>
-#include <linux/buffer_head.h>   // for wait_on_buffer
+#include <linux/buffer_head.h>   /* for wait_on_buffer */
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 5c4641f..36aa0fd 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -305,8 +305,8 @@ int ll_xattr_cache_get(struct inode *inode,
 void ll_inode_size_lock(struct inode *inode);
 void ll_inode_size_unlock(struct inode *inode);
 
-// FIXME: replace the name of this with LL_I to conform to kernel stuff
-// static inline struct ll_inode_info *LL_I(struct inode *inode)
+/* FIXME: replace the name of this with LL_I to conform to kernel stuff */
+/* static inline struct ll_inode_info *LL_I(struct inode *inode) */
 static inline struct ll_inode_info *ll_i2info(struct inode *inode)
 {
 	return container_of(inode, struct ll_inode_info, lli_vfs_inode);
@@ -1036,7 +1036,7 @@ static inline struct client_obd *sbi2mdc(struct ll_sb_info *sbi)
 	return &obd->u.cli;
 }
 
-// FIXME: replace the name of this with LL_SB to conform to kernel stuff
+/* FIXME: replace the name of this with LL_SB to conform to kernel stuff */
 static inline struct ll_sb_info *ll_i2sbi(struct inode *inode)
 {
 	return ll_s2sbi(inode->i_sb);
-- 
1.9.1

