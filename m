Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaEERtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:49:05 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:9616 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbaEERtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:49:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAC3OZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkCgmIRQHMEYVWiHyERgEDjxqKGQGKfod2gzY7
Date: Mon, 5 May 2014 19:49:00 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/2] kernel/cpuset.c: convert printk to pr_foo()
Message-Id: <20140505194900.a0679fd326208e0b56e51f5e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/cpuset.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1d8c047..7c0e8da 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -696,11 +696,8 @@ restart:
 		if (nslot == ndoms) {
 			static int warnings = 10;
 			if (warnings) {
-				printk(KERN_WARNING
-				 "rebuild_sched_domains confused:"
-				  " nslot %d, ndoms %d, csn %d, i %d,"
-				  " apn %d\n",
-				  nslot, ndoms, csn, i, apn);
+				pr_warn("rebuild_sched_domains confused: nslot %d, ndoms %d, csn %d, i %d, apn %d\n",
+					nslot, ndoms, csn, i, apn);
 				warnings--;
 			}
 			continue;
@@ -2018,7 +2015,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 		parent = parent_cs(parent);
 
 	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
-		printk(KERN_ERR "cpuset: failed to transfer tasks out of empty cpuset ");
+		pr_err("cpuset: failed to transfer tasks out of empty cpuset ");
 		pr_cont_cgroup_name(cs->css.cgroup);
 		pr_cont("\n");
 	}
@@ -2555,7 +2552,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 	cgrp = task_cs(tsk)->css.cgroup;
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
-	printk(KERN_INFO "%s cpuset=", tsk->comm);
+	pr_info("%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
 	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
 
-- 
1.9.1
