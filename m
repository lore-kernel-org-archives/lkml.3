Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbaEKXeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:34:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61450 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaEKXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:34:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 0/5] nohz: Move nohz kick out of scheduler IPI, v3
Date: Mon, 12 May 2014 01:33:52 +0200
Message-Id: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this version gives up with smp_queue_function_single() and extends
irq work to support remote queuing. As suggested by Peterz.

Comments?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      irq_work: Architecture support for remote irq work raise
      irq_work: Force non-lazy works on IPI
      irq_work: Allow remote queueing
      nohz: Move full nohz kick to its own IPI
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 arch/Kconfig               | 12 +++++++
 arch/alpha/kernel/time.c   |  3 +-
 arch/arm/Kconfig           |  1 +
 arch/arm/kernel/smp.c      |  4 +--
 arch/powerpc/kernel/time.c |  3 +-
 arch/sparc/kernel/pcr.c    |  3 +-
 arch/x86/Kconfig           |  1 +
 arch/x86/kernel/irq_work.c | 10 ++----
 include/linux/irq_work.h   |  3 ++
 include/linux/tick.h       |  9 ++++-
 kernel/irq_work.c          | 87 +++++++++++++++++++++++++++++++---------------
 kernel/sched/core.c        | 14 ++++----
 kernel/sched/sched.h       | 12 +++++--
 kernel/time/Kconfig        |  2 ++
 kernel/time/tick-sched.c   | 10 +++---
 kernel/timer.c             |  2 +-
 16 files changed, 118 insertions(+), 58 deletions(-)
