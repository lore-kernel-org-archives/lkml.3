Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3KKEYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 23:24:54 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:45765 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3KKEYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 23:24:47 -0500
Message-ID: <52805BFF.2040809@synopsys.com>
Date: Mon, 11 Nov 2013 09:54:31 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, chen Gang <gang.chen@asianux.com>,
        Christoph Lameter <cl@linux.com>, Jiang Liu <liuj97@gmail.com>,
        Noam Camus <noamc@ezchip.com>
Subject: [GIT PULL] ARC updates for 3.13 rc1
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

First batch of ARC changes for 3.13-rc1. A bunch of other fixes need some other
bits to be merged hence will follow towards end of week.

Please Full

Thx,
-Vineet
---------------------->
The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-v3.13-rc1-part1

for you to fetch changes up to 737d5b980be82f722153d8104f7949e4204c5911:

  ARC: [plat-arcfpga] defconfig update (2013-11-07 14:34:32 +0530)

----------------------------------------------------------------
ARC changes for 3.13

* Towards a working SMP setup (ASID allocation, TLB Flush,...)
* Support for TRACE_IRQFLAGS, LOCKDEP
* cacheflush backend consolidation for I/D
* Lots of allmodconfig fixlets from Chen
* Other improvements/fixes

----------------------------------------------------------------
Chen Gang (6):
      arc: kgdb: add default implementation for kgdb_roundup_cpus()
      arc: remove '__init' for setup_processor() and arc_init_IRQ()
      arc: remove '__init' for first_lines_of_secondary()
      arc: remove '__init' for get_hw_config_num_irq()
      arc: export symbol for save_stack_trace() in stacktrace.c
      arc: export symbol for pm_power_off in reset.c

Christoph Lameter (1):
      arc: Replace __get_cpu_var uses

Jiang Liu (1):
      smp, ARC: kill SMP single function call interrupt

Noam Camus (1):
      ARC: [SMP] enlarge possible NR_CPUS

Vineet Gupta (16):
      ARC: Annotate some functions as static
      ARC: use __weak instead of __attribute__((weak))
      ARC: cacheflush refactor #1: push aux reg ascertaining into leaf routine
      ARC: cacheflush refactor #2: I and D caches lines to have same size
      ARC: cacheflush refactor #3: Unify the {d,i}cache flush leaf helpers
      ARC: cacheflush optim - PTAG can be loop invariant if V-P is const
      ARC: Change calling convention of do_page_fault()
      ARC: Reduce #ifdef'ery for unaligned access emulation
      ARC: Reset the value of Interrupt Priority Register
      ARC: Add support for irqflags tracing and lockdep
      ARC: Fix bogus gcc warning and micro-optimise TLB iteration loop
      ARC: [SMP] ASID allocation
      ARC: [SMP] TLB flush
      ARC: [SMP] Fix build failures for large NR_CPUS
      ARC: [SMP] Disallow RTSC
      ARC: [plat-arcfpga] defconfig update

 arch/arc/Kconfig                   |  16 ++--
 arch/arc/configs/fpga_defconfig    |   3 +
 arch/arc/include/asm/cache.h       |   8 +-
 arch/arc/include/asm/irq.h         |   4 +-
 arch/arc/include/asm/irqflags.h    |  22 ++++++
 arch/arc/include/asm/mmu.h         |   2 +-
 arch/arc/include/asm/mmu_context.h |  61 +++++++++++----
 arch/arc/include/asm/setup.h       |   2 +-
 arch/arc/include/asm/smp.h         |   2 +-
 arch/arc/include/asm/tlbflush.h    |  11 ++-
 arch/arc/include/asm/unaligned.h   |   3 +-
 arch/arc/kernel/ctx_sw.c           |  13 +++-
 arch/arc/kernel/ctx_sw_asm.S       |  11 ++-
 arch/arc/kernel/entry.S            |  24 +++---
 arch/arc/kernel/head.S             |   2 +-
 arch/arc/kernel/irq.c              |  12 ++-
 arch/arc/kernel/kgdb.c             |  12 +++
 arch/arc/kernel/kprobes.c          |   6 +-
 arch/arc/kernel/reset.c            |   1 +
 arch/arc/kernel/setup.c            |  11 ++-
 arch/arc/kernel/smp.c              |  10 +--
 arch/arc/kernel/stacktrace.c       |   5 +-
 arch/arc/kernel/time.c             |  11 +--
 arch/arc/kernel/traps.c            |   3 +-
 arch/arc/mm/cache_arc700.c         | 155 ++++++++++++++++---------------------
 arch/arc/mm/fault.c                |   2 +-
 arch/arc/mm/tlb.c                  |  91 ++++++++++++++++++++--
 arch/arc/mm/tlbex.S                |   4 +-
 28 files changed, 326 insertions(+), 181 deletions(-)
