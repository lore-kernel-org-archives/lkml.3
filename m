Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaDFXYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:24:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60555 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaDFXXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:23:55 -0400
Date: Sun, 6 Apr 2014 16:23:51 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [GIT PULL] MTD changes for 3.15
Message-ID: <20140406232351.GB3131@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140405

for you to fetch changes up to 4a4163caccae97a23d97c29032664ee7b7a498d0:

  Fix index regression in nand_read_subpage (2014-04-04 23:13:17 -0700)

----------------------------------------------------------------
MTD updates for 3.15:
 - A few SPI NOR ID definitions
 - Kill the NAND "max pagesize" restriction
 - Fix some x16 bus-width NAND support
 - Add NAND JEDEC parameter page support
 - DT bindings for NAND ECC
 - GPMI NAND updates (subpage reads)
 - More OMAP NAND refactoring
 - New STMicro SPI NOR driver (now in 40 patches!)
 - A few other random bugfixes

----------------------------------------------------------------
Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Alexander Sverdlin (1):
      mtd: phram: Repair multiple instances support

Axel Lin (1):
      mtd: m25p80: Use positive logic to check JEDEC ID

Boris BREZILLON (1):
      mtd: nand: fix erroneous read_buf call in nand_write_page_raw_syndrome

Brian Norris (3):
      mtd: nand: force NAND_CMD_READID onto 8-bit bus
      mtd: nand: don't use read_buf for 8-bit ONFI transfers
      mtd: m25p80: add Macronix mx66l1g55g 1Gbit SPI flash

Cai Zhiyong (1):
      mtd: nand: remove unused function input parameter

Christian Riesch (2):
      mtd: Add a retlen parameter to _get_{fact,user}_prot_info
      mtd: Fix the behavior of OTP write if there is not enough room for data

Dan Carpenter (3):
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()
      mtd: remove some duplicative checks
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()

David Mosberger (1):
      mtd: nand: fix GET/SET_FEATURES address on 16-bit devices

Erico Nunes (1):
      mtd: nand: fix mention to CONFIG_MTD_NAND_ECC_BCH

Ezequiel Garcia (4):
      of_mtd: Add helpers to get ECC strength and ECC step size
      mtd: nand: Add a devicetree binding for ECC strength and ECC step size
      mtd: nand: pxa3xx: Remove unused macro
      mtd: nand: pxa3xx: Print actual ECC strength in error message

Fabian Frederick (2):
      mtd: block2mtd: Add mutex_destroy
      mtd: block2mtd: check device size

Fabio Estevam (1):
      mtd: mxc_nand: Propagate the error if platform_get_irq() fails

Geert Uytterhoeven (2):
      mtd: m25p80: Add dual read support
      mtd: m25p80: Enable Dual SPI read transfers for s25fl256s1 and s25fl512s

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Huang Shijie (11):
      mtd: nand: kill the the NAND_MAX_PAGESIZE/NAND_MAX_OOBSIZE for nand_buffers{}
      mtd: nand: remove the NAND_MAX_PAGESIZE/NAND_MAX_OOBSIZE
      mtd: nand: add support for SanDisk SDTNRGAMA-008G
      mtd: nand: add the data structures for JEDEC parameter page
      mtd: nand: add fields for JEDEC in nand_chip
      mtd: nand: add a helper to get the supported features for JEDEC
      mtd: nand: parse out the JEDEC compliant NAND
      mtd: nand: print out the right information for JEDEC compliant NAND
      mtd: nand: add "page" argument for read_subpage hook
      mtd: gpmi: do not use the mtd->writesize
      mtd: gpmi: add subpage read support

Jean Delvare (1):
      mtd: ts5500: Add dependency

Jingoo Han (10):
      mtd: devices: elm: Remove unnecessary OOM messages
      mtd: spear_smi: Remove unnecessary OOM messages
      mtd: pmc551: Remove unnecessary OOM messages
      mtd: plat-ram: Remove unnecessary OOM messages
      mtd: lpddr: Remove unnecessary OOM messages
      mtd: onenand: Remove unnecessary OOM messages
      mtd: cfi: Remove unnecessary OOM messages
      mtd: gen_probe: Remove unnecessary OOM messages
      mtd: denali_dt: Use devm_ioremap_resource()
      mtd: omap2: Use devm_ioremap_resource()

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Kuninori Morimoto (1):
      mtd: m25p80: add support for the Spansion s25fl008k chip

