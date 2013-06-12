Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3FLQIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:08:38 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64773 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3FLQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:08:36 -0400
Date: Thu, 13 Jun 2013 00:08:17 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: yinghai@kernel.org, liwanp@linux.vnet.ibm.com, tangchen@cn.fujitsu.com,
        tj@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH]memblock: Fix potential section mismatch problem
Message-ID: <20130612160816.GA13813@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, yinghai@kernel.org,
	liwanp@linux.vnet.ibm.com, tangchen@cn.fujitsu.com, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch convert __init to __init_memblock
for functions which make reference to memblock variable
with attribute __meminitdata.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 mm/memblock.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c5fad93..ee74c69 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -766,7 +766,7 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
+static phys_addr_t __init_memblock memblock_alloc_base_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t max_addr,
 					int nid)
 {
@@ -785,17 +785,17 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 	return 0;
 }
 
-phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
+phys_addr_t __init_memblock memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
 	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 }
 
-phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+phys_addr_t __init_memblock __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
 	return memblock_alloc_base_nid(size, align, max_addr, MAX_NUMNODES);
 }
 
-phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+phys_addr_t __init_memblock memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
 	phys_addr_t alloc;
 
@@ -808,12 +808,12 @@ phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys
 	return alloc;
 }
 
-phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
+phys_addr_t __init_memblock memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
-phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
+phys_addr_t __init_memblock memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
 	phys_addr_t res = memblock_alloc_nid(size, align, nid);
 
@@ -827,12 +827,12 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
  * Remaining API functions
  */
 
-phys_addr_t __init memblock_phys_mem_size(void)
+phys_addr_t __init_memblock memblock_phys_mem_size(void)
 {
 	return memblock.memory.total_size;
 }
 
-phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
+phys_addr_t __init_memblock memblock_mem_size(unsigned long limit_pfn)
 {
 	unsigned long pages = 0;
 	struct memblock_region *r;
@@ -862,7 +862,7 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
 
-void __init memblock_enforce_memory_limit(phys_addr_t limit)
+void __init_memblock memblock_enforce_memory_limit(phys_addr_t limit)
 {
 	unsigned long i;
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
@@ -904,7 +904,7 @@ static int __init_memblock memblock_search(struct memblock_type *type, phys_addr
 	return -1;
 }
 
-int __init memblock_is_reserved(phys_addr_t addr)
+int __init_memblock memblock_is_reserved(phys_addr_t addr)
 {
 	return memblock_search(&memblock.reserved, addr) != -1;
 }
@@ -1016,12 +1016,12 @@ void __init_memblock __memblock_dump_all(void)
 	memblock_dump(&memblock.reserved, "reserved");
 }
 
-void __init memblock_allow_resize(void)
+void __init_memblock memblock_allow_resize(void)
 {
 	memblock_can_resize = 1;
 }
 
-static int __init early_memblock(char *p)
+static int __init_memblock early_memblock(char *p)
 {
 	if (p && strstr(p, "debug"))
 		memblock_debug = 1;
-- 
1.7.12.4.dirty
