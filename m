Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3IBVTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:19:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60649 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3IBVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:19:07 -0400
Date: Mon, 2 Sep 2013 22:19:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130902211902.GY3084@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rx43rDlPB5nB2+S"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.122
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3rx43rDlPB5nB2+S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E12

for you to fetch changes up to 578739259875a93b1869d25cdf4a8bd963b7d0a7:

  Merge remote-tracking branch 'spi/topic/txx9' into spi-next (2013-09-01 1=
3:49:18 +0100)

----------------------------------------------------------------

spi: Updates for v3.12

Business as usual for SPI - some new drivers, lots of fixes and updates
to existing drivers plus some new framework features.  Notable changes
are:

 - Support for dual and quad data lines, commonly used by flash chips to
   improve performance, from Wang Yuhang.
 - Factored out a common pattern for runtime PM implementation into the
   core saving a bunch of code.
 - A particularly nice set of updates to the ep93xx driver from
   H Hartley Sweeten, modernising it and reducing the code size a lot.
 - New drivers for Blackfin v3, EFM32, Freescale DSPI and TI QSPI.

----------------------------------------------------------------
Alexander Stein (1):
      spi-topcliff-pch: Add MODULE_DEVICE_TABLE

Andy Shevchenko (2):
      spi: tle62x0: dump small buffers using %*ph
      spi: tle62x0: dump small buffers using %*ph

Axel Lin (16):
      spi: bcm2835: Use SPI_BPW_MASK macro for bits_per_word_mask setting
      spi: octeon: Remove my_master pointer from struct octeon_spi
      spi: spi-mxs: Remove unused bits_per_word variable
      spi: bitbang: Remove unused tmp variable
      spi: octeon: Remove empty octeon_spi_nop_transfer_hardware function
      spi: octeon: Remove unused bits_per_word variable in octeon_spi_do_tr=
ansfer
      spi: octeon: Convert to use bits_per_word_mask
      spi: Remove a redundant test for master->running in spi_queued_transf=
er
      spi: bcm2835: Add spi_master_get() call to prevent use after free
      spi: altera: Simplify altera_spi_txrx implementation for noirq case
      spi: nuc900: Fix mode_bits setting
      spi: Use dev_get_drvdata at appropriate places
      spi: rspi: Add spi_master_get() call to prevent use after free
      spi: altera: Use DIV_ROUND_UP to calculate hw->bytes_per_word
      spi: efm32: Fix build error
      spi: core: Fix spi_register_master error handling

Barry Song (1):
      spi: sirf: use DMA if both buffer address and length are aligned

Boris BREZILLON (1):
      spi: atmel: prepare clk before calling enable

Chao Fu (2):
      Documentation: DT: Add Freescale DSPI driver
      spi:Add Freescale DSPI driver for Vybrid VF610 platform

Dan Carpenter (1):
      spi/xilinx: signedness issue checking platform_get_irq()

Emil Goode (2):
      spi/atmel: Fix format specifier warnings
      spi/ep93xx: Fix format specifier warning

Fabio Estevam (8):
      spi: spi-imx: Use devm functions
      spi: spi-imx: Check the return value from clk_prepare_enable()
      spi: spi-mxs: Fix the error path sequence
      spi: spi-mxs: Check the return value from clk_prepare_enable()
      spi: spi-mxs: Check the return value from stmp_reset_block()
      spi: spi-bitbang: Fix conversion of spi_bitbang_transfer_one()
      spi: spi-mxs: Remove unneeded check for platform_get_resource()
      spi: spi-pl022: Fix warning when CONFIG_ARM_LPAE=3Dy

Gabor Juhos (1):
      spi: limit default transfer speed to controller's max speed

Gerhard Sittig (1):
      spi: mpc512x: cleanup clock API use

Girish K S (1):
      spi: s3c64xx: add missing check for polling mode

Guennadi Liakhovetski (1):
      spi: rspi: provide port addresses to dmaengine driver via slave confi=
guration

