Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3LIVyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:54:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47313 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761754Ab3LIVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:52:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v3 19/23] mm/memory_hotplug: Use memblock apis for early memory allocations
Date: Mon, 9 Dec 2013 16:50:52 -0500
Message-ID: <1386625856-12942-20-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct ensure_zone_is_initialized() function description according
to the introduced memblock APIs for early memory allocations.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index cf1736d..4f158ec 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -268,7 +268,7 @@ static void fix_zone_id(struct zone *zone, unsigned long start_pfn,
 }
 
 /* Can fail with -ENOMEM from allocating a wait table with vmalloc() or
- * alloc_bootmem_node_nopanic() */
+ * alloc_bootmem_node_nopanic()/memblock_virt_alloc_node_nopanic() */
 static int __ref ensure_zone_is_initialized(struct zone *zone,
 			unsigned long start_pfn, unsigned long num_pages)
 {
-- 
1.7.9.5

