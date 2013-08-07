Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3HGJKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:10:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53310 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3HGJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:10:49 -0400
Message-ID: <52020EF1.2060003@huawei.com>
Date: Wed, 7 Aug 2013 17:10:09 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Xishi Qiu <qiuxishi@huawei.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mm: use zone_is_initialized() instead of if(zone->wait_table)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "zone_is_initialized()" instead of "if (zone->wait_table)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f3fcac1..387654b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -194,7 +194,7 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 
 	zone = &pgdat->node_zones[0];
 	for (; zone < pgdat->node_zones + MAX_NR_ZONES - 1; zone++) {
-		if (zone->wait_table) {
+		if (zone_is_initialized(zone)) {
 			nr_pages = zone->wait_table_hash_nr_entries
 				* sizeof(wait_queue_head_t);
 			nr_pages = PAGE_ALIGN(nr_pages) >> PAGE_SHIFT;
-- 
1.7.1

