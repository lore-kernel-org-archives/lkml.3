Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3GIXdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:33:45 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:43407 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3GIXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:33:43 -0400
Date: Tue, 9 Jul 2013 16:33:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: cgroups@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.11-fixes] cgroup: remove bcache_subsys_id which
 got added stealthily
Message-ID: <20130709233338.GB10374@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From add0c59d802e6118e51e21244c3871be35164e4b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 9 Jul 2013 16:17:39 -0700

cafe563591 ("bcache: A block layer cache") added a new cgroup
subsystem bcache_subsys without proper review and ack.  bcache_subsys
seems to use cgroup for group stats and per-group cache_mode
configuration.  This is very much the type of usage that we don't want
to allow.

Fortunately, CONFIG_CGROUP_BCACHE which enables bcache_subsys is
currently commented out, so this shouldn't have any upstream users.
Let's nip in the bud.  While at it, clarify in cgroup_subsys.h that no
new subsystem should be added without explicit acks from cgroup
maintainers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org
---
Applied to cgroup/for-3.11-fixes.  Please don't do things like this
ever again.

Thanks.

 include/linux/cgroup_subsys.h | 45 +++++++------------------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 6e7ec64..b613ffd 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -1,86 +1,55 @@
-/* Add subsystem definitions of the form SUBSYS(<name>) in this
- * file. Surround each one by a line of comment markers so that
- * patches don't collide
+/*
+ * List of cgroup subsystems.
+ *
+ * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
-
-/* */
-
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CPUSETS)
 SUBSYS(cpuset)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_DEBUG)
 SUBSYS(debug)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_SCHED)
 SUBSYS(cpu_cgroup)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_CPUACCT)
 SUBSYS(cpuacct)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_MEMCG)
 SUBSYS(mem_cgroup)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_DEVICE)
 SUBSYS(devices)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_FREEZER)
 SUBSYS(freezer)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_NET_CLS_CGROUP)
 SUBSYS(net_cls)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_BLK_CGROUP)
 SUBSYS(blkio)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_PERF)
 SUBSYS(perf)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_NETPRIO_CGROUP)
 SUBSYS(net_prio)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_HUGETLB)
 SUBSYS(hugetlb)
 #endif
-
-/* */
-
-#ifdef CONFIG_CGROUP_BCACHE
-SUBSYS(bcache)
-#endif
-
-/* */
+/*
+ * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
+ */
-- 
1.8.3.1

