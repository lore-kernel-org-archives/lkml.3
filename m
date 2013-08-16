Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3HPFeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:34:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62047 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3HPFeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:34:02 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <wangyijing@huawei.com>
Subject: [PATCH] workqueue: Fix manage_workers() RETURNS description
Date: Fri, 16 Aug 2013 13:33:35 +0800
Message-ID: <1376631215-10704-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
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
 kernel/workqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..e8ee7a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2033,8 +2033,8 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * RETURNS:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.
+ * %false if the poll don't need management and the caller can safely 
+ * start processing works, %true otherwise.
  */
 static bool manage_workers(struct worker *worker)
 {
-- 
1.8.2.1


