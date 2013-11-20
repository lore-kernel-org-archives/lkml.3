Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3KTEm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:42:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:41624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3KTEmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:42:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,734,1378882800"; 
   d="asc'?scan'208";a="436424901"
Date: Wed, 20 Nov 2013 09:16:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, vinod.koul@intel.com,
        dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine updates
Message-ID: <20131120034630.GK8834@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus


Here is the pull request for 3.13. This is consolidated pull request from D=
an
Williams and me. I have merged his changes into mine.

This brings for slave dmaengine:
- Change dma notification flag to DMA_COMPLETE from DMA_SUCCESS as dmaengin=
e can
  only transfer and not verify validaty of dma transfers
- Bunch of fixes across drivers:
	- cppi41 driver fixes from Daniel
	- 8 channel freescale dma engine support and updated bindings from Hongbo
	- msx-dma fixes and cleanup by Markus
- DMAengine updates from Dan:
    1/ Bartlomiej and Dan finalized a rework of the dma address unmap
       implementation.

    2/ In the course of testing 1/ a collection of enhancements to dmatest
       fell out.  Notably basic performance statistics, and fixed / enhanced
       test control through new module parameters 'run', 'wait', 'noverify',
       and 'verbose'.  Thanks to Andriy and Linus for their review.

    3/ Testing the raid related corner cases of 1/ triggered bugs in the
       recently added 16-source operation support in the ioatdma driver.

    4/ Some minor fixes / cleanups to mv_xor and ioatdma.

--
Thanks
~Vinod

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:
  Linus Torvalds (1):
        Linux 3.12-rc7

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Bartlomiej Zolnierkiewicz (4):
      dmatest: make driver unmap also source buffers by itself
      NTB: convert to dmaengine_unmap_data
      dmaengine: remove DMA unmap from drivers
      dmaengine: remove DMA unmap flags

Dan Carpenter (2):
      dma: pl330: off by one in pl330_probe()
      dma: pl330: silence a compile warning

Dan Williams (26):
      dmaengine: consolidate memcpy apis
      dmaengine: prepare for generic 'unmap' data
      dmaengine: reference counted unmap data
      async_memcpy: convert to dmaengine_unmap_data
      async_xor: convert to dmaengine_unmap_data
      async_xor_val: convert to dmaengine_unmap_data
      async_raid6_recov: convert to dmaengine_unmap_data
      async_pq: convert to dmaengine_unmap_data
      async_pq_val: convert to dmaengine_unmap_data
      Revert "dmatest: append verify result to results"
      dmatest: replace stored results mechanism, with uniform messages
      dmatest: cleanup redundant "dmatest: " prefixes
      dmatest: restore ability to start test at module load and init
      dmatest: support xor-only, or pq-only channels in tests
      dmatest: use pseudo random numbers
      dmatest: add support for skipping verification and random data setup
      dmatest: add basic performance metrics
      dmatest: add a 'wait' parameter
      dmatest: convert to dmaengine_unmap_data
      dmatest: verbose mode
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      ioatdma: clean up sed pool kmem_cache
      raid6test: add new corner case for ioatdma driver
      ioat: kill msix_single_vector support
      ioat: fix ioat3_irq_reinit

Daniel Mack (6):
      dma: cppi41: pass around device instead of platform_device
      dma: cppi41: s/deinit_cpii41/deinit_cppi41/
      dma: cppi41: add shortcut to &pdev->dev in cppi41_dma_probe()
      dma: cppi41: add support for suspend and resume
      dma: cppi41: restore more registers
      dma: cppi41: use cppi41_pop_desc() where possible

Dave Jiang (1):
      ioatdma: Fix bug in selftest after removal of DMA_MEMSET.

Ezequiel Garcia (2):
      dma: mv_xor: Remove unneeded NULL address check
      dma: mv_xor: Fix mis-usage of mmio 'base' and 'high_base' registers

Guennadi Liakhovetski (1):
      DMA: ste_dma40: use a power of 2 check

Hongbo Zhang (3):
      DMA: Freescale: revise device tree binding document
      DMA: Freescale: Add new 8-channel DMA engine device tree nodes
      DMA: Freescale: update driver to support 8-channel DMA engine

Joel Fernandes (3):
      dma: edma: Split out PaRAM set calculations into its own function
      dma: edma: Increase maximum SG limit to 20
      dma: edma: Add support for Cyclic DMA

Ludovic Desroches (1):
      dma: atmel-dma: correct typo in the device tree bindings documentation

Markus Pargmann (5):
      dma: mxs-dma: Cleanup interrupt handler
      dma: mxs-dma: Report correct residue for cyclic DMA
      dma: mxs-dma: Fix channel reset hardware bug
      dma: mxs-dma: Update state after channel reset
      dma: mxs-dma: Use semaphores for cyclic DMA

Michael Opdenacker (2):
      dma: coh901318: remove deprecated IRQF_DISABLED
      dma: misc: remove deprecated IRQF_DISABLED

