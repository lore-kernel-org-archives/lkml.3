Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbbAFQ50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:57:26 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48324 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbbAFQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:57:24 -0500
Date: Tue, 6 Jan 2015 11:57:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 cgroup/for-3.20] cgroup: reorder SUBSYS(blkio) in
 cgroup_subsys.h
Message-ID: <20150106165720.GI3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduled cgroup writeback support requires blkio to be
initialized before memcg as memcg needs to provide certain blkcg
related functionalities.  Relocate blkio so that it's right above
memory.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

These are two trivial patches to prepare for the cgroup writeback
support.  Applying to cgroup/for-3.20.

Thanks.

 include/linux/cgroup_subsys.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -15,6 +15,10 @@ SUBSYS(cpu)
 SUBSYS(cpuacct)
 #endif
 
+#if IS_ENABLED(CONFIG_BLK_CGROUP)
+SUBSYS(blkio)
+#endif
+
 #if IS_ENABLED(CONFIG_MEMCG)
 SUBSYS(memory)
 #endif
@@ -31,10 +35,6 @@ SUBSYS(freezer)
 SUBSYS(net_cls)
 #endif
 
-#if IS_ENABLED(CONFIG_BLK_CGROUP)
-SUBSYS(blkio)
-#endif
-
 #if IS_ENABLED(CONFIG_CGROUP_PERF)
 SUBSYS(perf_event)
 #endif
