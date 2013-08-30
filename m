Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3H3Dms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:42:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21074 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H3Dmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:42:46 -0400
Message-ID: <522014A7.3040002@huawei.com>
Date: Fri, 30 Aug 2013 11:42:31 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <tony.luck@intel.com>, <laijs@cn.fujitsu.com>
CC: <fenghua.yu@intel.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
Subject: [PATCH 4/5] mm/ia64: use N_MEMORY instead of N_HIGH_MEMORY
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
 arch/ia64/kernel/uncached.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index a96bcf8..d2e5545 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -196,7 +196,7 @@ unsigned long uncached_alloc_page(int starting_nid, int n_pages)
 	nid = starting_nid;
 
 	do {
-		if (!node_state(nid, N_HIGH_MEMORY))
+		if (!node_state(nid, N_MEMORY))
 			continue;
 		uc_pool = &uncached_pools[nid];
 		if (uc_pool->pool == NULL)
-- 
1.7.1


