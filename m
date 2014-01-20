Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaATP7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:59:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57174 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:59:41 -0500
Date: Mon, 20 Jan 2014 15:59:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140120155936.GR17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4CyH/NlNBqvsUTYP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4CyH/NlNBqvsUTYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E14

for you to fetch changes up to ae49d4c5d6e9a46c1fe63fcd58e1069fa8a59aa9:

  Merge remote-tracking branches 'spi/topic/altera', 'spi/topic/ath79', 'sp=
i/topic/atmel', 'spi/topic/bcm2835', 'spi/topic/bcm63xx', 'spi/topic/bcm63x=
x-hsspi', 'spi/topic/bitbang', 'spi/topic/bpw', 'spi/topic/clps711x', 'spi/=
topic/coldfire', 'spi/topic/davinci', 'spi/topic/dw', 'spi/topic/falcon', '=
spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/topic/hspi', 'spi/topic/mpc512x=
', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/oc-tiny', 'spi/topic/o=
map', 'spi/topic/orion', 'spi/topic/pci', 'spi/topic/pxa2xx', 'spi/topic/qs=
pi', 'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sc18is602', 'spi/=
topic/sh', 'spi/topic/tegra114', 'spi/topic/tegra20-sflash', 'spi/topic/teg=
ra20-slink', 'spi/topic/txx9' and 'spi/topic/xcomm' into spi-next (2014-01-=
17 18:58:01 +0000)

----------------------------------------------------------------

spi: Updates for v3.14

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

Axel Lin (14):
      spi: core: Use list_first_entry_or_null() instead of open-coded
      spi: s3c64xx: Remove duplicate code to clear S3C64XX_SPI_SLAVE_SEL re=
gister
      spi: ti-qspi: Fix getting correct address for qspi
      spi: sh-hspi: Fix modalias for sh-hspi
      spi: core: Use list_first_entry to extract head of queue
      spi: fsl-dspi: Add missing breaks for switch cases
      spi: oc-tiny: Simplify tiny_spi_txrx_bufs implementation when irq is =
not used
      spi: altera: Remove unneeded NULL checking for hw->bitbang.master
      spi: ti-qspi: Simplify qspi_write_msg and qspi_read_msg implementation
      spi: ti-qspi: Fixup driver name
      spi: sh: Use spi_sh_clear_bit() instead of open-coded
      spi: clps711x: Add MODULE_ALIAS to support module auto-loading
      spi: Remove duplicate code to set default bits_per_word setting
      spi: sc18is602: Convert to use bits_per_word_mask

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

Geert Uytterhoeven (18):
      spi: rspi: Fix NULL pointer dereference on SH7757
      spi: rspi: Fix typo when clearing SPSR_OVRF
      spi: rspi: Use dev_get_platdata() instead of raw dev.platform_data ac=
cess
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
      spi/bcm63xx: don't reject reads >=3D 256 bytes
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

Mark Brown (14):
      spi: Factor validation and initialisation of messages outside lock
      spi: omap2: Add build dependencies for writel_relaxed()
      Merge remote-tracking branch 'spi/fix/rspi' into spi-rcar
      Merge tag 'v3.13-rc2' into spi-rcar
      Merge tag 's3c64xx-dmaengine' of git://git.kernel.org/.../broonie/mis=
c into spi-s3c64xx
      Merge tag 'v3.13-rc6' into spi-rcar
      Merge tag 'v3.13-rc6' into spi-dw
      spi: Use bitfields for multiple data lines
      Merge branch 'topic/rcar' of git://git.kernel.org/.../broonie/spi int=
o spi-rspi
      Merge branches 'topic/sc18is602' and 'topic/rspi' of git://git.kernel=
=2Eorg/.../broonie/spi into spi-bpw
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/bcm63xx', 'spi/fix/dspi', 'sp=
i/fix/hspi', 'spi/fix/imx', 'spi/fix/msiof', 'spi/fix/pxa2xx', 'spi/fix/qsp=
i' and 'spi/fix/rspi' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branches 'spi/topic/altera', 'spi/topic/ath79',=
 'spi/topic/atmel', 'spi/topic/bcm2835', 'spi/topic/bcm63xx', 'spi/topic/bc=
m63xx-hsspi', 'spi/topic/bitbang', 'spi/topic/bpw', 'spi/topic/clps711x', '=
spi/topic/coldfire', 'spi/topic/davinci', 'spi/topic/dw', 'spi/topic/falcon=
', 'spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/topic/hspi', 'spi/topic/mpc=
512x', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/oc-tiny', 'spi/top=
ic/omap', 'spi/topic/orion', 'spi/topic/pci', 'spi/topic/pxa2xx', 'spi/topi=
c/qspi', 'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sc18is602', '=
spi/topic/sh', 'spi/topic/tegra114', 'spi/topic/tegra20-sflash', 'spi/topic=
/tegra20-slink', 'spi/topic/txx9' and 'spi/topic/xcomm' into spi-next

