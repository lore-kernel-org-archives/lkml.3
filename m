Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690Ab3KMSY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:24:58 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40518 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab3KMSYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:24:49 -0500
Date: Wed, 13 Nov 2013 10:24:43 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MTD changes for 3.13
Message-ID: <20131113182443.GD9468@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

David Woodhouse has given me the go-ahead to send the MTD pull request
for 3.13. Please take these fixes.

I've noted the highlights, and there are a few bits that are worth a
review (minor amendments to ABI; I don't want to hide them, but I also
think they are justified and safe).

Brian

The following changes since commit d255c59aab2a3fdf0bb8a5db75e50d9c926c3bb9:

  Merge tag 'for-linus-20131025' of git://git.infradead.org/linux-mtd (2013-10-25 20:15:13 +0100)

are available in the git repository at:


  git://git.infradead.org/linux-mtd.git tags/for-linus-20131112

for you to fetch changes up to 885d71e5838f68d5dbee92ab952cc90ad6c1dc6b:

  mtd: gpmi: fix the NULL pointer (2013-11-12 10:17:57 -0800)

----------------------------------------------------------------
MTD merge for 3.13

 * Unify some compile-time differences so that we have fewer uses of
   #ifdef CONFIG_OF in atmel_nand
 * Other general cleanups (removing unused functions, options, variables,
   fields; use correct interfaces)
 * Fix BUG() for new odd-sized NAND, which report non-power-of-2 dimensions via
   ONFI
 * Miscellaneous driver fixes (SPI NOR flash; BCM47xx NAND flash; etc.)
 * Improve differentiation between SLC and MLC NAND -- this clarifies an ABI
   issue regarding the MTD "type" (in sysfs and in ioctl(MEMGETINFO)), where
   the MTD_MLCNANDFLASH type was present but inconsistently used
 * Extend GPMI NAND to support multi-chip-select NAND for some platforms
 * Many improvements to the OMAP2/3 NAND driver, including an expanded DT
   binding to bring us closer to mainline support for some OMAP systems
 * Fix a deadlock in the error path of the Atmel NAND driver probe
 * Correct the error codes from MTD mmap() to conform to POSIX and the Linux
   Programmer's Manual. This is an acknowledged change in the MTD ABI, but I
   can't imagine somebody relying on the non-standard -ENOSYS error code
   specifically. Am I just being unimaginative? :)
 * Fix a few important GPMI NAND bugs (one regression from 3.12 and one
   long-standing race condition)
 * More? Read the log!

----------------------------------------------------------------
Alexander Sverdlin (1):
      mtd: phram: Make phram 64-bit compatible

Brian Norris (21):
      nand: docg4: use nand_base's default BBT scan
      mtd: nand: lpc32xx_slc: don't call nand_default_bbt directly
      mtd: nandsim: don't call nand_default_bbt() directly
      mtd: nand: stop exporting nand_default_bbt
      mtd: dataflash: remove unused field
      mtd: denali: make init function static
      mtd: onenand: remove redundant offset check
      mtd: nand: remove obsolete 'ecclayout' field
      mtd: onenand: remove unused variable assignments
      mtd: lpddr_cmds: make function static
      mtd: nand: cleanup ONFI printed errors, warnings
      mtd: nand: correct extemded param page error handling
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size
      mtd: m25p80: remove obsolete FIXME
      mtd: m25p80: re-align ID entries
      mtd: m25p80: remove M25PXX_USE_FAST_READ Kconfig
      mtd: m25p80: remove 'disabled' device check
      mtd: m25p80: add support for Macronix mx25l3255e
      mtd: m25p80: fixup device removal failure path
      mtd: nand_bbt: kill NAND_BBT_SCANALLPAGES

Ezequiel Garcia (5):
      of_mtd: Add no-op stubs to support CONFIG_OF=n
      mtd: Use MTD_BLOCK_MAJOR instead of the magic number
      mtd: nand: pxa3xx: Move DMA I/O enabling
      mtd: nand: pxa3xx: Allocate data buffer on detected flash size
      mtd: Move major number definitions to major.h

Fabio Estevam (1):
      mtd: gpmi: Use devm_kzalloc()

Flavio Silveira (1):
      mtd: m25p80: Add support for ESMT F25L32PA

Hauke Mehrtens (1):
      mtd: bcm47xxpart: handle malloc failures

