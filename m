Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796Ab3IFR3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:29:22 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54305 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750721Ab3IFR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:29:20 -0400
Date: Fri, 6 Sep 2013 18:28:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.12
Message-ID: <20130906172828.GA8678@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.


The following changes since commit ee7538a008a45050c8f706d38b600f55953169f9:

  arm64: perf: fix event validation for software group leaders (2013-08-20 12:05:57 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-for-linus

for you to fetch changes up to 4d5e0b1527dd330940e8b7180b8d7016fc900352:

  Documentation/arm64: clarify requirements for DTB placement (2013-09-05 17:29:05 +0100)

----------------------------------------------------------------
- User tagged pointers support (top 8-bit of user pointers automatically
  ignored by the CPU).
- Kernel mode NEON (no users for arm64 yet but work in progress).
- arm64 kernel Image header extended to accommodate future EFI stub.
- Remove BogoMIPS reporting (not relevant, it's just the timer
  frequency).
- Clean-up (EM_AARCH64/EM_ARM to elf-em.h, ELF notes in read-only
  segment, unused variable).
- Bug-fixes (RAM boundaries not 2MB aligned, perf, includes).

----------------------------------------------------------------
Ard Biesheuvel (1):
      arm64: add support for kernel mode NEON

Catalin Marinas (3):
      arm64: Enable interrupts in the EL0 undef handler
      arm64: Fix mapping of memory banks not ending on a PMD_SIZE boundary
      arm64: Remove unused cpu_name ascii in arch/arm64/mm/proc.S

Chen Gang (1):
      ARM64: include: asm: include "asm/types.h" in "pgtable-2level-types.h" and "pgtable-3level-types.h"

Dan Aloni (1):
      Move the EM_ARM and EM_AARCH64 definitions to uapi/linux/elf-em.h

Mark Salter (2):
      arm64: move elf notes into readonly segment
      Documentation/arm64: clarify requirements for DTB placement

Roy Franz (1):
      arm64: Expand arm64 image header

Will Deacon (4):
      arm64: perf: fix group validation when using enable_on_exec
      arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit
      arm64: delay: don't bother reporting bogomips in /proc/cpuinfo
      arm64: mm: permit use of tagged pointers at EL0

 Documentation/arm64/booting.txt               | 22 ++++++++++++-----
 Documentation/arm64/tagged-pointers.txt       | 34 +++++++++++++++++++++++++++
 arch/arm/include/asm/elf.h                    |  2 --
 arch/arm64/Kconfig                            |  3 +++
 arch/arm64/include/asm/elf.h                  |  3 ---
 arch/arm64/include/asm/neon.h                 | 14 +++++++++++
 arch/arm64/include/asm/pgtable-2level-types.h |  2 ++
 arch/arm64/include/asm/pgtable-3level-types.h |  2 ++
 arch/arm64/include/asm/pgtable-hwdef.h        |  1 +
 arch/arm64/kernel/entry.S                     |  3 +++
 arch/arm64/kernel/fpsimd.c                    | 28 ++++++++++++++++++++++
 arch/arm64/kernel/head.S                      |  8 +++++++
 arch/arm64/kernel/perf_event.c                |  7 ++++--
 arch/arm64/kernel/setup.c                     |  3 ---
 arch/arm64/kernel/smp.c                       |  6 +----
 arch/arm64/kernel/vmlinux.lds.S               |  3 +--
 arch/arm64/mm/mmu.c                           | 23 ++++++++++++++++--
 arch/arm64/mm/proc.S                          |  6 +----
 include/uapi/linux/elf-em.h                   |  2 ++
 19 files changed, 142 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/arm64/tagged-pointers.txt
 create mode 100644 arch/arm64/include/asm/neon.h
