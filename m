Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3HFEH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:07:29 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35327 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3HFEH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:07:28 -0400
Message-ID: <52007660.7070907@huawei.com>
Date: Tue, 6 Aug 2013 12:06:56 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] mm/mempolicy: return NULL if node is NUMA_NO_NODE in get_task_policy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If node == NUMA_NO_NODE, pol is NULL, we should return NULL instead of
do "if (!pol->mode)" check.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4baf12e..e0e3398 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -129,6 +129,8 @@ static struct mempolicy *get_task_policy(struct task_struct *p)
 		node = numa_node_id();
 		if (node != NUMA_NO_NODE)
 			pol = &preferred_node_policy[node];
+		else
+			return NULL;
 
 		/* preferred_node_policy is not initialised early in boot */
 		if (!pol->mode)
-- 
1.8.2.2



