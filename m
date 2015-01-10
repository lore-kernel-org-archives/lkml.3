Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbbAJAeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:34:36 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64156 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 00/10][RFC] Increased clocksource validation and cleanups
Date: Fri,  9 Jan 2015 16:34:18 -0800
Message-Id: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this series is the result of earlier discussions with Linus
and his suggestions around improvements to clocksource validation
in the hope we can more easily catch bad hardware.

There's also a few cleanups Linus suggested as well as a few I've been
meaning to get to for awhile.

I'm still feeling cautious about capping the clocksource reads to the
max_cycles values, and even more so with the underflow detection. So 
this isn't yet ready for merging, but I wanted to get some initial
review and feedback since its not blowing up in my initial testing.

So let me know what you think, and hopefully we can get this into
shape so it can get more testing and we can evaluate it for 3.20.

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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>

John Stultz (10):
  clocksource: Simplify clocks_calc_max_nsecs logic
  clocksource: Simplify logic around clocksource wrapping saftey margins
  clocksource: Remove clocksource_max_deferment()
  clocksource: Add max_cycles to clocksource structure
  time: Add debugging checks to warn if we see delays
  time: Cap clocksource reads to the clocksource max_cycles value
  time: Try to catch clocksource delta underflows
  clocksource: Mostly kill clocksource_register()
  sparc: Convert to using clocksource_register_hz()
  clocksource: Add some debug info about clocksources being registered

 arch/s390/kernel/time.c     |   2 +-
 arch/sparc/kernel/time_32.c |   6 +-
 include/linux/clocksource.h |  15 ++++-
 kernel/time/clocksource.c   | 143 ++++++++++++++++++--------------------------
 kernel/time/jiffies.c       |   5 +-
 kernel/time/sched_clock.c   |   6 +-
 kernel/time/timekeeping.c   |  34 +++++++++++
 7 files changed, 113 insertions(+), 98 deletions(-)

-- 
1.9.1

