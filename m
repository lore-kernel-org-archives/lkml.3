Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3H3BWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:22:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:56322 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3H3BWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:22:21 -0400
Message-ID: <521FF39E.3040700@huawei.com>
Date: Fri, 30 Aug 2013 09:21:34 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/4] mm/vmalloc: use NUMA_NO_NODE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more appropriate "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 13a5495..f5483f8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1582,7 +1582,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		struct page *page;
 		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
-		if (node < 0)
+		if (node == NUMA_NO_NODE)
 			page = alloc_page(tmp_mask);
 		else
 			page = alloc_pages_node(node, tmp_mask, order);
-- 
1.7.1


