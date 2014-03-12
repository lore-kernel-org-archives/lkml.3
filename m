Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaCLCKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:10:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49897 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbaCLCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:10:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Archs <linux-arch@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Huiqingding <huding@redhat.com>
Subject: [GIT PULL] timers updates for 3.15
Date: Wed, 12 Mar 2014 03:09:56 +0100
Message-Id: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the timers/cputime-fix-steal-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/cputime-fix-steal-v2

It's based on tip:timers/core. The patches are essentially unchanged
since the last version (https://lkml.org/lkml/2014/3/6/376). I only
added a small comment in 4/6 and acks from Rik.

---
The main purpose of this set is to fix a bug on full dynticks configs
where steal time accounting appears to be zero in /proc/stat even
after a few seconds of competing guests running busy loops in a same
host CPU. It's not a regression though as it was there since the
beginning with full dynticks.

So patch [4/6] ("cputime: Fix jiffies based cputime assumption on
steal accounting") is the most important patch of the series. The rest
is mostly preparatory work to fix the bug plus various cleanups.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      cputime: Fix nsecs_to_cputime() return type cast
      cputime: Default implementation of nsecs -> cputime conversion
      cputime: Bring cputime -> nsecs conversion
      cputime: Fix jiffies based cputime assumption on steal accounting
      sched: Remove needless round trip nsecs <-> tick conversion of steal time
      arch: Remove stub cputime.h headers


 arch/alpha/include/asm/Kbuild         |  1 +
 arch/alpha/include/asm/cputime.h      |  6 ------
 arch/cris/include/asm/Kbuild          |  1 +
 arch/cris/include/asm/cputime.h       |  6 ------
 arch/frv/include/asm/Kbuild           |  1 +
 arch/frv/include/asm/cputime.h        |  6 ------
 arch/m32r/include/asm/Kbuild          |  1 +
 arch/m32r/include/asm/cputime.h       |  6 ------
 arch/microblaze/include/asm/Kbuild    |  1 +
 arch/microblaze/include/asm/cputime.h |  1 -
 arch/mn10300/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/cputime.h    |  1 -
 arch/score/include/asm/Kbuild         |  2 +-
 arch/score/include/asm/cputime.h      |  6 ------
 arch/x86/include/asm/Kbuild           |  1 +
 arch/x86/include/asm/cputime.h        |  1 -
 drivers/cpufreq/cpufreq_stats.c       |  2 +-
 drivers/s390/cio/cio.c                |  2 +-
 fs/proc/stat.c                        |  2 +-
 fs/proc/uptime.c                      |  2 +-
 include/asm-generic/cputime_jiffies.h |  4 +++-
 include/asm-generic/cputime_nsecs.h   |  5 ++++-
 include/linux/cputime.h               | 16 ++++++++++++++++
 include/linux/kernel_stat.h           |  2 +-
 include/linux/sched.h                 |  2 +-
 kernel/sched/core.c                   |  6 ------
 kernel/sched/cputime.c                | 16 +++++++++++-----
 kernel/sched/sched.h                  | 10 ----------
 28 files changed, 48 insertions(+), 63 deletions(-)
