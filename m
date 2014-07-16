Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaGPVf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:35:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:41733 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGPVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:35:23 -0400
Date: Thu, 17 Jul 2014 00:35:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] proc: convert /proc/$PID/oom_score to seq_file
 interface
Message-ID: <20140716213515.GF21290@p183.telecom.by>
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
@@ -412,7 +412,8 @@ static const struct file_operations proc_cpuset_operations = {
 };
 #endif
 
-static int proc_oom_score(struct task_struct *task, char *buffer)
+static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
@@ -422,7 +423,7 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 		points = oom_badness(task, NULL, NULL, totalpages) *
 						1000 / totalpages;
 	read_unlock(&tasklist_lock);
-	return sprintf(buffer, "%lu\n", points);
+	return seq_printf(m, "%lu\n", points);
 }
 
 struct limit_names {
@@ -2617,7 +2618,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score",  S_IRUGO, proc_oom_score),
+	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
@@ -2955,7 +2956,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score", S_IRUGO, proc_oom_score),
+	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
