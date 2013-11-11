Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3KKOuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:50:01 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64148 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3KKOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:49:54 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [GIT PULL] dynticks updates for 3.13
Date: Mon, 11 Nov 2013 15:49:47 +0100
Message-Id: <1384181387-30194-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core

It passed through 0-day testing. I'm proposing it for 3.13 just in case but I'm ok
as well if you think it's too late and should be delayed for 3.14

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      nohz: Convert a few places to use local per cpu accesses
      context_tracking: Wrap static key check into more intuitive function name
      context_tracking: Rename context_tracking_active() to context_tracking_cpu_is_enabled()
      posix-timers: Spare workqueue if there is no full dynticks CPU to kick
      posix-timers: Fix full dynticks CPUs kick on timer rescheduling

Paul Gortmaker (1):
      trivial: fix spelling in CONTEXT_TRACKING_FORCE help text


 include/linux/context_tracking.h       | 10 ++++-----
 include/linux/context_tracking_state.h | 11 +++++++---
 include/linux/tick.h                   |  8 ++++----
 include/linux/vtime.h                  |  4 ++--
 init/Kconfig                           |  2 +-
 kernel/context_tracking.c              |  8 ++++----
 kernel/posix-cpu-timers.c              | 21 +++++++++----------
 kernel/softirq.c                       |  4 +---
 kernel/time/tick-broadcast.c           |  6 +++---
 kernel/time/tick-internal.h            |  4 ++--
 kernel/time/tick-sched.c               | 37 ++++++++++++++--------------------
 11 files changed, 54 insertions(+), 61 deletions(-)
