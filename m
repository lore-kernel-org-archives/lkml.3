Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbaEMOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:38:49 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64241 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaEMOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:38:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 0/5] nohz: Move nohz kick out of scheduler IPI, v4
Date: Tue, 13 May 2014 16:38:36 +0200
Message-Id: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this version now implements remote irq works using the generic IPI
interrupt available in most archs, as suggested by Peterz.

Keep in mind that the first patch is really just a draft to build the
mockup. It needs to be turned into an internal state set on boot or so.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v2

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      irq_work: Let arch tell us if it can raise irq work
      irq_work: Force non-lazy works to the IPI
      irq_work: Allow remote queueing
      nohz: Move full nohz kick to its own IPI
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 arch/alpha/kernel/time.c   |  5 +++
 arch/arm/kernel/smp.c      |  5 +++
 arch/powerpc/kernel/time.c |  5 +++
 arch/sparc/kernel/pcr.c    |  5 +++
 arch/x86/kernel/irq_work.c |  7 ++++
 include/linux/irq_work.h   |  3 ++
 include/linux/tick.h       |  9 ++++-
 kernel/irq_work.c          | 83 +++++++++++++++++++++++++++++++---------------
 kernel/sched/core.c        | 14 ++++----
 kernel/sched/sched.h       | 12 +++++--
 kernel/smp.c               |  3 ++
 kernel/time/tick-sched.c   | 10 +++---
 kernel/timer.c             |  2 +-
 13 files changed, 119 insertions(+), 44 deletions(-)
