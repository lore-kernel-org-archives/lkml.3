Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaCEAZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:25:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44905 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755862AbaCEAZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:25:10 -0500
Message-Id: <20140305002446.173840270@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Mar 2014 19:24:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/8] Linux 3.8.13.14-rt28-rc1
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.8.13.14-rt28-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/7/2014.

Enjoy,

-- Steve


To build 3.8.13.14-rt28-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.14-rt28-rc1.patch.xz

You can also build from 3.8.13.14-rt27 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.14-rt27-rt28-rc1.patch.xz


Changes from 3.8.13.14-rt27:

---


Nicholas Mc Guire (1):
      net: ip_send_unicast_reply: add missing local serialization

Paul E. McKenney (1):
      rcu: Eliminate softirq processing from rcutree

Sebastian Andrzej Siewior (3):
      Revert "x86: Disable IST stacks for debug/int 3/stack fault for PREEMPT_RT"
      kernel/hrtimer: be non-freezeable in cpu_chill()
      arm/unwind: use a raw_spin_lock

Steven Rostedt (1):
      rt: Make cpu_chill() use hrtimer instead of msleep()

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.14-rt28-rc1

Tiejun Chen (1):
      rcutree/rcu_bh_qs: disable irq while calling rcu_preempt_qs()

----
 arch/arm/kernel/unwind.c             |  14 ++--
 arch/x86/include/asm/page_64_types.h |  21 ++----
 arch/x86/kernel/cpu/common.c         |   2 -
 arch/x86/kernel/dumpstack_64.c       |   4 --
 include/linux/delay.h                |   2 +-
 kernel/hrtimer.c                     |  19 +++++
 kernel/rcutree.c                     | 119 +++++++++++++++++++++++++++----
 kernel/rcutree.h                     |   3 +-
 kernel/rcutree_plugin.h              | 133 ++++-------------------------------
 localversion-rt                      |   2 +-
 net/ipv4/ip_output.c                 |   9 ++-
 11 files changed, 159 insertions(+), 169 deletions(-)
