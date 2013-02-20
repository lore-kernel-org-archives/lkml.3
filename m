Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935717Ab3BTP1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:27:07 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48331 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935430Ab3BTP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:27:06 -0500
From: Clark Williams <clark.williams@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <clark.williams@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] more sched.h reorganization
Date: Wed, 20 Feb 2013 09:19:08 -0600
Message-Id: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These two patches continue the sched.h reorganizatin. The first is a simple
move of the RR_TIMESLICE definition from sysctl to rt.h. 

The second moves the clock-related items from sched.h into sched/clock.h

Tested against allmodconfigs for x86_64, arm, mips, alpha and ia64.

Clark Williams (2):
  sched: move RR_TIMESLICE from sysctl.h to rt.h
  sched: move clock definitions from sched.h to new file

 arch/arm/kernel/sched_clock.c |  2 +-
 arch/x86/kernel/cpu/amd.c     |  2 +-
 arch/x86/kernel/cpu/intel.c   |  2 +-
 arch/x86/kernel/tsc.c         |  2 +-
 drivers/acpi/apei/ghes.c      |  1 +
 drivers/acpi/processor_idle.c |  2 +-
 fs/bio-integrity.c            |  1 +
 include/linux/blkdev.h        |  2 +-
 include/linux/ftrace.h        |  2 +-
 include/linux/sched.h         | 61 -------------------------------------------
 include/linux/sched/rt.h      |  6 +++++
 include/linux/sched/sysctl.h  |  6 -----
 init/do_mounts.c              |  2 +-
 init/do_mounts_initrd.c       |  2 +-
 init/main.c                   |  2 +-
 kernel/events/core.c          |  1 +
 kernel/lockdep.c              |  2 +-
 kernel/printk.c               |  1 +
 kernel/rcutorture.c           |  2 +-
 kernel/sched/sched.h          |  1 +
 kernel/time/tick-sched.c      |  2 +-
 kernel/trace/ring_buffer.c    |  1 +
 kernel/trace/trace_clock.c    |  2 +-
 kernel/watchdog.c             |  1 +
 lib/plist.c                   |  2 +-
 25 files changed, 28 insertions(+), 82 deletions(-)

-- 
1.8.1.2

