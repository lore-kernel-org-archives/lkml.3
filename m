Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaEYO36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 10:29:58 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60678 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaEYO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 10:29:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/5] nohz: Move nohz kick out of scheduler IPI, v6
Date: Sun, 25 May 2014 16:29:46 +0200
Message-Id: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version implements separate lists for tick and IPI works. As such
it simplifies the IPI raise decision.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v4

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
 kernel/irq_work.c        | 74 +++++++++++++++++++++++++++---------------------
 kernel/sched/core.c      | 14 ++++-----
 kernel/sched/sched.h     | 12 ++++++--
 kernel/smp.c             |  4 +++
 kernel/time/tick-sched.c | 10 ++++---
 7 files changed, 76 insertions(+), 49 deletions(-)
