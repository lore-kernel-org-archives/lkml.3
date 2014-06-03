Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaFCOle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:41:34 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49399 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaFCOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:40:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] irq_work: Shorten a bit irq_work_needs_cpu()
Date: Tue,  3 Jun 2014 16:40:17 +0200
Message-Id: <1401806420-31018-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small cleanup.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq_work.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 44ac87c..a4350d0 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -89,10 +89,7 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
 
 bool irq_work_needs_cpu(void)
 {
-	struct llist_head *list;
-
-	list = &__get_cpu_var(lazy_list);
-	if (llist_empty(list))
+	if (llist_empty(&__get_cpu_var(lazy_list)))
 		return false;
 
 	/* All work should have been flushed before going offline */
-- 
1.8.3.1

