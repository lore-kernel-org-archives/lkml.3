Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab3FMN2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:28:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab3FMN2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537718"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part2 PATCH v4 10/15] x86, numa: Move memory_add_physaddr_to_nid() to CONFIG_NUMA.
Date: Thu, 13 Jun 2013 21:03:34 +0800
Message-Id: <1371128619-8987-11-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:59:03,
	Serialize complete at 2013/06/13 20:59:03
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
index 1242190..2b5057f 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -1009,7 +1009,7 @@ EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
+#ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 start)
 {
 	struct numa_meminfo *mi = &numa_meminfo;
-- 
1.7.1

