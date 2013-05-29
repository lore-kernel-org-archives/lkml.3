Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab3E2Qkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:40:32 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:43648 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527Ab3E2Qjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:39:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Bohac <jbohac@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Mike Galbraith <efault@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] nohz fixes
Date: Wed, 29 May 2013 18:39:39 +0200
Message-Id: <1369845580-15273-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/urgent-for-tip branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/urgent-for-tip

Only the 6th patch is new so I'm posting it along, the others have been
posted a few days ago.

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      vtime: Use consistent clocks among nohz accounting
      watchdog: Boot-disable by default on full dynticks
      kvm: Move guest entry/exit APIs to context_tracking
      nohz: Prevent broadcast source from stealing full dynticks timekeeping duty

Li Zhong (1):
      nohz: Fix notifier return val that enforce timekeeping

Steven Rostedt (1):
      nohz: Warn if the machine can not perform nohz_full


 include/linux/context_tracking.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h         |   37 +------------------------------------
 include/linux/vtime.h            |    4 ++--
 kernel/context_tracking.c        |    1 -
 kernel/sched/core.c              |    2 +-
 kernel/sched/cputime.c           |    6 +++---
 kernel/time/tick-broadcast.c     |   11 ++++++++---
 kernel/time/tick-sched.c         |    7 ++++++-
 kernel/watchdog.c                |    6 ++++++
 9 files changed, 62 insertions(+), 47 deletions(-)
