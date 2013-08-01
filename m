Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3HAAmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:42:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35452 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3HAAbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:31:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [GIT PULL] nohz patches for 3.12 preview v3
Date: Thu,  1 Aug 2013 02:31:17 +0200
Message-Id: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So none of the patches from the previous v2 posting have changed.
I've just added two more in order to fix build crashes reported
by Wu Fengguang:

      hardirq: Split preempt count mask definitions
      m68k: hardirq_count() only need preempt_mask.h

If no comment arise, I'll send a pull request to Ingo in a few days.

Thanks.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-3.12-preview-v3
---

Frederic Weisbecker (23):
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


 arch/ia64/include/asm/Kbuild            |    1 +
 arch/m68k/include/asm/irqflags.h        |    2 +-
 arch/powerpc/include/asm/Kbuild         |    1 +
 arch/s390/include/asm/cputime.h         |    3 -
 arch/s390/include/asm/vtime.h           |    7 ++
 arch/s390/kernel/vtime.c                |    1 +
 include/linux/context_tracking.h        |  120 +++++++++++++++--------------
 include/linux/context_tracking_state.h  |   39 +++++++++
 include/linux/hardirq.h                 |  117 +----------------------------
 include/linux/preempt_mask.h            |  122 +++++++++++++++++++++++++++++
 include/linux/tick.h                    |   45 +++++++++--
 include/linux/vtime.h                   |   74 ++++++++++++++++--
 include/trace/events/context_tracking.h |   58 ++++++++++++++
 init/Kconfig                            |   28 +++++--
 kernel/context_tracking.c               |  128 ++++++++++++++++++-------------
 kernel/sched/core.c                     |    4 +-
 kernel/sched/cputime.c                  |   53 ++++---------
 kernel/time/Kconfig                     |    1 -
 kernel/time/tick-sched.c                |   56 ++++++--------
 19 files changed, 534 insertions(+), 326 deletions(-)
