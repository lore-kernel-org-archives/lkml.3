Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3GBTSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:18:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3GBTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:18:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 6/7] ARM SoC driver specific changes
Date: Tue, 2 Jul 2013 21:12:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307022112.13518.arnd@arndb.de>
X-Provags-ID: V02:K0:ubfRFlnkq1ObC0I1SviptUXa2a7UIeCtvTfIsv2QEoJ
 OHdOEmcmPrYZyoIN5arBcEVEjHytIo9V5w/6bwc+NjTHJDwxos
 qBbduhGLwC3TPGhTW0U5vQ0xg4IE4WsR4t4xJeEIDffcm16ZqW
 6PiwAsyMAVrYHf6LNzaK627kfRLz+4mOv0+wXIKUn4v7gyPBVC
 vLJEF5rIKbmgOvn/EjVXB6BLAW5eG7u2WJ97LfZ2FLkQQC5Eg/
 u9bUWLPoKbSSH6SYPZ88BXXgk4zmsNZ1J7Q94AGF17Vg7nh1/c
 uDuwubVKR92LxtWmecmn6yEXfQX0aTUEtCn1oFsAfSfWMpvP3Z
 W/QnHB6unLPlwR3eR63c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to 5c913a9a9772f4b434aaea7328836419287b5d1c:

  Merge tag 'ux500-dma40-for-arm-soc-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson into next/drivers (2013-06-25 11:20:15 -0700)

----------------------------------------------------------------

ARM SoC driver specific changes

These changes are all driver specific and cross over between arm-soc
contents and some other subsystem, in these cases cpufreq, crypto,
dma, pinctrl, mailbox and usb, and the subsystem owners agreed to
have these changes merged through arm-soc. As we proceed to untangle
the dependencies between platform code and driver code, the amount of
changes in this category is fortunately shrinking, for 3.11 we have
16 branches here and 101 non-merge changesets, the majority of which
are for the stedma40 dma engine driver used in the ux500 platform.
Cleaning up that code touches multiple subsystems, but gets rid
of the dependency in the end.

The mailbox code moved out from mach-omap2 to drivers/mailbox
is an intermediate step and is still omap specific at the moment.
Patches exist to generalize the subsystem and add other drivers
with the same API, but those did not make it for 3.11.

Conflicts:
* In cpu-db8500.c results from the removal of the u8500_of_init_devices
  function in combination with the split of u8500_auxdata_lookup.

* In arch/arm/mach-omap2/devices.c, the includes got reshuffled.
  we need to keep linux/wl12xx.h and linux/platform_data/mailbox-omap.h.


----------------------------------------------------------------

Arnd Bergmann (10):
      gpio: rcar: fix gpio_rcar_of_table
      Merge tag 'omap-for-v3.11/gpmc-part2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'omap-for-v3.11/mailbox-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branches 'samsung/exynos-dt2' and 'samsung/s3c24xx-dt2' into next/drivers
      Merge tag 'common-clk-audio' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 's3c24xx-pinctrl-2' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'ux500/cleanup' into next/drivers
      Merge tag 'renesas-pinmux2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-gpio-rcar2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'drivers-for-linus' into for-linus

Christoph Fritz (1):
      ARM: OMAP2+: nand: reorganize gpmc timing values

Fabio Baltieri (8):
      clocksource: dbx500-prcmu: comment cleanup
      dmaengine: ste_dma40: Declare memcpy config as static
      crypto: ux500/hash: use readl on iomem addresses
      crypto: ux500/hash: add missing static qualifiers
      crypto: ux500/crypt: add missing __iomem qualifiers
      crypto: ux500: use dmaengine_device_control API
      crypto: ux500: use dmaengine_prep_slave_sg API
      crypto: ux500: use dmaengine_submit API

Guennadi Liakhovetski (2):
      pinctrl: r8a73a4: add pinmux data for MMCIF and SDHI interfaces
      pinctrl: r8a7790: fix two pin numbers

Gupta Pekon (1):
      ARM: OMAP2+: gpmc: get number of useable GPMC chip-selects via DT

Heiko Stuebner (2):
      pinctrl: Add pinctrl-s3c24xx driver
      pinctrl: s3c24xx: use correct header for chained_irq functions

Jean-Christophe PLAGNIOL-VILLARD (3):
      USB: gadget: atmel_usba: move global struct usba_ep usba_ep to struct usba_udc
      USB: gadget: atmel_usba: allow multi instance
      USB: gadget: atmel_usba: add DT support

Jon Hunter (1):
      ARM: dts: OMAP2+: Simplify NAND support