Lee Jones (40):
      mtd: st_spi_fsm: Allocate resources and register with MTD framework
      mtd: st_spi_fsm: Supply all register address and bit logic defines
      mtd: st_spi_fsm: Initialise and configure the FSM for normal working conditions
      mtd: st_spi_fsm: Supply framework for device requests
      mtd: st_spi_fsm: Supply a method to read from the FSM's FIFO
      mtd: st_spi_fsm: Add support for JEDEC ID extraction
      mtd: devices: Provide header for shared OPCODEs and SFDP commands
      mtd: st_spi_fsm: Provide device look-up table
      mtd: st_spi_fsm: Dynamically setup flash device based on JEDEC ID
      mtd: st_spi_fsm: Search for preferred FSM message sequence configurations
      mtd: st_spi_fsm: Use device size to determine address width
      mtd: st_spi_fsm: Prepare the read/write FSM message sequence(s)
      mtd: st_spi_fsm: Add device-tree binding documentation
      mtd: st_spi_fsm: Fetch boot-device from mode pins
      mtd: st_spi_fsm: Provide the erase one sector sequence
      mtd: st_spi_fsm: Provide the sequence for enabling 32bit addressing mode
      mtd: st_spi_fsm: Prepare read/write sequences according to configuration
      mtd: st_spi_fsm: Add a check to if the chip can handle an SoC reset
      mtd: st_spi_fsm: Provide a method to put the chip into 32bit addressing mode
      mtd: st_spi_fsm: Update the flash Volatile Configuration Register
      mtd: st_spi_fsm: Provide the default read/write configurations
      mtd: st_spi_fsm: Supply the N25Qxxx specific read configurations
      mtd: st_spi_fsm: Supply the N25Qxxx chip specific configuration call-back
      mtd: st_spi_fsm: Prepare default sequences for read/write/erase
      mtd: st_spi_fsm: Add the ability to read from a Serial Flash device
      mtd: st_spi_fsm: Write to Flash via the FSM FIFO
      mtd: st_spi_fsm: Supply a busy wait for post-write status
      mtd: st_spi_fsm: Erase partly or as a whole a Serial Flash device
      mtd: st_spi_fsm: Add the ability to read the FSM's status
      mtd: st_spi_fsm: Add the ability to write to FSM's status register
      mtd: st_spi_fsm: Supply the MX25xxx chip specific configuration call-back
      mtd: st_spi_fsm: Supply the S25FLxxx chip specific configuration call-back
      mtd: st_spi_fsm: Supply the W25Qxxx chip specific configuration call-back
      mtd: st_spi_fsm: Move runtime configurable msg sequences into device's struct
      mtd: st_spi_fsm: Convert ST SPI FSM (NOR) Flash driver to new DT partitions
      mtd: st_spi_fsm: Remove useless consts from function arguments
      mtd: st_spi_fsm: Avoid duplicating MTD core code
      mtd: st_spi_fsm: Correct vendor name spelling issue - missing "M"
      mtd: st_spi_fsm: Allow loop to run at least once before giving up CPU
      mtd: st_spi_fsm: Succinctly reorganise .remove()

Li Zefan (2):
      jffs2: remove from wait queue after schedule()
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Nicolas Ferre (1):
      mtd: atmel_nand: change log level

Paul Gortmaker (1):
      mtd: delete non-required instances of include <linux/init.h>

