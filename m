Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3KKPVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:21:16 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45993 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3KKPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:21:08 -0500
Message-ID: <5280F5E1.7050600@gmail.com>
Date: Mon, 11 Nov 2013 09:21:05 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [GIT PULL] DeviceTree for 3.13
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull. Details below. There are a few expected trivial merge
conflicts with the powerpc and crypto trees.

Rob

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/devicetree-for-3.13

for you to fetch changes up to c11eede69b6ad0ac44ebc1e021a8d2699c5f1f8f:

  powerpc: add missing explicit OF includes for ppc (2013-11-11 09:10:50
-0600)

----------------------------------------------------------------
DeviceTree updates for 3.13. This is a bit larger pull request than
usual for this cycle with lots of clean-up.

- Cross arch clean-up and consolidation of early DT scanning code.
- Clean-up and removal of arch prom.h headers. Makes arch specific
  prom.h optional on all but Sparc.
- Addition of interrupts-extended property for devices connected to
  multiple interrupt controllers.
- Refactoring of DT interrupt parsing code in preparation for deferred
  probe of interrupts.
- ARM cpu and cpu topology bindings documentation.
- Various DT vendor binding documentation updates.

----------------------------------------------------------------
David Miller (1):
      of: Make cpu node handling more portable.

Grant Likely (15):
      of: fix unnecessary warning on missing /cpus node
      of: Fix iteration bug over CPU reg properties
      of: Fix dereferencing node name in debug output to be safe
      of/irq: Rename of_irq_map_* functions to of_irq_parse_*
      of/irq: Replace of_irq with of_phandle_args
      of/irq: simplify args to irq_create_of_mapping
      of/irq: Refactor interrupt-map parsing
      of: Add helper for printing an of_phandle_args structure
      of: Add testcases for interrupt parsing
      of/irq: Create of_irq_parse_and_map_pci() to consolidate arch code.
      microblaze/pci: Drop PowerPC-ism from irq parsing
      of/irq: create interrupts-extended property
      arm/versatile: Fix versatile irq specifications.
      of/irq: Fix bug in interrupt parsing refactor.
      of/irq: Fix potential buffer overflow

Jayachandran C (1):
      MIPS: Netlogic: replace early_init_devtree() call

Lorenzo Pieralisi (2):
      Documentation: devicetree: arm: cpus/cpu nodes bindings updates
      Documentation: DT: arm: define CPU topology bindings

Matt Porter (1):
      of: add vendor prefix for PHYTEC Messtechnik GmbH

Rob Herring (55):
      c6x: use boot_command_line instead of private c6x_command_line
      openrisc: use boot_command_line instead of private cmd_line
      of: create unflatten_and_copy_device_tree
      arc: use unflatten_and_copy_device_tree
      openrisc: use unflatten_and_copy_device_tree
      x86: use unflatten_and_copy_device_tree
      xtensa: use unflatten_and_copy_device_tree
      metag: use unflatten_and_copy_device_tree
      of: Introduce common early_init_dt_scan
      arc: use early_init_dt_scan
      arm: use early_init_dt_scan
      arm64: use early_init_dt_scan
      c6x: use early_init_dt_scan
      metag: use early_init_dt_scan
      microblaze: use early_init_dt_scan
      mips: use early_init_dt_scan
      openrisc: use early_init_dt_scan
      xtensa: use early_init_dt_scan
      of: create default early_init_dt_add_memory_arch
      arm: set initrd_start/initrd_end for fdt scan
      arm64: set initrd_start/initrd_end for fdt scan
      of: remove early_init_dt_setup_initrd_arch
      openrisc: remove unnecessary prom.c includes
      of: introduce common FDT machine related functions
      arc: use common of_flat_dt_match_machine
      arm: use common of_flat_dt_match_machine
      arm64: use common of_flat_dt_get_machine_name
      metag: use common of_flat_dt_match_machine
      mips: use common of_flat_dt_get_machine_name
      drivers: remove unnecessary prom.h includes
      of: remove unnecessary prom.h includes
      ARM: keystone: remove unnecessary prom.h include
      arm64: remove unnecessary prom.h include
      arc: remove unnecessary prom.h includes
      hexagon: remove unnecessary prom.h includes
      metag: move setup_machine_fdt declaration from prom.h
      microblaze: clean-up prom.h implicit includes
      drivers: clean-up prom.h implicit includes
      mips: add explicit includes of prom.h
      x86: add necessary includes for prom.h
      of: implement pci_address_to_pio as weak function
      of: implement of_node_to_nid as a weak function
      of: remove HAVE_ARCH_DEVTREE_FIXUPS
      of: move of_address_to_resource and of_iomap declarations from sparc
      of: move of_translate_dma_address to of_address.h
      powerpc: clean-up include ordering in prom.h
      powerpc: add explicit OF includes
      of: only include prom.h on sparc
      of: remove empty arch prom.h headers
      of: set dma_mask to point to coherent_dma_mask
      Merge branch 'cpu-bindings' into for-next
      Merge remote-tracking branch 'grant/devicetree/next' into for-next
      dt: disable self-tests for !OF_IRQ
      dt/irq: add empty of_irq_count for !OF_IRQ
      powerpc: add missing explicit OF includes for ppc

