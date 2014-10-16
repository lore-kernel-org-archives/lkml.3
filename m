Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaJPUVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:21:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:26830 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaJPUU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:20:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,734,1406617200"; 
   d="scan'208";a="590420952"
Date: Fri, 17 Oct 2014 01:15:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dma <dmaengine@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] slave dmaengine updates
Message-ID: <20141016194509.GK1638@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the pull request for current long merge window.
I have merged tags/spi-pxa2xx-clk form spi tree to resolve dependency of few
commits in my tree. You should have recived these one from spi tree.

For dmaengine contributions we have:
- designware cleanup by Andy
- my series moving device_control users to dmanegine_xxx APIs for later removal of
  device_control API
- minor fixes spread over drivers mainly mv_xor, pl330, mmp, imx-sdma etc

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
  Linus Torvalds (1):
        Linux 3.17-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alan Cox (1):
      serial: 8250_pci: Add PCI IDs for Intel Braswell

Andy Gross (1):
      dmaengine: qcom_adm: Add device tree binding

Andy Shevchenko (15):
      dmaengine: dw: move dw_dmac.h to where it belongs to
      avr32: at32ap700x: don't rely on default DMA masters
      dmaengine: dw: convert dw_dma_slave to use explicit HS interfaces
      dmaengine: dw: apply both HS interfaces and remove slave_id usage
      dmaengine: dw: introduce generic filter function
      dmaengine: dw: move clock operations to platform.c
      dmaengine: dw: add PCI IDs for Braswell DMAs
      serial: 8250: don't use slave_id of dma_slave_config
      dmatest: prevent memory leakage on error path in thread
      dmaengine: dw: move private definitions to regs.h
      dmaengine: dw: split dma-dw.h to platform and private parts
      dmaengine: dw: introduce dw_dma_on() helper
      dmaengine: dw: always export dw_dma_{en,dis}able
      dmaengine: dw: enable and disable controller when needed
      dmaengine: dw: export probe()/remove() and Co to users

Arnd Bergmann (1):
      dma: imx-sdma: fix another incorrect __init annotation

Chen-Yu Tsai (1):
      dmaengine: sun6i: Remove obsolete clk muxing code

Chew, Chiau Ee (1):
      spi/pxa2xx-pci: Add common clock framework support in PCI glue layer

Ezequiel Garcia (3):
      dma: mv_xor: Replace printk with dev_info
      dma: mv_xor: Remove all interrupt magic numbers
      dma: mv_xor: Remove dead code

Fabio Estevam (1):
      dma: Kconfig: Include mx6 in the IMX_SDMA help section

Geert Uytterhoeven (1):
      dmaengine: Update documentation for inline wrapper

Kiran Padwal (1):
      dma: cppi41: Switch to using managed resource in probe

Krzysztof Kozlowski (4):
      dmaengine: pl330: Remove non-NULL check for pl330_submit_req parameters
      dmaengine: pl330: Remove unused 'regs' variable in pl330_submit_req()
      dmaengine: pl330: Fix NULL pointer dereference on probe failure
      dmaengine: pl330: Fix NULL pointer dereference on driver unbind

Laurent Pinchart (1):
      dmaengine: Mark the struct dma_slave_config direction field deprecated

Lior Amsalem (4):
      dma: mv_xor: Simplify the DMA_MEMCPY operation
      dma: mv_xor: Remove multi-slot support
      dma: mv_xor: Reduce interrupts by enabling EOD only when needed
      dma: mv_xor: Add support for DMA_INTERRUPT

Mark Brown (1):
      dma: imx-sdma: Remove spurious __init annotation on sdma_probe()

Michal Simek (1):
      dma: xilinx: Remove .owner field for driver

Mika Westerberg (2):
      spi/pxa2xx: Don't use slave_id of dma_slave_config
      spi/pxa2xx-pci: Add support for Intel Braswell

Qiao Zhou (2):
      dmaengine: mmp_tdma: add DMA_PREP_INTERRUPT flag support
      ASoC: mmp-pcm: add NO_PERIOD_WAKEUP for PCM INFO

Ryo Kataoka (1):
      dma: rcar-audmapp: Fix for no corresponding slave ID

Sebastian Andrzej Siewior (1):
      dmaengine: edma: check for echan->edesc => NULL in edma_dma_pause()

Srikanth Thokala (1):
      dma: Add Xilinx AXI DMA DT Binding Documentation

Vignesh Raman (2):
      dma: imx-sdma: use module_platform_driver for SDMA driver
      dma: imx-sdma: Adding tasklet_kill() in sdma_remove function.

