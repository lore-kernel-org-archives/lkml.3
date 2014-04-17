Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaDQP3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:29:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49151 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaDQP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:29:22 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH 1/3] cgroup: clean up obsolete comment for parse_cgroupfs_options()
Date: Thu, 17 Apr 2014 23:29:15 +0800
Message-Id: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1d5be6b287c8efc87(cgroup: move module ref handling into
rebind_subsystems()) makes parse_cgroupfs_options() no longer
takes refcounts on subsystems.

And unified hierachy makes parse_cgroupfs_options not need to
call with cgroup_mutex held to protect the cgroup_subsys[].

So this patch cleanups these comment and BUG_ON().

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/cgroup.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2412cb7..b261798 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1222,10 +1222,7 @@ struct cgroup_sb_opts {
 };
 
 /*
- * Convert a hierarchy specifier into a bitmask of subsystems and
- * flags. Call with cgroup_mutex held to protect the cgroup_subsys[]
- * array. This function takes refcounts on subsystems to be used, unless it
- * returns error, in which case no refcounts are taken.
+ * Convert a hierarchy specifier into a bitmask of subsystems and flags.
  */
 static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
@@ -1235,8 +1232,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	struct cgroup_subsys *ss;
 	int i;
 
-	BUG_ON(!mutex_is_locked(&cgroup_mutex));
-
 #ifdef CONFIG_CPUSETS
 	mask = ~(1UL << cpuset_cgrp_id);
 #endif
-- 
1.9.0.GIT

