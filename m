Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBWVkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:52179 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaBWVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:39:59 -0500
Message-Id: <20140223212703.511977310@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 00/26] genirq: Another round of tree wide cleanups
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the last tree wide sweep a serious amount of braindamage,
blatant abuse and serious trainwrecks of the generic irq subsystem has
found its way into mainline.

The top score on the shitlist definitely gets this gem:

    #include "../../../kernel/irq/settings.h"

tightly followed by the HYpedPERVersity irq handling.

The series contains the following cleanups:

    - Rewrite abusive code written by incomptetent ...

    - Replace open coded constructs by the proper core functions.

    - Replace common patterns by a core implementation

This adds a few functions to the core code, which might be not
necessary at all, but I'm not masochistic enough to try to dechipher
the undocumented mess of Xen and HyperV.

The releavant patches have a Not-Yet-SOB tag and might be dropped if
the maintainers of the code in question can't come up with reasonable
explanations why they are necessary at all.

Thanks,

	tglx
---
 arch/arm/mach-imx/pm-imx6q.c           |    7 +-
 arch/arm/mach-mmp/pm-mmp2.c            |   16 -----
 arch/arm/mach-mmp/pm-pxa910.c          |   20 +-----
 arch/arm/mach-omap1/ams-delta-fiq.c    |    7 --
 arch/blackfin/Kconfig                  |    1 
 arch/blackfin/kernel/irqchip.c         |   36 ++----------
 arch/ia64/kernel/irq_ia64.c            |   10 +--
 arch/metag/kernel/irq.c                |   20 +-----
 arch/mips/kernel/smtc.c                |    2 
 arch/mips/sgi-ip22/ip22-int.c          |    2 
 arch/mips/sgi-ip22/ip22-time.c         |    2 
 arch/mips/sibyte/bcm1480/smp.c         |    2 
 arch/mips/sibyte/sb1250/smp.c          |    2 
 arch/mn10300/kernel/mn10300-watchdog.c |    2 
 arch/powerpc/kernel/eeh_driver.c       |   26 +++++++-
 arch/powerpc/kernel/irq.c              |    8 --
 arch/powerpc/sysdev/ehv_pic.c          |   10 ---
 arch/sh/kernel/irq.c                   |   16 -----
 arch/sparc/kernel/time_64.c            |    2 
 arch/x86/include/asm/hardirq.h         |    3 +
 arch/x86/include/asm/mshyperv.h        |    4 +
 arch/x86/kernel/cpu/mshyperv.c         |   97 ++++++++++++++++++++-------------
 arch/x86/kernel/irq.c                  |    6 ++
 arch/x86/xen/spinlock.c                |    2 
 arch/xtensa/kernel/irq.c               |   20 +-----
 drivers/hv/vmbus_drv.c                 |   39 +------------
 drivers/pci/host/pcie-designware.c     |    4 -
 drivers/s390/cio/cio.c                 |    5 -
 drivers/xen/events/events_2l.c         |   15 +----
 drivers/xen/events/events_base.c       |   27 ++-------
 drivers/xen/events/events_fifo.c       |    8 --
 include/linux/irq.h                    |    8 ++
 include/linux/kernel_stat.h            |   12 ++--
 kernel/irq/chip.c                      |   15 +++++
 kernel/irq/irqdesc.c                   |   16 +++++
 kernel/irq/manage.c                    |    6 +-
 36 files changed, 204 insertions(+), 274 deletions(-)




