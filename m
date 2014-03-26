Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaCZF4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:56:32 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54613 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaCZF4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:56:31 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, chad@dahc.us, viro@zeniv.linux.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: silicom: hide conditionally used function in condition
Date: Wed, 26 Mar 2014 14:58:50 +0900
Message-Id: <1395813530-2684-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bp_proc_create() be called only when BP_PROC_SUPPORT defined but its
definition live outside of #ifdef BP_PROC_SUPPORT and cause following
trivial build warning:
drivers/staging/silicom/bpctl_mod.c:6786:12: warning:
‘bp_proc_create’ defined but not used [-Wunused-function]
 static int bp_proc_create(void)
            ^

Fix the warning by hide the definition inside #ifdef BP_PROC_SUPPORT.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6b9365b..beff280 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -119,7 +119,9 @@ static void if_scan_init(void);
 
 static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
 static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
+#ifdef BP_PROC_SUPPORT
 static int bp_proc_create(void);
+#endif
 
 static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 static int get_dev_idx_bsf(int bus, int slot, int func);
@@ -6783,6 +6785,7 @@ EXPORT_SYMBOL(bp_if_scan_sd);
 
 static struct proc_dir_entry *bp_procfs_dir;
 
+#ifdef BP_PROC_SUPPORT
 static int bp_proc_create(void)
 {
 	bp_procfs_dir = proc_mkdir(BP_PROC_DIR, init_net.proc_net);
@@ -6794,6 +6797,7 @@ static int bp_proc_create(void)
 	}
 	return 0;
 }
+#endif
 
 static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
-- 
1.8.3.2

