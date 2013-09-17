Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3IQBJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:09:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:27707 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3IQBJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:09:47 -0400
Message-ID: <5237AB84.9000404@huawei.com>
Date: Tue, 17 Sep 2013 09:08:20 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [RESEND PATCH] mm/mempolicy: use NUMA_NO_NODE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more appropriate NUMA_NO_NODE instead of -1

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4baf12e..4f0cd20 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1083,7 +1083,7 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 	tmp = *from;
 	while (!nodes_empty(tmp)) {
 		int s,d;
-		int source = -1;
+		int source = NUMA_NO_NODE;
 		int dest = 0;
 
 		for_each_node_mask(s, tmp) {
@@ -1118,7 +1118,7 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 			if (!node_isset(dest, tmp))
 				break;
 		}
-		if (source == -1)
+		if (source == NUMA_NO_NODE)
 			break;
 
 		node_clear(source, tmp);
@@ -1765,7 +1765,7 @@ static unsigned offset_il_node(struct mempolicy *pol,
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
 	int c;
-	int nid = -1;
+	int nid = NUMA_NO_NODE;
 
 	if (!nnodes)
 		return numa_node_id();
@@ -1802,11 +1802,11 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
 
 /*
  * Return the bit number of a random bit set in the nodemask.
- * (returns -1 if nodemask is empty)
+ * (returns NUMA_NO_NODE if nodemask is empty)
  */
 int node_random(const nodemask_t *maskp)
 {
-	int w, bit = -1;
+	int w, bit = NUMA_NO_NODE;
 
 	w = nodes_weight(*maskp);
 	if (w)
-- 
1.7.1


