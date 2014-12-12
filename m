Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaLLWIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:08:17 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65398 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaLLWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:08:13 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        jogo@openwrt.org, arnd@arndb.de, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 00/23] Generic BMIPS kernel
Date: Fri, 12 Dec 2014 14:06:51 -0800
Message-Id: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4->V5:

 - Rebase on top of Linus' head of tree, converting BCM3384 platform code
   to Generic BMIPS platform code.

 - Fix a couple of #include's

 - Remove a couple of bogus entries from bmips_be_defconfig

Compile-tested only.  Some BMIPS platforms may require acked-but-unmerged
changes in other subsystems (like the native-endian serial8250/DT patches).

For 3.19 you'll want the first patch at the minimum (because the build is
currently broken).


Brian Norris (1):
  irqchip: brcmstb-l2: don't clear wakeable interrupts at init time

Kevin Cernekee (22):
  MIPS: bcm3384: Fix outdated use of mips_cpu_intc_init()
  MIPS: Create a common <asm/mach-generic/war.h>
  MIPS: bcm3384: Rename "bcm3384" target to "bmips"
  irqchip: Update docs regarding irq_domain_add_tree()
  irqchip: bcm7120-l2: Refactor driver for arbitrary IRQEN/IRQSTAT
    offsets
  irqchip: bcm7120-l2: Split STB-specific logic into its own function
  irqchip: bcm7120-l2: Add support for BCM3380-style controllers
  irqchip: Add new driver for BCM7038-style level 1 interrupt
    controllers
  MIPS: Let __dt_register_buses accept a single bus type
  MIPS: Fall back to the generic restart notifier
  MIPS: Reorder MIPS_L1_CACHE_SHIFT priorities
  MIPS: BMIPS: Flush the readahead cache after DMA
  MIPS: BMIPS: Document the firmware->kernel DTB interface
  MIPS: BMIPS: Rewrite DMA code to use "dma-ranges" property
  MIPS: BMIPS: Remove bogus bus name
  MIPS: BMIPS: Add quirks for several Broadcom platforms
  MIPS: BMIPS: Delete the irqchip driver from irq.c
  MIPS: BMIPS: Use a non-default FIXADDR_TOP setting
  MIPS: BMIPS: Enable additional peripheral and CPU support in defconfig
  MIPS: BMIPS: Refresh BCM3384 DTS files
  MIPS: BMIPS: Update DT bindings to reflect new SoC support
  MIPS: BMIPS: Add DTS files for several platforms

 Documentation/IRQ-domain.txt                       |   3 +-
 .../interrupt-controller/brcm,bcm3380-l2-intc.txt  |  41 +++
 .../interrupt-controller/brcm,bcm7038-l1-intc.txt  |  52 ++++
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  12 +-
 .../devicetree/bindings/mips/brcm/bcm3384-intc.txt |  37 ---
 .../devicetree/bindings/mips/brcm/cm-dsl.txt       |  11 -
 .../devicetree/bindings/mips/brcm/soc.txt          |  12 +
 Documentation/devicetree/booting-without-of.txt    |  28 ++
 arch/mips/Kbuild.platforms                         |   2 +-
 arch/mips/Kconfig                                  |  37 ++-
 arch/mips/bcm3384/Platform                         |   7 -
 arch/mips/bcm3384/dma.c                            |  81 -----
 arch/mips/bcm3384/irq.c                            | 193 ------------
 arch/mips/bcm3384/setup.c                          |  97 ------
 arch/mips/bmips/Kconfig                            |  50 +++
 arch/mips/{bcm3384 => bmips}/Makefile              |   0
 arch/mips/bmips/Platform                           |   7 +
 arch/mips/bmips/dma.c                              | 117 +++++++
 arch/mips/bmips/irq.c                              |  38 +++
 arch/mips/bmips/setup.c                            | 194 ++++++++++++
 arch/mips/boot/dts/Makefile                        |  10 +-
 arch/mips/boot/dts/bcm3384.dtsi                    | 109 -------
 arch/mips/boot/dts/bcm3384_viper.dtsi              | 108 +++++++
 arch/mips/boot/dts/bcm3384_zephyr.dtsi             | 126 ++++++++
 arch/mips/boot/dts/bcm6328.dtsi                    |  86 ++++++
 arch/mips/boot/dts/bcm6368.dtsi                    |  93 ++++++
 arch/mips/boot/dts/bcm7125.dtsi                    | 139 +++++++++
 arch/mips/boot/dts/bcm7346.dtsi                    | 224 ++++++++++++++
 arch/mips/boot/dts/bcm7360.dtsi                    | 161 ++++++++++
 arch/mips/boot/dts/bcm7420.dtsi                    | 184 +++++++++++
 arch/mips/boot/dts/bcm7425.dtsi                    | 225 ++++++++++++++
 arch/mips/boot/dts/bcm93384wvg.dts                 |   9 +-
 arch/mips/boot/dts/bcm93384wvg_viper.dts           |  25 ++
 arch/mips/boot/dts/bcm96368mvwg.dts                |  31 ++
 arch/mips/boot/dts/bcm97125cbmb.dts                |  31 ++
 arch/mips/boot/dts/bcm97346dbsmb.dts               |  58 ++++
 arch/mips/boot/dts/bcm97360svmb.dts                |  34 +++
 arch/mips/boot/dts/bcm97420c.dts                   |  45 +++
 arch/mips/boot/dts/bcm97425svmb.dts                |  60 ++++
 arch/mips/boot/dts/bcm9ejtagprb.dts                |  22 ++
 .../{bcm3384_defconfig => bmips_be_defconfig}      |  11 +-
 arch/mips/configs/bmips_stb_defconfig              |  88 ++++++
 arch/mips/include/asm/mach-ar7/war.h               |  24 --
 arch/mips/include/asm/mach-ath25/war.h             |  25 --
 arch/mips/include/asm/mach-ath79/war.h             |  24 --
 arch/mips/include/asm/mach-au1x00/war.h            |  24 --
 arch/mips/include/asm/mach-bcm3384/war.h           |  24 --
 arch/mips/include/asm/mach-bcm47xx/war.h           |  24 --
 arch/mips/include/asm/mach-bcm63xx/war.h           |  24 --
 .../{mach-bcm3384 => mach-bmips}/dma-coherence.h   |   6 +-
 arch/mips/include/asm/mach-bmips/spaces.h          |  18 ++
 arch/mips/include/asm/mach-cavium-octeon/war.h     |  25 --
 arch/mips/include/asm/mach-cobalt/war.h            |  24 --
 arch/mips/include/asm/mach-dec/war.h               |  24 --
 arch/mips/include/asm/mach-emma2rh/war.h           |  24 --
 .../asm/{mach-ralink => mach-generic}/war.h        |   6 +-
 arch/mips/include/asm/mach-jazz/war.h              |  24 --
 arch/mips/include/asm/mach-jz4740/war.h            |  24 --
 arch/mips/include/asm/mach-lantiq/war.h            |  23 --
 arch/mips/include/asm/mach-lasat/war.h             |  24 --
 arch/mips/include/asm/mach-loongson/war.h          |  24 --
 arch/mips/include/asm/mach-loongson1/war.h         |  24 --
 arch/mips/include/asm/mach-netlogic/war.h          |  25 --
 arch/mips/include/asm/mach-paravirt/war.h          |  25 --
 arch/mips/include/asm/mach-pnx833x/war.h           |  24 --
 arch/mips/include/asm/mach-tx39xx/war.h            |  24 --
 arch/mips/include/asm/mach-vr41xx/war.h            |  24 --
 arch/mips/kernel/prom.c                            |   5 +-
 arch/mips/kernel/reset.c                           |   2 +
 arch/mips/mm/dma-default.c                         |  13 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-bcm7038-l1.c                   | 335 +++++++++++++++++++++
 drivers/irqchip/irq-bcm7120-l2.c                   | 193 ++++++++----
 drivers/irqchip/irq-brcmstb-l2.c                   |   9 +-
 75 files changed, 2850 insertions(+), 1172 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm3380-l2-intc.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7038-l1-intc.txt
 delete mode 100644 Documentation/devicetree/bindings/mips/brcm/bcm3384-intc.txt
 delete mode 100644 Documentation/devicetree/bindings/mips/brcm/cm-dsl.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/soc.txt
 delete mode 100644 arch/mips/bcm3384/Platform
 delete mode 100644 arch/mips/bcm3384/dma.c
 delete mode 100644 arch/mips/bcm3384/irq.c
 delete mode 100644 arch/mips/bcm3384/setup.c
 create mode 100644 arch/mips/bmips/Kconfig
 rename arch/mips/{bcm3384 => bmips}/Makefile (100%)
 create mode 100644 arch/mips/bmips/Platform
 create mode 100644 arch/mips/bmips/dma.c
 create mode 100644 arch/mips/bmips/irq.c
 create mode 100644 arch/mips/bmips/setup.c
 delete mode 100644 arch/mips/boot/dts/bcm3384.dtsi
 create mode 100644 arch/mips/boot/dts/bcm3384_viper.dtsi
 create mode 100644 arch/mips/boot/dts/bcm3384_zephyr.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6328.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6368.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7125.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7346.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7360.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7420.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7425.dtsi
 create mode 100644 arch/mips/boot/dts/bcm93384wvg_viper.dts
 create mode 100644 arch/mips/boot/dts/bcm96368mvwg.dts
 create mode 100644 arch/mips/boot/dts/bcm97125cbmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97346dbsmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97360svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97420c.dts
 create mode 100644 arch/mips/boot/dts/bcm97425svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm9ejtagprb.dts
 rename arch/mips/configs/{bcm3384_defconfig => bmips_be_defconfig} (89%)
 create mode 100644 arch/mips/configs/bmips_stb_defconfig
 delete mode 100644 arch/mips/include/asm/mach-ar7/war.h
 delete mode 100644 arch/mips/include/asm/mach-ath25/war.h
 delete mode 100644 arch/mips/include/asm/mach-ath79/war.h
 delete mode 100644 arch/mips/include/asm/mach-au1x00/war.h
 delete mode 100644 arch/mips/include/asm/mach-bcm3384/war.h
 delete mode 100644 arch/mips/include/asm/mach-bcm47xx/war.h
 delete mode 100644 arch/mips/include/asm/mach-bcm63xx/war.h
 rename arch/mips/include/asm/{mach-bcm3384 => mach-bmips}/dma-coherence.h (90%)
 create mode 100644 arch/mips/include/asm/mach-bmips/spaces.h
 delete mode 100644 arch/mips/include/asm/mach-cavium-octeon/war.h
 delete mode 100644 arch/mips/include/asm/mach-cobalt/war.h
 delete mode 100644 arch/mips/include/asm/mach-dec/war.h
 delete mode 100644 arch/mips/include/asm/mach-emma2rh/war.h
 rename arch/mips/include/asm/{mach-ralink => mach-generic}/war.h (86%)
 delete mode 100644 arch/mips/include/asm/mach-jazz/war.h
 delete mode 100644 arch/mips/include/asm/mach-jz4740/war.h
 delete mode 100644 arch/mips/include/asm/mach-lantiq/war.h
 delete mode 100644 arch/mips/include/asm/mach-lasat/war.h
 delete mode 100644 arch/mips/include/asm/mach-loongson/war.h
 delete mode 100644 arch/mips/include/asm/mach-loongson1/war.h
 delete mode 100644 arch/mips/include/asm/mach-netlogic/war.h
 delete mode 100644 arch/mips/include/asm/mach-paravirt/war.h
 delete mode 100644 arch/mips/include/asm/mach-pnx833x/war.h
 delete mode 100644 arch/mips/include/asm/mach-tx39xx/war.h
 delete mode 100644 arch/mips/include/asm/mach-vr41xx/war.h
 create mode 100644 drivers/irqchip/irq-bcm7038-l1.c

-- 
2.1.1

