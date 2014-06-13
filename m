Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaFMA4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:56:14 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46587 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaFMA4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:56:12 -0400
Message-ID: <1402620965.14780.104.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jun 2014 10:56:05 +1000
In-Reply-To: <1402620918.14780.102.camel@pasglop>
References: <1402620918.14780.102.camel@pasglop>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061300-0260-0000-0000-000005212E60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 10:55 +1000, Benjamin Herrenschmidt wrote:
> Hi Linus !

Sending a copy via IBM just in case gmail has an issue with pull
requests :-) If it goes through fine I'll stop doing it.

Cheers,
Ben.

> Here are the remaining bits I was mentioning earlier. Mostly bug fixes
> and new selftests from Michael (yay !). He also removed the WSP platform
> and A2 core support which were dead before release, so less clutter.
> 
> One little "feature" I snuck in is the doorbell IPI support for
> non-virtualized P8 which speeds up IPIs significantly between threads
> of a core.
> 
> Cheers,
> Ben.
> 
> The following changes since commit dfb945473ae8528fd885607b6fa843c676745e0c:
> 
>   Merge git://www.linux-watchdog.org/linux-watchdog (2014-06-10 19:16:36 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next
> 
> for you to fetch changes up to ad718622ab6d500c870772b1b8dda46fa2195e6d:
> 
>   powerpc/book3s: Fix some ABIv2 issues in machine check code (2014-06-12 09:41:33 +1000)
> 
> ----------------------------------------------------------------
> Anton Blanchard (4):
>       powernv: Fix permissions on sysparam sysfs entries
>       crypto/nx: disable NX on little endian builds
>       powerpc/powernv: Reduce panic timeout from 180s to 10s
>       powerpc/book3s: Fix some ABIv2 issues in machine check code
> 
> Benjamin Herrenschmidt (1):
>       powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support
> 
> Dan Carpenter (2):
>       powerpc/cpm: Remove duplicate FCC_GFMR_TTX define
>       powerpc/spufs: Remove duplicate SPUFS_CNTL_MAP_SIZE define
> 
> Gavin Shan (5):
>       powerpc/eeh: Clear frozen state for child PE
>       powerpc/eeh: Report frozen parent PE prior to child PE
>       powerpc/powernv: Don't escalate non-existing frozen PE
>       powerpc/powernv: Fix killed EEH event
>       powerpc/eeh: Dump PE location code
> 
> Guo Chao (1):
>       powerpc/powernv: Fix endianness problems in EEH
> 
> Joel Stanley (1):
>       powerpc/powernv: Fix reading of OPAL msglog
> 
> Kees Cook (1):
>       powerpc/xmon: avoid format string leaking to printk
> 
> Mahesh Salgaonkar (4):
>       powerpc/book3s: Fix machine check handling for unhandled errors
>       powerpc/book3s: Add stack overflow check in machine check handler.
>       powerpc/book3s: Increment the mce counter during machine_check_early call.
>       powerpc/book3s: Fix guest MC delivery mechanism to avoid soft lockups in guest.
> 
> Michael Ellerman (6):
>       powerpc: Remove platforms/wsp and associated pieces
>       powerpc/perf: Ensure all EBB register state is cleared on fork()
>       selftests/powerpc: Fix instruction loop for ABIv2 (LE)
>       selftests/powerpc: Put the test in a separate process group
>       selftests/powerpc: Add support for skipping tests
>       selftests/powerpc: Add tests of PMU EBBs
> 
> Michael Neuling (3):
>       powerpc: Don't setup CPUs with bad status
>       powerpc/cpuidle: Only clear LPCR decrementer wakeup bit on fast sleep entry
>       powerpc/powernv: Enable POWER8 doorbell IPIs
> 
> Paul Bolle (3):
>       powerpc: Remove check for CONFIG_SERIAL_TEXT_DEBUG
>       powerpc: fix typo 'CONFIG_PPC_CPU'
>       powerpc: fix typo 'CONFIG_PMAC'
> 
> Sam bobroff (1):
>       powerpc: Correct DSCR during TM context switch
> 
> Shreyas B. Prabhu (2):
>       powerpc/powernv: Include asm/smp.h to fix UP build failure
>       powerpc/powernv : Disable subcore for UP configs
> 
>  arch/powerpc/Kconfig.debug                         |    5 -
>  arch/powerpc/configs/chroma_defconfig              |  307 ------
>  arch/powerpc/include/asm/cpm2.h                    |    1 -
>  arch/powerpc/include/asm/eeh.h                     |    1 +
>  arch/powerpc/include/asm/eeh_event.h               |    2 +-
>  arch/powerpc/include/asm/mmu-book3e.h              |    4 -
>  arch/powerpc/include/asm/opal.h                    |  102 +-
>  arch/powerpc/include/asm/reg_a2.h                  |    9 -
>  arch/powerpc/include/asm/switch_to.h               |    8 +-
>  arch/powerpc/include/asm/wsp.h                     |   14 -
>  arch/powerpc/include/uapi/asm/cputable.h           |    1 +
>  arch/powerpc/kernel/Makefile                       |    1 -
>  arch/powerpc/kernel/cpu_setup_a2.S                 |  120 ---
>  arch/powerpc/kernel/cpu_setup_power.S              |    2 +
>  arch/powerpc/kernel/cputable.c                     |   41 +-
>  arch/powerpc/kernel/eeh.c                          |   38 +-
>  arch/powerpc/kernel/eeh_driver.c                   |   24 +-
>  arch/powerpc/kernel/eeh_event.c                    |   21 +-
>  arch/powerpc/kernel/eeh_pe.c                       |   60 ++
>  arch/powerpc/kernel/entry_64.S                     |    6 -
>  arch/powerpc/kernel/exceptions-64e.S               |   16 -
>  arch/powerpc/kernel/exceptions-64s.S               |   64 +-
>  arch/powerpc/kernel/head_40x.S                     |   19 -
>  arch/powerpc/kernel/process.c                      |    8 +-
>  arch/powerpc/kernel/setup-common.c                 |    2 +-
>  arch/powerpc/kernel/time.c                         |    2 +-
>  arch/powerpc/kernel/traps.c                        |    2 +
>  arch/powerpc/kernel/udbg.c                         |    2 -
>  arch/powerpc/kernel/udbg_16550.c                   |   11 -
>  arch/powerpc/kvm/book3s_hv_ras.c                   |   15 +-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   19 +-
>  arch/powerpc/lib/sstep.c                           |    2 +-
>  arch/powerpc/platforms/Kconfig                     |    1 -
>  arch/powerpc/platforms/Kconfig.cputype             |    6 +-
>  arch/powerpc/platforms/Makefile                    |    1 -
>  arch/powerpc/platforms/cell/spufs/spufs.h          |    1 -
>  arch/powerpc/platforms/powernv/Kconfig             |    1 +
>  arch/powerpc/platforms/powernv/Makefile            |    4 +-
>  arch/powerpc/platforms/powernv/eeh-ioda.c          |  109 +-
>  arch/powerpc/platforms/powernv/opal-msglog.c       |    6 +-
>  arch/powerpc/platforms/powernv/opal-sysparam.c     |    4 +-
>  arch/powerpc/platforms/powernv/pci.c               |   81 +-
>  arch/powerpc/platforms/powernv/setup.c             |    3 +
>  arch/powerpc/platforms/powernv/smp.c               |    6 +
>  arch/powerpc/platforms/pseries/Kconfig             |    1 +
>  arch/powerpc/platforms/wsp/Kconfig                 |   30 -
>  arch/powerpc/platforms/wsp/Makefile                |   10 -
>  arch/powerpc/platforms/wsp/chroma.c                |   56 -
>  arch/powerpc/platforms/wsp/h8.c                    |  135 ---
>  arch/powerpc/platforms/wsp/ics.c                   |  762 -------------
>  arch/powerpc/platforms/wsp/ics.h                   |   25 -
>  arch/powerpc/platforms/wsp/msi.c                   |  102 --
>  arch/powerpc/platforms/wsp/msi.h                   |   19 -
>  arch/powerpc/platforms/wsp/opb_pic.c               |  321 ------
>  arch/powerpc/platforms/wsp/psr2.c                  |   67 --
>  arch/powerpc/platforms/wsp/scom_smp.c              |  435 --------
>  arch/powerpc/platforms/wsp/scom_wsp.c              |   82 --
>  arch/powerpc/platforms/wsp/setup.c                 |   36 -
>  arch/powerpc/platforms/wsp/smp.c                   |   88 --
>  arch/powerpc/platforms/wsp/wsp.c                   |  117 --
>  arch/powerpc/platforms/wsp/wsp.h                   |   29 -
>  arch/powerpc/platforms/wsp/wsp_pci.c               | 1134 --------------------
>  arch/powerpc/platforms/wsp/wsp_pci.h               |  268 -----
>  arch/powerpc/sysdev/xics/icp-native.c              |    9 +-
>  arch/powerpc/xmon/nonstdio.c                       |    2 +-
>  drivers/cpuidle/cpuidle-powernv.c                  |    8 +-
>  drivers/crypto/Kconfig                             |    2 +-
>  tools/testing/selftests/powerpc/Makefile           |    2 +-
>  tools/testing/selftests/powerpc/harness.c          |   15 +-
>  tools/testing/selftests/powerpc/pmu/Makefile       |   26 +-
>  tools/testing/selftests/powerpc/pmu/ebb/Makefile   |   32 +
>  .../powerpc/pmu/ebb/back_to_back_ebbs_test.c       |  106 ++
>  .../powerpc/pmu/ebb/close_clears_pmcc_test.c       |   59 +
>  .../powerpc/pmu/ebb/cpu_event_pinned_vs_ebb_test.c |   93 ++
>  .../powerpc/pmu/ebb/cpu_event_vs_ebb_test.c        |   89 ++
>  .../selftests/powerpc/pmu/ebb/cycles_test.c        |   58 +
>  .../powerpc/pmu/ebb/cycles_with_freeze_test.c      |  117 ++
>  tools/testing/selftests/powerpc/pmu/ebb/ebb.c      |  727 +++++++++++++
>  tools/testing/selftests/powerpc/pmu/ebb/ebb.h      |   78 ++
>  .../selftests/powerpc/pmu/ebb/ebb_handler.S        |  365 +++++++
>  .../selftests/powerpc/pmu/ebb/ebb_on_child_test.c  |   86 ++
>  .../powerpc/pmu/ebb/ebb_on_willing_child_test.c    |   92 ++
>  .../powerpc/pmu/ebb/ebb_vs_cpu_event_test.c        |   86 ++
>  .../powerpc/pmu/ebb/event_attributes_test.c        |  131 +++
>  .../powerpc/pmu/ebb/fixed_instruction_loop.S       |   43 +
>  .../selftests/powerpc/pmu/ebb/fork_cleanup_test.c  |   79 ++
>  .../powerpc/pmu/ebb/instruction_count_test.c       |  164 +++
>  .../powerpc/pmu/ebb/lost_exception_test.c          |  100 ++
>  .../selftests/powerpc/pmu/ebb/multi_counter_test.c |   91 ++
>  .../powerpc/pmu/ebb/multi_ebb_procs_test.c         |  109 ++
>  .../selftests/powerpc/pmu/ebb/no_handler_test.c    |   61 ++
>  .../selftests/powerpc/pmu/ebb/pmae_handling_test.c |  106 ++
>  .../powerpc/pmu/ebb/pmc56_overflow_test.c          |   93 ++
>  tools/testing/selftests/powerpc/pmu/ebb/reg.h      |   49 +
>  .../selftests/powerpc/pmu/ebb/reg_access_test.c    |   39 +
>  .../pmu/ebb/task_event_pinned_vs_ebb_test.c        |   91 ++
>  .../powerpc/pmu/ebb/task_event_vs_ebb_test.c       |   83 ++
>  tools/testing/selftests/powerpc/pmu/ebb/trace.c    |  300 ++++++
>  tools/testing/selftests/powerpc/pmu/ebb/trace.h    |   41 +
>  tools/testing/selftests/powerpc/pmu/event.c        |   26 +
>  tools/testing/selftests/powerpc/pmu/event.h        |    4 +
>  tools/testing/selftests/powerpc/pmu/lib.c          |  252 +++++
>  tools/testing/selftests/powerpc/pmu/lib.h          |   41 +
>  tools/testing/selftests/powerpc/pmu/loop.S         |   73 +-
>  tools/testing/selftests/powerpc/subunit.h          |    5 +
>  tools/testing/selftests/powerpc/tm/Makefile        |   15 +
>  .../testing/selftests/powerpc/tm/tm-resched-dscr.c |   90 ++
>  tools/testing/selftests/powerpc/utils.h            |   12 +
>  108 files changed, 4514 insertions(+), 4505 deletions(-)
>  delete mode 100644 arch/powerpc/configs/chroma_defconfig
>  delete mode 100644 arch/powerpc/include/asm/wsp.h
>  delete mode 100644 arch/powerpc/kernel/cpu_setup_a2.S
>  delete mode 100644 arch/powerpc/platforms/wsp/Kconfig
>  delete mode 100644 arch/powerpc/platforms/wsp/Makefile
>  delete mode 100644 arch/powerpc/platforms/wsp/chroma.c
>  delete mode 100644 arch/powerpc/platforms/wsp/h8.c
>  delete mode 100644 arch/powerpc/platforms/wsp/ics.c
>  delete mode 100644 arch/powerpc/platforms/wsp/ics.h
>  delete mode 100644 arch/powerpc/platforms/wsp/msi.c
>  delete mode 100644 arch/powerpc/platforms/wsp/msi.h
>  delete mode 100644 arch/powerpc/platforms/wsp/opb_pic.c
>  delete mode 100644 arch/powerpc/platforms/wsp/psr2.c
>  delete mode 100644 arch/powerpc/platforms/wsp/scom_smp.c
>  delete mode 100644 arch/powerpc/platforms/wsp/scom_wsp.c
>  delete mode 100644 arch/powerpc/platforms/wsp/setup.c
>  delete mode 100644 arch/powerpc/platforms/wsp/smp.c
>  delete mode 100644 arch/powerpc/platforms/wsp/wsp.c
>  delete mode 100644 arch/powerpc/platforms/wsp/wsp.h
>  delete mode 100644 arch/powerpc/platforms/wsp/wsp_pci.c
>  delete mode 100644 arch/powerpc/platforms/wsp/wsp_pci.h
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/Makefile
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/back_to_back_ebbs_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/close_clears_pmcc_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/cpu_event_pinned_vs_ebb_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/cpu_event_vs_ebb_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/cycles_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/cycles_with_freeze_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb.h
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb_handler.S
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb_on_child_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb_on_willing_child_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/ebb_vs_cpu_event_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/event_attributes_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/fixed_instruction_loop.S
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/instruction_count_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/lost_exception_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/multi_counter_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/multi_ebb_procs_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/pmae_handling_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/pmc56_overflow_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/reg.h
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/reg_access_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/task_event_pinned_vs_ebb_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/task_event_vs_ebb_test.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/trace.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/trace.h
>  create mode 100644 tools/testing/selftests/powerpc/pmu/lib.c
>  create mode 100644 tools/testing/selftests/powerpc/pmu/lib.h
>  create mode 100644 tools/testing/selftests/powerpc/tm/Makefile
>  create mode 100644 tools/testing/selftests/powerpc/tm/tm-resched-dscr.c
> 


