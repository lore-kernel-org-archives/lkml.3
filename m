Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3AXMgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:36:42 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:44436 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3AXMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:36:35 -0500
Subject: [PATCH] workqueue: un-GPL function delayed_work_timer_fn()
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Date: Thu, 24 Jan 2013 16:36:31 +0400
Message-ID: <20130124123630.11433.32503.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d8e794dfd51c368ed3f686b7f4172830b60ae47b ("workqueue: set
delayed_work->timer function on initialization") exports function
delayed_work_timer_fn() only for GPL modules. This makes delayed-works
unusable for non-GPL modules, because initialization macro now requires
GPL symbol. For example schedule_delayed_work() available for non-GPL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # 3.7
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fbc6576..033ad5b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1352,7 +1352,7 @@ void delayed_work_timer_fn(unsigned long __data)
 	/* should have been called from irqsafe timer with irq already off */
 	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
 }
-EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
+EXPORT_SYMBOL(delayed_work_timer_fn);
 
 static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 				struct delayed_work *dwork, unsigned long delay)

