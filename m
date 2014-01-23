Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaAWNTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:19:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58567 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWNTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:19:47 -0500
Date: Thu, 23 Jan 2014 13:19:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140123131936.GK17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GMOLFvf9RD8hOD5r"
Content-Disposition: inline
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.14 remerged
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GMOLFvf9RD8hOD5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.14-2

for you to fetch changes up to 8b8b773e6b611e6629ac01f85d401c949d153546:

  Merge commit 'spi/topic/sc18is602' into spi-linus (2014-01-23 13:14:15 +0000)

----------------------------------------------------------------

spi: Updates for v3.14

A respun version of the merges for the pull request previously sent with
a few additional fixes.  The last two merges were fixed up by hand since
the branches have moved on and currently have the prior merge in them.

Quite a busy release for the SPI subsystem, mostly in cleanups big and
small scattered through the stack rather than anything else:

 - New driver for the Broadcom BC63xx HSSPI controller.
 - Fix duplicate device registration for ACPI.
 - Conversion of s3c64xx to DMAEngine (this pulls in platform and DMA
   changes upon which the transiton depends).
 - Some small optimisations to reduce the amount of time we hold locks
   in the datapath, eliminate some redundant checks and the size of a
   spi_transfer.
 - Lots of fixes, cleanups and general enhancements to drivers,
   especially the rspi and Atmel drivers.

----------------------------------------------------------------
Alexander Shiyan (1):
      spi: clps711x: Use devm_gpio_request()

Axel Lin (15):
      spi: core: Use list_first_entry_or_null() instead of open-coded
      spi: s3c64xx: Remove duplicate code to clear S3C64XX_SPI_SLAVE_SEL register
      spi: ti-qspi: Fix getting correct address for qspi
      spi: sh-hspi: Fix modalias for sh-hspi
      spi: core: Use list_first_entry to extract head of queue
      spi: fsl-dspi: Add missing breaks for switch cases
      spi: oc-tiny: Simplify tiny_spi_txrx_bufs implementation when irq is not used
      spi: altera: Remove unneeded NULL checking for hw->bitbang.master
      spi: ti-qspi: Simplify qspi_write_msg and qspi_read_msg implementation
      spi: ti-qspi: Fixup driver name
      spi: sh: Use spi_sh_clear_bit() instead of open-coded
      spi: clps711x: Add MODULE_ALIAS to support module auto-loading
      spi: Remove duplicate code to set default bits_per_word setting
      spi: sc18is602: Convert to use bits_per_word_mask
      spi: core: Fix transfer failure when master->transfer_one returns positive value

Baruch Siach (6):
      spi: gpio: clarify gpio chipselect language
      spi: dw: drop unused struct dw_spi field
      spi: dw: use managed resources
      spi: dw-mmio: prepare the clock before enabling
      spi: dw: fix memory leak on error path
      spi: dw-pci: fix typo

Dan Carpenter (1):
      spi: bcm63xx-hsspi: checking for ERR_PTR instead of NULL

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Ezequiel Garcia (1):
      spi: spi-gpio: Use 'cansleep' variants to access GPIO

Geert Uytterhoeven (21):
      spi: rspi: Fix NULL pointer dereference on SH7757
      spi: rspi: Fix typo when clearing SPSR_OVRF
      spi: rspi: Use dev_get_platdata() instead of raw dev.platform_data access
      spi: rspi: Remove casts
      spi: rspi: Make more pointers const
      spi: rspi: Use DUMMY_DATA macro instead of hardcoded value
      spi: rspi: Use u8 for 8-bit register values
      spi: Kill superfluous cast in spi_w8r16()
      spi: core: Improve tx/rx_nbits check comments
      spi: sh-hspi: Spelling s/recive/receive/
      spi: bitbang: Grammar s/make to make/to make/
      spi/s3c64xx: Correct indentation
      spi: rspi: Remove dependency on DMAE for SHMOBILE
      spi: rspi: Add more RSPI register documentation
      spi: rspi: Add more QSPI register documentation
      spi: rspi: Add support for specifying CPHA/CPOL
      spi: rspi: Spelling s/transmition/transmission/
      spi: rspi: Add missing clk_disable() calls in error and cleanup paths
      spi: Spelling s/finised/finished/
      spi: Clarify transfer_one() w.r.t. spi_finalize_current_transfer()
      spi: Correct set_cs() documentation

