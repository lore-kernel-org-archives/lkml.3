Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3FYTvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:51:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62167 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3FYTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:51:50 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children unconditionally
Date: Tue, 25 Jun 2013 12:51:45 -0700
Message-Id: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
is hidden under CONFIG_EXPERT.  It's generally useful functionality,
though, so expose it unconditionally.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/proc/array.c | 2 --
 fs/proc/base.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..96d3e3e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -598,7 +598,6 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static struct pid *
 get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 {
@@ -719,4 +718,3 @@ const struct file_operations proc_tid_children_operations = {
 	.llseek  = seq_lseek,
 	.release = children_seq_release,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..34396a9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2866,9 +2866,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("children",  S_IRUGO, proc_tid_children_operations),
-#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_tid_numa_maps_operations),
 #endif
-- 
1.8.1.4

