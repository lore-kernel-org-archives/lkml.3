Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaJXRd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:33:57 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48427 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaJXRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:33:55 -0400
Date: Fri, 24 Oct 2014 18:33:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] arm64 fixes for 3.18
Message-ID: <20141024173328.GA14639@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to 3dec0fe48a8936528aae2fc3f904c2c9a34ba368:

  arm64: Fix memblock current_limit with 64K pages and 48-bit VA (2014-10-24 18:16:47 +0100)

----------------------------------------------------------------
arm64 fixes:

- Enable 48-bit VA space now that KVM has been fixed, together with
  a couple of fixes for pgd allocation alignment and initial memblock
  current_limit. There is still a dependency on !ARM_SMMU which needs to
  be updated as it uses the page table manipulation macros of the host
  kernel
- eBPF fixes following changes/conflicts during the merging window
- Compat types affecting compat_elf_prpsinfo
- Compilation error on UP builds
- ASLR fix when /proc/sys/kernel/randomize_va_space == 0
- DT definitions for CLCD support on ARMv8 model platform

----------------------------------------------------------------
Alex Bennée (1):
      Documentation/arm64/memory.txt: fix typo

Arun Chandran (1):
      arm64: ASLR: Don't randomise text when randomise_va_space == 0

Catalin Marinas (4):
      arm64: Align less than PAGE_SIZE pgds naturally
      arm64: Fix compilation error on UP builds
      arm64: vexpress: Add CLCD support to the ARMv8 model platform
      arm64: Fix memblock current_limit with 64K pages and 48-bit VA

Christoffer Dall (1):
      arm64: Allow 48-bits VA space without ARM_SMMU

Daniel Borkmann (2):
      net: bpf: arm64: address randomize and write protect JIT code
      net: bpf: arm64: minor fix of type in jited

Steve Capper (1):
      arm64: mm: Correct fixmap pagetable types

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Zi Shen Lim (2):
      arm64: bpf: add 'shift by register' instructions
      arm64: bpf: add 'load 64-bit immediate' instruction

 Documentation/arm64/memory.txt               |  2 +-
 arch/arm64/Kconfig                           |  3 +-
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi | 35 +++++++++++-
 arch/arm64/configs/defconfig                 |  2 +
 arch/arm64/include/asm/compat.h              |  4 +-
 arch/arm64/include/asm/elf.h                 |  4 +-
 arch/arm64/include/asm/irq_work.h            | 11 ++++
 arch/arm64/kernel/process.c                  |  5 --
 arch/arm64/mm/ioremap.c                      |  4 +-
 arch/arm64/mm/mmu.c                          | 12 ++--
 arch/arm64/mm/pgd.c                          | 18 +++++-
 arch/arm64/net/bpf_jit.h                     |  8 ++-
 arch/arm64/net/bpf_jit_comp.c                | 84 ++++++++++++++++++++++++----
 13 files changed, 160 insertions(+), 32 deletions(-)

-- 
Catalin
