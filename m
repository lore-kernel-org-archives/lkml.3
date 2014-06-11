Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaFKHF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:05:59 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56571 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFKHF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:05:57 -0400
Date: Wed, 11 Jun 2014 00:05:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [GIT PULL] MTD updates for 3.16-rc1
Message-ID: <20140611070544.GA17699@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140610

for you to fetch changes up to f1900c79633e9ed757319e63aefb8e29443ea35e:

  Merge MTD pullreq from 3.15-rc5 (2014-06-10 23:21:12 -0700)

----------------------------------------------------------------

MTD updates for 3.16:
- refactor m25p80.c driver for use as a general SPI NOR framework for other
  drivers which may speak to SPI NOR flash without providing full SPI support
  (i.e., not part of drivers/spi/)
- new Freescale QuadSPI driver (utilizing new SPI NOR framework)
- updates for the STMicro "FSM" SPI NOR driver
- fix sync/flush behavior on mtd_blkdevs
- fixup subpage write support on a few NAND drivers
- correct the MTD OOB test for odd-sized OOB areas
- add BCH-16 support for OMAP NAND
- fix warnings and trivial refactoring
- utilize new ECC DT bindings in pxa3xx NAND driver
- new LPDDR NVM driver
- address a few assorted bugs caught by Coverity
- add new imx6sx support for GPMI NAND
- use a bounce buffer for NAND when non-DMA-able buffers are used

----------------------------------------------------------------
Aaron Sierra (1):
      mtd: fsl_ifc_nand: Use void type for IFC buffer

Akinobu Mita (1):
      mtd: mtd_oobtest: generate consistent data for verification

Angus Clark (6):
      mtd: st_spi_fsm: Add Macronix MX25L25655E device
      mtd: st_spi_fsm: Update Macronix 32-bit addressing support
      mtd: st_spi_fsm: Update Macronix 'QE' configuration
      mtd: st_spi_fsm: Refactor status register operations
      mtd: st_spi_fsm: Add Spansion S25FL032P to device table
      mtd: st_spi_fsm: Add support for Macronix MX25L3255E

Arnd Bergmann (1):
      mtd: onenand: fix build warning for dma type

Brian Norris (25):
      mtd: m25p80: use the SPI nor framework
      mtd: spi-nor: EXPORT symbols which could be used by module drivers
      mtd: spi-nor: drop \t after #define
      mtd: spi-nor: re-name OPCODE_* to SPINOR_OP_*
      mtd: spi-nor: unify read opcode variants with ST SPI FSM
      Documentation: spi-nor: rewrite some portions
      mtd: spi-nor: shorten Kconfig naming
      mtd: st_spi_fsm: fixup Kconfig dependency
      mtd: st_spi_fsm: kill duplicate CMD definitions
      mtd: st_spi_fsm: replace FLACH_CMD_* with SPINOR_OP_*
      mtd: st_spi_fsm: begin using spi-nor.h opcodes
      mtd: spi-nor: allow to be built as module
      mtd: fsl-quadspi: fix __iomem annotations
      mtd: st_spi_fsm: correct type issues
      mtd: st_spi_fsm: only build for ARM
      Merge branch 'spinor'
      mtd: nand: refactor erase_cmd() to return chip status
      mtd: lpddr: fix Kconfig dependency, for I/O accessors
      mtd: pfow: remove unused variable
      mtd: slram: fix unused variable warning
      mtd: maps: sc520cdp: fix warnings
      mtd: nand_bbt: remove unused variable
      mtd: nand_bbt: handle error case for nand_create_badblock_pattern()
      mtd: nand: r852: correct write_buf loop bounds
      Merge MTD pullreq from 3.15-rc5

Christian Engelmayer (1):
      mtd: nand: omap: fix compile warning on ‘erased_sector_bitflips’

Dan Carpenter (1):
      mtd: cfi: indent some if statements

Ezequiel Garcia (4):
      mtd: nand: Warn the user if the selected ECC strength is too weak
      mtd: nand: pxa3xx: Clean pxa_ecc_init() error handling
      mtd: nand: pxa3xx: Use ECC strength and step size devicetree binding
      mtd: nand: pxa3xx: Add supported ECC strength and step size to the DT binding

Geert Uytterhoeven (3):
      mtd: m25p80: Revive dual read support
      mtd: spi-nor: Enable Dual and Quad SPI read transfers for s25sl032p
      mtd: Fix warning in access_ok() parameter passing

Himangi Saraogi (1):
      mtd: bf5xx_nand: use the managed version of kzalloc

Huang Shijie (11):
      mtd: spi-nor: copy the SPI NOR commands to a new header file
      mtd: spi-nor: add the basic data structures
      mtd: spi-nor: add the framework for SPI NOR
      Documentation: add the document for the SPI NOR framework
      mtd: spi-nor: add a helper to find the spi_device_id
      Documentation: add the binding file for Freescale QuadSPI driver
      mtd: spi-nor: Add Freescale QuadSPI driver
      mtd: spi-nor: add the copyright information
      mtd: gpmi: add gpmi_devdata{} to simplify the code
      Documentation: mtd: update the document for m25p80
      mtd: gpmi: add gpmi support for imx6sx

Jean Delvare (1):
      mtd: Fix Elan SC520 dependencies

Jingoo Han (3):
      mtd: st_spi_fsm: Make of_device_id array const
      mtd: nand: pxa3xx: Make of_device_id array const
      mtd: orion_nand: Make of_device_id array const

Joe Schultz (1):
      mtd: fsl_ifc_nand: Workaround bogus WP on 16-bit NAND

Kamal Dasu (1):
      mtd: nand: Add support to use nand_base poi databuf as bounce buffer

Masahiro Yamada (1):
      mtd: nand: fix a typo in a comment line

