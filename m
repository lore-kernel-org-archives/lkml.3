Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3FLOCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:02:48 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65103 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3FLOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:02:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/6] timers nohz updates preview for 3.11
Date: Wed, 12 Jun 2013 16:02:32 +0200
Message-Id: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So here is a first batch of some patches I think could go for 3.11
Except for "rcu: Prevent CPU from stopping tick if awaited for quiescent state report"
which needs more thinking. I believe we can do more from the IPI to force a
quiescent state without the need to restart the tick.

For those who want to check through git:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core-preview

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      sched: Disable lb_bias feature for full dynticks
      watchdog: Register / unregister watchdog kthreads on sysctl control
      watchdog: Boot-disable by default on full dynticks
      rcu: Prevent CPU from stopping tick if awaited for quiescent state report
      nohz: Remove obsolete check for full dynticks CPUs to be RCU nocbs

Steven Rostedt (1):
      nohz: Warn if the machine can not perform nohz_full


 include/linux/rcupdate.h |    3 +
 kernel/rcutree_plugin.h  |   43 +++++++++++++++++++++
 kernel/sched/fair.c      |   13 +++++-
 kernel/sched/features.h  |    3 +
 kernel/time/tick-sched.c |   20 +++++-----
 kernel/watchdog.c        |   93 ++++++++++++++++++++++++++-------------------
 6 files changed, 124 insertions(+), 51 deletions(-)
