Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbbAJAf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:35:28 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45085 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbbAJAes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 10/10] clocksource: Add some debug info about clocksources being registered
Date: Fri,  9 Jan 2015 16:34:28 -0800
Message-Id: <1420850068-27828-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the mask, max_cycles, and max_idle_ns values for clocksources
being registered.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/clocksource.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9a0b951..c641aa7 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -770,6 +770,10 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
 						 cs->maxadj, cs->mask,
 						 &cs->max_cycles);
+
+	pr_info("clocksource %s: mask: 0x%llx max_cycles: 0x%llx, max_idle_ns: %lld ns\n",
+			cs->name, cs->mask, cs->max_cycles, cs->max_idle_ns);
+
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 
-- 
1.9.1

