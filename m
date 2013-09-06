Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab3IFIza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:55:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31749 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3IFIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:55:27 -0400
Message-ID: <52299848.1000105@huawei.com>
Date: Fri, 6 Sep 2013 16:54:32 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm/hotplug: rename the function is_memblock_offlined_cb()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function is_memblock_offlined() return 1 means memory block is offlined,
but is_memblock_offlined_cb() return 1 means memory block is not offlined, 
this will confuse somebody, so rename the function.
Another, use "pfn_to_nid(pfn)" instead of "page_to_nid(pfn_to_page(pfn))".

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ca1dd3a..a95dd28 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -937,7 +937,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_online(nr_pages, zone, &arg);
 
-	nid = page_to_nid(pfn_to_page(pfn));
+	nid = pfn_to_nid(pfn);
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
@@ -1657,7 +1657,7 @@ int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int is_memblock_offlined_cb(struct memory_block *mem, void *arg)
+static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int ret = !is_memblock_offlined(mem);
 
@@ -1794,7 +1794,7 @@ void __ref remove_memory(int nid, u64 start, u64 size)
 	 * if this is not the case.
 	 */
 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
-				is_memblock_offlined_cb);
+				check_memblock_offlined_cb);
 	if (ret) {
 		unlock_memory_hotplug();
 		BUG();
-- 
1.7.1


