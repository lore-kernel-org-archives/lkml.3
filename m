Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3INTso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47133 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410Ab3INTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5/7] clocksource: add latch to clocksource
Date: Sat, 14 Sep 2013 12:47:59 -0700
Message-Id: <1379188081-15613-6-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add latch for data used by clock read operations. This is in preparation
for the clock latch synchronization scheme. "cycle_last" rely on
timekeeper seqlock synchronization, and will therefore need to be
latched.

Add:
- cycle_last_latch (array of 2 elements),
- read_latch(),
- update_latch().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/clocksource.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index dbbf8aa..ef9c2e5 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -180,6 +180,10 @@ struct clocksource {
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
+	cycle_t (*read_latch)(struct clocksource *cs, int index);
+	void (*update_latch)(struct clocksource *cs, int oldindex,
+			int newindex);
+	cycle_t cycle_last_latch[2];
 
 	const char *name;
 	struct list_head list;
-- 
1.7.10.4