Kukjin Kim (4):
      Merge branch 'v3.11-next/driver-gpio' into v3.11-next/s3c24xx-driver
      Merge branch 'v3.11-next/driver-pinctrl' into v3.11-next/s3c24xx-driver
      Merge branch 'v3.11-next/driver-cpufreq' into v3.11-next/s3c24xx-driver
      Merge branch 'v3.11-next/s3c24xx-dt-2' into v3.11-next/dt-n-clk-audio

Kuninori Morimoto (1):
      sh-pfc: r8a7778: tidyup MMC_D1 pin

Laurent Pinchart (3):
      gpio-rcar: Add DT support
      gpio-rcar: Reference core gpio documentation in the DT bindings
      gpio-rcar: Remove #ifdef CONFIG_OF around OF-specific sections

Lee Jones (57):
      dmaengine: ste_dma40: Assign memcpy channels in the driver
      dmaengine: ste_dma40: Move default memcpy configs into the driver
      dmaengine: ste_dma40: Rectify incorrect configuration validation checking
      dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers
      ARM: ux500: Strip out duplicate USB DMA configuration
      dmaengine: ste_dma40: Remove home-brew MAX() macro
      ARM: ux500: Remove unused 'data_width' attributes from SDI DMA configs
      ARM: ux500: Remove unused 'data_width' attributes from SSP DMA configs
      ARM: ux500: Remove unused 'data_width' attributes from UART DMA configs
      ARM: ux500: Remove superfluous 'psize' attribute from Audio platform data
      dmaengine: ste_dma40: Calculate number of logical channels from physical ones
      dmaengine: ste_dma40: Remove 'always true' checking
      dmaengine: ste_dma40: Move rev error-check up to revision acquisition
      dmaengine: ste_dma40: Also report the number of logical channels
      dmaengine: ste_dma40: Allocate plat_data on declaration
      dmaengine: ste_dma40: Allow driver to be probe()able when DT is enabled
      dmaengine: ste_dma40: Supply full Device Tree parsing support
      ARM: ux500: Pass remnant platform data though to DMA40 driver
      dmaengine: ste_dma40: Separate Logical Global Interrupt Mask (GIM) unmasking
      dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
      dmaengine: ste_dma40: Don't configure runtime configurable setup during allocate
      ARM: ux500: Stop passing UART's platform data for Device Tree boots
      dmaengine: ste_dma40: Only use addresses passed as configuration information
      dmaengine: ste_dma40: Remove redundant address fetching function
      ARM: ux500: Remove DMA address look-up table
      dmaengine: ste_dma40: Correct copy/paste error
      ARM: ux500: Remove unnecessary attributes from DMA channel request pdata
      crypto: ux500/hash - Prepare clock before enabling it
      crypto: ux500/hash - Set DMA configuration though dma_slave_config()
      ARM: ux500: Stop passing Hash DMA channel config information though pdata
      crypto: ux500/cryp - Prepare clock before enabling it
      crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
      ARM: ux500: Stop passing Cryp DMA channel config information though pdata
      crypto: ux500/[cryp|hash] - Show successful start-up in the bootlog
      ARM: ux500: Register Cryp and Hash platform drivers on Snowball
      usb: musb: ux500: move channel number knowledge into the driver
      usb: musb: ux500: move the MUSB HDRC configuration into the driver
      usb: musb: ux500: take the dma_mask from coherent_dma_mask
      usb: musb: ux500: harden checks for platform data
      usb: musb: ux500: attempt to find channels by name before using pdata
      usb: musb: ux500: add device tree probing support
      ARM: ux500: Remove ux500-musb platform registation when booting with DT
      ARM: ux500: Remove empty function u8500_of_init_devices()
      dmaengine: ste_dma40: Use the BIT macro to replace ugly '(1 << x)'s
      ARM: ux500: Replace ST-E's home-brew DMA direction definition with the generic one
      dmaengine: ste_dma40: Replace ST-E's home-brew DMA direction defs with generic ones
      ARM: ux500: Remove recently unused stedma40_xfer_dir enums
      dmaengine: ste_dma40_ll: Use the BIT macro to replace ugly '(1 << x)'s
      dmaengine: ste_dma40: Convert data_width from register bit format to value
      dmaengine: ste_dma40_ll: Replace meaningless register set with comment
      dmaengine: ste_dma40: Allow memcpy channels to be configured from DT
      ARM: ux500: Stop passing DMA platform data though AUXDATA
      dmaengine: ste_dma40: Fetch the number of physical channels from DT
      dmaengine: ste_dma40: Fetch disabled channels from DT
      ARM: ux500: Provide a AB8500 GPIO Device Tree node
      ARM: ux500: Correct the EN_3v3 regulator's on/off GPIO
      ARM: ux500: Remove mop500_snowball_ethernet_clock_enable()

Linus Walleij (1):
      dmaengine: ste_dma40: Fix up static memcpy event lines

