Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBNMNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:13:14 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37499 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBNMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:12:49 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] dynticks: A few updates
Date: Fri, 14 Feb 2014 13:12:38 +0100
Message-Id: <1392379960-4758-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A small pair of updates for the dynticks code. The patch from Viresh removes a
few scheduler IPIs that I have seen on boot which are there to wake up CPUs when some
deferrable timers are enqueued. Those were enqueued on all CPUs so there is a possible
big round of IPI. And those can be avoided with the first patch. On my machine the main
sources of these were MCE, vmstat/SLAB, cpufreq. They happen either on initcall or cpu hotplug.

But deferrable timers happen anytime, not just at boot. It depends on your config and
your load. So the positive impact of the first patch should be broader.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/dynticks-testing.git
	timers/core

Thanks.

---
Paul Gortmaker (1):
  nohz: ensure users are aware boot CPU is not NO_HZ_FULL

Viresh Kumar (1):
  timer: Spare IPI when deferrable timer is queued on idle remote
    targets

 kernel/time/Kconfig | 2 +-
 kernel/timer.c      | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
1.8.3.1

