Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaDETCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:02:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaDETCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:02:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 1/8] ARM: SoC non-critical bug fixes for 3.15
Date: Sat, 5 Apr 2014 20:02:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201404052102.26018.arnd@arndb.de>
X-Provags-ID: V02:K0:JSMyMkCL9ETVcHPjZCPcnQvue6UKTdt2qx27IaX5LFm
 n9lvmvHuENEc1VsN+UzgG2kgM2shvaJURgqiVdsl5KHPJRPdoS
 9XZfSBic+aDdw2kotI1eEbwG64kwejlUy5/C66QaHNEMb1clkp
 7CS9GpLBBAX5JM48QBpAvNtGyvYAwZ7tf8rChBNj11N8Jfq+wH
 RRZ4/v8v8W6w5cm/zt5tH0LRz6YLQca7pEYXBKD/yMAGR86CaC
 jzHrL1N8OesfX1OXbWJmtg5nm7BYPSHWNHt5JHVsvVuGEFrWjy
 5KA31ZgocT8JRh7xd3o6iBJ3UGbLVkraiX2nTBbKnuP92UWvMk
 WaJub8roSxFDNdr4niaHz3At3uUO5V1FoVSRFtEKG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical-3.15

for you to fetch changes up to cb46a256a78225817945cd52068d61d5126c236e:

  ARM: at91: fix a typo (2014-04-03 21:52:26 +0200)

----------------------------------------------------------------
ARM: SoC non-critical bug fixes for 3.15

Lots of isolated bug fixes that were not found to be important
enough to be submitted before the merge window or backported
into stable kernels.
The vast majority of these came out of Arnd's randconfig testing
and just prevents running into build-time bugs in configurations
that we do not care about in practice.

----------------------------------------------------------------
Alexander Shiyan (3):
      ARM: clps711x: autcpu12: Fix incorrect NAND CLE GPIO
      MAINTAINERS: ARM: clps711x: Use regex patterns to involve all CLPS711X drivers
      ARM: nspire: Fix compiler warning

Arnd Bergmann (57):
      Merge tag 'omap-for-v3.15/fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      ARM: mmp: allow platform devices with modular USB
      Merge tag 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      ARM: at91: split out at91x40 into a top-level option
      ARM: at91: don't provide dt init code for at91x40
      ARM: at91: export sam9_smc interfaces
      ARM: at91: fix broken "if () else" statement
      ARM: at91: sama5 always uses DT
      ARM: davinci: make dm644x-evm phy fixup conditional
      ARM: davinci: fix Kconfig for DA850_EVM
      ARM: efm32: select AUTO_ZRELADDR
      ARM: ep93xx: export ep93xx_chip_revision
      ARM: hisi: fix building without CONFIG_HOTPLUG_CPU
      ARM: ixp4xx/omixp: always include linux/leds.h
      ARM: ixp4xx: avoid use of PCIBIOS_MIN_MEM in io.h
      ARM: ixp4xx: fix gpio rework
      ARM: ks8695/og: make PCI setup conditional
      ARM: lpc32xx: export lpc32xx_return_iram_size
      ARM: msm: add missing include of linux/module.h
      ARM: msm: avoid calling debug_ll_addr on !MMU
      ARM: msm: export legacy DMA interfaces
      ARM: omap1: don't rely on tps65010
      ARM: mvebu: add missing header
      ARM: orion5x: make dns323 independent of PHY support
      ARM: pxa: don't "select" SMC91X on MACH_XCEP
      ARM: pxa: enable pxafb unconditionally for some boards
      ARM: pxa: fix colibri build
      ARM: pxa: fix pxa_ssp_* declarations
      ARM: pxa: remove broken balloon3_gpio_vbus reference
      ARM: pxa: select I2C_GPIO only if I2C is on
      ARM: pxa: trizeps4 and trizeps4wl use the same file
      ARM: rpc: autoselect CPU_SA110
      ARM: footbridge: don't build floppy code for addin mode
      ARM: footbridge: fix build with PCI disabled
      ARM: footbridge: make screen_info setup conditional
      ARM: realview: fix sparsemem build
      ARM: integrator: only select pl01x if TTY is enabled
      ARM: s3c24xx: MINI2440 needs I2C for EEPROM_AT24
      ARM: s3c24xx: fix gta02 build error
      ARM: s3c24xx: osiris dvs needs tps65010
      ARM: s3c64xx: MACH_SMDK6400 needs HSMMC1
      ARM: s3c64xx: select power domains only when used
      ARM: s5p64x0: fix building with only one soc type
      ARM: s5pv210: enable IDE support in MACH_TORBRECK
      ARM: samsung: allow serial driver to be disabled
      ARM: samsung: fix SAMSUNG_PM_DEBUG Kconfig logic
      ARM: samsung: select ATAGS where necessary
      ARM: samsung: select CRC32 for SAMSUNG_PM_CHECK
      ARM: exynos: fix l2x0 saved regs handling
      ARM: exynos: add missing include of linux/module.h
      ARM: sunxi: fix build for THUMB2_KERNEL
      ARM: tegra: make debug_ll code build for ARMv6
      Merge branch 'randconfig-fixes' into next/fixes-non-critical
      Revert "ARM: ixp4xx: fix gpio rework"
      Revert "ARM: ixp4xx: Make dma_set_coherent_mask common, correct implementation"
      ARM: moxart: fix CPU selection
      ARM: at91: fix a typo