Mark Jackson (1):
      ARM: OMAP2+: Allow NAND transfer mode to be specified in DT

Olof Johansson (9):
      Merge tag 'ux500-dma40-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'dw_apb_timer_of' of git://github.com/mmind/linux-rockchip into next/drivers
      Merge tag 's3c24xx-driver-1' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'omap-for-v3.11/gpmc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'ux500-clksrc-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'ux500-dma40-for-arm-soc-2' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'renesas-gpio-rcar-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'at91-drivers' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge tag 'ux500-dma40-for-arm-soc-3' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers

Padmavathi Venna (6):
      ARM: dts: use #include for all device trees for Samsung
      clk: samsung: register audio subsystem clocks using common clock framework
      ARM: dts: add Exynos audio subsystem clock controller node
      ARM: dts: add clock provider information for i2s controllers in Exynos5250
      ARM: dts: Update Samsung I2S documentation
      clk: exynos5250: Add enum entries for divider clock of i2s1 and i2s2

Rabin Vincent (1):
      clocksource: dbx500-prcmu: use relaxed readl variant

Suman Anna (6):
      omap: mailbox: check iomem resource before dereferencing it
      omap: mailbox: call request_irq after mbox queues are allocated
      omap: mailbox: correct the argument type for irq ops
      ARM: OMAP2+: mbox: remove dependencies with soc.h
      ARM: OMAP2+: add user and fifo info to mailbox platform data
      mailbox/omap: move the OMAP mailbox framework to drivers

Sylwester Nawrocki (1):
      gpio: samsung: Remove OF support for s3c24xx

Tony Lindgren (1):
      Merge tag 'omap-mailbox-for-v3.11' of git://github.com/sumananna/mailbox into omap-for-v3.11/mailbox

Ulrich Hecht (1):
      sh-pfc: r8a7790: add HSCIF pin groups

Viresh Kumar (1):
      cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq

Wei Yongjun (1):
      dmaengine: ste_dma40: fix error return code in d40_probe()

