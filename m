Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaAMEYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:24:01 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60978 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaAMEX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:23:58 -0500
Date: Sun, 12 Jan 2014 20:23:27 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm/next] cgroup: remove stray references to css_id
Message-ID: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial: remove the few stray references to css_id, which itself
was removed in v3.13's 2ff2a7d03bbe "cgroup: kill css_id".

Signed-off-by: Hugh Dickins <hughd@google.com>
---
But I don't know your plans with respect to the XXX in
kernel/cgroup.c, so perhaps you'd prefer to amend this.

 drivers/md/bcache/request.c |    1 -
 include/linux/cgroup.h      |    3 ---
 mm/page_cgroup.c            |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

--- mmotm/drivers/md/bcache/request.c	2014-01-10 18:24:58.212448858 -0800
+++ linux/drivers/md/bcache/request.c	2014-01-12 20:00:07.641685957 -0800
@@ -163,7 +163,6 @@ static struct cgroup_subsys_state *bcach
 static void bcachecg_destroy(struct cgroup *cgroup)
 {
 	struct bch_cgroup *cg = cgroup_to_bcache(cgroup);
-	free_css_id(&bcache_subsys, &cg->css);
 	kfree(cg);
 }
 
--- mmotm/include/linux/cgroup.h	2014-01-10 18:25:01.820448944 -0800
+++ linux/include/linux/cgroup.h	2014-01-12 20:00:07.645685957 -0800
@@ -29,7 +29,6 @@ struct cgroupfs_root;
 struct cgroup_subsys;
 struct inode;
 struct cgroup;
-struct css_id;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
@@ -79,8 +78,6 @@ struct cgroup_subsys_state {
 	struct cgroup_subsys_state *parent;
 
 	unsigned long flags;
-	/* ID for this css, if possible */
-	struct css_id __rcu *id;
 
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
--- mmotm/mm/page_cgroup.c	2014-01-10 18:25:02.256448954 -0800
+++ linux/mm/page_cgroup.c	2014-01-12 20:00:07.645685957 -0800
@@ -452,7 +452,7 @@ unsigned short swap_cgroup_record(swp_en
  * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
  * @ent: swap entry to be looked up.
  *
- * Returns CSS ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
+ * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
