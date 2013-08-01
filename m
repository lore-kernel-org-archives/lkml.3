Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3HAAgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:36:43 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40049 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3HAAcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:32:11 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 16/23] m68k: hardirq_count() only need preempt_mask.h
Date: Thu,  1 Aug 2013 02:31:33 +0200
Message-Id: <1375317100-20651-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k irqflags implementation needs to check hardirq
context in some cases.

As it is a very low level header file, it's better to
include preempt_mask.h rather than hardirq.h when the
only purpose is to use irq context APIs. This way we
can avoid future header circular dependencies when
vtime.h will expand to use static keys.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/irqflags.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/irqflags.h b/arch/m68k/include/asm/irqflags.h
index 7ef4115..4c62755 100644
--- a/arch/m68k/include/asm/irqflags.h
+++ b/arch/m68k/include/asm/irqflags.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 #ifdef CONFIG_MMU
-#include <linux/hardirq.h>
+#include <linux/preempt_mask.h>
 #endif
 #include <linux/preempt.h>
 #include <asm/thread_info.h>
-- 
1.7.5.4

