Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaA1HqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:46:18 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42471 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaA1HqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:46:16 -0500
Date: Mon, 27 Jan 2014 23:46:11 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MTD changes for 3.14
Message-ID: <20140128074611.GH3162@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the MTD updates for 3.14. Sorry, I still haven't gotten many
useful signatures on my key yet. I don't know too many local developers
in your web of trust. I'll try to get to a conference soon enough.

Notably, I'm adding myself to MAINTAINERS. I've gotten an ack from Artem
(an unofficial maintainer), but David's ack would be nice.

Regards,
Brian

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140127

for you to fetch changes up to 0ff76a920e3558307567b45aa0a91fb914924bfc:

  mtd: gpmi: add sanity check when mapping DMA for read_buf/write_buf (2014-01-27 21:55:03 -0800)

----------------------------------------------------------------
MTD updates for 3.14:
 - Add me (Brian Norris) as an additional MTD maintainer (it'd be nice to get
   David's "ack" for this; I'm sure he approves, but he's been pretty silent
   lately)
 - Add Ezequiel Garcia as maintainer for the pxa3xx NAND driver
 - Last (?) round of pxa3xx improvements for supporting Armada 370/XP
 - Typical churn in driver boilerplate (OOM messages, printk()'s, devm_*, etc.)
 - Quad read mode support for SPI NOR driver (m25p80)
 - Update Davinci NAND driver to prepare for use on new platforms
 - Begin to kill off NAND_MAX_{PAGE,OOB}SIZE macros; more work is pending
 - Miscellaneous NAND device support (new IDs)
 - Add READ RETRY support for Micron MLC NAND
 - Support new GPMI NAND ECC layout device-tree binding
 - Avoid mapping stack/vmalloc() memory for GPMI NAND DMA

----------------------------------------------------------------
Alexander Shiyan (1):
      mtd: nand: diskonchip: Request memory region prior ioremap()

Axel Lin (3):
      mtd: convert to use ATTRIBUTE_GROUPS
      mtd: make deregister_mtd_parser return void
      mtd: make register_mtd_parser return void

Brian Norris (14):
      mtd: nand: pxa3xx: make ECC configuration checks more explicit
      mtd: nand: fix misspelling in ONFI parameter field name
      MAINTAINERS: mtd: add Brian Norris for MTD maintenance
      mtd: nand: lpc32xx_mlc: drop custom write_page callback
      mtd: nand-gpio: don't waste memory for OF failure
      mtd: omap2: use nand_base defaults for polled I/O
      mtd: onenand: fix warning (integer used as pointer)
      mtd: nand: localize ECC failures per page
      mtd: nand: add ONFI vendor block for Micron
      mtd: nand: add generic READ RETRY support
      mtd: nand: support Micron READ RETRY
      mtd: nand: use __packed shorthand
      mtd: m25p80: assign default read command
      mtd: mtdram: add missing 'const'

Cai Zhiyong (1):
      mtd: nand: assign mtd->name in find_full_id_nand

Ezequiel Garcia (33):
      mtd: nand: omap2: Fix OMAP_BCH option dependency
      mtd: nand: pxa3xx: devicetree binding update
      mtd: nand: pxa3xx: Add documentation about the controller
      mtd: nand: pxa3xx: Make config menu show supported platforms
      mtd: nand: pxa3xx: Prevent sub-page writes
      mtd: nand: pxa3xx: read_page() returns max_bitflips
      mtd: nand: pxa3xx: Early variant detection
      mtd: nand: pxa3xx: Use chip->cmdfunc instead of the internal
      mtd: nand: pxa3xx: Split FIFO size from to-be-read FIFO count
      mtd: nand: pxa3xx: Replace host->page_size by mtd->writesize
      mtd: nand: pxa3xx: Add a nice comment to pxa3xx_set_datasize()
      mtd: nand: pxa3xx: Use a completion to signal device ready
      mtd: nand: pxa3xx: Use waitfunc() to wait for the device to be ready
      mtd: nand: pxa3xx: Add bad block handling
      mtd: nand: pxa3xx: Add driver-specific ECC BCH support
      mtd: nand: pxa3xx: Clear cmd buffer #3 (NDCB3) on command start
      mtd: nand: pxa3xx: Add helper function to set page address
      mtd: nand: pxa3xx: Remove READ0 switch/case falltrough
      mtd: nand: pxa3xx: Split prepare_command_pool() in two stages
      mtd: nand: pxa3xx: Move the data buffer clean to prepare_start_command()
      mtd: nand: pxa3xx: Fix SEQIN column address set
      mtd: nand: pxa3xx: Add a read/write buffers markers
      mtd: nand: pxa3xx: Introduce multiple page I/O support
      mtd: nand: pxa3xx: Add multiple chunk write support
      mtd: nand: pxa3xx: Add ECC BCH correctable errors detection
      mtd: nand: refactor print messages
      MAINTAINERS: mtd: add PXA3xx NAND driver to MAINTAINERS
      mtd: nand: sh_flctl: Remove unneeded CONFIG_OF
      mtd: nand: pxa3xx: Clear need_wait flag when starting a command
      mtd: nand: pxa3xx: Use extended cmdfunc() only if needed
      mtd: nand: pxa3xx: Consolidate ECC initialization
      mtd: Hide CONFIG_MTD_BLKDEVS from the menu
      mtd: nand: pxa3xx: Add "armada370-nand" compatible

Fabio Estevam (4):
      mtd: gpmi: Use devm_clk_get()
      mtd: gpmi-lib: Make checkpatch happy
      mtd: nand: mxc_nand: Check the return value from clk_prepare_enable()
      mtd: tests: mtd_nandecctest: Use IS_ENABLED() macro

Geert Uytterhoeven (7):
      mtd: remove superfluous name casts
      mtd: pasemi_nand.c: remove superfluous name cast
      mtd: ms02-nv: remove superfluous name cast
      mtd: make mtd_partition.name const
      mtd: m25p80: Use OPCODE_QUAD_READ_4B for 4-byte addressing
      mtd: m25p80: Enable Quad SPI read transfers for s25fl512s
      mtd: m25p80: Set rx_nbits for Quad SPI transfers

Huang Shijie (17):
      mtd: gpmi: add a new DT property to use the datasheet's minimum required ECC
      mtd: gpmi: do not use the local array to do the DMA transfer
      mtd: gpmi: delete the gpmi_pre_bbt_scan
      mtd: gpmi: remove the unused line
      mtd: gpmi: rename the functions from gpmi_nfc_* to gpmi_nand_*
      mtd: gpmi: use devm_ioremap_resource
      mtd: gpmi: use devm_request_irq
      mtd: gpmi: remove the unnecessary pr_err()
      mtd: gpmi: change pr_err to dev_err
      mtd: gpmi: change pr_debug to dev_dbg
      mtd: mxc-nand: kill the NAND_MAX_PAGESIZE/NAND_MAX_OOBSIZE
      mtd: denali: kill the NAND_MAX_PAGESIZE/NAND_MAX_OOBSIZE
      mtd: nand: add support for Samsung K9LCG08U0B
      mtd: nand: add SanDisk manufacturer ID
      mtd: nand: add Intel manufacturer ID
      mtd: gpmi: allocate a proper buffer for non ECC read/write
      mtd: gpmi: add sanity check when mapping DMA for read_buf/write_buf

Igor Grinberg (1):
      mtd: m25p80: add support for m25px16

Ivan Khoronzhuk (9):
      mtd: nand: davinci: fix driver registration
      mtd: nand: davinci: return ENOMEM if memory allocation is failed
      mtd: nand: davinci: check required ti,davinci-chipselect property
      mtd: nand: davinci: simplify error handling
      mtd: nand: davinci: move bindings under mtd
      mtd: nand: davinci: extend description of bindings
      mtd: nand: davinci: adjust DT properties to MTD generic
      mtd: nand: davinci: reuse driver for Keystone arch
      mtd: nand: davinci: don't request AEMIF address range

Jingoo Han (36):
      mtd: dataflash: remove unnecessary spi_set_drvdata()
      mtd: denali: remove DEFINE_PCI_DEVICE_TABLE macro
      mtd: docg3: Use devm_*() functions
      mtd: lantiq-flash: Use devm_kzalloc()
      mtd: denali_dt: Use devm_clk_get()
      mtd: lpc32xx_slc: Use devm_*() functions
      mtd: nuc900_nand: Use devm_*() functions
      mtd: tmio_nand: Use devm_*() functions
      mtd: atmel_nand: Remove unnecessary OOM messages
      mtd: orion_nand: Remove unnecessary OOM messages
      mtd: sharpsl: Remove unnecessary OOM messages
      mtd: au1550nd: Remove unnecessary OOM messages
      mtd: bf5xx_nand: Remove unnecessary OOM messages
      mtd: cafe_nand: Remove unnecessary OOM messages
      mtd: cmx270_nand: Remove unnecessary OOM messages
      mtd: cs553x_nand: Remove unnecessary OOM messages
      mtd: diskonchip: Remove unnecessary OOM messages
      mtd: fsl_elbc_nand: Remove unnecessary OOM messages
      mtd: fsl_ifc_nand: Remove unnecessary OOM messages
      mtd: jz4740_nand: Remove unnecessary OOM messages
      mtd: txx9ndfmc: Remove unnecessary OOM messages
      mtd: davinci_nand: Remove unnecessary OOM messages
      mtd: fsmc_nand: Remove unnecessary OOM messages
      mtd: nand-gpio: Remove unnecessary OOM messages
      mtd: lpc32xx_mlc: Remove unnecessary OOM messages
      mtd: lpc32xx_slc: Remove unnecessary OOM messages
      mtd: mpc5121_nfc: Remove unnecessary OOM messages
      mtd: s3c2410: Remove unnecessary OOM messages
      mtd: sh_flctl: Remove unnecessary OOM messages
      mtd: atmel_nand: use dev_err() instead of printk()
      mtd: fsmc_nand: use dev_warn() instead of printk()
      mtd: orion_nand: use dev_err() instead of printk()
      mtd: sharpsl: use dev_err() instead of printk()
      mtd: ixp4xx: Use devm_*() functions
      mtd: plat_nand: Use devm_*() functions
      mtd: plat_nand: Remove unnecessary OOM messages

Josh Triplett (1):
      mtd: denali: Drop print of build date/time

Laurent Pinchart (3):
      mtd: sh_flctl: enable driver compilation with COMPILE_TEST
      mtd: sh_flctl: fix warnings due to improper casts
      mtd: sh_flctl: use devm_* managed allocators

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Philipp Rosenberger (1):
      of_mtd: fix header file include guard

Prabhakar Kushwaha (1):
      mtd: nand: Update mtd.name assignment type to u64 for IFC, eLBC

Rafał Miłecki (2):
      mtd: bcm47xxpart: find boot partition by CFE magic
      mtd: bcm47xxpart: alternative MAGIC for board_data partition

Rashika Kheria (2):
      mtd: lpddr: Mark functions as static and remove unused function
      mtd: denali: Mark function is_erased() as static

Rodolfo Giometti (1):
      mtd: nand: pxa3xx: Add support for 2048 bytes page size devices

Sachin Kamat (4):
      mtd: omap2: Cleanup header files
      mtd: orion: Cleanup mtd-orion_nand.h header
      mtd: onenand: Trivial cleanup in samsung.h
      mtd: s3c2410: Merge plat/regs-nand.h into s3c2410.c

Sourav Poddar (2):
      drivers: mtd: m25p80: convert "bool" read check into an enum
      drivers: mtd: m25p80: add quad read support

Uwe Kleine-König (1):
      mtd: nand: don't use {read,write}_buf for 8-bit transfers

Wei Yongjun (5):
      mtd: mpc5121_nfc: drop devm_free_irq of devm_ allocated irq
      mtd: mxc_nand: add missing clk_disable_unprepare() in mxcnd_remove()
      mtd: au1550nd: add missing platform_set_drvdata()
      mtd: plat_nand: remove redundant return value check of platform_get_resource()
      mtd: nuc900_nand: remove redundant return value check of platform_get_resource()

Zhouyi Zhou (1):
      jffs2: NULL return of kmem_cache_zalloc should be handled

 .../devicetree/bindings/arm/davinci/nand.txt       |  46 --
 .../devicetree/bindings/mtd/davinci-nand.txt       |  94 +++
 .../devicetree/bindings/mtd/gpmi-nand.txt          |   8 +
 .../devicetree/bindings/mtd/pxa3xx-nand.txt        |   6 +-
 Documentation/mtd/nand/pxa3xx-nand.txt             | 113 ++++
 MAINTAINERS                                        |   9 +-
 arch/arm/plat-samsung/include/plat/regs-nand.h     | 123 ----
 drivers/mtd/Kconfig                                |   7 +-
 drivers/mtd/afs.c                                  |   3 +-
 drivers/mtd/ar7part.c                              |   3 +-
 drivers/mtd/bcm47xxpart.c                          |  27 +-
 drivers/mtd/bcm63xxpart.c                          |   3 +-
 drivers/mtd/cmdlinepart.c                          |   3 +-
 drivers/mtd/devices/docg3.c                        |  20 +-
 drivers/mtd/devices/m25p80.c                       | 226 ++++++-
 drivers/mtd/devices/ms02-nv.c                      |   2 +-
 drivers/mtd/devices/mtd_dataflash.c                |   5 +-
 drivers/mtd/devices/mtdram.c                       |   2 +-
 drivers/mtd/lpddr/lpddr_cmds.c                     |  32 +-
 drivers/mtd/maps/ixp4xx.c                          |  28 +-
 drivers/mtd/maps/lantiq-flash.c                    |  37 +-
 drivers/mtd/maps/pxa2xx-flash.c                    |   2 +-
 drivers/mtd/maps/sun_uflash.c                      |   2 +-
 drivers/mtd/mtdcore.c                              |  10 +-
 drivers/mtd/mtdpart.c                              |   9 +-
 drivers/mtd/nand/Kconfig                           |  14 +-
 drivers/mtd/nand/atmel_nand.c                      |   8 +-
 drivers/mtd/nand/au1550nd.c                        |   6 +-
 drivers/mtd/nand/bf5xx_nand.c                      |   1 -
 drivers/mtd/nand/cafe_nand.c                       |   4 +-
 drivers/mtd/nand/cmx270_nand.c                     |   1 -
 drivers/mtd/nand/cs553x_nand.c                     |   1 -
 drivers/mtd/nand/davinci_nand.c                    |  93 +--
 drivers/mtd/nand/denali.c                          |  53 +-
 drivers/mtd/nand/denali.h                          |   4 +-
 drivers/mtd/nand/denali_dt.c                       |   4 +-
 drivers/mtd/nand/denali_pci.c                      |   3 +-
 drivers/mtd/nand/diskonchip.c                      |  13 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |   3 +-
 drivers/mtd/nand/fsl_ifc_nand.c                    |   3 +-
 drivers/mtd/nand/fsmc_nand.c                       |  16 +-
 drivers/mtd/nand/gpio.c                            |  12 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              | 127 ++--
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             | 207 +++---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |   2 -
 drivers/mtd/nand/jz4740_nand.c                     |   4 +-
 drivers/mtd/nand/lpc32xx_mlc.c                     |  26 +-
 drivers/mtd/nand/lpc32xx_slc.c                     |  19 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |  10 +-
 drivers/mtd/nand/mxc_nand.c                        |  25 +-
 drivers/mtd/nand/nand_base.c                       | 183 +++++-
 drivers/mtd/nand/nand_ids.c                        |   2 +
 drivers/mtd/nand/nuc900_nand.c                     |  54 +-
 drivers/mtd/nand/omap2.c                           |   8 +-
 drivers/mtd/nand/orion_nand.c                      |   4 +-
 drivers/mtd/nand/pasemi_nand.c                     |   2 +-
 drivers/mtd/nand/plat_nand.c                       |  40 +-
 drivers/mtd/nand/pxa3xx_nand.c                     | 713 +++++++++++++++++----
 drivers/mtd/nand/s3c2410.c                         |  38 +-
 drivers/mtd/nand/sh_flctl.c                        |  55 +-
 drivers/mtd/nand/sharpsl.c                         |   6 +-
 drivers/mtd/nand/tmio_nand.c                       |  46 +-
 drivers/mtd/nand/txx9ndfmc.c                       |   5 +-
 drivers/mtd/ofpart.c                               |  19 +-
 drivers/mtd/onenand/generic.c                      |   2 +-
 drivers/mtd/onenand/samsung.h                      |   2 -
 drivers/mtd/redboot.c                              |   3 +-
 drivers/mtd/tests/mtd_nandecctest.c                |   2 +-
 fs/jffs2/malloc.c                                  |   4 +
 include/linux/mtd/mtdram.h                         |   2 +-
 include/linux/mtd/nand.h                           |  41 +-
 include/linux/mtd/partitions.h                     |   8 +-
 include/linux/of_mtd.h                             |   2 +-
 include/linux/platform_data/mtd-nand-omap2.h       |   2 -
 include/linux/platform_data/mtd-nand-pxa3xx.h      |   3 +
 include/linux/platform_data/mtd-onenand-omap2.h    |   2 -
 include/linux/platform_data/mtd-orion_nand.h       |   6 +-
 77 files changed, 1688 insertions(+), 1045 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt
 create mode 100644 Documentation/mtd/nand/pxa3xx-nand.txt
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-nand.h
