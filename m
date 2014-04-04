Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaDDGju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:39:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50349 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaDDGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:39:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 00/36] timers/hrtimers: Cleanups & Fixes
Date: Fri,  4 Apr 2014 12:05:43 +0530
Message-Id: <cover.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I know you are not going to look at these before end of this merge window and
you wanted to have a look at V1 before me posting these. But I am reposting them
now due to these reasons:
- Need to resend my cpu isolation (cpuset.quiesce) patches which are based of
  these
- Few patches are dropped/merged/fixed/updated and so all the patches from V1
  wouldn't have made sense
- There were some new patches as well which I wanted to send

These have gone through fair bit of testing via kbuild system maintained by
Fengguang Wu.


These are some minor cleanups and potential bug fixes in there. These are based
of tip/timers-core-for-linus ..

V1 of most of these patches (~28) were posted here:
https://lkml.org/lkml/2014/3/26/107
https://lkml.org/lkml/2014/3/28/148

V1->V2:
- few new patches:
  - patches around for_each_active_base()
  - hrtimer: call switch_hrtimer_base() after setting new expiry time
  - Some other minor cleanups
- few patches are dropped
- few are merged together as they covered same stuff
- rebased all patches and moved the patches removing parameters or return values
  at the bottom, so that others can be applied easily. Though as per my last
  mail, it doesn't look like they are making the 'text' segments any bigger.

Viresh Kumar (36):
  hrtimer: replace 'tab' with 'space' after 'comma'
  hrtimer: Fix comment mistake over hrtimer_force_reprogram()
  hrtimer: fix routine names in comments
  hrtimer: remove {} around a single liner 'for' loop in
    migrate_hrtimers()
  hrtimer: Coalesce format fragments in printk()
  hrtimer: remove dummy definition of hrtimer_force_reprogram()
  hrtimer: replace sizeof(struct hrtimer) with sizeof(*timer)
  hrtimer: move unlock_hrtimer_base() upwards
  hrtimer: call hrtimer_set_expires_range() from
    hrtimer_set_expires_range_ns()
  hrtimer: use base->index instead of basenum in switch_hrtimer_base()
  hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
  hrtimer: use base->hres_active directly instead of
    hrtimer_hres_active()
  hrtimer: don't check state of base->hres_active in
    hrtimer_switch_to_hres()
  hrtimer: reorder code in __remove_hrtimer()
  hrtimer: don't emulate notifier call to initialize timer base
  hrtimer: Create hrtimer_get_monoexpires()
  hrtimer: don't check if timer is queued in __remove_hrtimer()
  hrtimer: rewrite switch_hrtimer_base() to remove extra indentation
    level
  hrtimer: rewrite remove_hrtimer() to remove extra indentation level
  hrtimer: replace base by new_base to get resolution:
    __hrtimer_start_range_ns()
  hrtimer: create base_on_this_cpu()
  hrtimer: clear active_bases as soon as the timer is removed
  hrtimer: create for_each_active_base()
  hrtimer: Use for_each_active_base() to iterate over active clock
    bases
  hrtimer: call hrtimer_get_softirq_time() only if
    cpu_base->active_bases is set
  hrtimer: take lock only once for a cpu_base in hrtimer_run_queues()
  hrtimer: call switch_hrtimer_base() after setting new expiry time
  hrtimer: remove 'base' parameter from remove_timer() and
    __remove_timer()
  hrtimer: remove 'base' parameter from switch_hrtimer_base()
  hrtimer: remove 'base' parameter from enqueue_hrtimer()
  hrtimer: remove 'base' parameter from hrtimer_{enqueue_}reprogram()
  hrtimer: make switch_hrtimer_base() return void
  hrtimer: make lock_hrtimer_base() return void
  hrtimer: make enqueue_hrtimer() return void
  timer: simplify CPU_UP_PREPARE notifier code path
  timer: don't emulate notifier call to initialize timer base

 include/linux/hrtimer.h |  14 +-
 kernel/hrtimer.c        | 365 ++++++++++++++++++++++--------------------------
 kernel/timer.c          |  12 +-
 3 files changed, 179 insertions(+), 212 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

