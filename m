Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaEDKrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 06:47:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15381 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753475AbaEDKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 06:47:19 -0400
Date: Sun, 4 May 2014 11:46:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.15
Message-ID: <20140504104628.GA17370@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below for 3.15. These are mostly arm64
fixes with an additional arm(64) platform fix for the initialisation of
vexpress clocks (the latter only affecting arm64; the arch/arm64 code
is SoC agnostic and does not rely on early SoC-specific calls). Thanks.

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to e715eb2e73918f4cefbba0b717ff8902e8030b39:

  vexpress: Initialise the sysregs before setting up the clocks (2014-05-04 11:35:29 +0100)

----------------------------------------------------------------
- vexpress platform clocks initialisation moved earlier following the
  arm64 move of of_clk_init() call in a previous commit
- Default DMA ops changed to non-coherent to preserve compatibility with
  32-bit ARM DT files. The "dma-coherent" property can be used to
  explicitly mark a device coherent. The Applied Micro DT file has been
  updated to avoid DMA cache maintenance for the X-Gene SATA controller
  (the only arm64 related driver with such assumption in -rc mainline)
- Fixmap correction for earlyprintk
- kern_addr_valid() fix for huge pages

----------------------------------------------------------------
Catalin Marinas (3):
      arm64: Use bus notifiers to set per-device coherent DMA ops
      arm64: Mark the Applied Micro X-Gene SATA controller as DMA coherent
      vexpress: Initialise the sysregs before setting up the clocks

Dave Anderson (1):
      arm64: Fix for the arm64 kern_addr_valid() function

Marc Zyngier (1):
      arm64: fixmap: fix missing sub-page offset for earlyprintk

Ritesh Harjani (1):
      arm64: Make default dma_ops to be noncoherent

 .../devicetree/bindings/ata/apm-xgene.txt          |  3 ++
 arch/arm64/boot/dts/apm-storm.dtsi                 |  3 ++
 arch/arm64/kernel/early_printk.c                   |  6 ++--
 arch/arm64/kernel/setup.c                          |  2 +-
 arch/arm64/mm/dma-mapping.c                        | 35 ++++++++++++++++++++--
 arch/arm64/mm/mmu.c                                |  3 ++
 drivers/clk/versatile/clk-vexpress-osc.c           |  2 ++
 include/asm-generic/fixmap.h                       |  3 ++
 8 files changed, 50 insertions(+), 7 deletions(-)

-- 
Catalin
