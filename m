Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3GGE4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 00:56:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:46527 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3GGE4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 00:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1012,1363158000"; 
   d="asc'?scan'208";a="327694650"
Date: Sun, 7 Jul 2013 09:47:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [GIT PULL] slave-dmaengine updates
Message-ID: <20130707041714.GB16653@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Once you have some time from extended weekend celebrations please consider
pulling the following to get:
- Various fixes and PCI driver for dw_dmac by Andy
- DT binding for imx-dma by Markus & imx-sdma by Shawn
- DT fixes for dmaengine by Lars
- jz4740 dmac driver by Lars
- and various fixes across the drivers


The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:
  Linus Torvalds (1):
        Linux 3.10-rc5

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Andy Shevchenko (4):
      dw_dmac: don't check resource with devm_ioremap_resource
      dma: move dw_dmac driver to an own directory
      dma: dw: split driver to library part and platform code
      dma: dw: add PCI part of the driver

Boris BREZILLON (1):
      dmaengine: at_hdmac: prepare clk before calling enable

Denis Efremov (1):
      dw_dmac: remove inline marking of EXPORT_SYMBOL functions

Dmitry Osipenko (2):
      dma: tegra20-apbdma: err message correction
      dma: tegra: avoid channel lock up after free

Elen Song (2):
      DMA: AT91: Get transfer width
      DMA: AT91: Get residual bytes in dma buffer

Fabio Estevam (1):
      dma: mxs-dma: Staticize mxs_dma_xlate

Guennadi Liakhovetski (3):
      DMA: shdma: (cosmetic) don't re-calculate a pointer
      DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
      DMA: shdma: add DT support

Jingoo Han (3):
      dma: use platform_{get,set}_drvdata()
      dma: at_hdmac: remove unnecessary platform_set_drvdata()
      dma: timb_dma: remove unnecessary platform_set_drvdata()

Lars-Peter Clausen (5):
      dma: of: Remove restriction that #dma-cells can't be 0
      dma: of: Remove check on always true condition
      dma: Add a jz4740 dmaengine driver
      MIPS: jz4740: Register jz4740 DMA device
      MIPS: jz4740: Remove custom DMA API

Ludovic Desroches (2):
      ARM: at91: dt: add header to define at_hdmac configuration
      dmaengine: at_hdmac: add FIFO configuration parameter to DMA DT bindi=
ng

Maarten ter Huurne (2):
      MIPS: jz4740: Acquire and enable DMA controller clock
      MIPS: jz4740: Correct clock gate bit for DMA controller

Mark Brown (1):
      dmaengine: PL08x: Avoid collisions with get_signal() macro

Markus Pargmann (2):
      dma: imx-dma: Add oftree support
      DMA: imx-dma: imxdma->dev used uninitialized

Nicolas Ferre (5):
      dmaengine: at_hdmac/trivial: correct typo in comment
      dmaengine: at_hdmac: extend hardware handshaking interface identifica=
tion
      dmaengine: at_hdmac/trivial: rearrange CFG register bits assignment
      dmaengine: at_hdmac: remove unsuded atc_cleanup_descriptors()
      dmaengine/trivial: at_hdmac: add curly brackets to if/else expressions

Qiao Zhou (1):
      dma: mmp_tdma: disable irq when disabling dma channel

Rongjun Ying (1):
      dmaengine: sirf: set dma residue based on the current dma transfer po=
sition

Shawn Guo (1):
      dma: imx-sdma: move to generic device tree bindings

Vinod Koul (1):
      dmaengine: dw: select DW_DMAC_BIG_ENDIAN_IO automagically

Will Deacon (2):
      dma: pl330: rip out broken, redundant ID probing
      dma: pl330: use dma_addr_t for describing bus addresses

 .../devicetree/bindings/dma/atmel-dma.txt          |    7 +-
 .../devicetree/bindings/dma/fsl-imx-dma.txt        |   48 ++
 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |   56 ++
 Documentation/devicetree/bindings/dma/shdma.txt    |   75 +++
 MAINTAINERS                                        |    3 +-
 arch/arm/mach-lpc32xx/phy3250.c                    |    4 +-
 arch/arm/mach-spear/spear3xx.c                     |    4 +-
 arch/arm/mach-spear/spear6xx.c                     |    4 +-
 arch/mips/include/asm/mach-jz4740/dma.h            |   56 --
 arch/mips/include/asm/mach-jz4740/platform.h       |    1 +
 arch/mips/jz4740/Makefile                          |    2 +-
 arch/mips/jz4740/board-qi_lb60.c                   |    1 +
 arch/mips/jz4740/clock.c                           |    2 +-
 arch/mips/jz4740/dma.c                             |  287 ---------
 arch/mips/jz4740/platform.c                        |   21 +
 drivers/dma/Kconfig                                |   26 +-
 drivers/dma/Makefile                               |    3 +-
 drivers/dma/amba-pl08x.c                           |    8 +-
 drivers/dma/at_hdmac.c                             |  211 +++++--
 drivers/dma/at_hdmac_regs.h                        |    5 +
 drivers/dma/dma-jz4740.c                           |  617 ++++++++++++++++=
