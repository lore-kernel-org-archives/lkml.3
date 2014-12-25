Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaLYR5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:57:02 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36417 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaLYR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:56:59 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 00/25] Generic BMIPS kernel
Date: Thu, 25 Dec 2014 09:48:55 -0800
Message-Id: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V5->V6: Incorporate several fixes/enhancements from Jaedon Shin:

 - Fix register read/modify/write in RAC flush code.

 - Fix use of "SYS_HAS_CPU_BMIPS32_3300" Kconfig symbol.

 - Add base platform support for 7358 and 7362.

The DTS files follow Andrew Bresticker's new per-vendor directory layout.

This series applies on top of Linus' current head of tree.

Patch 01 (Fix outdated use of mips_cpu_intc_init()) is REQUIRED for 3.19
to fix a build failure seen in 3.19-rc.  The other patches can
be queued for 3.20 or later.


Andrew Bresticker (2):
  MIPS: Move device-trees into vendor sub-directories
  MIPS: Add dtbs_install target

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
 arch/mips/Makefile                                 |   7 +-
 arch/mips/bcm3384/Platform                         |   7 -
 arch/mips/bcm3384/dma.c                            |  81 -----
 arch/mips/bcm3384/irq.c                            | 193 ------------
 arch/mips/bcm3384/setup.c                          |  97 ------
 arch/mips/bmips/Kconfig                            |  58 ++++
 arch/mips/{bcm3384 => bmips}/Makefile              |   0
 arch/mips/bmips/Platform                           |   7 +
 arch/mips/bmips/dma.c                              | 117 +++++++
 arch/mips/bmips/irq.c                              |  38 +++
 arch/mips/bmips/setup.c                            | 194 ++++++++++++
 arch/mips/boot/dts/Makefile                        |  33 +-
 arch/mips/boot/dts/bcm3384.dtsi                    | 109 -------
 arch/mips/boot/dts/brcm/Makefile                   |  19 ++
 arch/mips/boot/dts/brcm/bcm3384_viper.dtsi         | 108 +++++++
 arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi        | 126 ++++++++
 arch/mips/boot/dts/brcm/bcm6328.dtsi               |  86 ++++++
 arch/mips/boot/dts/brcm/bcm6368.dtsi               |  93 ++++++
 arch/mips/boot/dts/brcm/bcm7125.dtsi               | 139 +++++++++
 arch/mips/boot/dts/brcm/bcm7346.dtsi               | 224 ++++++++++++++
 arch/mips/boot/dts/brcm/bcm7358.dtsi               | 161 ++++++++++
 arch/mips/boot/dts/brcm/bcm7360.dtsi               | 161 ++++++++++
 arch/mips/boot/dts/brcm/bcm7362.dtsi               | 167 ++++++++++
 arch/mips/boot/dts/brcm/bcm7420.dtsi               | 184 +++++++++++
 arch/mips/boot/dts/brcm/bcm7425.dtsi               | 225 ++++++++++++++
 arch/mips/boot/dts/{ => brcm}/bcm93384wvg.dts      |   9 +-
 arch/mips/boot/dts/brcm/bcm93384wvg_viper.dts      |  25 ++
 arch/mips/boot/dts/brcm/bcm96368mvwg.dts           |  31 ++
 arch/mips/boot/dts/brcm/bcm97125cbmb.dts           |  31 ++
 arch/mips/boot/dts/brcm/bcm97346dbsmb.dts          |  58 ++++
 arch/mips/boot/dts/brcm/bcm97358svmb.dts           |  34 +++
 arch/mips/boot/dts/brcm/bcm97360svmb.dts           |  34 +++
 arch/mips/boot/dts/brcm/bcm97362svmb.dts           |  34 +++
 arch/mips/boot/dts/brcm/bcm97420c.dts              |  45 +++
 arch/mips/boot/dts/brcm/bcm97425svmb.dts           |  60 ++++
 arch/mips/boot/dts/brcm/bcm9ejtagprb.dts           |  22 ++
 arch/mips/boot/dts/cavium-octeon/Makefile          |   9 +
 .../boot/dts/{ => cavium-octeon}/octeon_3xxx.dts   |   0
 .../boot/dts/{ => cavium-octeon}/octeon_68xx.dts   |   0
 arch/mips/boot/dts/lantiq/Makefile                 |   9 +
 arch/mips/boot/dts/{ => lantiq}/danube.dtsi        |   0
 arch/mips/boot/dts/{ => lantiq}/easy50712.dts      |   0
 arch/mips/boot/dts/mti/Makefile                    |   9 +
 arch/mips/boot/dts/{ => mti}/sead3.dts             |   0
 arch/mips/boot/dts/netlogic/Makefile               |  12 +
 arch/mips/boot/dts/{ => netlogic}/xlp_evp.dts      |   0
 arch/mips/boot/dts/{ => netlogic}/xlp_fvp.dts      |   0
 arch/mips/boot/dts/{ => netlogic}/xlp_gvp.dts      |   0
 arch/mips/boot/dts/{ => netlogic}/xlp_svp.dts      |   0
 arch/mips/boot/dts/ralink/Makefile                 |  12 +
 arch/mips/boot/dts/{ => ralink}/mt7620a.dtsi       |   0
 arch/mips/boot/dts/{ => ralink}/mt7620a_eval.dts   |   0
 arch/mips/boot/dts/{ => ralink}/rt2880.dtsi        |   0
 arch/mips/boot/dts/{ => ralink}/rt2880_eval.dts    |   0
 arch/mips/boot/dts/{ => ralink}/rt3050.dtsi        |   0
 arch/mips/boot/dts/{ => ralink}/rt3052_eval.dts    |   0
 arch/mips/boot/dts/{ => ralink}/rt3883.dtsi        |   0
 arch/mips/boot/dts/{ => ralink}/rt3883_eval.dts    |   0
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
 arch/mips/mm/dma-default.c                         |  15 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-bcm7038-l1.c                   | 335 +++++++++++++++++++++
 drivers/irqchip/irq-bcm7120-l2.c                   | 193 ++++++++----
 drivers/irqchip/irq-brcmstb-l2.c                   |   9 +-
 103 files changed, 3335 insertions(+), 1193 deletions(-)
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
 create mode 100644 arch/mips/boot/dts/brcm/Makefile
 create mode 100644 arch/mips/boot/dts/brcm/bcm3384_viper.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm6328.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm6368.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7125.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7346.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7358.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7360.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7362.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7420.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm7425.dtsi
 rename arch/mips/boot/dts/{ => brcm}/bcm93384wvg.dts (63%)
 create mode 100644 arch/mips/boot/dts/brcm/bcm93384wvg_viper.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm96368mvwg.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97125cbmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97346dbsmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97358svmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97360svmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97362svmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97420c.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm97425svmb.dts
 create mode 100644 arch/mips/boot/dts/brcm/bcm9ejtagprb.dts
 create mode 100644 arch/mips/boot/dts/cavium-octeon/Makefile
 rename arch/mips/boot/dts/{ => cavium-octeon}/octeon_3xxx.dts (100%)
 rename arch/mips/boot/dts/{ => cavium-octeon}/octeon_68xx.dts (100%)
 create mode 100644 arch/mips/boot/dts/lantiq/Makefile
 rename arch/mips/boot/dts/{ => lantiq}/danube.dtsi (100%)
 rename arch/mips/boot/dts/{ => lantiq}/easy50712.dts (100%)
 create mode 100644 arch/mips/boot/dts/mti/Makefile
 rename arch/mips/boot/dts/{ => mti}/sead3.dts (100%)
 create mode 100644 arch/mips/boot/dts/netlogic/Makefile
 rename arch/mips/boot/dts/{ => netlogic}/xlp_evp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_fvp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_gvp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_svp.dts (100%)
 create mode 100644 arch/mips/boot/dts/ralink/Makefile
 rename arch/mips/boot/dts/{ => ralink}/mt7620a.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/mt7620a_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt2880.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt2880_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3050.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3052_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3883.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3883_eval.dts (100%)
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