Huang Shijie (20):
      mtd: nand: add a helper to check the SLC/MLC nand chip
      mtd: nand: rename the cellinfo to bits_per_cell
      mtd: nand: add the "bits per cell" info for legacy ID NAND
      mtd: nand: set the cell information for ONFI nand
      mtd: nand: print out the cell information for nand chip
      mtd: gpmi: rewrite the gpmi_ecc_write_oob() to support the jffs2
      mtd: nand: add more comment for MTD_NANDFLASH/MTD_MLCNANDFLASH
      mtd: nand: add a helper to detect the nand type
      mtd: mtd-abi: add a helper to detect the nand type
      mtd: add MTD_MLCNANDFLASH case for mtd_type_show()
      jffs2: do not support the MLC nand
      mtd: nand: fix the wrong mtd->type for nand chip
      mtd: gpmi: decouple the chip select from the DMA channel
      mtd: gpmi: use DMA channel 0 for all the nand chips
      mtd: gpmi: scan two nand chips
      mtd: gpmi: imx6: fix the wrong method for checking ready/busy
      mtd: nand: use a local variable to simplify the nand_scan_tail
      mtd: gpmi: only scan two chips for imx6
      mtd: gpmi: fix kernel BUG due to racing DMA operations
      mtd: gpmi: fix the NULL pointer

Jingoo Han (5):
      mtd: plat-ram: Remove casting the return value which is a void pointer
      mtd: intel_vr_nor: remove unnecessary pci_set_drvdata()
      mtd: pci: remove unnecessary pci_set_drvdata()
      mtd: scb2_flash: remove unnecessary pci_set_drvdata()
      mtd: denali: remove unnecessary pci_set_drvdata()

Josh Wu (4):
      mtd: atmel_nand: remove #if defined(CONFIG_OF) around OF-specific code
      mtd: atmel_nand: add MODULE_DEVICE_TABLE for nfc driver
      mtd: atmel_nand: use minimum ecc requirements of nand: ecc_{strength,step}_ds
      mtd: atmel_nand: fix bug driver will in a dead lock if no nand detected

Lothar Waßmann (1):
      mtd: nand: gpmi-nand: janitorial cleanup: (commas after last element of struct initializer)

Mark Brown (1):
      mtd: dataflash: Say if we find a device we don't support

Michael Opdenacker (1):
      mtd: nand: remove deprecated IRQF_DISABLED

Mike Dunn (1):
      mtd: docg4: fix status polling loop

Paul Bolle (1):
      mtd: onenand: omap: remove two unused functions

Pekon Gupta (9):
      ARM: OMAP2+: cleaned-up DT support of various ECC schemes
      mtd: nand: omap: combine different flavours of 1-bit hamming ecc schemes
      mtd: nand: omap: cleanup: replace local references with generic framework names
      mtd: nand: omap: use DT specified bus-width only for scanning NAND device
      mtd: nand: omap2: clean-up BCHx_HW and BCHx_SW ECC configurations in device_probe
      mtd: nand: omap: clean-up ecc layout for BCH ecc schemes
      mtd: nand: omap: use drivers/mtd/nand/nand_bch.c wrapper for BCH ECC instead of lib/bch.c
      mtd: nand: omap: updated devm_xx for all resource allocation and free calls
      mtd: nand: omap: remove selection of BCH ecc-scheme via KConfig

Prabhakar Kushwaha (2):
      driver/mtd/IFC: Add support of 8K page size NAND flash
      driver/mtd/ifc: Read Status while programming NAND flash

Priyanka Jain (1):
      mtd: m25p80: Add support for Micron N25Q512A memory

Rafał Miłecki (2):
      mtd: bcm47xxpart: detect block aligned Squashfs partition
      mtd: bcm47xxpart: detect "factory" partition

Sachin Kamat (15):
      mtd: diskonchip: Fix incorrect placement of __initdata
      mtd: nand: lpc32xx_mlc: Remove redundant of_match_ptr
      mtd: nand: lpc32xx_slc: Remove redundant of_match_ptr
      mtd: nand: pxa3xx_nand: Remove redundant of_match_ptr
      mtd: sst25l: Remove redundant spi_set_drvdata
      mtd: sst25l: Use devm_kzalloc
      mtd: fsl_ifc_nand: Remove redundant dev_set_drvdata
      mtd: fsl_ifc_nand: Use module_platform_driver
      mtd: socrates_nand: Remove redundant dev_set_drvdata
      mtd: socrates_nand: Use devm_kzalloc
      mtd: socrates_nand: Use dev_err instead of printk
      mtd: plat-ram: Use module_platform_driver
      mtd: bcm47xxnflash: Use module_platform_driver
      mtd: bcm47xxnflash: Use devm_kzalloc
      mtd: mxc_nand: Include linux/of.h header

