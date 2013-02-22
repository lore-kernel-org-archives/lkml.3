Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3BVEdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:33:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:8937 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3BVEd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:33:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="asc'?scan'208";a="290437256"
Date: Fri, 22 Feb 2013 10:02:51 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: Dan Williams <djbw@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine updates
Message-ID: <20130222043251.GA16351@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Linus,

Here is the slave-dmaengine updates.

This is fairly big pull by my standards as I had missed last merge window.
So we have the support for device tree for slave-dmaengine, large updates to
dw_dmac driver from Andy for reusing on different architectures. Along with this
we have fixes on bunch of the drivers

Thanks
~Vinod
----------------------

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Akinobu Mita (4):
      dmaengine: use for_each_set_bit
      dma: amba-pl08x: use vchan_dma_desc_free_list
      dmatest: adjust invalid module parameters for number of source buffers
      async_tx: use memchr_inv

Alessandro Rubini (1):
      pl080.h: moved from arm/include/asm/hardware to include/linux/amba/

Andy Shevchenko (34):
      dw_dmac: change dev_printk() to corresponding macros
      dw_dmac: don't call platform_get_drvdata twice
      dw_dmac: change dev_crit to dev_WARN in dwc_handle_error
      dw_dmac: introduce to_dw_desc() macro
      dw_dmac: absence of pdata isn't critical when autocfg is set
      dw_dmac: check for mapping errors
      dw_dmac: remove redundant check
      dw_dmac: update tx_node_active in dwc_do_single_block
      dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
      dmaengine: introduce is_slave_direction function
      dma: at_hdmac: check direction properly for cyclic transfers
      dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
      dma: ep93xx_dma: reuse is_slave_direction helper
      dma: ipu_idmac: reuse is_slave_direction helper
      dma: ste_dma40: reuse is_slave_direction helper
      dw_dmac: call .probe after we have a device in place
      dw_dmac: store direction in the custom channel structure
      dw_dmac: make usage of dw_dma_slave optional
      dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
      dw_dmac: allocate dma descriptors from DMA_COHERENT memory
      dw_dmac: don't exceed AHB master number in dwc_get_data_width
      dw_dmac: move soft LLP code from tasklet to dwc_scan_descriptors
      dw_dmac: print out DW_PARAMS and DWC_PARAMS when debug
      dw_dmac: remove unnecessary tx_list field in dw_dma_chan
      dw_dmac: introduce total_len field in struct dw_desc
      dw_dmac: fill individual length of descriptor
      dw_dmac: return proper residue value
      dw_dmac: apply default dma_mask if needed
      dma: of-dma: protect list write operation by spin_lock
      dmaengine.h: remove redundant else keyword
      dma: coh901318: avoid unbalanced locking
      dma: coh901318: set residue only if dma is in progress
      edma: do not waste memory for dma_mask
      dma: tegra20-apb-dma: remove unnecessary assignment

Arnd Bergmann (1):
      Revert "ARM: SPEAr13xx: Pass DW DMAC platform data from DT"

Barry Song (4):
      dmaengine: sirf: enable the driver support new SiRFmarco SoC
      DMAEngine: add dmaengine_prep_interleaved_dma wrapper for interleaved api
      DMAEngine: sirf: add DMA pause/resume support
      DMAEngine: sirf: lock the shared registers access in sirfsoc_dma_terminate_all

Bartlomiej Zolnierkiewicz (10):
      async_tx: add missing DMA unmap to async_memcpy()
      ioat: add missing DMA unmap to ioat_dma_self_test()
      mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
      carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
      ioat3: add missing DMA unmap to ioat_xor_val_self_test()
      async_tx: fix build for async_memset
      dmaengine: remove dma_async_memcpy_pending() macro
      dmaengine: remove dma_async_memcpy_complete() macro
      dmaengine: add cpu_relax() to busy-loop in dma_sync_wait()
      async_tx: fix checking of dma_wait_for_async_tx() return value

Cong Ding (3):
      dma: remove unnecessary null pointer check in mmp_pdma.c
      dma: sh/shdma-base.c: remove unnecessary null pointer check
      dma: of-dma.c: fix memory leakage

Dave Jiang (3):
      ioat: Add alignment workaround for IVB platforms
      ioat: remove chanerr mask setting for IOAT v3.x
      ioatdma: fix race between updating ioat->head and IOAT_COMPLETION_PENDING

