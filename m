Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaFCOk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:40:29 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41247 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaFCOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:40:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v7
Date: Tue,  3 Jun 2014 16:40:15 +0200
Message-Id: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version fixes the following concerns from Peterz:

* Warn _before_ work claim on irq_work_queue_on()
* Warn on in_nmi() while remote queueing
* Only disabled preemption (and not irqs) on local queueing

Thanks.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v5

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      irq_work: Split raised and lazy lists
      irq_work: Shorten a bit irq_work_needs_cpu()
      irq_work: Implement remote queueing
      nohz: Move full nohz kick to its own IPI
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 include/linux/irq_work.h |  2 ++
 include/linux/tick.h     |  9 +++++-
 kernel/irq_work.c        | 72 ++++++++++++++++++++++++++++--------------------
 kernel/sched/core.c      | 14 ++++------
 kernel/sched/sched.h     | 12 ++++++--
 kernel/smp.c             |  4 +++
 kernel/time/tick-sched.c | 10 ++++---
 7 files changed, 77 insertions(+), 46 deletions(-)
