Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaDUJz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:55:59 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45885 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaDUJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:55:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 00/19] tick: cleanups (Shouldn't change code behavior)
Date: Mon, 21 Apr 2014 15:24:56 +0530
Message-Id: <cover.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by you (https://lkml.org/lkml/2014/4/14/797), this is the second
lot of changes I have. I have divided the earlier patchset into three parts:
- Bugfixes, already merged
- Code cleanups which shouldn't have any functional change
- Code cleanups which may have any functional change

This patchset is targeting the second part now. Its just about moving the code
around to make it more readable and obvious. Not removing any code at all, that
will be addressed in next series.

V1->V2: Actually V1 was never reviewed and so it is mostly a resend of V1. Some
rearrangement of patches is done though.

Viresh Kumar (19):
  tick: trivial cleanups
  tick: update doc style comments for 'struct tick_sched'
  tick: rearrange members of 'struct tick_sched'
  tick: move declaration of 'tick_cpu_device' to tick.h
  tick: move definition of tick_get_device() to tick.h
  tick: create tick_get_cpu_device() to get tick_cpu_device on this cpu
  tick: initialize variables during their definitions
  tick-oneshot: move tick_is_oneshot_available() to tick-oneshot.c
  tick-oneshot: remove tick_resume_oneshot()
  tick-common: call tick_check_percpu() from tick_check_preferred()
  tick-common: remove tick_check_replacement()
  tick-common: don't pass 'cpu' & 'cpumask' to tick_setup_device()
  tick-common: remove local variable 'broadcast' from tick_resume()
  tick-sched: add comment about 'idle_active' in tick_nohz_idle_exit()
  tick-sched: define 'delta' inside 'if' block in
    update_ts_time_stats()
  tick-sched: remove parameters to {__}tick_nohz_task_switch() routines
  tick-sched: remove local variable 'now' from tick_setup_sched_timer()
  tick-sched: invert parameter of tick_check_oneshot_change()
  tick-sched: rearrange code in tick_do_update_jiffies64()

 include/linux/hrtimer.h      |  3 --
 include/linux/tick.h         | 62 +++++++++++++++++++-----------
 kernel/hrtimer.c             |  4 +-
 kernel/sched/core.c          |  2 +-
 kernel/time/clockevents.c    | 12 +++---
 kernel/time/clocksource.c    | 14 +++----
 kernel/time/tick-broadcast.c | 48 +++++++++--------------
 kernel/time/tick-common.c    | 90 ++++++++++++++------------------------------
 kernel/time/tick-internal.h  | 15 ++++----
 kernel/time/tick-oneshot.c   | 34 +++++++++--------
 kernel/time/tick-sched.c     | 80 +++++++++++++++++++++++----------------
 kernel/time/timekeeping.c    | 10 ++---
 12 files changed, 177 insertions(+), 197 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

