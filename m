Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477Ab3IEIIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:08:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21990 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3IEIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:08:37 -0400
Message-ID: <52283AF9.2080606@huawei.com>
Date: Thu, 5 Sep 2013 16:04:09 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@suse.de>,
        <xiaoguangrong@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2][RESEND] mm/thp: fix stale comments of transparent_hugepage_flags
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v1 -> v2: also update the stale comments about default transparent
hugepage support pointed by Wanpeng Li.

Since commit 13ece886d9(thp: transparent hugepage config choice),
transparent hugepage support is disabled by default, and
TRANSPARENT_HUGEPAGE_ALWAYS is configured when TRANSPARENT_HUGEPAGE=y.

And since commit d39d33c332(thp: enable direct defrag), defrag is
enable for all transparent hugepage page faults by default, not only in
MADV_HUGEPAGE regions.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/huge_memory.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a92012a..90ce6de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -27,11 +27,12 @@
 #include "internal.h"
 
 /*
- * By default transparent hugepage support is enabled for all mappings
- * and khugepaged scans all mappings. Defrag is only invoked by
- * khugepaged hugepage allocations and by page faults inside
- * MADV_HUGEPAGE regions to avoid the risk of slowing down short lived
- * allocations.
+ * By default transparent hugepage support is disabled in order that avoid
+ * to risk increase the memory footprint of applications without a guaranteed
+ * benefit. When transparent hugepage support is enabled, is for all mappings,
+ * and khugepaged scans all mappings.
+ * Defrag is invoked by khugepaged hugepage allocations and by page faults
+ * for all hugepage allocations.
  */
 unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
-- 
1.7.1


