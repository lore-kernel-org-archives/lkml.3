Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaJFPRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:17:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37089 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaJFPRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:17:09 -0400
Date: Mon, 6 Oct 2014 16:16:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141006151652.GP4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Content-Disposition: inline
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E18

for you to fetch changes up to a2285b8c75bf7e21895f7c2cf75d6a910914517b:

  Merge remote-tracking branch 'spi/topic/xilinx' into spi-next (2014-10-03=
 16:33:44 +0100)

----------------------------------------------------------------
spi: Updates for v3.18

A quiet release for SPI, mainly driver updates and not too many of them:

 - Support for dummy transfers (for delays on startup) in drivers using
   transfer_one().
 - Lots of enhancements to the Designware driver to support new Intel
   SoCs.
 - Support for newer Renesas chips.
 - DMA support for the i.MX driver.
 - One new driver for Broadcom BCM53xx chips.

----------------------------------------------------------------
Addy Ke (1):
      spi/rockchip: fix bug that cause the failure to read data in DMA mode

Alexander Shiyan (1):
      spi: clps711x: Migrate to the new clk subsystem

Alexander Stein (1):
      spi: fsl-dspi: Remove probe info message

Anders Berg (1):
      spi: pl022: Add support for chip select extension

Andy Shevchenko (19):
      spi/pxa2xx-pci: remove unnecessary assignment
      spi: dw-pci: move info message at the end of probe
      spi: dw-pci: apply pci_bar and re-use pci_name
      spi: dw-pci: convert to use dev_pm_ops
      spi: dw-pci: provide platform specific data via driver_data
      spi: dw-pci: remove FSF address and update copyright
      spi: dw: remove FSF address
      spi: dw-mid: check that DMA was inited before exit
      spi: dw-mid: remove Moorestown support
      spi: dw-mid: remove redundant dmac member
      spi: dw-mid: remove FSF address and update copyright
      spi: dw: don't use mrst prefix anymore
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: terminate ongoing transfers at exit
      spi: dw: introduce support of loopback mode
      spi: dw: fix style of code in few places
      spi: dw-mid: change magic numbers to the constants
      spi: dw-mid: convert to use DMAengine wrappers
      spi: dw-mid: follow new DMAengine workflow

Axel Lin (2):
      spi: bcm53xx: Fix module dependency
      spi: bcm53xx: Add missing module information

Chew, Chiau Ee (1):
      spi/pxa2xx-pci: Add common clock framework support in PCI glue layer

Geert Uytterhoeven (12):
      spi: rspi: Remove unneeded semicolon
      spi: rspi: Use devm_kasprintf()
      spi: rspi: Configure DMA slave bus width to 8 bit
      spi: rspi: Add DT support to DMA setup
      spi: sh-msiof: Configure DMA slave bus width
      spi: sh-msiof: Add DT support to DMA setup
      spi: sh-msiof: Return early in sh_msiof_dma_once() where possible
      spi: sh-msiof: Fix transmit-only DMA transfers
      regmap: Split regmap_get_endian() in two functions
      spi: rspi: Add support for new R-Car Gen2 SoCs
      spi: sh-msiof: Add support for new R-Car Gen2 SoCs
      spi/drivers: Restrict COMPILE_TEST by HAS_DMA where needed

Greg Ungerer (1):
      spi: orion: support armada extended baud rates

Javier Martinez Canillas (1):
      regmap: Fix DT endianess parsing logic

Jingoo Han (10):
      spi: bcm53xx: make local symbol static
      spi: ep93xx: Fix checkpatch issue
      spi: xtensa-xtfpga: Fix checkpatch issue
      spi: spi-mxs: Fix checkpatch issue
      spi: davinci: Fix checkpatch issue
      spi: dw: Fix checkpatch issue
      spi: orion: Fix checkpatch issue
      spi: tegra114: Fix checkpatch issue
      spi: tegra20-sflash: Fix checkpatch issue
      spi: txx9: Fix checkpatch issue

Kiran Padwal (1):
      spi: pl022: Add missing error check for devm_kzalloc

Mark Brown (12):
      Merge tag 'dt-endian' of git://git.kernel.org/.../broonie/regmap into=
 spi-fsl-dspi
      spi: Only call transfer_one() if we have buffers to transfer
      Merge tag 'dt-endian' of git://git.kernel.org/.../broonie/regmap into=
 spi-fsl-dspi
      Merge branch 'topic/checkpatch' of git://git.kernel.org/.../broonie/s=
pi into spi-dw
      Merge remote-tracking branch 'spi/fix/rockchip' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/dma-dep' into spi-next
      Merge remote-tracking branches 'spi/topic/bcm53xx', 'spi/topic/cadenc=
e', 'spi/topic/checkpatch' and 'spi/topic/clps711x' into spi-next
      Merge remote-tracking branches 'spi/topic/davinci', 'spi/topic/doc', =
'spi/topic/dw' and 'spi/topic/fsl' into spi-next
      Merge remote-tracking branches 'spi/topic/fsl-dspi', 'spi/topic/imx',=
 'spi/topic/mxs', 'spi/topic/omap-100k' and 'spi/topic/orion' into spi-next
      Merge remote-tracking branches 'spi/topic/pl022', 'spi/topic/pxa2xx',=
 'spi/topic/rspi', 'spi/topic/sh-msiof' and 'spi/topic/sirf' into spi-next
      Merge remote-tracking branch 'spi/topic/xilinx' into spi-next

