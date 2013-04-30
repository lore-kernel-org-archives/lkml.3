Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953Ab3D3QG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:06:29 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58663 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760331Ab3D3QG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:06:26 -0400
Date: Tue, 30 Apr 2013 17:06:20 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 patches for 3.10-rc1
Message-ID: <20130430160620.GI29766@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.

The following changes since commit 792072066d30372772137be9ee2f4d72d77329f9:

  arm64: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS (2013-03-19 16:19:19 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-for-linus

for you to fetch changes up to 16c85a1fd73eade2ae290d759924c09b4595f504:

  arm64: Use acquire/release semantics instead of explicit DMB (2013-04-30 15:58:37 +0100)

----------------------------------------------------------------
Main features:
- Versatile Express SoC (model) support - DT files and Kconfig entries
  (there are no arch/arm64/mach-* directories). The bulk of the code has
  already been moved to drivers/ as part of the ARM SoC clean-up.
- Basic multi-cluster support (CPU logical map initialised from the DT).
- Simple earlyprintk support for UART 8250/16550 and FastModel console
  output.
- Optimised kernel library bitops and string functions.
- Automatic initialisation of the irqchip and clocks via DT.

----------------------------------------------------------------
Anup Patel (1):
      arm64: add support for 8250/16550 earlyprintk

Catalin Marinas (10):
      arm64: Initialise the clocks described via DT
      arm64: klib: Optimised memory functions
      arm64: klib: Optimised string functions
      arm64: klib: Optimised atomic bitops
      arm64: Use irqchip_init() for interrupt controller initialisation
      Merge branch 'arm64-klib' into upstream
      arm64: Execute DSB during thread switching for TLB/cache maintenance
      arm64: Fix compat types affecting struct compat_stat
      arm64: vexpress: Enable ARMv8 RTSM model (SoC) support
      arm64: Use acquire/release semantics instead of explicit DMB

Chen Gang (3):
      arm64: Define readq and writeq for driver module using
      arm64: Define cmpxchg64 and cmpxchg64_local for outside use
      arm64: compiling issue, need add include/asm/vga.h file

Christopher Covington (1):
      arm64: Fix task tracing

Javi Merino (3):
      arm64: kernel: make the pen of the secondary a 64-bit unsigned value
      arm64: kernel: initialise cpu_logical_map from the DT
      arm64: head: match all affinity levels in the pen of the secondaries

Liviu Dudau (1):
      arm64: psci: Use the MPIDR values from cpu_logical_map for cpu ids.

Marc Zyngier (3):
      arm64: add read_cpuid_{implementor,part_number,mpidr}
      arm64: early_printk: add support for FastModel console output
      arm64: add explicit symbols to ESR_EL1 decoding

Mark Rutland (2):
      arm64: Survive invalid cpu enable-methods
      arm64: klib: bitops: fix unpredictable stxr usage

Pawel Moll (1):
      arm64: vexpress: Add dts files for the ARMv8 RTSM models

Steve Capper (1):
      arm64: mm: Correct show_pte behaviour

Will Deacon (1):
      arm64: smp: honour #address-size when parsing CPU reg property

 arch/arm64/Kconfig                                 |  11 +-
 arch/arm64/boot/dts/Makefile                       |   2 +
 arch/arm64/boot/dts/foundation-v8.dts              | 230 ++++++++++++++++++++
 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts             | 159 ++++++++++++++
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi       | 234 +++++++++++++++++++++
 arch/arm64/boot/dts/skeleton.dtsi                  |  13 ++
 arch/arm64/configs/defconfig                       |   4 +
 arch/arm64/include/asm/Kbuild                      |   2 +-
 arch/arm64/include/asm/bitops.h                    |  18 +-
 arch/arm64/include/asm/cmpxchg.h                   |   3 +
 arch/arm64/include/asm/compat.h                    |  22 +-
 arch/arm64/include/asm/cputype.h                   |  30 +++
 arch/arm64/include/asm/esr.h                       |  55 +++++
 arch/arm64/include/asm/exception.h                 |   1 +
 arch/arm64/include/asm/hardirq.h                   |   5 +
 arch/arm64/include/asm/io.h                        |   4 +
 arch/arm64/include/asm/irq.h                       |   1 +
 .../arm64/{lib/bitops.c => include/asm/smp_plat.h} |  25 ++-
 arch/arm64/include/asm/string.h                    |  37 ++++
 arch/arm64/kernel/arm64ksyms.c                     |  21 +-
 arch/arm64/kernel/early_printk.c                   |  35 +++
 arch/arm64/kernel/entry.S                          |  53 ++---
 arch/arm64/kernel/head.S                           |   4 +-
 arch/arm64/kernel/irq.c                            |  19 +-
 arch/arm64/kernel/process.c                        |   8 +-
 arch/arm64/kernel/setup.c                          |  12 ++
 arch/arm64/kernel/smp.c                            | 113 ++++++++--
 arch/arm64/kernel/smp_psci.c                       |   5 +-
 arch/arm64/lib/Makefile                            |   4 +-
 arch/arm64/lib/bitops.S                            |  68 ++++++
 arch/arm64/lib/memchr.S                            |  44 ++++
 arch/arm64/lib/memcpy.S                            |  53 +++++
 arch/arm64/lib/memmove.S                           |  57 +++++
 arch/arm64/lib/memset.S                            |  53 +++++
 arch/arm64/lib/strchr.S                            |  42 ++++
 arch/arm64/lib/strrchr.S                           |  43 ++++
 arch/arm64/mm/fault.c                              |   6 +-
 drivers/net/ethernet/smsc/Kconfig                  |   4 +-
 38 files changed, 1410 insertions(+), 90 deletions(-)
 create mode 100644 arch/arm64/boot/dts/foundation-v8.dts
 create mode 100644 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
 create mode 100644 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi
 create mode 100644 arch/arm64/boot/dts/skeleton.dtsi
 create mode 100644 arch/arm64/include/asm/esr.h
 rename arch/arm64/{lib/bitops.c => include/asm/smp_plat.h} (58%)
 create mode 100644 arch/arm64/include/asm/string.h
 create mode 100644 arch/arm64/lib/bitops.S
 create mode 100644 arch/arm64/lib/memchr.S
 create mode 100644 arch/arm64/lib/memcpy.S
 create mode 100644 arch/arm64/lib/memmove.S
 create mode 100644 arch/arm64/lib/memset.S
 create mode 100644 arch/arm64/lib/strchr.S
 create mode 100644 arch/arm64/lib/strrchr.S
