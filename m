Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3FEHXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:23:00 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48729 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3FEHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:22:59 -0400
Message-ID: <51AEE48C.7010400@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:11:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] workqueue: remove the unused helper in .h
References: <51AEE452.8080605@linux.vnet.ibm.com>
In-Reply-To: <51AEE452.8080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060507-1396-0000-0000-00000311A4C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cancel_delayed_work(), flush_work_sync() and flush_delayed_work_sync()
are no longer used by anyone, just remove them.

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/workqueue.h |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..93a6f5e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -564,33 +564,6 @@ static inline bool keventd_up(void)
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
-/* used to be different but now identical to flush_work(), deprecated */
-static inline bool __deprecated flush_work_sync(struct work_struct *work)
-{
-	return flush_work(work);
-}
-
-/* used to be different but now identical to flush_delayed_work(), deprecated */
-static inline bool __deprecated flush_delayed_work_sync(struct delayed_work *dwork)
-{
-	return flush_delayed_work(dwork);
-}
-
 #ifndef CONFIG_SMP
 static inline long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
-- 
1.7.4.1

