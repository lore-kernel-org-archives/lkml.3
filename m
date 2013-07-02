Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3GBTTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:19:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3GBTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:19:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 2/7] ARM SoC cleanups
Date: Tue, 2 Jul 2013 21:01:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307022101.44753.arnd@arndb.de>
X-Provags-ID: V02:K0:4A/FTIbTBL+dFlkb8EEOWLWiqKNKlG/mAgHMzi0kjVn
 I2/EWIxcQ5LDhyljofqCp4i/AlByxs+ocQhlAcIDMaa7FgU8jt
 9YW2kKd/y1WzwERg3fqT32dG6C+67MEtC0Sur+RUodxPitwx+m
 erjz08GYrbX61ohgssdoA3BJYrnfdD338/2giC1pmHCcYX+Xtq
 YLCjghEGnQvm8B49gTDn8YH+5TLfhI1vgD2oXRXgkcs+3y/TOG
 Ot8gvKaUH4OlY5LDzx03mlHw0YWj+L9a2xKc/aldGpLK9Mio2O
 fpP8ait36RfgmENsvzEXZd1vI0yYZ7HcoazzVEXWmegXtJvs/a
 9J9JP1E8Q0IRrz3M9NZ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to 0ee8090c1d059eca4d60e8e473bee91fb5d1996b:

  Merge branch 'armsoc/for-3.11/cleanups' of git://github.com/broadcom/bcm11351 into next/cleanup (2013-06-21 15:39:24 +0200)

----------------------------------------------------------------

ARM SoC cleanups

This contains cleanups as preparation for other branches adding new
features, we pulled 16 branches for 9 platforms into this one.

Most notable here is the removal of support for ATAGS based OMAP4
systems. Since all OMAP4 machines are fully functional with DT based
booting in 3.10, we can remove a lot of code here.

Also noteworthy is Maxime Ripard's cleanup of the machine descriptors,
which means we need no machine descriptors in a lot more cases and
can boot additional machines by just having the respective device
drivers enabled.

----------------------------------------------------------------

Andrew Lunn (1):
      ARM: Orion: Remove redundant init_dma_coherent_pool_size()

Andrew Murray (1):
      of/pci: Provide support for parsing PCI DT ranges property

Arnd Bergmann (11):
      Merge tag 'zynq-cleanup-for-3.11' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'picoxcell-next' of git://github.com/jamieiles/linux-2.6-ji into next/cleanup
      Merge tag 'omap-for-v3.11/pm-serial-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.11/pm-voltdomain-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.11/dma-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'samsung-cleanup-1' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      ARM: s5p64x0: avoid build warning for uncompress.h
      ARM: picoxcell: remove .nr_irqs reference
      Merge branch 'armsoc/for-3.11/cleanups' of git://github.com/broadcom/bcm11351 into next/cleanup
      Merge tag 'cleanup-for-linus' into for-linus

David Brown (1):
      ARM: dts: msm: Fix merge resolution

Ezequiel Garcia (1):
      bus: mvebu-mbus: Use pr_fmt

Jamie Iles (1):
      picoxcell: remove redundant common.h

Jarkko Nikula (8):
      ARM: OMAP2+: Remove AES crypto device DMA channel definitions
      ARM: OMAP2+: Remove duplicated DMA channel definitions
      ARM: OMAP2+: hwmod: Remove remaining DMA channel definitions
      ARM: OMAP2+: Remove dma.h
      ARM: OMAP1: Remove McBSP DMA channel definitions
      ARM: OMAP1: Remove duplicated DMA channel definitions
      ARM: OMAP1: Remove legacy irda.h and irda setup from board files
      ARM: OMAP1: Remove dma.h

Jean-Christophe PLAGNIOL-VILLARD (7):
      ARM: at91: dt: use #include for all device trees
      ARM: at91: dt: switch to standard GPIO flag defines.
      ARM: at91: dt: add pinctrl pre-processor define
      ARM: at91: dt: switch to pinctrl to pre-processor
      ARM: at91: dt: switch to standard IRQ flag defines
      ARM: at91: udpate defconfigs
      ARM: at91: drop rm9200dk board support

