Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3GAKT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:19:59 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:56108 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3GAKT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:19:57 -0400
Date: Mon, 1 Jul 2013 12:19:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: [git pull] Exotic architecture fixes
Message-ID: <alpine.DEB.2.02.1307011216200.22876@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus.

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git exotic-arch-fixes

for you to fetch changes up to ee89bd6bc73d1d14555418a2642172448052f1dd:

  lib: Move fonts from drivers/video/console/ to lib/fonts/ (2013-06-28 10:28:22 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (34):
      avr32: atmel_default_console_device depends on CONFIG_SERIAL_ATMEL
      c6x: Wire up asm-generic/xor.h
      cris/kgdb: Properly split long lines in asm
      cris/kgdb: Remove unused static int do_printk
      cris/kgdb: Kill forward declarations for static functions
      cris/kgdb: Use #ifdef PROCESS_SUPPORT where needed
      cris/kgdb: Make symbols used from asm global
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
      h8300/boot: Use POSIX "$((..))" instead of bashism "$[...]"
      openrisc: Wire up asm-generic/xor.h
      score: Remove unneeded <asm/dma-mapping.h>
      score: Wire up asm-generic/xor.h
      input: cros_ec_keyb_clear_keyboard() depends on CONFIG_PM_SLEEP
      Revert "staging/solo6x10: depend on CONFIG_FONTS"
      console/font: Refactor font support code selection logic
      lib: Move fonts from drivers/video/console/ to lib/fonts/

Jiang Liu (1):
      h8300: add missing definition for read_barries_depends()

Summary:

This is a collection of several exotic architecture fixes, and a few
other fixes for issues that were detected while doing the former.

Thanks for pulling!

 Documentation/DocBook/device-drivers.tmpl          |    4 +-
 arch/arm/boot/compressed/Makefile                  |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |    2 +
 arch/c6x/include/asm/Kbuild                        |    1 +
 arch/cris/Kconfig                                  |   32 +-
 arch/cris/arch-v10/kernel/kgdb.c                   |  870 ++++++--------------
 arch/cris/arch-v32/drivers/Kconfig                 |    7 -
 arch/cris/include/asm/Kbuild                       |    4 +
 arch/cris/include/asm/io.h                         |    3 +
 arch/cris/include/asm/linkage.h                    |    6 -
 arch/frv/kernel/head.S                             |    5 -
 arch/h8300/Kconfig                                 |  118 +--
 arch/h8300/Kconfig.cpu                             |    4 +
 arch/h8300/boot/compressed/Makefile                |    2 +-
 arch/h8300/include/asm/Kbuild                      |    2 +
 arch/h8300/include/asm/barrier.h                   |    2 +
 arch/h8300/include/asm/linkage.h                   |    6 -
 arch/h8300/include/asm/tlb.h                       |   15 -
 arch/h8300/kernel/entry.S                          |  118 +--
 arch/h8300/kernel/syscalls.S                       |  648 +++++++--------
 arch/h8300/lib/abs.S                               |    4 +-
 arch/h8300/lib/memcpy.S                            |    4 +-
 arch/h8300/lib/memset.S                            |    4 +-
 arch/h8300/platform/h8300h/aki3068net/crt0_ram.S   |   16 +-
 arch/h8300/platform/h8300h/generic/crt0_ram.S      |   14 +-
 arch/h8300/platform/h8300h/generic/crt0_rom.S      |   14 +-
 arch/h8300/platform/h8300h/h8max/crt0_ram.S        |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_ram.S       |   16 +-
 arch/h8300/platform/h8s/edosk2674/crt0_rom.S       |   14 +-
 arch/h8300/platform/h8s/generic/crt0_ram.S         |   16 +-
 arch/h8300/platform/h8s/generic/crt0_rom.S         |   12 +-
 arch/m68k/kernel/asm-offsets.c                     |    2 +-
 arch/openrisc/include/asm/Kbuild                   |    1 +
 arch/score/include/asm/Kbuild                      |    1 +
 arch/score/include/asm/dma-mapping.h               |    6 -
 arch/unicore32/boot/compressed/Makefile            |    2 +-
 drivers/input/keyboard/cros_ec_keyb.c              |   54 +-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/parport/Kconfig                            |    4 +-
 drivers/staging/media/solo6x10/Kconfig             |    3 +-
 drivers/usb/misc/sisusbvga/Kconfig                 |    1 +
 drivers/video/console/Kconfig                      |  116 +--
 drivers/video/console/Makefile                     |   32 +-
 lib/Kconfig                                        |    2 +
 lib/Makefile                                       |    2 +
 lib/fonts/Kconfig                                  |  117 +++
 lib/fonts/Makefile                                 |   18 +
 {drivers/video/console => lib/fonts}/font_10x18.c  |    0
 {drivers/video/console => lib/fonts}/font_6x11.c   |    0
 {drivers/video/console => lib/fonts}/font_7x14.c   |    0
 {drivers/video/console => lib/fonts}/font_8x16.c   |    0
 {drivers/video/console => lib/fonts}/font_8x8.c    |    0
 .../video/console => lib/fonts}/font_acorn_8x8.c   |    0
 .../video/console => lib/fonts}/font_mini_4x6.c    |    0
 .../video/console => lib/fonts}/font_pearl_8x8.c   |    0
 .../video/console => lib/fonts}/font_sun12x22.c    |    0
 .../video/console => lib/fonts}/font_sun8x16.c     |    0
 {drivers/video/console => lib/fonts}/fonts.c       |    2 +-
 58 files changed, 927 insertions(+), 1419 deletions(-)
 delete mode 100644 arch/cris/include/asm/linkage.h
 delete mode 100644 arch/h8300/include/asm/linkage.h
 delete mode 100644 arch/score/include/asm/dma-mapping.h
 create mode 100644 lib/fonts/Kconfig
 create mode 100644 lib/fonts/Makefile
 rename {drivers/video/console => lib/fonts}/font_10x18.c (100%)
 rename {drivers/video/console => lib/fonts}/font_6x11.c (100%)
 rename {drivers/video/console => lib/fonts}/font_7x14.c (100%)
 rename {drivers/video/console => lib/fonts}/font_8x16.c (100%)
 rename {drivers/video/console => lib/fonts}/font_8x8.c (100%)
 rename {drivers/video/console => lib/fonts}/font_acorn_8x8.c (100%)
 rename {drivers/video/console => lib/fonts}/font_mini_4x6.c (100%)
 rename {drivers/video/console => lib/fonts}/font_pearl_8x8.c (100%)
 rename {drivers/video/console => lib/fonts}/font_sun12x22.c (100%)
 rename {drivers/video/console => lib/fonts}/font_sun8x16.c (100%)
 rename {drivers/video/console => lib/fonts}/fonts.c (98%)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
