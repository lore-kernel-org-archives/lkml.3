Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3DOGZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:25:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13828 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3DOGZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:25:16 -0400
Message-ID: <516B9D41.8080508@huawei.com>
Date: Mon, 15 Apr 2013 14:25:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: remove cgrp->top_cgroup
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used, and it can be retrieved via cgrp->root->top_cgroup.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9c300ad..64047ae 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -204,7 +204,6 @@ struct cgroup {
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
 	struct cgroupfs_root *root;
-	struct cgroup *top_cgroup;
 
 	/*
 	 * List of cg_cgroup_links pointing at css_sets with
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6780459..c16719e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1418,7 +1418,6 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->name = &root_cgroup_name;
-	cgrp->top_cgroup = cgrp;
 	init_cgroup_housekeeping(cgrp);
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 }
@@ -4145,7 +4144,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
-	cgrp->top_cgroup = parent->top_cgroup;
 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-- 
1.8.0.2
