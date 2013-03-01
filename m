Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3CAQJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:09:22 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:35743 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3CAQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:09:21 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/5] context_tracking: Fixes and improvements
Date: Fri,  1 Mar 2013 17:08:54 +0100
Message-Id: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a bunch of patches preview for 3.10

Thanks.

Frederic Weisbecker (5):
  context_tracking: Move exception handling to generic code
  context_tracking: Restore correct previous context state on exception
    exit
  context_tracking: Restore preempted context state after
    preempt_schedule_irq()
  cputime: Dynamically scale cputime for full dynticks accounting
  context_tracking: Enable probes by default for selftesting

 arch/x86/include/asm/context_tracking.h |   21 ----
 arch/x86/kernel/kvm.c                   |    8 +-
 arch/x86/kernel/traps.c                 |   68 +++++++++-----
 arch/x86/mm/fault.c                     |    8 +-
 include/linux/context_tracking.h        |   24 +++++-
 include/linux/sched.h                   |    4 +-
 init/Kconfig                            |    1 +
 kernel/fork.c                           |    2 +-
 kernel/sched/core.c                     |    6 +-
 kernel/sched/cputime.c                  |  154 ++++++++++++++++---------------
 10 files changed, 163 insertions(+), 133 deletions(-)

-- 
1.7.5.4