Michal Nazarewicz (4):
      spi: omap-100k: remove pointless _remove function
      spi: tegra114: use u32 for 32-bit register values
      spi: tegra20-slink: use u32 for 32-bit register values
      spi: tegra20-sflash: use u32 for 32-bit register values

Mika Westerberg (3):
      spi: Check conflicting CS based on spi->chip_select instead of device=
 name
      spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match
      spi/pxa2xx: fix compilation warning when !CONFIG_PM_SLEEP

Richard Genoud (1):
      spi: atmel: add support for changing message transfer speed

Sachin Kamat (2):
      spi: nuc900: Cleanup spi-nuc900.h header
      spi: s3c24xx: Remove reference to plat/fiq.h

Santosh Shilimkar (1):
      spi: davinci: Fix the build warning with CONFIG_ARM_LPAE=3Dy

Sekhar Nori (1):
      spi/davinci: Don't select EDMA

Sourav Poddar (3):
      spi/qspi: parse register by name.
      spi/qspi: update binding information
      spi/qspi: Fix runtime resume path

Takashi Yoshii (2):
      spi: spi-sh-msiof: round up div to fix freq calculation
      spi: spi-sh-msiof: set hi/low Active for HW CS

Tomasz Figa (6):
      spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
      ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver
      clk: samsung: s3c64xx: Add aliases for DMA clocks
      ARM: s3c64xx: Remove legacy DMA driver
      clk: samsung: s3c64xx: Remove clock aliases of old DMA driver
      spi: s3c64xx: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled

Trent Piepho (2):
      spi: Order fields in spi_device for better packing
      spi: Eliminate 3WIRE spi_transfer check

Victor Kamensky (1):
      spi: omap2-mcspi: raw read and write endian fix

Wei Yongjun (6):
      spi: coldfire-qspi: remove redundant return value check of platform_g=
et_resource()
      spi: bcm63xx: fix reference leak to master in bcm63xx_spi_remove()
      spi: spi-s3c24xx: remove redundant return value check of platform_get=
_resource()
      spi: txx9: drop clk_put for devm_clk_get in txx9spi_probe()
      spi: nuc900: remove redundant return value check of platform_get_reso=
urce()
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
 arch/arm/mach-s3c64xx/dma.c                       | 762 ------------------=
---
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
 drivers/spi/spi-atmel.c                           | 778 ++++++++----------=
----
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
 drivers/spi/spi.c                                 |  68 +-
 include/linux/platform_data/spi-nuc900.h          |   8 +-
 include/linux/spi/s3c24xx.h                       |   2 +
 include/linux/spi/spi.h                           |   8 +-
 63 files changed, 1795 insertions(+), 2386 deletions(-)
 delete mode 100644 arch/arm/mach-s3c64xx/dma.c
 create mode 100644 arch/arm/mach-s3c64xx/pl080.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/fiq.h
 create mode 100644 drivers/spi/spi-bcm63xx-hsspi.c
Reply-To:=20
X-Cookie: We have DIFFERENT amounts of HAIR --
Fcc: +sent-mail


--4CyH/NlNBqvsUTYP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3UflAAoJELSic+t+oim9ylgP/0eNw2wrajjzg3IkLju9dpJ8
3QQ3Mc+KEdGGmuNEloMa/jkh7j8gI1j9BUBOr6MJiZQhXSfILRv1qz87RZ+yxHr3
8WyCAI/tUxw9bU7Y6BqD7eoc6fqbusQvSrWuU14zxpNaDbbNn2flF9TjZbTUmfTM
ZSTtUODFQPLIEC9IRMWaHSu9Y8+2GeAL6cTKYsSjd0oKE5T4bWsxXyDYKU/Wb8iQ
0E5xZpXg1I2+wThVAFRvZBNKS3RBLiN385cXxpL2Kqdo6sPFw4MOuSKOhBCnOvJm
nuroOUF00TO1ZHpFRuLmcO62yL6Q5HFDnj41kiQwBQlgFynDWPboZdYOzv20VpiO
xRbEIykNoKFmdZKjasTSyLhMCZ06NrxNZgz8/qjFgN+9t43wVvYw0Oq5mbJR97WF
KYEa/8b0cVTXuFJuXSlJ/Esqg1+IP9kiKDs8tJts78RGaGQCEkYyxdWD4bN48z3u
p6DvcYohA5uTyRDXSRf+9BFd1C1qDx04aK8dZdAo/KhvzwXKjbZDZrXC+JAzL1X2
EEbQxXxKRvG7Tcr8oyP21YbfI77YhAW32w82MUdAzs5zPINe5lUAGnqSagNLb7iA
2YVYqwYZ4wBkdMPHrg+u1x4B62QKSPZVer1f8+UYMofITV3KulNJQGM6B61n8uFm
W8VmYvKSJynW+T+bX9gN
=VtMS
-----END PGP SIGNATURE-----

--4CyH/NlNBqvsUTYP--
