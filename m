Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbbAWAKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:10:08 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54189 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbbAWAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 12/12] clocksource: Add some debug info about clocksources being registered
Date: Thu, 22 Jan 2015 16:09:27 -0800
Message-Id: <1421971767-17707-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
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
index b56f4b9..ec7b552 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -773,6 +773,10 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
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

