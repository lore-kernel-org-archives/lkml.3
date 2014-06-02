Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaFBVir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47042 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaFBViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:11 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 7/7] ARM: SoC driver changes
Date: Mon,  2 Jun 2014 14:04:10 -0700
Message-Id: <1401743050-7379-8-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC-near driver changes that we're merging through our tree. Mostly
because they depend on other changes we have staged, but in some cases
because the driver maintainers preferred that we did it this way.

This contains a largeish cleanup series of the omap_l3_noc bus driver,
cpuidle rework for Exynos, some reset driver conversions and a long
branch of TI EDMA fixes and cleanups, with more to come next release.

The TI EDMA cleanups is a shared branch with the dmaengine tree, with
a handful of Davinci-specific fixes on top.

After discussion at last year's KS (and some more on the mailing lists),
we are here adding a drivers/soc directory. The purpose of this is
to keep per-vendor shared code that's needed by different drivers but
that doesn't fit into the MFD (nor drivers/platform) model. We expect
to keep merging contents for this hierarchy through arm-soc so we can
keep an eye on what the vendors keep adding here and not making it a
free-for-all to shove in crazy stuff.

----------------------------------------------------------------

The following changes since commit 35683340e0e953a6c64fecffacf76478f01dcf1f:

  Merge tag 'dt-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-3.16

for you to fetch changes up to 45e70b7d48d53d5eb193c6b3f012b31ca135fb4c:

  Merge tag 'samsung-drivers-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/drivers

----------------------------------------------------------------

Afzal Mohammed (2):
      bus: omap_l3_noc: ignore masked out unclearable targets
      bus: omap_l3_noc: Add AM4372 interconnect error data

Amit Daniel Kachhap (1):
      ARM: EXYNOS: Move arm core power down clock to exynos5250 common clock

Andy Gross (2):
      soc: qcom: Add GSBI driver
      tty: serial: msm: Remove direct access to GSBI

Arnd Bergmann (3):
      Merge tag 'qcom-drivers-for-3.16' of git://git.kernel.org/.../galak/linux-qcom into next/drivers
      Merge tag 'sunxi-drivers-for-3.16-2' of https://github.com/mripard/linux into next/drivers
      soc: qcom: fix of_device_id table

Boris BREZILLON (2):
      reset: sunxi: document sunxi's reset controllers bindings
      reset: sunxi: allow MFD subdevices probe

Daniel Lezcano (20):
      ARM: EXYNOS: Prevent forward declaration for cpuidle
      ARM: EXYNOS: Use cpuidle_register
      ARM: EXYNOS: Change function name prefix for cpuidle
      ARM: EXYNOS: Encapsulate register access inside a function for pm
      ARM: EXYNOS: Move some code inside the idle_finisher for cpuidle
      ARM: EXYNOS: Fix S5P_WAKEUP_STAT call for cpuidle
      ARM: EXYNOS: Use the cpu_pm notifier for pm
      ARM: EXYNOS: Move scu_enable in the cpu_pm notifier
      ARM: EXYNOS: Remove ifdef for scu_enable in pm
      ARM: EXYNOS: Pass wakeup mask parameter to function for cpuidle
      ARM: EXYNOS: Encapsulate boot vector code into a function for cpuidle
      ARM: EXYNOS: Disable cpuidle for exynos5440
      ARM: EXYNOS: Encapsulate the AFTR code into a function
      ARM: EXYNOS: Move the AFTR state function into pm.c
      ARM: EXYNOS: Move the power sequence call in the cpu_pm notifier
      ARM: EXYNOS: Move S5P_CHECK_SLEEP into pm.c
      ARM: EXYNOS: Pass the AFTR callback to the platform_data
      ARM: EXYNOS: Cleanup all unneeded headers from cpuidle.c
      ARM: EXYNOS: Move the driver to drivers/cpuidle directory
      ARM: EXYNOS: Fix kernel panic when unplugging CPU1 on exynos

Florian Fainelli (3):
      bus: add Broadcom GISB bus arbiter timeout/error handler
      Documentation: devicetree: add Broadcom GISB arbiter bindings
      Documentation: sysfs: add Broadcom GISB arbiter sysfs properties

Ivan Khoronzhuk (3):
      Documentation: dt: add bindings for keystone reset driver
      Documentation: dt: add bindings for keystone pll control controller
      power: reset: keystone-reset: introduce keystone reset driver

Joel Fernandes (4):
      dmaengine: edma: Add DMA memcpy support
      dmaengine: edma: No need save/restore interrupt flags during spin_lock in IRQ
      dmaengine: edma: Document variables used for residue accounting
      dmaengine: edma: update DMA memcpy to use new param element

Kukjin Kim (1):
      Merge branch 'v3.16-next/clk-samsung' into v3.16-next/cpuidle-exynos

Maxime Ripard (1):
      power: reset: Add Allwinner A31 reset code

