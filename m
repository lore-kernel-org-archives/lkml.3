Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3EBHGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:06:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52185 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3EBHFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:05:07 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/5] ARM: arm-soc cleanup for 3.10
Date: Wed,  1 May 2013 23:58:33 -0700
Message-Id: <1367477916-28399-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367477916-28399-1-git-send-email-olof@lixom.net>
References: <1367477916-28399-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a collection of cleanup patches. Among the pieces that stand out are:

- The deletion of h720x platforms
- Split of at91 non-dt platforms to their own Kconfig file to keep them separate
- General cleanups and refactoring of i.MX and MXS platforms
- Some restructuring of clock tables for OMAP
- Convertion of PMC driver for Tegra to dt-only
- Some renames of sunxi -> sun4i (Allwinner A10)
- ... plus a bunch of other stuff that I haven't mentioned


Conflicts:

arch/arm/Kconfig: remove/remove conflict. Both sides should be
removed. There seems to be some dangling use of the SA11x0 options in
cpufreq that should be removed though (separate issue).

drivers/gpio/gpio-pl061.c: Add/add conflict, keep both

drivers/usb/host/ohci-exynos.c: Change/remove. Take out the newline
and the plat/* include.

arch/arm/mach-imx/cpufreq.c: Remove/remove conflict. Drop the file.

----------------------------------------------------------------

The following changes since commit 300aff2eea4843557709f479a2efa753aa53caf5:

  Merge branch 'next/fixes-non-critical' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to afcf7924ecab726dab0227188783c4a40d9f0eec:

  Merge branch 'fixes' into next/cleanup

----------------------------------------------------------------

Alexander Shiyan (3):
      ARM: S3C24XX: Removed unneeded dependency on ARCH_S3C24XX for boards
      ARM: S3C24XX: Removed unneeded dependency on CPU_S3C2410
      ARM: S3C24XX: Removed unneeded dependency on CPU_S3C2412

Arnd Bergmann (18):
      ARM: gemini: get platform to build again
      Merge branch 'next/cleanup-s3c' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/cleanup-s5p' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'clksrc-cleanup-for-3.10' of git://sources.calxeda.com/kernel/linux into next/cleanup
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'cleanup_for_v3.10' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      ARM: l7200: remove zombie file
      ARM: kill Hynix h720x platform
      clocksource: make CLOCKSOURCE_OF_DECLARE type safe
      Merge tag 'omap-for-v3.10/cleanup-v2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.10/fixes-pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'tegra/fixes' into next/cleanup
      Merge tag 'tegra-for-3.10-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'v3.9-rc5' into next/cleanup
      Merge tag 'mxs-cleanup-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'cleanup-samsung-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'next/spring-cleaning' into next/cleanup

Catalin Marinas (4):
      arm: Move the set_handle_irq and handle_arch_irq declarations to asm/irq.h
      arm: Move chained_irq_(enter|exit) to a generic file
      irqchip: gic: Call handle_bad_irq() directly
      irqchip: gic: Perform the gic_secondary_init() call via CPU notifier

Fabio Estevam (3):
      ARM: imx: avic: Move avic_saved_mask_reg under CONFIG_PM
      ARM: imx: clk-imx27: Do not register peripheral clock for SSI
      clocksource: mxs_timer: Add semicolon at end of line

Heiko Stuebner (3):
      ARM: S3C24XX: remove plat/irq.h in plat-samsung
      ARM: S3C24XX: move plat-samsung/s3c24XX headers to local common.h
      ARM: S3C24XX: cleanup the included soc init functions in common.h

Hiroshi Doyu (4):
      ARM: tegra: Unify tegra{20,30,114}_init_early()
      ARM: tegra: Rename board-dt-tegra20.c to tegra.c
      ARM: tegra: Unify Device tree board files
      ARM: tegra: refactor tegra{20,30}_boot_secondary

J Keerthy (1):
      ARM: OMAP2+: clock data: Remove CK_* flags

Jarkko Nikula (2):
      ARM: OMAP1: Remove unused DMA channel definitions
      ARM: OMAP2+: Remove unused DMA channel definitions

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91: move non DT Kconfig to Kconfig.non_dt
      ARM: at91: rename board-dt to more specific name board-dt-sam9
      ARM: at91: renamme rm9200 dt file

Jingoo Han (1):
      ARM: EXYNOS: change the name of USB ohci header

Johan Hovold (2):
      ARM: at91/setup: fix trivial typos
      ARM: at91: remove trailing semicolon from macros

Joseph Lo (5):
      ARM: tegra: pmc: add specific compatible DT string for Tegra30 and Tegra114
      ARM: tegra: fix the PMC compatible string in DT
      ARM: tegra: pmc: convert PMC driver to support DT only
      ARM: tegra: pmc: add power on function for secondary CPUs
      ARM: tegra: replace the CPU power on function with PMC call

Kukjin Kim (4):
      mmc: s3cmci: moved mach/regs-sdi.h into s3cmci device driver
      ARM: S3C24XX: plat/common-smdk.h local
      ARM: S5PC100: remove useless ifdef in common.h
      ARM: S5PV210: remove useless ifdef in common.h

Markus Pargmann (1):
      ARM: imx: Remove cpufreq driver

Maxime Ripard (10):
      ARM: at91: Fix typo in restart code panic message
      ARM: irq: Call irqchip_init if no init_irq function is specified
      Merge remote-tracking branch 'arm-soc/clksrc/cleanup' into sunxi/core-for-3.10
      Merge remote-tracking branch 'clk/clk-for-3.10' into sunxi/core-for-3.10
      clocksource: sunxi: Cleanup the timer code
      clocksource: sunxi: make use of CLKSRC_OF
      clocksource: sunxi: Rename sunxi to sun4i
      irqchip: sunxi: Make use of the IRQCHIP_DECLARE macro
      irqchip: sunxi: Rename sunxi to sun4i
      ARM: sunxi: Rework the restart code

Nicolas Ferre (1):
      ARM: at91: remove unused dbgu_readl() macro

Olof Johansson (9):
      Merge branch 'gic' of git://git.kernel.org/.../cmarinas/linux-aarch64 into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      irqchip: vic: add include of linux/irq.h
      Merge branch 'gic/cleanup' into next/cleanup
      Merge tag 'imx-cleanup-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge branch 'depends/clk-for-3.10' into next/cleanup
      Merge tag 'sunxi-cleanup-for-3.10' of git://github.com/mripard/linux into next/cleanup
      Merge tag 'msm-cleanup-3.10' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge branch 'fixes' into next/cleanup

Padmavathi Venna (1):
      ARM: SAMSUNG: Remove unnecessary code for dma

Paul Bolle (12):
      ARM: S3C24XX: drop "select MACH_N35"
      ARM: S3C24XX: drop "select MACH_NEO1973"
      ARM: EXYNOS: drop "select HAVE_SCHED_CLOCK"
      ARM: EXYNOS: change HAVE_SAMSUNG_KEYPAD to KEYBOARD_SAMSUNG
      ARM: SAMSUNG: remove "config S3C_BOOT_WATCHDOG"
      ARM: SAMSUNG: Remove useless Samsung GPIO related CONFIG
      ARM: S3C24XX: remove unneeded "config SMDK2440_CPU2442"
      ARM: S3C64XX: remove obsolete Makefile line
      ARM: S5P64X0: Fix typo "CONFIG_S5P64X0_SETUP_SDHCI"
      ARM: SAMSUNG: Fix typo "CONFIG_SAMSUNG_DEV_RTC"
      ARM: EXYNOS: remove "config EXYNOS_DEV_DRM"
      ARM: i.MX: remove unused ARCH_* configs

Peter De Schrijver (1):
      clocksource: tegra: move to of_clk_get

Rob Herring (4):
      clocksource: add empty version of clocksource_of_init
      clocksource: pass DT node pointer to init functions
      clocksource: tegra20: use the device_node pointer passed to init
      ARM: smp_twd: convert to use CLKSRC_OF init

Sachin Kamat (1):
      irqchip: irq-gic: Fix checkpatch errors

Santosh Shilimkar (9):
      ARM: OMAP2+: PM: Remove bogus fiq_[enable/disable] tuple
      ARM: OMAP4+: Remove the un-necessary cache flush from hotplug code
      ARM: OMAP4+: Remove un-necessary cacheflush in secondary CPU boot path
      ARM: OMAP4+: Remove out of placed smp_wmb() in secondary wakeup code
      ARM: OMAP4+: Move the CPU wakeup prepare code under smp_prepare_cpus()
      ARM: OMAP4: PM: Remove L4 wakeup depedency with MPU since errata fix exist now
      ARM: OMAP4: PM: Now remove L4 per clockdomain static depedency with MPU
      ARM: OMAP4: Fix the init code to have OMAP4460 errata available in DT build
      ARM: OMAP4+: PM: Restore CPU power state to ON with clockdomain force wakeup method

Sascha Hauer (1):
      ARM i.MX53: remove platform ahci support

Shawn Guo (30):
      ARM: imx: remove duplicated function declaration
      ARM: imx: remove pl310_get_save_ptr() declaration
      Merge remote-tracking branch 'arm-soc/clksrc/cleanup' into mxs/cleanup
      ARM: mxs: use CLKSRC_OF helper to initialize timer
      ARM: mxs: look up timrot clock from device tree
      ARM: mxs: get timrot base address from device tree
      ARM: mxs: remove cpu_is_mx23() call from timer code
      ARM: mxs: select STMP_DEVICE and use it for timer code
      ARM: mxs: move timer driver into drivers/clocksource
      ARM: mxs: get icoll base address from device tree
      ARM: mxs: call stmp_reset_block() in icoll
      ARM: mxs: move icoll driver into drivers/irqchip
      ARM: mxs: remove unneeded mach-types.h inclusion
      clk: mxs: get base address from device tree
      clk: mxs: remove the use of mach level IO accessor
      rtc: stmp3xxx: use stmp_reset_block() instead
      iio: mxs-lradc: remove unneeded mach header inclusion
      ASoC: mxs-saif: remove mach header inclusion
      ARM: mxs: remove empty hardware.h
      ARM: mxs: get reset address from device tree
      ARM: mxs: remove system.c
      ARM: mxs: get ocotp base address from device tree
      ARM: mxs: use debug_ll_io_init for low-level debug
      ARM: mxs: remove mm.c
      ARM: mxs: move mxs_get_ocotp() into mach-mxs.c
      ARM: mxs: remove common.h
      ARM: mxs: merge imx23 and imx28 into one machine_desc
      ARM: mxs: remove unused headers
      ARM: imx: remove Makefile.boot
      ARM: imx: remove mx6q.h

Stephen Boyd (4):
      ARM: msm: Move dma.h #defines that are private to dma.c
      mmc: msm_sdcc: Remove unnecessary include
      gpio: Make gpio-msm-v1 into a platform driver
      ARM: msm: Remove unused cpu.h header file

Sylwester Nawrocki (1):
      ARM: S3C24XX: Remove unused GPIO drive strength register definitions

Tero Kristo (1):
      ARM: OMAP4+: Use common scratchpad SAR RAM offsets for all architectures

Thomas Petazzoni (3):
      arm: plat-orion: only build addr-map.c when needed
      arm: plat-orion: use mv_mbus_dram_info() in PCIe code
      arm: mach-orion5x: use mv_mbus_dram_info() in PCI code

Tony Lindgren (3):
      Merge tag 'omap-cleanup-a-for-3.10' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.10/cleanup
      Merge branch 'for_3.10/omap_generic_cleanup_v2' of git://git.kernel.org/.../ssantosh/linux into omap-for-v3.10/cleanup-v2
      Merge tag 'omap-pm-v3.10/fixes/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.10/fixes-pm

Wei Yongjun (1):
      ARM: EXYNOS: remove duplicated include from common.c

Will Deacon (1):
      ARM: tegra: use setup_mm_for_reboot rather than explicit pgd switch


 ...nner,sunxi-ic.txt => allwinner,sun4i-ic.txt} |   4 +-
 ...unxi-timer.txt => allwinner,sun4i-timer.txt} |   4 +-
 .../watchdog/{sunxi-wdt.txt => sun4i-wdt.txt}   |   6 +-
 arch/arm/Kconfig                                |  22 +-
 arch/arm/Makefile                               |   1 -
 arch/arm/boot/dts/imx23.dtsi                    |   5 +-
 arch/arm/boot/dts/imx28.dtsi                    |   5 +-
 arch/arm/boot/dts/tegra114.dtsi                 |   2 +-
 arch/arm/boot/dts/tegra20.dtsi                  |   2 +
 arch/arm/boot/dts/tegra30.dtsi                  |   4 +-
 arch/arm/configs/at91_dt_defconfig              |   2 +-
 arch/arm/configs/at91sam9260_defconfig          |   2 +-
 arch/arm/configs/at91sam9g20_defconfig          |   2 +-
 arch/arm/configs/at91sam9g45_defconfig          |   2 +-
 arch/arm/configs/h7201_defconfig                |  27 -
 arch/arm/configs/h7202_defconfig                |  47 --
 arch/arm/include/asm/irq.h                      |   5 +
 arch/arm/include/asm/mach/irq.h                 |  36 -
 arch/arm/include/asm/smp_twd.h                  |   8 -
 arch/arm/kernel/irq.c                           |   6 +-
 arch/arm/kernel/smp_twd.c                       |  17 +-
 arch/arm/mach-at91/Kconfig                      | 398 +----------
 arch/arm/mach-at91/Kconfig.non_dt               | 399 +++++++++++
 arch/arm/mach-at91/Makefile                     |   4 +-
 arch/arm/mach-at91/at91_rstc.h                  |   2 +-
 arch/arm/mach-at91/at91_shdwc.h                 |   2 +-
 arch/arm/mach-at91/at91x40_time.c               |   2 +-
 .../{board-rm9200-dt.c => board-dt-rm9200.c}    |   0
 .../mach-at91/{board-dt.c => board-dt-sam9.c}   |   0
 arch/arm/mach-at91/gpio.c                       |   3 +-
 arch/arm/mach-at91/include/mach/at91_dbgu.h     |   3 -
 arch/arm/mach-at91/include/mach/at91_matrix.h   |   2 +-
 arch/arm/mach-at91/include/mach/at91_st.h       |   2 +-
 arch/arm/mach-at91/setup.c                      |   8 +-
 arch/arm/mach-exynos/Kconfig                    |  13 +-
 arch/arm/mach-exynos/common.c                   |   2 +-
 arch/arm/mach-exynos/dev-ohci.c                 |   2 +-
 arch/arm/mach-exynos/mach-origen.c              |   2 +-
 arch/arm/mach-exynos/mach-smdkv310.c            |   2 +-
 arch/arm/mach-exynos/platsmp.c                  |   8 -
 arch/arm/mach-gemini/Makefile                   |   2 +-
 arch/arm/mach-gemini/board-nas4220b.c           |   1 +
 arch/arm/mach-gemini/board-rut1xx.c             |   2 +
 arch/arm/mach-gemini/board-wbd111.c             |   1 +
 arch/arm/mach-gemini/board-wbd222.c             |   1 +
 arch/arm/mach-gemini/common.h                   |   2 +
 arch/arm/mach-gemini/gpio.c                     |  19 +-
 arch/arm/mach-gemini/include/mach/hardware.h    |   2 +-
 arch/arm/mach-gemini/irq.c                      |   4 +-
 arch/arm/mach-gemini/mm.c                       |  22 +-
 .../{include/mach/system.h => reset.c}          |   2 +-
 arch/arm/mach-h720x/Kconfig                     |  40 --
 arch/arm/mach-h720x/Makefile                    |  16 -
 arch/arm/mach-h720x/Makefile.boot               |   2 -
 arch/arm/mach-h720x/common.c                    | 268 --------
 arch/arm/mach-h720x/common.h                    |  30 -
 arch/arm/mach-h720x/cpu-h7201.c                 |  57 --
 arch/arm/mach-h720x/cpu-h7202.c                 | 225 ------
 arch/arm/mach-h720x/h7201-eval.c                |  38 -
 arch/arm/mach-h720x/h7202-eval.c                |  81 ---
 arch/arm/mach-h720x/include/mach/boards.h       |  53 --
 arch/arm/mach-h720x/include/mach/debug-macro.S  |  40 --
 arch/arm/mach-h720x/include/mach/entry-macro.S  |  57 --
 arch/arm/mach-h720x/include/mach/h7201-regs.h   |  67 --
 arch/arm/mach-h720x/include/mach/h7202-regs.h   | 155 -----
 arch/arm/mach-h720x/include/mach/hardware.h     | 190 -----
 arch/arm/mach-h720x/include/mach/irqs.h         | 116 ----
 arch/arm/mach-h720x/include/mach/isa-dma.h      |  19 -
 arch/arm/mach-h720x/include/mach/uncompress.h   |  36 -
 arch/arm/mach-highbank/highbank.c               |   5 +-
 arch/arm/mach-highbank/platsmp.c                |   7 -
 arch/arm/mach-imx/Kconfig                       |  18 -
 arch/arm/mach-imx/Makefile                      |   3 +-
 arch/arm/mach-imx/Makefile.boot                 |  35 -
 arch/arm/mach-imx/avic.c                        |   4 +-
 arch/arm/mach-imx/clk-imx27.c                   |   2 -
 arch/arm/mach-imx/common.h                      |   3 -
 arch/arm/mach-imx/cpu_op-mx51.c                 |  31 -
 arch/arm/mach-imx/cpu_op-mx51.h                 |  14 -
 arch/arm/mach-imx/cpufreq.c                     | 202 ------
 arch/arm/mach-imx/devices/Kconfig               |   4 -
 arch/arm/mach-imx/devices/Makefile              |   1 -
 arch/arm/mach-imx/devices/devices-common.h      |  10 -
 arch/arm/mach-imx/devices/platform-ahci-imx.c   | 157 -----
 arch/arm/mach-imx/hardware.h                    |   1 -
 arch/arm/mach-imx/mach-cpuimx51sd.c             |   5 -
 arch/arm/mach-imx/mach-imx6q.c                  |   5 +-
 arch/arm/mach-imx/mach-mx51_babbage.c           |   4 -
 arch/arm/mach-imx/mx6q.h                        |  31 -
 arch/arm/mach-imx/platsmp.c                     |  12 -
 arch/arm/mach-l7200/include/mach/debug-macro.S  |  38 -
 arch/arm/mach-msm/board-halibut.c               |   1 +
 arch/arm/mach-msm/board-msm7x30.c               |   1 +
 arch/arm/mach-msm/board-qsd8x50.c               |   1 +
 arch/arm/mach-msm/board-trout.c                 |   1 +
 arch/arm/mach-msm/devices-msm7x00.c             |  31 +
 arch/arm/mach-msm/devices-msm7x30.c             |  31 +
 arch/arm/mach-msm/devices-qsd8x50.c             |  31 +
 arch/arm/mach-msm/devices.h                     |   4 +
 arch/arm/mach-msm/dma.c                         |  26 +
 arch/arm/mach-msm/include/mach/cpu.h            |  54 --
 arch/arm/mach-msm/include/mach/dma.h            |  26 -
 arch/arm/mach-msm/platsmp.c                     |   8 -
 arch/arm/mach-mxs/Makefile                      |   4 -
 arch/arm/mach-mxs/include/mach/common.h         |  29 -
 arch/arm/mach-mxs/include/mach/debug-macro.S    |   9 +-
 arch/arm/mach-mxs/include/mach/digctl.h         |  22 -
 arch/arm/mach-mxs/include/mach/hardware.h       |  23 -
 arch/arm/mach-mxs/include/mach/mx23.h           | 169 -----
 arch/arm/mach-mxs/include/mach/mx28.h           | 225 ------
 arch/arm/mach-mxs/include/mach/mxs.h            | 117 ----
 arch/arm/mach-mxs/mach-mxs.c                    | 185 ++++-
 arch/arm/mach-mxs/mm.c                          |  52 --
 arch/arm/mach-mxs/ocotp.c                       |  93 ---
 arch/arm/mach-mxs/system.c                      | 139 ----
 arch/arm/mach-omap1/dma.h                       |  41 --
 arch/arm/mach-omap2/cclock2420_data.c           | 283 ++++----
 arch/arm/mach-omap2/cclock2430_data.c           | 311 ++++-----
 arch/arm/mach-omap2/cclock33xx_data.c           | 165 +++--
 arch/arm/mach-omap2/cclock3xxx_data.c           | 685 ++++++++++---------
 arch/arm/mach-omap2/cclock44xx_data.c           | 517 +++++++-------
 arch/arm/mach-omap2/clock.c                     |  17 +-
 arch/arm/mach-omap2/clock.h                     |  20 +-
 arch/arm/mach-omap2/cpuidle34xx.c               |   3 -
 arch/arm/mach-omap2/cpuidle44xx.c               |   8 +-
 arch/arm/mach-omap2/dma.h                       |  70 --
 arch/arm/mach-omap2/omap-hotplug.c              |   6 -
 arch/arm/mach-omap2/omap-smp.c                  |  76 +-
 arch/arm/mach-omap2/omap4-common.c              |  16 +
 arch/arm/mach-omap2/omap4-sar-layout.h          |  14 +-
 arch/arm/mach-omap2/pm24xx.c                    |  11 +-
 arch/arm/mach-omap2/pm34xx.c                    |   9 +-
 arch/arm/mach-omap2/pm44xx.c                    |  20 +-
 arch/arm/mach-omap2/timer.c                     |   2 +-
 arch/arm/mach-orion5x/pci.c                     |   7 +-
 arch/arm/mach-prima2/platsmp.c                  |   8 -
 arch/arm/mach-s3c24xx/Kconfig                   |  22 +-
 arch/arm/mach-s3c24xx/bast-irq.c                |   2 -
 arch/arm/mach-s3c24xx/clock-s3c2410.c           |   1 -
 arch/arm/mach-s3c24xx/clock-s3c2412.c           |   1 -
 arch/arm/mach-s3c24xx/clock-s3c2416.c           |   1 -
 arch/arm/mach-s3c24xx/clock-s3c2443.c           |   1 -
 arch/arm/mach-s3c24xx/common-smdk.c             |   3 +-
 .../include/plat => mach-s3c24xx}/common-smdk.h |   3 +-
 arch/arm/mach-s3c24xx/common.c                  |   7 +-
 arch/arm/mach-s3c24xx/common.h                  |  90 ++-
 arch/arm/mach-s3c24xx/dma-s3c2410.c             |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2412.c             |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2440.c             |   1 -
 arch/arm/mach-s3c24xx/dma-s3c2443.c             |   1 -
 arch/arm/mach-s3c24xx/include/mach/dma.h        |   1 -
 arch/arm/mach-s3c24xx/include/mach/regs-sdi.h   | 127 ----
 arch/arm/mach-s3c24xx/irq-pm.c                  |   7 +-
 arch/arm/mach-s3c24xx/irq.c                     |   9 +-
 arch/arm/mach-s3c24xx/mach-jive.c               |   2 +-
 arch/arm/mach-s3c24xx/mach-n30.c                |   1 -
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |   2 -
 arch/arm/mach-s3c24xx/mach-otom.c               |   1 -
 arch/arm/mach-s3c24xx/mach-qt2410.c             |   2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c           |   3 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |   5 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |   4 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c           |   5 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |   5 +-
 arch/arm/mach-s3c24xx/mach-vstms.c              |   3 +-
 arch/arm/mach-s3c24xx/pm-s3c2412.c              |   1 -
 arch/arm/mach-s3c24xx/regs-dsc.h                | 203 +-----
 arch/arm/mach-s3c24xx/s3c2410.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2412.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2416.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2440.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2442.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2443.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c244x.c                 |   2 -
 arch/arm/mach-s3c64xx/Makefile                  |   1 -
 arch/arm/mach-s3c64xx/include/mach/dma.h        |   1 -
 arch/arm/mach-s5pc100/common.h                  |   9 -
 arch/arm/mach-s5pv210/common.h                  |   9 -
 arch/arm/mach-shmobile/smp-emev2.c              |   7 -
 arch/arm/mach-shmobile/smp-r8a7779.c            |   7 -
 arch/arm/mach-shmobile/smp-sh73a0.c             |   7 -
 arch/arm/mach-socfpga/platsmp.c                 |  12 -
 arch/arm/mach-spear13xx/platsmp.c               |   8 -
 arch/arm/mach-spear13xx/spear13xx.c             |   4 +-
 arch/arm/mach-sunxi/Kconfig                     |   5 +-
 arch/arm/mach-sunxi/sunxi.c                     |  74 +-
 arch/arm/mach-tegra/Makefile                    |   4 +-
 arch/arm/mach-tegra/board-dt-tegra114.c         |  46 --
 arch/arm/mach-tegra/board-dt-tegra30.c          |  60 --
 arch/arm/mach-tegra/board.h                     |   4 +-
 arch/arm/mach-tegra/common.c                    |  26 +-
 arch/arm/mach-tegra/hotplug.c                   |  23 +-
 arch/arm/mach-tegra/platsmp.c                   | 118 ++--
 arch/arm/mach-tegra/pm.c                        |   7 +-
 arch/arm/mach-tegra/pmc.c                       | 152 +++-
 arch/arm/mach-tegra/pmc.h                       |   4 +
 arch/arm/mach-tegra/sleep.h                     |  10 +-
 .../mach-tegra/{board-dt-tegra20.c => tegra.c}  |  16 +-
 arch/arm/mach-ux500/platsmp.c                   |   8 -
 arch/arm/mach-ux500/timer.c                     |   3 +-
 arch/arm/mach-vexpress/v2m.c                    |   6 +-
 arch/arm/mach-virt/platsmp.c                    |   8 -
 arch/arm/plat-orion/Makefile                    |   6 +-
 arch/arm/plat-orion/pcie.c                      |  10 +-
 arch/arm/plat-samsung/Kconfig                   |  14 -
 arch/arm/plat-samsung/dma-ops.c                 |  10 +-
 arch/arm/plat-samsung/include/plat/dma-ops.h    |   1 -
 arch/arm/plat-samsung/include/plat/dma-pl330.h  |   1 -
 arch/arm/plat-samsung/include/plat/irq.h        | 116 ----
 arch/arm/plat-samsung/include/plat/rtc-core.h   |   2 +-
 arch/arm/plat-samsung/include/plat/s3c2410.h    |  31 -
 arch/arm/plat-samsung/include/plat/s3c2412.h    |  32 -
 arch/arm/plat-samsung/include/plat/s3c2416.h    |  37 -
 arch/arm/plat-samsung/include/plat/s3c2443.h    |  36 -
 arch/arm/plat-samsung/include/plat/s3c244x.h    |  42 --
 arch/arm/plat-samsung/include/plat/sdhci.h      |   4 +-
 arch/arm/plat-samsung/irq-vic-timer.c           |   3 +-
 arch/arm/plat-samsung/s5p-irq-gpioint.c         |   3 +-
 arch/arm/plat-versatile/platsmp.c               |   8 -
 drivers/clk/mxs/clk-imx23.c                     |  42 +-
 drivers/clk/mxs/clk-imx28.c                     |  42 +-
 drivers/clocksource/Kconfig                     |   2 +-
 drivers/clocksource/Makefile                    |   3 +-
 drivers/clocksource/bcm2835_timer.c             |  12 +-
 drivers/clocksource/clksrc-of.c                 |   5 +-
 .../timer.c => drivers/clocksource/mxs_timer.c  |  36 +-
 .../{sunxi_timer.c => sun4i_timer.c}            |  94 ++-
 drivers/clocksource/tegra20_timer.c             |  75 +-
 drivers/clocksource/vt8500_timer.c              |  16 +-
 drivers/gpio/gpio-msm-v1.c                      | 220 ++++--
 drivers/gpio/gpio-msm-v2.c                      |   3 +-
 drivers/gpio/gpio-mxc.c                         |   2 +-
 drivers/gpio/gpio-omap.c                        |   3 +-
 drivers/gpio/gpio-pl061.c                       |   2 +-
 drivers/gpio/gpio-pxa.c                         |   3 +-
 drivers/gpio/gpio-tegra.c                       |   3 +-
 drivers/irqchip/Makefile                        |   3 +-
 drivers/irqchip/exynos-combiner.c               |   1 +
 drivers/irqchip/irq-gic.c                       |  36 +-
 .../icoll.c => drivers/irqchip/irq-mxs.c        |  24 +-
 drivers/irqchip/irq-sun4i.c                     | 149 ++++
 drivers/irqchip/irq-sunxi.c                     | 151 ----
 drivers/irqchip/irq-vic.c                       |   3 +-
 drivers/mmc/host/msm_sdcc.c                     |   1 -
 drivers/mmc/host/s3cmci.c                       |  83 ++-
 drivers/pinctrl/pinctrl-at91.c                  |   3 +-
 drivers/pinctrl/pinctrl-exynos.c                |   3 +-
 drivers/pinctrl/pinctrl-nomadik.c               |   2 +-
 drivers/pinctrl/pinctrl-sirf.c                  |   2 +-
 drivers/pinctrl/spear/pinctrl-plgpio.c          |   2 +-
 drivers/rtc/rtc-stmp3xxx.c                      |   6 +-
 drivers/staging/iio/adc/mxs-lradc.c             |   3 -
 drivers/staging/imx-drm/ipu-v3/ipu-common.c     |   2 +-
 drivers/usb/host/ohci-exynos.c                  |   2 +-
 include/linux/clk/mxs.h                         |  16 +
 include/linux/clocksource.h                     |  12 +-
 include/linux/irqchip/arm-gic.h                 |   1 -
 include/linux/irqchip/chained_irq.h             |  52 ++
 .../mach/timex.h => include/linux/irqchip/mxs.h |   9 +-
 include/linux/irqchip/sunxi.h                   |  27 -
 .../{usb-exynos.h => usb-ohci-exynos.h}         |   0
 include/linux/sunxi_timer.h                     |  24 -
 sound/soc/mxs/mxs-saif.c                        |   5 +-
 263 files changed, 2919 insertions(+), 6559 deletions(-)
 rename Documentation/devicetree/bindings/interrupt-controller/{allwinner,sunxi-ic.txt => allwinner,sun4i-ic.txt} (94%)
 rename Documentation/devicetree/bindings/timer/{allwinner,sunxi-timer.txt => allwinner,sun4i-timer.txt} (78%)
 rename Documentation/devicetree/bindings/watchdog/{sunxi-wdt.txt => sun4i-wdt.txt} (57%)
 delete mode 100644 arch/arm/configs/h7201_defconfig
 delete mode 100644 arch/arm/configs/h7202_defconfig
 create mode 100644 arch/arm/mach-at91/Kconfig.non_dt
 rename arch/arm/mach-at91/{board-rm9200-dt.c => board-dt-rm9200.c} (100%)
 rename arch/arm/mach-at91/{board-dt.c => board-dt-sam9.c} (100%)
 rename arch/arm/mach-gemini/{include/mach/system.h => reset.c} (91%)
 delete mode 100644 arch/arm/mach-h720x/Kconfig
 delete mode 100644 arch/arm/mach-h720x/Makefile
 delete mode 100644 arch/arm/mach-h720x/Makefile.boot
 delete mode 100644 arch/arm/mach-h720x/common.c
 delete mode 100644 arch/arm/mach-h720x/common.h
 delete mode 100644 arch/arm/mach-h720x/cpu-h7201.c
 delete mode 100644 arch/arm/mach-h720x/cpu-h7202.c
 delete mode 100644 arch/arm/mach-h720x/h7201-eval.c
 delete mode 100644 arch/arm/mach-h720x/h7202-eval.c
 delete mode 100644 arch/arm/mach-h720x/include/mach/boards.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7201-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7202-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/isa-dma.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-imx/Makefile.boot
 delete mode 100644 arch/arm/mach-imx/cpu_op-mx51.c
 delete mode 100644 arch/arm/mach-imx/cpu_op-mx51.h
 delete mode 100644 arch/arm/mach-imx/cpufreq.c
 delete mode 100644 arch/arm/mach-imx/devices/platform-ahci-imx.c
 delete mode 100644 arch/arm/mach-imx/mx6q.h
 delete mode 100644 arch/arm/mach-l7200/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-msm/include/mach/cpu.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/common.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/digctl.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mx23.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mx28.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mxs.h
 delete mode 100644 arch/arm/mach-mxs/mm.c
 delete mode 100644 arch/arm/mach-mxs/ocotp.c
 delete mode 100644 arch/arm/mach-mxs/system.c
 rename arch/arm/{plat-samsung/include/plat => mach-s3c24xx}/common-smdk.h (86%)
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/regs-sdi.h
 delete mode 100644 arch/arm/mach-tegra/board-dt-tegra114.c
 delete mode 100644 arch/arm/mach-tegra/board-dt-tegra30.c
 rename arch/arm/mach-tegra/{board-dt-tegra20.c => tegra.c} (89%)
 delete mode 100644 arch/arm/plat-samsung/include/plat/irq.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c2410.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c2412.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c2416.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c2443.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c244x.h
 rename arch/arm/mach-mxs/timer.c => drivers/clocksource/mxs_timer.c (91%)
 rename drivers/clocksource/{sunxi_timer.c => sun4i_timer.c} (50%)
 rename arch/arm/mach-mxs/icoll.c => drivers/irqchip/irq-mxs.c (89%)
 create mode 100644 drivers/irqchip/irq-sun4i.c
 delete mode 100644 drivers/irqchip/irq-sunxi.c
 create mode 100644 include/linux/clk/mxs.h
 create mode 100644 include/linux/irqchip/chained_irq.h
 rename arch/arm/mach-h720x/include/mach/timex.h => include/linux/irqchip/mxs.h (52%)
 delete mode 100644 include/linux/irqchip/sunxi.h
 rename include/linux/platform_data/{usb-exynos.h => usb-ohci-exynos.h} (100%)
 delete mode 100644 include/linux/sunxi_timer.h
