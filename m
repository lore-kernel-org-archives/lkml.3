Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaDETEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:04:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:56654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaDETEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:04:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 3/8] ARM: SoC specific changes
Date: Sat, 5 Apr 2014 20:04:10 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201404052104.11363.arnd@arndb.de>
X-Provags-ID: V02:K0:W7MD7tFpxfosbTHx15zqvVPdaWXBuusEYO6S8O16fBR
 tBC+KCHmoUmvPcckXb2Pge6/umgk4Zp3q6aWFoT0Ggtgu9GNli
 EWlre8+p3nIHHoNdvw0W1keml8hnlwvdBYYOdgiOMIEJE0uSqE
 04B/O0S9qHNmgCPG1WqCX1kG1hPeTKMgd0jLk3cr2Z0JGD8XK3
 uSO5D5+dqra0xiXdCw68dZUaXfG/pOhDJMc2jksXrT5RSRjLU+
 RaB3O7ttPdk1RsMOjAvwa4cn1ET3jkwN6Fa6ABi+wbUvDBrkeR
 2/YK6BR0bg5JyQr2IXyYPzKk3HCXUUw9gmrJLWVUCAF5dBHODY
 D7ERzZDkS7yoXVFVCx9WJePjQnN+QAPBb4UhI4GvQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0e8b860ac6d65209beea03ee9b718089838476ef:

  ARM: bcm281xx: Rename board_init() function (2014-03-06 03:18:01 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-3.15

for you to fetch changes up to 9233087dc468f75bdeb7830c694c09dc74be88c4:

  ARM: sunxi: Select HAVE_ARM_ARCH_TIMER (2014-03-27 14:26:27 -0700)

----------------------------------------------------------------
ARM: SoC specific changes

Lots of changes specific to one of the SoC families. Some that
stick out are:

* mach-qcom gains new features, most importantly SMP support for
  the newer chips (Stephen Boyd, Rohit Vaswani)
* mvebu gains support for three new SoCs: Armada 375, 380 and 385
  (Thomas Petazzoni and Free-electrons team)
* SMP support for Rockchips (Heiko Stübner)
* Lots of i.MX changes (Shawn Guo)
* Added support for BCM5301x SoC (Hauke Mehrtens)
* Multiplatform support for Marvell Kirkwood and Dove
  (Andrew Lunn and Sebastian Hesselbarth doing the final part
  of a long journey)
* Unify davinci platforms and remove obsolete ones (Sekhar Nori,
  Arnd Bergmann)

Conflicts:
* BCM5301x trivially conflicts with the moved BCM2835 code
  in Kconfig and Makefile
* arch/arm/mach-imx/pm-imx6q.c got renamed to pm-imx6.c
  and needs the change from 8435cf757632a "arm: Replace various
  irq_desc accesses" applied there.
* some shmobile platforms now need to select both ARCH_DMA_ADDR_T_64BIT
  and SYS_SUPPORTS_SH_CMT
* The vmlinux.lds.h file has two new macros that are both needed

----------------------------------------------------------------
Afzal Mohammed (2):
      ARM: OMAP2+: AM43x: enable in default config
      ARM: OMAP2+: AM43x: determine features

Alexander Shiyan (3):
      ARM: clps711x: Add CLPS711X irqchip driver
      ARM: dts: clps711x: Add bindings documentation for CLPS711X irqchip driver
      ARM: clps711x: Migrate CLPS711X subarch to the new irqchip driver

Alexandre Courbot (6):
      ARM: trusted_foundations: fix vendor prefix typos
      ARM: trusted_foundations: fallback when TF support is missing
      ARM: firmware: enable Trusted Foundations by default
      ARM: firmware: add prepare_idle() operation
      ARM: trusted_foundations: implement prepare_idle()
      ARM: tegra: cpuidle: use firmware for power down

Andrew Lunn (17):
      ARM: kirkwood: Give pm.c its own header file.
      ARM: kirkwood: Convert mv88f6281gtw_ge switch setup to DT
      ARM: kirkwood: Drop printing the SoC type and revision
      ARM: kirkwood: Separate board-dt from common and pcie code.
      ARM: kirkwood: ioremap the cpu_config register before using it.
      ARM: kirkwood: ioremap memory control register
      ARM: mvebu: Add ARCH_MULTI_V7 to SoCs
      ARM: orion: Move cache-feroceon-l2.h out of plat-orion
      ARM: MM: Add DT binding for Feroceon L2 cache
      ARM: Fix default CPU selection for ARCH_MULTI_V5
      ARM: MM Enable building Feroceon L2 cache controller with ARCH_MVEBU
      ARM: mvebu: Move kirkwood DT boards into mach-mvebu
      ARM: mvebu: Let kirkwood use the system controller for restart
      ARM: mvebu: Enable mvebu-soc-id on Kirkwood
      ARM: mvebu: Simplify headers and make local
      ARM: kirkwood: Remove redundant kexec code
      ARM: kirkwood: Add HP T5325 thin client

Anson Huang (8):
      ARM: imx: AHB rate must be set to 132MHz on i.mx6sl
      ARM: imx: add cpuidle support for i.mx6sl
      ARM: imx: add suspend in ocram support for i.mx6q
      ARM: imx: add suspend in ocram support for i.mx6dl
      ARM: imx: add suspend in ocram support for i.mx6sl
      ARM: imx: add always-on clock array for i.mx6sl to maintain correct usecount
      ARM: imx: avoid calling clk APIs in idle thread which may cause schedule
      ARM: imx: add speed grading check for i.mx6 soc

Arnd Bergmann (13):
      Merge branch 'mvebu/soc' into next/soc
      Merge tag 'mvebu-soc-3xx-3.15' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-soc-3.15-2' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-soc-3.15-3' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'sunxi-core-for-3.15' of https://github.com/mripard/linux into next/soc
      Merge branch 'bcm/cleanup' into next/soc
      Merge tag 'armsoc/for-3.15/soc-3' of git://github.com/broadcom/mach-bcm into next/soc
      ARM: davinci: remove tnetv107x support
      Merge tag 'davinci-for-v3.15/soc' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      Merge tag 'armsoc/for-3.15/soc-4' of git://github.com/broadcom/mach-bcm into next/soc
      ARM: mvebu: don't select CONFIG_NEON
      Merge tag 'davinci-for-v3.15/soc-2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/soc
      ARM: cache-tauros2: remove ARMv6 code

Dave Gerlach (1):
      ARM: OMAP2+: clockdomain: Reintroduce SW_SLEEP Support

Denis Carikli (3):
      ARM: imx_v6_v7_defconfig: Enable backlight gpio support.
      ARM i.MX35: build in pinctrl support.
      ARM: imx_v6_v7_defconfig: Enable some drivers used on the cpuimx35.

Ezequiel Garcia (1):
      ARM: mvebu: Rename the ARCH_MVEBU menu option

Fabio Estevam (7):
      ARM: imx_v6_v7_defconfig: Select PCI support
      ARM: imx: Use INT_MEM_CLK_LPM as the bit name
      ARM: imx_v4_v5_defconfig: Select CONFIG_MMC_UNSAFE_RESUME
      ARM: imx_v6_v7_defconfig: Select CONFIG_MMC_UNSAFE_RESUME
      ARM: mach-imx: Select CONFIG_SRAM at ARCH_MXC level
      ARM: imx_v6_v7_defconfig: Select CONFIG_DEBUG_FS
      ARM: mach-imx: Kconfig: Remove IMX_HAVE_PLATFORM_IMX2_WDT from SOC_IMX53

Florian Fainelli (1):
      ARM: restrict BCM_KONA_UART to ARCH_BCM_MOBILE

Gaku Inami (1):
      ARM: shmobile: r8a7790 CA7-SCU enablement

Gregory CLEMENT (1):
      ARM: mvebu: add initial support for the Armada 375 SOCs

Hauke Mehrtens (3):
      ARM: BCM5301X: initial support for the BCM5301X/BCM470X SoCs with ARM CPU
      ARM: BCM5301X: add early debugging support
      ARM: BCM5301X: workaround suppress fault

Heiko Stuebner (4):
      ARM: rockchip: add snoop-control-unit
      ARM: rockchip: add sram dt nodes and documentation
      ARM: rockchip: add power-management-unit
      ARM: rockchip: add smp bringup code

Hisashi Nakamura (1):
      ARM: shmobile: r8a7790 SYSC setup code

Jason Cooper (5):
      Merge tag 'tags/mvebu-soc-3.15' into mvebu/soc-3xx
      ARM: mvebu: Armada 375/38x depend on MULTI_V7
      ARM: kirkwood: select dtbs based on SoC
      Merge branch 'mvebu/soc-3xx' into mvebu/soc
      Merge branch 'mvebu/soc-kw' into mvebu/soc

John Tobias (1):
      ARM: imx: add select on ARCH_MXC for cpufreq support

Keita Kobayashi (1):
      ARM: shmobile: r8a7790 CA15-SCU enablement

Kevin Hilman (1):
      ARM: davinci: fix DT booting with default defconfig

Laurent Pinchart (1):
      ARM: shmobile: APMU: Fix warnings due to improper printk formats

Liu Ying (2):
      ARM: imx: clk-imx6sl: Suppress duplicate const sparse warning
      ARM: imx: clk-vf610: Suppress duplicate const sparse warning

Lokesh Vutla (2):
      ARM: OMAP2+: AM43xx: implement support for machine restart
      ARM: OMAP2+: AM43x: Add ID for ES1.1

Magnus Damm (4):
      ARM: shmobile: Use 64-bit dma_addr_t on r8a7790/r8a7791
      ARM: shmobile: Break out R-Car SYSC PM code
      ARM: shmobile: Remove __init from rcar_gen2_read_mode_pins()
      ARM: shmobile: Move SYSC base variable to inside ifdefs

Markus Mayer (1):
      ARM: bcm21664: Add board support.

Matt Porter (2):
      Merge tag 'armsoc/for-3.15/soc-2' into armsoc/for-3.15/soc-3
      ARM: configs: bcm_defconfig: enable bcm590xx regulator support

Maxime Ripard (2):
      ARM: sunxi: Add the new watchog compatibles to the reboot code
      ARM: sunxi: Select HAVE_ARM_ARCH_TIMER

Nishanth Menon (1):
      ARM: OMAP3+: DPLL: stop reparenting to same parent if already done

Olof Johansson (11):
      Merge tag 'qcom-soc-for-3.15' of git://git.kernel.org/.../galak/linux-qcom into next/soc
      Merge tag 'v3.15-rockchip-smp' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge tag 'omap-for-v3.15/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.15/prcm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'imx-soc-3.15' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      ARM: enable ARM_HAS_SG_CHAIN for multiplatform
      Merge tag 'armsoc/for-3.15/soc-2' of git://github.com/broadcom/mach-bcm into next/soc
      Merge tag 'renesas-soc2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'tegra-for-3.15-tf' of git://git.kernel.org/.../tegra/linux into next/soc
      Merge tag 'tegra-for-3.15-soc' of git://git.kernel.org/.../tegra/linux into next/soc

Paul Bolle (1):
      ARM: OMAP2+: remove OMAP_PACKAGE_ZAC and OMAP_PACKAGE_ZAF

Philipp Zabel (2):
      ARM: imx6q: Add GPR6 and GPR7 register definitions for iomuxc gpr
      ARM i.MX6q: Mark VPU and IPU AXI transfers as cacheable, increase IPU priority

Rajendra Nayak (1):
      ARM: OMAP2+: AM43x: Use gptimer as clocksource

Richard Weinberger (1):
      ARM: mach-bcm: Remove GENERIC_TIME

Rohit Vaswani (4):
      ARM: qcom: Re-organize platsmp to make it extensible
      devicetree: bindings: Document Krait/Scorpion cpus and enable-method
      ARM: qcom: Add SMP support for KPSSv1
      ARM: qcom: Add SMP support for KPSSv2

Sascha Hauer (1):
      ARM i.MX: remove PWM platform support

Sebastian Andrzej Siewior (1):
      ARM: imx: enable delaytimer on the imx timer

Sebastian Hesselbarth (1):
      ARM: mvebu: move DT Dove to MVEBU

Sekhar Nori (4):
      ARM: davinci: enable da8xx build concurrently with older devices
      ARM: davinci: add da8xx specific configs to davinci_all_defconfig
      ARM: davinci: da8xx: fix multiple watchdog device registration
      ARM: davinci: remove da8xx_omapl_defconfig

Shawn Guo (12):
      Merge tag 'kconfig-cleanup-for-3.15' into imx/soc
      ARM: imx6q: remove unneeded clk lookups
      ARM: imx6q: support ptp and rmii clock from pad
      bus: imx-weim: support CS GPR configuration
      ARM: imx6: move v7_cpu_resume() into suspend-imx6.S
      ARM: imx6: build headsmp.o only on CONFIG_SMP
      ARM: imx6: call suspend_set_ops() from suspend routine
      ARM: imx6: do not call imx6q_suspend_init() with !CONFIG_SUSPEND
      ARM: imx6: introduce CONFIG_SOC_IMX6 for i.MX6 common stuff
      ARM: imx6: rename pm-imx6q.c to pm-imx6.c
      ARM: imx6: build suspend-imx6.o with CONFIG_SOC_IMX6
      ARM: imx6: drop .text.head section annotation from headsmp.S

Srinivas Kandagatla (1):
      MAINTAINERS: Update ARM STi maintainers

Stefan Agner (1):
      ARM: tegra: don't timeout if CPU is powergated

Stephen Boyd (4):
      ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp
      devicetree: bindings: Document qcom,kpss-acc
      devicetree: bindings: Document qcom,saw2 node
      ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs

Stephen Warren (1):
      ARM: tegra: remove tegra EMC scaling driver

Suman Anna (1):
      ARM: AM43x: hwmod data: register spinlock OCP interface

Thierry Reding (1):
      ARM: tegra: Export I/O rail functions

Thomas Petazzoni (7):
      ARM: mvebu: rename armada-370-xp.c to board-v7.c
      ARM: mvebu: rename DT machine structure for Armada 370/XP
      ARM: mvebu: make CPU_PJ4B selection a per-SoC choice
      ARM: mvebu: add Armada 375 support to the system-controller driver
      ARM: mvebu: add workaround for data abort issue on Armada 375
      ARM: mvebu: add initial support for the Armada 380/385 SOCs
      Documentation: arm: update Marvell documentation about Armada 375/38x

Tomi Valkeinen (1):
      ARM: OMAP2+: clock: fix rate prints

Tony Lindgren (1):
      Merge tag 'for-v3.15/omap-hwmod-clk-prcm-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.15/prcm


 Documentation/arm/Marvell/README                   |  12 +-
 .../devicetree/bindings/arm/armada-375.txt         |   9 +
 .../devicetree/bindings/arm/armada-38x.txt         |  10 +
 Documentation/devicetree/bindings/arm/bcm4708.txt  |   8 +
 Documentation/devicetree/bindings/arm/cpus.txt     |  25 +-
 .../devicetree/bindings/arm/mrvl/feroceon.txt      |  16 +
 .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  |  30 +
 .../devicetree/bindings/arm/msm/qcom,saw2.txt      |  35 +
 .../bindings/arm/mvebu-system-controller.txt       |   3 +-
 .../devicetree/bindings/arm/rockchip/pmu.txt       |  16 +
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |  30 +
 Documentation/devicetree/bindings/bus/imx-weim.txt |  28 +-
 .../interrupt-controller/cirrus,clps711x-intc.txt  |  41 ++
 MAINTAINERS                                        |  20 +-
 arch/arm/Kconfig                                   |   5 +-
 arch/arm/Kconfig.debug                             |  22 +-
 arch/arm/boot/dts/Makefile                         |   9 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     |  62 ++
 arch/arm/boot/dts/qcom-msm8960.dtsi                |   6 +
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   5 +
 arch/arm/boot/dts/rk3066a.dtsi                     |  13 +
 arch/arm/boot/dts/rk3188.dtsi                      |  13 +
 arch/arm/boot/dts/rk3xxx.dtsi                      |  10 +
 arch/arm/configs/bcm_defconfig                     |   7 +
 arch/arm/configs/da8xx_omapl_defconfig             | 139 ----
 arch/arm/configs/davinci_all_defconfig             |  23 +
 arch/arm/configs/imx_v4_v5_defconfig               |   1 +
 arch/arm/configs/imx_v6_v7_defconfig               |   7 +
 arch/arm/configs/multi_v7_defconfig                |   2 +
 arch/arm/configs/mvebu_defconfig                   |   1 +
 arch/arm/configs/omap2plus_defconfig               |   1 +
 arch/arm/firmware/Kconfig                          |   3 +-
 arch/arm/firmware/trusted_foundations.c            |  20 +-
 arch/arm/include/asm/firmware.h                    |   4 +
 .../asm/hardware}/cache-feroceon-l2.h              |   4 +-
 arch/arm/include/asm/smp.h                         |   9 +
 arch/arm/include/asm/trusted_foundations.h         |  13 +-
 arch/arm/kernel/devtree.c                          |  40 ++
 arch/arm/mach-bcm/Kconfig                          |  26 +
 arch/arm/mach-bcm/Makefile                         |   6 +-
 arch/arm/mach-bcm/bcm_5301x.c                      |  61 ++
 arch/arm/mach-bcm/board_bcm21664.c                 |  78 +++
 arch/arm/mach-clps711x/board-autcpu12.c            |   2 -
 arch/arm/mach-clps711x/board-cdb89712.c            |   2 -
 arch/arm/mach-clps711x/board-clep7312.c            |   2 -
 arch/arm/mach-clps711x/board-edb7211.c             |   2 -
 arch/arm/mach-clps711x/board-p720t.c               |   2 -
 arch/arm/mach-clps711x/common.c                    | 201 +-----
 arch/arm/mach-clps711x/common.h                    |   5 +-
 arch/arm/mach-clps711x/include/mach/clps711x.h     |  16 -
 arch/arm/mach-davinci/Kconfig                      |  12 -
 arch/arm/mach-davinci/Makefile                     |   2 -
 arch/arm/mach-davinci/Makefile.boot                |  20 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        | 287 --------
 arch/arm/mach-davinci/davinci.h                    |   2 +
 arch/arm/mach-davinci/devices-tnetv107x.c          | 434 ------------
 arch/arm/mach-davinci/devices.c                    |  17 +-
 arch/arm/mach-davinci/dm355.c                      |   8 +-
 arch/arm/mach-davinci/dm365.c                      |   8 +-
 arch/arm/mach-davinci/dm644x.c                     |   8 +-
 arch/arm/mach-davinci/dm646x.c                     |   8 +-
 arch/arm/mach-davinci/include/mach/cputype.h       |   8 -
 arch/arm/mach-davinci/include/mach/irqs.h          |  97 ---
 arch/arm/mach-davinci/include/mach/mux.h           | 269 --------
 arch/arm/mach-davinci/include/mach/psc.h           |  47 --
 arch/arm/mach-davinci/include/mach/serial.h        |   8 -
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |  61 --
 arch/arm/mach-davinci/include/mach/uncompress.h    |   6 -
 arch/arm/mach-davinci/tnetv107x.c                  | 766 ---------------------
 arch/arm/mach-dove/Kconfig                         |  12 -
 arch/arm/mach-dove/Makefile                        |   1 -
 arch/arm/mach-imx/Kconfig                          |  43 +-
 arch/arm/mach-imx/Makefile                         |   9 +-
 arch/arm/mach-imx/clk-imx21.c                      |   1 -
 arch/arm/mach-imx/clk-imx25.c                      |   8 -
 arch/arm/mach-imx/clk-imx27.c                      |   1 -
 arch/arm/mach-imx/clk-imx51-imx53.c                |   2 -
 arch/arm/mach-imx/clk-imx6q.c                      |   7 +-
 arch/arm/mach-imx/clk-imx6sl.c                     | 159 ++++-
 arch/arm/mach-imx/clk-vf610.c                      |  36 +-
 arch/arm/mach-imx/common.h                         |  17 +-
 arch/arm/mach-imx/cpuidle-imx6q.c                  |   4 +-
 arch/arm/mach-imx/cpuidle-imx6sl.c                 |  57 ++
 arch/arm/mach-imx/cpuidle.h                        |   5 +
 arch/arm/mach-imx/devices-imx25.h                  |   4 -
 arch/arm/mach-imx/devices-imx51.h                  |   4 -
 arch/arm/mach-imx/devices/Kconfig                  |   3 -
 arch/arm/mach-imx/devices/Makefile                 |   1 -
 arch/arm/mach-imx/devices/devices-common.h         |   9 -
 arch/arm/mach-imx/devices/platform-mxc_pwm.c       |  69 --
 arch/arm/mach-imx/hardware.h                       |   4 +-
 arch/arm/mach-imx/headsmp.S                        |  40 --
 arch/arm/mach-imx/mach-imx6q.c                     |  98 ++-
 arch/arm/mach-imx/mach-imx6sl.c                    |   6 +-
 arch/arm/mach-imx/pm-imx6.c                        | 551 +++++++++++++++
 arch/arm/mach-imx/pm-imx6q.c                       | 240 -------
 arch/arm/mach-imx/suspend-imx6.S                   | 361 ++++++++++
 arch/arm/mach-imx/time.c                           |  12 +
 arch/arm/mach-kirkwood/Kconfig                     |   7 -
 arch/arm/mach-kirkwood/Makefile                    |   4 +-
 arch/arm/mach-kirkwood/board-dt.c                  | 113 ++-
 arch/arm/mach-kirkwood/board-mv88f6281gtw_ge.c     |  50 --
 arch/arm/mach-kirkwood/common.c                    |   3 +-
 arch/arm/mach-kirkwood/common.h                    |  13 -
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |   2 +
 arch/arm/mach-kirkwood/pm.c                        |   9 +-
 arch/arm/mach-kirkwood/pm.h                        |  26 +
 arch/arm/mach-msm/common.h                         |   2 -
 arch/arm/mach-mv78xx0/common.c                     |   2 +-
 arch/arm/mach-mvebu/Kconfig                        |  79 ++-
 arch/arm/mach-mvebu/Makefile                       |   8 +-
 arch/arm/mach-mvebu/board-t5325.c                  |  41 ++
 .../arm/mach-mvebu/{armada-370-xp.c => board-v7.c} |  58 +-
 arch/arm/mach-mvebu/board.h                        |  22 +
 .../{mach-dove/board-dt.c => mach-mvebu/dove.c}    |  20 +-
 arch/arm/mach-mvebu/kirkwood-pm.c                  |  76 ++
 arch/arm/mach-mvebu/kirkwood-pm.h                  |  26 +
 arch/arm/mach-mvebu/kirkwood.c                     | 199 ++++++
 arch/arm/mach-mvebu/kirkwood.h                     |  22 +
 arch/arm/mach-mvebu/mvebu-soc-id.c                 |   1 +
 arch/arm/mach-mvebu/system-controller.c            |  14 +-
 arch/arm/mach-omap2/Kconfig                        |   7 -
 arch/arm/mach-omap2/Makefile                       |   1 +
 arch/arm/mach-omap2/board-generic.c                |   3 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |   6 +-
 arch/arm/mach-omap2/cminst44xx.c                   |  18 +-
 arch/arm/mach-omap2/dpll3xxx.c                     |   2 +-
 arch/arm/mach-omap2/id.c                           |  16 +-
 arch/arm/mach-omap2/io.c                           |   1 +
 arch/arm/mach-omap2/mux.h                          |   3 -
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |   1 +
 arch/arm/mach-omap2/prminst44xx.c                  |   3 +
 arch/arm/mach-omap2/soc.h                          |   3 +-
 arch/arm/mach-omap2/timer.c                        |   3 +-
 arch/arm/mach-qcom/board.c                         |  14 -
 arch/arm/mach-qcom/platsmp.c                       | 341 +++++++--
 arch/arm/mach-qcom/scm-boot.h                      |   8 +-
 arch/arm/mach-rockchip/Kconfig                     |   1 +
 arch/arm/mach-rockchip/Makefile                    |   1 +
 arch/arm/mach-rockchip/core.h                      |  22 +
 arch/arm/mach-rockchip/headsmp.S                   |  30 +
 arch/arm/mach-rockchip/platsmp.c                   | 184 +++++
 arch/arm/mach-rockchip/rockchip.c                  |   2 +
 arch/arm/mach-shmobile/Kconfig                     |   3 +
 arch/arm/mach-shmobile/Makefile                    |   3 +-
 arch/arm/mach-shmobile/include/mach/pm-rcar.h      |  15 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |  13 +-
 arch/arm/mach-shmobile/include/mach/r8a7790.h      |   1 +
 arch/arm/mach-shmobile/platsmp-apmu.c              |   3 +-
 arch/arm/mach-shmobile/pm-r8a7779.c                | 131 +---
 arch/arm/mach-shmobile/pm-r8a7790.c                |  45 ++
 arch/arm/mach-shmobile/pm-rcar.c                   | 141 ++++
 arch/arm/mach-shmobile/setup-rcar-gen2.c           |   2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |  17 +-
 arch/arm/mach-shmobile/smp-r8a7790.c               |  17 +
 arch/arm/mach-sunxi/Kconfig                        |   1 +
 arch/arm/mach-sunxi/sunxi.c                        |   4 +-
 arch/arm/mach-tegra/Makefile                       |   1 -
 arch/arm/mach-tegra/cpuidle-tegra114.c             |   7 +-
 arch/arm/mach-tegra/platsmp.c                      |   2 +-
 arch/arm/mach-tegra/powergate.c                    |   2 +
 arch/arm/mach-tegra/tegra2_emc.c                   | 347 ----------
 arch/arm/mach-tegra/tegra2_emc.h                   |  24 -
 arch/arm/mm/Kconfig                                |   2 +-
 arch/arm/mm/cache-feroceon-l2.c                    |  45 +-
 arch/arm/mm/cache-tauros2.c                        |  29 +-
 drivers/bus/imx-weim.c                             |  58 ++
 drivers/irqchip/Kconfig                            |   8 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-clps711x.c                     | 243 +++++++
 include/asm-generic/vmlinux.lds.h                  |  10 +
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |  18 +
 172 files changed, 3918 insertions(+), 3679 deletions(-)