Hou Zhiqiang (2):
      spi/fsl-espi: fix the return value judgment of irq_of_parse_and_map.
      spi/fsl-espi: Add Power Management support for eSPI controller

Jingoo Han (17):
      spi: remove DEFINE_PCI_DEVICE_TABLE macro
      spi: atmel: Use devm_*() functions
      spi: coldfire-qspi: Use devm_*() functions
      spi: xcomm: Use devm_spi_register_master()
      spi: sc18is602: Use devm_spi_register_master()
      spi: falcon: Use devm_spi_register_master()
      spi: orion: Use devm_clk_get()
      spi: rcar: Use devm_spi_register_master()
      spi: bcm63xx-hsspi: Use devm_clk_get()
      spi: bcm63xx: Use devm_clk_get()
      spi: nuc900: Use devm_*() functions
      spi: davinci: Use devm_*() functions
      spi: ath79: Use devm_*() functions
      spi: s3c24xx: Use devm_*() functions
      spi: txx9: Use devm_clk_get()
      spi: bcm2835: Use devm_request_irq()
      spi: mpc512x: Use devm_*() functions

John Whitmore (1):
      spi: Correction to typos in Documentation/spi/spi-summary

Jonas Gorski (8):
      spi: bcm63xx-hsspi: add bcm63xx HSSPI driver
      spi/bcm63xx-hsspi: check result of clk_prepare_enable
      spi/bcm63xx-hsspi: use devm_register_master()
      spi/bcm63xx-hsspi: fix pm sleep support
      spi/bcm63xx: don't substract prepend length from total length
      spi/bcm63xx: don't reject reads >= 256 bytes
      spi/bcm63xx: check return value of clk_prepare_enable
      spi/bcm63xx: fix pm sleep support

Laurent Pinchart (7):
      spi: sh-msiof: Fix warnings due to improper casts
      spi: rcar: Fix uninitialized variable warning
      spi: rcar: Fix pointer cast in the remove function
      spi: rcar: Use devm_* managed allocators
      spi: sh-msiof: Enable driver compilation with COMPILE_TEST
      spi: sh-msiof: Use devm_* managed allocators
      spi: sh-msiof: Convert to clk_prepare/unprepare

Marek Vasut (1):
      spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds

Mark Brown (18):
      spi: Factor validation and initialisation of messages outside lock
      spi: omap2: Add build dependencies for writel_relaxed()
      Merge remote-tracking branch 'spi/fix/rspi' into spi-rcar
      Merge tag 'v3.13-rc2' into spi-rcar
      Merge tag 's3c64xx-dmaengine' of git://git.kernel.org/.../broonie/misc into spi-s3c64xx
      Merge tag 'v3.13-rc6' into spi-rcar
      Merge tag 'v3.13-rc6' into spi-dw
      spi: Use bitfields for multiple data lines
      Merge branch 'topic/rcar' of git://git.kernel.org/.../broonie/spi into spi-rspi
      Merge branches 'topic/sc18is602' and 'topic/rspi' of git://git.kernel.org/.../broonie/spi into spi-bpw
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/bcm63xx', 'spi/fix/dspi', 'spi/fix/hspi', 'spi/fix/imx', 'spi/fix/msiof', 'spi/fix/pxa2xx', 'spi/fix/qspi', 'spi/topic/altera', 'spi/topic/ath79' and 'spi/topic/atmel' into spi-linus
      Merge remote-tracking branches 'spi/topic/bcm2835', 'spi/topic/bcm63xx', 'spi/topic/bcm63xx-hsspi', 'spi/topic/bitbang', 'spi/topic/bpw', 'spi/topic/clps711x', 'spi/topic/coldfire', 'spi/topic/davinci', 'spi/topic/dw' and 'spi/topic/falcon' into spi-linus
      Merge remote-tracking branches 'spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/topic/hspi', 'spi/topic/mpc512x', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/oc-tiny', 'spi/topic/omap', 'spi/topic/orion' and 'spi/topic/pci' into spi-linus
      Merge remote-tracking branches 'spi/topic/pxa2xx', 'spi/topic/qspi', 'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sh', 'spi/topic/tegra114', 'spi/topic/tegra20-sflash', 'spi/topic/tegra20-slink', 'spi/topic/txx9' and 'spi/topic/xcomm' into spi-linus
      Merge commit 'spi/fix/rcar' into spi-linus
      Merge commit 'spi/topic/sc18is602' into spi-linus

