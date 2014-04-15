Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaDOMsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:48:12 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48267 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaDOMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:48:07 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] cgroup: print pretty format in /proc/cgroups
Date: Tue, 15 Apr 2014 20:47:45 +0800
Message-Id: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that /proc/cgroups printed format has ugly alignment(see below).

This patch confines every field in fixed-width(16 actually) range.
Though MAX_CGROUP_TYPE_NAMELEN is 32, but currently no subsystem
has name width more than 10, so 16 is a moderate width; besides, 16
figures could accomandate enormous huge number, so no need to worry
that these fields would clobber each other.

Before:
  #subsys_name     hierarchy       num_cgroups     enabled
  cpuset	2	1	1
  cpu	3	1	1
  cpuacct	3	1	1
  memory	4	1	1
  devices	5	1	1
  freezer 6	1	1
  net_cls	7	1	1
  blkio	8	1	1
  perf_event	9	1	1
  hugetlb	10	1	1

Patch applied:
  #subsys_name     hierarchy       num_cgroups     enabled
  cpuset          2               1               1
  cpu             3               1               1
  cpuacct         3               1               1
  memory          4               1               1
  devices         5               1               1
  freezer         6               1               1
  net_cls         7               1               1
  blkio           8               1               1
  perf_event      9               1               1
  hugetlb         10              1               1

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..d981697 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4347,7 +4347,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	mutex_lock(&cgroup_mutex);
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%-16s%-16d%-16d%-16d\n",
 			   ss->name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
 
-- 
1.9.0.GIT

