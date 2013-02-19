Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab3BSNPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:15:00 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36827 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3BSNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:14:59 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Feb 2013 13:14:37 +0000
X-Google-Sender-Auth: 2lbSRp_Z2Z5bxL1ibH0FGc8PlJI
Message-ID: <CACxGe6vpVCW-wyAZRga7aCkccXWPJM1tER3VTg9hS4pfG22_SQ@mail.gmail.com>
Subject: [GIT PULL] SPI for v3.9
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/spi-for-linus

for you to fetch changes up to 095c3752e673c0ba039a2f67fd867297fde75ae7:

  spi: Document cs_gpios and cs_gpio in kernel-doc (2013-02-11 00:05:31 +0000)

----------------------------------------------------------------
SPI changes for v3.9

Changes to both core spi code and spi device drivers. The driver
changes are the usual set of bug fixes and platform enablement. Core
code changes include:
- More intelligent assignment of SPI bus numbers when using DT
- Fixes to initialization and documentation of chipselect gpio array.
- Pull checks for bits_per_word and transfer speed out of drivers and
  into core code
- Ensure temporary DMA buffers are DMA safe

----------------------------------------------------------------
Anatolij Gustschin (2):
      spi/mpc512x-psc: don't use obsolet cell-index property
      spi/spi-mpc512x-psc: init mode bits supported by the driver

Andreas Larsson (2):
      spi/of: Fix initialization of cs_gpios array
      spi: Document cs_gpios and cs_gpio in kernel-doc

Barry Song (2):
      spi/sirf: use clk_prepare_enable and clk_disable_unprepare
      spi/sirf: add support for new SiRFmarco SMP SoC

Bastian Hecht (1):
      spi/sh-msiof: Add device tree parsing to driver

Ezequiel Garcia (1):
      spi/orion: Use module_platform_driver()

Fabio Estevam (1):
      spi/imx: Add MODULE_ALIAS()

Felipe Balbi (1):
      spi/omap2: disable DMA requests before complete()

Gabor Juhos (6):
      spi/ath79: add delay between SCK changes
      spi/ath79: add missing HIGH->LOW SCK transition
      spi/ath79: remove superfluous chip select code
      spi/ath79: use gpio_request_one
      spi/ath79: avoid multiple initialization of the SPI controller
      spi/ath79: add shutdown handler

Grant Likely (4):
      spi/of: Use DT aliases for assigning bus number
      Merge branch 'broonie/spi-next' of
git://git.kernel.org/.../broonie/misc.git
      spi: Remove erroneous __init, __exit and __exit_p() references in drivers
      Merge branch spi-next from git://git.kernel.org/.../broonie/misc.git

Guennadi Liakhovetski (1):
      spi: bitbang: simplify pointer arithmetics

Jingoo Han (2):
      spi/s3c64xx: Use devm_clk_get() and devm_request_irq()
      spi/s3c64xx: fix checkpatch warnings and error

John Crispin (2):
      spi/mips-lantiq: make use of spi_finalize_current_message
      spi/mips-lantiq: set SPI_MASTER_HALF_DUPLEX flag

Jonas Gorski (2):
      spi/bcm63xx: reject transfers unable to transfer
      spi/bcm63xx: work around inability to keep CS up

Juha Lumme (1):
      mxs/spi: clear XFER_COUNT in ctrl0 field in DMA descriptor

Laxman Dewangan (3):
      spi: remove check for bits_per_word on transfer from low level driver
      spi: make sure all transfer has proper speed set
      spi/tegra: remove checks for valid speed

Mark Brown (3):
      spi/s3c64xx: Complain if we fail to set a transfer speed
      MAINTAINERS: Add myself as a backup maintainer for SPI
      spi: Ensure memory used for spi_write_then_read() is DMA safe

Matthias Brugger (2):
      spi: spi-omap2-mcspi.c: fix coding style
      spi: spi-omap2-mcspi.c: Toggle CS after each word

Maxime Ripard (2):
      spi: spi-gpio: Add checks for the dt properties
      spi: spi-gpio: fix compilation warning on 64 bits systems