Michal Nazarewicz (4):
      spi: omap-100k: remove pointless _remove function
      spi: tegra114: use u32 for 32-bit register values
      spi: tegra20-slink: use u32 for 32-bit register values
      spi: tegra20-sflash: use u32 for 32-bit register values

Mika Westerberg (3):
      spi: Check conflicting CS based on spi->chip_select instead of device name
      spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match
      spi/pxa2xx: fix compilation warning when !CONFIG_PM_SLEEP

Richard Genoud (1):
      spi: atmel: add support for changing message transfer speed

Sachin Kamat (2):
      spi: nuc900: Cleanup spi-nuc900.h header
      spi: s3c24xx: Remove reference to plat/fiq.h

Santosh Shilimkar (1):
      spi: davinci: Fix the build warning with CONFIG_ARM_LPAE=y

Sekhar Nori (1):
      spi/davinci: Don't select EDMA

Sourav Poddar (3):
      spi/qspi: parse register by name.
      spi/qspi: update binding information
      spi/qspi: Fix runtime resume path

Takashi Yoshii (2):
      spi: spi-sh-msiof: round up div to fix freq calculation
      spi: spi-sh-msiof: set hi/low Active for HW CS

Trent Piepho (2):
      spi: Order fields in spi_device for better packing
      spi: Eliminate 3WIRE spi_transfer check

Victor Kamensky (1):
      spi: omap2-mcspi: raw read and write endian fix

Wei Yongjun (6):
      spi: coldfire-qspi: remove redundant return value check of platform_get_resource()
      spi: bcm63xx: fix reference leak to master in bcm63xx_spi_remove()
      spi: spi-s3c24xx: remove redundant return value check of platform_get_resource()
      spi: txx9: drop clk_put for devm_clk_get in txx9spi_probe()
      spi: nuc900: remove redundant return value check of platform_get_resource()
      spi: dw-pci: remove free for resources allocated with devm_*

