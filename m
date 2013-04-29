Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3D2ULu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:11:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45221 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3D2ULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:11:48 -0400
Date: Mon, 29 Apr 2013 21:11:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant@secretlab.ca>
Message-ID: <20130429201142.GG3270@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iJXiJc/TAIT2rh2r"
Content-Disposition: inline
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iJXiJc/TAIT2rh2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1ad849aee5f53353ed88d9cd3d68a51b03a7d44f:

  spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts (2013-04-01 14:30:26 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.10

for you to fetch changes up to cd8d984f0def2a8c5733a9468634ec3e0feec03d:

  spi-topcliff-pch: fix to use list_for_each_entry_safe() when delete list items (2013-04-28 02:18:13 +0100)

----------------------------------------------------------------
spi: Updates for v3.10

A fairly quiet release for SPI, mainly driver work.  A few highlights:

- Supports bits per word compatibility checking in the core.
- Allow use of the IP used in Freescale SPI controllers outside
  Freescale SoCs.
- DMA support for the Atmel SPI driver.
- New drivers for the BCM2835 and Tegra114.

----------------------------------------------------------------
Alexandru Gheorghiu (2):
      spi/fsl: Use PTR_RET function
      spi/spidev: Use PTR_RET function

Anatolij Gustschin (2):
      spi: spi-mpc512x-psc: add support for gpio chip selects
      spi: spi-mpc512x-psc: let transmiter/receiver enabled when in xfer loop

Andreas Larsson (7):
      spi/spi-fsl-spi: Make driver usable in CPU mode outside of an FSL_SOC environment
      spi/spi-fsl-spi: Make sure in spi_fsl_setup that chipselect becomes inactive
      spi/spi-fsl-spi: Move setting non-zero tx and rx shifts to a function accessed by a function pointer
      spi/spi-fsl-spi: Introduce a type for the driver
      spi/spi-fsl-spi: Add support for setting a maximum number of bits per word
      spi/spi-fsl-spi: Add support for Aeroflex Gaisler GRLIB cores normally running on SPARC
      spi/spi-fsl-spi: Add support for gpio chipselects for GRLIB type cores

Arnd Bergmann (2):
      spi: s3c64xx: move to generic dmaengine API
      spi/sirf: fix MODULE_DEVICE_TABLE

Chris Boot (1):
      spi: add driver for BCM2835

Grant Likely (1):
      MAINTAINERS: Update Grant's email address and maintainership

Jingoo Han (1):
      spi/s3c64xx: add CONFIG_PM_SLEEP to suspend/resume functions

Jonas Gorski (11):
      spi/bcm63xx: properly prepare clocks before enabling them
      spi/bcm63xx: remove duplicated mode bits check
      spi/bcm63xx: remove unneeded debug message
      spi/bcm63xx: remove unused variable bs from bcm63xx_spi_setup
      spi/bcm63xx: check spi bits_per_word in spi_setup
      spi/bcm63xx: simplify bcm63xx_spi_check_transfer
      spi/bcm63xx: remove spi chip select validity check
      spi/bcm63xx: inline bcm63xx_spi_check_transfer
      spi/bcm63xx: inline hz usage in bcm63xx_spi_setup_transfer
      spi/bcm63xx: use devm_ioremap_resource()
      spi/bcm63xx: remove unused speed_hz variable

Josef Ahmad (1):
      spi-gpio: init CS before spi_bitbang_setup()

Laxman Dewangan (2):
      spi: tegra: slink: do not prepare dma transfer with DMA_CTRL_ACK flag
      spi/tegra114: add spi driver

Mark Brown (7):
      Merge branch 'spi-fix' into spi-next
      spi/s3c64xx: Convert to bits_per_word_mask
      Merge branch 'spi-fix' into spi-next
      spi: tegra: slink: do prepare dma transfer with DMA_CTRL_ACK flag
      spi/s3c64xx: Fix non-dmaengine usage
      spi/s3c64xx: Check for errors in dmaengine prepare_transfer()
      MAINTAINERS: Add git repository and update my address

Matthias Brugger (1):
      spi: spi-s3c64xx.c Remove unused argument.

Mika Westerberg (2):
      spi/pxa2xx-pci: correct the return value check of pcim_iomap_regions()
      spi/pxa2xx: enable multiblock DMA transfers for LPSS devices

Nicolas Ferre (5):
      spi/spi-atmel: call unmapping on transfers buffers
      spi/spi-atmel: status information passed through controller data
      spi/spi-atmel: add physical base address
      spi/spi-atmel: add flag to controller data for lock operations
      spi/spi-atmel: add dmaengine support

Richard Genoud (3):
      ARM: at91: add clocks for spi dt entries
      ARM: dts: add spi nodes for atmel SoC
      ARM: dts: add spi nodes for the atmel boards

Sachin Kamat (3):
      spi: spi-oc-tiny: Use of_match_ptr() macro
      spi: spi-sh-msiof: Use of_match_ptr() macro
      spi/pxa2xx: Convert to devm_ioremap_resource()

Sebastian Andrzej Siewior (1):
      spi/omap-mcspi: check condition also after timeout

Stephen Warren (6):
      spi: add ability to validate xfer->bits_per_word in SPI core
      spi: bcm2835: make use of new bits_per_word_mask core feature
      spi/tegra-slink: remove redundant code
      spi/tegra-sflash: assume CONFIG_OF, remove platform data
      spi/tegra-slink: assume CONFIG_OF, remove platform data
      spi/tegra: remove unused Tegra platform data header

Thomas Abraham (1):
      spi/s3c64xx: let device core setup the default pin configuration

Tony Lindgren (1):
      spi: omap2-mcspi: Fix transfers if DMADEVICES is not set

Wei Yongjun (7):
      spi: fix return value check in ce4100_spi_probe()
      spi: remove unused variable in tegra_slink_read_rx_fifo_to_client_rxbuf()
      mxs/spi: fix error return code in mxs_spi_probe()
      spi: tegra: slink: make local symbols static
      spi: omap2-mcspi: fix error return code in omap2_mcspi_probe()
      spi-topcliff-pch: missing platform_driver_unregister() on error in pch_spi_init()
      spi-topcliff-pch: fix to use list_for_each_entry_safe() when delete list items

Wenyou Yang (3):
      spi/spi-atmel: detect the capabilities of SPI core by reading the VERSION register.
      spi/spi-atmel: add support transfer on CS1,2,3, not only on CS0
      ARM: dts: add pinctrl property for spi node for atmel SoC

 .../devicetree/bindings/spi/brcm,bcm2835-spi.txt   |   22 +
 Documentation/devicetree/bindings/spi/fsl-spi.txt  |    3 +-
 .../bindings/spi/nvidia,tegra114-spi.txt           |   26 +
 .../devicetree/bindings/spi/spi-samsung.txt        |    8 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 MAINTAINERS                                        |   21 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |   40 +
 arch/arm/boot/dts/at91sam9263.dtsi                 |   40 +
 arch/arm/boot/dts/at91sam9263ek.dts                |   10 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   10 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   40 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   10 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   40 +
 arch/arm/boot/dts/at91sam9n12ek.dts                |   10 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   40 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   10 +
 arch/arm/mach-at91/at91sam9260.c                   |    2 +
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9n12.c                   |    2 +
 arch/arm/mach-at91/at91sam9x5.c                    |    2 +
 arch/arm/plat-samsung/devs.c                       |   10 +
 arch/mips/bcm63xx/dev-spi.c                        |   11 -
 .../include/asm/mach-bcm63xx/bcm63xx_dev_spi.h     |    1 -
 drivers/spi/Kconfig                                |   30 +-
 drivers/spi/Makefile                               |    3 +
 drivers/spi/spi-atmel.c                            |  728 ++++++++++--
 drivers/spi/spi-bcm2835.c                          |  422 +++++++
 drivers/spi/spi-bcm63xx.c                          |   78 +-
 drivers/spi/spi-fsl-cpm.c                          |  387 ++++++
 drivers/spi/spi-fsl-cpm.h                          |   43 +
 drivers/spi/spi-fsl-lib.c                          |    8 +
 drivers/spi/spi-fsl-lib.h                          |   15 +-
 drivers/spi/spi-fsl-spi.c                          |  601 +++-------
 drivers/spi/spi-fsl-spi.h                          |   72 ++
 drivers/spi/spi-gpio.c                             |    2 +-
 drivers/spi/spi-mpc512x-psc.c                      |   41 +-
 drivers/spi/spi-mxs.c                              |    1 +
 drivers/spi/spi-oc-tiny.c                          |    4 +-
 drivers/spi/spi-omap2-mcspi.c                      |   43 +-
 drivers/spi/spi-pxa2xx-pci.c                       |    6 +-
 drivers/spi/spi-pxa2xx.c                           |   14 +-
 drivers/spi/spi-s3c64xx.c                          |  292 +++--
 drivers/spi/spi-sh-msiof.c                         |    4 +-
 drivers/spi/spi-sirf.c                             |    2 +-
 drivers/spi/spi-tegra114.c                         | 1246 ++++++++++++++++++++
 drivers/spi/spi-tegra20-sflash.c                   |   41 +-
 drivers/spi/spi-tegra20-slink.c                    |   84 +-
 drivers/spi/spi-topcliff-pch.c                     |   16 +-
 drivers/spi/spi.c                                  |    8 +
 drivers/spi/spidev.c                               |    2 +-
 include/linux/platform_data/spi-s3c64xx.h          |    3 +
 include/linux/spi/spi-tegra.h                      |   40 -
 include/linux/spi/spi.h                            |    8 +
 53 files changed, 3712 insertions(+), 893 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/brcm,bcm2835-spi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/nvidia,tegra114-spi.txt
 create mode 100644 drivers/spi/spi-bcm2835.c
 create mode 100644 drivers/spi/spi-fsl-cpm.c
 create mode 100644 drivers/spi/spi-fsl-cpm.h
 create mode 100644 drivers/spi/spi-fsl-spi.h
 create mode 100644 drivers/spi/spi-tegra114.c
 delete mode 100644 include/linux/spi/spi-tegra.h

--iJXiJc/TAIT2rh2r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRftP7AAoJELSic+t+oim9gRQP/jxzkR/qKvMw0qaCW1afsjoP
rqNYmDfSyBkbVL5Htiuf2fc1zqTYH9Umlb+2+xNp5eJOIhMztUv0JfUxBg0hmMUg
woTpvU5g+lj7JxgaUqQl4FFYE2i2IDVRdc7WCvGtXyaDzNb/t1+Zv1y57J8hsdru
8incS3wldPxE3tZWgurAtUDvB5R5jgrzrImcb9gqq0R8aZlN+WZ6rEyAKS841gsp
cE1Qe/0/iOXadNZUCK6pfhDYDdOvJNqnk73vAaIhJjTD2q9hS095X4xGo9jxccD9
8IuAzfJat8zdHDwCskxrDsG6A75PnaEPUA+wIPnhH2wqhsUHZlJp6Q9GNWcjJr58
ETHgDp3aSGqf+PwhUUMiRo691yopK3D4TRdc+cuHdxa7i6/UsLeithUSJ46meAEA
k1OOKE4MuiH+U0u5kiP2CB/NzMOjTAGrVur+NHoLRAAqJuDvzrLf8dAoL8UFrW3I
Tt5Ritp2qsRuIjL9z+BI5x4M+TnbKcOKXDYCmeqDXGTt/t+8T95cK/usNN0V+05t
TZA+lP8f9KH5zT0p0suVhUQqAiR8DaWeZh6j1X99qi+cZBIdoksp+neXKkB2pqWf
Cq0/I4/At/WQkIqfkXWo3GKkcTUcTDsUlVpOhb4Zu5+9Pur2XpqOBT3J8ipcV3LX
983g522uC4cApRq6QsS7
=P1cn
-----END PGP SIGNATURE-----

--iJXiJc/TAIT2rh2r--
