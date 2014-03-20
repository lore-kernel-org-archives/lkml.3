Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbaCTNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:49:17 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59493 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaCTNtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:49:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org,
        mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 20 Mar 2014 19:18:57 +0530
Message-Id: <cover.1395322529.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For networking platforms we need to provide one isolated CPU per user space data
plane thread. These CPUs should not be interrupted by kernel at all unless
userspace has requested for some syscalls. And so must live in isolated mode.
Currently, there are background kernel activities that are running on almost
every CPU, like: timers/hrtimers/watchdogs/etc, and these are required to be
migrated to other CPUs.

This patchset tries to migrate un-pinned timers away in the first attempt. And
support for migrating others like hrtimers/workqueues/etc would be added later.

This has only went through basic testing currently on ARM Samsung Exynos board
which only has two CPUs. Separate cpusets were created for these two CPUs and
then timers were migrated from one cpuset to other.

This option was earlier suggested by Peter Z. here.

https://lkml.org/lkml/2014/1/15/186

Please provide your inputs on how this can be improved..

Viresh Kumar (4):
  timer: track pinned timers with TIMER_PINNED flag
  timer: don't migrate pinned timers
  timer: create timer_quiesce_cpu() for cpusets.quiesce option
  cpuset: Add cpusets.quiesce option

 include/linux/timer.h | 10 +++---
 kernel/cpuset.c       | 56 +++++++++++++++++++++++++++++++
 kernel/timer.c        | 92 +++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 136 insertions(+), 22 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