Wenyou Yang (1):
      spi: atmel: Refactor spi-atmel to use SPI framework queue

 Documentation/devicetree/bindings/spi/spi-bus.txt |   2 +-
 Documentation/devicetree/bindings/spi/ti_qspi.txt |   8 +-
 Documentation/spi/spi-summary                     |   8 +-
 arch/arm/Kconfig                                  |   1 +
 arch/arm/mach-s3c64xx/Kconfig                     |   7 +-
 arch/arm/mach-s3c64xx/Makefile                    |   2 +-
 arch/arm/mach-s3c64xx/common.h                    |   5 +
 arch/arm/mach-s3c64xx/dma.c                       | 762 ---------------------
 arch/arm/mach-s3c64xx/include/mach/dma.h          | 144 ++--
 arch/arm/mach-s3c64xx/pl080.c                     | 244 +++++++
 arch/arm/plat-samsung/devs.c                      |  10 +-
 arch/arm/plat-samsung/dma-ops.c                   |   8 +-
 arch/arm/plat-samsung/include/plat/fiq.h          |  13 -
 drivers/clk/samsung/clk-s3c64xx.c                 |   4 +-
 drivers/spi/Kconfig                               |  16 +-
 drivers/spi/Makefile                              |   1 +
 drivers/spi/spi-altera.c                          |   2 -
 drivers/spi/spi-ath79.c                           |  14 +-
 drivers/spi/spi-atmel.c                           | 778 ++++++++--------------
 drivers/spi/spi-bcm2835.c                         |  10 +-
 drivers/spi/spi-bcm63xx-hsspi.c                   | 475 +++++++++++++
 drivers/spi/spi-bcm63xx.c                         |  48 +-
 drivers/spi/spi-bitbang-txrx.h                    |   2 +-
 drivers/spi/spi-clps711x.c                        |  23 +-
 drivers/spi/spi-coldfire-qspi.c                   |  53 +-
 drivers/spi/spi-davinci.c                         |  49 +-
 drivers/spi/spi-dw-mmio.c                         |  74 +-
 drivers/spi/spi-dw-pci.c                          |  47 +-
 drivers/spi/spi-dw.c                              |  26 +-
 drivers/spi/spi-dw.h                              |   5 +-
 drivers/spi/spi-falcon.c                          |  12 +-
 drivers/spi/spi-fsl-dspi.c                        |   5 +-
 drivers/spi/spi-fsl-espi.c                        |  63 +-
 drivers/spi/spi-gpio.c                            |   8 +-
 drivers/spi/spi-imx.c                             |  27 +-
 drivers/spi/spi-mpc512x-psc.c                     |  18 +-
 drivers/spi/spi-mxs.c                             |   9 -
 drivers/spi/spi-nuc900.c                          |  56 +-
 drivers/spi/spi-oc-tiny.c                         |  62 +-
 drivers/spi/spi-omap-100k.c                       |  20 -
 drivers/spi/spi-omap2-mcspi.c                     |  38 +-
 drivers/spi/spi-orion.c                           |   4 +-
 drivers/spi/spi-pxa2xx-pci.c                      |   2 +-
 drivers/spi/spi-pxa2xx.c                          |   4 +-
 drivers/spi/spi-rspi.c                            | 363 +++++-----
 drivers/spi/spi-s3c24xx.c                         |  74 +-
 drivers/spi/spi-s3c64xx.c                         |   5 +-
 drivers/spi/spi-sc18is602.c                       |  24 +-
 drivers/spi/spi-sh-hspi.c                         |   4 +-
 drivers/spi/spi-sh-msiof.c                        |  62 +-
 drivers/spi/spi-sh.c                              |  13 +-
 drivers/spi/spi-sirf.c                            |   7 -
 drivers/spi/spi-tegra114.c                        |  98 +--
 drivers/spi/spi-tegra20-sflash.c                  |  22 +-
 drivers/spi/spi-tegra20-slink.c                   |  97 ++-
 drivers/spi/spi-ti-qspi.c                         | 129 ++--
 drivers/spi/spi-topcliff-pch.c                    |   8 +-
 drivers/spi/spi-txx9.c                            |   8 +-
 drivers/spi/spi-xcomm.c                           |  12 +-
 drivers/spi/spi.c                                 |  74 +-
 include/linux/platform_data/spi-nuc900.h          |   8 +-
 include/linux/spi/s3c24xx.h                       |   2 +
 include/linux/spi/spi.h                           |  20 +-
 63 files changed, 1806 insertions(+), 2393 deletions(-)
 delete mode 100644 arch/arm/mach-s3c64xx/dma.c
 create mode 100644 arch/arm/mach-s3c64xx/pl080.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/fiq.h
 create mode 100644 drivers/spi/spi-bcm63xx-hsspi.c

--GMOLFvf9RD8hOD5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4RbkAAoJELSic+t+oim9CdsP/RFHDi0CpvMW8U8AYtHXijWK
bOQSCNO4SC5MmP5t353lngtFjEVzAftlmTkwI3llBSaPMhJkD9jFYssZjlVwrXIp
Ki+k4XLJPAjpG/NEKtJuHPqvJJ6Ihz2YlB9CUXfWJlofDHNQK4qvfE2HX0Tiga2u
MWS4x0jFCifEId1B4TZj6V9jxZfDGx/T4AemvKSGcdPVq+VakIqXWyWtTqltlcek
xB6QSy47yIEUyu8/eJ4dzX1mdo3wKd54JRxW/OxMLg1TE9s8cPUcpkDaLYoNZsDi
oGf9RG9Hfq1DS3PrdlPu24VJ5H+I+GOQb+Bsf6aAjWUw5Hudn3VHk4OzrlPXcqnz
nHoIRbycJ04IuqOPLOlw6kZwaeUsOyI4xOWsJoIbrq05H/mltdekv7h/k12t7AQ6
xPH3FKHLGbpKh5r+7gDJeAP20cGLPJH/taM2GH0qFgM/jB/3Q8G5AAY1nbA2LZLW
r5dLYRTT+hU7XWQsXtB3toaiLWusMFDZE9iv3yxwBReEm0pZ8kPz/uHuGVMHJdlq
iT67TFd3YkQaWkqirbdUZJBYtsqXJona6TQlvPvWNshFu68+ZYmVFq+Tnmlb0tZN
VywoRvB31YiGHVuUUqol8qacbuHfOqXk2a7OP2k7tRrACOROcMdfZ3w9CUDSXjwQ
Sad1HUIWylMftHjGHh2T
=OWNH
-----END PGP SIGNATURE-----

--GMOLFvf9RD8hOD5r--
