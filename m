Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaEYOaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 10:30:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63753 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaEYOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 10:30:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] irq_work: Shorten a bit irq_work_needs_cpu()
Date: Sun, 25 May 2014 16:29:48 +0200
Message-Id: <1401028191-29756-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
References: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
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
index 87551cb..dee5a1f 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -88,10 +88,7 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
 
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

