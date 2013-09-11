Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3IKQIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:08:05 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59272 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3IKQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:08:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 00/25] simplify generic cross CPU function call implementation
Date: Thu, 12 Sep 2013 00:07:04 +0800
Message-Id: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

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

Jiang Liu (25):
  Revert smp: Fix SMP function call empty cpu mask race
  smp, alpha: kill SMP single function call interrupt
  smp, ARC: kill SMP single function call interrupt
  smp, ARM: kill SMP single function call interrupt
  smp, ARM64: kill SMP single function call interrupt
  smp, blackfin: kill SMP single function call interrupt
  smp, hexagon: kill SMP single function call interrupt
  smp, IA64: kill SMP single function call interrupt
  smp, m32r: kill SMP single function call interrupt
  smp, metag: kill SMP single function call interrupt
  smp, mips: kill redundant call of
    generic_smp_call_function_single_interrupt()
  smp, mn10300: kill SMP single function call interrupt
  smp, mn10300: enable arch_send_call_function_ipi_mask()
  smp, parisc: kill SMP single function call interrupt
  smp, ppc: kill SMP single function call interrupt
  smp, s390: prepare for killing
    generic_smp_call_function_single_interrupt()
  smp, sh: kill SMP single function call interrupt
  smp, sparc64: kill SMP single function call interrupt
  smp, sparc: kill SMP single function call interrupt
  smp, tile: kill SMP single function call interrupt
  smp, tile: kill SMP single function call interrupt
  smp, x86: kill SMP single function call interrupt
  smp: cleanup unsued generic_smp_call_function_single_interrupt()
  smp: rename call_single_queue as call_function_queue
  SMP, trivial: remove unused code from smp_boot.h

 arch/alpha/kernel/smp.c                  |  9 +-------
 arch/arc/kernel/smp.c                    |  7 +-----
 arch/arm/include/asm/hardirq.h           |  2 +-
 arch/arm/kernel/smp.c                    | 10 +--------
 arch/arm64/include/asm/hardirq.h         |  2 +-
 arch/arm64/kernel/smp.c                  | 10 +--------
 arch/blackfin/mach-common/smp.c          |  7 +-----
 arch/hexagon/include/asm/smp.h           |  1 -
 arch/hexagon/kernel/smp.c                |  6 +-----
 arch/ia64/kernel/smp.c                   |  8 ++-----
 arch/m32r/include/asm/smp.h              |  1 -
 arch/m32r/kernel/smp.c                   |  9 +-------
 arch/m32r/kernel/traps.c                 |  3 +--
 arch/metag/include/asm/smp.h             |  2 --
 arch/metag/kernel/smp.c                  |  6 +-----
 arch/mips/kernel/smp.c                   |  1 -
 arch/mn10300/include/asm/smp.h           |  2 +-
 arch/mn10300/kernel/smp.c                | 19 ++++++++--------
 arch/parisc/kernel/smp.c                 |  8 +------
 arch/powerpc/include/asm/smp.h           |  3 +--
 arch/powerpc/kernel/smp.c                | 12 +----------
 arch/s390/kernel/smp.c                   | 10 ++++-----
 arch/sh/include/asm/smp.h                |  1 -
 arch/sh/kernel/smp.c                     |  5 +----
 arch/sparc/include/asm/pil.h             |  5 ++---
 arch/sparc/include/asm/smp_32.h          |  4 +---
 arch/sparc/kernel/entry.S                | 10 ++-------
 arch/sparc/kernel/leon_smp.c             | 31 ++++++--------------------
 arch/sparc/kernel/smp_32.c               | 14 ++----------
 arch/sparc/kernel/smp_64.c               | 11 +---------
 arch/sparc/kernel/sun4d_smp.c            | 31 ++++++--------------------
 arch/sparc/kernel/sun4m_smp.c            | 11 ++--------
 arch/sparc/kernel/ttable_64.S            | 12 ++++-------
 arch/sparc/mm/ultra.S                    |  5 -----
 arch/tile/include/asm/smp.h              |  7 +++---
 arch/tile/kernel/smp.c                   |  6 +-----
 arch/x86/include/asm/entry_arch.h        |  1 -
 arch/x86/include/asm/hw_irq.h            |  3 ---
 arch/x86/include/asm/irq_vectors.h       |  7 +++---
 arch/x86/include/asm/trace/irq_vectors.h |  6 ------
 arch/x86/include/asm/xen/events.h        |  1 -
 arch/x86/kernel/entry_64.S               |  2 --
 arch/x86/kernel/irqinit.c                |  4 ----
 arch/x86/kernel/smp.c                    | 24 +--------------------
 arch/x86/xen/smp.c                       | 37 +-------------------------------
 include/linux/smp.h                      |  4 +---
 include/linux/smpboot.h                  |  1 -
 kernel/smp.c                             | 36 +++++++++++--------------------
 48 files changed, 82 insertions(+), 335 deletions(-)

-- 
1.8.1.2

