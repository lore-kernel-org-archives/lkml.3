Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638Ab3JPRaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:30:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:23462 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760991Ab3JPRWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417850844"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 00/28]: dmaengine: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:18 +0530
Message-Id: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we recently discussed in [1], the DMA_SUCCESS is an misnomer. The dmaengine
does not acknowledge that dma completed succesfully. It can only signal dma was
completed by it. Hence we should use DMA_COMPLTE as status instead of
DMA_SUCCESS

[1]: http://www.spinics.net/lists/arm-kernel/msg278346.html 

Vinod Koul (28):
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

 crypto/async_tx/async_tx.c    |    4 ++--
 drivers/dma/amba-pl08x.c      |    4 ++--
 drivers/dma/at_hdmac.c        |    2 +-
 drivers/dma/coh901318.c       |    2 +-
 drivers/dma/cppi41.c          |    2 +-
 drivers/dma/dma-jz4740.c      |    2 +-
 drivers/dma/dmaengine.c       |    2 +-
 drivers/dma/dmatest.c         |    2 +-
 drivers/dma/dw/core.c         |    4 ++--
 drivers/dma/edma.c            |    2 +-
 drivers/dma/imx-dma.c         |    2 +-
 drivers/dma/imx-sdma.c        |    2 +-
 drivers/dma/intel_mid_dma.c   |    4 ++--
 drivers/dma/ioat/dma.c        |    4 ++--
 drivers/dma/ioat/dma_v3.c     |    8 ++++----
 drivers/dma/iop-adma.c        |   16 ++++++++--------
 drivers/dma/k3dma.c           |    2 +-
 drivers/dma/mmp_tdma.c        |    6 +++---
 drivers/dma/mv_xor.c          |    6 +++---
 drivers/dma/mxs-dma.c         |    6 +++---
 drivers/dma/omap-dma.c        |    2 +-
 drivers/dma/ppc4xx/adma.c     |    2 +-
 drivers/dma/sa11x0-dma.c      |    2 +-
 drivers/dma/sh/shdma-base.c   |    2 +-
 drivers/dma/ste_dma40.c       |    2 +-
 drivers/dma/tegra20-apb-dma.c |    4 ++--
 drivers/dma/txx9dmac.c        |    4 ++--
 drivers/tty/serial/sh-sci.c   |    2 +-
 include/linux/dmaengine.h     |   12 ++++++------
 net/ipv4/tcp.c                |    4 ++--
 30 files changed, 59 insertions(+), 59 deletions(-)


Thanks
~Vinod
