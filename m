Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JLWE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:04:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49551 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab3JLWAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:00:01 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 12/23] mm/power: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:58:55 -0400
Message-ID: <1381615146-20342-13-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 358a146..26cbb4c 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -637,7 +637,7 @@ __register_nosave_region(unsigned long start_pfn, unsigned long end_pfn,
 		BUG_ON(!region);
 	} else
 		/* This allocation cannot fail */
-		region = alloc_bootmem(sizeof(struct nosave_region));
+		region = memblock_early_alloc(sizeof(struct nosave_region));
 	region->start_pfn = start_pfn;
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
-- 
1.7.9.5