Felipe Balbi (1):
      ARM: omap1: fix build when !CONFIG_OMAP_32K_TIMER

Florian Vaussard (2):
      CLK: TI: OMAP4/5/DRA7: Remove gpmc_fck from dummy clocks
      ARM: dts: omap4/5: Use l3_ick for the gpmc node

Krzysztof Halasa (2):
      IXP4xx: Fix Goramo Multilink GPIO conversion.
      IXP4xx: Fix DMA masks.

Krzysztof Hałasa (2):
      CNS3xxx: Fix a WARN() related to IRQ allocation.
      CNS3xxx: Fix PCIe early iotable_init().

Mugunthan V N (1):
      ARM: dts: am33xx: correcting dt node unit address for usb

Nishanth Menon (1):
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Paul Bolle (1):
      ARM: S3C24XX: Fix typo CONFIG_CPUS_3C2443

Paul Gortmaker (1):
      ARM: S3C64XX: mach-crag6410-module.c is not modular

Simon Kågström (1):
      ARM: ixp4xx: Make dma_set_coherent_mask common, correct implementation

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Stephen Warren (1):
      ARM: tegra: fix board DT pinmux setup

Suman Anna (1):
      ARM: OMAP4: hwmod data: correct the idlemodes for spinlock

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Tushar Behera (1):
      ARM: exynos_defconfig: Update EHCI config entry

