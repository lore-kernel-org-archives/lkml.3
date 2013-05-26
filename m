Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3EZF70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 01:59:26 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60472 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3EZF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 01:58:55 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 2/6] mm/memory_hotplug: remove memory_add_physaddr_to_nid
Date: Sun, 26 May 2013 13:58:37 +0800
Message-Id: <1369547921-24264-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052605-5564-0000-0000-000008148984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_add_physaddr_to_nid is not used any more, this patch remove it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 arch/x86/mm/numa.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a71c4e2..d470a54 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -803,18 +803,3 @@ const struct cpumask *cpumask_of_node(int node)
 EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-int memory_add_physaddr_to_nid(u64 start)
-{
-	struct numa_meminfo *mi = &numa_meminfo;
-	int nid = mi->blk[0].nid;
-	int i;
-
-	for (i = 0; i < mi->nr_blks; i++)
-		if (mi->blk[i].start <= start && mi->blk[i].end > start)
-			nid = mi->blk[i].nid;
-	return nid;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-- 
1.8.1.2

