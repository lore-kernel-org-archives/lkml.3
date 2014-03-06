Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaCFR4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:56:50 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:50653 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaCFR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:56:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Archs <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Huiqingding <huding@redhat.com>
Subject: [PATCH 0/6] cputime: Fixes and cleanups on steal time accounting
Date: Thu,  6 Mar 2014 18:56:35 +0100
Message-Id: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The main purpose of this set is to fix a bug on full dynticks configs
where steal time accounting appears to be zero in /proc/stat even
after a few seconds of competing guests running busy loops in a same
host CPU. It's not a regression though as it was there since the
beginning with full dynticks.

So patch [4/6] is the most important. The rest is preparatory work
to fix the bug and various cleanups.

Thanks.

---
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/cputime-fix-steal

Frederic Weisbecker (6):
  cputime: Fix nsecs_to_cputime() return type cast
  cputime: Default implementation of nsecs -> cputime conversion
  cputime: Bring cputime -> nsecs conversion
  cputime: Fix jiffies based cputime assumption on steal accounting
  sched: Remove needless round trip nsecs <-> tick conversion of steal
    time
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
 kernel/sched/cputime.c                | 11 ++++++-----
 kernel/sched/sched.h                  | 10 ----------
 28 files changed, 43 insertions(+), 63 deletions(-)
 delete mode 100644 arch/alpha/include/asm/cputime.h
 delete mode 100644 arch/cris/include/asm/cputime.h
 delete mode 100644 arch/frv/include/asm/cputime.h
 delete mode 100644 arch/m32r/include/asm/cputime.h
 delete mode 100644 arch/microblaze/include/asm/cputime.h
 delete mode 100644 arch/mn10300/include/asm/cputime.h
 delete mode 100644 arch/score/include/asm/cputime.h
 delete mode 100644 arch/x86/include/asm/cputime.h
 create mode 100644 include/linux/cputime.h

-- 
1.8.3.1