avinash philip (2):
      ARM: OMAP2+: gpmc: Converts GPMC driver to pm_runtime capable
      ARM: OMAP2+: gpmc: Low power transition support

 Documentation/devicetree/bindings/bus/ti-gpmc.txt  |   1 -
 .../devicetree/bindings/clock/clk-exynos-audss.txt |  64 ++
 .../devicetree/bindings/dma/ste-dma40.txt          |  66 +++
 .../devicetree/bindings/gpio/gpio-samsung.txt      |  43 --
 .../devicetree/bindings/gpio/renesas,gpio-rcar.txt |  46 ++
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   8 +
 .../bindings/pinctrl/samsung-pinctrl.txt           |   8 +
 .../devicetree/bindings/sound/samsung-i2s.txt      |  46 +-
 .../devicetree/bindings/usb/atmel-usb.txt          |  82 +++
 .../devicetree/bindings/usb/ux500-usb.txt          |  50 ++
 arch/arm/Kconfig                                   |  47 --
 arch/arm/boot/dts/dbx5x0.dtsi                      |   5 +
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos4210-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4210-trats.dts             |   2 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |   2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   4 +-
 arch/arm/boot/dts/exynos4212.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts           |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   2 +-
 arch/arm/boot/dts/exynos4412.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   4 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   2 +-
 arch/arm/boot/dts/exynos5250-snow.dts              |   4 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  20 +-
 arch/arm/boot/dts/exynos5440-sd5v1.dts             |   2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |   2 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |   2 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   1 -
 arch/arm/boot/dts/s3c2416-smdk2416.dts             |   2 +-
 arch/arm/boot/dts/s3c2416.dtsi                     |   4 +-
 arch/arm/boot/dts/s3c24xx.dtsi                     |   2 +-
 arch/arm/boot/dts/snowball.dts                     |  13 +-
 arch/arm/configs/omap1_defconfig                   |   3 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/board-flash.c                  |   3 +
 arch/arm/mach-omap2/devices.c                      |  13 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |  44 +-
 arch/arm/mach-omap2/gpmc.c                         |  82 ++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  14 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  13 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  13 +
 arch/arm/mach-s3c24xx/Kconfig                      |  66 +--
 arch/arm/mach-s3c24xx/Makefile                     |   6 -
 arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |   0
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |   2 +-
 arch/arm/mach-ux500/board-mop500-audio.c           |  68 +--
 arch/arm/mach-ux500/board-mop500-sdi.c             |  56 +-
 arch/arm/mach-ux500/board-mop500.c                 |  94 +--
 arch/arm/mach-ux500/board-mop500.h                 |   2 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |  66 +--
 arch/arm/mach-ux500/devices-db8500.c               | 123 +---
 arch/arm/mach-ux500/ste-dma40-db8500.h             | 193 +++---
 arch/arm/mach-ux500/usb.c                          |  47 +-
 arch/arm/plat-omap/Kconfig                         |  16 -
 arch/arm/plat-omap/Makefile                        |   3 -
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |  10 +-
 arch/arm/plat-samsung/include/plat/cpu-freq.h      |   6 +-
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos-audss.c             | 133 +++++
 drivers/clk/samsung/clk-exynos5250.c               |   5 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |  11 +-
 drivers/cpufreq/Kconfig.arm                        |  58 ++
 drivers/cpufreq/Makefile                           |   5 +
 .../cpufreq/s3c2410-cpufreq.c                      |   0
 .../cpufreq/s3c2412-cpufreq.c                      |   3 +-
 .../cpufreq/s3c2440-cpufreq.c                      |   0
 .../cpufreq/s3c24xx-cpufreq-debugfs.c              |   0
 .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |   0
 drivers/crypto/ux500/cryp/cryp.c                   |   4 +-
 drivers/crypto/ux500/cryp/cryp.h                   |   7 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |  57 +-
 drivers/crypto/ux500/hash/hash_alg.h               |   5 +-
 drivers/crypto/ux500/hash/hash_core.c              |  57 +-
 drivers/dma/ste_dma40.c                            | 533 ++++++++++-------
 drivers/dma/ste_dma40_ll.c                         | 189 +++---
 drivers/dma/ste_dma40_ll.h                         |   3 +-
 drivers/gpio/gpio-rcar.c                           |  63 +-
 drivers/gpio/gpio-samsung.c                        |  67 +--
 drivers/mailbox/Kconfig                            |  34 ++
 drivers/mailbox/Makefile                           |   6 +
 .../mailbox.c => drivers/mailbox/mailbox-omap1.c   |  12 +-
 .../mailbox.c => drivers/mailbox/mailbox-omap2.c   | 276 ++++-----
 .../mailbox.c => drivers/mailbox/omap-mailbox.c    |  54 +-
 .../plat/mailbox.h => drivers/mailbox/omap-mbox.h  |  70 +--
 drivers/pinctrl/Kconfig                            |   5 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/pinctrl-s3c24xx.c                  | 651 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c                  |  10 +
 drivers/pinctrl/pinctrl-samsung.h                  |   4 +
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c               | 198 +++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |   4 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               | 227 ++++++-
 drivers/remoteproc/Kconfig                         |   3 +-
 drivers/remoteproc/omap_remoteproc.c               |   2 +-
 drivers/staging/tidspbridge/Kconfig                |   3 +-
 .../tidspbridge/include/dspbridge/host_os.h        |   2 +-
 drivers/usb/gadget/Kconfig                         |   2 +-
 drivers/usb/gadget/atmel_usba_udc.c                | 264 ++++++---
 drivers/usb/gadget/atmel_usba_udc.h                |   2 +
 drivers/usb/musb/ux500.c                           |  61 +-
 drivers/usb/musb/ux500_dma.c                       |  59 +-
 include/dt-bindings/clk/exynos-audss-clk.h         |  25 +
 include/linux/omap-mailbox.h                       |  29 +
 include/linux/platform_data/dma-ste-dma40.h        |  41 +-
 include/linux/platform_data/mailbox-omap.h         |  58 ++
 include/linux/platform_data/usb-musb-ux500.h       |   5 +-
 sound/soc/ux500/ux500_pcm.c                        |  10 +-
 112 files changed, 3168 insertions(+), 1651 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-exynos-audss.txt
 create mode 100644 Documentation/devicetree/bindings/dma/ste-dma40.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/renesas,gpio-rcar.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ux500-usb.txt
 rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
 create mode 100644 drivers/clk/samsung/clk-exynos-audss.c
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c => drivers/cpufreq/s3c2410-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c => drivers/cpufreq/s3c2412-cpufreq.c (99%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c => drivers/cpufreq/s3c2440-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c => drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c (100%)
 rename arch/arm/mach-omap1/mailbox.c => drivers/mailbox/mailbox-omap1.c (94%)
 rename arch/arm/mach-omap2/mailbox.c => drivers/mailbox/mailbox-omap2.c (59%)
 rename arch/arm/plat-omap/mailbox.c => drivers/mailbox/omap-mailbox.c (92%)
 rename arch/arm/plat-omap/include/plat/mailbox.h => drivers/mailbox/omap-mbox.h (54%)
 create mode 100644 drivers/pinctrl/pinctrl-s3c24xx.c
 create mode 100644 include/dt-bindings/clk/exynos-audss-clk.h
 create mode 100644 include/linux/omap-mailbox.h
 create mode 100644 include/linux/platform_data/mailbox-omap.h

