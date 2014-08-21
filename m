Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaHUO61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:58:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45185 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaHUOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/9] nohz: Nohz full kick fixes
Date: Thu, 21 Aug 2014 16:52:48 +0200
Message-Id: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There have been several reports of warnings and lockup lately due to
recent or longer term issues.

This patchset is a proposed solution to fix them.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/fixes

Thanks,
	Frederic
---

Frederic Weisbecker (9):
      nohz: Restore NMI safe local irq work for local nohz kick
      nohz: Move nohz full init call to tick init
      irq_work: Force raised irq work to run on irq work interrupt
      x86: Build irq work only if local apic support
      x86: Tell irq work about self IPI support
      arm: Tell irq work about self IPI support
      arm64: Tell irq work about self IPI support
      nohz: Consolidate nohz full init code
      nohz: nohz full depends on irq work self IPI support


 arch/arm/kernel/smp.c             |  5 +++
 arch/arm64/kernel/smp.c           |  5 +++
 arch/x86/Kconfig                  |  4 +++
 arch/x86/include/asm/entry_arch.h |  2 +-
 arch/x86/kernel/Makefile          |  2 +-
 arch/x86/kernel/entry_64.S        |  2 +-
 arch/x86/kernel/irq_work.c        |  7 +++--
 arch/x86/kernel/irqinit.c         |  2 +-
 include/linux/irq_work.h          |  4 +++
 include/linux/tick.h              |  9 +-----
 init/main.c                       |  2 +-
 kernel/irq_work.c                 | 21 ++++++++++++-
 kernel/time/tick-common.c         |  1 +
 kernel/time/tick-internal.h       |  7 +++++
 kernel/time/tick-sched.c          | 66 ++++++++++++++++++++++++++++-----------
 kernel/time/timer.c               |  2 +-
 16 files changed, 105 insertions(+), 36 deletions(-)
