Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3DLBQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:16:03 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42244 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3DLBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:45 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 20/25] x86/mm/numa: when dnuma is enabled, use memlayout to handle memory hotplug's physaddr_to_nid.
Date: Thu, 11 Apr 2013 18:13:52 -0700
Message-Id: <1365729237-29711-21-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-7282-0000-0000-0000160E5151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a memlayout is tracked (ie: CONFIG_DYNAMIC_NUMA is enabled), rather
than iterate over numa_meminfo, a lookup can be done using memlayout.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/x86/mm/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 75819ef..f1609c0 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -28,7 +28,7 @@ struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
 static struct numa_meminfo numa_meminfo
-#ifndef CONFIG_MEMORY_HOTPLUG
+#if !defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DYNAMIC_NUMA)
 __initdata
 #endif
 ;
@@ -832,7 +832,7 @@ EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
+#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_DYNAMIC_NUMA)
 int memory_add_physaddr_to_nid(u64 start)
 {
 	struct numa_meminfo *mi = &numa_meminfo;
-- 
1.8.2.1

