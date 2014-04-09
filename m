Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbaDIQVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:21:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:27785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbaDIQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:20:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="asc'?scan'208";a="510229047"
Date: Wed, 9 Apr 2014 21:42:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine updates
Message-ID: <20140409161202.GB9846@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Here is the pull request for this merge window. Please pull to receive:
- New driver for Qcom bam dma
- New driver for RCAR peri-peri
- New driver for FSL eDMA
- Various odd fixes and updates thru the subsystem


The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:
  Linus Torvalds (1):
        Linux 3.14-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alexander Shiyan (2):
      dma: imx-dma: Replace printk with dev_*
      dma: imx-dma: Add missing module owner field

Andy Gross (2):
      dmaengine: qcom_bam_dma: Add device tree binding
      dmaengine: add Qualcomm BAM dma driver

Andy Shevchenko (5):
      acpi-dma: use devm_release() instead of devm_destroy()
      acpi-dma: convert to return error code when asked for channel
      dma: dw: add a PCI ID for Intel Haswell SoC
      dma: dw: remove leftovers in the comment blocks
      dma: dw: allocate memory in two stages in probe

Barry Song (1):
      dmaengine: sirf: enable generic dt binding for dma channels

Chao Xie (1):
      dma: mmp_pdma: add IRQF_SHARED when request irq

Chew, Chiau Ee (1):
      dma: dw: Add suspend and resume handling for PCI mode DW_DMAC.

Christian Engelmayer (1):
      dma: edma: Fix memory leak in edma_prep_dma_cyclic()

Dan Carpenter (1):
      dmaengine: s3c24xx-dma: make phy->irq signed for error handling

George Cherian (2):
      usb: musb: musb_cppi41: Dont reprogram DMA if tear down is initiated
      dma: cppi41: start tear down only if channel is busy

Jerome Blin (1):
      Add new line to test result strings produced in verbose mode

Jingchang Lu (2):
      dma: Add Freescale eDMA engine driver support
      dma: fsl-edma: fix static checker warning of NULL dereference

Kuninori Morimoto (1):
      shdma: add R-Car Audio DMAC peri peri driver

Lars-Peter Clausen (1):
      dma: Remove comment about embedding dma_slave_config into custom stru=
cts

Laurent Pinchart (3):
      DMA: shdma: Fix warnings due to improper casts and printk formats
      DMA: shdma: Fix warnings due to declared but unused symbols
      DMA: shdma: Make sh_dmae_pm static

Nenghua Cao (1):
      dma: mmp_tdma: move to generic device tree binding

Paul Bolle (1):
      dmaengine: Remove dependency on MACH_BCM2708

Peter Ujfalusi (1):
      dma: omap-dma: Implement device_slave_caps callback

Vinod Koul (4):
      dmaengine: at_hdmac: use tasklet_kill in teardown
      dmaengine: pch_dma: use tasklet_kill in teardown
      Merge branch 'topic/tasklet_fix' into for-linus
      Merge branch 'topic/bam' into for-linus

 Documentation/devicetree/bindings/dma/fsl-edma.txt |   76 ++
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |   41 +
 .../devicetree/bindings/dma/sirfsoc-dma.txt        |   43 +
 arch/arm/boot/dts/atlas6.dtsi                      |    2 +
 arch/arm/boot/dts/prima2.dtsi                      |    2 +
 drivers/dma/Kconfig                                |   21 +-
 drivers/dma/Makefile                               |    2 +
 drivers/dma/acpi-dma.c                             |   17 +-
 drivers/dma/at_hdmac.c                             |    1 -
 drivers/dma/cppi41.c                               |    7 +-
 drivers/dma/dmaengine.c                            |    9 +-
 drivers/dma/dmatest.c                              |    4 +-
 drivers/dma/dw/core.c                              |   21 +-
 drivers/dma/dw/pci.c                               |   36 +
 drivers/dma/dw/regs.h                              |    4 +-
 drivers/dma/edma.c                                 |    5 +-
 drivers/dma/fsl-edma.c                             |  975 +++++++++++++++++
 drivers/dma/imx-dma.c                              |   13 +-
 drivers/dma/mmp_pdma.c                             |    8 +-
 drivers/dma/mmp_tdma.c                             |   50 +
 drivers/dma/omap-dma.c                             |   18 +
 drivers/dma/pch_dma.c                              |    4 +-
 drivers/dma/qcom_bam_dma.c                         | 1111 ++++++++++++++++=
++++
 drivers/dma/s3c24xx-dma.c                          |    2 +-
 drivers/dma/sh/Kconfig                             |    6 +
 drivers/dma/sh/Makefile                            |    1 +
 drivers/dma/sh/rcar-audmapp.c                      |  320 ++++++
 drivers/dma/sh/shdma-base.c                        |   10 +-
 drivers/dma/sh/shdma-of.c                          |    3 +-
 drivers/dma/sh/shdmac.c                            |   13 +-
 drivers/dma/sh/sudmac.c                            |    4 +-
 drivers/dma/sirf-dma.c                             |   23 +
 drivers/usb/musb/musb_cppi41.c                     |    3 +-
 include/linux/acpi_dma.h                           |    5 +-
 include/linux/dmaengine.h                          |   14 +-
 include/linux/dw_dmac.h                            |    5 +-
 include/linux/platform_data/dma-rcar-audmapp.h     |   34 +
 37 files changed, 2839 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
 create mode 100644 Documentation/devicetree/bindings/dma/sirfsoc-dma.txt
 create mode 100644 drivers/dma/fsl-edma.c
 create mode 100644 drivers/dma/qcom_bam_dma.c
 create mode 100644 drivers/dma/sh/rcar-audmapp.c
 create mode 100644 include/linux/platform_data/dma-rcar-audmapp.h

Thanks
--=20
~Vinod

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTRXFSAAoJEHwUBw8lI4NHqdYP/RVCiLdj5tKj0gDtOumekfTu
7s8ETvOKYrkzrn5YY/Lfj+1Tc+/Ym+JJok3cIuS30Ex7zGVj1W3bRHPzj7SmG8Zt
P+mMS+o5kF7CU0k37UbxQGzKEghmG9qPByOlxJddtcjriAOiDCkS3q2zxQfTu586
68drAaTAqHGs0kPVj1GGjNgSRY9L4PohweliRObQ4XYJO37M8Ys7eS9Y7YmGq6Wk
+lqulJyWd8O7dogg5qK2GWhIgKnFWIxfGvsq2lx16f1u9aAx5IbUcGhfz3yVUNQd
F9wC1iLeBPS8opEikgEHbtV3bQ758s/fKwQAAwHFkdObSuKIK4aBPvIBSegBOyYi
AUkxujrvmJgAqvZ96rWv7SnLlwh7JDRPD3369aS/g0fGZfjcGFJaqYYegM/DiAfS
qK8IZ+xuYieJcAa1QKf/BWapXRp9OglHTN7S64vLnOiwP6Y5JvuVu37cKocF9eix
W3btrDuNIGROMoCmayjazopSUhQmK+2ezpg7b5lMjdGndkemjM07LA08UpKsQL/J
WtL+wuH4LcwGfrld/bqyUdKH+805h/JJHGWrrHb75N5OLaTKyrLVgtecrWjVIUS0
pZgsrfFu78rLb1NunBSj+u59+W+QO6kUK08n4ciLkGKli28PBCGSXCij0n9wqQkY
294m4rZjq872HVW6ALpP
=LfBT
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
