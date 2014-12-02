Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaLBKKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:10:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59444 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbaLBKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:10:05 -0500
Date: Tue, 2 Dec 2014 11:07:55 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [GIT PULL] DMAengine generic caps and device control split
Message-ID: <20141202100755.GA28563@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Here is a pull request for the set of patches to refactor and convert
all drivers to a splitted device_control and the generic slave_caps
stuff.

It is based on your current dma/next, so it shouldn't conflict in any
way.

Thanks,
Maxime

The following changes since commit 14d0f54d42c8d71c42a42a3e5ae2e13ba0ebd139:

  Merge branch 'topic/at_xdmac' into next (2014-11-27 14:41:39 +0530)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mripard/linux.git tags/dm=
aengine-generic-caps

for you to fetch changes up to a3121690b6136ca5f7032865295a513d324faadd:

  Documentation: dmaengine: Update the documentation (2014-12-02 10:08:19 +=
0100)

----------------------------------------------------------------
DMAengine device_control and device_slave_caps consolidation

Refactor and split device_control in order to be able to implement a generic
device_slave_caps mechanism, and convert all drivers to it.

----------------------------------------------------------------
Ludovic Desroches (2):
      dmaengine: at_xdmac: split device_control
      dmaengine: at_xdmac: Declare slave capabilities for the generic code

Maxime Ripard (59):
      serial: at91: Use dmaengine_slave_config API
      crypto: ux500: Use dmaengine_terminate_all API
      dmaengine: Make the destination abbreviation coherent
      dmaengine: Rework dma_chan_get
      dmaengine: Make channel allocation callbacks optional
      dmaengine: Introduce a device_config callback
      dmaengine: split out pause/resume operations from device_control
      dmaengine: Add device_terminate_all callback
      dmaengine: Remove the need to declare device_control
      dmaengine: Create a generic dma_slave_caps callback
      dmaengine: pl08x: Split device_control
      dmaengine: hdmac: Split device_control
      dmaengine: bcm2835: Split device_control
      dmaengine: coh901318: Split device_control
      dmaengine: cppi41: Split device_control
      dmaengine: jz4740: Split device_control
      dmaengine: dw: Split device_control
      dmaengine: edma: Split device_control
      dmaengine: ep93xx: Split device_control
      dmaengine: fsl-edma: Split device_control
      dmaengine: imx: Split device_control
      dmaengine: imx-sdma: Split device_control
      dmaengine: intel-mid-dma: Split device_control
      dmaengine: ipu-idmac: Split device_control
      dmaengine: k3: Split device_control
      dmaengine: mmp-pdma: Split device_control
      dmaengine: mmp-tdma: Split device_control
      dmaengine: moxart: Split device_control
      dmaengine: fsl-dma: Split device_control
      dmaengine: mpc512x: Split device_control
      dmaengine: mxs: Split device_control
      dmaengine: nbpfaxi: Split device_control
      dmaengine: omap: Split device_control
      dmaengine: pl330: Split device_control
      dmaengine: bam-dma: Split device_control
      dmaengine: s3c24xx: Split device_control
      dmaengine: sa11x0: Split device_control
      dmaengine: sh: Split device_control
      dmaengine: sirf: Split device_control
      dmaengine: sun6i: Split device_control
      dmaengine: d40: Split device_control
      dmaengine: tegra20: Split device_control
      dmaengine: xilinx: Split device_control
      dmaengine: mv_xor: Remove device_control
      dmaengine: pch-dma: Rename device_control
      dmaengine: td: Rename device_control
      dmaengine: txx9: Rename device_control
      dmaengine: rapidio: tsi721: Rename device_control
      dmaengine: bcm2835: Declare slave capabilities for the generic code
      dmaengine: fsl-edma: Declare slave capabilities for the generic code
      dmaengine: edma: Declare slave capabilities for the generic code
      dmaengine: nbpfaxi: Declare slave capabilities for the generic code
      dmaengine: omap: Declare slave capabilities for the generic code
      dmaengine: pl330: Declare slave capabilities for the generic code
      dmaengine: sirf: Declare slave capabilities for the generic code
      dmaengine: sun6i: Declare slave capabilities for the generic code
      dmaengine: Add a warning for drivers not using the generic slave caps=
 retrieval
      dmaengine: Remove device_control and device_slave_caps
      Documentation: dmaengine: Update the documentation

 Documentation/dmaengine/provider.txt  |  93 ++++++++--------
 drivers/crypto/ux500/cryp/cryp_core.c |   4 +-
 drivers/crypto/ux500/hash/hash_core.c |   2 +-
 drivers/dma/amba-pl08x.c              | 156 +++++++++++++++------------
 drivers/dma/at_hdmac.c                | 121 ++++++++++++---------
 drivers/dma/at_xdmac.c                | 127 ++++++++++++----------
 drivers/dma/bcm2835-dma.c             |  46 ++------
 drivers/dma/coh901318.c               | 137 +++++++++++------------
 drivers/dma/cppi41.c                  |  30 +-----
 drivers/dma/dma-jz4740.c              |  20 +---
 drivers/dma/dmaengine.c               |  51 +++++----
 drivers/dma/dw/core.c                 |  82 +++++++-------
 drivers/dma/edma.c                    |  70 ++++--------
 drivers/dma/ep93xx_dma.c              |  41 ++-----
 drivers/dma/fsl-edma.c                | 123 ++++++++++-----------
 drivers/dma/fsldma.c                  |  91 ++++++----------
 drivers/dma/imx-dma.c                 | 103 +++++++++---------
 drivers/dma/imx-sdma.c                |  66 ++++++------
 drivers/dma/intel_mid_dma.c           |  25 ++---
 drivers/dma/ipu/ipu_idmac.c           |  96 +++++++++--------
 drivers/dma/k3dma.c                   | 197 ++++++++++++++++++------------=