Michal Simek (3):
      dma: pl330: Simplify irq allocation
      dma: pl330: Support per channel irq allocation
      dma: pl330: Remove unnecessary amba_set_drvdata()

Olof Johansson (2):
      dmaengine: ipu: fix warnings from 64-bit dma_addr_t printouts
      dma: imx-sdma: Fix warnings for LPAE builds

Qiao Zhou (1):
      dma: mmp_tdma: add multiple burst size support for 910-squ

Russell King (1):
      dmaengine: imx-dma: fix format warnings

Sachin Kamat (1):
      dma: tegra20-apb-dma: Staticize tegra_dma_prep_dma_cyclic

Sebastian Andrzej Siewior (3):
      fix missing edma changes to EDMA_DMA_COMPLETE status
      dma: cppi41: redo descriptor collection in abort case
      dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error

Vinod Koul (36):
      dmaengine: use DMA_COMPLETE for dma completion status
      dmaengine: amba-pl08x: use DMA_COMPLETE for dma completion status
      dmaengine: at_hdma: use DMA_COMPLETE for dma completion status
      dmaengine: coh901318: use DMA_COMPLETE for dma completion status
      dmaengine: cppi41: use DMA_COMPLETE for dma completion status
      dmaengine: jz4740: use DMA_COMPLETE for dma completion status
      dmaengine: dmatest: use DMA_COMPLETE for dma completion status
      dmaengine: dw: use DMA_COMPLETE for dma completion status
      dmaengine: edma: use DMA_COMPLETE for dma completion status
      dmaengine: imx-dma: use DMA_COMPLETE for dma completion status
      dmaengine: imx-sdma: use DMA_COMPLETE for dma completion status
      dmaengine: intel_mid_dma: use DMA_COMPLETE for dma completion status
      dmaengine: ioat: use DMA_COMPLETE for dma completion status
      dmaengine: iop: use DMA_COMPLETE for dma completion status
      dmaengine: k3dma: use DMA_COMPLETE for dma completion status
      dmaengine: mmp_tdma: use DMA_COMPLETE for dma completion status
      dmaengine: mv_xor: use DMA_COMPLETE for dma completion status
      dmaengine: mxs-dma: use DMA_COMPLETE for dma completion status
      dmaengine: omap: use DMA_COMPLETE for dma completion status
      dmaengine: ppc4xx: use DMA_COMPLETE for dma completion status
      dmaengine: sa11x0: use DMA_COMPLETE for dma completion status
      dmaengine: sh: use DMA_COMPLETE for dma completion status
      dmaengine: ste: use DMA_COMPLETE for dma completion status
      dmaengine: tegra: use DMA_COMPLETE for dma completion status
      dmaengine: txx9: use DMA_COMPLETE for dma completion status
      async_tx: use DMA_COMPLETE for dma completion status
      serial: sh: use DMA_COMPLETE for dma completion status
      net: use DMA_COMPLETE for dma completion status
      dmaengine: remove unused DMA_SUCCESS
      Merge branch 'for-linus' into next
      Merge branch 'dma_complete' into next
      dmanengine: fix edma driver to not define DMA_COMPLETE
      Merge branch 'dma_complete' into next
      Merge branch 'for-linus' into next
      dmaengine: edma: remove duplicate kfree
      Merge commit 'dmaengine-3.13-v2' of git://git.kernel.org/.../djbw/dma=
engine

Wei Yongjun (1):
      dma: mmp_pdma: use list_move instead of list_del/list_add

 .../devicetree/bindings/dma/atmel-dma.txt          |    2 +-
 .../devicetree/bindings/powerpc/fsl/dma.txt        |  138 +++-
 Documentation/dmatest.txt                          |   72 +-
 arch/arm/common/edma.c                             |    4 +-
 arch/arm/include/asm/hardware/iop3xx-adma.h        |   30 -
 arch/arm/include/asm/hardware/iop_adma.h           |    4 -
 arch/arm/mach-iop13xx/include/mach/adma.h          |   26 -
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   82 ++
 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   82 ++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
 crypto/async_tx/async_memcpy.c                     |   37 +-
 crypto/async_tx/async_pq.c                         |  174 +++--
 crypto/async_tx/async_raid6_recov.c                |   61 +-
 crypto/async_tx/async_tx.c                         |    4 +-
 crypto/async_tx/async_xor.c                        |  123 ++--
 crypto/async_tx/raid6test.c                        |   10 +-
 drivers/ata/pata_arasan_cf.c                       |    3 +-
 drivers/dma/Kconfig                                |    9 +-
 drivers/dma/amba-pl08x.c                           |   39 +-
 drivers/dma/at_hdmac.c                             |   28 +-
 drivers/dma/coh901318.c                            |    4 +-
 drivers/dma/cppi41.c                               |  178 +++--
 drivers/dma/dma-jz4740.c                           |    2 +-
 drivers/dma/dmaengine.c                            |  264 ++++--
 drivers/dma/dmatest.c                              |  917 ++++++++--------=
