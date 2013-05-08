Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3EHDVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:21:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:42497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab3EHDVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,631,1363158000"; 
   d="asc'?scan'208";a="333518512"
Date: Wed, 8 May 2013 08:17:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: [GIT PULL] slave-dmaengine updates
Message-ID: <20130508024741.GS1960@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Here is the pull request for this merge window. Btw are you going to call it
3.10 or 4.0? .... 4.0 sounds much better :)

This time we have dmatest improvements from Andy along with dw_dmac fixes. He
has also done support for acpi for dmanegine
Also we have bunch of fixes going in DT support for dmanegine for various folks
Then Haswell and other ioat changes from Dave and SUDMAC support from Shimoda.

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:
  Linus Torvalds (1):
        Linux 3.9-rc7

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Andy Shevchenko (17):
      dmatest: cancel thread immediately when asked for
      dmatest: allocate memory for pq_coefs from heap
      dmatest: create dmatest_info to keep test parameters
      dmatest: move dmatest_channels and nr_channels to dmatest_info
      dmatest: split test parameters to separate structure
      dmatest: run test via debugfs
      dmatest: return actual state in 'run' file
      dmatest: define MAX_ERROR_COUNT constant
      dmatest: gather test results in the linked list
      dmatest: append verify result to results
      dw_dmac: don't wait for FIFO_EMPTY endlessly in dwc_chan_pause
      dw_dmac: fix style of the comments
      dw_dmac: rename DT related methods to reflect their belonging
      dw_dmac: remove unnecessary ENODEV check
      dma: acpi-dma: introduce ACPI DMA helpers
      dmaengine: call acpi_dma_request_slave_channel as well
      dw_dmac: add ACPI support

Arnd Bergmann (1):
      dmaengine: dw_dmac: simplify master selection

Barry Song (2):
      dmaengine:sirf:take clock and enable it while probing
      dmaengine: sirf: move driver init from module_init to subsys_initcall

Dave Jiang (13):
      ioatdma: make debug output more readable
      ioatdma: allow all channels to have irq coalescing support
      ioatdma: Adding Haswell devid for ioatdma
      ioatdma: Adding PCI IDs for Intel Atom S1200 product family ioatdma devices
      ioatdma: Add 64bit chansts register read for ioat v3.3.
      ioatdma: channel reset scheme fixup on Intel Atom S1200 platforms
      ioatdma: skip legacy reset bits since v3.3 plattform doesn't need it
      ioatdma: Removing PQ val disable for cb3.3
      ioatdma: skip silicon bug workaround for pq_align for cb3.3
      ioatdma: Removing hw bug workaround for CB3.x .2 and earlier
      ioatdma: Adding support for 16 src PQ ops and super extended descriptors
      ioatdma: S1200 platforms ioatdma channel 2 and 3 falsely advertise RAID cap
      ioatdma: Adding write back descriptor error status support for ioatdma 3.3

Fabio Estevam (1):
      dma: ipu: ipu_idmac: Fix section mismatch

Fengguang Wu (1):
      ioatdma: ioat3_alloc_sed can be static

Jassi Brar (1):
      DMA: PL330: allow submitting 2 requests at a time

Jon Hunter (1):
      dmaengine: OMAP: Register SDMA controller with Device Tree DMA driver

Lars-Peter Clausen (4):
      dma: Make the 'mask' parameter of __dma_request_channel const
      dma: of: Remove unnecessary list_empty check
      dma: of: Fix of_node reference leak
      dma:of: Use a mutex to protect the of_dma_list

Laxman Dewangan (1):
      dma: tegra: implement suspend/resume callbacks

Ludovic Desroches (1):
      at_hdmac: move to generic DMA binding

Markus Pargmann (1):
      DMA: of: Constant names

Maxin B. John (2):
      dma: timb_dma: Fix compiler warning
      dma: Remove erroneous __exit and __exit_p() references

Sachin Kamat (1):
      dma: pl330: Convert to devm_ioremap_resource()

Shimoda, Yoshihiro (2):
      dma: sh: add Kconfig
      sudmac: add support for SUDMAC

Stephen Warren (1):
      dma: tegra: assume CONFIG_OF

Syam Sidhardhan (1):
      dma: imx-dma: Remove redundant NULL check before kfree

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Vinod Koul (1):
      Merge branch 'topic/of' into for-linus

