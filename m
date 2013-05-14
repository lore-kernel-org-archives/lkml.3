Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3ENJ6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:58:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:38927 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab3ENJ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:58:10 -0400
Message-ID: <1368525476.31689.29.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 14 May 2013 19:57:56 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some more powerpc fixes to apply to 3.10. This is mostly bug
fixes (some of them regressions, some of them I deemed worth merging
now) along with some patches from Li Zhong hooking up the new
context tracking stuff (for the new full NO_HZ)

Cheers,
Ben.

The following changes since commit 5737789c8340620d7b542d1d4e9b197de8eb2801:

  powerpc: Make hard_irq_disable() do the right thing vs. irq tracing (2013-05-07 17:13:57 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to e34166ad63eac4d0fa98b4c4ed7a98202a18faef:

  powerpc: Set show_unhandled_signals to 1 by default (2013-05-14 18:01:04 +1000)

----------------------------------------------------------------
Alexander Gordeev (1):
      powerpc: Fix irq_set_affinity() return values

Alistair Popple (1):
      powerpc: Add an in memory udbg console

Aneesh Kumar K.V (2):
      powerpc/mm: Use the correct mask value when looking at pgtable address
      powerpc: Fix build errors STRICT_MM_TYPECHECKS

Anton Blanchard (1):
      powerpc/kexec: Fix kexec when using VMX optimised memcpy

Benjamin Herrenschmidt (5):
      powerpc/powernv: Properly drop characters if console is closed
      powerpc/powernv: Improve kexec reliability
      powerpc/powernv: Detect OPAL v3 API version
      powerpc/powernv: Fix starting of secondary CPUs on OPALv2 and v3
      powerpc: Set show_unhandled_signals to 1 by default

David Woodhouse (1):
      powerpc: Provide __bswapdi2

Li Zhong (6):
      powerpc: Fix MAX_STACK_TRACE_ENTRIES too low warning again
      powerpc: Syscall hooks for context tracking subsystem
      powerpc: Exception hooks for context tracking subsystem
      powerpc: Exit user context on notify resume
      powerpc: Use the new schedule_user API on userspace preemption
      powerpc: select HAVE_CONTEXT_TRACKING for pSeries

Michael Ellerman (1):
      powerpc: Make CONFIG_RTAS_PROC depend on CONFIG_PROC_FS

Michael Neuling (3):
      powerpc/perf: Move BHRB code into CONFIG_PPC64 region
      powerpc/pmu: Fix order of interpreting BHRB target entries
      powerpc/perf: Fix setting of "to" addresses for BHRB

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Scott Wood (2):
      powerpc: hard_irq_disable(): Call trace_hardirqs_off after disabling
      powerpc/booke64: Fix kernel hangs at kernel_dbg_exc

Vasant Hegde (1):
      powerpc/rtas_flash: Fix validate_flash buffer overflow issue

 arch/powerpc/Kconfig.debug                  |   23 +++
 arch/powerpc/include/asm/context_tracking.h |   10 +
 arch/powerpc/include/asm/firmware.h         |    4 +-
 arch/powerpc/include/asm/hw_irq.h           |    5 +-
 arch/powerpc/include/asm/opal.h             |    5 +-
 arch/powerpc/include/asm/pgalloc-64.h       |    2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h   |    2 +-
 arch/powerpc/include/asm/rtas.h             |    2 +
 arch/powerpc/include/asm/thread_info.h      |    7 +-
 arch/powerpc/include/asm/udbg.h             |    1 +
 arch/powerpc/kernel/entry_32.S              |    2 -
 arch/powerpc/kernel/entry_64.S              |    5 +-
 arch/powerpc/kernel/exceptions-64e.S        |    8 +-
 arch/powerpc/kernel/machine_kexec_64.c      |    4 +
 arch/powerpc/kernel/misc_32.S               |   11 ++
 arch/powerpc/kernel/misc_64.S               |   11 ++
 arch/powerpc/kernel/pci-common.c            |    5 +-
 arch/powerpc/kernel/ppc_ksyms.c             |    3 +-
 arch/powerpc/kernel/process.c               |    8 +
 arch/powerpc/kernel/ptrace.c                |    5 +
 arch/powerpc/kernel/rtas.c                  |  113 +++++++++++
 arch/powerpc/kernel/rtas_flash.c            |   10 +-
 arch/powerpc/kernel/signal.c                |    7 +-
 arch/powerpc/kernel/traps.c                 |   80 +++++---
 arch/powerpc/kernel/udbg.c                  |    3 +
 arch/powerpc/mm/fault.c                     |   41 ++--
 arch/powerpc/mm/hash_utils_64.c             |   36 +++-
 arch/powerpc/mm/init_64.c                   |    3 +-
 arch/powerpc/perf/core-book3s.c             |  280 +++++++++++++++------------
 arch/powerpc/platforms/Kconfig              |    2 +-
 arch/powerpc/platforms/powernv/opal.c       |   30 ++-
 arch/powerpc/platforms/powernv/pci-ioda.c   |    9 +
 arch/powerpc/platforms/powernv/pci.c        |   12 ++
 arch/powerpc/platforms/powernv/pci.h        |    2 +
 arch/powerpc/platforms/powernv/powernv.h    |    2 +
 arch/powerpc/platforms/powernv/setup.c      |   16 +-
 arch/powerpc/platforms/powernv/smp.c        |   62 +++++-
 arch/powerpc/platforms/pseries/Kconfig      |    1 +
 arch/powerpc/platforms/pseries/suspend.c    |   22 +++
 arch/powerpc/platforms/wsp/ics.c            |    2 +-
 arch/powerpc/sysdev/Makefile                |    2 +
 arch/powerpc/sysdev/ehv_pic.c               |    2 +-
 arch/powerpc/sysdev/mpic.c                  |    2 +-
 arch/powerpc/sysdev/udbg_memcons.c          |  105 ++++++++++
 arch/powerpc/sysdev/xics/ics-opal.c         |    2 +-
 45 files changed, 763 insertions(+), 206 deletions(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h
 create mode 100644 arch/powerpc/sysdev/udbg_memcons.c


