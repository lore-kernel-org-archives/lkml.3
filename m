Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3ECEsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:48:16 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:61366 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3ECEsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:48:15 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v4 0/7] posix timers fixlet
Date: Fri,  3 May 2013 00:47:40 -0400
Message-Id: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Glibc's posix timer testcase found a lot of bugs in posix timer code.
This series, hopefully, fixes all of them. All patches are independent 
each other logically.

Changes from v3
 - task_sched_runtime() micro optimization add to care tsk->on_cpu.
   suggested Paul Turner.
 - fixed several typo in changelogs.


KOSAKI Motohiro (7):
  posix-cpu-timers: don't account cpu timer after stopped thread
    runtime accounting
  posix-cpu-timers: fix acounting delta_exec twice
  posix-cpu-timers: fix wrong timer initialization
  posix-cpu-timers: timer functions should use timer time instead of
    clock time
  posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
  sched: task_sched_runtime introduce micro optimization
  posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}

 fs/binfmt_elf.c             |    2 +-
 fs/binfmt_elf_fdpic.c       |    2 +-
 include/linux/kernel_stat.h |    5 --
 include/linux/sched.h       |    5 +-
 kernel/posix-cpu-timers.c   |  143 ++++++++++++++++++++++++-------------------
 kernel/sched/core.c         |   34 ++++++-----
 kernel/sched/cputime.c      |   19 +++++-
 kernel/sched/stats.h        |    7 ++
 8 files changed, 125 insertions(+), 92 deletions(-)

