Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaATLdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:33:11 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42779 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:33:07 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, tangchen@cn.fujitsu.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH V5 1/3] mm/nobootmem: Fix unused variable
Date: Mon, 20 Jan 2014 12:32:37 +0100
Message-Id: <1390217559-14691-2-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012011-8372-0000-0000-000008610318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an unused variable warning in nobootmem.c

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 mm/nobootmem.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index e2906a5..0215c77 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -116,23 +116,29 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
-	phys_addr_t start, end, size;
+	phys_addr_t start, end;
 	u64 i;
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+	phys_addr_t size;
+#endif
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-
-	/* Free memblock.reserved array if it was allocated */
-	size = get_allocated_memblock_reserved_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
-
-	/* Free memblock.memory array if it was allocated */
-	size = get_allocated_memblock_memory_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
+	{
+		phys_addr_t size;
+		/* Free memblock.reserved array if it was allocated */
+		size = get_allocated_memblock_reserved_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+		
+		/* Free memblock.memory array if it was allocated */
+		size = get_allocated_memblock_memory_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+	}
 #endif
 
 	return count;
-- 
1.8.4.5