++++
 drivers/dma/dw/Kconfig                             |   29 +
 drivers/dma/dw/Makefile                            |    8 +
 drivers/dma/{dw_dmac.c =3D> dw/core.c}               |  320 ++---------
 drivers/dma/dw/internal.h                          |   70 +++
 drivers/dma/dw/pci.c                               |  101 ++++
 drivers/dma/dw/platform.c                          |  317 ++++++++++
 drivers/dma/{dw_dmac_regs.h =3D> dw/regs.h}          |    7 +
 drivers/dma/fsldma.c                               |    5 +-
 drivers/dma/imx-dma.c                              |   77 +++-
 drivers/dma/imx-sdma.c                             |   40 ++
 drivers/dma/mmp_tdma.c                             |    4 +
 drivers/dma/mxs-dma.c                              |    2 +-
 drivers/dma/of-dma.c                               |   17 +-
 drivers/dma/pl330.c                                |   29 +-
 drivers/dma/ppc4xx/adma.c                          |    5 +-
 drivers/dma/sh/Makefile                            |    2 +-
 drivers/dma/sh/shdma-base.c                        |   26 +-
 drivers/dma/sh/shdma-of.c                          |   82 +++
 drivers/dma/sh/shdma.c                             |   33 +-
 drivers/dma/sirf-dma.c                             |   17 +
 drivers/dma/tegra20-apb-dma.c                      |    3 +-
 drivers/dma/timb_dma.c                             |    2 -
 include/dt-bindings/dma/at91.h                     |   27 +
 include/linux/amba/pl08x.h                         |    8 +-
 include/linux/of_dma.h                             |    1 -
 include/linux/platform_data/dma-atmel.h            |    4 +
 include/linux/platform_data/dma-imx.h              |    6 +-
 include/linux/sh_dma.h                             |    2 -
 include/linux/shdma-base.h                         |    3 +
 50 files changed, 1889 insertions(+), 799 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/fsl-imx-dma.txt
 create mode 100644 Documentation/devicetree/bindings/dma/shdma.txt
 delete mode 100644 arch/mips/jz4740/dma.c
 create mode 100644 drivers/dma/dma-jz4740.c
 create mode 100644 drivers/dma/dw/Kconfig
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{dw_dmac.c =3D> dw/core.c} (85%)
 create mode 100644 drivers/dma/dw/internal.h
 create mode 100644 drivers/dma/dw/pci.c
 create mode 100644 drivers/dma/dw/platform.c
 rename drivers/dma/{dw_dmac_regs.h =3D> dw/regs.h} (97%)
 create mode 100644 drivers/dma/sh/shdma-of.c
 create mode 100644 include/dt-bindings/dma/at91.h

--=20
Thanks
~Vinod

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJR2OvKAAoJEHwUBw8lI4NH9SgQAJSqo0pzHyWMs/foAdGo+uPA
mTwJ8+jhNzISuTg6Ko61lpnu82A1ot53txMt6BwldHLZ8IPCcwGifot959HSQDny
VJqDBAebMm4Tzqfwm2Q9ZoQVV9HsAewR4btyBKlzWEU5rLEXMmwn67BL4lBtDQ0r
5fuVwXO2CHRCVABqeADhl8Y09otj1+jOnXCTPsH393HUsqV+Z/MfkwfCj9nZn+jI
Ny8kSWRwg3Xwu5Kuzo0aYsFd0OIV5tFngPxowz6NbRgQluA7sGut3/ajQX8PK2Lw
7aYL85FFgEaFRHiwaMDyb8cA6hQyViOIM6mOgOlQSkIETdWBuaca16g19bYC+0ni
yqZruud8agp5vCwayoDYdkEk+s48b8R87F4c2nMwcJvUEfD72XsA7aprbmdGWJl1
4a7vaQN5g7Ku8+/sBugilBUaFprfSXqZ4xr8n72FSxPkCQEgTO8mOVQ8JGC5WyB3
2sQp1JKBN7rqsE5XppURA8ZnSSl+6FUlTnh/2xVLYN32TnP5YzG2JfA44BVhfEmF
g54MrqwSyu98r4jujtPkEsqkLjgBXAjsM6/ep3aLy7WktZwvohPLajASLJcU/99k
M4XZTpPJE9bL7jjSllQNTT6iBGOjqjd4QR1KJTxt0sv/Zxsih+uzxenxdUIGRU1o
FMzn6TjXg8ftk0Z54AzI
=0/8X
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
