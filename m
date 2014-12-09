Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaLITMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:12:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53480 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaLITMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:12:12 -0500
Date: Tue, 9 Dec 2014 19:11:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141209191152.GI11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOdHDkIp180r3pqZ"
Content-Disposition: inline
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOdHDkIp180r3pqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.19

for you to fetch changes up to 0e647037fed5632e7c5989ec359ab84c676888ac:

  Merge remote-tracking branches 'spi/topic/spidev' and 'spi/topic/txx9' into spi-next (2014-12-08 12:17:20 +0000)

----------------------------------------------------------------
spi: Updates for v3.19

Not a huge amount going on this release, mainly new drivers (there's a
couple more waiting that didn't quite make the cut for this release
too):

 - An interface for querying if the current transfer is the last in a
   message, allowing controllers that need special handling for the
   final transfer to use the core message parsing.
 - Support for Amlogic Meson SPIFC, Imagination Technologies SFPI, Intel
   Quark X1000 and Samsung Exynos 7 controllers.

----------------------------------------------------------------
Andrew Bresticker (2):
      spi: Add binding document for IMG SPFI controller
      spi: Add driver for IMG SPFI controller

Andy Shevchenko (2):
      spi: dw-mid: refactor to use helpers
      spi: dw-mid: split rx and tx callbacks when DMA

Beniamino Galvani (4):
      spi: core: Add spi_transfer_is_last() helper
      spi: meson: Add device tree bindings documentation for SPIFC
      spi: meson: Add support for Amlogic Meson SPIFC
      spi: meson: Select REGMAP_MMIO

Charles Keepax (1):
      spi: spi-mxs: Fix mapping from vmalloc-ed buffer to scatter list

Christophe Leroy (1):
      spi: fsl-spi: Don't use cpm_command on CPM1

Fabio Estevam (2):
      spi: spi-mxs: Register the irq with the device name
      spi: spi-fsl-spi: Return an error code in fsl_spi_do_one_msg()

Fengguang Wu (1):
      spi/atmel: fix simple_return.cocci warnings

Heiner Kallweit (3):
      spi: fsl-(e)spi: migrate to generic master queueing
      spi: fsl-espi: add (un)prepare_transfer_hardware calls to save power if SPI is not in use
      spi: fsl-spi: remove unused variable assignment

Jarkko Nikula (1):
      spi: core: Do not mangle error code from kthread_run()

Lars-Peter Clausen (1):
      spi: cadence: Fix 3-to-8 mux mode

Laurentiu Palcu (1):
      spi/rockchip: remove redundant call to spi_master_put()

Ludovic Desroches (2):
      spi: atmel: remove compat for non DT board when requesting dma chan
      spi: atmel: introduce probe deferring

Mark Brown (9):
      Merge branch 'fix/dw' of git://git.kernel.org/.../broonie/spi into spi-dw
      spi: spidev: Don't mangle max_speed_hz in underlying spi device
      spi/s3c64xx: Remove redundant runtime PM management
      Merge remote-tracking branch 'spi/fix/cadence' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branches 'spi/topic/atmel', 'spi/topic/cadence', 'spi/topic/dw' and 'spi/topic/fsl-cpm' into spi-next
      Merge remote-tracking branches 'spi/topic/fsl-dspi', 'spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/topic/img-spfi' and 'spi/topic/meson' into spi-next
      Merge remote-tracking branches 'spi/topic/mxs', 'spi/topic/pxa', 'spi/topic/rockchip', 'spi/topic/samsung' and 'spi/topic/sirf' into spi-next
      Merge remote-tracking branches 'spi/topic/spidev' and 'spi/topic/txx9' into spi-next

Markus Elfring (1):
      spi/txx9: Deletion of an unnecessary check before the function call "clk_disable"

Padmavathi Venna (1):
      spi: s3c64xx: add support for exynos7 SPI controller

Paul Cercueil (1):
      spi: cadence: Init HW after reading devicetree attributes

Qipan Li (2):
      spi: sirf: assign spi_master's max_speed_hz member
      spi: sirf: reset SPI controller in init stage

