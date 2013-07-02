Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3GBFWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:22:51 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:33199 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3GBFWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:22:50 -0400
Message-ID: <51D26363.2060303@synopsys.com>
Date: Tue, 2 Jul 2013 10:51:39 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [GIT PULL] arch/arc updates for 3.11
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

First batch of ARC changes for 3.11. Please pull.

There's a second bunch to follow next week - which depends on commits on other
trees (irq/net). I'd have preferred the accompanying ARC change via respective
trees, but it didn't workout somehow.

Thx,
-Vineet

--------------->
The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-v3.11-rc1-part1

for you to fetch changes up to baadb8fd0c62540f2ffb2d0f12b8a47c7975562b:

  ARC: warn on improper stack unwind FDE entries (2013-06-27 14:37:59 +0530)

----------------------------------------------------------------
ARC changes for 3.11

Highlights of changes:

-Continuation of ARC MM changes from 3.10 including
   zero page optimization;
   Setting pagecache pages dirty by default;
   Non executable stack by default;
   Reducing dcache flushes for aliasing VIPT config

-Long overdue rework of pt_regs machinery - removing the unused word gutters
 and adding ECR register to baseline (helps cleanup lot of low level code)

-Support for ARC gcc 4.8

-Few other preventive fixes, cosmetics, usage of Kconfig helper..

The diffstat is larger than normal primarily because of arcregs.h header split
as well as beautification of macros in entry.h

----------------------------------------------------------------
Alexey Brodkin (1):
      ARC: make dcache VIPT aliasing support dependant on dcache

Mischa Jonker (1):
      ARC: [plat-arcfpga] Fix build breakage when !CONFIG_ARC_SERIAL

Paul Gortmaker (1):
      arc: delete __cpuinit usage from all arc files

Vineet Gupta (29):
      ARC: Use kconfig helper IS_ENABLED() to get rid of defines.h
      ARC: More code beautification with IS_ENABLED()
      ARC: Disintegrate arcregs.h
      ARC: Reduce Code for ECR printing
      ARC: cache detection code bitrot
      ARC: No-op full icache flush if !CONFIG_ARC_HAS_ICACHE
      ARC: [mm] Zero page optimization
      ARC: [mm] optimise VIPT dcache aliasing 1/x
      ARC: [mm] optimise VIPT dcache aliasing 2/x
      ARC: [mm] Assume pagecache page dirty by default
      ARC: [mm] Make stack/heap Non-executable by default
      ARC: [mm] Remove @write argument to do_page_fault()
      ARC: pt_regs update #0: remove kernel stack canary
      ARC: pt_regs update #1: Align pt_regs end with end of kernel stack page
      ARC: pt_regs update #2: Remove unused gutter at start of pt_regs
      ARC: pt_regs update #3: Remove unused gutter at start of callee_regs
      ARC: Increase readability of entry handlers
      ARC: Entry Handler tweaks: Avoid hardcoded LIMMS for ECR values
      ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption
      ARC: K/U SP saved from one location in stack switching macro
      ARC: pt_regs update #4: r25 saved/restored unconditionally
      ARC: stop using pt_regs->orig_r8
      ARC: pt_regs update #5: Use real ECR for pt_regs->event vs. synth values
      ARC: Remove explicit passing around of ECR
      ARC: Setup Vector Table Base in early boot
      ARC: Adjustments for gcc 4.8
      ARC: [tlb-miss] Extraneous PTE bit testing/setting
      ARC: [tlb-miss] Fix bug with CONFIG_ARC_DBG_TLB_MISS_COUNT
      ARC: warn on improper stack unwind FDE entries

 arch/arc/Kconfig                    |   8 +-
 arch/arc/Makefile                   |  28 +-
 arch/arc/configs/fpga_defconfig     |   2 +-
 arch/arc/configs/nsimosci_defconfig |   2 +-
 arch/arc/configs/tb10x_defconfig    |   2 +-
 arch/arc/include/asm/arcregs.h      | 127 +--------
 arch/arc/include/asm/bug.h          |   5 +-
 arch/arc/include/asm/cache.h        |  26 +-
 arch/arc/include/asm/cacheflush.h   |  13 +-
 arch/arc/include/asm/defines.h      |  56 ----
 arch/arc/include/asm/entry.h        | 521 +++++++++++++++---------------------
 arch/arc/include/asm/irq.h          |   2 +-
 arch/arc/include/asm/irqflags.h     |  20 ++
 arch/arc/include/asm/kgdb.h         |   4 +-
 arch/arc/include/asm/kprobes.h      |   6 +-
 arch/arc/include/asm/mmu.h          |  44 +++
 arch/arc/include/asm/page.h         |   7 +-
 arch/arc/include/asm/pgtable.h      |   6 +
 arch/arc/include/asm/processor.h    |  17 +-
 arch/arc/include/asm/ptrace.h       |  47 ++--
 arch/arc/include/asm/syscall.h      |   5 +-
 arch/arc/include/asm/tlb-mmu1.h     |   4 +-
 arch/arc/include/asm/tlb.h          |  26 --
 arch/arc/include/asm/unaligned.h    |   4 +-
 arch/arc/include/uapi/asm/ptrace.h  |  15 +-
 arch/arc/kernel/asm-offsets.c       |   7 +-
 arch/arc/kernel/ctx_sw.c            |  14 +-
 arch/arc/kernel/entry.S             | 103 +++----
 arch/arc/kernel/head.S              |   2 +
 arch/arc/kernel/irq.c               |  16 +-
 arch/arc/kernel/kgdb.c              |   4 +-
 arch/arc/kernel/kprobes.c           |   5 +-
 arch/arc/kernel/process.c           |   9 +-
 arch/arc/kernel/ptrace.c            |  14 +-
 arch/arc/kernel/setup.c             |  18 +-
 arch/arc/kernel/smp.c               |   4 +-
 arch/arc/kernel/stacktrace.c        |   2 +-
 arch/arc/kernel/time.c              |  17 +-
 arch/arc/kernel/traps.c             |  52 ++--
 arch/arc/kernel/troubleshoot.c      |  31 +--
 arch/arc/kernel/unaligned.c         |   2 +-
 arch/arc/kernel/unwind.c            |   2 +
 arch/arc/kernel/vmlinux.lds.S       |  24 +-
 arch/arc/mm/cache_arc700.c          | 126 +++++----
 arch/arc/mm/fault.c                 |  12 +-
 arch/arc/mm/tlb.c                   |  38 ++-
 arch/arc/mm/tlbex.S                 |  35 +--
 arch/arc/plat-arcfpga/platform.c    |  12 +-
 48 files changed, 670 insertions(+), 876 deletions(-)
 delete mode 100644 arch/arc/include/asm/defines.h
