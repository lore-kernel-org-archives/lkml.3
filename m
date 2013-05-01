Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab3EACHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:07:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32376 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089Ab3EACGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:06:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,584,1363158000"; 
   d="scan'208";a="43010592"
Date: Tue, 30 Apr 2013 21:06:47 -0500
From: rkuo <rkuo@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [GIT PULL] Hexagon arch fixes
Message-ID: <20130501020518.GA17080@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull the following changes for the Hexagon architecture (and one
touching OpenRISC).  They include various fixes to make use of additional
arch features and cleanups.  The largest functional change is a cleanup
of the signal and event return paths.


Thanks,
Richard Kuo


The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

for you to fetch changes up to 426d29ccb2a8d44c18d3167327ee82b38287e7bf:

  Hexagon: add v4 CS regs to core copyout macro (2013-04-30 19:40:29 -0500)

----------------------------------------------------------------
Paul Bolle (2):
      arch: remove CONFIG_GENERIC_FIND_NEXT_BIT again
      Hexagon: remove two Kconfig entries

Richard Kuo (30):
      Hexagon: clean up generic headers in Kbuild
      Hexagon: fix __atomic_add_unless
      Hexagon: add support for ARCH_PFN_OFFSET
      Hexagon: change arch version config to allow comparisons
      Hexagon: use GENERIC_CPU_DEVICES
      Hexagon: use defines for MIN_KERNEL_SEG calculation
      Hexagon: add individual register access for switch_stack
      Hexagon: add support for new v4+ registers
      Hexagon: Signal and return path fixes
      Hexagon: check to if we will overflow the signal stack
      Hexagon: remove keyring related call
      Hexagon: fix initial page table setup prior to jump to VA
      Hexagon: add support for additional exceptions
      Hexagon: use correct work mask when checking for more work
      Hexagon: add support for single-stepping (v4+)
      Hexagon: don't print info for offline CPU's
      Hexagon: switch to using the device type for IO mappings
      Hexagon: add IOMEM and _relaxed IO macros
      Hexagon: fix up int enable/disable at ret_from_fork
      Hexagon: fix psp/sp macro
      Hexagon: use generic sys_fork, sys_vfork, and sys_clone
      Hexagon: break up user fn/arg register setting
      Hexagon: fix signal.c compile error
      Hexagon: add translation types for __vmnewmap
      Hexagon: update copyright dates
      Hexagon: fix signal number for user mem faults
      Hexagon: fix return value for notify_resume case in do_work_pending
      Hexagon: use correct translations for DMA mappings
      Hexagon: use correct translation for VMALLOC_START
      Hexagon: add v4 CS regs to core copyout macro

 arch/hexagon/Kconfig                      |   33 +---
 arch/hexagon/Makefile                     |   17 +-
 arch/hexagon/include/asm/Kbuild           |    2 +-
 arch/hexagon/include/asm/atomic.h         |   22 ++-
 arch/hexagon/include/asm/elf.h            |   23 ++-
 arch/hexagon/include/asm/hexagon_vm.h     |   56 +++---
 arch/hexagon/include/asm/io.h             |   16 +-
 arch/hexagon/include/asm/mem-layout.h     |   28 ++-
 arch/hexagon/include/asm/page.h           |   12 +-
 arch/hexagon/include/asm/processor.h      |   51 +++++-
 arch/hexagon/include/asm/vm_mmu.h         |   11 +-
 arch/hexagon/include/uapi/asm/ptrace.h    |    5 +
 arch/hexagon/include/uapi/asm/registers.h |   17 +-
 arch/hexagon/include/uapi/asm/signal.h    |    4 +
 arch/hexagon/include/uapi/asm/unistd.h    |    3 +
 arch/hexagon/include/uapi/asm/user.h      |    6 +
 arch/hexagon/kernel/Makefile              |    2 +-
 arch/hexagon/kernel/asm-offsets.c         |    5 +-
 arch/hexagon/kernel/dma.c                 |   27 ++-
 arch/hexagon/kernel/head.S                |  107 +++++++++--
 arch/hexagon/kernel/kgdb.c                |    4 +-
 arch/hexagon/kernel/process.c             |   42 ++++-
 arch/hexagon/kernel/ptrace.c              |   26 ++-
 arch/hexagon/kernel/setup.c               |    9 +-
 arch/hexagon/kernel/signal.c              |   45 ++---
 arch/hexagon/kernel/topology.c            |   52 ------
 arch/hexagon/kernel/traps.c               |   36 ++--
 arch/hexagon/kernel/vm_entry.S            |  282 ++++++++++++++++++++---------
 arch/hexagon/kernel/vm_events.c           |    4 +-
 arch/hexagon/kernel/vm_vectors.S          |    4 +-
 arch/hexagon/kernel/vmlinux.lds.S         |   12 +-
 arch/hexagon/mm/init.c                    |   35 ++--
 arch/hexagon/mm/vm_fault.c                |    4 +-
 arch/openrisc/Kconfig                     |    3 -
 34 files changed, 659 insertions(+), 346 deletions(-)
 delete mode 100644 arch/hexagon/kernel/topology.c


--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