Silvio F (1):
      DT: sort vendor-prefixes.txt

Soren Brinkmann (1):
      of: Add vendor prefix for Cadence

Sylwester Nawrocki (1):
      of: Add empty for_each_available_child_of_node() macro definition

Thierry Reding (5):
      of/irq: Rework of_irq_count()
      of/irq: Use irq_of_parse_and_map()
      of: Add AU Optronics Corporation vendor prefix
      of: Add Chunghwa Picture Tubes Ltd. vendor prefix
      of: Add Panasonic Corporation vendor prefix

Tomasz Figa (2):
      of/irq: Pass trigger type in IRQ resource flags
      of: irq: Fix interrupt-map entry matching

 Documentation/devicetree/bindings/arm/cpus.txt     | 401 +++++++++++++++--
 Documentation/devicetree/bindings/arm/topology.txt | 474
+++++++++++++++++++++
 .../bindings/interrupt-controller/interrupts.txt   |  29 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   9 +-
 arch/arc/include/asm/mach_desc.h                   |  17 +-
 arch/arc/include/asm/prom.h                        |  14 -
 arch/arc/kernel/devtree.c                          |  97 +----
 arch/arc/kernel/setup.c                            |   6 +-
 arch/arc/mm/init.c                                 |   7 -
 arch/arm/boot/dts/testcases/tests-interrupts.dtsi  |  58 +++
 arch/arm/boot/dts/testcases/tests.dtsi             |   1 +
 arch/arm/boot/dts/versatile-ab.dts                 |   2 +-
 arch/arm/boot/dts/versatile-pb.dts                 |   2 +-
 arch/arm/include/asm/prom.h                        |   2 -
 arch/arm/kernel/devtree.c                          |  57 +--
 arch/arm/mach-integrator/pci_v3.c                  |  18 +-
 arch/arm/mach-keystone/platsmp.c                   |   1 -
 arch/arm/mach-u300/timer.c                         |   9 +-
 arch/arm/mm/init.c                                 |  13 +-
 arch/arm64/include/asm/prom.h                      |   1 -
 arch/arm64/kernel/setup.c                          |  60 +--
 arch/arm64/mm/init.c                               |  25 +-
 arch/c6x/include/asm/prom.h                        |   1 -
 arch/c6x/include/asm/setup.h                       |   2 -
 arch/c6x/kernel/devicetree.c                       |  29 --
 arch/c6x/kernel/setup.c                            |  13 +-
 arch/c6x/kernel/vmlinux.lds.S                      |   6 -
 arch/hexagon/kernel/setup.c                        |   3 -
 arch/metag/include/asm/mach/arch.h                 |   2 +-
 arch/metag/include/asm/prom.h                      |  23 -
 arch/metag/include/asm/setup.h                     |   1 +
 arch/metag/kernel/devtree.c                        |  83 +---
 arch/metag/kernel/setup.c                          |   7 +-
 arch/metag/mm/init.c                               |   9 -
 arch/microblaze/include/asm/pci.h                  |   2 -
 arch/microblaze/include/asm/prom.h                 |  39 +-
 arch/microblaze/kernel/prom.c                      |  32 +-
 arch/microblaze/kernel/setup.c                     |   3 +-
 arch/microblaze/kernel/timer.c                     |   1 +
 arch/microblaze/pci/pci-common.c                   |  73 +---
 arch/mips/include/asm/netlogic/xlp-hal/xlp.h       |   1 +
 arch/mips/include/asm/prom.h                       |  14 -
 arch/mips/kernel/prom.c                            |  60 +--
 arch/mips/lantiq/prom.c                            |   1 +
 arch/mips/mti-sead3/sead3-setup.c                  |   2 +
 arch/mips/netlogic/xlp/dt.c                        |  18 +-
 arch/mips/netlogic/xlp/setup.c                     |   2 +-
 arch/mips/pci/fixup-lantiq.c                       |  13 +-
 arch/mips/pci/pci-rt3883.c                         |  24 +-
 arch/mips/ralink/of.c                              |   1 +
 arch/openrisc/include/asm/prom.h                   |  22 -
 arch/openrisc/kernel/prom.c                        |  70 +--
 arch/openrisc/kernel/setup.c                       |   6 +-
 arch/powerpc/include/asm/prom.h                    |  33 +-
 arch/powerpc/kernel/epapr_paravirt.c               |   1 +
 arch/powerpc/kernel/pci-common.c                   |  11 +-
 arch/powerpc/kernel/prom.c                         |   9 -
 arch/powerpc/platforms/512x/clock.c                |   1 +
 arch/powerpc/platforms/512x/pdm360ng.c             |   2 +
 arch/powerpc/platforms/82xx/mpc8272_ads.c          |   2 +
 arch/powerpc/platforms/82xx/pq2fads.c              |   2 +
 arch/powerpc/platforms/83xx/suspend.c              |   2 +
 arch/powerpc/platforms/85xx/c293pcie.c             |   1 +
 arch/powerpc/platforms/85xx/common.c               |   2 +
 arch/powerpc/platforms/85xx/ppa8548.c              |   1 +
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |   1 +
 arch/powerpc/platforms/85xx/smp.c                  |   1 +
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |   2 +
 arch/powerpc/platforms/86xx/pic.c                  |   1 +
 arch/powerpc/platforms/8xx/ep88xc.c                |   2 +
 arch/powerpc/platforms/8xx/mpc86xads_setup.c       |   2 +
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |   2 +
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |   1 +
 arch/powerpc/platforms/cell/celleb_scc_pciex.c     |   6 +-
 arch/powerpc/platforms/cell/celleb_scc_sio.c       |   7 +-
 arch/powerpc/platforms/cell/spider-pic.c           |   7 +-
 arch/powerpc/platforms/cell/spu_manage.c           |  13 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c   |   1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   2 +
 arch/powerpc/platforms/fsl_uli1575.c               |  12 +-
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |   1 +
 arch/powerpc/platforms/powermac/pfunc_base.c       |   1 +
 arch/powerpc/platforms/powermac/pic.c              |  10 +-
 arch/powerpc/platforms/powernv/opal-lpc.c          |   1 +
 arch/powerpc/platforms/powernv/opal.c              |   1 +
 arch/powerpc/platforms/powernv/setup.c             |   1 +
 arch/powerpc/platforms/pseries/event_sources.c     |   8 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +
 arch/powerpc/sysdev/cpm_common.c                   |   1 +
 arch/powerpc/sysdev/ehv_pic.c                      |   1 +
 arch/powerpc/sysdev/fsl_gtm.c                      |  11 +-
 arch/powerpc/sysdev/fsl_pmc.c                      |   1 +
 arch/powerpc/sysdev/fsl_rio.c                      |   2 +
 arch/powerpc/sysdev/fsl_rmu.c                      |   1 +
 arch/powerpc/sysdev/mpic.c                         |   8 +-
 arch/powerpc/sysdev/mpic_msgr.c                    |   6 +-
 arch/powerpc/sysdev/mpic_msi.c                     |   8 +-
 arch/powerpc/sysdev/mpic_timer.c                   |   2 +
 arch/powerpc/sysdev/of_rtc.c                       |   1 +
 arch/powerpc/sysdev/ppc4xx_ocm.c                   |   1 +
 arch/powerpc/sysdev/ppc4xx_soc.c                   |   1 +
 arch/powerpc/sysdev/xilinx_intc.c                  |   2 +
 arch/sparc/include/asm/prom.h                      |  12 -
 arch/sparc/kernel/prom_64.c                        |  53 +++
 arch/x86/include/asm/prom.h                        |   5 -
 arch/x86/kernel/devicetree.c                       |  51 +--
 arch/xtensa/include/asm/prom.h                     |   6 -
 arch/xtensa/kernel/setup.c                         |  55 +--
 drivers/ata/sata_dwc_460ex.c                       |   2 +
 drivers/ata/sata_fsl.c                             |   2 +
 drivers/char/bsr.c                                 |   1 +
 drivers/char/hw_random/pasemi-rng.c                |   1 +
 drivers/char/hw_random/ppc4xx-rng.c                |   1 +
 drivers/clk/clk-ppc-corenet.c                      |   1 +
 drivers/cpufreq/pasemi-cpufreq.c                   |   1 +
 drivers/crypto/amcc/crypto4xx_core.c               |   3 +
 drivers/crypto/caam/ctrl.c                         |   5 +-
 drivers/crypto/caam/jr.c                           |   4 +-
 drivers/crypto/omap-sham.c                         |   2 +-
 drivers/crypto/talitos.c                           |   2 +
 drivers/dma/bestcomm/sram.c                        |   1 +
 drivers/dma/fsldma.c                               |   2 +
 drivers/dma/mpc512x_dma.c                          |   2 +
 drivers/dma/ppc4xx/adma.c                          |   2 +
 drivers/edac/cell_edac.c                           |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/i2c/busses/i2c-cpm.c                       |   2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |   2 +
 drivers/i2c/busses/i2c-mpc.c                       |   2 +
 drivers/i2c/busses/i2c-powermac.c                  |   1 +
 drivers/input/serio/xilinx_ps2.c                   |   8 +-
 drivers/macintosh/macio_asic.c                     |   2 +
 drivers/macintosh/rack-meter.c                     |   2 +
 drivers/macintosh/smu.c                            |   1 +
 drivers/macintosh/via-pmu.c                        |   2 +
 drivers/media/platform/fsl-viu.c                   |   2 +
 drivers/misc/carma/carma-fpga-program.c            |   2 +
 drivers/misc/carma/carma-fpga.c                    |   2 +
 drivers/mtd/nand/fsl_elbc_nand.c                   |   1 +
 drivers/mtd/nand/fsl_ifc_nand.c                    |   1 +
 drivers/mtd/nand/fsl_upm.c                         |   1 +
 drivers/mtd/nand/mpc5121_nfc.c                     |   2 +
 drivers/mtd/nand/ndfc.c                            |   1 +
 drivers/mtd/nand/pasemi_nand.c                     |   2 +
 drivers/mtd/nand/socrates_nand.c                   |   1 +
 drivers/net/can/grcan.c                            |   3 -
 drivers/net/can/sja1000/sja1000_of_platform.c      |   1 -
 drivers/net/ethernet/arc/emac_main.c               |  10 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c   |   4 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |   4 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c   |   4 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   1 +
 drivers/net/ethernet/freescale/gianfar.c           |   2 +
 drivers/net/ethernet/freescale/ucc_geth.c          |   2 +
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   1 +
 drivers/net/ethernet/ibm/emac/core.c               |   2 +
 drivers/net/ethernet/ibm/emac/mal.c                |   1 +
 drivers/net/ethernet/ibm/emac/rgmii.c              |   1 +
 drivers/net/ethernet/ibm/emac/tah.c                |   1 +
 drivers/net/ethernet/ibm/emac/zmii.c               |   1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   1 +
 drivers/of/Kconfig                                 |   1 +
 drivers/of/address.c                               |  18 +-
 drivers/of/base.c                                  |  67 ++-
 drivers/of/fdt.c                                   | 138 +++++-
 drivers/of/irq.c                                   | 164 +++----
 drivers/of/of_pci.c                                |   1 -
 drivers/of/of_pci_irq.c                            |  41 +-
 drivers/of/pdt.c                                   |   1 -
 drivers/of/platform.c                              |   2 +
 drivers/of/selftest.c                              | 161 ++++++-
 drivers/pci/host/pci-mvebu.c                       |  15 +-
 drivers/pcmcia/electra_cf.c                        |   2 +
 drivers/pcmcia/m8xx_pcmcia.c                       |   2 +
 drivers/rtc/rtc-mpc5121.c                          |   2 +
 drivers/spi/spi-fsl-cpm.c                          |   1 +
 drivers/spi/spi-fsl-espi.c                         |   8 +-
 drivers/spi/spi-mpc512x-psc.c                      |   1 +
 drivers/spi/spi-ppc4xx.c                           |   2 +
 drivers/tty/ehv_bytechan.c                         |   1 +
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   4 +-
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c        |   1 +
 drivers/tty/serial/pmac_zilog.c                    |   2 +
 drivers/tty/serial/ucc_uart.c                      |   2 +
 drivers/usb/gadget/fsl_qe_udc.c                    |   1 +
 drivers/usb/host/ehci-ppc-of.c                     |   2 +
 drivers/usb/host/fhci-hcd.c                        |   2 +
 drivers/usb/host/ohci-ppc-of.c                     |   2 +
 drivers/video/fsl-diu-fb.c                         |   2 +
 drivers/virt/fsl_hypervisor.c                      |   1 +
 drivers/watchdog/gef_wdt.c                         |   1 +
 drivers/watchdog/mpc8xxx_wdt.c                     |   1 +
 drivers/watchdog/pika_wdt.c                        |   1 +
 fs/proc/proc_devtree.c                             |   3 -
 include/linux/cpu.h                                |   3 +
 include/linux/of.h                                 |  17 +-
 include/linux/of_address.h                         |  39 +-
 include/linux/of_fdt.h                             |  19 +-
 include/linux/of_irq.h                             |  47 +-
 include/linux/of_pci.h                             |   5 +-
 kernel/irq/irqdomain.c                             |  13 +-
 sound/aoa/core/gpio-feature.c                      |   3 +-
 sound/aoa/soundbus/i2sbus/core.c                   |   2 +
 sound/ppc/pmac.c                                   |   2 +
 sound/ppc/tumbler.c                                |   1 +
 sound/soc/fsl/fsl_dma.c                            |   2 +
 sound/soc/fsl/mpc5200_dma.c                        |   2 +
 sound/soc/fsl/mpc5200_psc_ac97.c                   |   2 +-
 sound/soc/fsl/mpc8610_hpcd.c                       |   1 +
 sound/soc/fsl/p1022_ds.c                           |   1 +
 sound/soc/fsl/p1022_rdk.c                          |   1 +
 212 files changed, 1919 insertions(+), 1251 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/topology.txt
 delete mode 100644 arch/arc/include/asm/prom.h
 create mode 100644 arch/arm/boot/dts/testcases/tests-interrupts.dtsi
 delete mode 100644 arch/arm64/include/asm/prom.h
 delete mode 100644 arch/c6x/include/asm/prom.h
 delete mode 100644 arch/metag/include/asm/prom.h
 delete mode 100644 arch/openrisc/include/asm/prom.h
 delete mode 100644 arch/xtensa/include/asm/prom.h

