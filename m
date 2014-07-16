Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaGPVeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:34:15 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55337 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaGPVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:34:11 -0400
Date: Thu, 17 Jul 2014 00:34:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] proc: convert /proc/$PID/wchan to seq_file interface
Message-ID: <20140716213401.GD21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -235,7 +235,8 @@ static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
  * Returns the resolved symbol.  If that fails, simply return the address.
  */
-static int proc_pid_wchan(struct task_struct *task, char *buffer)
+static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
@@ -246,9 +247,9 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			return 0;
 		else
-			return sprintf(buffer, "%lu", wchan);
+			return seq_printf(m, "%lu", wchan);
 	else
-		return sprintf(buffer, "%s", symname);
+		return seq_printf(m, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
@@ -2598,7 +2599,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",      S_IRUGO, proc_pid_wchan),
+	ONE("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
@@ -2936,7 +2937,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",     S_IRUGO, proc_pid_wchan),
+	ONE("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
