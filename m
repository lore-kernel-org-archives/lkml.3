Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab3ICGQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:16:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47648 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3ICGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:16:31 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 1/3] mm/vmalloc: don't set area->caller twice
Date: Tue,  3 Sep 2013 14:16:11 +0800
Message-Id: <1378188973-22351-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090306-5140-0000-0000-000003C4D2FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v1 -> v2: rebase against mmotm tree

The caller address has already been set in set_vmalloc_vm(), there's no need
to set it again in __vmalloc_area_node.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1074543..d78d117 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1566,7 +1566,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
-	area->caller = caller;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
-- 
1.8.1.2

