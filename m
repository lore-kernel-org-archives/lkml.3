Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3HUQoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:44:23 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:32995 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3HUQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:44:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 0/6] timekeeping: Missing timekeeping update detection
Date: Wed, 21 Aug 2013 18:42:15 +0200
Message-Id: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With the timekeeping going to be maintained by full system idle detection
patchset from Paul, it seems that the guarantees that enforce timekeeping
progression are going to grow in complexity enough to deserve some automated
checking.

So here is a proposition in the form of a timekeeping watchdog. It
uses periodic NMIs that poll on any suspicious drift between jiffies
and a global cpu clock progression.

Thanks.

Frederic Weisbecker (6):
  sched: Let arch tell us if sched clock is NMI-safe
  x86: nsecs to cycles conversion
  x86: Tell that sched clock is callable in nmi
  seqlock: Add raw_seqbegin() for non-waiting readers
  jiffies: Add jiffies_to_nsecs
  timekeeping: Debug missing timekeeping updates

 arch/Kconfig                       |    8 ++
 arch/x86/Kconfig                   |    2 +
 arch/x86/include/asm/cycles.h      |   11 +++
 arch/x86/kernel/apic/hw_nmi.c      |    7 --
 include/linux/jiffies.h            |    6 ++
 include/linux/seqlock.h            |    5 ++
 include/linux/time.h               |   11 +++
 kernel/time/Makefile               |    1 +
 kernel/time/tick-sched.c           |    4 +
 kernel/time/timekeeping.c          |    1 +
 kernel/time/timekeeping_selftest.c |  125 ++++++++++++++++++++++++++++++++++++
 kernel/watchdog.c                  |    3 +-
 lib/Kconfig.debug                  |   13 ++++
 13 files changed, 189 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/cycles.h
 create mode 100644 kernel/time/timekeeping_selftest.c

-- 
1.7.5.4

