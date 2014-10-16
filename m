Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaJPGrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:47:41 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64027 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaJPGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:47:39 -0400
Date: Wed, 15 Oct 2014 23:47:35 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [GIT PULL] MTD updates for 3.18
Message-ID: <20141016064735.GE22169@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for delaying this a bit later than usual. There's one mild
regression from 3.16 that was noticed during the 3.17 cycle, and I meant
to send a fix for it along with this pull request. I'll probably try to
queue it up for a later pull request once I've had a better look at it,
hopefully by -rc2 at the latest.

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20141015

for you to fetch changes up to 8b3d58e554453ab858bbb169d93b7321bdc628d4:

  mtd: nand: omap: Correct CONFIG_MTD_NAND_OMAP_BCH help message (2014-10-06 23:40:09 -0700)

----------------------------------------------------------------
MTD updates for 3.18

NAND
 * Cleanup for Denali driver
 * Atmel: add support for new page sizes
 * Atmel: fix up 'raw' mode support
 * Atmel: miscellaneous cleanups
 * New timing mode helpers for non-ONFI NAND
 * OMAP: allow driver to be (properly) built as a module
 * bcm47xx: RESET support and other cleanups

SPI NOR
 * Miscellaneous cleanups, to prepare framework for wider use (some further
   work still pending)
 * Compile-time configuration to select 4K vs. 64K support for flash that
   support both (necessary for using UBIFS on some SPI NOR)

A few scattered code quality fixes, detected by Coverity

See the changesets for more.

----------------------------------------------------------------
Aaron Sierra (2):
      mtd: physmap_of: Fix ROM support via OF
      mtd: physmap_of: Add non-obsolete map_rom probe

Aaron Wu (1):
      mtd: gpio_flash: handle case where offset + len exceeds the window size

Boris BREZILLON (3):
      mtd: nand: atmel_nand: retrieve NFC clock
      mtd: nand: support ONFI timing mode retrieval for non-ONFI NANDs
      mtd: nand: add Hynix's H27UCG8T2ATR-BC to nand_ids table

Brian Norris (16):
      mtd: cfi_cmdset_0002: allow retry/timeout loop to exit
      mtd: correct upper bounds check for mtd_*() APIs
      mtd: sm_ftl: initialize error code
      mtd: remove dead non-char logic
      mtd: mtdswap: fix integer overflow
      mtd: tests: fix integer overflow issues
      mtd: use __packed shorthand
      mtd: nand: denali: set proper error code on timeout
      mtd: nandsim: fix integer widening
      mtd: maps: solutionengine: drop excess dependency
      mtd: nand: fix integer widening problems
      mtd: terminate user-provided string
      Merge l2-mtd/next into l2-mtd/master
      Merge tag 'v3.17-rc5' from upstream
      mtd: denali: remove another set-but-unused variable
      MAINTAINERS: add l2-mtd.git, 'next' tree for MTD

Dan Carpenter (1):
      mtd: ndfc: silence an array underflow static checker warning

Ezequiel Garcia (1):
      mtd: nand: Force omap_elm to be built as a module if omap2_nand is a module

Ezequiel García (4):
      nand: omap2: Add support for flash-based bad block table
      nand: omap2: Remove horrible ifdefs to fix module probe
      nand: omap2: Replace pr_err with dev_err
      mtd: nand: Move ELM driver and rename as omap_elm

Geert Uytterhoeven (1):
      mtd: nand: Use ULL-suffix for big u64 constant

Martin Kepplinger (1):
      mtd: use NULL instead of 0 for an address

Masahiro Yamada (9):
      mtd: denali: avoid using a magic number
      mtd: denali: fix the format of comment blocks
      mtd: denali: remove unnecessary variable initializations
      mtd: denali: remove unnecessary casts
      mtd: denali: change the type of iterators to int
      mtd: denali: remove a set-but-unused variable
      mtd: denali: fix include guard and license block of denali.h
      mtd: denali: remove unnecessary parentheses
      mtd: denali: fix indents and other trivial things

Rafał Miłecki (11):
      mtd: spi-nor: remove duplicated w25q128 entry
      mtd: spi-nor: drop jedec_probe /helper/ function
      mtd: bcm47xxpart: find NVRAM partitions in middle blocks
      mtd: bcm47xxnflash: fix typo in freq calculation
      mtd: bcm47xxnflash: add dev_ready and fill chip_delay
      mtd: bcm47xxnflash: add cmd_ctrl handler
      mtd: bcm47xxnflash: NAND_CMD_RESET support
      mtd: bcm47xxnflash: replace some magic numbers
      mtd: nand: don't break long print messages
      mtd: spi-nor: add Kconfig option to disable 4K sectors
      mtd: move support for struct flash_platform_data into m25p80