H Hartley Sweeten (10):
      spi: spi-ep93xx: always handle transfer specific settings
      spi: spi-ep93xx: use read,write instead of __raw_* variants
      spi: spi-ep93xx: remove bits_per_word() helper
      spi: spi-ep93xx: get platform resources early in (*probe)
      spi: spi-ep93xx: remove dev_err() for kzalloc() failure
      spi: spi-ep93xx: remove 'dss' from per chip private data
      spi: spi-ep93xx: use devm_clk_get()
      spi: spi-ep93xx: don't bother calculating the divisors in ep93xx_spi_=
setup()
      spi: spi-ep93xx: move the clock divider calcs into ep93xx_spi_chip_se=
tup()
      spi: spi-ep93xx: convert to the queued driver infrastructure

Jingoo Han (5):
      spi: s3c64xx: fix checkpatch error and warnings
      spi: s3c64xx: fix printk warnings
      spi: s3c64xx: fix casting warning
      spi: bfin-v3: remove unnecessary platform_set_drvdata()
      spi: use dev_get_platdata()

Julia Lawall (3):
      spi/spi-{bcm63xx.c,bfin-v3.c}: simplify use of devm_ioremap_resource
      spi/sirf: simplify use of devm_ioremap_resource
      spi: simplify devm_request_mem_region/devm_ioremap

Laurent Navet (1):
      drivers/spi/spi-tegra114.c clean use of devm_ioremap_resource()

Mark Brown (87):
      spi/bitbang: Unexport spi_bitbang_transfer()
      spi/bitbang: Factor out message transfer from message pump loop
      spi/rspi: Add missing dependency on DMAE
      spi: Support transfer speed checking in the core
      spi: More sanity checks for transfers
      spi/clps711x: Remove unneeded devm_ deallocations
      spi/omap-100k: Remove empty reset function
      spi/omap-100k: Use core functionality to check validity of transfers
      spi/omap-100k: Factor message transfer function out of work queue
      spi/omap-100k: Convert to use core message queue implementation
      spi/omap-100k: Convert to devm_clk_get()
      spi/omap-100k: Prepare and unprepare clocks
      spi/omap-100k: Convert to module_platform_driver()
      spi/xilinx: Convert to devm_ioremap_resource()
      spi/xilinx: Remove remains of of_platform device registration
      spi/xilinx: Refer to platform device as pdev in probe() and remove()
      spi/bitbang: Use core message pump
      spi/s3c64xx: Remove unused message queue
      spi/sh-hspi: Remove noisy print
      spi/sh-msiof: Remove unneeded empty runtime PM callbacks
      spi/atmel: Annotate lock/unlock functions
      spi/orion: Directly include linux/size.h
      spi/drivers: Enable build of drivers with COMPILE_TEST
      spi/orion: Convert to devm_ioremap_resource()
      spi/tegra114: Factor runtime PM out into transfer prepare/unprepare
      spi/tegra-sflash: Factor runtime PM out into transfer prepare/unprepa=
