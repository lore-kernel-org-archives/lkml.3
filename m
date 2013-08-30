Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3H3Dgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:36:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:59263 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3H3Dgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:36:52 -0400
Message-ID: <5220133E.4030204@huawei.com>
Date: Fri, 30 Aug 2013 11:36:30 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <laijs@cn.fujitsu.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <zhangyanfei@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/5] mm/vmalloc: use N_MEMORY instead of N_HIGH_MEMORY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8219fc48a(mm: node_states: introduce N_MEMORY),
we introduced N_MEMORY, now N_MEMORY stands for the nodes that has any memory,
and N_HIGH_MEMORY stands for the nodes that has normal or high memory.

The code here need to handle with the nodes which have memory,
we should use N_MEMORY instead.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 13a5495..1152947 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2573,7 +2573,7 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 		for (nr = 0; nr < v->nr_pages; nr++)
 			counters[page_to_nid(v->pages[nr])]++;
 
-		for_each_node_state(nr, N_HIGH_MEMORY)
+		for_each_node_state(nr, N_MEMORY)
 			if (counters[nr])
 				seq_printf(m, " N%u=%u", nr, counters[nr]);
 	}
-- 
1.7.1


