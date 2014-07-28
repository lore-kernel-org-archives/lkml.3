Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaG1Rhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:37:50 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60672 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG1Rhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/10] nohz: Support sysidle (+ some more nohz kick cleanups)
Date: Mon, 28 Jul 2014 19:37:26 +0200
Message-Id: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this set, I have added Paul's acks and applied Peterz suggestion to
rename irq_work_void_on() to kick_cpu(), which I actually expanded to
kick_cpu_async() so to differentiate its behaviour from kick_all_cpus_sync().

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/sysidle-v2

Thanks,
	Frederic
---

Frederic Weisbecker (10):
      smp: Introduce void kick_cpu_async()
      nohz: Kick full dynticks timer targets with an empty IPI
      rcu: Kick full dynticks CPU on extended grace period with kick_cpu_async()
      nohz: Appropriate timekeeper kick on sysidle break
      smp: Fast path check on IPI list
      nohz: Define meaningful symbol for nohz full timekeeper
      nohz: Enforce timekeeping on CPU 0
      nohz: Fetch timekeeping max deferment only for timekeeper
      nohz: Switch nohz full timekeeper to dynticks idle on top of sysidle detection
      nohz: Warn on illegal timekeeper switch in nohz full


 include/linux/smp.h         |  1 +
 kernel/rcu/tree_plugin.h    | 10 ++++---
 kernel/sched/core.c         |  8 ++---
 kernel/smp.c                | 32 +++++++++++++++++++-
 kernel/time/tick-common.c   | 11 ++++---
 kernel/time/tick-internal.h |  8 +++++
 kernel/time/tick-sched.c    | 72 ++++++++++++++++++++++-----------------------
 7 files changed, 90 insertions(+), 52 deletions(-)
