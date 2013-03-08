Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3CHLiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:38:01 -0500
Received: from multi.imgtec.com ([194.200.65.239]:47758 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3CHLiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:38:00 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/1] irq_work.h: fix warning when CONFIG_IRQ_WORK=n
Date: Fri, 8 Mar 2013 11:36:22 +0000
Message-ID: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_08_11_37_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A randconfig caught repeated compiler warnings when CONFIG_IRQ_WORK=n
due to the definition of a non-inline static function in
<linux/irq_work.h>:

include/linux/irq_work.h +40 : warning: 'irq_work_needs_cpu' defined but not used

Make it inline to supress the warning. This is caused by the following
commit:

Commit 00b42959106a9ca1c2899e591ae4e9a83ad6af05 ("irq_work: Don't stop
the tick with pending works") merged in v3.9-rc1.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/irq_work.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index f5dbce5..6601702 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -37,7 +37,7 @@ void irq_work_sync(struct irq_work *work);
 #ifdef CONFIG_IRQ_WORK
 bool irq_work_needs_cpu(void);
 #else
-static bool irq_work_needs_cpu(void) { return false; }
+static inline bool irq_work_needs_cpu(void) { return false; }
 #endif
 
 #endif /* _LINUX_IRQ_WORK_H */
-- 
1.8.1.2


