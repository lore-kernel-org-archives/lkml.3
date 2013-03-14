Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3CNO0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:26:44 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39638 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3CNO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:26:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] irq_work.h: fix warning when CONFIG_IRQ_WORK=n
Date: Thu, 14 Mar 2013 15:26:28 +0100
Message-Id: <1363271189-6631-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
References: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

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
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4

