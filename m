Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaEERfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:35:20 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:12782 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbaEERfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:35:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAK3KZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwHhVaIfIRGAQOPGooZAYp+h3aDNjs
Date: Mon, 5 May 2014 19:35:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/1] kernel/cgroup.c: replace pr_warning by pr_warn
Message-Id: <20140505193517.e8f4be9e4f9866ffcfa3de28@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes 2 kernel-doc warnings.

Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..f9603f9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1017,9 +1017,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		 * Just warn about it and continue.
 		 */
 		if (cgrp_dfl_root_visible) {
-			pr_warning("cgroup: failed to create files (%d) while rebinding 0x%lx to default root\n",
+			pr_warn("cgroup: failed to create files (%d) while rebinding 0x%lx to default root\n",
 				   ret, ss_mask);
-			pr_warning("cgroup: you may retry by moving them to a different hierarchy and unbinding\n");
+			pr_warn("cgroup: you may retry by moving them to a different hierarchy and unbinding\n");
 		}
 	}
 
@@ -1210,7 +1210,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	/* Consistency checks */
 
 	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
-		pr_warning("cgroup: sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
+		pr_warn("cgroup: sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
 
 		if ((opts->flags & (CGRP_ROOT_NOPREFIX | CGRP_ROOT_XATTR)) ||
 		    opts->cpuset_clone_children || opts->release_agent ||
@@ -1274,7 +1274,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		goto out_unlock;
 
 	if (opts.subsys_mask != root->cgrp.subsys_mask || opts.release_agent)
-		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
+		pr_warn("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
 
 	added_mask = opts.subsys_mask & ~root->cgrp.subsys_mask;
@@ -1548,7 +1548,7 @@ retry:
 				ret = -EINVAL;
 				goto out_unlock;
 			} else {
-				pr_warning("cgroup: new mount options do not match the existing superblock, will be ignored\n");
+				pr_warn("cgroup: new mount options do not match the existing superblock, will be ignored\n");
 			}
 		}
 
@@ -1737,7 +1737,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 
 /**
  * cgroup_task_migrate - move a task from one cgroup to another.
- * @old_cgrp; the cgroup @tsk is being migrated from
+ * @old_cgrp: the cgroup @tsk is being migrated from
  * @tsk: the task being migrated
  * @new_cset: the new css_set @tsk is being attached to
  *
@@ -3666,10 +3666,10 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 	    parent->parent) {
-		pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
+		pr_warn("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
 			   current->comm, current->pid, ss->name);
 		if (!strcmp(ss->name, "memory"))
-			pr_warning("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
+			pr_warn("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
 		ss->warned_broken_hierarchy = true;
 	}
 
@@ -4053,7 +4053,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 /**
  * cgroup_destroy_css_killed - the second step of cgroup destruction
- * @work: cgroup->destroy_free_work
+ * @cgrp: cgroup->destroy_free_work
  *
  * This function is invoked from a work item for a cgroup which is being
  * destroyed after all css's are offlined and performs the rest of
-- 
1.9.1
