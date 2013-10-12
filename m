Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3JLWD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:03:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49560 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3JLWAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:00:07 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC 17/23] mm/page_cgroup: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:59:00 -0400
Message-ID: <1381615146-20342-18-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Switch to memblock interfaces for early memory allocator

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/page_cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6d757e3..7428f4c 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -54,8 +54,9 @@ static int __init alloc_node_page_cgroup(int nid)
 
 	table_size = sizeof(struct page_cgroup) * nr_pages;
 
-	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
-			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	base = memblock_early_alloc_try_nid_nopanic(nid,
+			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+			BOOTMEM_ALLOC_ACCESSIBLE);
 	if (!base)
 		return -ENOMEM;
 	NODE_DATA(nid)->node_page_cgroup = base;
-- 
1.7.9.5