Vinod Koul (18):
      Merge commit 'tags/spi-pxa2xx-clk' into for-linus
      pata_arasan_cf: use dmaengine_terminate_all() API
      dmaengine: coh901318: use dmaengine_terminate_all() API
      V4L2: mx3_camer: use dmaengine_pause() API
      mtd: fsmc_nand: use dmaengine_terminate_all() API
      mtd: sh_flctl: use dmaengine_terminate_all() API
      net: ks8842: use dmaengine_terminate_all() API
      serial: sh-sci: use dmaengine_terminate_all() API
      video: mx3fb: use dmaengine_terminate_all() API
      dmaengine: add dmaengine_prep_dma_sg() helper
      dmaengine: freescale: add and export fsl_dma_external_start()
      carma-fpga: use dmaengine_xxx() API
      carma-fpga: move to fsl_dma_external_start()
      dmaengine: freescale: remove FSLDMA_EXTERNAL_START control method
      dmaengine: remove FSLDMA_EXTERNAL_START
      Merge branch 'topic/dma_control_cleanup_acks' into for-linus
      Merge branch 'topic/dma_control_fsl_acks' into for-linus
      serial: atmel: add missing dmaengine header

 Documentation/devicetree/bindings/dma/qcom_adm.txt |   62 +++++
 .../devicetree/bindings/dma/xilinx/xilinx_dma.txt  |   65 +++++
 Documentation/dmaengine.txt                        |    4 +-
 MAINTAINERS                                        |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |   19 +-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h    |    2 +-
 drivers/ata/pata_arasan_cf.c                       |    5 +-
 drivers/dma/Kconfig                                |    2 +-
 drivers/dma/coh901318.c                            |    2 +-
 drivers/dma/cppi41.c                               |   16 +-
 drivers/dma/dmatest.c                              |    4 +-
 drivers/dma/dw/core.c                              |  147 +++++------
 drivers/dma/dw/internal.h                          |   61 +----
 drivers/dma/dw/pci.c                               |    8 +-
 drivers/dma/dw/platform.c                          |   92 ++++----
 drivers/dma/dw/regs.h                              |   41 +++-
 drivers/dma/edma.c                                 |    2 +-
 drivers/dma/fsldma.c                               |   25 +-
 drivers/dma/imx-sdma.c                             |   35 ++-
 drivers/dma/mmp_tdma.c                             |   19 +-
 drivers/dma/mv_xor.c                               |  268 +++++++-------------
 drivers/dma/mv_xor.h                               |   62 ++---
 drivers/dma/pl330.c                                |   19 +-
 drivers/dma/sh/rcar-audmapp.c                      |   15 +-
 drivers/dma/sun6i-dma.c                            |   23 --
 drivers/dma/xilinx/xilinx_vdma.c                   |    1 -
 drivers/media/platform/soc_camera/mx3_camera.c     |    6 +-
 drivers/misc/carma/carma-fpga-program.c            |   12 +-
 drivers/mtd/nand/fsmc_nand.c                       |    2 +-
 drivers/mtd/nand/sh_flctl.c                        |    2 +-
 drivers/net/ethernet/micrel/ks8842.c               |    6 +-
 drivers/spi/Kconfig                                |    2 +-
 drivers/spi/spi-pxa2xx-dma.c                       |   15 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  122 ++++++++--
 drivers/spi/spi-pxa2xx.c                           |    2 -
 drivers/tty/serial/8250/8250.h                     |    6 +-
 drivers/tty/serial/8250/8250_dw.c                  |    7 +-
 drivers/tty/serial/8250/8250_pci.c                 |   78 +++++-
 drivers/tty/serial/atmel_serial.c                  |    1 +
 drivers/tty/serial/sh-sci.c                        |    2 +-
 drivers/video/fbdev/mx3fb.c                        |    3 +-
 include/linux/dma/dw.h                             |   64 +++++
 include/linux/dmaengine.h                          |   17 +-
 include/linux/dw_dmac.h                            |  111 --------
 include/linux/fsldma.h                             |   13 +
 include/linux/platform_data/dma-dw.h               |   59 +++++
 include/linux/spi/pxa2xx_spi.h                     |    9 +-
 include/sound/atmel-abdac.h                        |    2 +-
 include/sound/atmel-ac97c.h                        |    2 +-
 sound/atmel/abdac.c                                |    4 +-
 sound/atmel/ac97c.c                                |    3 +-
 sound/soc/pxa/mmp-pcm.c                            |    3 +-
 52 files changed, 858 insertions(+), 696 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_adm.txt
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_dma.txt
 create mode 100644 include/linux/dma/dw.h
 delete mode 100644 include/linux/dw_dmac.h
 create mode 100644 include/linux/fsldma.h
 create mode 100644 include/linux/platform_data/dma-dw.h

Thanks
-- 
~Vinod