----
 drivers/dma/dw/core.c                              |   29 +-
 drivers/dma/edma.c                                 |  369 ++++++--
 drivers/dma/ep93xx_dma.c                           |   30 +-
 drivers/dma/fsldma.c                               |   26 +-
 drivers/dma/fsldma.h                               |    2 +-
 drivers/dma/imx-dma.c                              |   42 +-
 drivers/dma/imx-sdma.c                             |   10 +-
 drivers/dma/intel_mid_dma.c                        |    4 +-
 drivers/dma/ioat/dma.c                             |   53 +-
 drivers/dma/ioat/dma.h                             |   14 -
 drivers/dma/ioat/dma_v2.c                          |    2 +-
 drivers/dma/ioat/dma_v2.h                          |    1 -
 drivers/dma/ioat/dma_v3.c                          |  323 +------
 drivers/dma/ioat/pci.c                             |   20 +-
 drivers/dma/iop-adma.c                             |  113 +---
 drivers/dma/ipu/ipu_idmac.c                        |    6 +-
 drivers/dma/k3dma.c                                |    4 +-
 drivers/dma/mmp_pdma.c                             |    7 +-
 drivers/dma/mmp_tdma.c                             |   40 +-
 drivers/dma/mv_xor.c                               |   58 +--
 drivers/dma/mv_xor.h                               |   25 +-
 drivers/dma/mxs-dma.c                              |  178 +++-
 drivers/dma/omap-dma.c                             |    2 +-
 drivers/dma/pl330.c                                |   32 +-
 drivers/dma/ppc4xx/adma.c                          |  272 +------
 drivers/dma/sa11x0-dma.c                           |    2 +-
 drivers/dma/sh/shdma-base.c                        |    2 +-
 drivers/dma/sh/shdmac.c                            |    4 +-
 drivers/dma/ste_dma40.c                            |    7 +-
 drivers/dma/tegra20-apb-dma.c                      |    6 +-
 drivers/dma/timb_dma.c                             |   37 +-
 drivers/dma/txx9dmac.c                             |   29 +-
 drivers/media/platform/m2m-deinterlace.c           |    3 +-
 drivers/media/platform/timblogiw.c                 |    2 +-
 drivers/misc/carma/carma-fpga.c                    |    3 +-
 drivers/mtd/nand/atmel_nand.c                      |    3 +-
 drivers/mtd/nand/fsmc_nand.c                       |    2 -
 drivers/net/ethernet/micrel/ks8842.c               |    6 +-
 drivers/ntb/ntb_transport.c                        |   86 ++-
 drivers/spi/spi-dw-mid.c                           |    4 +-
 drivers/tty/serial/sh-sci.c                        |    2 +-
 include/linux/dmaengine.h                          |   76 ++-
 include/linux/platform_data/edma.h                 |    8 +-
 net/ipv4/tcp.c                                     |    4 +-
 sound/soc/davinci/davinci-pcm.c                    |    2 +-
 71 files changed, 1979 insertions(+), 2272 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi


--=20

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSjDCWAAoJEHwUBw8lI4NHDH8P/iMK5fsFfwk1GBWLSZGbWvEM
/Jt3W4SAkVeFtqVzH/z9hhZQI4boSQ7dcWRyzFCjYtAz9G7l3paWwQ2rnSiDpGOY
DHXnIW3Q5FAWx7zBoVGfyTaY4F+OZbrL/mgp0Iat7hDnR2m5+eU9Rw+QxLrWJvhC
+KxPj9EHaul2m0RXyZWd0N68Pqssp4qKTq7Q8ufR8sw50g9hXhfIiolwbiqjrxaM
vV2yXhcBCwfrjLckb97MHQWJikRARevOR2l7go2muRcpQzWDILLENvqT94x+gni1
tUmN5FOX9PCLB0cQNWKL718QS3AQ3gfy+aLyvm/GAKxZ9C5Wna1M52x0H+A8xjPw
WNwqUn4ZP2bLA2+4dFJlUPSRNX1P0kxTaUT45irdlVzjuPa+fp5EEe3Juin94dhI
6CHWFqoZ2MX/+xjHmvFdEEg0z/LU6U1SYjIJl0JPb6+MRv8E+VAaDUEgISyrnU+B
geFHattPqn6whn6R8ThBrefwVFGKdLcqeOyW48wonkso2ZWQb+P1MX7WSuLGkxV6
w7bE7AB5gS72xwnyu49jLODBQHRlI0wRZz8rgso0QKwVFJJY7KKqbfYDLHyGznIJ
0LlDLdOOj4Z2ngSF+GmhjaToKuI3SgG/TRwXwMnw09R8NsKmovA7liqxPStirdqb
i0vvELrph0S1bErRx0di
=jeq/
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
