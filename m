Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaGMSMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:12:47 -0400
Received: from mail.efficios.com ([78.47.125.74]:42855 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaGMSMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:12:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] timekeeping: export ktime_get_mono_fast_ns to GPL modules
Date: Sun, 13 Jul 2014 14:12:18 -0400
Message-Id: <1405275138-25213-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this export to allow tracers built as GPL modules to use
ktime_get_mono_fast_ns().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2bd73b0..ce0b751 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -400,6 +400,7 @@ u64 notrace ktime_get_mono_fast_ns(void)
 {
 	return ktime_get_fast_ns(&tk_fast_mono);
 }
+EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
 
-- 
1.7.10.4

