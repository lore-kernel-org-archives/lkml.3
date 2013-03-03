Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3CCMUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3CCMUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:20:24 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile [v2]
Date: Sun,  3 Mar 2013 07:20:14 -0500
Message-Id: <1362313214-24110-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I explicitly disable the clocksource watchdog in the x86 Kconfig,
the x86 kernel will not compile unless this is properly defined.

v2: Oops ... move this to clocksource.h where it belongs

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 include/linux/clocksource.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 27cfda4..8292fe6 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -285,7 +285,12 @@ extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 extern void clocksource_mark_unstable(struct clocksource *cs);
+#else
+static inline void clocksource_mark_unstable(struct clocksource *cs) { }
+#endif
+
 
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
-- 
1.7.9.3

