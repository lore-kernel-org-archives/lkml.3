Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3IID3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:29:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4982 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3IID2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:28:49 -0400
Message-ID: <522D4038.7010609@huawei.com>
Date: Mon, 9 Sep 2013 11:27:52 +0800
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
Subject: [PATCH 1/2] mm/hotplug: rename the function is_memblock_offlined_cb()
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

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/memory_hotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ca1dd3a..85f80b7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
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


