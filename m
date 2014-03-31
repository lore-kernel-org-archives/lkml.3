Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaCaLvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:51:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaCaLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:51:51 -0400
Date: Mon, 31 Mar 2014 12:51:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140331115137.GR2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/rMgauiyHIRVABE"
Content-Disposition: inline
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi updates for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/rMgauiyHIRVABE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E15

for you to fetch changes up to 45b15d98a96ffdb3c608bdad952f51930c151420:

  Merge remote-tracking branches 'spi/topic/xilinx' and 'spi/topic/xtfpga' =
into spi-next (2014-03-30 00:51:48 +0000)

----------------------------------------------------------------

spi: Updates for v3.15

A busy release for both cleanups and new drivers this time along with
further factoring out of replicated code into the core:

 - Provide support in the core for DMA mapping transfers - essentially
   all drivers weren't implementing this properly, now there's no
   excuse.
 - Dual and quad mode support for spidev.
 - Fix handling of cs_change in the generic implementation.
 - Remove the S3C_DMA code from the s3c64xx driver now that all the
   platforms using it have been converted to dmaengine.
 - Lots of improvements to the Renesas SPI controllers.
 - Drivers for Allwinner A10 and A31, Qualcomm QUP and Xylinx xtfpga.
 - Removal of the bitrotted ti-ssp driver.

----------------------------------------------------------------
Alexander Shiyan (5):
      spi: clps711x: Simplify handling of RX & TX buffers
      spi: clps711x: Add support for 1-8 BPW transfers
      spi: clps711x: Use SPI-core "cs_gpios" property for storing GPIOs
      spi/imx: Use dev_name() for request_irq() to distinguish SPIs
      spi: clps711x: Remove <mach/hardware.h> dependency

Alexander Stein (2):
      spi/topcliff-pch: Fix debug message
      spi: topcliff-pch: Transform noisy message to dev_vdbg

Arnd Bergmann (1):
      spi: remove obsolete spi-ti-ssp driver

Atsushi Nemoto (1):
      spi: core: make zero length transfer valid again

Axel Lin (91):
      spi: octeon: Use list_is_last() instead of open-coded
      spi: sc18is602: Remove sc18is602_setup() because it is done by spi co=
re
      spi: sirf: Avoid duplicate code in various bits_per_word cases
      spi: tegra114: Use list_is_last() instead of open-coded
      spi: davinci: Remove unneeded NULL checking for dspi and dspi->bitban=
g.master
      spi: davinci: Use of_match_ptr at appropriate place
      spi: orion: Let spi core handle checking transfer speed
      spi: mxs: Use list_for_each_entry to iterate over transfer list
      spi: Use SPI_BPW_MASK macro at appropriate places
      spi: omap-100k: Remove unused MOD_REG_BIT macro
      spi: omap-100k: Remove unused fields from struct omap1_spi100k
      spi: Use reinit_completion at appropriate places
      spi: core: Set max_speed_hz of spi_device default to max_speed_hz of =
controller
      spi: txx9: Convert to let spi core handle checking transfer speed
      spi: tegra114: Convert to use master->max_speed_hz
      spi: tegra20-sflash: Convert to use master->max_speed_hz
      spi: tegra20-slink: Convert to use master->max_speed_hz
      spi: sc18is602: Move checking chip_select for SC18IS602 to sc18is602_=
setup
      spi: orion: Convert to let spi core validate xfer->bits_per_word
      spi: octeon: Remove unused bits_per_word from struct octeon_spi_setup
      spi: Remove duplicate code to check chip_select
      spi: s3c24xx: Convert to let spi core validate bits_per_word
      spi: bfin5xx: Remove duplicate code to check spi->mode
      spi: nuc900: Remove unused fields from struct nuc900_spi
      spi: ep93xx: Convert to let spi core handle checking transfer speed
      spi: bfin5xx: Remove unused last_transfer pointer in bfin_spi_givebac=
k()
      spi: topcliff-pch: Convert to use master->max_speed_hz
      spi: au1550: Convert to let spi core handle checking transfer speed
      spi: sun6i: Fix define for SUN6I_TFR_CTL_CS_MASK
      spi: Remove explictly set bus_num and num_chipselect to default setti=
ng
      spi: mpc512x-psc: Remove redundant code to get bus_num from DT
      spi: omap2-mcspi: Remove list_empty checking in omap2_mcspi_transfer_=
