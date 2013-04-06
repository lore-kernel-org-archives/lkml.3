Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3DFQqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:46:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35062 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DFQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:46:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [RFC GIT PULL] nohz: Full dynticks rq clock handling
Date: Sat,  6 Apr 2013 18:45:53 +0200
Message-Id: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this is the part that handles the rq clock on full dynticks CPUs.
May be some of the update_nohz_rq_clock() calls here could even
apply to mainline for dynticks idle CPUs.

There are still two known places I need to look into for which I had patches
in my nohz tree but I need to have a deeper look into these (make the patch
saner, check if the problem should be fixed in mainline instead, etc...):

* http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=3.9-rc1-nohz1&id=36ca34d0d4ba0a9589cf3054a7df9f0879ddd6c5
* http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=3.9-rc1-nohz1&id=9c3af3b4104682217b1f602acb4efbab563ccf59

But otherwise this patchset handles the big bulk of rq clock handling.

This can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-rqclock

Thanks.

---
Frederic Weisbecker (7):
  sched: Update rq clock on nohz CPU before migrating tasks
  sched: Update rq clock on nohz CPU before setting fair group shares
  sched: Update rq clock on tickless CPUs before calling
    check_preempt_curr()
  sched: Update rq clock earlier in unthrottle_cfs_rq
  sched: Update rq clock before idle balancing
  sched: Use an accessor to read rq clock
  sched: Debug nohz rq clock

 kernel/sched/core.c      |   30 +++++++++++++++++++++---
 kernel/sched/fair.c      |   55 ++++++++++++++++++++++++++--------------------
 kernel/sched/rt.c        |    8 +++---
 kernel/sched/sched.h     |   47 +++++++++++++++++++++++++++++++++++++++
 kernel/sched/stats.h     |    8 +++---
 kernel/sched/stop_task.c |    8 +++---
 lib/Kconfig.debug        |   11 +++++++++
 7 files changed, 127 insertions(+), 40 deletions(-)

-- 
1.7.5.4

