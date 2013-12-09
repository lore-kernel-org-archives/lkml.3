Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab3LIDc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:32:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:19701 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458Ab3LIDc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:32:27 -0500
From: Libin <huawei.libin@huawei.com>
To: Tejun Heo <tj@kernel.org>
CC: <guohanjun@huawei.com>, <wangyijing@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: Remove redundant call for pwq_adjust_max_active
Date: Mon, 9 Dec 2013 11:30:47 +0800
Message-ID: <1386559847-33012-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

In __alloc_workqueue_key(), alloc_and_link_pwqs() already called
pwq_adjust_max_active() to update the pwq's max_active, but after
that there is a redundant call for pwq_adjust_max_active. It is
meanless, remove it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c66912be..31cbe1d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4247,11 +4247,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	 */
 	mutex_lock(&wq_pool_mutex);
 
-	mutex_lock(&wq->mutex);
-	for_each_pwq(pwq, wq)
-		pwq_adjust_max_active(pwq);
-	mutex_unlock(&wq->mutex);
-
 	list_add(&wq->list, &workqueues);
 
 	mutex_unlock(&wq_pool_mutex);
-- 
1.8.2.2