re
      spi/tegra-slink: Factor runtime PM out into transfer prepare/unprepare
      spi: Provide core support for runtime PM during transfers
      spi/bcm63xx: Convert to core runtime PM
      spi/coldfire-qspi: Convert to core runtime PM
      spi/omap2: Covert to core runtime PM
      spi/pl022: Convert to core runtime PM
      spi/pxa2xx: Convert to core runtime PM
      spi/hspi: Convert to core runtime PM
      spi/s3c64xx: Use core for runtime PM
      spi/tegra114: Use core runtime PM
      spi/tegra20-sflash: Use core runtime PM
      spi/tegra20-slink: Use core runtime PM
      spi/txx9: Use linux/gpio.h not asm/gpio.h
      spi/sirf: Depends on SIRF_DMA
      spi/build: Remove SPI_SIRF from compile test
      Merge tag 'v3.11-rc4' into spi-bitbang
      spi/bitbang: Drop empty setup() functions
      Merge tag 'v3.11-rc5' into spi-s3c64xx
      spi/s3c64xx: Take runtime PM reference even if DMA is not supported
      Merge remote-tracking branch 'spi/topic/quad' into spi-qspi
      Merge remote-tracking branch 'spi/topic/xilinx' into spi-pdata
      Merge remote-tracking branch 'spi/topic/rspi' into spi-pdata
      spi: quad: Make DT properties optional
      Merge remote-tracking branch 'spi/topic/atmel' into spi-next
      Merge remote-tracking branch 'spi/topic/bcm2835' into spi-next
      Merge remote-tracking branch 'spi/topic/bitbang' into spi-next
      Merge remote-tracking branch 'spi/topic/blackfin-v3' into spi-next
      Merge remote-tracking branch 'spi/topic/bpw' into spi-next
      Merge remote-tracking branch 'spi/topic/build' into spi-next
      Merge remote-tracking branch 'spi/topic/checks' into spi-next
      Merge remote-tracking branch 'spi/topic/clps711x' into spi-next
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/davinci' into spi-next
      Merge remote-tracking branch 'spi/topic/doc' into spi-next
      Merge remote-tracking branch 'spi/topic/dspi' into spi-next
      Merge remote-tracking branch 'spi/topic/efm32' into spi-next
      Merge remote-tracking branch 'spi/topic/ep93xx' into spi-next
      Merge remote-tracking branch 'spi/topic/imx' into spi-next
      Merge remote-tracking branch 'spi/topic/ioremap' into spi-next
      Merge remote-tracking branch 'spi/topic/mpc512x' into spi-next
      Merge remote-tracking branch 'spi/topic/msglen' into spi-next
      Merge remote-tracking branch 'spi/topic/mxs' into spi-next
      Merge remote-tracking branch 'spi/topic/nuc900' into spi-next
      Merge remote-tracking branch 'spi/topic/octeon' into spi-next
      Merge remote-tracking branch 'spi/topic/omap-100k' into spi-next
      Merge remote-tracking branch 'spi/topic/orion' into spi-next
      Merge remote-tracking branch 'spi/topic/pdata' into spi-next
      Merge remote-tracking branch 'spi/topic/pl022' into spi-next
      Merge remote-tracking branch 'spi/topic/pxa' into spi-next
      Merge remote-tracking branch 'spi/topic/qspi' into spi-next
      Merge remote-tracking branch 'spi/topic/quad' into spi-next
      Merge remote-tracking branch 'spi/topic/rspi' into spi-next
      Merge remote-tracking branch 'spi/topic/s3c64xx' into spi-next
      Merge remote-tracking branch 'spi/topic/sh-hspi' into spi-next
      Merge remote-tracking branch 'spi/topic/sh-msiof' into spi-next
      Merge remote-tracking branch 'spi/topic/sirf' into spi-next
      Merge remote-tracking branch 'spi/topic/tegra' into spi-next
      Merge remote-tracking branch 'spi/topic/tel62x0' into spi-next
      Merge remote-tracking branch 'spi/topic/tle62x0' into spi-next
      Merge remote-tracking branch 'spi/topic/topcliff' into spi-next
      Merge remote-tracking branch 'spi/topic/txx9' into spi-next

Michal Simek (4):
      spi/xilinx: Remove CONFIG_OF from the driver
      spi/xilinx: Clean ioremap calling
      spi/xilinx: Use of_property_read_u32 for reading value from node
      spi/xilinx: Simplify irq allocation

Mika Westerberg (1):
      spi/pxa2xx: enable DMA on newer Intel LPSS silicon

Niels de Vos (1):
      spi/imx: expose module alias for loading from device-tree

Qipan Li (2):
      spi: sirf: add missed spi mode_bits that SiRFSoC hardware supports
      spi/sirf: fix the misunderstanding about len of spi_transfer

Sachin Kamat (1):
      spi/documentation: Fix usage of __initdata

Santosh Shilimkar (1):
      spi: davinci: Update configs to make it selectable on Keystone

