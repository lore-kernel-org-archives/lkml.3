Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab3IIFKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:10:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63506 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3IIFKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:10:16 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH] workqueue: remove meaningless BUILD_BUG_ON() in init_workqueues()
Date: Mon, 9 Sep 2013 13:10:00 +0800
Message-ID: <1378703400-4536-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

In the current implementation, this BUILD_BUG_ON makes no sense.
First of all, the number of worker pools needed cannot be determined
at compile time, because the number of backing pools for UNBOUND
workqueues is dynamic based on the assigned custom attributes.
Secondly, it should use WORK_OFFQ_POOL_BITS instead of
(BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT).

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..41019b1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5009,10 +5009,6 @@ static int __init init_workqueues(void)
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
 	int i, cpu;
 
-	/* make sure we have enough bits for OFFQ pool ID */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_END * NR_STD_WORKER_POOLS);
-
 	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
-- 
1.8.2.1