Viresh Kumar (1):
      DMA: OF: Check properties value before running be32_to_cpup() on it

 Documentation/acpi/enumeration.txt                 |   77 ++
 .../devicetree/bindings/dma/atmel-dma.txt          |   35 +-
 Documentation/dmatest.txt                          |   81 ++
 arch/arm/mach-omap2/dma.c                          |    4 +
 drivers/dma/Kconfig                                |   16 +-
 drivers/dma/Makefile                               |    3 +-
 drivers/dma/acpi-dma.c                             |  279 ++++++
 drivers/dma/at_hdmac.c                             |   97 ++-
 drivers/dma/at_hdmac_regs.h                        |    4 +
 drivers/dma/coh901318.c                            |    4 +-
 drivers/dma/dmaengine.c                            |   17 +-
 drivers/dma/dmatest.c                              |  887 ++++++++++++++++---
 drivers/dma/dw_dmac.c                              |  203 +++--
 drivers/dma/dw_dmac_regs.h                         |    6 +-
 drivers/dma/imx-dma.c                              |    7 +-
 drivers/dma/imx-sdma.c                             |    4 +-
 drivers/dma/ioat/dma.c                             |    8 +-
 drivers/dma/ioat/dma.h                             |   53 ++-
 drivers/dma/ioat/dma_v2.h                          |    2 +
 drivers/dma/ioat/dma_v3.c                          |  912 +++++++++++++++++---
 drivers/dma/ioat/hw.h                              |   88 ++-
 drivers/dma/ioat/pci.c                             |   20 +
 drivers/dma/ioat/registers.h                       |    4 +
 drivers/dma/ipu/ipu_idmac.c                        |    6 +-
 drivers/dma/of-dma.c                               |   96 +--
 drivers/dma/omap-dma.c                             |   38 +-
 drivers/dma/pch_dma.c                              |    2 +-
 drivers/dma/pl330.c                                |   10 +-
 drivers/dma/sh/Kconfig                             |   24 +
 drivers/dma/sh/Makefile                            |    3 +-
 drivers/dma/sh/sudmac.c                            |  428 +++++++++
 drivers/dma/sirf-dma.c                             |   24 +-
 drivers/dma/tegra20-apb-dma.c                      |   87 ++-
 drivers/dma/timb_dma.c                             |    2 +-
 drivers/dma/txx9dmac.c                             |    8 +-
 include/linux/acpi_dma.h                           |  116 +++
 include/linux/dmaengine.h                          |   15 +-
 include/linux/of_dma.h                             |   10 +-
 include/linux/sudmac.h                             |   52 ++
 39 files changed, 3215 insertions(+), 517 deletions(-)
 create mode 100644 Documentation/dmatest.txt
 create mode 100644 drivers/dma/acpi-dma.c
 create mode 100644 drivers/dma/sh/Kconfig
 create mode 100644 drivers/dma/sh/sudmac.c
 create mode 100644 include/linux/acpi_dma.h
 create mode 100644 include/linux/sudmac.h

--
Thanks
~Vinod

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRibzNAAoJEHwUBw8lI4NHzF8QAMczK+EhpNQtYA0b6cX7s85T
awl1/6JLwn0mylqBlbKYn/tbydC+qL0PXW7fuse07Dygv17fcjYJ0kJT4zMQ8KwI
LMqBZKE9RzGnv3zKyubWOoh5lVSN+PQzCQHEuftoXRWU0uQpGEkCl1/xBj0VApo8
BDvAprsQS+Cn3q/K5pseJcFGznH0ar1+90PiaUbxvy5/TGNw+tzYy333e4qMKyzA
T5XjTHPJIh2V32ZBodTTkrzidgO6NDRSk3XNSdBTTkqPT9yl1jSjEGb23MeprGW+
KD8nJNdX56MT3D27UjmLY1xWzkact+Md55I7Kd8LEV1XZI8IXzyKvVrYJa3/RHcz
j61GE905C9Au6GB0n37tQ8t6rtZsbkgj9RVY3Cs0hUfKt41n5RUcomUC78IUOCBB
/CRvWVFXDx9rNd+PrCD5sC6m44qzLOHbga0Uz0HWHcENtGOvyX/4xM3OdVIrDXFj
z5ThuHRRv1qKZnu9mwJ+ZxAjkE0llPohqWkwPzBCB1mAFkytjrf7P2FMJqLEg1Ci
28eymk7mBTHdgg6gFCWiu+5gR+yW6dIYZo8ZmAEdqCFNXgVmQcJY8C77AzN60KAu
eqRNTqZL163hjBfwyI6Ajpsh3hS6Dk7If8GlZ+8SgIaqqOEcuqmlcvDAtmVL3H9v
3e4GipAVKaDXno3fKs++
=szjf
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
