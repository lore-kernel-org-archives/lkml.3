Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3IRAaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:30:18 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56251 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3IRAaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:30:15 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 2/2] mm/vmalloc: drop "caller" argument of __vmalloc_area_node() 
Date: Wed, 18 Sep 2013 08:30:02 +0800
Message-Id: <1379464202-21104-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379464202-21104-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1379464202-21104-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091800-2000-0000-0000-00000DC43894
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc_area_node() no longer need "caller" argument. It can use area->caller 
instead. This patch drop "caller" argument of __vmalloc_area_node().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d78d117..f75c2aa 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1546,7 +1546,7 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				 pgprot_t prot, int node, const void *caller)
+				 pgprot_t prot, int node)
 {
 	const int order = 0;
 	struct page **pages;
@@ -1560,7 +1560,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
-				PAGE_KERNEL, node, caller);
+				PAGE_KERNEL, node, area->caller);
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
@@ -1633,7 +1633,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (!area)
 		goto fail;
 
-	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node);
 	if (!addr)
 		goto fail;
 
-- 
1.8.1.2