Scott Jiang (1):
      spi: add spi controller v3 master driver for Blackfin

Shimoda, Yoshihiro (1):
      spi: spi-rspi: fix inconsistent spin_lock_irqsave

Sourav Poddar (6):
      driver: spi: Modify core to compute the message length
      spi/qspi: Add qspi flash controller
      spi: conditional checking of mode and transfer bits.
      spi/qspi: Add dual/quad spi read support
      spi/qspi: Fix device table entry
      spi/qspi: Add compatible string for am4372.

Stephen Warren (1):
      spi: fix SPI_BIT_MASK so it always fits into 32-bits

Tomasz Figa (3):
      spi: s3c64xx: Zero dma_slave_config struct in prepare_dma()
      spi: s3c64xx: Do not request CS GPIO on subsequent calls to .setup()
      spi: s3c64xx: Use dmaengine_prep_slave_single() to prepare DMA transf=
ers

Uwe Kleine-K=F6nig (2):
      spi/bitbang: don't error out if there is no setup callback provided
      spi: new controller driver for efm32 SoCs

Wei Yongjun (4):
      spi: tegra114: remove redundant dev_err call in tegra_spi_probe()
      spi: spi-efm32: remove redundant dev_err call in efm32_spi_probe()
      spi: sirf: fix error return code in spi_sirfsoc_probe()
      spi/qspi: fix missing unlock on error in ti_qspi_start_transfer_one()

Wolfram Sang (1):
      spi: bcm2835: don't check resource with devm_ioremap_resource

wangyuhang (3):
      spi: DUAL and QUAD support
      spi: quad: Fix missing return
      spi: quad: fix the name of DT property

 .../devicetree/bindings/spi/efm32-spi.txt          |  34 +
 Documentation/devicetree/bindings/spi/spi-bus.txt  |  10 +
 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |  42 +
 Documentation/devicetree/bindings/spi/ti_qspi.txt  |  22 +
 Documentation/spi/spi-summary                      |   2 +-
 drivers/spi/Kconfig                                |  63 +-
 drivers/spi/Makefile                               |   4 +
 drivers/spi/spi-altera.c                           |  48 +-
 drivers/spi/spi-ath79.c                            |   2 +-
 drivers/spi/spi-atmel.c                            |  36 +-
 drivers/spi/spi-au1550.c                           |   2 +-
 drivers/spi/spi-bcm2835.c                          |  10 +-
 drivers/spi/spi-bcm63xx.c                          |  37 +-
 drivers/spi/spi-bfin-sport.c                       |   2 +-
 drivers/spi/spi-bfin-v3.c                          | 965 +++++++++++++++++=
