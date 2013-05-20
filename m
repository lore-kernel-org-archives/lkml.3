Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3ETQCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53003 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3ETQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/8] nohz: Random fixes
Date: Mon, 20 May 2013 18:01:48 +0200
Message-Id: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few fixes for nohz against -rc1. I'll likely send the non-rfc
part to Ingo tomorrow, unless anybody has concerns.

Thanks.

---
Frederic Weisbecker (6):
  vtime: Use consistent clocks among nohz accounting
  watchdog: Boot-disable by default on full dynticks
  kvm: Move guest entry/exit APIs to context_tracking
  kthread: Enable parking requests from setup() and unpark() callbacks
  watchdog: Rename confusing state variable
  watchdog: Fix internal state with boot user disabled watchdog

Li Zhong (1):
  nohz: Fix notifier return val that enforce timekeeping

Steven Rostedt (1):
  nohz: Warn if the machine can not perform nohz_full

 include/linux/context_tracking.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h         |   37 +------------------------------------
 include/linux/nmi.h              |    2 +-
 include/linux/vtime.h            |    4 ++--
 kernel/context_tracking.c        |    1 -
 kernel/sched/core.c              |    2 +-
 kernel/sched/cputime.c           |    6 +++---
 kernel/smpboot.c                 |    6 ++++++
 kernel/sysctl.c                  |    4 ++--
 kernel/time/tick-sched.c         |    7 ++++++-
 kernel/watchdog.c                |   34 ++++++++++++++++++++--------------
 11 files changed, 77 insertions(+), 61 deletions(-)

-- 
1.7.5.4