Randy Dunlap (1):
      mtd: fix linux/mtd/nand.h kernel-doc warning

Raphaël Poggi (1):
      mtd: atmel_nand: increase chip_delay

Roger Quadros (1):
      mtd: nand: omap: Correct CONFIG_MTD_NAND_OMAP_BCH help message

Samarth Parikh (1):
      mtd: Fixed checkpatch seq_printf warnings

Thomas Petazzoni (1):
      mtd: spi-nor: add support for Micron M25PX80

Wei Yongjun (1):
      mtd: atmel_nand: remove redundant dev_err call

White Ding (1):
      mtd: nand: fix nand_lock/unlock() function

Wu, Josh (4):
      mtd: atmel_nand: add pmecc support for 512, 1k, 4k, 8k page size
      mtd: atmel_nand: NFC: fix mtd_nandbiterrs.ko test fail when using sram write
      mtd: atmel_nand: remove pmecc_sector_number, use ecc.steps instead
      mtd: atmel_nand: remove pmecc_bytes_per_sector, use chip->ecc.bytes instead

 .../devicetree/bindings/mtd/atmel-nand.txt         |   2 +
 .../devicetree/bindings/mtd/mtd-physmap.txt        |   4 +-
 MAINTAINERS                                        |   1 +
 arch/arm/mach-omap2/gpmc.c                         |   2 +
 drivers/mtd/bcm47xxpart.c                          |  11 +
 drivers/mtd/chips/cfi_cmdset_0002.c                |   2 +
 drivers/mtd/devices/Makefile                       |   1 -
 drivers/mtd/devices/docg3.c                        |  26 +-
 drivers/mtd/devices/m25p80.c                       |  22 +-
 drivers/mtd/maps/Kconfig                           |   2 +-
 drivers/mtd/maps/gpio-addr-flash.c                 |  42 +-
 drivers/mtd/maps/pcmciamtd.c                       |   2 +-
 drivers/mtd/maps/physmap_of.c                      |   6 +-
 drivers/mtd/mtdchar.c                              |   3 +
 drivers/mtd/mtdcore.c                              |  39 +-
 drivers/mtd/mtdswap.c                              |   8 +-
 drivers/mtd/nand/Kconfig                           |   7 +-
 drivers/mtd/nand/Makefile                          |   1 +
 drivers/mtd/nand/atmel_nand.c                      |  96 ++--
 drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c       |  57 ++-
 drivers/mtd/nand/denali.c                          | 565 +++++++++++----------
 drivers/mtd/nand/denali.h                          |  27 +-
 drivers/mtd/nand/nand_base.c                       |  38 +-
 drivers/mtd/nand/nand_bbt.c                        |  23 +-
 drivers/mtd/nand/nand_ids.c                        |   4 +
 drivers/mtd/nand/nand_timings.c                    |   2 +-
 drivers/mtd/nand/nandsim.c                         |   2 +-
 drivers/mtd/nand/ndfc.c                            |   3 +-
 drivers/mtd/nand/omap2.c                           | 166 +++---
 drivers/mtd/{devices/elm.c => nand/omap_elm.c}     |   0
 drivers/mtd/nand/sm_common.h                       |   2 +-
 drivers/mtd/sm_ftl.c                               |   2 +-
 drivers/mtd/spi-nor/Kconfig                        |  14 +
 drivers/mtd/spi-nor/spi-nor.c                      |  42 +-
 drivers/mtd/tests/mtd_test.c                       |   4 +-
 drivers/mtd/tests/nandbiterrs.c                    |   2 +-
 drivers/mtd/tests/oobtest.c                        |   8 +-
 drivers/mtd/tests/pagetest.c                       |   4 +-
 drivers/mtd/tests/readtest.c                       |   2 +-
 drivers/mtd/tests/speedtest.c                      |  14 +-
 drivers/mtd/tests/subpagetest.c                    |  10 +-
 include/linux/mtd/cfi.h                            |  22 +-
 include/linux/mtd/nand.h                           |  12 +
 include/linux/platform_data/elm.h                  |  16 +
 include/linux/platform_data/mtd-nand-omap2.h       |   1 +
 45 files changed, 757 insertions(+), 562 deletions(-)
 rename drivers/mtd/{devices/elm.c => nand/omap_elm.c} (100%)