Pekon Gupta (17):
      mtd: nand: omap: add field to indicate current ecc-scheme in 'struct omap_nand_info'
      mtd: nand: omap: ecc.correct: omap_elm_correct_data: rename ambiguous variable 'eccsize' and 'ecc_vector_size'
      mtd: nand: omap: ecc.correct: omap_elm_correct_data: fix erased-page detection for BCHx_HW ECC schemes
      mtd: nand: omap: ecc.correct: omap_elm_correct_data: cleanup for future enhancements
      mtd: nand: omap: ecc.correct: omap_elm_correct_data: fix programmed-page bit-flip correction logic
      mtd: nand: omap: ecc.calculate: rename omap3_calculate_ecc_bch to omap_calculate_ecc_bch
      mtd: nand: omap: ecc.calculate: refactor omap_calculate_ecc_bch for BCHx_HW ecc-scheme
      mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch4 in omap_calculate_ecc_bch
      mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch8 in omap_calculate_ecc_bch
      mtd: nand: omap: ecc.hwctl: rename omap3_enable_hwecc_bch to omap_enable_hwecc_bch
      mtd: nand: omap: ecc.hwctl: refactor omap_enable_hwecc_bch for ECC related GPMC configs
      mtd: nand: omap: ecc.hwctl: clean omap_enable_hwecc_bch for redundant ECC configs
      mtd: nand: omap: remove is_elm_present flag
      mtd: devices: elm: check for hardware engine's design constraints
      mtd: devices: elm: clean elm_load_syndrome
      mtd: devices: elm: configure parallel channels based on ecc_steps
      mtd: devices: elm: update DRIVER_NAME as "omap-elm"

Philippe De Muyter (1):
      mtd: allow CONFIG_MTD_PHYSMAP_OF also for CONFIG_MTD_RAM

Rafał Miłecki (3):
      mtd: bcm47xxpart: fix off by one in partitions limit
      mtd: bcm47xxpart: avoid overflowing when registering trx
      mtd: bcm47xxpart: allow enabling on ARCH_BCM_5301X

Richard Weinberger (1):
      mtd: nand: flctl: Add dependency on HAS_IOMEM and HAS_DMA

Ron (1):
      Fix index regression in nand_read_subpage

Sachin Kamat (1):
      mtd: nand: s3c2410: Trivial cleanup in header file

Sasha Levin (1):
      mtd: diskonchip: mem resource name is not optional

Stefan Sørensen (1):
      mtd: elm: Use correct check on return value of pm_runtime_get_sync

