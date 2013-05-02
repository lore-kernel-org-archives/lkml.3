Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3EBHFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:05:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:32807 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3EBHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:05:11 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/5] ARM: arm-soc platform updates for 3.10, part 1
Date: Wed,  1 May 2013 23:58:35 -0700
Message-Id: <1367477916-28399-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367477916-28399-1-git-send-email-olof@lixom.net>
References: <1367477916-28399-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains platform updates for 3.10. Among the highlights:

- Support for the new Atmel Cortex-A5 based platforms (SAMA5D3)
- New support for CSR SiRFatlas6 SoCs
- A handful of updates for NVidia T114 (a.k.a. Tegra 4)
- A bunch of updates for the shmobile platforms
- A handful of updates for davinci
- A few updates for Qualcomm MSM
- Plus a handful of other patches, defconfig updates, etc.


Conflicts:

Documentation/kernel-parameters.txt: Trivial add/add conflict

arch/arm/mach-exynos/cpuidle.c: Add/remove conflict. Take away the
"en_core_tk_irqen" line but keep the rest of the branch contents.

----------------------------------------------------------------

The following changes since commit 429b8d7cfc7394dd040525e963e3f08df478477c:

  Merge branch 'next/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to e0d20b69d3fa74a21ec363989612bddd58b930b8:

  Merge branch 'gic/cleanup' into next/soc

----------------------------------------------------------------

Arnd Bergmann (15):
      Merge branch 'prima2/soc' into next/soc
      Merge tag 'ux500-defconfig-v3.10' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge tag 'ux500-core-v3.10' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge tag 'renesas-defconfig-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'omap-for-v3.10/crypto-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'bcm2835-for-3.10-defconfig' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge tag 'davinci-for-v3.10/soc' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'davinci-for-v3.10/dt' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge branch 'tegra/cleanup' into next/soc
      Merge tag 'tegra-for-3.10-soc' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'mxs-soc-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'omap-for-v3.10/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'tegra-for-3.10-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'devel-samsung-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/soc

Artem Bityutskiy (1):
      ARM: LPC32xx: defconfig update: Remove the museum NAND option

Barry Song (2):
      arm: prima2: add new SiRFatlas6 machine in common board
      ARM/dts: prima2: add .dtsi for atlas6 and .dts for atla6-evb board

Bastian Hecht (1):
      ARM: mach-shmobile: r8a7740: Add DT names to clock list

Charles Keepax (2):
      ARM: S3C64XX: Clear DMA flags on channel request
      ARM: S3C64XX: Slow down mic detection rate for wm5102

Christian Daudt (1):
      ARM: bcm281xx: Add timer driver (DT portion)

Daniel Lezcano (3):
      ARM: EXYNOS: factor out the idle states
      ARM: EXYNOS: handle properly the return values
      ARM: EXYNOS: replace cpumask by the corresponding macro

Danny Huang (2):
      ARM: tegra: expose chip ID and revision
      ARM: tegra: add speedo-based process id for Tegra114

Dinh Nguyen (3):
      ARM: socfpga: Enable soft reset
      ARM: socfpga: Add clock entries into device tree
      ARM: socfpga: Upgrade clk driver for socfpga to make use of dts clock entries

Fabio Estevam (4):
      ARM: mxs: Select ARM_CPU_SUSPEND
      ARM: mxs_defconfig: Build CONFIG_INPUT_EVDEV as built-in
      ARM: mxs_defconfig: Select CONFIG_MMC_UNSAFE_RESUME
      ARM: mxs_defconfig: Select watchdog driver

Guennadi Liakhovetski (2):
      ARM: shmobile: add MMCIF and SDHI DT clock aliases to sh73a0 and r8a7740
      ARM: shmobile: sh73a0: fix Z and ZG clock hierarchy

Hongbo Zhang (1):
      ARM: ux500: enable ux500 EXT4_FS and LBDAF support by default

Inderpal Singh (2):
      ARM: EXYNOS: Add support for rtc wakeup
      ARM: SAMSUNG: check processor type before cache restoration in resume

Jonathan Kliegman (2):
      ARM: EXYNOS: Remove hardcode wakeup unmask for EINT_0
      ARM: EXYNOS: Clear ENABLE_WAKEUP_SW bit when entering suspend

