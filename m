Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3BVUJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab3BVUJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:09:09 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
Date: Fri, 22 Feb 2013 15:08:56 -0500
Message-Id: <1361563736-28241-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I explicitly disable the clocksource watchdog in the x86 Kconfig,
the x86 kernel will not compile unless this is properly defined.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 kernel/time/clocksource.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..e04821f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -450,6 +450,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+void clocksource_mark_unstable(struct clocksource *cs) { }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
-- 
1.7.9.3