Torsten Fleischer (2):
      spi: spi-gpio: Add dt support for a single device with no chip select
      spi: spi-gpio: Fix compiler warning when building for 64 bit systems

Vinod Koul (2):
      spi/dw: use dmaengine_slave_config() API
      spi/atmel: use dmaengine_terminate_all() API

Weike Chen (2):
      spi: spi-pxa2xx: Add helpers for regiseters' accessing
      spi: spi-pxa2xx: SPI support for Intel Quark X1000

Wenyou Yang (2):
      spi/atmel: add support for runtime PM
      spi/atmel: improve the system suspend/resume functions implementation

Xiubo Li (1):
      spi: fsl-dspi: remove useless code for dspi driver.

kbuild test robot (1):
      spi: meson: meson_spifc_setup_speed() can be static

 Documentation/devicetree/bindings/spi/spi-gpio.txt |   6 +-
 .../devicetree/bindings/spi/spi-img-spfi.txt       |  37 +
 .../devicetree/bindings/spi/spi-meson.txt          |  22 +
 .../devicetree/bindings/spi/spi-samsung.txt        |   2 +-
 drivers/spi/Kconfig                                |  17 +-
 drivers/spi/Makefile                               |   2 +
 drivers/spi/spi-atmel.c                            | 115 ++--
 drivers/spi/spi-cadence.c                          |  33 +-
 drivers/spi/spi-dw-mid.c                           | 114 +++-
 drivers/spi/spi-dw.h                               |   2 +-
 drivers/spi/spi-fsl-cpm.c                          |   5 +-
 drivers/spi/spi-fsl-dspi.c                         |   3 +-
 drivers/spi/spi-fsl-espi.c                         |  59 +-
 drivers/spi/spi-fsl-lib.c                          |  59 +-
 drivers/spi/spi-fsl-lib.h                          |  10 +-
 drivers/spi/spi-fsl-spi.c                          |  17 +-
 drivers/spi/spi-gpio.c                             |  37 +-
 drivers/spi/spi-img-spfi.c                         | 746 +++++++++++++++++++++
 drivers/spi/spi-meson-spifc.c                      | 462 +++++++++++++
 drivers/spi/spi-mxs.c                              |  12 +-
 drivers/spi/spi-pxa2xx-pci.c                       |   8 +
 drivers/spi/spi-pxa2xx.c                           | 304 +++++++--
 drivers/spi/spi-pxa2xx.h                           |  16 +-
 drivers/spi/spi-rockchip.c                         |   2 -
 drivers/spi/spi-s3c64xx.c                          |  41 +-
 drivers/spi/spi-sirf.c                             |  12 +-
 drivers/spi/spi-txx9.c                             |   3 +-
 drivers/spi/spi.c                                  |   2 +-
 drivers/spi/spidev.c                               |  16 +-
 include/linux/pxa2xx_ssp.h                         |  20 +
 include/linux/spi/spi.h                            |   6 +
 31 files changed, 1911 insertions(+), 279 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-img-spfi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-meson.txt
 create mode 100644 drivers/spi/spi-img-spfi.c
 create mode 100644 drivers/spi/spi-meson-spifc.c

--GOdHDkIp180r3pqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh0l3AAoJECTWi3JdVIfQZf0H/2zGYyJbNQltvZMkrvwQ5UvI
cMPx3QJj+jSm17NRzbNkf/1phNpIk47oD3xq0IIkfKXn5m3itoT61PdGJfzzERAA
NhkDmFJEkid4ncuc2qcohVDQWWaE9vz1rNn5AB7/rNXdF3qyafAZXEJNRMvTLZBx
SFoWVCX+zWwKau+JWJvaawUTGL+jgoKfIiRtHYdPR8GWCHefOYZrVT+Qnd6SUfSs
HxMgCa4Mhdov4dXoABP3TLvJDDSVXXUh+561mos7KCqRIFiXcp+qnlGrj3FLomyA
2Imt5+F2r8zBTmtrWAOKUO2f+towfRlku8yj/LMA2CsUsNh81ygro30xx1qKVJ4=
=lAaD
-----END PGP SIGNATURE-----

--GOdHDkIp180r3pqZ--
