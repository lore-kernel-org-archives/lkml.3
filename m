Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab3ICON2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:13:28 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50939 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3ICON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:13:27 -0400
Date: Tue, 3 Sep 2013 16:13:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/nohz changes for v3.12
Message-ID: <20130903141322.GA27504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-nohz-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus

   HEAD: c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba nohz: Include local CPU in full dynticks global kick

It mostly contains fixes and full dynticks off-case optimizations,
by Frederic Weisbecker.

NOTE: for some reason my pull request scripts failed to generate a proper 
diffstat so I've generated the shortlog and diffstat manually. All 
resulting mistakes are mine.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (24):
      sched: Consolidate open coded preemptible() checks
      context_tracing: Fix guest accounting with native vtime
      vtime: Update a few comments
      context_tracking: Fix runtime CPU off-case
      nohz: Only enable context tracking on full dynticks CPUs
      context_tracking: Remove full dynticks' hacky dependency on wide context tracking
      context_tracking: Ground setup for static key use
      context_tracking: Optimize main APIs off case with static key
      context_tracking: Optimize guest APIs off case with static key
      context_tracking: Optimize context switch off case with static keys
      context_tracking: User/kernel broundary cross trace events
      vtime: Remove a few unneeded generic vtime state checks
      vtime: Fix racy cputime delta update
      context_tracking: Split low level state headers
      hardirq: Split preempt count mask definitions
      m68k: hardirq_count() only need preempt_mask.h
      vtime: Describe overriden functions in dedicated arch headers
      vtime: Optimize full dynticks accounting off case with static keys
      vtime: Always scale generic vtime accounting results
      vtime: Always debug check snapshot source _before_ updating it
      nohz: Rename a few state variables
      nohz: Optimize full dynticks state checks with static keys
      nohz: Optimize full dynticks's sched hooks with static keys
      nohz: Include local CPU in full dynticks global kick

Ingo Molnar (1):
      Merge branch 'timers/nohz-v3' of git://git.kernel.org/.../frederic/linux-dynticks into timers/nohz

Merge made by the 'recursive' strategy.

 arch/ia64/include/asm/Kbuild            |   1 +
 arch/m68k/include/asm/irqflags.h        |   2 +-
 arch/powerpc/include/asm/Kbuild         |   1 +
 arch/s390/include/asm/cputime.h         |   3 --
 arch/s390/include/asm/vtime.h           |   7 ++++
 arch/s390/kernel/vtime.c                |   1 +
 include/linux/context_tracking.h        | 128 ++++++++++++++++++++++++++++++++++++++---------------------------------
 include/linux/context_tracking_state.h  |  39 ++++++++++++++++++++++
 include/linux/hardirq.h                 | 117 +---------------------------------------------------------------
 include/linux/preempt_mask.h            | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tick.h                    |  45 +++++++++++++++++++++----
 include/linux/vtime.h                   |  74 ++++++++++++++++++++++++++++++++++++-----
 include/trace/events/context_tracking.h |  58 ++++++++++++++++++++++++++++++++
 init/Kconfig                            |  28 ++++++++++++----
 init/main.c                             |   2 ++
 kernel/context_tracking.c               | 125 +++++++++++++++++++++++++++++++++++++++------------------------------
 kernel/sched/core.c                     |   4 +--
 kernel/sched/cputime.c                  |  53 +++++++++--------------------
 kernel/time/Kconfig                     |   1 -
 kernel/time/tick-sched.c                |  61 ++++++++++++++++------------------
 20 files changed, 545 insertions(+), 327 deletions(-)
 create mode 100644 arch/s390/include/asm/vtime.h
 create mode 100644 include/asm-generic/vtime.h
 create mode 100644 include/linux/context_tracking_state.h
 create mode 100644 include/linux/preempt_mask.h
 create mode 100644 include/trace/events/context_tracking.h

