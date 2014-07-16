Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaGPVeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:34:44 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61822 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaGPVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:34:40 -0400
Date: Thu, 17 Jul 2014 00:34:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] proc: convert /proc/$PID/schedstat to seq_file
 interface
Message-ID: <20140716213434.GE21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -311,9 +311,10 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 /*
  * Provides /proc/PID/schedstat
  */
-static int proc_pid_schedstat(struct task_struct *task, char *buffer)
+static int proc_pid_schedstat(struct seq_file *m, struct pid_namespace *ns,
+			      struct pid *pid, struct task_struct *task)
 {
-	return sprintf(buffer, "%llu %llu %lu\n",
+	return seq_printf(m, "%llu %llu %lu\n",
 			(unsigned long long)task->se.sum_exec_runtime,
 			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
@@ -2605,7 +2606,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat",  S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
@@ -2943,7 +2944,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat", S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat", S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
