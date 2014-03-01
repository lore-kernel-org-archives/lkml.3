Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaCADwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:52:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:12205 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbaCADwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:52:37 -0500
Message-Id: <20140301035209.031474616@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 22:52:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 00/14] Linux 3.10.32-rt31-rc2
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.10.32-rt31-rc2.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/3/2014.

Enjoy,

-- Steve


To build 3.10.32-rt31-rc2 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.32.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.32-rt31-rc2.patch.xz

You can also build from 3.10.32-rt30 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.32-rt30-rt31-rc2.patch.xz


Changes from 3.10.32-rt30:

---


Nicholas Mc Guire (1):
      net: ip_send_unicast_reply: add missing local serialization

Paul E. McKenney (2):
      rcu: Don't activate RCU core on NO_HZ_FULL CPUs
      rcu: Eliminate softirq processing from rcutree

Sebastian Andrzej Siewior (5):
      Revert "x86: Disable IST stacks for debug/int 3/stack fault for PREEMPT_RT"
      kernel/hrtimer: be non-freezeable in cpu_chill()
      irq_work: allow certain work in hard irq context
      arm/unwind: use a raw_spin_lock
      leds: trigger: disable CPU trigger on -RT

Steven Rostedt (3):
      timer: Raise softirq if there's irq_work
      timer/rt: Always raise the softirq if there's irq_work to be done
      rt: Make cpu_chill() use hrtimer instead of msleep()

Steven Rostedt (Red Hat) (1):
      Linux 3.10.32-rt31-rc2

Thomas Gleixner (1):
      timers: do not raise softirq unconditionally

Tiejun Chen (1):
      rcutree/rcu_bh_qs: disable irq while calling rcu_preempt_qs()

----
 arch/arm/kernel/unwind.c             |  14 ++--
 arch/powerpc/kernel/time.c           |   2 +-
 arch/sparc/kernel/pcr.c              |   2 +
 arch/x86/include/asm/page_64_types.h |  21 ++---
 arch/x86/kernel/cpu/common.c         |   2 -
 arch/x86/kernel/dumpstack_64.c       |   4 -
 drivers/leds/trigger/Kconfig         |   2 +-
 include/linux/delay.h                |   2 +-
 include/linux/hrtimer.h              |   3 +-
 include/linux/irq_work.h             |   1 +
 kernel/hrtimer.c                     |  50 ++++++------
 kernel/irq_work.c                    |  22 ++++-
 kernel/rcutree.c                     | 122 +++++++++++++++++++++++----
 kernel/rcutree.h                     |   4 +-
 kernel/rcutree_plugin.h              | 154 ++++++++---------------------------
 kernel/time/tick-sched.c             |   1 +
 kernel/timer.c                       |  37 ++++++++-
 localversion-rt                      |   2 +-
 net/ipv4/ip_output.c                 |   9 +-
 19 files changed, 249 insertions(+), 205 deletions(-)
