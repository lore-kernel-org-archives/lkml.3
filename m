Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaDQP32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:29:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34943 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaDQP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:29:11 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH 2/3] cgroup: remove orphaned cgroup_pidlist_seq_operations
Date: Thu, 17 Apr 2014 23:29:04 +0800
Message-Id: <1397748544-6570-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6612f05b88fa309c9(cgroup: unify pidlist and other file handling)
has removed the only user of cgroup_pidlist_seq_operations :
cgroup_pidlist_open().

This patch removes it.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/cgroup.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b261798..38a9cd0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3883,17 +3883,6 @@ static int cgroup_pidlist_show(struct seq_file *s, void *v)
 	return seq_printf(s, "%d\n", *(int *)v);
 }
 
-/*
- * seq_operations functions for iterating on pidlists through seq_file -
- * independent of whether it's tasks or procs
- */
-static const struct seq_operations cgroup_pidlist_seq_operations = {
-	.start = cgroup_pidlist_start,
-	.stop = cgroup_pidlist_stop,
-	.next = cgroup_pidlist_next,
-	.show = cgroup_pidlist_show,
-};
-
 static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
 					 struct cftype *cft)
 {
-- 
1.9.0.GIT

