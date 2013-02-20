Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab3BTRSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:18:12 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50673 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753818Ab3BTRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:18:10 -0500
Date: Wed, 20 Feb 2013 17:17:58 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 patches for 3.9
Message-ID: <20130220171758.GA20787@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.

The following changes since commit f1b99392caf120d7533da260318fae0eb5053737:

  arm64: makefile: fix uname munging when setting ARCH on native machine (2013-01-22 17:51:00 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-for-linus

for you to fetch changes up to ec45d1cfd3cb65121fc52f39efc17d832f4f7b91:

  arm64: mm: update CONTEXTIDR register to contain PID of current process (2013-02-11 18:24:18 +0000)

----------------------------------------------------------------
- SMP support for the PSCI booting protocol (power state coordination
interface).
- Simple earlyprintk support.
- Platform devices populated by default from the DT (SoC-agnostic).
- CONTEXTIDR support (used by external trace tools).

----------------------------------------------------------------
Catalin Marinas (4):
      arm64: Populate the platform devices
      arm64: Add simple earlyprintk support
      arm64: Add kvm_para.h and xor.h generic headers
      arm64: Select ARCH_WANT_FRAME_POINTERS

Marc Zyngier (4):
      arm64: add COMPAT_PSR_*_BIT flags
      arm64: perf: add guest vs host discrimination
      arm64: SMP: rework the SMP code to be enabling method agnostic
      arm64: SMP: enable PSCI boot method

Will Deacon (4):
      arm64: psci: add support for PSCI invocations from the kernel
      arm64: compat: use compat_uptr_t type for compat_ucontext.uc_link
      arm64: atomics: fix grossly inconsistent asm constraints for exclusives
      arm64: mm: update CONTEXTIDR register to contain PID of current process

 Documentation/arm64/memory.txt       |   2 +
 arch/arm64/Kconfig                   |   1 +
 arch/arm64/Kconfig.debug             |  17 +++
 arch/arm64/include/asm/Kbuild        |   2 +
 arch/arm64/include/asm/atomic.h      | 132 +++++++++++-----------
 arch/arm64/include/asm/cmpxchg.h     |  74 ++++++------
 arch/arm64/include/asm/futex.h       |   2 +-
 arch/arm64/include/asm/io.h          |   3 +
 arch/arm64/include/asm/memory.h      |   1 +
 arch/arm64/include/asm/mmu.h         |   1 +
 arch/arm64/include/asm/mmu_context.h |  15 +++
 arch/arm64/include/asm/perf_event.h  |   7 +-
 arch/arm64/include/asm/psci.h        |  38 +++++++
 arch/arm64/include/asm/ptrace.h      |  10 ++
 arch/arm64/include/asm/smp.h         |  11 ++
 arch/arm64/include/asm/spinlock.h    |  78 ++++++-------
 arch/arm64/include/uapi/asm/Kbuild   |   3 +
 arch/arm64/kernel/Makefile           |   5 +-
 arch/arm64/kernel/early_printk.c     | 118 ++++++++++++++++++++
 arch/arm64/kernel/head.S             |  12 +-
 arch/arm64/kernel/perf_event.c       |  37 ++++++
 arch/arm64/kernel/process.c          |   4 +-
 arch/arm64/kernel/psci.c             | 211 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c            |  11 ++
 arch/arm64/kernel/signal32.c         |   4 +-
 arch/arm64/kernel/smp.c              |  69 ++++++++----
 arch/arm64/kernel/smp_psci.c         |  52 +++++++++
 arch/arm64/kernel/smp_spin_table.c   |  66 +++++++++++
 arch/arm64/mm/mmu.c                  |  42 +++++++
 29 files changed, 855 insertions(+), 173 deletions(-)
 create mode 100644 arch/arm64/include/asm/psci.h
 create mode 100644 arch/arm64/kernel/early_printk.c
 create mode 100644 arch/arm64/kernel/psci.c
 create mode 100644 arch/arm64/kernel/smp_psci.c
 create mode 100644 arch/arm64/kernel/smp_spin_table.c