Fabio Baltieri (8):
      dmaengine: ste_dma40: add a done queue for completed descriptors
      dmaengine: ste_dma40: add missing kernel-doc entry
      dmaengine: ste_dma40: minor cosmetic fixes
      dmaengine: ste_dma40: minor code readability fixes
      dmaengine: ste_dma40: add software lli support
      dmaengine: set_dma40: ignore spurious interrupts
      dmaengine: set_dma40: balance clock in probe fail code
      dmaengine: ste_dma40: do not remove descriptors for cyclic transfers

Fabio Estevam (1):
      dma: mxs-dma: Fix build warnings with W=1

Fengguang Wu (1):
      dmaengine: ioat - fix spare sparse complain

Gerald Baeza (2):
      dmaengine: ste_dma40: support fixed physical channel allocation
      dmaengine: ste_dma40: physical channels number correction

Guennadi Liakhovetski (1):
      dma: sh: Don't use ENODEV for failing slave lookup

Heikki Krogerus (3):
      dmaengine: dw_dmac: remove CLK dependency
      dmaengine: dw_dmac: amend description and indentation
      dma: dw_dmac: clear suspend bit during termination

Jean Delvare (1):
      dma: ipu: Drop unused spinlock

Joe Perches (1):
      dma: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Jon Hunter (4):
      dmaengine: add helper function to request a slave DMA channel
      of: Add generic device tree DMA helpers
      of: dma: fix potential deadlock when requesting a slave channel
      of: dma: fix protection of DMA controller data stored by DMA helpers

Jon Mason (1):
      dmatest: Fix NULL pointer dereference on ioat

Kees Cook (1):
      drivers/dma: remove CONFIG_EXPERIMENTAL

Laxman Dewangan (2):
      dma: tegra: add support for channel wise pause
      dma: tegra: add support for Tegra114 SoC

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Matt Porter (2):
      of: dma: fix typos in generic dma binding definition
      dma: edma: fix slave config dependency on direction

Mika Westerberg (1):
      dw_dmac: add support for Lynxpoint DMA controllers

Narayanan (1):
      dmaengine: ste_dma40: reset priority bit for logical channels

Narayanan G (1):
      dmaengine: ste_dma40: don't check for pm_runtime_suspended()

Padmavathi Venna (4):
      DMA: PL330: Add new pl330 filter for DT case.
      DMA: PL330: Add xlate function
      DMA: PL330: Register the DMA controller with the generic DMA helpers
      ARM: dts: pl330: Add #dma-cells for generic dma binding support

Per Forlin (3):
      dmaengine: ste_dma40: use writel_relaxed for lcxa
      dmaengine: ste_dma40: set dma max seg size
      dmaengine: ste_dma40: limit burst size to 16

Rabin Vincent (1):
      dmaengine: ste_dma40: don't allow high priority dest event lines

Sachin Kamat (1):
      DMA: PL330: Use devm_* functions

Shiraz Hashim (1):
      dmaengine/dmatest: terminate transfers only in case of errors

Tong Liu (1):
      dmaengine: ste_dma40: support more than 128 event lines

Vinod Koul (5):
      of: dma- fix build break for !CONFIG_OF
      dmaengine: fix build failure due to missing semi-colon
      dmaengine: fix !of_dma compilation warning
      Merge tag 'ux500-dma40' of //git.linaro.org/people/fabiobaltieri/linux.git
      dmaengine: move drivers/of/dma.c -> drivers/dma/of-dma.c

Viresh Kumar (3):
      dmaengine: dw_dmac: Update documentation style comments for dw_dma_platform_data
      dmaengine: dw_dmac: Enhance device tree support
      ARM: SPEAr13xx: Pass DW DMAC platform data from DT

