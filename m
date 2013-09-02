Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3IBMf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:35:59 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47701 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab3IBMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:35:57 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mm/vmalloc: don't set area->caller twice
Date: Mon,  2 Sep 2013 20:35:43 +0800
Message-Id: <1378125345-13228-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090212-8878-0000-0000-000008AB44C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller address has already been set in set_vmalloc_vm(), there's no need 
to set it again in __vmalloc_area_node.

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
-       area->caller = caller;
        if (!area->pages) {
                remove_vm_area(area->addr);
                kfree(area);
--
1.8.1.2