Joseph Lo (9):
      ARM: tegra: bring up secondary CPU for Tegra114
      ARM: tegra: add clock source of PMC to device trees
      ARM: tegra: moving the CPU power timer function to PMC driver
      gpio: tegra: add gpio wakeup source handling
      ARM: tegra: irq: add wake up handling
      ARM: dt: tegra: add bindings of power management configurations for PMC
      ARM: tegra: pm: add platform suspend support
      ARM: tegra: cpuidle: remove redundant parameters for powered-down mode
      ARM: tegra: pm: fix build error w/o PM_SLEEP

Kuninori Morimoto (9):
      ARM: shmobile: add gic_iid macro for ICCIAR / interrupt ID
      ARM: shmobile: r8a7779: fixup dtsi typo
      ARM: shmobile: r8a7779: fixup DT machine name
      ARM: shmobile: r8a7779: use gic_iid macro
      ARM: shmobile: tidyup chip series definition order for r8a7740/r8a7779
      ARM: shmobile: r8a7779: add Thermal support on DT
      ARM: shmobile: armadillo800eva: enable branch prediction on defconfig
      ARM: shmobile: armadillo800eva: enable NEON on defconfig
      ARM: shmobile: armadillo800eva: enable all errata for cache on defconfig

Lee Jones (1):
      ARM: ux500: Turn on the 'heartbeat' LED trigger

Linus Walleij (1):
      ARM: ux500: bump arch nr of GPIOs

Ludovic Desroches (6):
      ARM: at91: change name template in AT91_SOC_START macro
      ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
      ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
      ARM: at91: introduce SAMA5 support
      ARM: at91: dt: add device tree files for SAMA5D3 family
      ARM: at91: add defconfig for SAMA5

Magnus Damm (21):
      ARM: shmobile: Remove unused headers from hotplug.c
      ARM: shmobile: Remove partial CPU Hotplug from EMEV2
      ARM: shmobile: Move EMEV2 CPU boot vector setup code
      ARM: shmobile: Remove sh73a0_get_core_count()
      ARM: shmobile: Remove r8a7779_get_core_count()
      ARM: shmobile: Remove emev2_get_core_count()
      ARM: shmobile: Kill off sh73a0 scu_base_addr() function
      ARM: shmobile: Kill off r8a7779 scu_base_addr() function
      ARM: shmobile: Rework EMEV2 scu_base variable
      ARM: shmobile: Move headsmp-sh73a0.S to headsmp-scu.S
      ARM: shmobile: Common shmobile_scu_base in headsmp-scu.S
      ARM: shmobile: Update EMEV2 to use scu_power_mode()
      ARM: shmobile: Make EMEV2 setup functions static
      ARM: shmobile: Fix base address readout in headsmp-scu.S
      ARM: shmobile: Rework SH73A0_SCU_BASE IOMEM() usage
      ARM: shmobile: Use R8A7779_SCU_BASE with TWD
      ARM: shmobile: Update r8a7779 to check SCU for hotplug
      ARM: shmobile: Update r8a7779 to use scu_power_mode()
      ARM: shmobile: Use sh73a0-specific cpu disable code
      ARM: shmobile: Rearrange r8a7779 cpu hotplug code
      ARM: shmobile: Remove unused hotplug.c

Manjunathappa, Prakash (4):
      ARM: davinci: mmc: derive version information from device name
      mmc: davinci_mmc: add DT support
      ARM: davinci: da850: add mmc DT entries
      ARM: davinci: da850: override mmc DT node device name

Mark A. Greer (13):
      ARM: OMAP2xxx: hwmod: Convert SHAM crypto device data to hwmod
      ARM: OMAP2xxx: hwmod: Add DMA support for SHAM module
      ARM: OMAP3xxx: hwmod: Convert SHAM crypto device data to hwmod
      ARM: OMAP2+: Remove unnecessary message when no SHA IP is present
      ARM: OMAP2+: Only manually add hwmod data when DT not used.
      ARM: AM33XX: Add sha0 crypto clock data
      ARM: AM33XX: hwmod: Update and uncomment SHA0 module data
      ARM: OMAP2xxx: hwmod: Convert AES crypto devcie data to hwmod
      ARM: OMAP3xxx: hwmod: Convert AES crypto device data to hwmod
      ARM: OMAP2+: Remove unnecessary message when no AES IP is present
      ARM: OMAP2+: Only manually add hwmod data when DT not used.
      ARM: AM33XX: Add aes0 crypto clock data
      ARM: AM33XX: hwmod: Update and uncomment AES0 module data

