Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbbAWAJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:34 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46694 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbbAWAJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:32 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/12][RFC] Increased clocksource validation and cleanups (v2)
Date: Thu, 22 Jan 2015 16:09:15 -0800
Message-Id: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So here's another round for this series, which is the result of
earlier discussions with Linus and his suggestions around
improvements to clocksource validation in the hope we can more
easily catch bad hardware.

There's also a few cleanups Linus suggested as well as a few I've been
meaning to get to for awhile.

I tried in address all the feedback that had been given, adding
the checks behind CONFIG_DEBUG_TIMEKEEPING.  I also sorted out a
sane way to print rate-limited warnings if we see cycle deltas that
are too large, or if they look like small underflows.

Let me know what you think. I'm still a bit hesitant to queue
any of this for 3.20 (particularly the last few cleanups), but
if there aren't many more objections I might see if it can
still make it.

thanks
-john

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>

John Stultz (12):
  clocksource: Simplify clocks_calc_max_nsecs logic
  clocksource: Simplify logic around clocksource wrapping saftey margins
  clocksource: Remove clocksource_max_deferment()
  clocksource: Add max_cycles to clocksource structure
  time: Add debugging checks to warn if we see delays
  time: Add infrastructure to cap clocksource reads to the max_cycles
    value
  time: Try to catch clocksource delta underflows
  time: Add warnings when overflows or underflows are observed
  clocksource: Improve clocksource watchdog reporting
  clocksource: Mostly kill clocksource_register()
  sparc: Convert to using clocksource_register_hz()
  clocksource: Add some debug info about clocksources being registered

 arch/s390/kernel/time.c     |   2 +-
 arch/sparc/kernel/time_32.c |   6 +-
 include/linux/clocksource.h |  16 ++++-
 kernel/time/clocksource.c   | 164 +++++++++++++++++++-------------------------
 kernel/time/jiffies.c       |   5 +-
 kernel/time/sched_clock.c   |   6 +-
 kernel/time/timekeeping.c   | 113 ++++++++++++++++++++++++++----
 lib/Kconfig.debug           |  12 ++++
 8 files changed, 205 insertions(+), 119 deletions(-)

-- 
1.9.1

