Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab3FNDRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:17:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62906 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3FNDRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:17:31 -0400
Message-ID: <51BA8B3F.3060606@huawei.com>
Date: Fri, 14 Jun 2013 11:17:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH ] cgroup: rename cont to cgrp
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cont is short for container. control group was named process container
at first, but then people found container already has a meaning in
linux kernel.

Clean up the leftover variable name @cont.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

I'll clean up this for memcg later.

---
 include/linux/cgroup.h |  4 ++--
 kernel/cgroup.c        | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b7bd4be..9f6e26a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -436,13 +436,13 @@ struct cftype {
 	 * entry. The key/value pairs (and their ordering) should not
 	 * change between reboots.
 	 */
-	int (*read_map)(struct cgroup *cont, struct cftype *cft,
+	int (*read_map)(struct cgroup *cgrp, struct cftype *cft,
 			struct cgroup_map_cb *cb);
 	/*
 	 * read_seq_string() is used for outputting a simple sequence
 	 * using seqfile.
 	 */
-	int (*read_seq_string)(struct cgroup *cont, struct cftype *cft,
+	int (*read_seq_string)(struct cgroup *cgrp, struct cftype *cft,
 			       struct seq_file *m);
 
 	ssize_t (*write)(struct cgroup *cgrp, struct cftype *cft,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dd4ab91..25f1054 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5473,7 +5473,7 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 }
 
 #ifdef CONFIG_CGROUP_DEBUG
-static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cont)
+static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cgrp)
 {
 	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
 
@@ -5483,23 +5483,23 @@ static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cont)
 	return css;
 }
 
-static void debug_css_free(struct cgroup *cont)
+static void debug_css_free(struct cgroup *cgrp)
 {
-	kfree(cont->subsys[debug_subsys_id]);
+	kfree(cgrp->subsys[debug_subsys_id]);
 }
 
-static u64 debug_taskcount_read(struct cgroup *cont, struct cftype *cft)
+static u64 debug_taskcount_read(struct cgroup *cgrp, struct cftype *cft)
 {
-	return cgroup_task_count(cont);
+	return cgroup_task_count(cgrp);
 }
 
-static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
+static u64 current_css_set_read(struct cgroup *cgrp, struct cftype *cft)
 {
 	return (u64)(unsigned long)current->cgroups;
 }
 
-static u64 current_css_set_refcount_read(struct cgroup *cont,
-					   struct cftype *cft)
+static u64 current_css_set_refcount_read(struct cgroup *cgrp,
+					 struct cftype *cft)
 {
 	u64 count;
 
@@ -5509,7 +5509,7 @@ static u64 current_css_set_refcount_read(struct cgroup *cont,
 	return count;
 }
 
-static int current_css_set_cg_links_read(struct cgroup *cont,
+static int current_css_set_cg_links_read(struct cgroup *cgrp,
 					 struct cftype *cft,
 					 struct seq_file *seq)
 {
@@ -5536,14 +5536,14 @@ static int current_css_set_cg_links_read(struct cgroup *cont,
 }
 
 #define MAX_TASKS_SHOWN_PER_CSS 25
-static int cgroup_css_links_read(struct cgroup *cont,
+static int cgroup_css_links_read(struct cgroup *cgrp,
 				 struct cftype *cft,
 				 struct seq_file *seq)
 {
 	struct cgrp_cset_link *link;
 
 	read_lock(&css_set_lock);
-	list_for_each_entry(link, &cont->cset_links, cset_link) {
+	list_for_each_entry(link, &cgrp->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
 		int count = 0;
-- 
1.8.0.2
