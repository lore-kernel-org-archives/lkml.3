Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaBRXem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:34:42 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48725 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBRXek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:34:40 -0500
Date: Tue, 18 Feb 2014 18:34:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.15] workqueue: Remove deprecated
 __cancel_delayed_work()
Message-ID: <20140218233436.GO31892@mtj.dyndns.org>
References: <1392441591-38152-1-git-send-email-tanxiaojun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392441591-38152-1-git-send-email-tanxiaojun@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tan.

The description didn't seem to give enough details so I applied with
updated description.

Thanks a lot!
------ 8< ------
>From 90d88bd75424dff51e2072fd2f8fa85ee893aa17 Mon Sep 17 00:00:00 2001
From: Tan Xiaojun <tanxiaojun@huawei.com>
Date: Sat, 15 Feb 2014 13:19:51 +0800

__cancel_delayed_work() was deprecated by 136b5721d75a ("workqueue:
deprecate __cancel_delayed_work()") as cancel_delayed_work() was
updated so that it could be used from all contexts.  Enough time has
passed since the deprecation.  Let's remove it.

tj: description update

Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
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
1.8.5.3

