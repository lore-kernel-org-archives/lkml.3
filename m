Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3CLCnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:43:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19063 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3CLCnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:43:14 -0400
Message-ID: <513E9626.9080206@huawei.com>
Date: Tue, 12 Mar 2013 10:42:46 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Liujiang <jiang.liu@huawei.com>, qiuxishi <qiuxishi@huawei.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: mm/hotplug: fix build warning when CONFIG_MEMORY_HOTREMOVE=n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a warning while building kernel with
CONFIG_MEMORY_HOTPLUG=y && CONFIG_MEMORY_HOTREMOVE=n:
arch/x86/mm/init_64.c:1024: warning:kernel_physical_mapping_remove defined but not used

So move kernel_physical_mapping_remove() into "#ifdef CONFIG_MEMORY_HOTREMOVE" block

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
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
1.7.6.1