Maxime Ripard (18):
      ARM: picoxcell: Remove init_irq declaration in machine description
      ARM: bcm281xx: Remove init_irq declaration in machine description
      ARM: sunxi: Remove init_irq declaration in machine description
      ARM: msm: Remove init_irq declaration in machine description
      ARM: mvebu: Remove init_irq declaration in machine description
      ARM: zynq: Remove init_irq declaration in machine description
      ARM: nomadik: Remove init_irq declaration in machine description
      ARM: spear: Remove init_irq declaration in machine description
      ARM: sirf: Remove init_irq declaration in machine description
      ARM: vexpress: Remove init_irq declaration in machine description
      ARM: virt: Remove init_irq declaration in machine description
      ARM: vt8500: Remove init_irq declaration in machine description
      ARM: mmu: Call debug_ll_io_init if no map_io function is specified
      ARM: highbank: remove the .map_io declaration
      ARM: mxs: remove the .map_io declaration
      ARM: sunxi: Remove the .map_io function declaration
      ARM: sunxi: Update datasheet documentation
      ARM: sunxi: irqchip: Update the documentation

Michal Simek (1):
      ARM: zynq: Not to rewrite jump code when starting address is 0x0

Olof Johansson (10):
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'arm-soc-cleanups-for-3.11' of git://github.com/mripard/linux into next/cleanup
      Merge tag 'cleanup-3.11-3' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'of_pci-3.11' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'omap-for-v3.10/fixes-v3.10-rc4' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-for-v3.11/cleanup-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'cleanup-3.11-4' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'msm-fix-for-3.11' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge tag 'msm-cleanup-for-3.11' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge tag 'sunxi-core-for-3.11' of git://github.com/mripard/linux into next/cleanup

R Sricharan (2):
      ARM: OMAP: dma: Remove the wrong dev_id check
      ARM: OMAP: dma: Fix the dma_chan_link_map init order

Rajendra Nayak (3):
      ARM: OMAP2+: Powerdomain: Remove the need to always have a voltdm associated to a pwrdm
      ARM: AM33xx: Remove the unused voltagedomain data
      ARM: OMAP: dma: Remove the erroneous freeing of platform data

Rohit Vaswani (4):
      msm: Remove unused file core.h
      msm: iomap: Remove unused bases and mappings
      ARM: msm: Remove gpiomux-v2 and re-organize MSM_GPIOMUX configs
      gpio: msm: Add device tree and irqdomain support for gpio-msm-v2

Sourav Poddar (3):
      arm: omap2+: serial: remove no_console_suspend support
      arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
      arm: omap2+: omap_device: remove no_idle_on_suspend

Sricharan R (2):
      ARM: OMAP4: hwmod data: Clean up the data file
      ARM: OMAP4: hwmod data: Remove irq entries from mcspi, mmc hwmods

Stephen Boyd (1):
      mfd: ssbi: Use devm_* and simplify code

Thierry Reding (2):
      of/pci: Add of_pci_get_devfn() function
      of/pci: Add of_pci_parse_bus_range() function

Thomas Petazzoni (1):
      arm: mvebu: mark functions of armada-370-xp.c as static

Tomasz Figa (7):
      ARM: S5P64X0: Use common uncompress.h part for plat-samsung
      watchdog: s3c2410_wdt: Use local register definitions
      ARM: SAMSUNG: Use local definitions of watchdog registers
      ARM: SAMSUNG: Add watchdog reset driver
      ARM: SAMSUNG: Let platforms use the new watchdog reset driver
      ARM: SAMSUNG: Remove legacy watchdog reset code
      ARM: SAMSUNG: Remove unused plat/regs-watchdog.h header

Tomi Valkeinen (1):
      ARM: OMAP4: hwmod data: add DSS data back

Tony Lindgren (10):
      ARM: OMAP2+: Legacy support for wl12xx when booted with devicetree
      ARM: OMAP2+: Remove board-4430sdp.c
      ARM: OMAP2+: Remove board-omap4panda.c
      ARM: OMAP2+: Remove legacy mux data for omap4
      ARM: OMAP2+: Remove omap4 pdata from hsmmc.c
      ARM: OMAP2+: Remove omap4 pdata for USB
      ARM: OMAP2+: Remove omap4 ocp2scp pdata
      Merge branch 'am33xx' into omap-for-v3.11/cleanup
      Merge tag 'omap-pm-v3.11/cleanup/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.11/pm-serial
      Merge tag 'omap-pm-v3.11/voltdm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.11/pm-voltdomain