Michael Heimpold (1):
      spi: spi-mxs: fix a tiny typo in a comment

Michal Simek (2):
      spi: cadence: Remove .owner field for driver
      spi: xilinx: Remove .owner field for driver

Murali Karicheri (1):
      spi: davinci: add support for adding delay between word's transmissio=
ns

Nick Krause (1):
      spi: omap-100k: Remove unused definitions

Oscar Utbult (1):
      spi-summary: documentation mistake

Qipan Li (3):
      spi: sirf: correct spi gpio and hardware chipselect behaviour
      spi: sirf: fix 'cmd_transfer' function typos
      spi: sirf: cleanup the indentation of marcos

Rafa=C5=82 Mi=C5=82ecki (1):
      spi: bcm53xx: driver for SPI controller on Broadcom bcma SoC

Robin Gong (1):
      spi: spi-imx: add DMA support

Stephen Warren (1):
      regmap: of_regmap_get_endian() cleanup

Xiubo Li (5):
      regmap: add DT endianness binding support.
      regmap: Add the DT binding documentation for endianness
      spi: fsl-dspi: Convert to use regmap framework's endianness method.
      spi: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      spi: fsl: Sort include headers alphabetically

 .../devicetree/bindings/regmap/regmap.txt          |  47 ++++
 .../devicetree/bindings/spi/fsl-imx-cspi.txt       |   5 +
 Documentation/devicetree/bindings/spi/sh-msiof.txt |  23 +-
 .../devicetree/bindings/spi/spi-davinci.txt        |  30 +++
 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |   7 +-
 .../devicetree/bindings/spi/spi-orion.txt          |   2 +-
 Documentation/devicetree/bindings/spi/spi-rspi.txt |  10 +-
 Documentation/spi/spi-summary                      |   6 +-
 drivers/base/regmap/regmap-i2c.c                   |   2 +
 drivers/base/regmap/regmap-spi.c                   |   2 +
 drivers/base/regmap/regmap.c                       |  74 ++++-
 drivers/spi/Kconfig                                |  19 +-
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-bcm53xx.c                          | 299 +++++++++++++++++=
++++
 drivers/spi/spi-bcm53xx.h                          |  72 +++++
 drivers/spi/spi-cadence.c                          |   1 -
 drivers/spi/spi-clps711x.c                         |  34 +--
 drivers/spi/spi-davinci.c                          |  63 ++++-
 drivers/spi/spi-dw-mid.c                           |  65 ++---
 drivers/spi/spi-dw-pci.c                           |  67 +++--
 drivers/spi/spi-dw.c                               |  64 +++--
 drivers/spi/spi-dw.h                               |  11 +-
 drivers/spi/spi-ep93xx.c                           |   1 +
 drivers/spi/spi-fsl-cpm.c                          |  14 +-
 drivers/spi/spi-fsl-dspi.c                         |  22 +-
 drivers/spi/spi-fsl-espi.c                         |  12 +-
 drivers/spi/spi-fsl-lib.c                          |   6 +-
 drivers/spi/spi-fsl-spi.c                          |  22 +-
 drivers/spi/spi-imx.c                              | 286 +++++++++++++++++=
++-
 drivers/spi/spi-mxs.c                              |   6 +-
 drivers/spi/spi-omap-100k.c                        |   4 -
 drivers/spi/spi-orion.c                            | 121 +++++++--
 drivers/spi/spi-pl022.c                            |  64 ++++-
 drivers/spi/spi-pxa2xx-pci.c                       |  20 +-
 drivers/spi/spi-rockchip.c                         |  15 +-
 drivers/spi/spi-rspi.c                             |  55 ++--
 drivers/spi/spi-sh-msiof.c                         |  51 ++--
 drivers/spi/spi-sirf.c                             | 109 +++-----
 drivers/spi/spi-tegra114.c                         |   9 +
 drivers/spi/spi-tegra20-sflash.c                   |   3 +-
 drivers/spi/spi-txx9.c                             |   2 +
 drivers/spi/spi-xilinx.c                           |   1 -
 drivers/spi/spi-xtensa-xtfpga.c                    |   1 +
 drivers/spi/spi.c                                  |  45 ++--
 include/linux/amba/bus.h                           |   5 +
 45 files changed, 1396 insertions(+), 382 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt
 create mode 100644 drivers/spi/spi-bcm53xx.c
 create mode 100644 drivers/spi/spi-bcm53xx.h

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUMrJjAAoJECTWi3JdVIfQrDkH+wfKzqN0riSLczrHCCdusiib
EgLxLxDa/5GzntEuKyTCv7CPEMuVuBeUTfXspbsmmAtQQa+8ORKZ/dHV68aX/8IQ
x6MnobbjXGGLvsZHCc9KpFQqEmQGyVBao2R8aIAJ/KBZChqUeOeyx7gZ1W0a5aeL
D8qCh7Pkwcskk8si4a13gwGeQgqmirhtjNmzaSWC18BMAN8p8vQDsaxvePK4nILY
qgC+M6V9NA+L10rMH6s56nJKAKCuz+rfpb/KLwkR4aclsTEP+TvtBZdOb3VvxfXL
fLhuMB75dJRJj6ntmpGAfSwoVBAa0HDkzWPQ8gSGyDHnQsgujLrsWAgLTqzy+MA=
=2NUI
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