one_message
      spi: omap2-mcspi: Convert to let spi core validate transfer speed
      spi: clps711x: Refactor to use core message parsing
      spi: qup: Remove spi_master_put in spi_qup_remove
      spi: qup: Convert ot let spi core handle checking transfer speed
      spi: sh-hspi: Convert to let spi core validate bits_per_word
      spi: Use list_last_entry at appropriate places
      spi: xilinx: Convert to let spi core validate bits_per_word
      spi: fsl-spi: Convert to let spi core validate xfer->bits_per_word
      spi: core: Replace msleep with usleep_range to get more accurate slee=
p time
      spi: qup: Fix build error due to a typo
      spi: qup: Enable driver compilation with COMPILE_TEST
      spi: qup: Depend on ARM && COMPILE_TEST to avoid build error
      spi: qup: Remove module version
      spi: s3c64xx: Let spi core handle validating transfer length
      spi: qup: Get rid of using struct spi_qup_device
      spi: sh-hspi: Remove hspi_cleanup function
      spi: txx9: Let spi core handle validating transfer length
      spi: orion: Let spi core handle validating transfer length
      spi: sh-hspi: Remove duplicate code to set default transfer speed
      spi: sh-msiof: Kill sh_msiof_spi_bits and sh_msiof_spi_hz functions
      spi: atmel: Remove redundant list_empty checking
      spi: omap-uwire: Convert to use bits_per_word_mask
      spi: octeon: Remove struct octeon_spi_setup usage
      spi: octeon: Convert to let spi core validate transfer speed
      spi: atmel: Let spi core handle validating transfer length
      spi: dw: Convert to let spi core validate transfer speed
      spi: sun4i: Set bits_per_word_mask to only support 8 bits word length
      spi: sun6i: Set bits_per_word_mask to only support 8 bits word length
      spi: xcomm: Remove duplicate code to set default bits_per_word and ma=
x speed
      spi: coldfire-qspi: Remove unused dev field from struct mcfqspi
      spi: coldfire-qspi: Use core message handling
      spi: s3c24xx: Add missing spi_master_{resume,suspend} calls to PM cal=
lbacks
      spi: coldfire-qspi: Enable clock before calling spi_master_resume
      spi: clps711x: Provide label argument for devm_gpio_request
      spi: coldfire-qspi: Prevent NULL pointer dereference
      spi: efm32: Clean up non-DT paths
      spi: sc18is602: Convert to let spi core validate transfer speed
      spi: clps711x: Remove duplicate code to set default bits_per_word and=
 max speed
      spi: oc-tiny: Remove unneeded NULL checking for hw->bitbang.master
      spi: altera: Use bits_per_word_mask
      spi: sirf: Add missing spi_master_{resume,suspend} calls to PM callba=
cks
      spi: sh-sci: Prevent NULL pointer dereference
      spi: core: Use master->max_speed_hz as transfer speed when xfer->spee=
d_hz > master->max_speed_hz
      spi: nuc900: Fix setting multiple bits settings in register
      spi: xtensa-xtfpga: Enable driver compilation with COMPILE_TEST
      spi: fsl-lib: Fix memory leak of pinfo
      spi: altera: Remove the code to get unused platform_data
      spi: fsl-espi: Remove unused bits_per_word variable in fsl_espi_bufs
      spi: topcliff-pch: Properly unregister platform devices on probe() er=
ror paths
      spi: bcm63xx: Remove unused define for PFX
      spi: coldfire-qspi: Simplify the code to set register bits for transf=
er speed
      spi: omap-uwire: Remove full duplex check
      spi: clps711x: Enable driver compilation with COMPILE_TEST
      spi: clps711x: Convert to use master->max_speed_hz
      spi: fsl-dspi: Fix memory leak
      spi: dw: Don't call kfree for memory allocated by devm_kzalloc
      spi: omap-100k: Fix memory leak
      spi: mpc52xx: Convert to use bits_per_word_mask
      spi: bitbang: Make spi_bitbang_stop() return void

Barry Song (1):
      spi: sirf: move to use generic dma dt-binding

Baruch Siach (2):
      spi: dw-mmio: allow multiple instances
      spi: dw-mmio: remove HAVE_CLK build dependecy

Chao Fu (2):
      spi/fsl-dspi: Convert to use regmap and add big-endian support
      spi/fsl-dspi: Remove some coding sytle not in standard

