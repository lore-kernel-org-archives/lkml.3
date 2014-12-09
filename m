Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaLIVlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:41:52 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54065 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaLIVls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:41:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 6/9] ARM: SoC DT updates for 3.19
Date: Tue, 09 Dec 2014 22:40:19 +0100
Message-ID: <14657639.RrnLVWDtO6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:d+2ZEhAUQkRm7scAH9rSaaiYuGcevgNs9RRKuBtDtMEvW0Dbbc3
 XJ8kx2k1XzzMmhhxEFMO2WURRHOpb7CoTOVhzk+XxezCUQJtLw0r0ychIqvDf6gJ1D3KpZR
 Ew6hdU0bPMjogjjPO0P6R+lvpviHZo6M9q2Nt2jiUY1U4wRwCsD/pXi+tqv6AqyYb3RgZ8A
 4pmMzLSVJ1DI+j6pw5WWQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 65b5732d241b8b39e07653794eefffd0d8028cbb:

  clocksource: arch_timer: Allow the device tree to specify uninitialized timer registers (2014-12-04 23:31:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to e2405a59e54856460468c80ea92ee3dce35c2c86:

  ARM: dts: rk3288: add arm,cpu-registers-not-fw-configured (2014-12-05 10:27:16 -0800)

----------------------------------------------------------------
ARM: SoC DT updates for 3.19

The DT branch adds a lot of new stuff for additional SoC and board
support. The branch is the largest one and contains 513 out of the
total 972 non-merge arm-soc changesets for 3.19.

Most of the changes are about enabling additional on-chip devices for
existing machines, but there are also an unusual number of new SoC
types being added this time:

* AMLogic Meson8
* ARM Realview in DT mode
* Allwinner A80
* Broadcom BCM47081
* Broadcom Cygnus
* Freescale LS1021A
* Freescale Vybrid 500 series
* Mediatek MT6592, MT8127, MT8135
* STMicroelectronics STiH410
* Samsung Exynos4415

The level of support for the above differs widely, some are just
stubs with nothing more than CPU, memory and a UART, but others
are fairly complete. As usual, these get extended over time.

There are also many new boards getting added, this is the
list of model strings that are showing up in new dts files:

* ARM RealView PB1176
* Altera SOCFPGA Arria 10
* Asus RT-N18U (BCM47081)
* Buffalo WZR-1750DHP (BCM4708)
* Buffalo WZR-600DHP2 (BCM47081)
* Cygnus Enterprise Phone (BCM911360_ENTPHN)
* D-Link DIR-665
* Google Spring
* IGEP COM MODULE Rev. G (TI OMAP AM/DM37x)
* IGEPv2 Rev. F (TI OMAP AM/DM37x)
* LS1021A QDS Board
* LS1021A TWR Board
* LeMaker Banana Pi
* MarsBoard RK3066
* MediaTek MT8127 Moose Board
* MediaTek MT8135 evaluation board
* Mele M3
* Merrii A80 Optimus Board
* Netgear R6300 V2 (BCM4708)
* Nomadik STN8815NHK
* NovaTech OrionLXm
* Olimex A20-OLinuXino-LIME2
* Raspberry Pi Model B+
* STiH410 B2120
* Samsung Monk board
* Samsung Rinato board
* Synology DS213j
* Synology DS414
* TBS2910 Matrix ARM mini PC
* TI AM5728 BeagleBoard-X15
* Toradex Colibri VF50 on Colibri Evaluation Board
* Zynq ZYBO Development Board

Other notable changes include:

* exynos: cleanup of existing dts files
* mvebu: improved pinctrl support for Armada 370/XP
* nomadik: restructuring dts files
* omap: added CAN bus support
* shmobile: added clock support for some SoCs
* shmobile: added sound support for some SoCs
* sirf: reset controller support
* sunxi: continuing the relicensing under dual GPL/MIT
* sunxi: lots of new on-chip device support
* sunxi: working simplefb support (long awaited)
* various: provide stdout-path property for earlycon

----------------------------------------------------------------
Adam YH Lee (1):
      ARM: dts: Gumstix DuoVero: Bind vdac regulator to hdmi node

Alexander Stein (2):
      ARM: at91/dt: at91sam9x5: Add CAN device nodes
      ARM: at91/dt: at91sam9263: Add CAN device nodes

Andreas Faerber (11):
      ARM: dts: Prepare node labels for exynos5250
      ARM: dts: Clean up exynos5250-snow
      ARM: dts: Fill in bootargs for exynos5250-snow
      ARM: dts: Clean up exynos5250-smdk5250
      ARM: dts: Clean up exynos5250-arndale
      ARM: dts: Fix apparent GPIO typo in exynos5250-arndale
      ARM: dts: Simplify USB3503 on exynos5250-arndale
      ARM: dts: Add exynos5250-spring device tree
      ARM: dts: Add usb3503 pinctrl to exynos5250-spring
      ARM: dts: Add temperature sensor to exynos5250-spring
      ARM: dts: Add trackpad to exynos5250-spring

Andreas Färber (1):
      Documentation: devicetree: Fix Xilinx VDMA specification

Andrew Lunn (2):
      ARM: Kirkwood: DIR665: Instantiate Distributed Switch Architecture
      mvebu: 370 RD: Add support for the switch

Antoine Tenart (2):
      ARM: dts: berlin: add BG2Q nodes for USB support
      ARM: dts: Berlin: enable USB on the BG2Q DMP

Antoine Ténart (6):
      ARM: dts: berlin: add the AHCI node for the BG2Q
      ARM: dts: berlin: enable the eSATA interface on the BG2Q DMP
      Documentation: bindings: add reset bindings docs for Marvell Berlin SoCs
      ARM: dts: berlin: add a required reset property in the chip controller node
      ARM: dts: berlin: enable timer 1 for sched_clock
      ARM: dts: berlin: Add phy-connection-type to BG2Q Ethernet

Arnaud Ebalard (15):
      arm: mvebu: Fix LED color in NETGEAR ReadyNAS 102 .dts file
      arm: mvebu: Clarify (e)SATA ports info in NETGEAR ReadyNAS 102 .dts file
      ARM: mvebu: Enable rear eSATA ports of NETGEAR ReadyNAS 2120
      arm: mvebu: fix vendor prefix typo in kirkwood-synology.dtsi
      arm: mvebu: add uartX labels for Armada SoC serial nodes
      arm: mvebu: use recently introduced uart label for stdout-path
      arm: mvebu: move Armada 370/XP pinctrl node definition armada-370-xp.dtsi
      arm: mvebu: define and use common Armada 370 SPI pinctrl settings
      arm: mvebu: define and use common Armada 370 UART pinctrl settings
      arm: mvebu: define and use common Armada XP UART2/3 pinctrl settings
      arm: mvebu: define and use common Armada XP SPI pinctrl setting
      arm: mvebu: add .dts file for Synology DS213j
      arm: mvebu: add .dts file for Synology DS414
      arm: mvebu: fix wrongly named DS414 pinctrl entries
      arm: mvebu: normalize pinctrl entries for Armada SoCs

Arnd Bergmann (31):
      Merge branch 'renesas/dt-du' into next/dt
      Merge tag 'renesas-dt-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt-cleanups2-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt-cleanups3-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'hix5hd2-dt-for-3.19' of git://github.com/hisilicon/linux-hisi into next/dt
      Merge tag 'mvebu-dt-3.19' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'omap-for-v3.19/dt-part1' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'arm-soc/for-3.19/cygnus-dts-v2' of http://github.com/brcm/linux into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'v3.19-next-dts' of https://github.com/mbgg/linux-mediatek into next/dt
      Merge tag 'sti-dt-for-v3.19-2' of git://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge tag 'v3.19-meson-dts' of https://github.com/carlocaione/linux-meson into next/dt
      Merge tag 'sunxi-dt-for-3.19' of git://git.kernel.org/.../mripard/linux into next/dt
      Merge tag 'v3.19-rockchip-dts2' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'berlin-dt-3.19-2' of git://git.infradead.org/users/hesselba/linux-berlin into next/dt
      Merge tag 'renesas-dt2-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'socfpga_dts_updates_for_v3.19' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Revert "ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks."
      Revert "ARM: dts: sunxi: unify APB1 clock"
      Merge branch 'sunxi/dt' into next/dt
      Merge tag 'v3.19-rockchip-dts3' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'samsung-dt-3' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'omap-for-v3.19/dt-part2-updated' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'imx-dt-3.19' of git://git.kernel.org/.../shawnguo/linux into next/dt
      Merge tag 'sunxi-simplefb-for-3.19' of https://git.kernel.org/.../mripard/linux into next/dt
      Merge tag 'sirf-dts-for-3.19' of git://git.kernel.org/.../baohua/linux into next/dt
      Merge tag 'mvebu-dt-3.19-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'bcm5301x-dt-2014-11-27' of https://github.com/hauke/linux into next/dt
      Merge tag 'zynq-dt-for-3.19' of https://github.com/Xilinx/linux-xlnx into next/dt
      Merge tag 'v3.19-rockchip-dts4' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt

Bartlomiej Zolnierkiewicz (1):
      ARM: dts: add CPU nodes for Exynos4 SoCs

Beniamino Galvani (3):
      ARM: dts: add dtsi for Amlogic Meson8 SoCs
      ARM: meson: DTS: enable L2 cache
      ARM: dts: meson: add I2C controller nodes

Bhuvanchandra DV (5):
      ARM: dts: vf610: Add PWM second instance
      ARM: dts: vf610-colibri: Add PWM support
      ARM: dts: vf610-colibri: Add backlight support
      ARM: dts: vf-colibri: Add I2C support
      ARM: dts: vf-colibri-eval-v3.dts: Enable ST-M41T0M6 RTC

Caesar Wang (3):
      ARM: dts: rockchip: add RK3288 Thermal data
      ARM: dts: rockchip: add main thermal info to rk3288
      ARM: dts: rockchip: enable thermal on rk3288-evb board

Carlo Caione (1):
      DTS: meson: Add forgotten compatible in board DTS

Chanwoo Choi (6):
      ARM: dts: Add board dts file for exynos3250-rinato
      ARM: dts: Add sleep mode pin configuration for exynos3250-rinato
      ARM: dts: Add sleep mode of regulator for exynos3250-rinato
      ARM: dts: Add dts files for exynos4415 SoC
      Documentation: devicetree: Add Exynos-based boards compatible string
      ARM: dts: Remove unused bootargs from exynos3250-rinato

Chen-Yu Tsai (21):
      ARM: dts: sunxi: Add Allwinner A80 dtsi
      ARM: dts: sun9i: Add A80 Optimus Board support
      ARM: dts: sun9i: Add basic clocks and reset controls
      ARM: dts: sun9i: Add i2c controller nodes to a80 dtsi
      ARM: dts: sun9i: Add i2c3 pinmux setting for A80 SoC
      ARM: dts: sun9i: Enable i2c3 on A80 Optimus board
      ARM: dts: sun9i: Add GPIO LEDs for A80 Optimus board
      ARM: dts: sun9i: Add uart4 pinmux setting for A80 SoC
      ARM: dts: sun9i: Enable uart4 for A80 Optimus board
      ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks.
      ARM: sun6i: DT: Add PLL6 multiple outputs
      ARM: dts: sunxi: Add Allwinner A80 dtsi
      ARM: dts: sun9i: Add A80 Optimus Board support
      ARM: dts: sun9i: Add basic clocks and reset controls
      ARM: dts: sun9i: Add i2c controller nodes to a80 dtsi
      ARM: dts: sun9i: Add i2c3 pinmux setting for A80 SoC
      ARM: dts: sun9i: Enable i2c3 on A80 Optimus board
      ARM: dts: sun9i: Add GPIO LEDs for A80 Optimus board
      ARM: dts: sun9i: Add uart4 pinmux setting for A80 SoC
      ARM: dts: sun9i: Enable uart4 for A80 Optimus board
      ARM: sun6i: DT: Add PLL6 multiple outputs

Christian Hemp (5):
      ARM: dts: imx6: phyFLEX: set nodes in alphabetical order
      ARM: dts: imx6: phyFLEX: Enable gpmi in module file
      ARM: dts: imx6: phyFLEX: Set correct interrupt for pmic
      ARM: dts: imx6: phyFLEX: Add PCIe
      ARM: dts: imx6: phyFLEX: Add CAN support

Claudio Leite (1):
      ARM: Kirkwood: Add support for DLink DIR665

Daniel Kurtz (1):
      ARM: dts: rk3288: add VOP iommu nodes

Darshana Padmadas (4):
      dt-bindings: Document correct and deprecated vendor-prefix with device isl29028
      dt-bindings: Document deprecated device vendor name to fix related warning
      Staging: iio: light: Added correct vendor-prefix for device isl29028
      arch: arm: boot: dts: Correct vendor-prefix for iio device isl29028 in compatible property

Dinh Nguyen (3):
      arm: dts: socfpga: Add OCRAM node
      arm: dts: socfpga: enable watchdog for socfpga platform
      arm: dts: socfpga: Add a base DTSI for Altera's Arria10 SOC

Dmitry Lavnikevich (2):
      ARM: dts: pbab01: move i2c pins and frequency configuration into pfla02
      ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6 boards

Dmitry Lifshitz (10):
      ARM: dts: cm-t3x: cleanup comments indentation
      ARM: dts: cm-t3x: add ADS7846 touchscreen support
      ARM: OMAP2+: remove cm-t3x touchscreen pdata quirk
      ARM: dts: cm-t3x: add EEPROM support
      ARM: dts: sb-t35: add EEPROM support
      ARM: dts: cm-t3x30: add keypad support
      ARM: dts: cm-t3x: add I2C1 pinmux
      ARM: dts: cm-t3x: add TV out support
      ARM: dts: sbc-t3x: add TV out display alias
      ARM: dts: sbc-t3x30: add audio support

Doug Anderson (1):
      ARM: dts: rockchip: Add SPI DMA into rk3288.dtsi

Emilio López (1):
      ARM: dts: sunxi: unify APB1 clock

Ezequiel Garcia (1):
      ARM: mvebu: Enable the reference clock for timer and watchdog on Armada 375 SoC

Fabio Estevam (3):
      ARM: dts: imx53: Improve SSI clocks description
      ARM: dts: imx51: Improve SSI clocks description
      ARM: dts: imx6q-tbs2910: Remove unneeded 'fsl,mode' property

Fugang Duan (1):
      ARM: dts: imx6x: Add enet2 support for imx6sx-sdb board

Gabriel FERNANDEZ (6):
      ARM: STi: DT: STiH407: 407 DT Entry for clockgen A0
      ARM: STi: DT: STiH407: 407 DT Entry for clockgen C0
      ARM: STi: DT: STiH407: 407 DT Entry for clockgen D0/D2/D3
      ARM: STi: DT: STiH407: 407 DT Entry for clockgenA9
      ARM: STi: DT: STiH407: Add all defines for STiH407 DT clocks
      ARM: STi: DT: STiH407: Fix: clk-tmds-hdmi clock is missing

Geert Uytterhoeven (17):
      clocksource: sh_tmu: Document R-Mobile r8a7740 binding
      clocksource: sh_tmu: Document r8a7778 binding
      clocksource: sh_mtu2: Drop incorrect SoC family name
      ARM: shmobile: r8a7740 dtsi: Add missing INTCA clock for irqpin module
      ARM: shmobile: r8a7740 dtsi: Fix clock index for scifa2
      ARM: shmobile: r8a7740 dtsi: Add TMU0 and TMU1 device nodes
      ARM: shmobile: armadillo800eva dts: Enable TMU0
      ARM: shmobile: r8a73a4: Add SoC-specific CMT compatible property
      ARM: shmobile: r8a7778: Add SoC-specific TMU compatible property
      ARM: shmobile: r8a7779 dtsi: Add SoC-specific SATA compatible property
      ARM: shmobile: r8a7790 dtsi: Drop bogus 0x unit-address prefix
      ARM: shmobile: r8a7791 dtsi: Drop bogus 0x unit-address prefix
      ARM: shmobile: kzm9g-reference dts: Drop bogus 0x unit-address prefix
      ARM: shmobile: r8a73a4 dtsi: Add SoC-specific IIC compatible properties
      ARM: shmobile: sh73a0 dtsi: Add SoC-specific IIC compatible properties
      ARM: shmobile: koelsch dts: Add labels for the LEDs
      ARM: shmobile: kzm9g-reference dts: Add labels for the LEDs

George McCollister (1):
      ARM: dts: Add devicetree for NovaTech OrionLXm

Gregory CLEMENT (1):
      ARM: mvebu: Fix the Aurora L2 cache node with the required cache-unified property

Grygorii Strashko (2):
      ARM: dts: k2e-evm: add 1g ethernet phys nodes
      ARM: dts: k2l-evm: add 1g ethernet phys nodes

Hans de Goede (24):
      ARM: dts: sun7i: Add spi0_pins_a pinctrl setting
      ARM: dts: sun7i: Add uart3_pins_b pinctrl setting
      ARM: dts: sun7i: Add Banana Pi board
      ARM: dts: sun7i: Add mmc2_pins_a pinctrl definition
      ARM: dts: sun7i: Add Mele M3 board
      ARM: dts: sunxi: Add regulator-boot-on property to ahci-5v regulator
      ARM: dts: sun6i: Add EHCI support for the M9 board
      ARM: dts: sun6i: Add support for the status led
      ARM: dts: sun6i: Add ethernet support to M9 board
      ARM: dts: sun7i: Add spi0_pins_a pinctrl setting
      ARM: dts: sun7i: Add uart3_pins_b pinctrl setting
      ARM: dts: sun7i: Add Banana Pi board
      ARM: dts: sun7i: Add mmc2_pins_a pinctrl definition
      ARM: dts: sun7i: Add Mele M3 board
      ARM: dts: sunxi: Add regulator-boot-on property to ahci-5v regulator
      ARM: dts: sun6i: Add EHCI support for the M9 board
      ARM: dts: sun6i: Add support for the status led
      ARM: dts: sun6i: Add ethernet support to M9 board
      ARM: dts: sun4i: Add simplefb node
      ARM: dts: sun5i: Add simplefb node
      ARM: dts: sun6i: Add simplefb node
      ARM: dts: sun7i: Add simplefb node
      ARM: dts: sunxi: Add de_be0 clk parent pll to simplefb node
      ARM: dts: sunxi: Update simplefb nodes so that u-boot can find them

Hauke Mehrtens (1):
      ARM: BCM5301X: Add IRQs to Broadcom's bus-axi in DTS file

Heiko Stuebner (3):
      ARM: dts: rockchip: add operating points and armclk references
      ARM: dts: rockchip: add cpu supplies to boards
      ARM: dts: rockchip: temporarily disable smp on rk3288

Hisashi Nakamura (1):
      ARM: shmobile: r8a7794: Add arch_timer to device tree

Howard Chen (3):
      ARM: mediatek: Add basic support for mt6592
      ARM: mediatek: add dts for mt6592-evb
      dt-bindings: add documentation for Mediatek SoC

Iain Paton (2):
      ARM: sun7i: add support for A20-OLinuXino-Lime2
      ARM: sun7i: add support for A20-OLinuXino-Lime2

Jacek Anaszewski (1):
      ARM: dts: add MFC codec device node for exynos3250

Jaewon Kim (2):
      ARM: dts: add pwm node for exynos4412-trats2
      ARM: dts: Add max77693-haptic node for exynos4412-trats2

Javier Martinez Canillas (2):
      ARM: dts: Add rtc_src clk for s3c-rtc on exynos Peach boards
      ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow

Jingchang Lu (4):
      ARM: dts: Add SoC level device tree support for LS1021A
      ARM: dts: Add initial LS1021A QDS board dts support
      ARM: dts: Add initial LS1021A TWR board dts support
      dt-bindings: arm: add Freescale LS1021A SoC device tree binding

Jiri Prchal (1):
      ARM: at91: at91sam9x5 dt: add usart dma definitions to dt

Joe.C (6):
      ARM: mediatek: Add basic support for mt8127
      ARM: mediatek: add dts for 8127 Moose board
      ARM: mediatek: Add basic support for mt8135
      ARM: mediatek: add dts for MT8135 evaluation board.
      ARM: dts: Build dtb for mt8127 & mt8135
      dt-bindings: add more chips in documentation for Mediatek SoC

Jonathan Richardson (2):
      dt-bindings: Document Broadcom Cygnus SoC and clocks
      dt-bindings: Document Broadcom Cygnus SoC and clocks

Julien CHAUVEAU (6):
      ARM: dts: rockchip: enable DMA on SPI for rk3066 and rk3188
      ARM: dts: rockchip: add I2S controllers for rk3066 and rk3188
      ARM: dts: rockchip: add serial aliases for rk3066 and rk3188
      ARM: dts: rockchip: fix invalid unit-address in rk3188.dtsi
      ARM: dts: rockchip: enable PWM on Radxa Rock
      ARM: dts: rockchip: set FIFO size for SDMMC, SDIO and EMMC on rk3066 and rk3188

Karsten Merker (2):
      ARM: dts: sunxi: Banana Pi: increase startup-delay for the GMAC PHY regulator
      ARM: dts: sunxi: Banana Pi: increase startup-delay for the GMAC PHY regulator

Kever Yang (4):
      ARM: dts: rockchip: enable init rate for clock
      ARM: dts: rockchip: add pmu references to cpus nodes
      ARM: dts: rockchip: add intmem node for rk3288 smp support
      ARM: dts: rockchip: add reset for CPU nodes

Koji Matsuoka (1):
      ARM: shmobile: r8a7794: Add VIN clock to device tree

Kouei Abe (3):
      ARM: shmobile: r8a7790: Add RGX clock to device tree
      ARM: shmobile: r8a7791: Add SGX clock to device tree
      ARM: shmobile: r8a7794: Add SGX clock to device tree

Krzysztof Kozlowski (2):
      ARM: dts: Add Maxim 77693 PMIC to exynos4412-trats2
      ARM: dts: Add micro SD card SDHCI node for exynos4412-trats

Kuninori Morimoto (21):
      ARM: shmobile: r8a7778 dtsi: Remove unnecessary MMC options
      ARM: shmobile: r8a7779 dtsi: Remove unnecessary MMC options
      ARM: shmobile: r8a7790 dtsi: Remove unnecessary MMC options
      ARM: shmobile: r8a7790: Add Audio DMAC devices to DT
      ARM: shmobile: r8a7791: Add Audio DMAC devices to DT
      ARM: shmobile: r8a7790: Add Audio DMAC peri peri devices to DT
      ARM: shmobile: r8a7791: Add Audio DMAC peri peri devices to DT
      ARM: shmobile: lager: fixup IIC2 clock frequency
      ARM: shmobile: lager: Sound PIO support on DTS
      ARM: shmobile: lager: Sound DMA support on DTS
      ARM: shmobile: lager: Sound DMA support via BUSIF on DTS
      ARM: shmobile: lager: Sound DMA support via SRC on DTS
      ARM: shmobile: lager: Sound DMA support via DVC on DTS
      ARM: shmobile: koelsch: fixup I2C2 clock frequency
      ARM: shmobile: koelsch: Sound PIO support on DTS
      ARM: shmobile: koelsch: Sound DMA support on DTS
      ARM: shmobile: koelsch: Sound DMA support via BUSIF on DTS
      ARM: shmobile: koelsch: Sound DMA support via SRC on DTS
      ARM: shmobile: koelsch: Sound DMA support via DVC on DTS
      ARM: shmobile: lager: add Volume Ramp usage on comment
      ARM: shmobile: koelsch: add Volume Ramp usage on comment

Laurent Pinchart (4):
      ARM: shmobile: r8a7790: Rename mmcif node to mmc
      ARM: shmobile: r8a7791: Add MMCIF0 DT node
      ARM: shmobile: r8a7790: Reference DMA channels in MMCIF DT nodes
      ARM: shmobile: r8a7791: Reference DMA channels in MMCIF DT node

Lee Jones (4):
      ARM: STi: DT: STiH41x: Convert all uppercase non-defines to lowercase
      ARM: STi: DT: STiH416: Supply Thermal Controller Device Tree nodes
      ARM: DT: STi: STiH416: Add DT node for MiPHY365x
      ARM: DT: STi: STiH416: Add DT node for ST's SATA device

Linus Walleij (18):
      ARM: realview: basic device tree implementation
      ARM: realview: add device tree and bindings for PB1176
      ARM: realview: move DT GIC to FPGA node
      ARM: realview: add PL061 GPIO to the PB1176 DTS
      ARM: realview: add charlcd to PB1176 device tree
      ARM: realview: add RTC clocks to device tree
      ARM: realview: add PL022 SSP/SPI block to PB1176 DTS
      ARM: realview: add FPGA UART4 to PB1176 DTS
      ARM: realview: add KMIs to the PB1176 DTS
      ARM: realview: add MMCI to the PB1176 DTS
      ARM: nomadik: move MMC/SD card detect GPIO to board DTS
      ARM: nomadik: disable chrystals in top level board files
      ARM: nomadik: move GPIO I2C to S8815 board file
      ARM: nomadik: set up MCDATDIR2
      ARM: nomadik: push ethernet down to board
      ARM: nomadik: device tree for NHK15 board
      ARM: update Nomadik config
      ARM: nomadik: configure in STMPE support

Lokesh Vutla (1):
      ARM: dts: DRA7: Add node for RTC

Lucas Stach (1):
      ARM: dts: imx53: add cpufreq-dt support

Lukasz Majewski (2):
      ARM: dts: Device tree node definition for TMU on exynos4x12
      ARM: dts: Enable TMU support for exynos4412-trats2

Marcin Wojtas (3):
      ARM: mvebu: enable no-1-8-v flag for Armada 385 DB SDHCI interface
      ARM: mvebu: remove clock-frequency from Armada 38x SDHCI Device Tree node
      ARM: mvebu: adjust ethernet aliases according to U-Boot requirements for A38x

Marek Szyprowski (1):
      ARM: dts: add missing clock to MFC device for exynos4

Matthias Klein (1):
      ARM: bcm2835: Add device tree for Raspberry Pi model B+

Maxime Ripard (49):
      ARM: sunxi: regulators: Relicense the device tree under GPLv2/X11
      ARM: sun4i: ba10: Relicense the device tree under GPLv2/X11
      ARM: sun4i: hackberry: Relicense the device tree under GPLv2/X11
      ARM: sun4i: inet97fv2: Relicense the device tree under GPLv2/X11
      ARM: sun4i: mini xplus: Relicense the device tree under GPLv2/X11
      ARM: sun4i: olinuxino lime: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino micro: Relicense the device tree under GPLv2/X11
      ARM: sun5i: r7: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino micro: Relicense the device tree under GPLv2/X11
      ARM: sun6i: colombus: Relicense the device tree under GPLv2/X11
      ARM: sun6i: hummingbird: Relicense the device tree under GPLv2/X11
      ARM: sun6i: m9: Relicense the device tree under GPLv2/X11
      ARM: sun7i: i12: Relicense the device tree under GPLv2/X11
      ARM: sun8i: q8h: Relicense the device tree under GPLv2/X11
      ARM: sun6i: app4: Relicense the device tree under GPLv2/X11
      ARM: sunxi: Fix GPLv2 wording
      ARM: sun4i: a1000: Relicense the device tree under GPLv2/X11
      ARM: sun9i: Enable the A80 pinctrl driver
      ARM: sun9i: optimus: Set UART0 muxing
      ARM: sun7i: olinuxino lime: Relicense the device tree under GPLv2/X11
      ARM: sun4i: pcduino: Relicense the device tree under GPLv2/X11
      ARM: sun7i: pcduino3: Relicense the device tree under GPLv2/X11
      ARM: sun4i: cubieboard: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino: Relicense the device tree under GPLv2/X11
      Merge branch 'sunxi/fixes-for-3.18' into HEAD
      ARM: sunxi: regulators: Relicense the device tree under GPLv2/X11
      ARM: sun4i: ba10: Relicense the device tree under GPLv2/X11
      ARM: sun4i: hackberry: Relicense the device tree under GPLv2/X11
      ARM: sun4i: inet97fv2: Relicense the device tree under GPLv2/X11
      ARM: sun4i: mini xplus: Relicense the device tree under GPLv2/X11
      ARM: sun4i: olinuxino lime: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino micro: Relicense the device tree under GPLv2/X11
      ARM: sun5i: r7: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino micro: Relicense the device tree under GPLv2/X11
      ARM: sun6i: colombus: Relicense the device tree under GPLv2/X11
      ARM: sun6i: hummingbird: Relicense the device tree under GPLv2/X11
      ARM: sun6i: m9: Relicense the device tree under GPLv2/X11
      ARM: sun7i: i12: Relicense the device tree under GPLv2/X11
      ARM: sun8i: q8h: Relicense the device tree under GPLv2/X11
      ARM: sun6i: app4: Relicense the device tree under GPLv2/X11
      ARM: sunxi: Fix GPLv2 wording
      ARM: sun4i: a1000: Relicense the device tree under GPLv2/X11
      ARM: sun9i: Enable the A80 pinctrl driver
      ARM: sun9i: optimus: Set UART0 muxing
      ARM: sun7i: olinuxino lime: Relicense the device tree under GPLv2/X11
      ARM: sun4i: pcduino: Relicense the device tree under GPLv2/X11
      ARM: sun7i: pcduino3: Relicense the device tree under GPLv2/X11
      ARM: sun4i: cubieboard: Relicense the device tree under GPLv2/X11
      ARM: sun5i: olinuxino: Relicense the device tree under GPLv2/X11

Mugunthan V N (1):
      ARM: dts: am437x-gp: Add dcan support

Murali Karicheri (2):
      ARM: dts: keystone: add DT bindings for PCI controller for port 0
      ARM: dts: keystone-k2e: add DT bindings for PCI controller for port 1

Naveen Krishna Chatradhi (1):
      ARM: dts: correct the mmc0 capability string for exynos Peach boards

Nicolas Ferre (1):
      ARM: at91/dt/trivial: at91sam9x5_can.dtsi: comment and whitespace fixes

Olof Johansson (14):
      Merge tag 'samsung-dt' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'arm-realview-dt-for-arm-soc' of git://git.kernel.org/.../linusw/linux-integrator into next/dt
      Merge tag 'renesas-dt-cleanups-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-r8a73a4-dt-timers-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'v3.19-rockchip-dts1' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'renesas-dt-clocksource-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'arm-soc/for-3.18/cygnus-dts-v9' of http://github.com/brcm/linux into next/dt
      Merge tag 'sti-dt-for-v3.19-1' of git://git.stlinux.com/devel/kernel/linux-sti into next/dt
      Merge tag 'berlin-dt-3.19-1' of git://git.infradead.org/users/hesselba/linux-berlin into next/dt
      Merge tag 'at91-dt' of git://git.kernel.org/.../nferre/linux-at91 into next/dt
      Merge tag 'nomadik-for-v3.19' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'bcm5301x-dt-2014-12-04' of https://github.com/hauke/linux into next/dt
      Merge branch 'clocksource/physical-timers' into next/dt
      Revert "ARM: dts: rockchip: temporarily disable smp on rk3288"

Pankaj Dubey (1):
      ARM: dts: add sysreg phandle to i2c device nodes for exynos

Peter Crosthwaite (3):
      doc: dt: vendor-prefixes: Add Digilent Inc
      arm: dts: zynq: Move crystal freq. to board level
      arm: dts: zynq: Add Digilent ZYBO board

Peter Griffin (17):
      ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
      ARM: sti: Add STiH407 reset controller support.
      ARM: STi: DT: Add sdhci pins for stih416
      ARM: STi: DT: Add sdhci controller for stih416
      ARM: STi: DT: Add sdhci pin configuration for stih415
      ARM: STi: DT: Add sdhci controller for stih415
      ARM: STi: DT: Enable mmc0 for both stih415 and stih416 SoCs
      ARM: STi: DT: Enable second sdhci controller for stih416 b2020 boards.
      ARM: STi: DT: STiH416: Add pinctl setup for usb controllers.
      ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
      ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb controllers.
      ARM: STi: DT: STiH410: Add defines for STiH410 DT clocks
      ARM: STi: DT: STiH410: Add pinctl config for usb controllers.
      ARM: STi: DT: STih407: Abstract common dt nodes into shared files.
      ARM: STi: DT: STiH410: Add STiH410 SoC and b2120 board support.
      ARM: STi: DT: STih407: STih410: Add clk_ignore_unused to kernel bootargs
      ARM: STi: DT: STiH416: Change miphy356 node name to phy@fe382000

Philipp Zabel (1):
      ARM: dts: imx6qdl: Enable CODA960 VPU

Qipan Li (1):
      ARM: dts: atlas6: add resets property for SPI nodes

Rafał Miłecki (7):
      ARM: BCM5301X: Add Broadcom's bus-axi to the DTS file
      ARM: BCM5301X: Add LEDs for Netgear R6250 V1
      ARM: BCM5301X: Add buttons for Netgear R6250
      ARM: BCM5301X: Add DT for Netgear R6300 V2
      ARM: BCM5301X: Add DT for Buffalo WZR-1750DHP
      ARM: BCM5301X: Add DT for Asus RT-N18U
      ARM: BCM5301X: Add DT for Buffalo WZR-600DHP2

Renwei Wu (2):
      ARM: dts: prima2: add resets property for VPP nodes
      ARM: dts: atlas6: add resets property for VPP nodes

Robin Gong (1):
      ARM: dts: imx6: add pm_power_off support for i.mx6 chips

Roger Quadros (9):
      ARM: dts: dra7: Add syscon regmap for CORE CONTROL area
      ARM: dts: DRA7: Add DCAN nodes
      ARM: dts: dra7-evm: Add CAN support
      ARM: dts: dra72-evm: Add CAN support
      ARM: dts: am4372: Add control module syscon node
      ARM: dts: am4372: Add DCAN nodes
      ARM: dts: am33xx: Add control module syscon node
      ARM: dts: am33xx: Update DCAN nodes
      ARM: dts: am335x-evm: Add DCAN1 details

Romain Perier (4):
      ARM: dts: rockchip: Add EMAC Rockchip for RK3066 SoCs
      ARM: dts: rockchip: Add devicetree source for MarsBoard RK3066
      ARM: dts: rockchip: add label property for leds on Radxa Rock
      ARM: dts: rockchip: Add input voltage supply regulators in pmic for Marsboard

Roman Byshko (8):
      ARM: dtsi: sunxi: add common VBUS regulator
      ARM: sun7i: dtsi: add support for usbphy0
      ARM: dts: sun7i: Cubietruck: override regulator pin
      ARM: dts: sun7i: Cubietruck: add power supply regulator for USB OTG VBUS
      ARM: dtsi: sunxi: add common VBUS regulator
      ARM: sun7i: dtsi: add support for usbphy0
      ARM: dts: sun7i: Cubietruck: override regulator pin
      ARM: dts: sun7i: Cubietruck: add power supply regulator for USB OTG VBUS

Rongjun Ying (3):
      ARM: dts: prima2: add I2S 2ch, 6ch, nodin, mclk groups
      ARM: dts: atlas6: add a separate pingroup for i2s mclk output
      ARM: dts: atlas6: Add I2S external clock input pingroup

Sanchayan Maity (1):
      ARM: dts: vf610-colibri: Add ADC support

Scott Branden (2):
      ARM: dts: Enable Broadcom Cygnus SoC
      ARM: dts: Enable Broadcom Cygnus SoC

Sebastian Hesselbarth (19):
      ARM: dts: berlin: Add GPIO leds to Google Chromecast
      ARM: dts: berlin: Add BG2 ethernet DT nodes
      ARM: dts: berlin: Add BG2CD ethernet DT nodes
      ARM: dts: berlin: Enable ethernet on Sony NSZ-GS7
      ARM: dts: berlin: Add SDHCI controller nodes to BG2/BG2CD
      ARM: dts: berlin: Enable WiFi on Google Chromecast
      ARM: dts: berlin: Enable eMMC on Sony NSZ-GS7
      ARM: mvebu: armada-xp: Consolidate pinctrl node
      ARM: mvebu: armada-xp: Add node alias to pinctrl and add base address
      ARM: mvebu: armada-xp: Use pinctrl node alias
      ARM: mvebu: armada-xp: Move GE0/1 pinctrl settings for RGMII
      ARM: mvebu: armada-xp: Add GE0 pinctrl settings for GMII
      ARM: mvebu: armada-xp: Add RGMII pinctrl to Lenovo ix4-300d
      ARM: mvebu: armada-xp: Add I2C eeprom on Lenovo ix4-300d
      ARM: mvebu: armada-xp: Fix 74hc595 count for Lenovo ix4-300d
      ARM: berlin: Add AHCI and SATA PHY nodes to BG2
      ARM: berlin: Enable SATA on Sony NSZ-GS7
      ARM: dts: berlin: add BG2CD nodes for USB support
      ARM: dts: berlin: enable USB on the Google Chromecast

Sebastian Reichel (2):
      ARM: dts: OMAP3-N900: add si4713 support
      ARM: dst: OMAP3-N900: Add n900-battery support

Sergei Shtylyov (7):
      ARM: shmobile: r8a7790: add USB PHY DT support
      ARM: shmobile: lager: enable USB PHY
      ARM: shmobile: r8a7791: add USB PHY DT support
      ARM: shmobile: koelsch: enable USB PHY
      ARM: shmobile: henninger: enable USB PHY
      ARM: shmobile: r8a7790: link PCI USB devices to USB PHY
      ARM: shmobile: r8a7791: link PCI USB devices to USB PHY

Shawn Guo (1):
      Merge tag 'imx-soc-3.19' into imx/dt

Simon Horman (12):
      ARM: shmobile: r8a73a4: Add CMT1 node
      ARM: shmobile: r8a73a4: Rename cmt registration helper
      ARM: shmobile: ape6evm-reference: Initialise CMT1 device using DT
      ARM: shmobile: r8a73a4: Remove empty r8a73a4_add_dt_devices
      Merge tag 'renesas-r8a73a4-dt-timers-for-v3.19' into dt-for-v3.19.base
      ARM: shmobile: r8a7778: Add TMU nodes
      ARM: shmobile: bockw-reference: Initialise TMU device using DT
      ARM: shmobile: alt dts: Drop console= bootargs parameter
      ARM: shmobile: armadillo800eva: Use keyboard as gpio-keys node name
      ARM: shmobile: lager: Use keyboard as gpio-keys node name
      ARM: shmobile: koelsch: Use keyboard as gpio-keys node name
      ARM: shmobile: kzm9g-reference: Use keyboard as gpio-keys node name

Soeren Moch (3):
      devicetree: bindings: Add vendor prefix for TBS Technologies
      ARM: dts: add initial support for TBS2910 Matrix ARM mini PC
      ARM: dts: imx6q-tbs2910: Enable snvs-poweroff

Sonny Rao (1):
      ARM: dts: rk3288: add arm,cpu-registers-not-fw-configured

Stefan Agner (7):
      ARM: dts: vf610: Add ARM Global Timer
      ARM: dts: vf610: assign oscillator to clock module
      ARM: dts: vf610: create generic base device trees
      ARM: dts: vf500-colibri: add Colibri VF50 support
      ARM: dts: vf610: use new GPIO support
      ARM: dts: vf610: enable USB misc/phy nodes where necessary
      ARM: dts: vf-colibri: add USB regulators

Sylwester Nawrocki (2):
      ARM: dts: Specify default clocks for Exynos4 camera devices
      ARM: dts: Specify audio clock parents and rates for exynos4412-odroid-common

Tao Huang (1):
      ARM: dts: prima2: add resets property for GPS nodes

Thomas Petazzoni (2):
      ARM: mvebu: remove conflicting muxing on Armada 370 DB
      ARM: mvebu: use simple-card DT binding for audio on Armada 370 DB

Thor Thayer (1):
      arm: dts: socfpga: Add SPI nodes to SOCFPGA DT.

Tomasz Figa (4):
      ARM: dts: Enable PWM node by default for s3c64xx
      ARM: dts: Keep eMMC regulators soft-disabled for exynos4412-trats2
      ARM: dts: Add utility macro to define pin sleep states for exynos4x12-pinctrl
      ARM: dts: Add sleep mode pin configuration for exynos4412-trats2

Ulrich Hecht (1):
      ARM: shmobile: r8a73a4: fix scifb* naming

Uwe Kleine-König (1):
      ARM: mvebu: fix ordering in Armada 370 .dtsi

Vignesh R (1):
      ARM: dts: AM43xx: add tscadc DT entries for am437x-evm and am43x-epos-evm

Vladimir Zapolskiy (1):
      ARM: dts: imx6dl: add alias for I2C4 bus

Wolfram Sang (3):
      ARM: shmobile: r8a7790: switch from scif to scifa
      ARM: shmobile: r8a7790: add DMA nodes for IIC
      ARM: shmobile: r8a7791: add DMA nodes for IIC

Ye He (1):
      ARM: dts: prima2: add node for Performance Monitor Unit

Yoshifumi Hosoya (3):
      ARM: shmobile: r8a7790: Add MMP clock to device tree
      ARM: shmobile: r8a7791: Add MMP clock to device tree
      ARM: shmobile: r8a7794: Add MMP and VSP1 clocks to device tree

Yoshihiro Shimoda (10):
      ARM: shmobile: r8a7790: add USB3.0 device node
      ARM: shmobile: lager: enable USB3.0
      ARM: shmobile: r8a7791: add USB3.0 device node
      ARM: shmobile: r8a7790: add HS-USB device node
      ARM: shmobile: lager: enable HS-USB
      ARM: shmobile: r8a7791: add HS-USB device node
      ARM: shmobile: koelsch: enable HS-USB
      ARM: shmobile: henninger: enable HS-USB
      ARM: shmobile: r8a7790: add USBDMAC{0,1} clocks to device tree
      ARM: shmobile: r8a7791: add USBDMAC{0,1} clocks to device tree

Youngjun Cho (1):
      ARM: dts: add board dts file for Exynos3250-based Monk board

Zhangfei Gao (9):
      ARM: dts: hix5hd2: add gmac node
      ARM: dts: hix5hd2: add mmc node
      ARM: dts: hix5hd2: add usb node
      ARM: dts: hix5hd2: add sata node
      ARM: dts: hix5hd2: add gpio node
      ARM: dts: hix5hd2: add wdg node
      ARM: dts: hix5hd2: add ir node
      ARM: dts: hix5hd2: add i2c node
      ARM: dts: hix5hd2: add reboot node

 Documentation/devicetree/bindings/arm/arm-boards   |  65 ++
 .../devicetree/bindings/arm/bcm/cygnus.txt         |  31 +
 Documentation/devicetree/bindings/arm/fsl.txt      |  38 +
 Documentation/devicetree/bindings/arm/gic.txt      |   1 +
 .../devicetree/bindings/arm/marvell,berlin.txt     |  10 +
 Documentation/devicetree/bindings/arm/mediatek.txt |  19 +-
 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 Documentation/devicetree/bindings/arm/rockchip.txt |   4 +
 .../devicetree/bindings/arm/samsung-boards.txt     |  19 +-
 .../devicetree/bindings/arm/ste-nomadik.txt        |   6 +
 .../devicetree/bindings/clock/bcm-cygnus-clock.txt |  34 +
 .../devicetree/bindings/clock/vf610-clock.txt      |  15 +
 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   2 +-
 .../devicetree/bindings/i2c/i2c-s3c2410.txt        |   1 +
 .../devicetree/bindings/i2c/trivial-devices.txt    |   2 +
 .../devicetree/bindings/timer/renesas,mtu2.txt     |   2 +-
 .../devicetree/bindings/timer/renesas,tmu.txt      |   4 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   3 +
 arch/arm/boot/dts/Makefile                         |  50 +-
 arch/arm/boot/dts/am335x-evm.dts                   |  13 +
 arch/arm/boot/dts/am335x-lxm.dts                   | 362 ++++++++
 arch/arm/boot/dts/am33xx.dtsi                      |  25 +-
 arch/arm/boot/dts/am4372.dtsi                      |  47 ++
 arch/arm/boot/dts/am437x-gp-evm.dts                |  34 +
 arch/arm/boot/dts/am43x-epos-evm.dts               |   8 +
 arch/arm/boot/dts/arm-realview-pb1176.dts          | 412 ++++++++++
 arch/arm/boot/dts/armada-370-db.dts                | 106 ++-
 arch/arm/boot/dts/armada-370-mirabox.dts           |  25 +-
 arch/arm/boot/dts/armada-370-netgear-rn102.dts     | 101 +--
 arch/arm/boot/dts/armada-370-netgear-rn104.dts     |  64 +-
 arch/arm/boot/dts/armada-370-rd.dts                |  73 +-
 arch/arm/boot/dts/armada-370-synology-ds213j.dts   | 316 +++++++
 arch/arm/boot/dts/armada-370-xp.dtsi               |  11 +-
 arch/arm/boot/dts/armada-370.dtsi                  | 190 +++--
 arch/arm/boot/dts/armada-375.dtsi                  |  12 +-
 arch/arm/boot/dts/armada-385-db.dts                |   2 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |   6 +-
 arch/arm/boot/dts/armada-xp-axpwifiap.dts          |  57 +-
 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts    |  75 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |  15 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  15 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |  15 +-
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts     | 166 ++--
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |  14 +-
 arch/arm/boot/dts/armada-xp-synology-ds414.dts     | 330 ++++++++
 arch/arm/boot/dts/armada-xp.dtsi                   |  66 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  19 +
 arch/arm/boot/dts/at91sam9x25.dtsi                 |   1 +
 arch/arm/boot/dts/at91sam9x35.dtsi                 |   1 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  12 +
 arch/arm/boot/dts/at91sam9x5_can.dtsi              |  50 +-
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi           |   3 +
 arch/arm/boot/dts/atlas6.dtsi                      |  15 +
 arch/arm/boot/dts/bcm-cygnus-clock.dtsi            |  91 +++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  | 140 ++++
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts           |  30 +
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  46 +-
 arch/arm/boot/dts/bcm2835-rpi.dtsi                 |  51 ++
 arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts  |  64 ++
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |  59 ++
 arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts     |  84 ++
 arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts        |  78 ++
 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts |  57 ++
 arch/arm/boot/dts/bcm47081.dtsi                    |  26 +
 arch/arm/boot/dts/bcm5301x.dtsi                    |  51 ++
 arch/arm/boot/dts/bcm911360_entphn.dts             |  53 ++
 arch/arm/boot/dts/bcm911360k.dts                   |  53 ++
 arch/arm/boot/dts/bcm958300k.dts                   |  53 ++
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |  16 +
 arch/arm/boot/dts/berlin2.dtsi                     | 110 +++
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |  30 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |  82 ++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  61 ++
 arch/arm/boot/dts/berlin2q.dtsi                    |  96 ++-
 arch/arm/boot/dts/dra7-evm.dts                     |  22 +
 arch/arm/boot/dts/dra7.dtsi                        |  35 +
 arch/arm/boot/dts/dra72-evm.dts                    |  23 +
 arch/arm/boot/dts/exynos3250-monk.dts              | 579 +++++++++++++
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi          |  16 +
 arch/arm/boot/dts/exynos3250-rinato.dts            | 682 ++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  |  10 +
 arch/arm/boot/dts/exynos4.dtsi                     |   4 +-
 arch/arm/boot/dts/exynos4210-trats.dts             |  16 +
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |  16 +
 arch/arm/boot/dts/exynos4210.dtsi                  |  17 +
 arch/arm/boot/dts/exynos4212.dtsi                  |  17 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |  26 +
 arch/arm/boot/dts/exynos4412-trats2.dts            | 412 +++++++++-
 arch/arm/boot/dts/exynos4412.dtsi                  |  29 +
 arch/arm/boot/dts/exynos4415-pinctrl.dtsi          | 573 +++++++++++++
 arch/arm/boot/dts/exynos4415.dtsi                  | 604 ++++++++++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |  16 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |  10 +
 arch/arm/boot/dts/exynos5250-arndale.dts           | 907 ++++++++++-----------
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 618 +++++++-------
 arch/arm/boot/dts/exynos5250-snow.dts              | 266 +++---
 arch/arm/boot/dts/exynos5250-spring.dts            | 566 +++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |  20 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   7 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |   4 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   7 +-
 arch/arm/boot/dts/hisi-x5hd2-dkb.dts               |  33 +
 arch/arm/boot/dts/hisi-x5hd2.dtsi                  | 390 ++++++++-
 arch/arm/boot/dts/imx51.dtsi                       |  12 +-
 arch/arm/boot/dts/imx53.dtsi                       |  25 +-
 arch/arm/boot/dts/imx6dl.dtsi                      |   8 +
 arch/arm/boot/dts/imx6q-tbs2910.dts                | 432 ++++++++++
 arch/arm/boot/dts/imx6q.dtsi                       |   4 +
 arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi       | 131 ++-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  97 ++-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   4 +
 arch/arm/boot/dts/imx6qdl.dtsi                     |  14 +
 arch/arm/boot/dts/imx6sl-evk.dts                   |   4 +
 arch/arm/boot/dts/imx6sl.dtsi                      |   6 +
 arch/arm/boot/dts/imx6sx-sdb.dts                   |  66 ++
 arch/arm/boot/dts/imx6sx.dtsi                      |   8 +-
 arch/arm/boot/dts/k2e-evm.dts                      |  12 +
 arch/arm/boot/dts/k2e.dtsi                         |  45 +
 arch/arm/boot/dts/k2l-evm.dts                      |  12 +
 arch/arm/boot/dts/keystone.dtsi                    |  45 +
 arch/arm/boot/dts/kirkwood-dir665.dts              | 278 +++++++
 arch/arm/boot/dts/kirkwood-synology.dtsi           |   2 +-
 arch/arm/boot/dts/ls1021a-qds.dts                  | 240 ++++++
 arch/arm/boot/dts/ls1021a-twr.dts                  | 127 +++
 arch/arm/boot/dts/ls1021a.dtsi                     | 408 +++++++++
 arch/arm/boot/dts/meson.dtsi                       |  37 +
 arch/arm/boot/dts/meson6-atv1200.dts               |   2 +-
 arch/arm/boot/dts/meson6.dtsi                      |   2 +
 arch/arm/boot/dts/meson8.dtsi                      |  92 +++
 arch/arm/boot/dts/mt6592-evb.dts                   |  26 +
 arch/arm/boot/dts/mt6592.dtsi                      |  98 +++
 arch/arm/boot/dts/mt8127-moose.dts                 |  25 +
 arch/arm/boot/dts/mt8127.dtsi                      |  94 +++
 arch/arm/boot/dts/mt8135-evbp1.dts                 |  25 +
 arch/arm/boot/dts/mt8135.dtsi                      | 116 +++
 arch/arm/boot/dts/omap3-cm-t3x.dtsi                | 124 ++-
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              |  18 +
 arch/arm/boot/dts/omap3-n900.dts                   |  16 +
 arch/arm/boot/dts/omap3-sb-t35.dtsi                |  36 +
 arch/arm/boot/dts/omap3-sbc-t3517.dts              |   1 +
 arch/arm/boot/dts/omap3-sbc-t3530.dts              |   1 +
 arch/arm/boot/dts/omap3-sbc-t3730.dts              |   1 +
 arch/arm/boot/dts/omap4-duovero-parlor.dts         |   1 +
 arch/arm/boot/dts/prima2.dtsi                      |  33 +
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts    |   4 +
 arch/arm/boot/dts/r8a73a4.dtsi                     |  37 +-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts      |   6 +-
 arch/arm/boot/dts/r8a7740.dtsi                     |  44 +-
 arch/arm/boot/dts/r8a7778-bockw-reference.dts      |   4 +
 arch/arm/boot/dts/r8a7778.dtsi                     |  42 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |  10 +-
 arch/arm/boot/dts/r8a7790-lager.dts                | 131 ++-
 arch/arm/boot/dts/r8a7790.dtsi                     | 189 ++++-
 arch/arm/boot/dts/r8a7791-henninger.dts            |  11 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |  99 ++-
 arch/arm/boot/dts/r8a7791.dtsi                     | 186 ++++-
 arch/arm/boot/dts/r8a7794-alt.dts                  |   2 +-
 arch/arm/boot/dts/r8a7794.dtsi                     |  29 +-
 arch/arm/boot/dts/rk3066a-bqcurie2.dts             |   4 +
 arch/arm/boot/dts/rk3066a-marsboard.dts            | 206 +++++
 arch/arm/boot/dts/rk3066a.dtsi                     | 115 ++-
 arch/arm/boot/dts/rk3188-radxarock.dts             |  23 +-
 arch/arm/boot/dts/rk3188.dtsi                      |  45 +-
 arch/arm/boot/dts/rk3288-evb-rk808.dts             |   6 +-
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   6 +
 arch/arm/boot/dts/rk3288-thermal.dtsi              |  74 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  99 ++-
 arch/arm/boot/dts/rk3xxx.dtsi                      |  17 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |   4 -
 arch/arm/boot/dts/s3c64xx.dtsi                     |   1 -
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |   8 +-
 arch/arm/boot/dts/sh73a0.dtsi                      |  10 +-
 arch/arm/boot/dts/socfpga.dtsi                     |  27 +
 arch/arm/boot/dts/socfpga_arria10.dtsi             | 374 +++++++++
 arch/arm/boot/dts/socfpga_arria10_socdk.dts        |  48 ++
 arch/arm/boot/dts/socfpga_cyclone5.dtsi            |   4 +
 arch/arm/boot/dts/ste-nomadik-nhk15.dts            | 151 ++++
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |  56 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |  45 +-
 arch/arm/boot/dts/stih407-b2120.dts                |  55 +-
 arch/arm/boot/dts/stih407-clock.dtsi               | 293 ++++++-
 .../boot/dts/{stih407.dtsi => stih407-family.dtsi} |  35 +-
 arch/arm/boot/dts/stih410-b2120.dts                |  29 +
 arch/arm/boot/dts/stih410-clock.dtsi               | 338 ++++++++
 arch/arm/boot/dts/stih410-pinctrl.dtsi             |  34 +
 arch/arm/boot/dts/stih410.dtsi                     |  14 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             | 361 ++++----
 arch/arm/boot/dts/stih415.dtsi                     |  12 +
 arch/arm/boot/dts/stih416-b2020.dts                |  22 +
 arch/arm/boot/dts/stih416-b2020e.dts               |  26 +-
 arch/arm/boot/dts/stih416-pinctrl.dtsi             | 415 ++++++----
 arch/arm/boot/dts/stih416.dtsi                     | 209 +++++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |   6 +-
 arch/arm/boot/dts/stih41x-b2020.dtsi               |  10 +-
 arch/arm/boot/dts/stih41x-b2020x.dtsi              |   4 +
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |  59 ++
 arch/arm/boot/dts/sun4i-a10-a1000.dts              |  46 +-
 arch/arm/boot/dts/sun4i-a10-ba10-tvbox.dts         |  46 +-
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts         |  46 +-
 arch/arm/boot/dts/sun4i-a10-hackberry.dts          |  46 +-
 arch/arm/boot/dts/sun4i-a10-inet97fv2.dts          |  46 +-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts         |  46 +-
 arch/arm/boot/dts/sun4i-a10-olinuxino-lime.dts     |  46 +-
 arch/arm/boot/dts/sun4i-a10-pcduino.dts            |  46 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  14 +
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts   |  46 +-
 arch/arm/boot/dts/sun5i-a10s-r7-tv-dongle.dts      |  46 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |  14 +
 arch/arm/boot/dts/sun5i-a13-hsg-h702.dts           |   6 +-
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts    |  48 +-
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts          |  46 +-
 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts          |  46 +-
 arch/arm/boot/dts/sun6i-a31-colombus.dts           |  46 +-
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts        |  46 +-
 arch/arm/boot/dts/sun6i-a31-m9.dts                 | 103 ++-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  46 +-
 arch/arm/boot/dts/sun7i-a20-bananapi.dts           | 214 +++++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |  14 +
 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts          |  46 +-
 arch/arm/boot/dts/sun7i-a20-m3.dts                 | 168 ++++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts     |  46 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    | 228 ++++++
 arch/arm/boot/dts/sun7i-a20-pcduino3.dts           |  46 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  45 +-
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts        |  46 +-
 arch/arm/boot/dts/sun8i-a23.dtsi                   |   6 +-
 arch/arm/boot/dts/sun9i-a80-optimus.dts            | 119 +++
 arch/arm/boot/dts/sun9i-a80.dtsi                   | 514 ++++++++++++
 arch/arm/boot/dts/sunxi-common-regulators.dtsi     |  66 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   2 +-
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi          |  96 +++
 arch/arm/boot/dts/vf-colibri.dtsi                  | 186 +++++
 arch/arm/boot/dts/vf500-colibri-eval-v3.dts        |  17 +
 arch/arm/boot/dts/vf500-colibri.dtsi               |  20 +
 arch/arm/boot/dts/vf500.dtsi                       | 171 ++++
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts        |  33 +-
 arch/arm/boot/dts/vf610-colibri.dtsi               | 100 +--
 arch/arm/boot/dts/vf610-cosmic.dts                 |  14 +-
 arch/arm/boot/dts/vf610-twr.dts                    |  46 +-
 arch/arm/boot/dts/vf610.dtsi                       | 486 +----------
 arch/arm/boot/dts/vfxxx.dtsi                       | 437 ++++++++++
 arch/arm/boot/dts/zynq-7000.dtsi                   |   1 -
 arch/arm/boot/dts/zynq-parallella.dts              |   1 +
 arch/arm/boot/dts/zynq-zc702.dts                   |   4 +
 arch/arm/boot/dts/zynq-zc706.dts                   |   4 +
 arch/arm/boot/dts/zynq-zed.dts                     |   4 +
 arch/arm/boot/dts/zynq-zybo.dts                    |  52 ++
 arch/arm/configs/nhk8815_defconfig                 |  11 +-
 arch/arm/mach-mediatek/mediatek.c                  |   3 +
 arch/arm/mach-nomadik/cpu-8815.c                   |   1 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   3 -
 arch/arm/mach-realview/Kconfig                     |  13 +
 arch/arm/mach-realview/Makefile                    |   1 +
 arch/arm/mach-realview/realview-dt.c               |  32 +
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |   1 -
 arch/arm/mach-shmobile/r8a73a4.h                   |   1 -
 arch/arm/mach-shmobile/setup-r8a73a4.c             |   9 +-
 arch/arm/mach-shmobile/setup-r8a7778.c             |   3 +-
 arch/arm/mach-sti/Kconfig                          |  10 +
 drivers/irqchip/irq-gic.c                          |   2 +
 drivers/staging/iio/light/isl29028.c               |   3 +-
 include/dt-bindings/clock/r8a7740-clock.h          |   1 +
 include/dt-bindings/clock/r8a7790-clock.h          |  14 +-
 include/dt-bindings/clock/r8a7791-clock.h          |  11 +-
 include/dt-bindings/clock/r8a7794-clock.h          |   9 +
 include/dt-bindings/clock/stih407-clks.h           |  86 ++
 include/dt-bindings/clock/stih410-clks.h           |  25 +
 267 files changed, 18516 insertions(+), 2823 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/bcm-cygnus-clock.txt
 create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/meson6-wdt.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 Documentation/mailbox.txt
 create mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 arch/arm/boot/dts/am335x-lxm.dts
 create mode 100644 arch/arm/boot/dts/am57xx-beagle-x15.dts
 create mode 100644 arch/arm/boot/dts/arm-realview-pb1176.dts
 create mode 100644 arch/arm/boot/dts/armada-370-synology-ds213j.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-synology-ds414.dts
 create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
 create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi
 create mode 100644 arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts
 create mode 100644 arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts
 create mode 100644 arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts
 create mode 100644 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
 create mode 100644 arch/arm/boot/dts/bcm47081.dtsi
 create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
 create mode 100644 arch/arm/boot/dts/bcm911360k.dts
 create mode 100644 arch/arm/boot/dts/bcm958300k.dts
 create mode 100644 arch/arm/boot/dts/exynos3250-monk.dts
 create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5250-spring.dts
 create mode 100644 arch/arm/boot/dts/imx6q-tbs2910.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-dir665.dts
 create mode 100644 arch/arm/boot/dts/ls1021a-qds.dts
 create mode 100644 arch/arm/boot/dts/ls1021a-twr.dts
 create mode 100644 arch/arm/boot/dts/ls1021a.dtsi
 create mode 100644 arch/arm/boot/dts/meson8.dtsi
 create mode 100644 arch/arm/boot/dts/mt6592-evb.dts
 create mode 100644 arch/arm/boot/dts/mt6592.dtsi
 create mode 100644 arch/arm/boot/dts/mt8127-moose.dts
 create mode 100644 arch/arm/boot/dts/mt8127.dtsi
 create mode 100644 arch/arm/boot/dts/mt8135-evbp1.dts
 create mode 100644 arch/arm/boot/dts/mt8135.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-igep0020-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-igep0020-rev-f.dts
 create mode 100644 arch/arm/boot/dts/omap3-igep0030-common.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-igep0030-rev-g.dts
 create mode 100644 arch/arm/boot/dts/r8a77xx-aa104xd12-panel.dtsi
 create mode 100644 arch/arm/boot/dts/rk3066a-marsboard.dts
 create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/socfpga_arria10.dtsi
 create mode 100755 arch/arm/boot/dts/socfpga_arria10_socdk.dts
 create mode 100644 arch/arm/boot/dts/ste-nomadik-nhk15.dts
 rename arch/arm/boot/dts/{stih407.dtsi => stih407-family.dtsi} (87%)
 create mode 100644 arch/arm/boot/dts/stih410-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih410-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih410-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih410.dtsi
 create mode 100644 arch/arm/boot/dts/stihxxx-b2120.dtsi
 create mode 100644 arch/arm/boot/dts/sun7i-a20-bananapi.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20-m3.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
 create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
 create mode 100644 arch/arm/boot/dts/sun9i-a80.dtsi
 create mode 100644 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
 create mode 100644 arch/arm/boot/dts/vf-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf500-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/vf500-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf500.dtsi
 create mode 100644 arch/arm/boot/dts/vfxxx.dtsi
 create mode 100644 arch/arm/boot/dts/zynq-zybo.dts
 create mode 100644 include/dt-bindings/clock/stih407-clks.h
 create mode 100644 include/dt-bindings/clock/stih410-clks.h
 create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h