Nishanth Menon (14):
      bus: omap_l3_noc: Fix copyright information
      bus: omap_l3_noc: remove iclk from omap_l3 struct
      bus: omap_l3_noc: populate l3->dev and use it
      bus: omap_l3_noc: switch over to relaxed variants of readl/writel
      bus: omap_l3_noc: un-obfuscate l3_targ address computation
      bus: omap_l3_noc: move L3 master data structure out
      bus: omap_l3_noc: convert target information into a structure
      bus: omap_l3_noc: convert flagmux information into a structure
      bus: omap_l3_noc: fix masterid detection
      bus: omap_l3_noc: make error reporting and handling common
      bus: omap_l3_noc: improve readability by using helper for slave event parsing
      bus: omap_l3_noc: add information about the type of operation
      bus: omap_l3_noc: Add information about the context of operation
      bus: omap_l3_noc: introduce concept of submodule

Olof Johansson (11):
      Merge tag 'socfpga-driver-update-for-3.16' of git://git.rocketboards.org/linux-socfpga-next into next/drivers
      Merge tag 'mvebu-drivers-3.16' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge branch 'sunxi/drivers-for-3.16' of https://github.com/mripard/linux into next/drivers
      Merge tag 'samsung-drivers' of http://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'omap-for-v3.16/l3-noc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'davinci-fixes-for-v3.15-rc4' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 'davinci-for-v3.16/edma' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 'keystone-reset-driver' of git://git.kernel.org/.../ssantosh/linux-keystone into next/drivers
      Merge tag 'exynos-cpuidle' of http://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'qcom-drivers-for-3.16-2' of git://git.kernel.org/.../galak/linux-qcom into next/drivers
      Merge tag 'samsung-drivers-2' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Peter Ujfalusi (29):
      platform_data: edma: Be precise with the paRAM struct
      arm: common: edma: Save the number of event queues/TCs
      dmaengine: edma: Correct the handling of src/dst_maxburst == 0
      dmaengine: edma: Add support for DMA_PAUSE/RESUME operation
      dmaengine: edma: Set DMA_CYCLIC capability flag
      dmaengine: edma: Reduce debug print verbosity for non verbose debugging
      dmaengine: edma: Implement device_slave_caps callback
      dmaengine: edma: Prefix debug prints where the text were identical in prep callbacks
      dmaengine: edma: Print the direction value as well when it is not supported
      dmaengine: edma: Add channel number to debug prints
      drivers: bus: omap_l3: Convert to use devm_kzalloc
      drivers: bus: omap_l3: Convert to use devm_ioremap_resource()
      drivers: bus: omap_l3: Convert to use devm_request_irq()
      drivers: bus: omap_l3: Remove the platform driver's remove function
      drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request fails
      ARM: edma: Clean up and simplify the code around irq request
      ARM: edma: No need to clean the pdata in edma_of_parse_dt()
      ARM: edma: Take the number of tc from edma_soc_info (pdata)
      ARM: edma: Do not change TC -> Queue mapping, leave it to default.
      ARM: davinci: Remove eDMA3 queue_tc_mapping data from edma_soc_info
      ARM: edma: Remove queue_tc_mapping data from edma_soc_info
      ARM: edma: Remove num_cc member from struct edma
      ARM: edma: Save number of regions from pdata to struct edma
      ARM: edma: Get IP configuration from HW (number of channels, tc, etc)
      dt/bindings: ti,edma: Remove redundant properties from documentation
      ARM: dts: am33xx: Remove obsolete properties from edma node
      ARM: dts: am4372: Remove obsolete properties from edma node
      ARM: davinci: Remove redundant/unused parameters for edma
      ARM: edma: Remove redundant/unused parameters from edma_soc_info

Rajendra Nayak (2):
      bus: omap_l3_noc: Add support for discountinous flag mux input numbers
      bus: omap_l3_noc: Add DRA7 interconnect error data

Santosh Shilimkar (1):
      soc: Introduce drivers/soc place-holder for SOC specific drivers

Sricharan R (2):
      bus: omap_l3_noc: rename functions and data to omap_l3
      bus: omap_l3_noc: use of_match_data to pick up SoC information

Steffen Trumtrar (1):
      reset: add driver for socfpga

Thomas Gleixner (6):
      dmaengine: edma: Sanitize residue reporting
      dmaengine: edma: Check the current decriptor first in tx_status()
      dmaengine: edma: Create private pset struct
      dmaengine: edma: Store transfer data in edma_desc and edma_pset
      dmaengine: edma: Make reading the position of active channels work
      dmaengine: edma: Provide granular accounting

Thomas Petazzoni (5):
      memory: mvebu-devbus: use ARMADA_ prefix in defines
      memory: mvebu-devbus: use _SHIFT suffixes instead of _BIT
      memory: mvebu-devbus: split functions
      memory: mvebu-devbus: add Orion5x support
      memory: mvebu-devbus: add a devbus, keep-config property

Tomasz Figa (1):
      cpufreq: exynos: Fix driver compilation with ARCH_MULTIPLATFORM