Maxime Coquelin (1):
      ARM: mach-ux500: enable 128KB way L2 cache on DB8540

Olof Johansson (6):
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into next/soc
      Merge tag 'renesas-defconfig2-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'lpc32xx/defconfig' of git://git.antcom.de/linux-2.6 into next/soc
      Merge tag 'msm-core-3.10' of git://git.kernel.org/.../davidb/linux-msm into next/soc
      Merge tag 'davinci-for-v3.10/soc-2-v2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge branch 'gic/cleanup' into next/soc

Paul Bolle (1):
      ARM: davinci: remove test for undefined Kconfig macro

Phil Edworthy (1):
      r8a7779: Add Display Unit clock support

Philip Avinash (2):
      ARM: davinci: clk framework support for enable/disable functionality
      ARM: davinci: da850: add ECAP & EHRPWM clock nodes

Robert Tivy (1):
      ARM: davinci: da8xx: add remoteproc support

Roland Stigge (3):
      ARM: LPC32xx: defconfig update: gpio and keys
      ARM: LPC32xx: defconfig update: Default drivers and cleanup
      ARM: LPC32xx: defconfig update: Cleanup (EXPERIMENTAL)

Ruslan Bilovol (3):
      ARM: OMAP2+: Move common part of late init into common function
      ARM: OMAP2+: SoC name and revision unification
      ARM: OMAP2+: Export SoC information to userspace

Sekhar Nori (3):
      ARM: davinci: da8xx dt: make file local symbols static
      ARM: davinci: sram.c: fix incorrect type in assignment
      ARM: davinci: ensure global variables are declared

Sergei Shtylyov (1):
      ARM: shmobile: R8A7779: use gic_iid() in SATA IRQ resource

Simon Horman (17):
      ARM: mach-shmobile: r8a7779: Allow initialisation of GIC by DT
      ARM: mach-shmobile: r8a7779: Minimal setup using DT
      ARM: shmobile: sh73a0: Remove sh73a0_init_irq_dt()
      ARM: shmobile: sh73a0: Add smp ops to DT_MACHINE_START
      ARM: shmobile: sh73a0: Remove warning about SMP
      ARM: shmobile: sh73a0: Do not use early devices with DT reference
      ARM: shmobile: r8a7779: Do not use early devices with DT reference
      ARM: shmobile: r8a7779: Do not initialise i2c as an early device
      ARM: shmobile: r8a7779: Remove lan from dtsi
      ARM: mach-shmobile: mackerel: enable MMCIF and SDHI in defconfig
      ARM: mach-shmobile: mackerel: enable REGULATOR in defconfig
      ARM: mach-shmobile: armadillo800eva: enable REGULATOR in defconfig
      ARM: shmobile: kzm9g: defconfig: do not enable PREEMPT
      ARM: mach-shmobile: kzm9g: do not enable REGULATOR_DUMMY in defconfig
      ARM: shmobile: marzen: defconfig: add GPIO RCAR driver support
      ARM: shmobile: marzen: defconfig: enable GPIO LEDs driver
      ARM: shmobile: ape6evm: add defconfig

Sricharan R (1):
      ARM: OMAP4: Enable fix for Cortex-A9 erratas

Stephen Boyd (2):
      ARM: msm: Rework timer binding to be more general
      ARM: msm: Wait for timer clear to complete

Stephen Warren (2):
      ARM: bcm2835: defconfig updates
      ARM: tegra: defconfig updates

Sylwester Nawrocki (1):
      ARM: SAMSUNG: Export MIPI CSIS/DSIM PHY control functions

Tony Lindgren (1):
      Merge tag 'omap-devel-a-for-3.10' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.10/crypto

Vishwanathrao Badarkhe, Manish (2):
      ARM: regulator: add tps6507x device tree data
      ARM: davinci: da850: add tps6507x regulator DT data

