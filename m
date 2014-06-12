Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaFLLv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:51:58 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59058 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaFLLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:51:55 -0400
Date: Thu, 12 Jun 2014 13:51:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler updates for v3.16, #2
Message-ID: <20140612115150.GA26691@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: 535560d841b2d54f31280e05e9c6ffd19da0c4e7 Merge commit '3cf2f34' into sched/core, to fix build error

Second round of scheduler changes:

 - try-to-wakeup and IPI reduction speedups, from Andy Lutomirski

 - continued power scheduling cleanups and refactorings, from Nicolas Pitre

 - misc fixes and enhancements

Thanks,

	Ingo

------------------------={ diffstat and shortlog created manually }=----------------->

 arch/arm/kernel/topology.c   |  54 +++++++++----------
 arch/powerpc/kernel/smp.c    |   2 +-
 drivers/cpuidle/driver.c     |   7 ++-
 include/linux/kvm_host.h     |   2 +-
 include/linux/sched.h        |  14 ++---
 include/trace/events/sched.h |  20 +++++++
 kernel/sched/core.c          | 182 +++++++++++++++++++++++++++++++++++---------------------------
 kernel/sched/deadline.c      |   2 -
 kernel/sched/fair.c          | 390 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------
 kernel/sched/features.h      |   8 +--
 kernel/sched/idle.c          |  30 ++++++++++-
 kernel/sched/rt.c            |   3 +-
 kernel/sched/sched.h         |  24 +++++----
 virt/kvm/kvm_main.c          |   4 +-
 14 files changed, 416 insertions(+), 326 deletions(-)


Andy Lutomirski (4):
      cpuidle: Set polling in poll_idle
      sched, trace: Add a tracepoint for IPI-less remote wakeups
      sched/idle: Clear polling before descheduling the idle thread
      sched/idle: Simplify wake_up_idle_cpu()

Ben Segall (1):
      sched/fair: Fix unlocked reads of some cfs_b->quota/period

Dan Carpenter (1):
      sched: Fix signedness bug in yield_to()

Giedrius Rekasius (1):
      sched: Remove redundant assignment to "rt_rq" in update_curr_rt(...)

Ingo Molnar (1):
      Merge commit '3cf2f34' into sched/core, to fix build error

Manuel Schölling (1):
      sched/fair: Use time_after() in record_wakee()

Nicolas Pitre (7):
      sched/fair: Remove "power" from 'struct numa_stats'
      sched/fair: Change "has_capacity" to "has_free_capacity"
      sched/fair: Disambiguate existing/remaining "capacity" usage
      sched: Let 'struct sched_group_power' care about CPU capacity
      sched: Remove remaining dubious usage of "power"
      sched: Final power vs. capacity cleanups
      sched: Rename capacity related flags

Paul Gortmaker (1):
      sched/deadline: Delete extraneous extern for to_ratio()

Peter Zijlstra (1):
      sched/idle: Optimize try-to-wake-up IPI

Tim Chen (1):
      sched/balancing: Reduce the rate of needless idle load balancing