Christian Engelmayer (2):
      spi: orion: Remove unused pointer in orion_spi_write_read()
      spi: omap-100k: Remove unused pointer in omap1_spi100k_txrx_pio()

Fabio Estevam (3):
      spi: spi-mxs: Propagate the real error code on platform_get_irq() fai=
lure
      spi: spi-imx: Propagate the real error code on platform_get_irq() fai=
lure
      spi/imx: Drop default setting for SPI_IMX

Geert Uytterhoeven (40):
      spi: rspi: Remove unused mesg parameter from {send,receive}_pio()
      spi: rspi: Use core message handling
      spi: rspi: Abstract 8/16-bit Data Register access
      spi: rspi: Add rspi_data_{out,in,out_in}() helpers
      spi: rspi: Abstract transfer_one() for RSPI and QSPI
      spi: rspi: Merge rspi_send_pio() and rspi_receive_pio()
      spi: rspi: Merge qspi_send_pio() and qspi_receive_pio()
      spi: rspi: Add support for more than one interrupt
      spi: rspi: Add support for RSPI on RZ/A1H
      spi: rspi: Add support for loopback mode
      spi: rspi: Convert to clk_prepare_enable/disable_unprepare
      spi: rspi: Use NULL as the clock ID
      spi: rspi: Add DT support
      spi: rspi: Add support for Quad and Dual SPI Transfers on QSPI
      spi: rspi: Only enable interrupts when there's a need to wait
      spi/spidev_test: Document -N/--no-cs and -R/--ready
      spi: sh-msiof: Fix SPI bus population from DT
      spi: sh-msiof: Typo in comment s/tx/rx/
      spi: sh-msiof: Change hz from unsigned long to u32
      spi: sh-msiof: Add more register documentation
      spi: sh-msiof: Use the core cs_gpio field, and make it optional
      spi: rspi: List full example compatible properties in bindings
      spi: rspi: Remove bogus colon in formatting
      spi: rspi: Remove empty rspi_cleanup()
      spi: rspi: Fix loopback mode for Dual/Quad SPI Transfers
      spi: spidev: Restore all SPI mode flags on ioctl failure
      spi: spidev: Add support for Dual/Quad SPI Transfers
      spi: spidev_test: Add support for Dual/Quad SPI Transfers
      spi: spidev_fdx: Add support for Dual/Quad SPI Transfers
      spi: sh-msiof: Improve bindings
      spi: sh-msiof: Move default FIFO sizes to device ID data
      spi: sh-msiof: Add support for R-Car H2 and M2
      spi: sh-msiof: Move clock management to (un)prepare_message()
      spi: sh-msiof: Convert to let spi core validate xfer->bits_per_word
      spi: sh-msiof: Use core message handling instead of spi-bitbang
      spi: sh-msiof: Remove "renesas,msiof-sh7724" from bindings
      spi: sh-spi: Improve bindings
      spi: sh-hspi: Add missing call to pm_runtime_disable() in failure path
      spi: sh-msiof: Convert to spi core auto_runtime_pm framework
      spi: rspi: Add runtime PM support, using spi core auto_runtime_pm

Ivan T. Ivanov (3):
      spi: qup: Add device tree bindings information
      spi: Add Qualcomm QUP SPI controller support
      spi: core: Validate length of the transfers in message

Jean Delvare (1):
      spi: Clean up probe and remove functions

Jingoo Han (6):
      spi: xilinx: remove unnecessary spaces
      spi: sirf: Use SIMPLE_DEV_PM_OPS macro
      spi: txx9: Use devm_ioremap_resource()
      spi: omap-100k: fix spacing coding style issue
      spi: bcm63xx-hsspi: Use SIMPLE_DEV_PM_OPS macro
      spi: fsl-dspi: Use SIMPLE_DEV_PM_OPS macro

Mark Brown (27):
      spi/pl022: Unprepare clocks while suspended
      spi: Add a timeout when waiting for transfers
      spi: Provide core support for DMA mapping transfers
      spi/s3c64xx: Remove unused /CS GPIO management
      spi/s3c64xx: Split wait_for_xfer() into PIO and DMA versions
      spi: Provide core support for full duplex devices
      spi: Make core DMA mapping functions generate scatterlists
      spi/sunxi: Add missing dependency on RESET_CONTROLLER
      spi/s3c64xx: Use core DMA mapping code with dmaengine
      spi/s3c64xx: Remove S3C_DMA support
      spi/s3c64xx: Remove code no longer needed as a result of S3C_DMA remo=
