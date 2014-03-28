Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaC1Llt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:41:49 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56506 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaC1Lls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:41:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
Date: Fri, 28 Mar 2014 17:11:19 +0530
Message-Id: <cover.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I have got few more cleanups other than what I posted yesterday:
https://lkml.org/lkml/2014/3/26/107

All 30 are pushed here (i.e. Part I and II)

git://git.linaro.org/people/viresh.kumar/linux.git timer-cleanup-for-tglx

Please see if they make sense.

Viresh Kumar (16):
  hrtimer: move unlock_hrtimer_base() upwards
  hrtimer: reorder code in __remove_hrtimer()
  hrtimer: Create hrtimer_get_monoexpires()
  hrtimer: remove 'base' parameter from remove_timer() and
    __remove_timer()
  hrtimer: remove 'base' parameter from switch_hrtimer_base()
  hrtimer: remove 'base' parameter from enqueue_hrtimer()
  hrtimer: remove 'base' parameter from hrtimer_{enqueue_}reprogram()
  hrtimer: make switch_hrtimer_base() return void
  hrtimer: make lock_hrtimer_base() return void
  hrtimer: make enqueue_hrtimer() return void
  hrtimer: don't check if timer is queued in __remove_hrtimer()
  hrtimer: rewrite switch_hrtimer_base() to remove extra indentation
    level
  hrtimer: rewrite remove_hrtimer() to remove extra indentation level
  hrtimer: replace base by new_base to get resolution:
    __hrtimer_start_range_ns()
  hrtimer: create base_on_this_cpu()
  hrtimer: use base->hres_active directly instead of
    hrtimer_hres_active()

 include/linux/hrtimer.h |  11 +++
 kernel/hrtimer.c        | 242 +++++++++++++++++++++---------------------------
 2 files changed, 119 insertions(+), 134 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