Will Deacon (1):
      irqchip: gic: use dmb ishst instead of dsb when raising a softirq

 MAINTAINERS                                  |   2 +-
 arch/arm/Kconfig                             |  15 +++-
 arch/arm/boot/dts/am33xx.dtsi                |   4 +-
 arch/arm/boot/dts/exynos5250-arndale.dts     |   1 +
 arch/arm/boot/dts/omap4.dtsi                 |   2 +
 arch/arm/boot/dts/omap5.dtsi                 |   2 +
 arch/arm/boot/dts/tegra114-dalmore.dts       |   2 -
 arch/arm/boot/dts/tegra124-venice2.dts       |  11 +--
 arch/arm/configs/davinci_all_defconfig       |   2 +
 arch/arm/configs/exynos_defconfig            |   2 +-
 arch/arm/include/asm/smp.h                   |   1 +
 arch/arm/include/debug/tegra.S               |  18 ++---
 arch/arm/mach-at91/Kconfig                   |  23 +++++-
 arch/arm/mach-at91/Kconfig.non_dt            |   8 +-
 arch/arm/mach-at91/at91sam9260_devices.c     |   6 +-
 arch/arm/mach-at91/sam9_smc.c                |   3 +
 arch/arm/mach-at91/setup.c                   |   2 +-
 arch/arm/mach-clps711x/board-autcpu12.c      |   2 +-
 arch/arm/mach-cns3xxx/cns3420vb.c            |   1 -
 arch/arm/mach-cns3xxx/core.c                 |  33 ++++++++-
 arch/arm/mach-cns3xxx/pcie.c                 | 105 ++++++++-------------------
 arch/arm/mach-davinci/Kconfig                |   5 --
 arch/arm/mach-davinci/board-dm644x-evm.c     |  11 +--
 arch/arm/mach-ep93xx/core.c                  |   1 +
 arch/arm/mach-exynos/common.c                |   6 +-
 arch/arm/mach-exynos/cpuidle.c               |   1 +
 arch/arm/mach-footbridge/Kconfig             |   2 +-
 arch/arm/mach-footbridge/Makefile            |   3 +-
 arch/arm/mach-footbridge/cats-hw.c           |   2 +
 arch/arm/mach-hisi/Makefile                  |   3 +-
 arch/arm/mach-hisi/hotplug.c                 |   2 +
 arch/arm/mach-integrator/Kconfig             |   8 +-
 arch/arm/mach-ixp4xx/common-pci.c            |  39 ----------
 arch/arm/mach-ixp4xx/common.c                |  61 ++++++++++++++--
 arch/arm/mach-ixp4xx/goramo_mlr.c            |  43 ++++++-----
 arch/arm/mach-ixp4xx/include/mach/io.h       |   3 +-
 arch/arm/mach-ixp4xx/omixp-setup.c           |   2 -
 arch/arm/mach-ks8695/board-og.c              |   3 +-
 arch/arm/mach-lpc32xx/common.c               |   1 +
 arch/arm/mach-mmp/aspenite.c                 |   4 +-
 arch/arm/mach-mmp/devices.c                  |  14 ++--
 arch/arm/mach-mmp/ttc_dkb.c                  |  18 ++---
 arch/arm/mach-moxart/Kconfig                 |   2 +-
 arch/arm/mach-msm/dma.c                      |   3 +
 arch/arm/mach-msm/io.c                       |   2 +
 arch/arm/mach-mvebu/armada-370-xp.c          |   1 +
 arch/arm/mach-nspire/nspire.c                |   2 +-
 arch/arm/mach-omap1/board-h2.c               |   3 +
 arch/arm/mach-omap1/board-osk.c              |   3 +
 arch/arm/mach-omap1/pm.c                     |   6 +-
 arch/arm/mach-omap2/irq.c                    |   8 ++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   |   3 +-
 arch/arm/mach-omap2/pm.h                     |   2 +-
 arch/arm/mach-orion5x/Kconfig                |   1 -
 arch/arm/mach-orion5x/dns323-setup.c         |   2 +
 arch/arm/mach-pxa/Kconfig                    |   9 ++-
 arch/arm/mach-pxa/balloon3.c                 |   1 -
 arch/arm/mach-pxa/colibri-evalboard.c        |   1 +
 arch/arm/mach-realview/include/mach/memory.h |   2 +
 arch/arm/mach-s3c24xx/Kconfig                |   4 +-
 arch/arm/mach-s3c24xx/common.c               |   2 +-
 arch/arm/mach-s3c24xx/mach-gta02.c           |   2 +-
 arch/arm/mach-s3c64xx/Kconfig                |   3 +-
 arch/arm/mach-s3c64xx/irq-pm.c               |  12 ++-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c |   2 +-
 arch/arm/mach-s5p64x0/common.c               |  18 ++++-
 arch/arm/mach-s5p64x0/common.h               |   5 +-
 arch/arm/mach-s5p64x0/irq-pm.c               |   6 ++
 arch/arm/mach-s5pv210/Kconfig                |   1 +
 arch/arm/mach-sunxi/Makefile                 |   2 +-
 arch/arm/mach-sunxi/headsmp.S                |   9 ---
 arch/arm/mach-sunxi/platsmp.c                |   2 +-
 arch/arm/mm/Kconfig                          |   2 +-
 arch/arm/plat-samsung/Kconfig                |   6 +-
 arch/arm/plat-samsung/init.c                 |   4 +
 drivers/clk/ti/clk-44xx.c                    |   1 -
 drivers/clk/ti/clk-54xx.c                    |   1 -
 drivers/clk/ti/clk-7xx.c                     |   1 -
 drivers/irqchip/irq-gic.c                    |   4 +-
 include/linux/pxa2xx_ssp.h                   |   2 +-
 80 files changed, 347 insertions(+), 270 deletions(-)
 delete mode 100644 arch/arm/mach-sunxi/headsmp.S
