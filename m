Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaFUX3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 19:29:25 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42190 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaFUX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 19:29:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/5] timer: Fix missing dynticks kick v2
Date: Sun, 22 Jun 2014 01:29:12 +0200
Message-Id: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's a 2nd set that fixes some missing dyntick kicks in the timer's code.
This new version also handles missing kicks in the hrtimers subsystem.

The patches are also available at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/missing-kick-v2

Thanks,
	Frederic
---

Viresh Kumar (5):
      timer: Store cpu-number in 'struct tvec_base'
      timer: Kick dynticks targets on mod_timer*() calls
      hrtimer: Store cpu-number in 'struct hrtimer_cpu_base'
      hrtimer: Kick lowres dynticks targets on timer enqueue
      hrtimer: Remove hrtimer_enqueue_reprogram()


 include/linux/hrtimer.h |  2 ++
 kernel/hrtimer.c        | 49 +++++++++++++++++++++++++++----------------------
 kernel/timer.c          | 34 ++++++++++++++++++----------------
 3 files changed, 47 insertions(+), 38 deletions(-)
