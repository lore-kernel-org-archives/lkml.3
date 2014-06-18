Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaFRS1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:27:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14936 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753800AbaFRS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:26:59 -0400
Date: Wed, 18 Jun 2014 19:26:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.16
Message-ID: <20140618182639.GA27504@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are primarily bug fixes with a performance improvement patch for
the GHASH crypto algorithm (which went in during this merging window)
and dts/defconfig/Kconfig updates.

Thanks.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to e3a920afc3482e954834a4ed95908c4bc5e4c000:

  arm64: mm: remove broken &= operator from pmd_mknotpresent (2014-06-18 16:34:30 +0100)

----------------------------------------------------------------
- ftrace_return_addr() macro fix for arm (introduced earlier via the
  arm64 tree)
- stack alignment exception entry code fix
- GHASH crypto algorithm fix and performance improvement
- CMA buffer limited to 32-bit (until a better way to describe the
  system topology in DT)
- UAPI sigcontext.h build fix
- __kernel_old_{gid,uid}_t definitions fix (affecting 32-bit LTP)
- ptrace fixes (kernel fault and 32-bit arm core dump)
- pte_mknotpresent() fix
- dts updates (APM SoC)
- defconfig and Kconfig update

----------------------------------------------------------------
Ard Biesheuvel (2):
      arm64/crypto: fix data corruption bug in GHASH algorithm
      arm64/crypto: improve performance of GHASH algorithm

Catalin Marinas (2):
      arm64: defconfig update for LTP
      arm64: Limit the CMA buffer to 32-bit if ZONE_DMA

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Mark Salter (1):
      arm64: fix build error in sigcontext.h

Paul Bolle (1):
      arm64: ftrace: Fix comment typo 'CONFIG_FUNCTION_GRAPH_FP_TEST'

Steven Rostedt (1):
      arm/ftrace: fix ftrace_return_addr() to ftrace_return_address()

Sudeep Holla (2):
      arm64: restore alphabetic order in Kconfig
      arm64: add ARCH_HAS_OPP to allow enabling OPP library

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Victor Kamensky (1):
      arm64: ptrace: fix empty registers set in prstatus of aarch32 process core

Vinayak Kale (1):
      arm64: dts: Add more serial port nodes in APM X-Gene device tree

Will Deacon (3):
      arm64: ptrace: change fs when passing kernel pointer to regset code
      arm64: uid16: fix __kernel_old_{gid,uid}_t definitions
      arm64: mm: remove broken &= operator from pmd_mknotpresent

 arch/arm/include/asm/ftrace.h             |  2 +-
 arch/arm64/Kconfig                        |  3 +-
 arch/arm64/boot/dts/apm-mustang.dts       |  4 ++
 arch/arm64/boot/dts/apm-storm.dtsi        | 36 +++++++++++-
 arch/arm64/configs/defconfig              | 15 +++++
 arch/arm64/crypto/ghash-ce-core.S         | 92 +++++++++++++------------------
 arch/arm64/crypto/ghash-ce-glue.c         |  5 +-
 arch/arm64/include/asm/Kbuild             |  1 -
 arch/arm64/include/asm/dma-mapping.h      |  2 -
 arch/arm64/include/asm/pgtable.h          |  2 +-
 arch/arm64/include/uapi/asm/posix_types.h | 10 ++++
 arch/arm64/include/uapi/asm/sigcontext.h  |  2 +-
 arch/arm64/kernel/entry-ftrace.S          |  2 +-
 arch/arm64/kernel/entry.S                 |  1 -
 arch/arm64/kernel/ptrace.c                | 32 ++++++++---
 arch/arm64/mm/init.c                      | 10 +++-
 16 files changed, 142 insertions(+), 77 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/posix_types.h

-- 
Catalin
