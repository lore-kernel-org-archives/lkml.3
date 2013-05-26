Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3EZVgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:36:03 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43150 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:36:00 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v5 0/8] posix timers fixlet
Date: Sun, 26 May 2013 17:35:39 -0400
Message-Id: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Glibc's posix timer testcase found a lot of bugs in posix timer code.
This series, hopefully, fixes all of them. All patches are independent 
each other logically.

Changes from v4
 - [1/8] comments colarification, fix account_group_{user_system}_time too.
 - [8/8] added CPUCLOCK_VIRT and CPUCLOCK_PROF timer initialization fix

Changes from v3
 - task_sched_runtime() micro optimization add to care tsk->on_cpu.
   suggested Paul Turner.
 - fixed several typo in changelogs.


KOSAKI Motohiro (8):
  posix-cpu-timers: don't account cpu timer after stopped thread
    runtime accounting
  posix-cpu-timers: fix acounting delta_exec twice
  posix-cpu-timers: fix wrong timer initialization
  posix-cpu-timers: timer functions should use timer time instead of
    clock time
  posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
  sched: task_sched_runtime introduce micro optimization
  posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}
  posix-cpu-timers: fix cputimer initialization mistake for {u,s}time

 fs/binfmt_elf.c             |    2 +-
 fs/binfmt_elf_fdpic.c       |    2 +-
 include/linux/kernel_stat.h |    5 --
 include/linux/sched.h       |    5 +-
 kernel/posix-cpu-timers.c   |  163 ++++++++++++++++++++++++++-----------------
 kernel/sched/core.c         |   34 +++++----
 kernel/sched/cputime.c      |   17 ++++-
 kernel/sched/stats.h        |   33 ++++++++-
 8 files changed, 167 insertions(+), 94 deletions(-)