val
      spi: Make max_tx and max_rx the same type
      Merge branch 'topic/dma' of git://git.kernel.org/.../broonie/spi into=
 HEAD
      Merge branch 'pm-drivers' of git://git.kernel.org/.../rafael/linux-pm=
 into spi-pl022
      spi: Do not require a completion
      spi: Fix handling of cs_change in core implementation
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/dma' into spi-next
      Merge remote-tracking branches 'spi/topic/altera', 'spi/topic/atmel',=
 'spi/topic/au1550', 'spi/topic/bcm63xx', 'spi/topic/bcm63xx-hsspi', 'spi/t=
opic/bfin5xx', 'spi/topic/bitbang' and 'spi/topic/bpw' into spi-next
      Merge remote-tracking branches 'spi/topic/bus-num', 'spi/topic/cleanu=
p', 'spi/topic/clps711x', 'spi/topic/coldfire', 'spi/topic/completion' and =
'spi/topic/davinci' into spi-next
      Merge remote-tracking branches 'spi/topic/drivers', 'spi/topic/dw', '=
spi/topic/efm32', 'spi/topic/ep93xx', 'spi/topic/fsl', 'spi/topic/fsl-dspi'=
, 'spi/topic/fsl-espi' and 'spi/topic/gpio' into spi-next
      Merge remote-tracking branches 'spi/topic/imx', 'spi/topic/init', 'sp=
i/topic/mpc512x-psc', 'spi/topic/mpc52xx', 'spi/topic/mxs', 'spi/topic/nuc9=
00', 'spi/topic/oc-tiny' and 'spi/topic/octeon' into spi-next
      Merge remote-tracking branches 'spi/topic/omap-uwire', 'spi/topic/oma=
p100k', 'spi/topic/omap2', 'spi/topic/orion', 'spi/topic/pl022', 'spi/topic=
/qup', 'spi/topic/rspi' and 'spi/topic/s3c24xx' into spi-next
      Merge remote-tracking branches 'spi/topic/s3c64xx', 'spi/topic/sc18is=
602', 'spi/topic/sh-hspi', 'spi/topic/sh-msiof', 'spi/topic/sh-sci', 'spi/t=
opic/sirf' and 'spi/topic/spidev' into spi-next
      Merge remote-tracking branches 'spi/topic/sunxi', 'spi/topic/tegra114=
', 'spi/topic/ti-qspi', 'spi/topic/ti-ssp', 'spi/topic/topcliff-pch', 'spi/=
topic/txx9', 'spi/topic/xcomm' and 'spi/topic/xfer' into spi-next
      Merge remote-tracking branches 'spi/topic/xilinx' and 'spi/topic/xtfp=
ga' into spi-next

Max Filippov (3):
      spi: add xtfpga SPI controller driver
      spi/xtensa-xtfpga: add DT binding documentation
      MAINTAINERS: add xtfpga platform section

Maxime Ripard (2):
      spi: sunxi: Add Allwinner A31 SPI controller driver
      spi: sunxi: Add Allwinner A10 SPI controller driver

Nishanth Menon (1):
      spi: omap-uwire: add missing iounmap

Paul Bolle (1):
      spi: omap2: use SUPERH, not SH

Paul Gortmaker (1):
      spi: delete non-required instances of include <linux/init.h>

Qipan Li (2):
      spi: sirf: use SET_SYSTEM_SLEEP_PM_OPS to initialize PM entries
      spi: sirf: provide a shortcut for spi command-data mode

Randy Dunlap (1):
      spi: atmel: fix printk format warnings

Sachin Kamat (1):
      spi/s3c64xx: Trivial cleanup in header file

SeongJae Park (1):
      spi: fix pointer-integer size mismatch warning

Shimoda, Yoshihiro (1):
      spi: rspi: fix build error when CONFIG_OF is not set

Sourav Poddar (1):
      spi/ti-qspi: Fix return from mmap path

Stefan Roese (1):
      spi: fsl: Fix problem with multi message transfers

Stefan S=F8rensen (2):
      spi: omap2-mcspi: Do not configure the controller on each transfer un=
less needed
      spi: omap2-mcspi: Support divide-by-n clock dividers

