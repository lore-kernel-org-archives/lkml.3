Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaGUD5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:57:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25255 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaGUD46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:56:58 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "Mel Gorman" <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: <peifeiyue@huawei.com>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <linux-ia64@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>
Subject: [PATCH v2 4/7] memory-hotplug: ia64: suitable memory should go to ZONE_MOVABLE
Date: Mon, 21 Jul 2014 11:46:39 +0800
Message-ID: <1405914402-66212-5-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1405914402-66212-1-git-send-email-wangnan0@huawei.com>
References: <1405914402-66212-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces zone_for_memory() to arch_add_memory() on ia64 to
ensure new, higher memory added into ZONE_MOVABLE if movable zone has
already setup.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
---
 arch/ia64/mm/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 25c3502..892d43e 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -631,7 +631,8 @@ int arch_add_memory(int nid, u64 start, u64 size)
 
 	pgdat = NODE_DATA(nid);
 
-	zone = pgdat->node_zones + ZONE_NORMAL;
+	zone = pgdat->node_zones +
+		zone_for_memory(nid, start, size, ZONE_NORMAL);
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 
 	if (ret)
-- 
1.8.4

