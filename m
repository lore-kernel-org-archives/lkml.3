Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959Ab3DQHQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:16:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:29856 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:16:36 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH] mm: fix build warning about kernel_physical_mapping_remove()
Date: Wed, 17 Apr 2013 15:15:58 +0800
Message-ID: <1366182958-21892-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MEMORY_HOTREMOVE is not set, a build warning about
"warning: ‘kernel_physical_mapping_remove’ defined but not used"
report.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..dafdeb2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1019,6 +1019,7 @@ void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
 	remove_pagetable(start, end, false);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1028,7 +1029,6 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true);
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
-- 
1.7.1