++++
 drivers/spi/spi-bfin5xx.c                          |   2 +-
 drivers/spi/spi-bitbang.c                          | 260 +++---
 drivers/spi/spi-clps711x.c                         |   6 -
 drivers/spi/spi-coldfire-qspi.c                    |  27 +-
 drivers/spi/spi-davinci.c                          |   4 +-
 drivers/spi/spi-efm32.c                            | 516 +++++++++++
 drivers/spi/spi-ep93xx.c                           | 355 ++------
 drivers/spi/spi-fsl-dspi.c                         | 557 ++++++++++++
 drivers/spi/spi-fsl-espi.c                         |   4 +-
 drivers/spi/spi-fsl-lib.c                          |   2 +-
 drivers/spi/spi-fsl-spi.c                          |  13 +-
 drivers/spi/spi-gpio.c                             |   4 +-
 drivers/spi/spi-imx.c                              |  76 +-
 drivers/spi/spi-mpc512x-psc.c                      |  50 +-
 drivers/spi/spi-mpc52xx-psc.c                      |   2 +-
 drivers/spi/spi-mxs.c                              |  28 +-
 drivers/spi/spi-nuc900.c                           |  17 +-
 drivers/spi/spi-oc-tiny.c                          |  24 +-
 drivers/spi/spi-octeon.c                           |  49 +-
 drivers/spi/spi-omap-100k.c                        | 278 ++----
 drivers/spi/spi-omap2-mcspi.c                      |  22 +-
 drivers/spi/spi-orion.c                            |  23 +-
 drivers/spi/spi-pl022.c                            |  28 +-
 drivers/spi/spi-pxa2xx.c                           |  21 +-
 drivers/spi/spi-rspi.c                             |  21 +-
 drivers/spi/spi-s3c24xx.c                          |   6 +-
 drivers/spi/spi-s3c64xx.c                          | 120 +--
 drivers/spi/spi-sh-hspi.c                          |  20 +-
 drivers/spi/spi-sh-msiof.c                         |  20 +-
 drivers/spi/spi-sh-sci.c                           |   2 +-
 drivers/spi/spi-sirf.c                             | 233 +++--
 drivers/spi/spi-tegra114.c                         |  18 +-
 drivers/spi/spi-tegra20-sflash.c                   |   8 +-
 drivers/spi/spi-tegra20-slink.c                    |   8 +-
 drivers/spi/spi-ti-qspi.c                          | 574 ++++++++++++
 drivers/spi/spi-ti-ssp.c                           |   2 +-
 drivers/spi/spi-tle62x0.c                          |   5 +-
 drivers/spi/spi-topcliff-pch.c                     |   2 +
 drivers/spi/spi-txx9.c                             |   2 +-
 drivers/spi/spi-xilinx.c                           | 188 ++--
 drivers/spi/spi.c                                  | 137 ++-
 include/linux/platform_data/efm32-spi.h            |  14 +
 include/linux/spi/spi.h                            |  36 +-
 include/linux/spi/spi_bitbang.h                    |   5 -
 59 files changed, 3721 insertions(+), 1347 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/efm32-spi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-fsl-dspi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/ti_qspi.txt
 create mode 100644 drivers/spi/spi-bfin-v3.c
 create mode 100644 drivers/spi/spi-efm32.c
 create mode 100644 drivers/spi/spi-fsl-dspi.c
 create mode 100644 drivers/spi/spi-ti-qspi.c
 create mode 100644 include/linux/platform_data/efm32-spi.h

--3rx43rDlPB5nB2+S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJQDDAAoJELSic+t+oim9O6AP/icAmo/1t4d2npqrJkfMl5Ne
L+mJqdnmOY89ZjZnmub8H53pTOnpRKkzfhlZ52gwubxEDZvMmCOdnrM5y+uWo/Le
j2MJNpGEKCnh/W8sssPcRPQGHZOKmap9RKnrQuPdJNY4PKxDJYk+Aa5gT+76PkI4
5eJ5ZeU1kSX3SCeU8r3QWXEutv9iIJoi9+3RyoV7Q947ZqwkGx+VeWLQqXR3xp2X
6MZElBFjlES8RpmhZjofgRFMdErTx2x0oiscy4eBCFtkIp2R+lv+wevaOTgKeBc0
e+833xw6H68DCQt2y7sbI9ecL0kUl+ToOwAZfQP3t+VX9hCFW9YVkf/kaRB5mD6W
AOWyWd4G0nOPv07pDB6NGwRh0yHt7N60FYYQ4JjvRf8xAJnfm1zxjp1JgWxB/t6n
K7Xh5fGb+im7xa4vv6NKiwjKQ8rf3fIc05DzrvIlZEvNj8ImRzXYVciYpIZrq1Zy
wXNTEUiugZKxwVZqcFmH+kqva0zgHwQt5o3RoArSjTxYAMG7j4iuBomQxa7WM4jl
ssyMIqAPt16SfcgK8ZB9ODSzXjMZMkFXzZDjL+cS0Qwg/l7TOs2POzfIquwHCKx8
8YVEqkEpHyVkUCOSFBOBCPOmi+hkygTsT4WY5K96t1jqLRrULQY80xv3j4j91FB7
8/d8UQNcncdhhK3siLVH
=2OGj
-----END PGP SIGNATURE-----

--3rx43rDlPB5nB2+S--
