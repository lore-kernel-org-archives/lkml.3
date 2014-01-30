Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaA3C4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 21:56:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:59472 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA3C4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 21:56:02 -0500
Message-ID: <1391050548.8524.89.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 30 Jan 2014 13:55:48 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc bits for this merge window. The bulk is made
of two pull requests from Scott and Anatolij that I had missed previously
(they arrived while I was away). Since both their branches are in -next
independently, and the content has been around for a little while, they
can still go in.

The rest is mostly bug and regression fixes, a small series of
cleanups to our pseries cpuidle code (including moving it to
the right place), and one new cpuidle bakend for the powernv
platform. I also wired up the new sched_attr syscalls.

Cheers,
Ben.

The following changes since commit d891ea23d5203e5c47439b2a174f86a00b356a6c:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2014-01-28 11:02:23 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to f878f84373aefda7f041a74b24a83b8b7dec1cf0:

  powerpc: Wire up sched_setattr and sched_getattr syscalls (2014-01-29 17:13:05 +1100)

----------------------------------------------------------------
Alistair Popple (1):
      powerpc/iommu: Fix initialisation of DART iommu table

Andreas Schwab (1):
      powerpc: Fix hw breakpoints on !HAVE_HW_BREAKPOINT configurations

Benjamin Herrenschmidt (3):
      Merge remote-tracking branch 'agust/next' into next
      Merge remote-tracking branch 'scott/next' into next
      powerpc: Wire up sched_setattr and sched_getattr syscalls

Deepthi Dharwar (6):
      powerpc/pseries/cpuidle: Move processor_idle.c to drivers/cpuidle.
      powerpc/pseries/cpuidle: Use cpuidle_register() for initialisation.
      powerpc/pseries/cpuidle: Make cpuidle-pseries backend driver a non-module.
      powerpc/pseries/cpuidle: Remove MAX_IDLE_STATE macro.
      powerpc/pseries/cpuidle: smt-snooze-delay cleanup.
      powerpc/powernv/cpuidle: Back-end cpuidle driver for powernv platform.

Gerhard Sittig (20):
      dts: mpc512x: introduce dt-bindings/clock/ header
      dts: mpc512x: add clock related device tree specs
      clk: mpc512x: introduce COMMON_CLK for MPC512x (disabled)
      clk: mpc512x: add backwards compat to the CCF code
      dts: mpc512x: add clock specs for client lookups
      clk: mpc5xxx: switch to COMMON_CLK, retire PPC_CLOCK
      spi: mpc512x: adjust to OF based clock lookup
      serial: mpc512x: adjust for OF based clock lookup
      serial: mpc512x: setup the PSC FIFO clock as well
      USB: fsl-mph-dr-of: adjust for OF based clock lookup
      mtd: mpc5121_nfc: adjust for OF based clock lookup
      fsl-viu: adjust for OF based clock lookup
      net: can: mscan: adjust to common clock support for mpc512x
      net: can: mscan: remove non-CCF code for MPC512x
      powerpc/mpc512x: improve DIU related clock setup
      clk: mpc512x: remove migration support workarounds
      powerpc/512x: clk: minor comment updates
      powerpc/512x: clk: enforce even SDHC divider values
      powerpc/512x: clk: support MPC5121/5123/5125 SoC variants
      powerpc/512x: dts: add MPC5125 clock specs

Joe Perches (1):
      powerpc/numa: Fix decimal permissions

Li Zhong (1):
      powerpc/mm: Fix compile error of pgtable-ppc64.h

Paul Mackerras (2):
      powerpc: Fix 32-bit frames for signals delivered when transactional
      powerpc: Make sure "cache" directory is removed when offlining cpu

Scott Wood (1):
      powerpc/booke64: Guard e6500 tlb handler with CONFIG_PPC_FSL_BOOK3E

Tang Yuantian (1):
      clk: corenet: Adds the clock binding

Tiejun Chen (1):
      powerpc/hugetlb: Replace __get_cpu_var with get_cpu_var

jmarchan@redhat.com (1):
      powerpc/mm: Fix mmap errno when MAP_FIXED is set and mapping exceeds the allowed address space

 .../devicetree/bindings/clock/corenet-clock.txt    |  134 +++
 arch/powerpc/Kconfig                               |    6 +-
 arch/powerpc/boot/dts/ac14xx.dts                   |    7 +
 arch/powerpc/boot/dts/mpc5121.dtsi                 |  113 +-
 arch/powerpc/boot/dts/mpc5125twr.dts               |   53 +-
 arch/powerpc/include/asm/clk_interface.h           |   20 -
 arch/powerpc/include/asm/mpc5121.h                 |    7 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |    6 +-
 arch/powerpc/include/asm/processor.h               |    7 -
 arch/powerpc/include/asm/systbl.h                  |    2 +
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h             |    3 +-
 arch/powerpc/kernel/Makefile                       |    1 -
 arch/powerpc/kernel/cacheinfo.c                    |    3 +
 arch/powerpc/kernel/clock.c                        |   82 --
 arch/powerpc/kernel/process.c                      |    2 +-
 arch/powerpc/kernel/signal_32.c                    |   19 +-
 arch/powerpc/kernel/sysfs.c                        |    2 -
 arch/powerpc/mm/hugetlbpage.c                      |    4 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/mm/slice.c                            |    2 +-
 arch/powerpc/mm/tlb_low_64e.S                      |    3 +-
 arch/powerpc/mm/tlb_nohash.c                       |    2 +
 arch/powerpc/platforms/512x/Kconfig                |    2 +-
 arch/powerpc/platforms/512x/Makefile               |    3 +-
 arch/powerpc/platforms/512x/clock-commonclk.c      | 1221 ++++++++++++++++++++
 arch/powerpc/platforms/512x/clock.c                |  754 ------------
 arch/powerpc/platforms/512x/mpc512x_shared.c       |  169 +--
 arch/powerpc/platforms/52xx/Kconfig                |    2 +-
 arch/powerpc/platforms/powernv/setup.c             |   13 +-
 arch/powerpc/platforms/pseries/Kconfig             |    9 -
 arch/powerpc/platforms/pseries/Makefile            |    1 -
 arch/powerpc/sysdev/dart_iommu.c                   |    1 +
 drivers/cpuidle/Kconfig                            |    5 +
 drivers/cpuidle/Kconfig.powerpc                    |   20 +
 drivers/cpuidle/Makefile                           |    5 +
 drivers/cpuidle/cpuidle-powernv.c                  |  169 +++
 .../cpuidle/cpuidle-pseries.c                      |   79 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |  270 +++--
 drivers/spi/spi-mpc512x-psc.c                      |   26 +-
 drivers/tty/serial/mpc52xx_uart.c                  |   90 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |   13 +-
 include/dt-bindings/clock/mpc512x-clock.h          |   76 ++
 include/linux/clk-provider.h                       |   16 +
 46 files changed, 2234 insertions(+), 1196 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/corenet-clock.txt
 delete mode 100644 arch/powerpc/include/asm/clk_interface.h
 delete mode 100644 arch/powerpc/kernel/clock.c
 create mode 100644 arch/powerpc/platforms/512x/clock-commonclk.c
 delete mode 100644 arch/powerpc/platforms/512x/clock.c
 create mode 100644 drivers/cpuidle/Kconfig.powerpc
 create mode 100644 drivers/cpuidle/cpuidle-powernv.c
 rename arch/powerpc/platforms/pseries/processor_idle.c => drivers/cpuidle/cpuidle-pseries.c (75%)
 create mode 100644 include/dt-bindings/clock/mpc512x-clock.h