Wang Guoli (1):
      jffs2: unlock f->sem on error in jffs2_new_inode()

 Documentation/devicetree/bindings/mtd/nand.txt   |   14 +
 Documentation/devicetree/bindings/mtd/st-fsm.txt |   26 +
 drivers/mtd/Kconfig                              |    2 +-
 drivers/mtd/bcm47xxpart.c                        |   11 +-
 drivers/mtd/chips/cfi_cmdset_0001.c              |   40 +-
 drivers/mtd/chips/cfi_cmdset_0002.c              |    9 +-
 drivers/mtd/chips/cfi_cmdset_0020.c              |    3 -
 drivers/mtd/chips/cfi_probe.c                    |    4 +-
 drivers/mtd/chips/cfi_util.c                     |    4 +-
 drivers/mtd/chips/gen_probe.c                    |    2 -
 drivers/mtd/devices/Kconfig                      |    8 +
 drivers/mtd/devices/Makefile                     |    1 +
 drivers/mtd/devices/block2mtd.c                  |   19 +-
 drivers/mtd/devices/elm.c                        |   49 +-
 drivers/mtd/devices/m25p80.c                     |   35 +-
 drivers/mtd/devices/mtd_dataflash.c              |   24 +-
 drivers/mtd/devices/phram.c                      |   41 +-
 drivers/mtd/devices/pmc551.c                     |    7 +-
 drivers/mtd/devices/serial_flash_cmds.h          |   81 +
 drivers/mtd/devices/spear_smi.c                  |    2 -
 drivers/mtd/devices/sst25l.c                     |    1 -
 drivers/mtd/devices/st_spi_fsm.c                 | 2108 ++++++++++++++++++++++
 drivers/mtd/inftlmount.c                         |    1 -
 drivers/mtd/lpddr/lpddr_cmds.c                   |    4 +-
 drivers/mtd/lpddr/qinfo_probe.c                  |    5 +-
 drivers/mtd/maps/Kconfig                         |   10 +-
 drivers/mtd/maps/bfin-async-flash.c              |    1 -
 drivers/mtd/maps/gpio-addr-flash.c               |    1 -
 drivers/mtd/maps/intel_vr_nor.c                  |    1 -
 drivers/mtd/maps/ixp4xx.c                        |    1 -
 drivers/mtd/maps/lantiq-flash.c                  |    1 -
 drivers/mtd/maps/latch-addr-flash.c              |    1 -
 drivers/mtd/maps/pci.c                           |    1 -
 drivers/mtd/maps/physmap_of.c                    |    1 -
 drivers/mtd/maps/plat-ram.c                      |    2 -
 drivers/mtd/maps/pxa2xx-flash.c                  |    1 -
 drivers/mtd/maps/rbtx4939-flash.c                |    1 -
 drivers/mtd/maps/scb2_flash.c                    |    1 -
 drivers/mtd/maps/sun_uflash.c                    |    1 -
 drivers/mtd/mtd_blkdevs.c                        |    1 -
 drivers/mtd/mtdchar.c                            |   20 +-
 drivers/mtd/mtdcore.c                            |   24 +-
 drivers/mtd/mtdpart.c                            |   14 +-
 drivers/mtd/nand/Kconfig                         |    2 +
 drivers/mtd/nand/ams-delta.c                     |    1 -
 drivers/mtd/nand/atmel_nand.c                    |   14 +-
 drivers/mtd/nand/au1550nd.c                      |    4 +-
 drivers/mtd/nand/bf5xx_nand.c                    |    1 -
 drivers/mtd/nand/cafe_nand.c                     |   68 +-
 drivers/mtd/nand/davinci_nand.c                  |    1 -
 drivers/mtd/nand/denali_dt.c                     |   39 +-
 drivers/mtd/nand/diskonchip.c                    |    5 +-
 drivers/mtd/nand/fsl_elbc_nand.c                 |    1 -
 drivers/mtd/nand/fsl_ifc_nand.c                  |    1 -
 drivers/mtd/nand/gpio.c                          |    1 -
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c           |  102 +-
 drivers/mtd/nand/mpc5121_nfc.c                   |    1 -
 drivers/mtd/nand/mxc_nand.c                      |    2 +
 drivers/mtd/nand/nand_base.c                     |  165 +-
 drivers/mtd/nand/nand_ids.c                      |    3 +
 drivers/mtd/nand/nuc900_nand.c                   |    6 +-
 drivers/mtd/nand/omap2.c                         |  512 +++---
 drivers/mtd/nand/pasemi_nand.c                   |    1 -
 drivers/mtd/nand/pxa3xx_nand.c                   |    3 +-
 drivers/mtd/nand/s3c2410.c                       |    1 -
 drivers/mtd/onenand/generic.c                    |    1 -
 drivers/mtd/onenand/omap2.c                      |    1 -
 drivers/mtd/onenand/onenand_base.c               |   38 +-
 drivers/mtd/onenand/samsung.c                    |    4 +-
 drivers/mtd/rfd_ftl.c                            |    9 +-
 drivers/mtd/sm_ftl.c                             |   11 +-
 drivers/mtd/tests/mtd_test.c                     |    1 -
 drivers/mtd/ubi/ubi.h                            |    1 -
 drivers/of/of_mtd.c                              |   34 +
 fs/jffs2/compr_rtime.c                           |    4 +-
 fs/jffs2/fs.c                                    |    9 +-
 fs/jffs2/nodelist.h                              |    2 +-
 fs/jffs2/nodemgmt.c                              |   14 +-
 include/linux/mtd/mtd.h                          |   16 +-
 include/linux/mtd/nand.h                         |  135 +-
 include/linux/of_mtd.h                           |   12 +
 include/linux/platform_data/elm.h                |   10 +-
 include/linux/platform_data/mtd-nand-s3c2410.h   |    8 +-
 83 files changed, 3181 insertions(+), 647 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/st-fsm.txt
 create mode 100644 drivers/mtd/devices/serial_flash_cmds.h
 create mode 100644 drivers/mtd/devices/st_spi_fsm.c
