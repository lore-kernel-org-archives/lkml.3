Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaAPNdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:33:17 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50786 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaAPNdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:33:14 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH] mm/nobootmem: Fix unused variable
Date: Thu, 16 Jan 2014 14:33:06 +0100
Message-Id: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011613-2966-0000-0000-000009F53054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an unused variable warning in nobootmem.c

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 mm/nobootmem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index e2906a5..12cbb04 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -116,9 +116,13 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
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
 
-- 
1.8.4.5