Vladimir Barinov (3):
      ARM: mach-shmobile: r8a7779: SATA DT configuration
      ARM: mach-shmobile: r8a7779: add SATA support
      ARM: mach-shmobile: marzen: add SATA support

Wei Yongjun (1):
      ARM: tegra: pm: remove duplicated include from pm.c


 .../bindings/arm/altera/socfpga-clk-manager.txt |   11 +
 .../bindings/arm/bcm/bcm,kona-timer.txt         |   19 +
 .../devicetree/bindings/arm/msm/timer.txt       |   41 +-
 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt   |   67 +-
 .../devicetree/bindings/clock/altr_socfpga.txt  |   18 +
 .../devicetree/bindings/mmc/davinci_mmc.txt     |   33 +
 Documentation/kernel-parameters.txt             |    6 +
 arch/arm/Kconfig                                |    3 +-
 arch/arm/boot/dts/Makefile                      |    5 +
 arch/arm/boot/dts/atlas6-evb.dts                |   78 ++
 arch/arm/boot/dts/atlas6.dtsi                   |  668 ++++++++++++
 arch/arm/boot/dts/bcm11351.dtsi                 |    8 +
 arch/arm/boot/dts/da850-evm.dts                 |   70 ++
 arch/arm/boot/dts/da850.dtsi                    |   15 +
 arch/arm/boot/dts/msm8660-surf.dts              |   20 +-
 arch/arm/boot/dts/msm8960-cdp.dts               |   22 +-
 arch/arm/boot/dts/r8a7779.dtsi                  |   98 ++
 arch/arm/boot/dts/sama5d3.dtsi                  | 1031 ++++++++++++++++++
 arch/arm/boot/dts/sama5d31ek.dts                |   51 +
 arch/arm/boot/dts/sama5d33ek.dts                |   44 +
 arch/arm/boot/dts/sama5d34ek.dts                |   61 ++
 arch/arm/boot/dts/sama5d35ek.dts                |   56 +
 arch/arm/boot/dts/sama5d3xcm.dtsi               |   91 ++
 arch/arm/boot/dts/sama5d3xdm.dtsi               |   42 +
 arch/arm/boot/dts/sama5d3xmb.dtsi               |  166 +++
 arch/arm/boot/dts/socfpga.dtsi                  |  157 +++
 arch/arm/boot/dts/socfpga_cyclone5.dts          |    8 +
 arch/arm/boot/dts/socfpga_vt.dts                |    8 +
 arch/arm/boot/dts/tegra114-dalmore.dts          |   13 +
 arch/arm/boot/dts/tegra114-pluto.dts            |   13 +
 arch/arm/boot/dts/tegra114.dtsi                 |    2 +
 arch/arm/boot/dts/tegra20-colibri-512.dtsi      |   13 +
 arch/arm/boot/dts/tegra20-harmony.dts           |   13 +
 arch/arm/boot/dts/tegra20-paz00.dts             |   13 +
 arch/arm/boot/dts/tegra20-seaboard.dts          |   13 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |   13 +
 arch/arm/boot/dts/tegra20-trimslice.dts         |   13 +
 arch/arm/boot/dts/tegra20-ventana.dts           |   13 +
 arch/arm/boot/dts/tegra20-whistler.dts          |   13 +
 arch/arm/boot/dts/tegra20.dtsi                  |    2 +
 arch/arm/boot/dts/tegra30-beaver.dts            |   13 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |   13 +
 arch/arm/boot/dts/tegra30.dtsi                  |    2 +
 arch/arm/boot/dts/tps6507x.dtsi                 |   47 +
 arch/arm/configs/ape6evm_defconfig              |   95 ++
 arch/arm/configs/armadillo800eva_defconfig      |    8 +-
 arch/arm/configs/bcm2835_defconfig              |    9 +-
 arch/arm/configs/kzm9g_defconfig                |    2 -
 arch/arm/configs/lpc32xx_defconfig              |   21 +-
 arch/arm/configs/mackerel_defconfig             |    4 +
 arch/arm/configs/marzen_defconfig               |    8 +
 arch/arm/configs/mxs_defconfig                  |    5 +-
 arch/arm/configs/sama5_defconfig                |  181 +++
 arch/arm/configs/tegra_defconfig                |   18 +-
 arch/arm/configs/u8500_defconfig                |    4 +-
 arch/arm/mach-at91/Kconfig                      |   59 +-
 arch/arm/mach-at91/Makefile                     |    7 +-
 arch/arm/mach-at91/at91rm9200.c                 |    2 +-
 arch/arm/mach-at91/at91sam9260.c                |    2 +-
 arch/arm/mach-at91/at91sam9261.c                |    2 +-
 arch/arm/mach-at91/at91sam9263.c                |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                |    2 +-
 arch/arm/mach-at91/at91sam9n12.c                |    2 +-
 arch/arm/mach-at91/at91sam9rl.c                 |    2 +-
 arch/arm/mach-at91/at91sam9x5.c                 |    2 +-
 arch/arm/mach-at91/board-dt-sama5.c             |   86 ++
 arch/arm/mach-at91/clock.c                      |  109 +-
 arch/arm/mach-at91/clock.h                      |    2 +
 arch/arm/mach-at91/include/mach/at91_pmc.h      |   18 +-
 arch/arm/mach-at91/include/mach/cpu.h           |   20 +
 arch/arm/mach-at91/include/mach/sama5d3.h       |   73 ++
 arch/arm/mach-at91/sama5d3.c                    |  377 +++++++
 arch/arm/mach-at91/setup.c                      |   27 +
 arch/arm/mach-at91/soc.h                        |    7 +-
 arch/arm/mach-davinci/board-da830-evm.c         |    1 -
 arch/arm/mach-davinci/board-da850-evm.c         |    2 -
 arch/arm/mach-davinci/board-dm355-evm.c         |    1 -
 arch/arm/mach-davinci/board-dm365-evm.c         |    1 -
 arch/arm/mach-davinci/board-dm644x-evm.c        |    1 -
 arch/arm/mach-davinci/board-neuros-osd2.c       |    1 -
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    1 -
 arch/arm/mach-davinci/board-tnetv107x-evm.c     |    1 -
 arch/arm/mach-davinci/clock.c                   |   21 +-
 arch/arm/mach-davinci/clock.h                   |    2 +
 arch/arm/mach-davinci/da830.c                   |    2 +-
 arch/arm/mach-davinci/da850.c                   |   50 +-
 arch/arm/mach-davinci/da8xx-dt.c                |    5 +-
 arch/arm/mach-davinci/devices-da8xx.c           |   92 +-
 arch/arm/mach-davinci/devices-tnetv107x.c       |    4 +-
 arch/arm/mach-davinci/devices.c                 |    6 +-
 arch/arm/mach-davinci/dm355.c                   |    4 +-
 arch/arm/mach-davinci/dm365.c                   |    4 +-
 arch/arm/mach-davinci/dm644x.c                  |    2 +-
 arch/arm/mach-davinci/include/mach/da8xx.h      |    5 +
 .../arm/mach-davinci/include/mach/debug-macro.S |    2 -
 arch/arm/mach-davinci/pm.c                      |    1 +
 arch/arm/mach-davinci/sram.c                    |    4 +-
 arch/arm/mach-davinci/tnetv107x.c               |    4 +-
 arch/arm/mach-davinci/usb.c                     |    1 +
 arch/arm/mach-exynos/common.c                   |    2 +
 arch/arm/mach-exynos/cpuidle.c                  |   58 +-
 arch/arm/mach-exynos/include/mach/pm-core.h     |    9 +-
 arch/arm/mach-msm/timer.c                       |  110 +-
 arch/arm/mach-mxs/Kconfig                       |    2 +
 arch/arm/mach-omap2/Kconfig                     |    3 +
 arch/arm/mach-omap2/cclock2430_data.c           |    4 +-
 arch/arm/mach-omap2/cclock33xx_data.c           |   10 +
 arch/arm/mach-omap2/cclock3xxx_data.c           |    2 +
 arch/arm/mach-omap2/common.h                    |    8 +
 arch/arm/mach-omap2/devices.c                   |  149 +--
 arch/arm/mach-omap2/id.c                        |   95 +-
 arch/arm/mach-omap2/io.c                        |   34 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |    2 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |    2 +
 .../omap_hwmod_2xxx_interconnect_data.c         |   36 +
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |   81 ++
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c      |   92 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |  172 ++-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |    4 +
 arch/arm/mach-prima2/Kconfig                    |   10 +-
 arch/arm/mach-prima2/common.c                   |   21 +
 arch/arm/mach-s3c64xx/dma.c                     |    1 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c    |    1 +
 arch/arm/mach-shmobile/Makefile                 |    7 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   13 +
 arch/arm/mach-shmobile/clock-r8a7779.c          |    8 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |    7 +-
 .../{headsmp-sh73a0.S => headsmp-scu.S}         |   15 +-
 arch/arm/mach-shmobile/hotplug.c                |   68 --
 arch/arm/mach-shmobile/include/mach/common.h    |   21 +-
 arch/arm/mach-shmobile/include/mach/irqs.h      |    1 +
 arch/arm/mach-shmobile/intc-r8a7779.c           |   27 +-
 arch/arm/mach-shmobile/intc-sh73a0.c            |    8 -
 arch/arm/mach-shmobile/setup-emev2.c            |    4 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |  104 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |   36 +-
 arch/arm/mach-shmobile/smp-emev2.c              |   86 +-
 arch/arm/mach-shmobile/smp-r8a7779.c            |  129 ++-
 arch/arm/mach-shmobile/smp-sh73a0.c             |   36 +-
 arch/arm/mach-socfpga/core.h                    |   11 +
 arch/arm/mach-socfpga/platsmp.c                 |    3 -
 arch/arm/mach-socfpga/socfpga.c                 |   16 +-
 arch/arm/mach-tegra/Makefile                    |    1 +
 arch/arm/mach-tegra/common.c                    |    5 +-
 arch/arm/mach-tegra/cpuidle-tegra20.c           |    6 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c           |    6 +-
 arch/arm/mach-tegra/fuse.c                      |    4 +
 arch/arm/mach-tegra/fuse.h                      |    7 +
 arch/arm/mach-tegra/irq.c                       |   96 +-
 arch/arm/mach-tegra/irq.h                       |    6 +
 arch/arm/mach-tegra/platsmp.c                   |    8 +
 arch/arm/mach-tegra/pm.c                        |  131 ++-
 arch/arm/mach-tegra/pm.h                        |   17 +-
 arch/arm/mach-tegra/pmc.c                       |  162 +++
 arch/arm/mach-tegra/pmc.h                       |   14 +
 arch/arm/mach-tegra/tegra.c                     |   29 +-
 arch/arm/mach-tegra/tegra114_speedo.c           |  104 ++
 arch/arm/mach-ux500/cache-l2x0.c                |    4 +-
 arch/arm/plat-samsung/s5p-sleep.S               |    9 +
 arch/arm/plat-samsung/setup-mipiphy.c           |    3 +
 drivers/clk/socfpga/clk.c                       |  163 ++-
 drivers/gpio/gpio-tegra.c                       |   21 +-
 drivers/mmc/host/davinci_mmc.c                  |   88 +-
 include/linux/platform_data/mmc-davinci.h       |    3 -
 164 files changed, 6029 insertions(+), 846 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm,kona-timer.txt
 create mode 100644 Documentation/devicetree/bindings/clock/altr_socfpga.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
 create mode 100644 arch/arm/boot/dts/atlas6-evb.dts
 create mode 100644 arch/arm/boot/dts/atlas6.dtsi
 create mode 100644 arch/arm/boot/dts/r8a7779.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d31ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d33ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d34ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d35ek.dts
 create mode 100644 arch/arm/boot/dts/sama5d3xcm.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3xdm.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d3xmb.dtsi
 create mode 100644 arch/arm/boot/dts/tps6507x.dtsi
 create mode 100644 arch/arm/configs/ape6evm_defconfig
 create mode 100644 arch/arm/configs/sama5_defconfig
 create mode 100644 arch/arm/mach-at91/board-dt-sama5.c
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d3.h
 create mode 100644 arch/arm/mach-at91/sama5d3.c
 rename arch/arm/mach-shmobile/{headsmp-sh73a0.S => headsmp-scu.S} (85%)
 delete mode 100644 arch/arm/mach-shmobile/hotplug.c
 create mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
