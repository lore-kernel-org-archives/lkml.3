Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaHHXp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:45:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35859 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaHHXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:45:22 -0400
Date: Fri, 8 Aug 2014 16:45:18 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MTD updates for 3.17-rc1
Message-ID: <20140808234518.GT3711@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140808

for you to fetch changes up to 2a500afe1e0e84c7a126df693dbd01353756dcfa:

  mtd: gpmi: make blockmark swapping optional (2014-07-27 22:06:31 -0700)

----------------------------------------------------------------
MTD updates for 3.17-rc1

AMD-compatible CFI driver:
 - Support OTP programming for Micron M29EW family
 - Increase buffer write timeout, according to detected flash parameter info

NAND
 - Add helpers for retrieving ONFI timing modes
 - GPMI: provide option to disable bad block marker swapping (required for
     Ka-On electronics platforms)

SPI NOR
 - EON EN25QH128 support
 - Support new Flag Status Register (FSR) on a few Micron flash

Common
 - New sysfs entries for bad block and ECC stats

And a few miscellaneous refactorings, cleanups, and driver improvements

----------------------------------------------------------------
Atsushi Nemoto (1):
      mtd: maps: rbtx4939-flash: delete an unused variable in rbtx4939_flash_remove

Bean Huo (1):
      mtd: cfi_cmdset_0002: fix do_write_buffer() timeout error

Bo Shen (1):
      mtd: atmel_nand: make ecc parameters same as definition

Boris BREZILLON (2):
      mtd: nand: define struct nand_timings
      mtd: nand: add ONFI timing mode to nand_timings converter

Brian Norris (3):
      mtd: lpc32xx: drop bitflip_threshold initialization
      mtd: bf5xx_nand: drop no-op PM support
      Merge tag 'v3.16-rc6' into MTD development branch

Christian Riesch (4):
      mtd: cfi_cmdset_0002: Add support for reading OTP
      mtd: cfi_cmdset_0002: Invalidate cache after entering/exiting OTP memory
      mtd: cfi_cmdset_0002: Add support for writing OTP memory
      mtd: cfi_cmdset_0002: Add support for locking OTP memory

Ezequiel Garcia (3):
      mtd: Add sysfs attributes to expose the ECC stats fields
      mtd: Introduce mtd_block_isreserved()
      mtd: Account for BBT blocks when a partition is being allocated

Fabian Frederick (3):
      fs/jffs2/acl.c: remove null test before kfree
      fs/jffs2/xattr.c: remove null test before kfree
      mtd: phram: replace kmalloc/strcpy by kstrdup

Geert Uytterhoeven (1):
      mtd: cmdlinepart: Spelling s/trucate/truncate/

Josh Wu (1):
      mtd: atmel_nand: NFC: support multiple interrupt handling

Kevin Hao (2):
      mtd/ftl: drop the useless VirtualPageMap in partition_t
      mtd/ftl: fix the double free of the buffers allocated in build_maps()

Lothar Waﬂmann (3):
      mtd: gpmi: remove useless (void *) type casts and spaces between type casts and variables
      mtd: gpmi: remove line breaks from error messages and improve wording
      mtd: gpmi: make blockmark swapping optional

Rob Ward (1):
      mtd: phram: Fix whitespace issues

Sergey Ryazanov (1):
      mtd: spi-nor: add support for EON EN25QH128

Vasily Khoruzhick (1):
      mtd: s3c2410: Move to clk_prepare_enable/clk_disable_unprepare

Wu, Josh (2):
      mtd: atmel_nand: add NFC status error check
      mtd: atmel_nand: implement the nfc_device_ready() by checking the R/B bit

grmoore@altera.com (2):
      mtd: spi-nor: add support for flag status register on Micron chips
      mtd: denali: use 8 bytes for READID command

 Documentation/ABI/testing/sysfs-class-mtd          |  38 +++
 .../devicetree/bindings/mtd/gpmi-nand.txt          |  10 +
 drivers/mtd/chips/cfi_cmdset_0002.c                | 375 +++++++++++++++++++--
 drivers/mtd/cmdlinepart.c                          |   2 +-
 drivers/mtd/devices/phram.c                        |   7 +-
 drivers/mtd/ftl.c                                  |   4 -
 drivers/mtd/maps/rbtx4939-flash.c                  |   2 -
 drivers/mtd/mtdcore.c                              |  59 +++-
 drivers/mtd/mtdpart.c                              |  13 +-
 drivers/mtd/nand/Makefile                          |   2 +-
 drivers/mtd/nand/atmel_nand.c                      | 142 ++++++--
 drivers/mtd/nand/atmel_nand_nfc.h                  |   4 +
 drivers/mtd/nand/bf5xx_nand.c                      |  24 --
 drivers/mtd/nand/denali.c                          |   6 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |  71 ++--
 drivers/mtd/nand/lpc32xx_mlc.c                     |   6 -
 drivers/mtd/nand/lpc32xx_slc.c                     |   6 -
 drivers/mtd/nand/nand_base.c                       |  18 +
 drivers/mtd/nand/nand_bbt.c                        |  14 +
 drivers/mtd/nand/nand_timings.c                    | 253 ++++++++++++++
 drivers/mtd/nand/s3c2410.c                         |   4 +-
 drivers/mtd/spi-nor/spi-nor.c                      |  53 +++
 fs/jffs2/acl.c                                     |   3 +-
 fs/jffs2/xattr.c                                   |   3 +-
 include/linux/mtd/mtd.h                            |   2 +
 include/linux/mtd/nand.h                           |  53 +++
 include/linux/mtd/spi-nor.h                        |   4 +
 27 files changed, 1032 insertions(+), 146 deletions(-)
 create mode 100644 drivers/mtd/nand/nand_timings.c
