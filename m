Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbbAWFeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:44049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbAWFeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444041798"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [Resend Patch v4 00/16] Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:39 +0800
Message-Id: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set has been hanging around for more than one year since v3.
Resend for collecting more Acks targetting v3.20 merging window.
Patches for ARC, Hexagon, Metag, MIPS and PARISC has been merged.
Gained Acks for Tile, Xen, ARM64 and S390.

Since commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use
logic similar to smp_call_function_single()", single and multiple
(mask version) cross CPU function calls are handled in the same way,
and generic_smp_call_function_interrupt() becomes an aliases of
generic_smp_call_function_single_interrupt(), so only one interrupt
is needed for arch code to support generic SMP function call interfaces.
This patch series simplifies arch code by killing the redundant
interrupt for cross CPU function calls.

We choose to keep generic_smp_call_function_interrupt() instead of
generic_smp_call_function_single_interrupt() because the former is
more generic.

Jiang Liu (16):
  smp, alpha: Kill SMP single function call interrupt
  smp, ARM: Kill SMP single function call interrupt
  smp, ARM64: Kill SMP single function call interrupt
  smp, IA64: Kill SMP single function call interrupt
  smp, m32r: Kill SMP single function call interrupt
  smp, mn10300: Kill SMP single function call interrupt
  smp, mn10300: Enable arch_send_call_function_ipi_mask()
  smp, sh: Kill SMP single function call interrupt
  smp, sparc64: Kill SMP single function call interrupt
  smp, sparc: Kill SMP single function call interrupt
  smp, x86, xen: Kill SMP single function call interrupt
  smp, x86: Kill SMP single function call interrupt
  smp, tile: Kill SMP single function call interrupt
  smp, s390: Kill SMP single function call interrupt
  smp: Cleanup unsued generic_smp_call_function_single_interrupt()
  smp, trivial: Remove unused function prototype from smp_boot.h

 arch/alpha/kernel/smp.c                  |    8 +------
 arch/arm/include/asm/hardirq.h           |    2 +-
 arch/arm/kernel/smp.c                    |   10 +-------
 arch/arm64/include/asm/hardirq.h         |    2 +-
 arch/arm64/kernel/smp.c                  |   10 +-------
 arch/ia64/kernel/smp.c                   |    8 ++-----
 arch/m32r/include/asm/smp.h              |    1 -
 arch/m32r/kernel/smp.c                   |    9 +-------
 arch/m32r/kernel/traps.c                 |    3 +--
 arch/mn10300/include/asm/smp.h           |    2 +-
 arch/mn10300/kernel/smp.c                |   19 ++++++++-------
 arch/s390/kernel/smp.c                   |   10 ++++----
 arch/sh/include/asm/smp.h                |    1 -
 arch/sh/kernel/smp.c                     |    5 +---
 arch/sparc/include/asm/pil.h             |    5 ++--
 arch/sparc/include/asm/smp_32.h          |    4 +---
 arch/sparc/kernel/entry.S                |   10 ++------
 arch/sparc/kernel/leon_smp.c             |   31 ++++++-------------------
 arch/sparc/kernel/smp_32.c               |   14 ++---------
 arch/sparc/kernel/smp_64.c               |   13 +----------
 arch/sparc/kernel/sun4d_smp.c            |   31 ++++++-------------------
 arch/sparc/kernel/sun4m_smp.c            |   11 ++-------
 arch/sparc/kernel/ttable_64.S            |   12 ++++------
 arch/sparc/mm/ultra.S                    |    5 ----
 arch/tile/include/asm/smp.h              |    7 +++---
 arch/tile/kernel/smp.c                   |    6 +----
 arch/x86/include/asm/entry_arch.h        |    1 -
 arch/x86/include/asm/hw_irq.h            |    3 ---
 arch/x86/include/asm/irq_vectors.h       |    7 +++---
 arch/x86/include/asm/trace/irq_vectors.h |    6 -----
 arch/x86/include/asm/xen/events.h        |    1 -
 arch/x86/kernel/entry_64.S               |    2 --
 arch/x86/kernel/irqinit.c                |    4 ----
 arch/x86/kernel/smp.c                    |   24 +------------------
 arch/x86/xen/smp.c                       |   37 +-----------------------------
 include/linux/smp.h                      |    4 +---
 include/linux/smpboot.h                  |    1 -
 kernel/smp.c                             |    4 ++--
 38 files changed, 65 insertions(+), 268 deletions(-)

-- 
1.7.10.4