Vincent Guittot (1):
      clocksource: exynos_mct: register sched_clock callback


 .../ABI/testing/sysfs-platform-brcmstb-gisb-arb |   8 +
 .../devicetree/bindings/arm/omap/l3-noc.txt     |   2 +
 .../devicetree/bindings/bus/brcm,gisb-arb.txt   |  30 +
 .../bindings/clock/ti-keystone-pllctrl.txt      |  20 +
 .../devicetree/bindings/dma/ti-edma.txt         |  13 +-
 .../memory-controllers/mvebu-devbus.txt         |  32 +-
 .../bindings/power/reset/keystone-reset.txt     |  67 +++
 .../reset/allwinner,sunxi-clock-reset.txt       |  21 +
 arch/arm/boot/dts/am33xx.dtsi                   |   3 -
 arch/arm/boot/dts/am4372.dtsi                   |   3 -
 arch/arm/common/edma.c                          | 197 ++++---
 arch/arm/mach-davinci/devices-da8xx.c           |  31 --
 arch/arm/mach-davinci/dm355.c                   |  14 -
 arch/arm/mach-davinci/dm365.c                   |  16 -
 arch/arm/mach-davinci/dm644x.c                  |  14 -
 arch/arm/mach-davinci/dm646x.c                  |  16 -
 arch/arm/mach-exynos/Makefile                   |   1 -
 arch/arm/mach-exynos/common.h                   |   2 +
 arch/arm/mach-exynos/cpuidle.c                  | 255 ---------
 arch/arm/mach-exynos/exynos.c                   |   8 +-
 arch/arm/mach-exynos/platsmp.c                  |   2 +-
 arch/arm/mach-exynos/pm.c                       | 152 +++++-
 arch/arm/mach-exynos/regs-pmu.h                 |   2 -
 drivers/Kconfig                                 |   2 +
 drivers/Makefile                                |   3 +
 drivers/bus/Kconfig                             |   8 +
 drivers/bus/Makefile                            |   1 +
 drivers/bus/brcmstb_gisb.c                      | 289 ++++++++++
 drivers/bus/omap_l3_noc.c                       | 406 ++++++++------
 drivers/bus/omap_l3_noc.h                       | 545 ++++++++++++++-----
 drivers/clk/samsung/clk-exynos5250.c            |  42 ++
 drivers/clocksource/exynos_mct.c                |   8 +
 drivers/cpufreq/Kconfig.arm                     |   6 +-
 drivers/cpufreq/exynos-cpufreq.c                |   2 -
 drivers/cpufreq/exynos-cpufreq.h                |  30 +-
 drivers/cpufreq/exynos4210-cpufreq.c            |  39 +-
 drivers/cpufreq/exynos4x12-cpufreq.c            |  40 +-
 drivers/cpufreq/exynos5250-cpufreq.c            |  43 +-
 drivers/cpuidle/Kconfig.arm                     |   6 +
 drivers/cpuidle/Makefile                        |   1 +
 drivers/cpuidle/cpuidle-exynos.c                |  99 ++++
 drivers/dma/edma.c                              | 335 +++++++++---
 drivers/memory/mvebu-devbus.c                   | 229 +++++---
 drivers/power/reset/Kconfig                     |  15 +
 drivers/power/reset/Makefile                    |   2 +
 drivers/power/reset/keystone-reset.c            | 166 ++++++
 drivers/power/reset/sun6i-reboot.c              |  85 +++
 drivers/reset/Makefile                          |   1 +
 drivers/reset/reset-socfpga.c                   | 146 +++++
 drivers/reset/reset-sunxi.c                     |  21 +-
 drivers/soc/Kconfig                             |   5 +
 drivers/soc/Makefile                            |   5 +
 drivers/soc/qcom/Kconfig                        |  11 +
 drivers/soc/qcom/Makefile                       |   1 +
 drivers/soc/qcom/qcom_gsbi.c                    |  85 +++
 drivers/tty/serial/msm_serial.c                 |  48 +-
 drivers/tty/serial/msm_serial.h                 |   5 -
 include/linux/platform_data/edma.h              |  28 +-
 58 files changed, 2605 insertions(+), 1062 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb
 create mode 100644 Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt
 create mode 100644 Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt
 create mode 100644 Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt
 delete mode 100644 arch/arm/mach-exynos/cpuidle.c
 create mode 100644 drivers/bus/brcmstb_gisb.c
 create mode 100644 drivers/cpuidle/cpuidle-exynos.c
 create mode 100644 drivers/power/reset/keystone-reset.c
 create mode 100644 drivers/power/reset/sun6i-reboot.c
 create mode 100644 drivers/reset/reset-socfpga.c
 create mode 100644 drivers/soc/Kconfig
 create mode 100644 drivers/soc/Makefile
 create mode 100644 drivers/soc/qcom/Kconfig
 create mode 100644 drivers/soc/qcom/Makefile
 create mode 100644 drivers/soc/qcom/qcom_gsbi.c
