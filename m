Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3HUAvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:51:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45018 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3HUAvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:51:23 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH v2 2/3] workqueue: Fix manage_workers() RETURNS description
Date: Wed, 21 Aug 2013 08:50:40 +0800
Message-ID: <1377046241-18516-3-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. The comment of function manage_workers()
RETURNS description is obvious wrong, same as the CONTEXT.
Fix it.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 26644ce..46a0de0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2034,8 +2034,11 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * RETURNS:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.
+ * %false if the pool don't need management and the caller can safely
+ * start processing works, %true indicates that the function released
+ * pool->lock and reacquired it to perform some management function
+ * and that the conditions that the caller verified while holding the
+ * lock before calling the function might no longer be true.
  */
 static bool manage_workers(struct worker *worker)
 {
-- 
1.8.2.1


