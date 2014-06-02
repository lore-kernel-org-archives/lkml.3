Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaFBOBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:01:47 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:47769 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaFBOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:01:46 -0400
Date: Mon, 2 Jun 2014 16:01:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.16
Message-ID: <alpine.DEB.2.02.1406021556230.30881@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to e8d6dc5ad26eb027c19cfb44825f038734be2cb3:

  m68k/hp300: Convert printk to pr_foo() (2014-05-28 10:11:55 +0200)

Highlights:
  - Support for running kernels in fast TT-RAM instead of slow ST-RAM on
    Atari,
  - Multi-platform EARLY_PRINTK,
  - Better support for machines with lots of RAM (think ARAnyM), and for
    running kernels larger than 4 MiB (think multi-platform).

Thanks for pulling!

----------------------------------------------------------------
Andreas Schwab (1):
      m68k: Increase initial mapping to 8 or 16 MiB if possible

Fabian Frederick (3):
      m68k/amiga: Convert printk(foo to pr_foo()
      m68k/apollo: Convert printk to pr_foo()
      m68k/hp300: Convert printk to pr_foo()

Finn Thain (4):
      m68k: Toward platform agnostic framebuffer debug logging
      m68k: Multi-platform EARLY_PRINTK
      m68k/mvme16x: Adopt common boot console
      m68k/atari: fix SCC initialization for debug console

Geert Uytterhoeven (1):
      m68k: Update defconfigs for v3.15-rc2

Michael Schmitz (4):
      m68k/atari - stram: alloc ST-RAM pool even if kernel not in ST-RAM
      m68k/atari - atafb: convert allocation of fb ram to new interface
      m68k/atari - ataflop: use correct virt/phys translation for DMA buffer
      m68k/atari - atari_scsi: use correct virt/phys translation for DMA buffer

 Documentation/kernel-parameters.txt  |   2 +-
 arch/m68k/Kconfig.debug              |   9 +-
 arch/m68k/amiga/amisound.c           |   2 +-
 arch/m68k/amiga/config.c             |  20 ++--
 arch/m68k/apollo/config.c            |  20 ++--
 arch/m68k/atari/stram.c              |  71 +++++++++---
 arch/m68k/configs/amiga_defconfig    |   5 +-
 arch/m68k/configs/apollo_defconfig   |   5 +-
 arch/m68k/configs/atari_defconfig    |   5 +-
 arch/m68k/configs/bvme6000_defconfig |   5 +-
 arch/m68k/configs/hp300_defconfig    |   5 +-
 arch/m68k/configs/mac_defconfig      |   5 +-
 arch/m68k/configs/multi_defconfig    |   5 +-
 arch/m68k/configs/mvme147_defconfig  |   5 +-
 arch/m68k/configs/mvme16x_defconfig  |   5 +-
 arch/m68k/configs/q40_defconfig      |   5 +-
 arch/m68k/configs/sun3_defconfig     |   5 +-
 arch/m68k/configs/sun3x_defconfig    |   5 +-
 arch/m68k/hp300/config.c             |  11 +-
 arch/m68k/include/asm/atari_stram.h  |   2 +
 arch/m68k/kernel/Makefile            |   2 +
 arch/m68k/kernel/early_printk.c      |  67 ++++++++++++
 arch/m68k/kernel/head.S              | 207 +++++++++++++++--------------------
 arch/m68k/mac/config.c               |  29 -----
 arch/m68k/mm/motorola.c              |  10 +-
 arch/m68k/mvme16x/config.c           |  26 +----
 drivers/block/ataflop.c              |   2 +-
 drivers/scsi/atari_scsi.c            |   2 +-
 drivers/video/fbdev/atafb.c          |  49 +++++----
 29 files changed, 329 insertions(+), 262 deletions(-)
 create mode 100644 arch/m68k/kernel/early_printk.c

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
