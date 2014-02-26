Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaBZQwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:52:15 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:40117 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaBZQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:52:10 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [GIT PULL] timers update for 3.15
Date: Wed, 26 Feb 2014 17:52:03 +0100
Message-Id: <1393433525-5765-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core
---

* The patch from Viresh removes some unecessary scheduler IPIs that wake
  up the CPUs when deferrable timers are enqueued on remote targets.

  In practice I have seen on boot some of these IPIs from various
  sources:  MCE, vmstat/SLAB, cpufreq. They happen either on initcall
  or cpu hotplug. Since these timers are enqueued on all CPUs, there
  are some potential big rounds of IPIs that are spared with this patch.
  
  But it's just what I've seen on my own machine on boot. I expect some
  more scenarios where a few IPIs will be avoided depending on configs
  and usecases because we have some more users of deferrable timers.

* Kconfig text made clearer for full dynticks by Paul Gortmaker.

Thanks,
	Frederic
---

Paul Gortmaker (1):
      nohz: ensure users are aware boot CPU is not NO_HZ_FULL

Viresh Kumar (1):
      timer: Spare IPI when deferrable timer is queued on idle remote targets


 kernel/time/Kconfig | 2 +-
 kernel/timer.c      | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)
