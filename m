Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaDNQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:24:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54866 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaDNQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:24:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/38] tick cleanups and bugfixes
Date: Mon, 14 Apr 2014 21:53:22 +0530
Message-Id: <cover.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

These are separate cleanups from the timers/hrtimers ones I did. I was waiting
for the merge window to close in order to send these and by the time it
happened, I got a long pending list.

These are mostly cleanups, reorders for better readability or efficiency, and
few bugfixes.

I have pushed these here as well:

git://git.linaro.org/people/viresh.kumar/linux.git tick-cleanups

They will be tested by kbuild bot also starting from tonight.

Viresh Kumar (38):
  tick: align to Coding Guidelines
  tick: update doc comments for struct tick_sched
  tick: rearrange members of 'struct tick_sched'
  tick: move declaration of tick_cpu_device to tick.h
  tick: move definition of tick_get_device() to tick.h
  tick: create tick_get_cpu_device() to get tick_cpu_device on this cpu
  tick-oneshot: drop local_irq_save/restore from
    tick_switch_to_oneshot()
  tick-oneshot: move tick_is_oneshot_available() to tick-oneshot.c
  tick-oneshot: remove tick_resume_oneshot()
  tick-common: remove extra checks from tick_check_new_device()
  tick-common: fix wrong check in tick_check_replacement()
  tick-common: call tick_check_percpu() from tick_check_preferred()
  tick-common: don't check tick_oneshot_mode_active() from
    tick_check_preferred()
  tick-common: do additional checks in tick_check_preferred()
  tick-common: remove tick_check_replacement()
  tick-common: don't pass cpumask to tick_setup_device()
  tick-common: call tick_install_replacement() from
    tick_check_new_device()
  tick-common: don't set mode to CLOCK_EVT_MODE_UNUSED in
    tick_shutdown()
  tick-common: remove local variable 'broadcast' from tick_resume()
  tick-sched: initialize 'cpu' while defining it in
    tick_nohz_full_setup()
  tick-sched: no need to rewrite '1' to tick_nohz_enabled
  tick-sched: no need to recheck cpu_online() in can_stop_idle_tick()
  tick-sched: invert parameter of tick_check_oneshot_change()
  tick-sched: don't check tick_nohz_full_cpu() in
    __tick_nohz_task_switch()
  tick-sched: don't call local_softirq_pending() thrice in
    can_stop_idle_tick()
  tick-sched: don't call update_wall_time() when delta is lesser than
    tick_period
  tick-sched: remove 'regs' parameter of tick_sched_handle()
  tick-sched: remove parameters to {__}tick_nohz_task_switch() routines
  tick-sched: remove wrapper around __tick_nohz_task_switch()
  tick-sched: move nohz_full_buf[] inside tick_nohz_init()
  tick-sched: initialize 'ts' during its definition
    __tick_nohz_idle_enter()
  tick-sched: add comment about 'idle_active' in tick_nohz_idle_exit()
  tick-sched: replace tick_nohz_active with tick_nohz_enabled in
    tick_nohz_switch_to_nohz()
  tick-sched: remove local variable 'now' from tick_setup_sched_timer()
  tick-broadcast: do checks before taking locks in
    tick_do_broadcast_on_off()
  tick-broadcast: get rid of extra comparison in
    tick_do_broadcast_on_off()
  tick-broadcast: merge tick_do_broadcast_on_off() into
    tick_broadcast_on_off()
  clockevents: set event_handler to clockevents_handle_noop() in
    clockevents_exchange_device()

 include/linux/clockchips.h   |   2 -
 include/linux/hrtimer.h      |   3 -
 include/linux/tick.h         |  65 ++++++++++-------
 kernel/hrtimer.c             |   4 +-
 kernel/sched/core.c          |   2 +-
 kernel/time/clockevents.c    |  11 +--
 kernel/time/tick-broadcast.c |  74 +++++++-------------
 kernel/time/tick-common.c    | 126 +++++++++++++--------------------
 kernel/time/tick-internal.h  |  15 ++--
 kernel/time/tick-oneshot.c   |  37 +++++-----
 kernel/time/tick-sched.c     | 163 +++++++++++++++++++++++--------------------
 11 files changed, 232 insertions(+), 270 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