Wei Yongjun (1):
      pch_dma: use module_pci_driver to simplify the code

 .../devicetree/bindings/dma/arm-pl330.txt          |   21 +-
 Documentation/devicetree/bindings/dma/dma.txt      |   81 +++
 Documentation/devicetree/bindings/dma/snps-dma.txt |   44 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |   12 +
 arch/arm/mach-s3c64xx/dma.c                        |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |    1 -
 arch/arm/mach-spear6xx/spear6xx.c                  |    2 +-
 crypto/async_tx/async_memcpy.c                     |    6 +
 crypto/async_tx/async_memset.c                     |    1 +
 crypto/async_tx/async_tx.c                         |    9 +-
 crypto/async_tx/async_xor.c                        |    4 +-
 drivers/dca/dca-core.c                             |    5 +
 drivers/dma/Kconfig                                |   11 +-
 drivers/dma/Makefile                               |    2 +
 drivers/dma/amba-pl08x.c                           |   10 +-
 drivers/dma/at_hdmac.c                             |   10 +-
 drivers/dma/at_hdmac_regs.h                        |    8 +-
 drivers/dma/coh901318.c                            |    4 +-
 drivers/dma/coh901318_lli.c                        |    2 +-
 drivers/dma/dmaengine.c                            |   21 +-
 drivers/dma/dmatest.c                              |   22 +-
 drivers/dma/dw_dmac.c                              |  523 ++++++++++++++------
 drivers/dma/dw_dmac_regs.h                         |   27 +-
 drivers/dma/edma.c                                 |   61 ++--
 drivers/dma/ep93xx_dma.c                           |    3 +-
 drivers/dma/ioat/dma.c                             |   11 +-
 drivers/dma/ioat/dma.h                             |    1 +
 drivers/dma/ioat/dma_v2.c                          |  113 +++--
 drivers/dma/ioat/dma_v3.c                          |  216 ++++++---
 drivers/dma/ioat/hw.h                              |   11 +
 drivers/dma/ioat/pci.c                             |   11 -
 drivers/dma/iop-adma.c                             |   45 +-
 drivers/dma/ipu/ipu_idmac.c                        |    2 +-
 drivers/dma/ipu/ipu_irq.c                          |    1 -
 drivers/dma/mmp_pdma.c                             |    6 +-
 drivers/dma/mv_xor.c                               |   40 +-
 drivers/dma/mxs-dma.c                              |    8 +-
 drivers/dma/of-dma.c                               |  267 ++++++++++
 drivers/dma/pch_dma.c                              |   13 +-
 drivers/dma/pl330.c                                |  101 +++--
 drivers/dma/sh/shdma-base.c                        |    3 -
 drivers/dma/sh/shdma.c                             |    2 +-
 drivers/dma/sirf-dma.c                             |   73 +++-
 drivers/dma/ste_dma40.c                            |  491 ++++++++++++++-----
 drivers/dma/ste_dma40_ll.c                         |   29 +-
 drivers/dma/ste_dma40_ll.h                         |  130 +++++-
 drivers/dma/tegra20-apb-dma.c                      |   57 ++-
 drivers/misc/carma/carma-fpga-program.c            |    2 +-
 drivers/misc/carma/carma-fpga.c                    |    6 +-
 drivers/mtd/nand/fsmc_nand.c                       |   22 +-
 .../asm/hardware => include/linux/amba}/pl080.h    |    2 +-
 include/linux/dmaengine.h                          |   48 +-
 include/linux/dw_dmac.h                            |   45 +-
 include/linux/of_dma.h                             |   74 +++
 include/linux/platform_data/dma-ste-dma40.h        |   13 +
 net/ipv4/tcp.c                                     |    8 +-
 56 files changed, 2038 insertions(+), 705 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/dma.txt
 create mode 100644 drivers/dma/of-dma.c
 rename {arch/arm/include/asm/hardware => include/linux/amba}/pl080.h (99%)
 create mode 100644 include/linux/of_dma.h


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRJvTzAAoJEHwUBw8lI4NHS/4QAL6oQlYtF71OBI0PSGkAPlOE
ZHcMnyxBn/RANEs4i20hvhF30FOPEbKTAORc1/ggbAGetAc8YR0+rfyfwh2Xxs5/
ClRvStth1GRGbwbOJSCg0OfPVtbPQDTF4QYo6PDgAWzpqJSZQsQRhT1+mXiHwTfx
xnu55Cg9staxRYljMX1Mb1DNrOxc/MrUkkWAP1W6GIp1by+MawQPVukYxkLc+OGX
V0uYXcT46LT+D/HX+d6QJVBH3ch45fzReRD6b6hqLgbEWn/gaBi9+19wMfJS5pz+
ZD/MQuMy6LguazkDpk0J93N9Up/GynBRcflXdNCyCm4dSm3gbyTthrPoAjrtRJIp
t8zxwv1RkCEXaO6B7kxRpbCZkmAMrukcXJjcgQBf1wSJMm814b02Cv4UNjT49ysC
sNCRdLh+sXKQ0atkPM/bbA96owg8bcNFLKVlsfUnS3xLEf01RlxE4onTr/YVr0kN
DywydplySZYCVrtinS2Zmx5tbvkBy0N1/f5IstBoegi35W1QDmmA+QJ2JAfzRKAo
uFdqlFoJW6dp64Ba476sZojP1T+FUhnK/j0NaiAPO7BCFhUi1k99AIll9A0VT6eJ
ZiStCJt2pX9Y/MbYudIIJ4Lvu7h2f050xww8sPBsP6IqBfPibz91b3LJpwbEB0KL
E0Dt7p/ztyi1WZzdhQXV
=h8sh
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
