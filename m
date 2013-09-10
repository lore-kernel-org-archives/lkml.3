Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3IJFIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:08:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:6191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3IJFIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:08:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,876,1371106800"; 
   d="asc'?scan'208";a="292894936"
Date: Tue, 10 Sep 2013 09:51:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
        vinod.koul@intel.com
Subject: [GIT PULL] slave-dmaengine update for 3.12
Message-ID: <20130910042100.GC17188@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Back from the longish weekend here, so time to send you the pull request.

Okay we have fairly longish pull this time, and NO recent rebase which got =
you
annoyed last time :(

This pull brings:
- Andy's DW driver updates
- Guennadi's sh driver updates
- Pl08x driver fixes from Tomasz & Alban
- Improvements to mmp_pdma by Daniel
- TI EDMA fixes by Joel
- New drivers:
	- Hisilicon k3dma driver
	- Renesas rcar dma driver
- New API for publishing slave driver capablities
- Various fixes across the subsystem by Andy, Jingoo, Sachin etc...


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:
  Linus Torvalds (1):
        Linux 3.11-rc4

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alban Bedel (2):
      dmaengine: PL08x: Fix reading the byte count in cctl
      dmaengine: PL08x: Add cyclic transfer support

Andy Shevchenko (20):
      imx-sdma: remove useless variable
      mxs-dma: remove useless variable
      edma: no need to assign residue to 0 explicitly
      ep93xx_dma: remove useless use of lock
      fsldma: remove useless use of lock
      mmp_pdma: remove useless use of lock
      mpc512x_dma: remove useless use of lock
      pch_dma: remove useless use of lock
      tegra20-apb-dma: remove useless use of lock
      ipu_idmac: re-use dma_cookie_status()
      mmp_tdma: set cookies as well when asked for tx status
      txx9dmac: return DMA_SUCCESS immediately from device_tx_status()
      acpi-dma: fix sparse warning
      dma: dw: append MODULE_DEVICE_TABLE for ACPI case
      dma: dw: improve comparison with ~0
      dma: dw: allow shared interrupts
      dma: dw: return DMA_SUCCESS immediately from device_tx_status()
      dma: dw: return DMA_PAUSED only if cookie status is DMA_IN_PROGRESS
      acpi-dma, doc: append managed function to the list
      acpi-dma: remove ugly conversion

Barry Song (1):
      dmaengine: sirf: add PM entries for sleep and runtime

Ben Hutchings (1):
      pch_dma: Add MODULE_DEVICE_TABLE

Chanho Park (1):
      dma: pl330: split off common code to give back descriptors

Dan Carpenter (1):
      dmaengine: ste_dma40: off by one in d40_of_probe()

Daniel Mack (13):
      dma: mmp_pdma: factor out DRCMR register calculation
      dma: mmp_pdma: refactor unlocking path in lookup_phy()
      dma: mmp_pdma: fix maximum transfer length
      dma: mmp_pdma: add filter function
      dma: mmp_pdma: make the controller a DMA provider
      dma: mmp_pdma: print the number of channels at probe time
      dma: mmp_pdma: remove duplicate assignment
      dma: mmp_pdma: add support for byte-aligned transfers
      dma: mmp_pdma: only complete one transaction from dma_do_tasklet()
      dma: mmp_pdma: don't clear DCMD_ENDIRQEN at end of pending chain
      dma: mmp_pdma: add support for cyclic DMA descriptors
      dma: mmp_pdma: set DMA_PRIVATE
      dma: dmagengine: fix function names in comments

Fabio Estevam (2):
      dma: ste_dma: Fix warning when CONFIG_ARM_LPAE=3Dy
      dma: imx-sdma: Staticize sdma_driver_data structures

Guennadi Liakhovetski (11):
      DMA: shdma: fix CHCLR register address calculation
      DMA: shdma: switch all __iomem pointers to void
      DMA: shdma: support the new CHCLR register layout
      DMA: shdma: switch to managed resource allocation
      DMA: sudmac: fix compiler warning
      DMA: shdma: make a pointer const
      DMA: shdma: switch DT mode to use configuration data from a match tab=
le
      DMA: shdma: remove private and unused defines from a global header
      DMA: shdma: add a header with common for ARM SoCs defines
      DMA: shdma: add r8a73a4 DMAC data to the device ID table
      DMA: shdma: fix a bad merge - remove free_irq()

Huang Shijie (1):
      dma: imx-sdma: remove the unused completion

Jingoo Han (7):
      dma: mmp_pdma: Staticize mmp_pdma_alloc_descriptor()
      dma: mv_xor: use NULL instead of 0
      dma: sirf: use NULL instead of 0
      dma: use dev_get_platdata()
      dma: ipu: remove unnecessary platform_set_drvdata()
      dma: sh: remove unnecessary platform_set_drvdata()
      dma: k3dma: use devm_ioremap_resource() instead of devm_request_and_i=
oremap()

Joel Fernandes (6):
      dma: edma: Setup parameters to DMA MAX_NR_SG at a time
      dma: edma: Write out and handle MAX_NR_SG at a given time
      ARM: edma: Add function to manually trigger an EDMA channel
      dma: edma: Find missed events and issue them
      dma: edma: Leave linked to Null slot instead of DUMMY slot
      dma: edma: Remove limits on number of slots

Julia Lawall (2):
      dma: mmp: simplify use of devm_ioremap_resource
      dma: replace devm_request_and_ioremap by devm_ioremap_resource

Lars-Peter Clausen (2):
      dma: pl330: Implement device_slave_caps
      dma: pl330: Fix handling of TERMINATE_ALL while processing completed =
descriptors

Lothar Wa=DFmann (1):
      dma: of: make error message more meaningful by adding the node name

Max Filippov (1):
      dma: add driver for R-Car HPB-DMAC

Sachin Kamat (3):
      dma: imx-dma: Remove redundant NULL check
      dma: ste_dma40: Remove duplicate const
      dma: ste_dma40: Fix potential null pointer dereference

Sascha Hauer (3):
      dma: imx-sdma: Use struct for driver data
      dma: imx-sdma: Add ROM script addresses to driver
      ARM: i.MX: remove sdma script address arrays from platform data

Shawn Guo (1):
      dma: mxs-dma: remove code left from generic DMA binding conversion

Tomasz Figa (6):
      dmaengine: PL08x: Refactor pl08x_getbytes_chan() to lower indentation
      dmaengine: PL08x: Add support for different offset of CONFIG register
      dmaengine: PL08x: Rework LLI handling to be less fragile
      dmaengine: PL08x: Move LLI dumping code into separate function
      dmaengine: PL08x: Add support for PL080S variant
      dmaengine: PL08x: Add support for different maximum transfer size

Vinod Koul (9):
      dmaengine: add dma_slave_get_caps api
      Merge branch 'topic/of' into for-linus
      dmaengine: fix - error: potential NULL dereference 'chan'
      Merge branch 'topic/api_caps' into for-linus
      Merge branch 'topic/of' into for-linus
      Merge branch 'topic/sh' into for-linus
      dmaengine: dma_slave_caps: remove sg entries
      dmaengine: pl330: use dma_set_max_seg_size to set the sg limit
      Merge branch 'topic/api_caps' into for-linus

Viresh Kumar (1):
      dmaengine/MAINTAINERS: Add Andy as Co-Maintainer of DW DMA Controller

Xiang Wang (2):
      dma: mmp_pdma: add protect when alloc/free phy channels
      dma: mmp_pdma: clear DRCMR when free a phy channel

Zhangfei Gao (2):
      dmaengine: add interface of dma_get_slave_channel
      dmaengine: Add hisilicon k3 DMA engine driver

 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |    7 +-
 Documentation/devicetree/bindings/dma/k3dma.txt    |   46 ++
 Documentation/devicetree/bindings/dma/shdma.txt    |   61 +-
 Documentation/driver-model/devres.txt              |    3 +
 MAINTAINERS                                        |    1 +
 arch/arm/common/edma.c                             |   17 +
 arch/arm/mach-imx/mm-imx25.c                       |   17 -
 arch/arm/mach-imx/mm-imx5.c                        |   14 -
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/acpi-dma.c                             |    4 +-
 drivers/dma/amba-pl08x.c                           |  501 +++++++++----
 drivers/dma/dmaengine.c                            |   28 +-
 drivers/dma/dw/core.c                              |   39 +-
 drivers/dma/dw/platform.c                          |    1 +
 drivers/dma/edma.c                                 |  164 +++-
 drivers/dma/ep93xx_dma.c                           |   10 +-
 drivers/dma/fsldma.c                               |   10 +-
 drivers/dma/imx-dma.c                              |    6 +-
 drivers/dma/imx-sdma.c                             |  179 ++++-
 drivers/dma/iop-adma.c                             |    6 +-
 drivers/dma/ipu/ipu_idmac.c                        |    6 +-
 drivers/dma/k3dma.c                                |  837 ++++++++++++++++=
++++
 drivers/dma/mmp_pdma.c                             |  320 ++++++--
 drivers/dma/mmp_tdma.c                             |    6 +-
 drivers/dma/mpc512x_dma.c                          |   10 +-
 drivers/dma/mv_xor.c                               |    4 +-
 drivers/dma/mxs-dma.c                              |   27 +-
 drivers/dma/of-dma.c                               |    3 +-
 drivers/dma/pch_dma.c                              |   10 +-
 drivers/dma/pl330.c                                |  179 +++--
 drivers/dma/sh/Kconfig                             |   10 +
 drivers/dma/sh/Makefile                            |    6 +
 drivers/dma/sh/rcar-hpbdma.c                       |  655 +++++++++++++++
 drivers/dma/sh/shdma-arm.h                         |   51 ++
 drivers/dma/sh/shdma-base.c                        |   26 +-
 drivers/dma/sh/shdma-of.c                          |    5 +-
 drivers/dma/sh/shdma-r8a73a4.c                     |   77 ++
 drivers/dma/sh/shdma.h                             |   16 +-
 drivers/dma/sh/{shdma.c =3D> shdmac.c}               |  160 ++---
 drivers/dma/sh/sudmac.c                            |   22 +-
 drivers/dma/sirf-dma.c                             |  134 +++-
 drivers/dma/ste_dma40.c                            |   23 +-
 drivers/dma/tegra20-apb-dma.c                      |    8 +-
 drivers/dma/timb_dma.c                             |    2 +-
 drivers/dma/txx9dmac.c                             |   22 +-
 include/linux/amba/pl080.h                         |    1 +
 include/linux/dma/mmp-pdma.h                       |   15 +
 include/linux/dmaengine.h                          |   37 +
 include/linux/fsl/mxs-dma.h                        |   20 -
 include/linux/platform_data/dma-rcar-hpbdma.h      |  103 +++
 include/linux/platform_data/edma.h                 |    2 +
 include/linux/sh_dma.h                             |   55 +-
 include/linux/shdma-base.h                         |    3 +-
 54 files changed, 3241 insertions(+), 738 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/k3dma.txt
 create mode 100644 drivers/dma/k3dma.c
 create mode 100644 drivers/dma/sh/rcar-hpbdma.c
 create mode 100644 drivers/dma/sh/shdma-arm.h
 create mode 100644 drivers/dma/sh/shdma-r8a73a4.c
 rename drivers/dma/sh/{shdma.c =3D> shdmac.c} (88%)
 create mode 100644 include/linux/dma/mmp-pdma.h
 delete mode 100644 include/linux/fsl/mxs-dma.h
 create mode 100644 include/linux/platform_data/dma-rcar-hpbdma.h

Thanks
~Vinod
--=20

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSLp4sAAoJEHwUBw8lI4NH4tIQAICazH4n7n/txMU9Eldw6POF
xJFRHVKvDdVHQN5OGuQws2sozORQb3qazrt53k2ry96WlV71KYUzE5e7NE+67TCi
5yKrw4GhVpVIttGrmFvq8uQ/HH8IiQYmzbIj6NYpnFa8z9LYbXIB29behIMewGgV
JNpkfAum4AIkpBWEmQBKSnLJ6jIOPq/V0CmakVkHwOdxW4BlCAStPeUV2lz5IpYc
FyEGIsyiIg4bXkZl5TDdDSP6ylG7FjmgWOoahXmhVPq1PRgoSXNRyG1JiBc06T15
Nx2hw30ShMpL1fYrq6YWf90LryE5QJyrrRKABIgbrKQk7sW4fqH0CKgaVXOjgjwK
KGj8ilD8ZhVyoj6pS3EOaWSNtpQZLNOvGKU49xZqxn4qvDCprCI7fWe8SIKIUHht
Rl6FCV4s8AKTepnK1D3Lb4IPwwz/LRgaihH+x5NacqzInpNRn9g6q+4T9rsVWrjw
Yf0d6yRwiUaazGCZ7gHWW+Z0ABPKAb0h130yKbNj6/nwwGvyQczE943tpl5kCh9f
0vhIgM7hDj4QKIe7OKveS4Iyw4OWShAuu2zfZv8D3vX3FEohcQ+1fF4DwXaDCYiW
qqNPhazck1NwMg6/0pLOXONmPwSOFFjzkoR85/GbRc2/Yh83T1f5dx49dwizAWuP
pIzlPVJ79XqluK19fxOL
=v/sk
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