Mika Westerberg (12):
      spi/pxa2xx-pci: switch to use pcim_* interfaces
      spi/pxa2xx: embed the ssp_device to platform data
      spi/pxa2xx: allow building on a 64-bit kernel
      spi/pxa2xx: fix warnings when compiling a 64-bit kernel
      spi/pxa2xx: convert to the pump message infrastructure
      spi/pxa2xx: convert to the common clk framework
      spi/pxa2xx: break out the private DMA API usage into a separate file
      spi/pxa2xx: add support for DMA engine
      spi/pxa2xx: add support for runtime PM
      spi/pxa2xx: add support for SPI_LOOP
      spi/pxa2xx: add support for Intel Low Power Subsystem SPI
      spi/pxa2xx: add support for Lynxpoint SPI controllers

Murali Karicheri (2):
      spi/davinci: add OF support for the spi controller
      spi/davinci: use request_threaded_irq() to fix deadlock

 Documentation/devicetree/bindings/spi/sh-msiof.txt |   12 +
 MAINTAINERS                                        |    1 +
 drivers/spi/Kconfig                                |   15 +-
 drivers/spi/Makefile                               |    5 +-
 drivers/spi/spi-altera.c                           |    2 +-
 drivers/spi/spi-ath79.c                            |  115 +-
 drivers/spi/spi-atmel.c                            |    2 +-
 drivers/spi/spi-au1550.c                           |    8 +-
 drivers/spi/spi-bcm63xx.c                          |  179 +++-
 drivers/spi/spi-bfin-sport.c                       |    3 +-
 drivers/spi/spi-bfin5xx.c                          |    5 +-
 drivers/spi/spi-bitbang.c                          |   33 +-
 drivers/spi/spi-clps711x.c                         |    2 +-
 drivers/spi/spi-coldfire-qspi.c                    |    3 +-
 drivers/spi/spi-davinci.c                          |  119 ++-
 drivers/spi/spi-ep93xx.c                           |    2 +-
 drivers/spi/spi-falcon.c                           |    3 +-
 drivers/spi/spi-gpio.c                             |   23 +-
 drivers/spi/spi-imx.c                              |    1 +
 drivers/spi/spi-mpc512x-psc.c                      |   17 +-
 drivers/spi/spi-mxs.c                              |    5 +-
 drivers/spi/spi-omap-100k.c                        |    6 +-
 drivers/spi/spi-omap-uwire.c                       |    6 +-
 drivers/spi/spi-omap2-mcspi.c                      |   42 +-
 drivers/spi/spi-orion.c                            |   21 +-
 drivers/spi/spi-ppc4xx.c                           |    6 +-
 drivers/spi/spi-pxa2xx-dma.c                       |  392 +++++++
 drivers/spi/spi-pxa2xx-pci.c                       |  133 +--
 drivers/spi/spi-pxa2xx-pxadma.c                    |  490 +++++++++
 drivers/spi/spi-pxa2xx.c                           | 1103 ++++++--------------
 drivers/spi/spi-pxa2xx.h                           |  221 ++++
 drivers/spi/spi-s3c64xx.c                          |   80 +-
 drivers/spi/spi-sh-msiof.c                         |   56 +-
 drivers/spi/spi-sirf.c                             |   10 +-
 drivers/spi/spi-tegra20-sflash.c                   |   14 +-
 drivers/spi/spi-tegra20-slink.c                    |   15 +-
 drivers/spi/spi-txx9.c                             |   12 +-
 drivers/spi/spi.c                                  |   15 +-
 include/linux/platform_data/spi-omap2-mcspi.h      |    3 +
 include/linux/pxa2xx_ssp.h                         |   18 +
 include/linux/spi/pxa2xx_spi.h                     |  108 +-
 include/linux/spi/spi.h                            |    5 +
 include/linux/spi/spi_gpio.h                       |    4 +-
 43 files changed, 2078 insertions(+), 1237 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/sh-msiof.txt
 create mode 100644 drivers/spi/spi-pxa2xx-dma.c
 create mode 100644 drivers/spi/spi-pxa2xx-pxadma.c
 create mode 100644 drivers/spi/spi-pxa2xx.h


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
