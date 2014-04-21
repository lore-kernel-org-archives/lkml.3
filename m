Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaDUHrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 03:47:05 -0400
Received: from relay.parallels.com ([195.214.232.42]:56230 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaDUHrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 03:47:03 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH] Documentation/memcg: warn about incomplete kmemcg state
Date: Mon, 21 Apr 2014 11:47:00 +0400
Message-ID: <1398066420-30707-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemcg is currently under development and lacks some important features.
In particular, it does not have support of kmem reclaim on memory
pressure inside cgroup, which practically makes it unusable in real
life. Let's warn about it in both Kconfig and Documentation to prevent
complaints arising.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 Documentation/cgroups/memory.txt |    5 +++++
 init/Kconfig                     |    6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 2622115276aa..af3cdfa3c07a 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -270,6 +270,11 @@ When oom event notifier is registered, event will be delivered.
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
+WARNING: Current implementation lacks reclaim support. That means allocation
+	 attempts will fail when close to the limit even if there are plenty of
+	 kmem available for reclaim. That makes this option unusable in real
+	 life so DO NOT SELECT IT unless for development purposes.
+
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
 different than user memory, since it can't be swapped out, which makes it
diff --git a/init/Kconfig b/init/Kconfig
index 427ba60d638f..4d6e645c8ad4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -993,6 +993,12 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+	  WARNING: Current implementation lacks reclaim support. That means
+	  allocation attempts will fail when close to the limit even if there
+	  are plenty of kmem available for reclaim. That makes this option
+	  unusable in real life so DO NOT SELECT IT unless for development
+	  purposes.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
-- 
1.7.10.4