Tushar Behera (1):
      ARM: SAMSUNG: Consolidate uncompress subroutine

Vaibhav Hiremath (1):
      ARM: AM33XX: hwmod data: irq, dma and addr info clean up

 Documentation/arm/sunxi/README                     |   21 +-
 .../devicetree/bindings/gpio/gpio-msm.txt          |   26 +
 .../interrupt-controller/allwinner,sun4i-ic.txt    |   87 +-
 .../interrupt-controller/sunxi/sun4i-a10.txt       |   89 ++
 .../interrupt-controller/sunxi/sun5i-a13.txt       |   55 +
 arch/arm/Kconfig                                   |    3 +
 arch/arm/boot/dts/aks-cdu.dts                      |   12 +-
 arch/arm/boot/dts/am33xx.dtsi                      |    1 -
 arch/arm/boot/dts/animeo_ip.dts                    |   18 +-
 arch/arm/boot/dts/at91-ariag25.dts                 |    6 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |  207 +--
 arch/arm/boot/dts/at91rm9200ek.dts                 |   10 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |  215 +--
 arch/arm/boot/dts/at91sam9263.dtsi                 |  203 +--
 arch/arm/boot/dts/at91sam9263ek.dts                |   24 +-
 arch/arm/boot/dts/at91sam9g15.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9g15ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9g20.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9g20ek.dts                |    6 +-
 arch/arm/boot/dts/at91sam9g20ek_2mmc.dts           |   10 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   28 +-
 arch/arm/boot/dts/at91sam9g25.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9g35.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9g35ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  213 +--
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   38 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  141 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   14 +-
 arch/arm/boot/dts/at91sam9x25.dtsi                 |   22 +-
 arch/arm/boot/dts/at91sam9x25ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9x35.dtsi                 |    2 +-
 arch/arm/boot/dts/at91sam9x35ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  279 ++--
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |    8 +-
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   14 +-
 arch/arm/boot/dts/ethernut5.dts                    |    6 +-
 arch/arm/boot/dts/evk-pro3.dts                     |    6 +-
 arch/arm/boot/dts/ge863-pro3.dtsi                  |    2 +-
 arch/arm/boot/dts/kizbox.dts                       |   16 +-
 arch/arm/boot/dts/mpa1600.dts                      |    4 +-
 arch/arm/boot/dts/msm8660-surf.dts                 |   11 +
 arch/arm/boot/dts/msm8960-cdp.dts                  |   11 +
 arch/arm/boot/dts/pm9g45.dts                       |   22 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |  520 +++----
 arch/arm/boot/dts/sama5d31ek.dts                   |    6 +-
 arch/arm/boot/dts/sama5d33ek.dts                   |    4 +-
 arch/arm/boot/dts/sama5d34ek.dts                   |    6 +-
 arch/arm/boot/dts/sama5d35ek.dts                   |    4 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |    4 +-
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |    2 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |   26 +-
 arch/arm/boot/dts/tny_a9260.dts                    |    4 +-
 arch/arm/boot/dts/tny_a9263.dts                    |    4 +-
 arch/arm/boot/dts/tny_a9g20.dts                    |    4 +-
 arch/arm/boot/dts/usb_a9260.dts                    |    4 +-
 arch/arm/boot/dts/usb_a9260_common.dtsi            |    6 +-
 arch/arm/boot/dts/usb_a9263.dts                    |    8 +-
 arch/arm/boot/dts/usb_a9g20-dab-mmx.dtsi           |   22 +-
 arch/arm/boot/dts/usb_a9g20.dts                    |    4 +-
 arch/arm/configs/at91_dt_defconfig                 |   55 +-
 arch/arm/configs/at91rm9200_defconfig              |  219 +--
 ...am9g20_defconfig => at91sam9260_9g20_defconfig} |   67 +-
 arch/arm/configs/at91sam9260_defconfig             |   91 --
 ...am9261_defconfig => at91sam9261_9g10_defconfig} |   19 +-
 arch/arm/configs/at91sam9263_defconfig             |   39 +-
 arch/arm/configs/at91sam9g45_defconfig             |   94 +-
 arch/arm/configs/sama5_defconfig                   |   35 +-
 arch/arm/mach-at91/Kconfig.non_dt                  |  166 +--
 arch/arm/mach-at91/Makefile                        |    3 -
 arch/arm/mach-at91/board-rm9200dk.c                |  228 ---
 arch/arm/mach-at91/board-sam9261ek.c               |   28 +-
 arch/arm/mach-bcm/board_bcm.c                      |    2 -
 arch/arm/mach-exynos/include/mach/uncompress.h     |    3 -
 arch/arm/mach-highbank/highbank.c                  |    1 -
 arch/arm/mach-msm/Kconfig                          |   13 +-
 arch/arm/mach-msm/Makefile                         |    6 +-
 arch/arm/mach-msm/board-dt-8660.c                  |    2 -
 arch/arm/mach-msm/board-dt-8960.c                  |    2 -
 arch/arm/mach-msm/core.h                           |    2 -
 arch/arm/mach-msm/gpiomux-8x60.c                   |   19 -
 arch/arm/mach-msm/gpiomux-v2.c                     |   25 -
 arch/arm/mach-msm/gpiomux-v2.h                     |   61 -
 arch/arm/mach-msm/gpiomux.c                        |   15 +
 arch/arm/mach-msm/gpiomux.h                        |    5 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |    7 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |    6 -
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 -
 arch/arm/mach-msm/io.c                             |    4 -
 arch/arm/mach-mvebu/armada-370-xp.c                |    8 +-
 arch/arm/mach-mxs/mach-mxs.c                       |    1 -
 arch/arm/mach-nomadik/cpu-8815.c                   |    2 -
 arch/arm/mach-omap1/board-h2.c                     |   36 -
 arch/arm/mach-omap1/board-palmte.c                 |   31 -
 arch/arm/mach-omap1/board-palmtt.c                 |   30 -
 arch/arm/mach-omap1/board-palmz71.c                |   31 -
 arch/arm/mach-omap1/board-sx1.c                    |   36 -
 arch/arm/mach-omap1/devices.c                      |    9 +-
 arch/arm/mach-omap1/dma.c                          |    2 -
 arch/arm/mach-omap1/dma.h                          |   42 -
 arch/arm/mach-omap1/include/mach/irda.h            |   33 -
 arch/arm/mach-omap1/lcd_dma.c                      |    2 -
 arch/arm/mach-omap1/mcbsp.c                        |   33 +-
 arch/arm/mach-omap2/Kconfig                        |   22 -
 arch/arm/mach-omap2/Makefile                       |    4 -
 arch/arm/mach-omap2/board-4430sdp.c                |  765 ----------
 arch/arm/mach-omap2/board-omap4panda.c             |  455 ------
 arch/arm/mach-omap2/devices.c                      |  133 +-
 arch/arm/mach-omap2/dma.h                          |   61 -
 arch/arm/mach-omap2/hsmmc.c                        |  103 +-
 arch/arm/mach-omap2/io.c                           |    1 -
 arch/arm/mach-omap2/mux.h                          |    3 -
 arch/arm/mach-omap2/mux44xx.c                      | 1356 -----------------
 arch/arm/mach-omap2/mux44xx.h                      |  298 ----
 arch/arm/mach-omap2/omap_device.c                  |    9 +-
 arch/arm/mach-omap2/omap_device.h                  |   10 -
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   21 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 1074 --------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   19 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 1544 +-------------------
 arch/arm/mach-omap2/powerdomain.c                  |    5 +
 arch/arm/mach-omap2/powerdomain.h                  |    2 +
 arch/arm/mach-omap2/prm33xx.c                      |    7 +
 arch/arm/mach-omap2/serial.c                       |    7 -
 arch/arm/mach-omap2/usb-host.c                     |  194 ---
 arch/arm/mach-omap2/usb-musb.c                     |    3 -
 arch/arm/mach-omap2/voltage.h                      |    1 -
 arch/arm/mach-omap2/voltagedomains33xx_data.c      |   43 -
 arch/arm/mach-picoxcell/common.c                   |    8 -
 arch/arm/mach-picoxcell/common.h                   |   17 -
 arch/arm/mach-prima2/common.c                      |    4 -
 arch/arm/mach-s3c24xx/Kconfig                      |    2 +
 arch/arm/mach-s3c24xx/include/mach/uncompress.h    |    3 +
 arch/arm/mach-s3c24xx/s3c2410.c                    |    3 +-
 arch/arm/mach-s3c24xx/s3c244x.c                    |    3 +-
 arch/arm/mach-s3c64xx/common.c                     |    8 +-
 arch/arm/mach-s3c64xx/include/mach/uncompress.h    |    3 +
 arch/arm/mach-s5p64x0/common.c                     |    4 +-
 arch/arm/mach-s5p64x0/include/mach/uncompress.h    |  162 +-
 arch/arm/mach-s5pc100/common.c                     |    3 +-
 arch/arm/mach-s5pc100/include/mach/uncompress.h    |    2 +
 arch/arm/mach-s5pv210/include/mach/uncompress.h    |    2 +
 arch/arm/mach-spear/spear1310.c                    |    2 -
 arch/arm/mach-spear/spear1340.c                    |    2 -
 arch/arm/mach-spear/spear300.c                     |    2 -
 arch/arm/mach-spear/spear310.c                     |    2 -
 arch/arm/mach-spear/spear320.c                     |    2 -
 arch/arm/mach-spear/spear6xx.c                     |    2 -
 arch/arm/mach-sunxi/sunxi.c                        |   19 -
 arch/arm/mach-sunxi/sunxi.h                        |   20 -
 arch/arm/mach-vexpress/v2m.c                       |    2 -
 arch/arm/mach-virt/virt.c                          |    2 -
 arch/arm/mach-vt8500/vt8500.c                      |    2 -
 arch/arm/mach-zynq/common.c                        |    2 -
 arch/arm/mach-zynq/platsmp.c                       |   52 +-
 arch/arm/mm/mmu.c                                  |    2 +
 arch/arm/plat-omap/dma.c                           |   11 +-
 arch/arm/plat-samsung/Kconfig                      |    6 +
 arch/arm/plat-samsung/Makefile                     |    1 +
 arch/arm/plat-samsung/include/plat/regs-watchdog.h |   41 -
 arch/arm/plat-samsung/include/plat/uncompress.h    |   21 +-
 .../arm/plat-samsung/include/plat/watchdog-reset.h |   38 +-
 arch/arm/plat-samsung/watchdog-reset.c             |   97 ++
 drivers/bus/mvebu-mbus.c                           |    8 +-
 drivers/bus/omap-ocp2scp.c                         |   60 -
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpio/gpio-msm-v2.c                         |  195 ++-
 drivers/of/address.c                               |   67 +
 drivers/of/of_pci.c                                |   59 +-
 drivers/ssbi/ssbi.c                                |   69 +-
 drivers/watchdog/s3c2410_wdt.c                     |   17 +-
 include/dt-bindings/pinctrl/at91.h                 |   35 +
 include/linux/of_address.h                         |   48 +
 include/linux/of_pci.h                             |    2 +
 include/linux/platform_data/omap_ocp2scp.h         |   31 -
 175 files changed, 2257 insertions(+), 9029 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-msm.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun4i-a10.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun5i-a13.txt
 rename arch/arm/configs/{at91sam9g20_defconfig => at91sam9260_9g20_defconfig} (67%)
 delete mode 100644 arch/arm/configs/at91sam9260_defconfig
 rename arch/arm/configs/{at91sam9261_defconfig => at91sam9261_9g10_defconfig} (91%)
 delete mode 100644 arch/arm/mach-at91/board-rm9200dk.c
 delete mode 100644 arch/arm/mach-msm/core.h
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h
 delete mode 100644 arch/arm/mach-omap1/dma.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/irda.h
 delete mode 100644 arch/arm/mach-omap2/board-4430sdp.c
 delete mode 100644 arch/arm/mach-omap2/board-omap4panda.c
 delete mode 100644 arch/arm/mach-omap2/dma.h
 delete mode 100644 arch/arm/mach-omap2/mux44xx.c
 delete mode 100644 arch/arm/mach-omap2/mux44xx.h
 delete mode 100644 arch/arm/mach-omap2/voltagedomains33xx_data.c
 delete mode 100644 arch/arm/mach-picoxcell/common.h
 delete mode 100644 arch/arm/mach-sunxi/sunxi.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-watchdog.h
 create mode 100644 arch/arm/plat-samsung/watchdog-reset.c
 create mode 100644 include/dt-bindings/pinctrl/at91.h
 delete mode 100644 include/linux/platform_data/omap_ocp2scp.h
