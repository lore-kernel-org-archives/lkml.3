Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3EIEwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:52:08 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:50116 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3EIEwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:52:07 -0400
Message-ID: <518B2B62.9090309@synopsys.com>
Date: Thu, 9 May 2013 10:21:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Alexander Shiyan <shc_work@mail.ru>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Noam Camus <noamc@ezchip.com>, Paul Bolle <pebolle@tiscali.nl>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [GIT PULL] arch/arc for 3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling ARC changes for 3.10 (shortlog below).

Note that the base-point is not a well known 3.9-rcX because of the PREEMPT_COUNT
+ compiler barrier fiasco - and I didn't bother to rebase after that. However the
series applies cleanly on top your tree as of today.

Also, I'm in the final stages of testing the d-cache aliasing support, so those
would follow in a day or two.

Thanks,
Vineet

The following changes since commit f011a08c804d50eeff4abf2d308cdce492f015aa:

  Merge tag 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes (2013-04-08 16:10:43
-0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-v3.10-rc1-part1

for you to fetch changes up to eacd0e950dc2100af54f2a94ae29105bf48ab921:

  ARC: [mm] Lazy D-cache flush (non aliasing VIPT) (2013-05-07 19:08:15 +0530)

----------------------------------------------------------------
ARC port updates for Linux 3.10 (part 1)

* Support for two new platforms based on ARC700
 - Abilis TB10x SoC [Chritisian/Pierrick]
 - Simulator only System-C Model [Mischa]

* ARC specific MM improvements
 - Avoid full TLB flush (ASID increment) on munmap (even single page)
 - VIPT Cache Flushing improvements
   + Delayed dcache flush for non-aliasing dcache (big performance boost)
   + icache flush aliasing agnostic (no need to kill all possible aliases)

* Others
 - Avoid needless rebuild of DTB files for every kernel build
 - Remove builtin cmdline as that is already provided by DeviceTree/bootargs
 - Fixing unaligned access emulation corner case
 - checkpatch fixes [Sachin]
 - Various fixlets [Noam]
 - Minor build failures/cleanups

----------------------------------------------------------------
Alexander Shiyan (1):
      ARC: Remove non existent refs to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD

Christian Ruppert (5):
      ARC: [build] Build failure with !KPROBES
      ARC: Prepare interrupt code for external controllers
      ARC: [TB10x] Device tree of TB100 and TB101 Development Kits
      ARC: [TB10x] Add support for TB10x platform
      ARC: [TB10x] Adapt device tree to new compatible string

Mischa Jonker (1):
      ARC: Add support for nSIM OSCI System C model

Noam Camus (2):
      ARC: Respect the cpu_id passed for fetching correct cpu info
      ARC: fix typo with clock speed

Paul Bolle (1):
      ARC: remove #ifdef-ed out include of dead header

Sachin Kamat (4):
      ARC: Remove unneeded version.h header include
      ARC: Use <linux/*> headers instead of <asm/*>
      ARC: Fix coding style issues
      ARC: Remove duplicate inclusion of header files

Vineet Gupta (21):
      ARC: [build] silence make defconfig warnings with host gcc 4.7
      ARC: [build] cleanup Makefile a bit
      ARC: [build] Allow uncompressed uImage
      ARC: [build] Fix warnings with CONFIG_DEBUG_SECTION_MISMATCH
      ARC: [kbuild] Allow platforms to disable LLSC for !SMP as well
      ARC: [kbuild] Include Kconfig.binfmt
      ARC: [kbuild] Avoid DTB rebuilds if DTS are untouched
      ARC: Debug/crash-printing Improvements
      ARC: unaligned access emulation error handling consolidation
      ARC: unaligned access emulation broken if callee-reg dest of LD/ST
      ARC: [plat-arcfpga] defconfig update
      ARC: [cmdline] Remove CONFIG_CMDLINE
      ARC: [cmdline] Don't overwrite u-boot provided bootargs
      ARC: Allow embedded arc-intc to be properly placed in DT intc hierarchy
      ARC: [mm] optimize needless full mm TLB flush on munmap
      ARC: [mm] optimise icache flush for user mappings
      ARC: [mm] optimise icache flush for kernel mappings
      ARC: [mm] consolidate icache/dcache sync code
      ARC: [mm] remove the pessimistic all-alias-invalidate icache helpers
      ARC: [mm] micro-optimize page size icache invalidate
      ARC: [mm] Lazy D-cache flush (non aliasing VIPT)

 arch/arc/Kconfig                       |   31 +--
 arch/arc/Makefile                      |   15 +-
 arch/arc/boot/Makefile                 |   19 +-
 arch/arc/boot/dts/Makefile             |    4 +-
 arch/arc/boot/dts/abilis_tb100.dtsi    |  340 +++++++++++++++++++++++++++++++
 arch/arc/boot/dts/abilis_tb100_dvk.dts |  127 ++++++++++++
 arch/arc/boot/dts/abilis_tb101.dtsi    |  349 ++++++++++++++++++++++++++++++++
 arch/arc/boot/dts/abilis_tb101_dvk.dts |  127 ++++++++++++
 arch/arc/boot/dts/abilis_tb10x.dtsi    |  247 ++++++++++++++++++++++
 arch/arc/boot/dts/nsimosci.dts         |   77 +++++++
 arch/arc/configs/fpga_defconfig        |    3 +-
 arch/arc/configs/nsimosci_defconfig    |   75 +++++++
 arch/arc/configs/tb10x_defconfig       |  117 +++++++++++
 arch/arc/include/asm/cacheflush.h      |   16 +-
 arch/arc/include/asm/irq.h             |    3 +-
 arch/arc/include/asm/serial.h          |   10 +
 arch/arc/include/asm/tlb.h             |   16 +-
 arch/arc/kernel/asm-offsets.c          |    2 +-
 arch/arc/kernel/clk.c                  |    2 +-
 arch/arc/kernel/disasm.c               |    2 +-
 arch/arc/kernel/entry.S                |    8 +-
 arch/arc/kernel/irq.c                  |   25 ++-
 arch/arc/kernel/kprobes.c              |    1 -
 arch/arc/kernel/module.c               |    4 +-
 arch/arc/kernel/setup.c                |   36 ++--
 arch/arc/kernel/time.c                 |    1 -
 arch/arc/kernel/traps.c                |   24 +--
 arch/arc/kernel/troubleshoot.c         |   50 +++--
 arch/arc/mm/cache_arc700.c             |  269 ++++++------------------
 arch/arc/mm/extable.c                  |    4 +-
 arch/arc/mm/fault.c                    |    1 -
 arch/arc/mm/init.c                     |    3 -
 arch/arc/mm/ioremap.c                  |    2 +-
 arch/arc/mm/tlb.c                      |   32 ++-
 arch/arc/plat-arcfpga/platform.c       |   12 ++
 arch/arc/plat-tb10x/Kconfig            |   36 ++++
 arch/arc/plat-tb10x/Makefile           |   21 ++
 arch/arc/plat-tb10x/tb10x.c            |   71 +++++++
 38 files changed, 1840 insertions(+), 342 deletions(-)
 create mode 100644 arch/arc/boot/dts/abilis_tb100.dtsi
 create mode 100644 arch/arc/boot/dts/abilis_tb100_dvk.dts
 create mode 100644 arch/arc/boot/dts/abilis_tb101.dtsi
 create mode 100644 arch/arc/boot/dts/abilis_tb101_dvk.dts
 create mode 100644 arch/arc/boot/dts/abilis_tb10x.dtsi
 create mode 100644 arch/arc/boot/dts/nsimosci.dts
 create mode 100644 arch/arc/configs/nsimosci_defconfig
 create mode 100644 arch/arc/configs/tb10x_defconfig
 create mode 100644 arch/arc/plat-tb10x/Kconfig
 create mode 100644 arch/arc/plat-tb10x/Makefile
 create mode 100644 arch/arc/plat-tb10x/tb10x.c
