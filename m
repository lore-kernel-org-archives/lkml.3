Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaBOFUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 00:20:03 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:4006 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaBOFUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 00:20:01 -0500
From: Tan Xiaojun <tanxiaojun@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: Remove unused __cancel_delayed_work
Date: Sat, 15 Feb 2014 13:19:51 +0800
Message-ID: <1392441591-38152-1-git-send-email-tanxiaojun@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.19.0]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use safer cancel_delayed_work() instead of __cancel_delayed_work,
and no one will use __cancel_delayed_work. So remove it.

Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
---
 include/linux/workqueue.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..edc9410 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -605,21 +605,6 @@ static inline bool keventd_up(void)
 	return system_wq != NULL;
 }
 
-/*
- * Like above, but uses del_timer() instead of del_timer_sync(). This means,
- * if it returns 0 the timer function may be running and the queueing is in
- * progress.
- */
-static inline bool __deprecated __cancel_delayed_work(struct delayed_work *work)
-{
-	bool ret;
-
-	ret = del_timer(&work->timer);
-	if (ret)
-		work_clear_pending(&work->work);
-	return ret;
-}
-
 /* used to be different but now identical to flush_work(), deprecated */
 static inline bool __deprecated flush_work_sync(struct work_struct *work)
 {
-- 
1.8.0


