Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab3D3JSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:18:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759933Ab3D3JSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:18:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,580,1363104000"; 
   d="scan'208";a="7159153"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 08/13] x86, numa: Move memory_add_physaddr_to_nid() to CONFIG_NUMA.
Date: Tue, 30 Apr 2013 17:21:18 +0800
Message-Id: <1367313683-10267-9-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 17:16:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 17:16:52,
	Serialize complete at 2013/04/30 17:16:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_add_physaddr_to_nid() is declared in include/linux/memory_hotplug.h,
protected by CONFIG_NUMA. And in x86, the definitions are protected by
CONFIG_MEMORY_HOTPLUG.

memory_add_physaddr_to_nid() uses numa_meminfo to find the physical address's
nid. It has nothing to do with memory hotplug. And also, it can be used by
alloc_low_pages() to obtain nid of the allocated memory.

So in x86, also use CONFIG_NUMA to protect it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 105b092..1367fe4 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -959,7 +959,7 @@ EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
+#ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 start)
 {
 	struct numa_meminfo *mi = &numa_meminfo;
-- 
1.7.1