Ulf Hansson (6):
      spi: pl022: Simplify clock handling
      spi: pl022: Remove redundant pinctrl to default state in probe
      PM / runtime: Fetch runtime PM callbacks using a macro
      PM: Add pm_runtime_suspend|resume_force functions
      spi: pl022: Let runtime PM callbacks be available for CONFIG_PM
      spi: pl022: Don't ignore power domain and amba bus at system suspend

Uwe Kleine-K=F6nig (2):
      spi: efm32: properly namespace location property
      spi: efm32: use $vendor,$device scheme for compatible string

Wenyou Yang (1):
      spi: atmel: adopt pinctrl support

 .../devicetree/bindings/spi/efm32-spi.txt          |   8 +-
 .../devicetree/bindings/spi/qcom,spi-qup.txt       |  85 +++
 Documentation/devicetree/bindings/spi/sh-hspi.txt  |  28 +-
 Documentation/devicetree/bindings/spi/sh-msiof.txt |  42 +-
 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |   2 +
 Documentation/devicetree/bindings/spi/spi-rspi.txt |  61 ++
 .../devicetree/bindings/spi/spi-sun4i.txt          |  24 +
 .../devicetree/bindings/spi/spi-sun6i.txt          |  24 +
 .../devicetree/bindings/spi/spi-xtensa-xtfpga.txt  |   9 +
 Documentation/spi/spidev                           |   6 +
 Documentation/spi/spidev_fdx.c                     |   8 +-
 Documentation/spi/spidev_test.c                    |  45 +-
 MAINTAINERS                                        |   6 +
 drivers/base/power/Makefile                        |   3 +-
 drivers/base/power/runtime.c                       | 162 +++-
 drivers/spi/Kconfig                                |  55 +-
 drivers/spi/Makefile                               |   5 +-
 drivers/spi/spi-altera.c                           |   7 +-
 drivers/spi/spi-ath79.c                            |   1 -
 drivers/spi/spi-atmel.c                            |  34 +-
 drivers/spi/spi-au1550.c                           |  30 +-
 drivers/spi/spi-bcm2835.c                          |   1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bfin-sport.c                       |   1 -
 drivers/spi/spi-bfin-v3.c                          |   3 +-
 drivers/spi/spi-bfin5xx.c                          |   8 -
 drivers/spi/spi-bitbang.c                          |   5 +-
 drivers/spi/spi-butterfly.c                        |   3 +-
 drivers/spi/spi-clps711x.c                         | 227 +++---
 drivers/spi/spi-coldfire-qspi.c                    | 112 ++-
 drivers/spi/spi-davinci.c                          |  14 +-
 drivers/spi/spi-dw-mmio.c                          |   2 +-
 drivers/spi/spi-dw.c                               |  17 +-
 drivers/spi/spi-efm32.c                            |  46 +-
 drivers/spi/spi-ep93xx.c                           |  21 +-
 drivers/spi/spi-falcon.c                           |   5 -
 drivers/spi/spi-fsl-dspi.c                         |  94 ++-
 drivers/spi/spi-fsl-espi.c                         |   5 -
 drivers/spi/spi-fsl-lib.c                          |  14 +-
 drivers/spi/spi-fsl-spi.c                          |  30 +-
 drivers/spi/spi-gpio.c                             |   8 +-
 drivers/spi/spi-imx.c                              |   7 +-
 drivers/spi/spi-mpc512x-psc.c                      |  17 +-
 drivers/spi/spi-mpc52xx-psc.c                      |   1 -
 drivers/spi/spi-mpc52xx.c                          |  17 +-
 drivers/spi/spi-mxs.c                              |   7 +-
 drivers/spi/spi-nuc900.c                           |  28 +-
 drivers/spi/spi-oc-tiny.c                          |   3 -
 drivers/spi/spi-octeon.c                           |  80 +-
 drivers/spi/spi-omap-100k.c                        |  52 +-
 drivers/spi/spi-omap-uwire.c                       |  34 +-
 drivers/spi/spi-omap2-mcspi.c                      |  65 +-
 drivers/spi/spi-orion.c                            |  80 +-
 drivers/spi/spi-pl022.c                            |  80 +-
 drivers/spi/spi-ppc4xx.c                           |   1 -
 drivers/spi/spi-pxa2xx-dma.c                       |   1 -
 drivers/spi/spi-pxa2xx-pxadma.c                    |   1 -
 drivers/spi/spi-pxa2xx.c                           |   3 +-
 drivers/spi/spi-qup.c                              | 779 +++++++++++++++++=
