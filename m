Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaHYL3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:29:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:59734 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755041AbaHYL3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:29:02 -0400
X-IronPort-AV: E=Sophos;i="5.04,396,1406563200"; 
   d="scan'208";a="35035619"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <tj@kernel.org>, <lizefan@huawei.com>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] cgroup: fix a typo in comment.
Date: Mon, 25 Aug 2014 19:27:52 +0800
Message-ID: <1408966072-2142-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no function named cgroup_enable_task_cg_links().
Instead, the correct function name in this comment should
be cgroup_enabled_task_cg_lists().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..64bbb56 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5161,7 +5161,7 @@ void cgroup_post_fork(struct task_struct *child)
 	int i;
 
 	/*
-	 * This may race against cgroup_enable_task_cg_links().  As that
+	 * This may race against cgroup_enable_task_cg_lists().  As that
 	 * function sets use_task_css_set_links before grabbing
 	 * tasklist_lock and we just went through tasklist_lock to add
 	 * @child, it's guaranteed that either we see the set
@@ -5176,7 +5176,7 @@ void cgroup_post_fork(struct task_struct *child)
 	 * when implementing operations which need to migrate all tasks of
 	 * a cgroup to another.
 	 *
-	 * Note that if we lose to cgroup_enable_task_cg_links(), @child
+	 * Note that if we lose to cgroup_enable_task_cg_lists(), @child
 	 * will remain in init_css_set.  This is safe because all tasks are
 	 * in the init_css_set before cg_links is enabled and there's no
 	 * operation which transfers all tasks out of init_css_set.
-- 
1.8.4.2

