Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602Ab3IDNax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:30:53 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65500 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3IDNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:30:51 -0400
From: Jianguo Wu <wujianguo106@gmail.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        xiaoguangrong@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH] mm/thp: fix comments in transparent_hugepage_flags
Date: Wed,  4 Sep 2013 21:30:22 +0800
Message-Id: <1378301422-9468-1-git-send-email-wujianguo@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d39d33c332(thp: enable direct defrag), defrag is enable
for all transparent hugepage page faults by default, not only in
MADV_HUGEPAGE regions.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/huge_memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a92012a..abf047e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -28,10 +28,8 @@
 
 /*
  * By default transparent hugepage support is enabled for all mappings
- * and khugepaged scans all mappings. Defrag is only invoked by
- * khugepaged hugepage allocations and by page faults inside
- * MADV_HUGEPAGE regions to avoid the risk of slowing down short lived
- * allocations.
+ * and khugepaged scans all mappings. Defrag is invoked by khugepaged
+ * hugepage allocations and by page faults for all hugepage allocations.
  */
 unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
-- 
1.8.1.2

