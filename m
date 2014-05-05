Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaEERrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:47:04 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:48800 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbaEERrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:47:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAGrNZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwNhVaIfIRGAQOPGooZAZJ0gzY7
Date: Mon, 5 May 2014 19:46:55 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/2] kernel/cpuset.c: kernel-doc fixes
Message-Id: <20140505194655.6d1304a0826c107debdbbe30@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also converts seq_printf to seq_puts

Cc: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/cpuset.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d54c41..1d8c047 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -890,6 +890,7 @@ static void update_tasks_cpumask_hier(struct cpuset *root_cs, bool update_root)
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
+ * @trialcs: trial cpuset
  * @buf: buffer of cpu numbers written to this cpuset
  */
 static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
@@ -2536,7 +2537,7 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
- * @task: pointer to task_struct of some task.
+ * @tsk: pointer to task_struct of some task.
  *
  * Description: Prints @task's name, cpuset name, and cached copy of its
  * mems_allowed to the kernel log.
@@ -2646,10 +2647,10 @@ out:
 /* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_printf(m, "Mems_allowed:\t");
+	seq_puts(m, "Mems_allowed:\t");
 	seq_nodemask(m, &task->mems_allowed);
-	seq_printf(m, "\n");
-	seq_printf(m, "Mems_allowed_list:\t");
+	seq_puts(m, "\n");
+	seq_puts(m, "Mems_allowed_list:\t");
 	seq_nodemask_list(m, &task->mems_allowed);
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 }
-- 
1.9.1
