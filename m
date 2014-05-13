Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaEMW0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:26:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:63553 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaEMW0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:26:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/3] nohz: Move nohz kick out of scheduler IPI, v5
Date: Wed, 14 May 2014 00:25:53 +0200
Message-Id: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I removed all the part that tried to avoid the tick for the nohz
IPI since the lockdep report I saw was actually about other issues
related to locking scenarios of my own brain.

Now it's much simplified!

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v3

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      irq_work: Implement remote queueing
      nohz: Move full nohz kick to its own IPI
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 include/linux/irq_work.h |  2 ++
 include/linux/tick.h     |  9 ++++++++-
 kernel/irq_work.c        | 19 ++++++++++++++++++-
 kernel/sched/core.c      | 14 ++++++--------
 kernel/sched/sched.h     | 12 +++++++++---
 kernel/smp.c             |  4 ++++
 kernel/time/tick-sched.c | 10 ++++++----
 7 files changed, 53 insertions(+), 17 deletions(-)