++
 drivers/spi/spi-rspi.c                             | 842 ++++++++++++++---=
----
 drivers/spi/spi-s3c24xx.c                          |  19 +-
 drivers/spi/spi-s3c64xx.c                          | 424 +++--------
 drivers/spi/spi-sc18is602.c                        |  29 +-
 drivers/spi/spi-sh-hspi.c                          |  43 +-
 drivers/spi/spi-sh-msiof.c                         | 385 +++++-----
 drivers/spi/spi-sh-sci.c                           |   8 +-
 drivers/spi/spi-sirf.c                             | 116 +--
 drivers/spi/spi-sun4i.c                            | 478 ++++++++++++
 drivers/spi/spi-sun6i.c                            | 484 ++++++++++++
 drivers/spi/spi-tegra114.c                         |  27 +-
 drivers/spi/spi-tegra20-sflash.c                   |  26 +-
 drivers/spi/spi-tegra20-slink.c                    |  20 +-
 drivers/spi/spi-ti-qspi.c                          |   5 +-
 drivers/spi/spi-ti-ssp.c                           | 378 ---------
 drivers/spi/spi-topcliff-pch.c                     |  47 +-
 drivers/spi/spi-txx9.c                             |  25 +-
 drivers/spi/spi-xcomm.c                            |  13 +-
 drivers/spi/spi-xilinx.c                           |  27 +-
 drivers/spi/spi-xtensa-xtfpga.c                    | 170 +++++
 drivers/spi/spi.c                                  | 247 +++++-
 drivers/spi/spidev.c                               |  23 +-
 include/linux/platform_data/spi-s3c64xx.h          |   9 +-
 include/linux/pm_runtime.h                         |   4 +
 include/linux/spi/spi.h                            |  31 +
 include/linux/spi/spi_bitbang.h                    |   2 +-
 include/uapi/linux/spi/spidev.h                    |  14 +-
 87 files changed, 4129 insertions(+), 2298 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rspi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun4i.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun6i.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga=
=2Etxt
 create mode 100644 drivers/spi/spi-qup.c
 create mode 100644 drivers/spi/spi-sun4i.c
 create mode 100644 drivers/spi/spi-sun6i.c
 delete mode 100644 drivers/spi/spi-ti-ssp.c
 create mode 100644 drivers/spi/spi-xtensa-xtfpga.c

--J/rMgauiyHIRVABE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOVbGAAoJELSic+t+oim9b5EP/A/DCboMOMc8X7OQOGixgSB5
oiFjEzjPr+C7cUYqzmfylRrCEJZo2S2HBZF6djGxLoCdDENpRjvKxubBddiT09C0
/wr4JRwnZzleU/UHtZunnTVlgPcekRBOJXF3nnuPofx2uKh82FYoLYAnJ1sfB299
BjWQYz7HnRyArO7jj/1XRYnKC2P6P0kbEXfVKij6ICvZmgGytovRfaUtyKuqXE+t
BKZKW1NLCoRKP2231U5z26qKPk40ST4Kmb1b4FGJxiWj0NV3wu6KeY60U25UpK+c
pngLdk1pifQ0wD5TLjt7abVjnFkv8saiJbNAk3AG5sxz5/az7bzbOz1+TfO9NoTl
Xa7e9BYDRtZc7Npom+DlsvB5dO/okjOdsb0jCmhd/tVac9Xiv9UpTLxuWE+ag3T9
MMRjq+XUffkDpzD3iOuun9FGLU4sf32+jeaqFc1KbF63iv76ukLu2zw+5YrYB8KF
xgQgPjN0d4NDabkgsgd5odPPyobxXa18CHE0FRUXT6fz/tMFbO52b3YKgdzbq5PP
wP/e9+kRMB35cRgVd8Rauhfb3bu/jRZ7sjsqwmHTn9eQBK52+5UJYDg80APkH9zd
0QrOufk45f6AHGzLxxSqONgsamie04IjEO5xjDAu7ZJ7NkNs8AZ8CXh3M99HOyZD
NQBb5KytdLYgxhI/37DE
=K8QH
-----END PGP SIGNATURE-----

--J/rMgauiyHIRVABE--
