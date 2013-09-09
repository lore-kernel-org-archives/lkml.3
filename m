Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3IIFOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:14:15 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:25923 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3IIFOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:14:14 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>, <huawei.libin@huawei.com>
Subject: [PATCH] workqueue: fix comment typo for __queue_work()
Date: Mon, 9 Sep 2013 13:13:58 +0800
Message-ID: <1378703638-7176-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

It seems the "dying" should be "draining" here.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..e390f3a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1320,7 +1320,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 
 	debug_work_activate(work);
 
-	/* if dying, only works from the same workqueue are allowed */
+	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
-- 
1.8.2.1


