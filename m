Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaFCKui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:50:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51695 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFCKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:50:36 -0400
Date: Tue, 3 Jun 2014 11:50:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140603105012.GZ31751@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zAZKrYjO7GRpkTOs"
Content-Disposition: inline
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi updates for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zAZKrYjO7GRpkTOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014:

  Linux 3.15-rc8 (2014-06-01 19:12:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git spi-v3.16

for you to fetch changes up to 69e25c755722056b57892bebeb1892e3a6fe8774:

  Merge remote-tracking branch 'spi/topic/workqueue' into spi-next (2014-06-02 17:08:43 +0100)

----------------------------------------------------------------

spi: Updates for v3.16

For this release SPI has been exceptionally quiet, all the work has been
on improving drivers (including taking advantage of some of the recent
framework updates):

 - DMA support for the rspi driver providing a nice performance boost.
 - Performance improvement for the SIRF controller in PIO mode.
 - New support for the Cadence SPI IP and for pxa2xx on BayTrail.

----------------------------------------------------------------
Alexandre Belloni (1):
      spi: atmel: fix incorrect comparison

Andy Gross (1):
      spi: qup: Correct selection of FIFO/Block mode

Antonio Ospite (1):
      spi/pxa2xx: fix runtime PM enabling order

Axel Lin (6):
      spi: atmel: Make current_remaining_bytes to be int
      spi: fsl: Kill mpc8xxx_spi_cleanup and convert fsl_espi_setup to use devm_kzalloc
      spi: fsl-spi: Fix memory leak
      spi: s3c24xx: Convert to use devm_kzalloc
      spi: Remove unneeded include of linux/workqueue.h
      spi: dw: Remove unused dw_spi_cleanup function

Baruch Siach (3):
      spi: dw: migrate to generic queue infrastructure
      spi: dw: document device tree binding
      spi: dw: add support for gpio controlled chip select

Chew, Chiau Ee (1):
      spi/pxa2xx-pci: Add PCI mode support for BayTrail LPSS SPI

Geert Uytterhoeven (19):
      spi: rspi: Round up division to avoid slave overclocking
      spi: core: Ignore unsupported spi-[tr]x-bus-width property values
      spi: rspi: Extract rspi_wait_for_{tx_empty,rx_full}()
      spi: rspi: Do not call rspi_receive_init() for TX-only
      spi: rspi: Remove unused 16-bit DMA support
      spi: rspi: Use core SPI_MASTER_MUST_[RT]X handling
      spi: rspi: Extract rspi_pio_transfer()
      spi: rspi: Don't consider DMA configuration failures fatal
      spi: rspi: Extract rspi_request_dma_chan()
      spi: rspi: Remove unneeded resource test in DMA setup
      spi: rspi: SPI DMA core needs both RX and TX DMA to function
      spi: rspi: Use SPI core DMA mapping framework
      spi: rspi: Move RSPI-specific setup out of DMA routines
      spi: rspi: Pass sg_tables instead of spi_tranfer to rspi_*_dma()
      spi: rspi: Merge rspi_*_dma() into rspi_dma_transfer()
      spi: rspi: Absorb rspi_rz_transfer_out_in() into rspi_rz_transfer_one()
      spi: rspi: Add DMA support for QSPI on R-Car Gen2
      spi: rspi: Add DMA support for RSPI on RZ/A1H
      spi: rspi: Extract rspi_common_transfer()

Harini Katakam (4):
      spi: core: Increase timeout value
      spi: Add driver for Cadence SPI controller
      spi: Add devicetree bindings documentation for Cadence SPI
      spi: cadence: Add dependency on ARM

Jane Wan (1):
      spi: fsl-espi: Configure FSL eSPI CSBEF and CSAFT

Jean Delvare (1):
      spi/topcliff-pch: Fix Kconfig dependencies

Jingoo Han (13):
      spi: pl022: remove unnecessary OOM messages
      spi: pxa2xx: remove unnecessary OOM messages
      spi: s3c24xx: remove unnecessary OOM messages
      spi: s3c64xx: remove unnecessary OOM messages
      spi: sh-msiof: remove unnecessary OOM messages
      spi: tle62x0: remove unnecessary OOM messages
      spi: topcliff-pch: remove unnecessary OOM messages
      spi: fsl-dspi: Make of_device_id array const
      spi: spi-gpio: Make of_device_id array const
      spi: qup: Make of_device_id array const
      spi: tegra114: Make of_device_id array const
      spi: tegra20-sflash: Make of_device_id array const
      spi: tegra20-slink: Make of_device_id array const

Mark Brown (7):
      Merge remote-tracking branches 'spi/fix/qup' and 'spi/fix/topcliff-pch' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/dt' into spi-next
      Merge remote-tracking branches 'spi/topic/adi', 'spi/topic/atmel' and 'spi/topic/cadence' into spi-next
      Merge remote-tracking branches 'spi/topic/dw', 'spi/topic/fsl', 'spi/topic/fsl-espi' and 'spi/topic/id-const' into spi-next
      Merge remote-tracking branches 'spi/topic/oom', 'spi/topic/pxa2xx', 'spi/topic/rspi' and 'spi/topic/sirf' into spi-next
      Merge remote-tracking branch 'spi/topic/workqueue' into spi-next

Qipan Li (4):
      spi: sirf: fix line over 80 characters style issue
      spi: sirf: fix spi full-duplex DMA transferring issue
      spi: sirf: refactor spi transfer functions
      spi: sirf: decrease the interrupt count and latency of PIO mode

Scott Jiang (2):
      spi: convert spi-bfin-v3.c to a multiplatform driver
      spi: spi-adi-v3: convert to use common clk framework

Valentin Longchamp (1):
      spi/fsl-espi: fix rx_buf in fsl_espi_cmd_trans()/fsl_espi_rw_trans()

Zhao Qiang (1):
      spi: add "spi-lsb-first" to devicetree

 Documentation/devicetree/bindings/spi/fsl-spi.txt  |   6 +
 Documentation/devicetree/bindings/spi/spi-bus.txt  |   2 +
 .../devicetree/bindings/spi/spi-cadence.txt        |  31 +
 Documentation/devicetree/bindings/spi/spi-dw.txt   |  24 +
 arch/blackfin/mach-bf609/boards/ezkit.c            |  22 +-
 arch/blackfin/mach-bf609/clock.c                   |   7 +
 drivers/spi/Kconfig                                |  13 +-
 drivers/spi/Makefile                               |   3 +-
 drivers/spi/{spi-bfin-v3.c => spi-adi-v3.c}        | 433 ++++++-------
 drivers/spi/spi-ath79.c                            |   1 -
 drivers/spi/spi-atmel.c                            |   9 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   1 -
 drivers/spi/spi-bcm63xx.c                          |   1 -
 drivers/spi/spi-cadence.c                          | 673 +++++++++++++++++++++
 drivers/spi/spi-dw-mmio.c                          |  22 +
 drivers/spi/spi-dw.c                               | 197 +-----
 drivers/spi/spi-dw.h                               |  24 +-
 drivers/spi/spi-falcon.c                           |   1 -
 drivers/spi/spi-fsl-dspi.c                         |   2 +-
 drivers/spi/spi-fsl-espi.c                         |  40 +-
 drivers/spi/spi-fsl-lib.c                          |   6 -
 drivers/spi/spi-fsl-lib.h                          |   1 -
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-gpio.c                             |   2 +-
 drivers/spi/spi-nuc900.c                           |   1 -
 drivers/spi/spi-omap-uwire.c                       |   1 -
 drivers/spi/spi-pl022.c                            |  13 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  76 ++-
 drivers/spi/spi-pxa2xx.c                           |  21 +-
 drivers/spi/spi-qup.c                              |   6 +-
 drivers/spi/spi-rspi.c                             | 601 +++++++-----------
 drivers/spi/spi-s3c24xx.c                          |  15 +-
 drivers/spi/spi-s3c64xx.c                          |   6 +-
 drivers/spi/spi-sh-msiof.c                         |   4 +-
 drivers/spi/spi-sh-sci.c                           |   1 -
 drivers/spi/spi-sirf.c                             | 305 ++++++----
 drivers/spi/spi-sun4i.c                            |   1 -
 drivers/spi/spi-sun6i.c                            |   1 -
 drivers/spi/spi-tegra114.c                         |   2 +-
 drivers/spi/spi-tegra20-sflash.c                   |   2 +-
 drivers/spi/spi-tegra20-slink.c                    |   2 +-
 drivers/spi/spi-tle62x0.c                          |   4 +-
 drivers/spi/spi-topcliff-pch.c                     |   5 +-
 drivers/spi/spi.c                                  |  22 +-
 .../bfin_spi3.h => include/linux/spi/adi_spi3.h    |  20 +-
 include/linux/spi/rspi.h                           |   2 -
 46 files changed, 1582 insertions(+), 1052 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-cadence.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-dw.txt
 rename drivers/spi/{spi-bfin-v3.c => spi-adi-v3.c} (60%)
 create mode 100644 drivers/spi/spi-cadence.c
 rename arch/blackfin/include/asm/bfin_spi3.h => include/linux/spi/adi_spi3.h (97%)

--zAZKrYjO7GRpkTOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjahhAAoJELSic+t+oim9dnQP/0caJtC+p6hjc27jThVyr5U8
NC5VYE+b1mAvDJQsWUZO3qdWotO+KTxFzwNqKrwdNafeE5jAMmXevidGSRWE17IS
+mRxqB52/CAGWKjtDMrpNgV4+zfbiQPeLkVG7hijIfVaexIX22JMDanyTYptUNdH
gFu0pnlqnF/rXMdXKMLXNQCSb1YTSehO+ipl+g6DMFUik0ght5XpJMOpcfY1j4/K
u81T7fwdaiaxtKwCyq/db9gL1DFkU7158dhv3FCfh4bR7fxk3+KsnfkLcm+9OgpJ
5rsPTBSZGzTIH5hyuF+tLLzzbd/K5TfG9Hqo5Gg0JT0qK4b3AMYveo4gqZwNhLMx
QmEqpO6LCQuCU8wNOw/A+ctvuCriOPOZKtbHwqf0xaifryW/YZlmCO+nwplBlhAP
dydCp0+pUF86cOd7SEotgQIgSymACdc5RW0j9cv+kv1ps4pyoK0yCBF1HuMXhBfa
VShO5mogcpyjq0lAAiTME+mg269jakLu8Df3L77stpvXmp7qiqNsyhG+2DydZKO9
xtnlGyBTJcflLqdln40iCawTE6zgjF7/U+Kz2iJb+1viieZLd7aXYPJiDgFDVluG
eNihykXskqL3KidMhHomidsv9SHGcHSoMvTToztu9gWRel29uOusP0nRwFajQ7Lq
p9gzOssSU82mX75Y2TKz
=e2OE
-----END PGP SIGNATURE-----

--zAZKrYjO7GRpkTOs--