Vladimir Zapolskiy (1):
      mtd: mtdchar: return expected errors on mmap() call

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wei Yongjun (3):
      mtg: docg3: use free_bch() instead of kfree()
      mtd: remove duplicated include from mtdcore.c
      mtd: nand: omap: fix error return code in omap_nand_probe()

 Documentation/ABI/testing/sysfs-class-mtd          |   2 +-
 Documentation/DocBook/mtdnand.tmpl                 |   2 -
 .../devicetree/bindings/mtd/gpmc-nand.txt          |  16 +-
 arch/arm/mach-omap2/board-flash.c                  |   2 +-
 arch/arm/mach-omap2/gpmc.c                         |  48 +-
 arch/powerpc/include/asm/fsl_ifc.h                 |   2 +
 drivers/mtd/bcm47xxpart.c                          |  23 +
 drivers/mtd/devices/Kconfig                        |   7 -
 drivers/mtd/devices/block2mtd.c                    |   1 +
 drivers/mtd/devices/docg3.c                        |   2 +-
 drivers/mtd/devices/m25p80.c                       |  82 ++-
 drivers/mtd/devices/mtd_dataflash.c                |   4 +-
 drivers/mtd/devices/phram.c                        |  66 +--
 drivers/mtd/devices/sst25l.c                       |  13 +-
 drivers/mtd/inftlcore.c                            |   2 +-
 drivers/mtd/lpddr/lpddr_cmds.c                     |   2 +-
 drivers/mtd/maps/intel_vr_nor.c                    |   1 -
 drivers/mtd/maps/pci.c                             |   1 -
 drivers/mtd/maps/plat-ram.c                        |  18 +-
 drivers/mtd/maps/scb2_flash.c                      |   1 -
 drivers/mtd/mtdblock.c                             |   3 +-
 drivers/mtd/mtdblock_ro.c                          |   3 +-
 drivers/mtd/mtdchar.c                              |   7 +-
 drivers/mtd/mtdcore.c                              |   3 +
 drivers/mtd/mtdsuper.c                             |   1 +
 drivers/mtd/nand/Kconfig                           |  40 +-
 drivers/mtd/nand/atmel_nand.c                      |  67 +--
 drivers/mtd/nand/bcm47xxnflash/main.c              |  38 +-
 drivers/mtd/nand/denali.c                          |   4 +-
 drivers/mtd/nand/denali_pci.c                      |   1 -
 drivers/mtd/nand/diskonchip.c                      |   2 +-
 drivers/mtd/nand/docg4.c                           |  16 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |   2 -
 drivers/mtd/nand/fsl_ifc_nand.c                    | 134 ++++-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |  13 +
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |  66 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-regs.h             |   3 +
 drivers/mtd/nand/lpc32xx_mlc.c                     |   2 +-
 drivers/mtd/nand/lpc32xx_slc.c                     |  10 +-
 drivers/mtd/nand/mxc_nand.c                        |   3 +-
 drivers/mtd/nand/nand_base.c                       | 305 +++++-----
 drivers/mtd/nand/nand_bbt.c                        |  38 +-
 drivers/mtd/nand/nandsim.c                         |   2 +-
 drivers/mtd/nand/omap2.c                           | 642 +++++++++------------
 drivers/mtd/nand/pxa3xx_nand.c                     |  56 +-
 drivers/mtd/nand/socrates_nand.c                   |  14 +-
 drivers/mtd/nand/tmio_nand.c                       |   3 +-
 drivers/mtd/nftlcore.c                             |   2 +-
 drivers/mtd/onenand/omap2.c                        |  22 -
 drivers/mtd/onenand/onenand_base.c                 |  17 +-
 drivers/mtd/ssfdc.c                                |   2 +-
 drivers/mtd/tests/nandbiterrs.c                    |   2 +-
 drivers/mtd/tests/oobtest.c                        |   2 +-
 drivers/mtd/tests/pagetest.c                       |   2 +-
 drivers/mtd/tests/subpagetest.c                    |   2 +-
 drivers/mtd/ubi/build.c                            |   1 +
 fs/jffs2/fs.c                                      |   4 +
 include/linux/mtd/bbm.h                            |   2 -
 include/linux/mtd/map.h                            |   4 +-
 include/linux/mtd/mtd.h                            |   8 +-
 include/linux/mtd/nand.h                           |  16 +-
 include/linux/of_mtd.h                             |  21 +-
 include/linux/platform_data/mtd-nand-omap2.h       |  18 +-
 include/uapi/linux/major.h                         |   2 +
 include/uapi/mtd/mtd-abi.h                         |   9 +-
 65 files changed, 925 insertions(+), 984 deletions(-)
