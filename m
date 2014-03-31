Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaCaHYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:24:09 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36476 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaCaHYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:24:06 -0400
Date: Mon, 31 Mar 2014 09:24:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.15 merge window
Message-ID: <20140331092400.17071766@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033107-4966-0000-0000-000008E66DA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
There are two memory management related changes, the CMMA support for
KVM to avoid swap-in of freed pages and the split page table lock for
the PMD level. These two come with common code changes in mm/.

A fix for the long standing theoretical TLB flush problem, this one
comes with a common code change in kernel/sched/.

Another set of changes is Heikos uaccess work, included is the initial
set of patches with more to come.

And fixes and cleanups as usual.

Dominik Dingel (3):
      s390/mm: fixing comment so that parameter name match
      s390/mm: remove unnecessary parameter from gmap_do_ipte_notify
      s390/mm: remove unecessary parameter from pgste_ipte_notify

Gerald Schaefer (1):
      s390/appldata_os: fix cpu array size calculation

Heiko Carstens (13):
      s390/uaccess: normalize order of parameters of indirect uaccess function calls
      s390/uaccess: get rid of indirect function calls
      s390/uaccess: consistent types
      s390/setup: get rid of MACHINE_HAS_MVCOS machine flag
      s390/uaccess: remove dead kernel parameter 'user_mode='
      s390/uaccess: introduce 'uaccesspt' kernel parameter
      s390/bitops: fix comment
      s390/uaccess: remove copy_from_user_real()
      s390/checksum: remove memset() within csum_partial_copy_from_user()
      s390/compat: remove compat exec domain
      s390/perf: make print_debug_cf() static
      s390: update defconfigs
      s390/smp: limit number of cpus in possible cpu mask

Josh Triplett (1):
      s390: select CONFIG_TTY for use of tty in unconditional keyboard driver

Konstantin Weitz (2):
      mm: add support for discard of unused ptes
      s390/kvm: support collaborative memory management

Martin Schwidefsky (8):
      sched/mm: call finish_arch_post_lock_switch in idle_task_exit and use_mm
      s390/mm,tlb: race of lazy TLB flush vs. recreation of TLB entries
      s390/kvm: set guest page states to stable on re-ipl
      mm: mask bits from pmd in pmd_lockptr/pmd_huge_pte
      s390/mm: enable split page table lock for PMD level
      s390/airq: add support for irq ranges
      s390/ptrace: add support for PTRACE_SINGLEBLOCK
      s390/con3270: optionally disable auto update

Michael Holzheu (2):
      s390/sclp_early: Return correct HSA block count also for zero
      hypfs: Add clarification for "weight_min" attribute

Philipp Hachtmann (1):
      s390/topology: Remove call to update_cpu_masks()

Sebastian Ott (5):
      s390/cio: fix driver callback initialization for ccw consoles
      s390/cio: reorder initialization of ccw consoles
      s390/cio: fix irq stats for early interrupts on ccw consoles
      s390: improve debug feature usage
      s390: add some drivers/subsystems to the MAINTAINERS file

 MAINTAINERS                             |   27 ++++-
 arch/s390/Kconfig                       |    5 +
 arch/s390/appldata/appldata_os.c        |    2 +-
 arch/s390/configs/default_defconfig     |   46 +++++++--
 arch/s390/configs/gcov_defconfig        |   33 ++++--
 arch/s390/configs/performance_defconfig |   33 ++++--
 arch/s390/configs/zfcpdump_defconfig    |    1 -
 arch/s390/defconfig                     |   10 ++
 arch/s390/hypfs/hypfs_vm.c              |    9 +-
 arch/s390/include/asm/airq.h            |   14 ++-
 arch/s390/include/asm/bitops.h          |    8 +-
 arch/s390/include/asm/ccwdev.h          |    4 +-
 arch/s390/include/asm/checksum.h        |   11 +-
 arch/s390/include/asm/futex.h           |   13 +--
 arch/s390/include/asm/kvm_host.h        |    5 +-
 arch/s390/include/asm/mmu_context.h     |   39 ++++++-
 arch/s390/include/asm/pgalloc.h         |   18 +++-
 arch/s390/include/asm/pgtable.h         |  105 +++++++++++++------
 arch/s390/include/asm/ptrace.h          |    1 +
 arch/s390/include/asm/sclp.h            |    1 +
 arch/s390/include/asm/setup.h           |    3 -
 arch/s390/include/asm/thread_info.h     |    3 +
 arch/s390/include/asm/uaccess.h         |  171 +++++++++++++------------------
 arch/s390/include/uapi/asm/ptrace.h     |    6 ++
 arch/s390/kernel/Makefile               |    5 +-
 arch/s390/kernel/compat_exec_domain.c   |   29 ------
 arch/s390/kernel/early.c                |    2 -
 arch/s390/kernel/entry.S                |    9 +-
 arch/s390/kernel/entry64.S              |    9 +-
 arch/s390/kernel/perf_event.c           |    2 +-
 arch/s390/kernel/ptrace.c               |   13 ++-
 arch/s390/kernel/setup.c                |   17 ---
 arch/s390/kernel/smp.c                  |    8 +-
 arch/s390/kernel/topology.c             |    1 -
 arch/s390/kvm/diag.c                    |    3 +
 arch/s390/kvm/kvm-s390.c                |   25 +++++
 arch/s390/kvm/kvm-s390.h                |    2 +
 arch/s390/kvm/priv.c                    |   41 ++++++++
 arch/s390/lib/Makefile                  |    3 +-
 arch/s390/lib/find.c                    |    2 +-
 arch/s390/lib/uaccess.h                 |    8 +-
 arch/s390/lib/uaccess_mvcos.c           |  116 ++++++++++++++++-----
 arch/s390/lib/uaccess_pt.c              |   69 +++++--------
 arch/s390/mm/maccess.c                  |   28 +----
 arch/s390/mm/pgtable.c                  |  158 +++++++++++++++++++++++++++-
 arch/s390/pci/pci_debug.c               |    2 +-
 drivers/s390/char/con3215.c             |    8 +-
 drivers/s390/char/con3270.c             |   13 ++-
 drivers/s390/char/raw3270.c             |   26 ++++-
 drivers/s390/char/raw3270.h             |    3 +-
 drivers/s390/char/sclp_early.c          |   31 +++++-
 drivers/s390/cio/airq.c                 |   66 +++++++-----
 drivers/s390/cio/chsc_sch.c             |    3 +-
 drivers/s390/cio/cio.c                  |    4 +-
 drivers/s390/cio/device.c               |   52 ++++++----
 drivers/s390/net/qeth_core_main.c       |    4 +-
 include/asm-generic/pgtable.h           |   13 +++
 include/linux/mm.h                      |   10 +-
 kernel/sched/core.c                     |    4 +-
 mm/mmu_context.c                        |    3 +
 mm/rmap.c                               |   10 ++
 61 files changed, 943 insertions(+), 427 deletions(-)
 delete mode 100644 arch/s390/kernel/compat_exec_domain.c

