Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKBWft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:35:49 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34457 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaKBWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:35:48 -0500
Date: Sun, 2 Nov 2014 14:35:40 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [GIT PULL] MTD fixes for 3.18
Message-ID: <20141102223540.GA22361@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 8b3d58e554453ab858bbb169d93b7321bdc628d4:

  mtd: nand: omap: Correct CONFIG_MTD_NAND_OMAP_BCH help message (2014-10-06 23:40:09 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20141102

for you to fetch changes up to 89cf38dd536a7301d6b5f5ddd73f42074c01bfaa:

  mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips (2014-10-29 18:50:52 -0700)

----------------------------------------------------------------
Three main MTD fixes for 3.18:

 * A regression from 3.16 which was noticed in 3.17. With the restructuring of
   the m25p80.c driver and the SPI NOR library framework, we omitted proper
   listing of the SPI device IDs. This means m25p80.c wouldn't auto-load
   (modprobe) properly when built as a module. For now, we duplicate the device
   IDs into both modules.

* The OMAP / ELM modules were depending on an implicit link ordering. Use
  deferred probing so that the new link order (in 3.18-rc) can still allow for
  successful probing.

* Fix suspend/resume support for LH28F640BF NOR flash

----------------------------------------------------------------
Ben Hutchings (2):
      mtd: spi-nor: make spi_nor_scan() take a chip type name, not spi_device_id
      mtd: m25p80,spi-nor: Fix module aliases for m25p80

Dmitry Eremin-Solenikov (1):
      mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips

Frans Klaver (1):
      mtd: omap: fix mtd devices not showing up

Rafał Miłecki (1):
      mtd: m25p80: get rid of spi_get_device_id

 drivers/mtd/chips/cfi_cmdset_0001.c |  2 ++
 drivers/mtd/devices/m25p80.c        | 64 ++++++++++++++++++++++++++++++++-----
 drivers/mtd/nand/omap_elm.c         |  2 +-
 drivers/mtd/spi-nor/fsl-quadspi.c   |  7 +---
 drivers/mtd/spi-nor/spi-nor.c       | 16 ++++++----
 include/linux/mtd/spi-nor.h         | 21 ++----------
 6 files changed, 73 insertions(+), 39 deletions(-)