Murali Karicheri (2):
      mtd: davinci-nand: disable subpage write for keystone-nand
      mtd: davinci-nand: disable subpage write for keystone-nand

Paul Bolle (1):
      mtd: maps: remove check for CONFIG_MTD_SUPERH_RESERVE

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Philippe De Muyter (1):
      mtd: Kconfig: give the CFI command set version in prompt and help

Raphaël Poggi (1):
      mtd: nand: add line feed to pr_err

Roman Peniaev (1):
      mtd: mtd_blkdevs: handle REQ_FLUSH request and do explicit flush of writeback buffer

Ron (1):
      mtd: nand: use the nand_read_subpage index everywhere

Ron Lee (1):
      NAND_ECC_SOFT_BCH can support subpage reads too

Ted Juan (1):
      mtd: nand: omap: fix omap_calculate_ecc_bch() for-loop error

Thomas Petazzoni (1):
      mtd: pxa3xx_nand: make the driver work on big-endian systems

Vincenzo Aliberti (1):
      mtd: lpddr: add driver for LPDDR2-NVM PCM memories

Wolfram Sang (1):
      mtd: elm: compile suspend/resume only with PM_SLEEP

pekon gupta (5):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page
      mtd: nand: omap: add support for BCH16_ECC - GPMC driver updates
      mtd: nand: omap: add support for BCH16_ECC - ELM driver updates
      mtd: nand: omap: add support for BCH16_ECC - NAND driver updates
      mtd: nand: omap: Documentation: How to select correct ECC scheme for your device ?

 .../devicetree/bindings/mtd/fsl-quadspi.txt        |   35 +
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   45 +
 Documentation/devicetree/bindings/mtd/m25p80.txt   |    4 +-
 .../devicetree/bindings/mtd/pxa3xx-nand.txt        |    8 +
 Documentation/mtd/spi-nor.txt                      |   62 +
 arch/arm/mach-omap2/gpmc.c                         |   15 +
 drivers/mtd/Kconfig                                |    2 +
 drivers/mtd/Makefile                               |    1 +
 drivers/mtd/chips/Kconfig                          |   16 +-
 drivers/mtd/chips/cfi_cmdset_0020.c                |    4 +-
 drivers/mtd/chips/cfi_util.c                       |    2 +-
 drivers/mtd/devices/Kconfig                        |    4 +-
 drivers/mtd/devices/elm.c                          |   38 +
 drivers/mtd/devices/m25p80.c                       | 1305 ++------------------
 drivers/mtd/devices/serial_flash_cmds.h            |   44 +-
 drivers/mtd/devices/slram.c                        |    4 +-
 drivers/mtd/devices/st_spi_fsm.c                   |  340 +++--
 drivers/mtd/lpddr/Kconfig                          |   13 +-
 drivers/mtd/lpddr/Makefile                         |    1 +
 drivers/mtd/lpddr/lpddr2_nvm.c                     |  507 ++++++++
 drivers/mtd/maps/Kconfig                           |    4 +-
 drivers/mtd/maps/sc520cdp.c                        |    6 +-
 drivers/mtd/maps/solutionengine.c                  |   25 +-
 drivers/mtd/mtd_blkdevs.c                          |    6 +
 drivers/mtd/mtdchar.c                              |   20 +-
 drivers/mtd/nand/bf5xx_nand.c                      |   13 +-
 drivers/mtd/nand/davinci_nand.c                    |    6 +
 drivers/mtd/nand/denali.c                          |    7 +-
 drivers/mtd/nand/docg4.c                           |    6 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |   14 +
 drivers/mtd/nand/fsl_ifc_nand.c                    |   21 +-
 drivers/mtd/nand/gpmi-nand/bch-regs.h              |   12 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   11 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |   72 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |   32 +-
 drivers/mtd/nand/nand_base.c                       |  104 +-
 drivers/mtd/nand/nand_bbt.c                        |   13 +-
 drivers/mtd/nand/nand_ecc.c                        |    2 +-
 drivers/mtd/nand/omap2.c                           |  108 +-
 drivers/mtd/nand/orion_nand.c                      |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |   44 +-
 drivers/mtd/nand/r852.c                            |    6 +-
 drivers/mtd/onenand/samsung.c                      |    8 +-
 drivers/mtd/spi-nor/Kconfig                        |   17 +
 drivers/mtd/spi-nor/Makefile                       |    2 +
 drivers/mtd/spi-nor/fsl-quadspi.c                  | 1009 +++++++++++++++
 drivers/mtd/spi-nor/spi-nor.c                      | 1107 +++++++++++++++++
 drivers/mtd/tests/oobtest.c                        |   17 +-
 include/linux/mtd/nand.h                           |   10 +-
 include/linux/mtd/pfow.h                           |    3 -
 include/linux/mtd/spi-nor.h                        |  214 ++++
 include/linux/platform_data/elm.h                  |    3 +-
 include/linux/platform_data/mtd-nand-omap2.h       |    5 +
 include/linux/platform_data/mtd-nand-pxa3xx.h      |    3 +
 include/uapi/mtd/mtd-abi.h                         |    1 +
 55 files changed, 3765 insertions(+), 1618 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/fsl-quadspi.txt
 create mode 100644 Documentation/mtd/spi-nor.txt
 create mode 100644 drivers/mtd/lpddr/lpddr2_nvm.c
 create mode 100644 drivers/mtd/spi-nor/Kconfig
 create mode 100644 drivers/mtd/spi-nor/Makefile
 create mode 100644 drivers/mtd/spi-nor/fsl-quadspi.c
 create mode 100644 drivers/mtd/spi-nor/spi-nor.c
 create mode 100644 include/linux/mtd/spi-nor.h