----
 drivers/dma/mmp_pdma.c                | 109 ++++++++++---------
 drivers/dma/mmp_tdma.c                |  82 +++++++-------
 drivers/dma/moxart-dma.c              |  25 +----
 drivers/dma/mpc512x_dma.c             | 111 +++++++++----------
 drivers/dma/mv_xor.c                  |   9 --
 drivers/dma/mxs-dma.c                 |  59 ++++------
 drivers/dma/nbpfaxi.c                 | 110 +++++++++----------
 drivers/dma/omap-dma.c                |  69 ++++--------
 drivers/dma/pch_dma.c                 |   8 +-
 drivers/dma/pl330.c                   | 126 ++++++++++------------
 drivers/dma/qcom_bam_dma.c            |  85 +++++++--------
 drivers/dma/s3c24xx-dma.c             |  75 +++++++------
 drivers/dma/sa11x0-dma.c              | 158 ++++++++++++++-------------
 drivers/dma/sh/shdma-base.c           |  72 ++++++-------
 drivers/dma/sirf-dma.c                |  59 +++-------
 drivers/dma/ste_dma40.c               |  60 +++++------
 drivers/dma/sun6i-dma.c               | 160 ++++++++++++++-------------
 drivers/dma/tegra20-apb-dma.c         |  22 +---
 drivers/dma/timb_dma.c                |   8 +-
 drivers/dma/txx9dmac.c                |   9 +-
 drivers/dma/xilinx/xilinx_vdma.c      |  29 ++---
 drivers/rapidio/devices/tsi721_dma.c  |   8 +-
 drivers/tty/serial/atmel_serial.c     |  10 +-
 include/linux/dmaengine.h             | 121 ++++++++++++---------
 sound/soc/soc-generic-dmaengine-pcm.c |   2 +-
 46 files changed, 1520 insertions(+), 1747 deletions(-)

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfY97AAoJEBx+YmzsjxAgnQYP/0h1jUO5pGEOvc2/JiV+adnR
MTuDE/lQFrE+jSKzdlShxP6GCegYlM9G3Fe2R57h/652SAYMYy1V6wOIzbiZvkh2
g3Z5ZqnB/1XiVLBr3J8oiCePS1gdMcCTYB9XZ1BP32Lo/J2qu9w8V6h8IQPfm2Sb
Hhp1MdRYqk6xusimgR+LaDl+Tc0KjAJ3DemKKAOlI9ZEBgWoNZgYUUtiM+aFiVBx
6jMC8x7xh6mqnLhsdzhFZ6WZ96Ivk7XKK7goygkhP5GK3dZ3pJsnoQRgN9XhvoDh
CjiUjsB7GEMe8uloTibjkSX/8XT8M4RcDlTj9rhK6roopWDsNYDzw5X321UD5Z7T
+ZnmiqQWABAv0bh5vnmfQuqSiLbHQjSWBb08AsqiLbkXcjk0IX+RU49gqgt8t3eb
9M+r/wcHDCCCUkCzjpC74ARHxsL7ryBhH43/ofIkEXbcjoeTGSQP+V6mrn3+Q9Hv
fYJdRgXjptWcNnpVr1Ns1woX8wOC6zJEmSOatYXnQC2Ej7ytc8Wwq0Wox5W6NZLw
g1zxoP6AJWJDfgJBOgsJxGmg/C6b72UnX0Xznvxy0+R/phqk4f5FSkXmf5BD83R8
w8LvFYy6W1WKWghTTy8WK/TFVoZ5Lc001ZqG84nw7PO3pPnXu69JUrUn1ZPl/xH5
3SBixygFTEfyKiRzZSo0
=lwQ2
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
