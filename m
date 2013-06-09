Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FISni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 14:43:38 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57011 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3FISnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 14:43:37 -0400
Date: Sun, 9 Jun 2013 20:41:12 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Lennox Wu <lennox.wu@gmail.com>, linux-c6x-dev@linux-c6x.org,
        Cris <linux-cris-kernel@axis.com>, linux@openrisc.net
Subject: [git pull] Exotic architecture fixes
Message-ID: <alpine.DEB.2.00.1306092034010.24700@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:
  Linus Torvalds (1):
        Linux 3.10-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git exotic-arch-fixes

Geert Uytterhoeven (33):
      avr32: atmel_default_console_device depends on CONFIG_SERIAL_ATMEL
      c6x: Wire up asm-generic/xor.h
      cris/kgdb: Properly split long lines in asm
      cris/kgdb: Remove unused static int do_printk
      cris/kgdb: Kill forward declarations for static functions
      cris/kgdb: Use #ifdef PROCESS_SUPPORT where needed
      cris/kgb: Make symbols used from asm global
      cris/kgdb: Remove obsolete USED*() macros
      cris/kgdb: Fix buffer overflow in getpacket()
      cris/kgdb: Remove sections protected by #ifdef PROCESS_SUPPORT
      cris: Provide <asm/kvm_para.h>
      cris: Provide inb_p() and outb_p()
      cris: Switch to asm-generic/linkage.h
      cris: Wire up asm-generic/xor.h
      cris: Switch cris to drivers/Kconfig
      console: Disable VGA text console support on cris
      parport: disable PC-style parallel port support on cris
      cris: Wire up asm-generic/vga.h
      frv: head.S - Remove commented-out initialization code
      h8300: Hardcode symbol prefixes in asm sources
      h8300: Fix <asm/tlb.h>
      h8300: Fill the system call table using a CALL() macro
      h8300: Wire up asm-generic/xor.h
      h8300: Limit timer channel ranges in Kconfig
      h8300: Switch h8300 to drivers/Kconfig
      h8300: Mark H83002 and H83048 CPU support broken
      openrisc: Wire up asm-generic/xor.h
      score: Remove unneeded <asm/dma-mapping.h>
      score: Wire up asm-generic/xor.h
      Revert "staging/solo6x10: depend on CONFIG_FONTS"
      console/font: Refactor font support code selection logic
      ntp: Remove unused variable flags in __hardpps
      input: cros_ec_keyb_clear_keyboard() depends on CONFIG_PM_SLEEP

Jiang Liu (1):
      h8300: add missing definition for read_barries_depends()

Summary:

This is a collection of several exotic architecture fixes (and a few
other trivial fixes).

The ntp commit has landed in 3.10-rc4 in the mean time, but I didn't
want to rebase this branch (which has been in -next for a while) just
for removing one commit.

Thanks for pulling!

 arch/avr32/mach-at32ap/at32ap700x.c              |    2 +
 arch/c6x/include/asm/Kbuild                      |    1 +
 arch/cris/Kconfig                                |   32 +-
 arch/cris/arch-v10/kernel/kgdb.c                 |  870 +++++++---------------
 arch/cris/arch-v32/drivers/Kconfig               |    7 -
 arch/cris/include/asm/Kbuild                     |    4 +
 arch/cris/include/asm/io.h                       |    3 +
 arch/cris/include/asm/linkage.h                  |    6 -
 arch/frv/kernel/head.S                           |    5 -
 arch/h8300/Kconfig                               |  118 +---
 arch/h8300/Kconfig.cpu                           |    4 +
 arch/h8300/include/asm/Kbuild                    |    2 +
 arch/h8300/include/asm/barrier.h                 |    2 +
 arch/h8300/include/asm/linkage.h                 |    6 -
 arch/h8300/include/asm/tlb.h                     |   15 -
 arch/h8300/kernel/entry.S                        |  118 ++--
 arch/h8300/kernel/syscalls.S                     |  648 ++++++++--------
 arch/h8300/lib/abs.S                             |    4 +-
 arch/h8300/lib/memcpy.S                          |    4 +-
 arch/h8300/lib/memset.S                          |    4 +-
 arch/h8300/platform/h8300h/aki3068net/crt0_ram.S |   16 +-
 arch/h8300/platform/h8300h/generic/crt0_ram.S    |   14 +-
 arch/h8300/platform/h8300h/generic/crt0_rom.S    |   14 +-
 arch/h8300/platform/h8300h/h8max/crt0_ram.S      |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_ram.S     |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_rom.S     |   14 +-
 arch/h8300/platform/h8s/generic/crt0_ram.S       |   16 +-
 arch/h8300/platform/h8s/generic/crt0_rom.S       |   12 +-
 arch/openrisc/include/asm/Kbuild                 |    1 +
 arch/score/include/asm/Kbuild                    |    1 +
 arch/score/include/asm/dma-mapping.h             |    6 -
 drivers/input/keyboard/cros_ec_keyb.c            |   54 +-
 drivers/media/platform/Kconfig                   |    2 +-
 drivers/parport/Kconfig                          |    4 +-
 drivers/staging/media/solo6x10/Kconfig           |    3 +-
 drivers/usb/misc/sisusbvga/Kconfig               |    1 +
 drivers/video/Makefile                           |    2 +-
 drivers/video/console/Kconfig                    |   16 +-
 drivers/video/console/Makefile                   |   16 +-
 kernel/time/ntp.c                                |    1 -
 40 files changed, 790 insertions(+), 1290 deletions(-)
 delete mode 100644 arch/cris/include/asm/linkage.h
 delete mode 100644 arch/h8300/include/asm/linkage.h
 delete mode 100644 arch/score/include/asm/dma-mapping.h

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

