Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab3DCMqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:46:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36829 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:46:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: [RFC GIT PULL] nohz: Kconfig layout improvements
Date: Wed,  3 Apr 2013 14:46:26 +0200
Message-Id: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This set addresses your review concerning the Kconfig layout.
Please note two things here that derive from what we agreed
on due to technical limitations:

* Now the full dynticks Kconfig is not hidden anymore behind its
high level dependencies. (ie: passive dependencies are now active).
There is an exception though with CONFIG_VIRT_CPU_ACCOUNTING_GEN
(Full dynticks cputime accounting) that is part of a choice menu
like PREEMPT_*. It seems such kconfig layout prevent from doing a remote
select on its choices. So it stays a passive dependency for now, until
Kconfig/Kbuild supports that (Cc'ing Michel Marek) or somebody shows
me what I did wrong ;)

* Ideally we want to reuse CONFIG_NO_HZ as a Kconfig that consolidate
the common code between CONFIG_NO_HZ_IDLE and CONFIG_NO_HZ_EXTENDED.
But we also want CONFIG_NO_HZ from old config files to map to CONFIG_NO_HZ_IDLE.
Both at the same time is not possible or we have a Kconfig circular
dependency. So I introduced a new CONFIG_NO_HZ_COMMON for common nohz code
and CONFIG_NO_HZ stays for backward compatibility by enabling CONFIG_NO_HZ_IDLE
by default.

If you're ok, please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-v2

Thanks.

---
Frederic Weisbecker (4):
  nohz: Unhide full dynticks feature from its dependencies
  nohz: Rename CONFIG_NO_HZ to CONFIG_NO_HZ_COMMON
  nohz: Pack nohz Kconfig option in a menu of choices
  nohz: Print final full dynticks CPUs range on boot

 Documentation/RCU/stallwarn.txt         |    2 +-
 Documentation/cpu-freq/governors.txt    |    4 +-
 arch/um/include/shared/common-offsets.h |    4 +-
 arch/um/os-Linux/time.c                 |    2 +-
 include/linux/sched.h                   |    8 ++--
 include/linux/tick.h                    |    8 ++--
 init/Kconfig                            |    2 +-
 kernel/hrtimer.c                        |    4 +-
 kernel/sched/core.c                     |   18 +++++-----
 kernel/sched/fair.c                     |   10 +++---
 kernel/sched/sched.h                    |    4 +-
 kernel/softirq.c                        |    2 +-
 kernel/time/Kconfig                     |   54 ++++++++++++++++++++++++------
 kernel/time/tick-sched.c                |   22 +++++++++---
 kernel/timer.c                          |    4 +-
 15 files changed, 95 insertions(+), 53 deletions(-)

-- 
1.7.5.4

