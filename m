Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaATVGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:06:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaATVGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:06:13 -0500
Date: Mon, 20 Jan 2014 13:06:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.14-rc1
Message-ID: <20140120210659.GA358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.14-rc1

for you to fetch changes up to 8bc661bfc0c2d221e209f4205bdaaf574d50100c:

  tty/serial: at91: disable uart timer at start of shutdown (2014-01-13 15:55:59 -0800)

----------------------------------------------------------------
TTY/Serial driver patches for 3.14-rc1

Here's the big tty/serial driver pull request for 3.14-rc1

There are a number of n_tty fixes and cleanups, and some serial driver
bugfixes, and we got rid of one obsolete driver, making this series
remove more lines than added, always a nice surprise.

All of these have been in linux-next with no reports of issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (5):
      serial: clps711x: Driver refactor
      serial: clps711x: dts: Add bindings documentation for the CLPS711X UART
      serial: Remove old SC26XX driver
      serial: clps711x: Add support for N_IRDA line discipline
      serial: clps711x: Enable driver compilation with COMPILE_TEST

Arnd Bergmann (2):
      tty/amiserial: avoid interruptible_sleep_on
      tty: synclink: avoid sleep_on race

Baruch Siach (1):
      serial: pl011: remove redundant early amba_ports declaration

Boris BREZILLON (1):
      tty/serial: at91: document clock properties

Chao Bi (1):
      n_gsm: race between ld close and gsmtty open

Chuansheng Liu (2):
      TTY/n_gsm: Removing the wrong tty_unlock/lock() in gsm_dlci_release()
      tty: Removing the deprecated function tty_vhangup_locked()

Fabio Estevam (1):
      tty: serial: mxs-auart: Check the return value from clk_prepare_enable()

Greg Kroah-Hartman (3):
      Merge 3.13-rc4 into tty-next
      Revert "serial: pl011: use DMA RX polling by default"
      Merge 3.13-rc5 into tty-next

Guennadi Liakhovetski (2):
      serial: pl011: (cosmetic) remove superfluous register write
      serial: pl011: fix fall back from DMA to interrupt mode

Heikki Krogerus (1):
      serial: 8250_dw: remove ACPI ifdef

Huang Shijie (1):
      serial: imx: add support for loopback mode.

Jingoo Han (3):
      serial: pch_uart: remove unnecessary pci_set_drvdata()
      parport_serial: remove unnecessary pci_set_drvdata()
      tty: remove DEFINE_PCI_DEVICE_TABLE macro

Jon Medhurst (3):
      serial: amba-pl011: use port lock to guard control register access
      serial: amba-pl011: factor out code for writing LCR_H register
      serial: amba-pl011: preseserve hardware settings during initialisation

Jonathan Woithe (1):
      serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip

Linus Walleij (1):
      serial: pl011: use DMA RX polling by default

Marek Roszko (3):
      tty/serial: at91: Handle shutdown more safely
      tty/serial: at91: fix race condition in atmel_serial_remove
      tty/serial: at91: disable uart timer at start of shutdown

Mark Deneen (1):
      tty/serial: at91: reset rx_ring when port is shutdown

Paul Gortmaker (1):
      tty: delete non-required instances of include <linux/init.h>

Peter Hurley (17):
      n_tty: Merge .receive_buf() flavors
      n_tty: Un-inline slow-path n_tty_receive_char()
      n_tty: Un-inline slow-path n_tty_receive_char_closing()
      n_tty: Refactor PARMRK doubling checks
      n_tty: Refactor input_available_p() by call site
      n_tty: Only perform wakeups for waiters
      tty: Always handle NULL flag ptr
      tty: Enable configurable tty flip buffer limit
      tty: Rename tty buffer memory_used field
      tty: Remove tty_prepare_flip_string_flags()
      staging/fwserial: Rip out rx buffering
      staging/fwserial: Up the tty buffer limit to 128K
      staging/fwserial: Rename data profiling functions
      staging/fwserial: Add Kconfig options for max ports
      tty: Fix stale tty_buffer_flush() comment
      tty: Halve flip buffer GFP_ATOMIC memory consumption
      n_tty: Fix buffer overruns with larger-than-4k pastes

Qipan Li (3):
      serial: sirf: use PM macro initialize PM functions
      serial: sirf: provide pm entries of uart_ops
      serial: sirf: correct condition for fetching dma buffer into tty

Qixue Xiao (1):
      tty: an overflow of multiplication in drivers/tty/cyclades.c

Randy Dunlap (1):
      init.h: add missing initcall variants

Randy Witt (1):
      serial_core: Don't re-initialize a previously initialized spinlock.

Rashika Kheria (2):
      drivers: tty: Mark the functions as static in n_gsm.c
      drivers: tty: Mark the function hvc_poll_init() as static in hvc_console.c

Stephen Warren (1):
      serial: 8250: enable UART_BUG_NOMSR for Tegra

Ulf Hansson (2):
      serial: pl011: Convert to modern PM ops
      serial: pl010: Convert to modern PM ops

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

 .../devicetree/bindings/serial/atmel-usart.txt     |   7 +
 .../bindings/serial/cirrus,clps711x-uart.txt       |  28 +
 arch/arm/mach-clps711x/devices.c                   |  21 +
 drivers/char/pcmcia/synclink_cs.c                  |   4 +-
 drivers/input/serio/serport.c                      |  28 +-
 drivers/parport/parport_serial.c                   |   5 -
 drivers/staging/fwserial/Kconfig                   |  20 +
 drivers/staging/fwserial/fwserial.c                | 151 ++---
 drivers/staging/fwserial/fwserial.h                |  24 +-
 drivers/tty/amiserial.c                            |  26 +-
 drivers/tty/cyclades.c                             |   2 +
 drivers/tty/goldfish.c                             |   1 -
 drivers/tty/hvc/hvc_console.c                      |   2 +-
 drivers/tty/hvc/hvsi_lib.c                         |   1 -
 drivers/tty/ipwireless/tty.c                       |   1 -
 drivers/tty/n_gsm.c                                |  63 +-
 drivers/tty/n_r3964.c                              |   2 +-
 drivers/tty/n_tty.c                                | 113 ++--
 drivers/tty/rocket.c                               |   2 +-
 drivers/tty/serial/8250/8250_core.c                |   4 +
 drivers/tty/serial/8250/8250_dw.c                  |   9 -
 drivers/tty/serial/8250/8250_em.c                  |   1 -
 drivers/tty/serial/8250/8250_pci.c                 |   9 +-
 drivers/tty/serial/8250/8250_pnp.c                 |   1 -
 drivers/tty/serial/8250/serial_cs.c                |   1 -
 drivers/tty/serial/Kconfig                         |  21 +-
 drivers/tty/serial/Makefile                        |   1 -
 drivers/tty/serial/amba-pl010.c                    |  15 +-
 drivers/tty/serial/amba-pl011.c                    |  84 +--
 drivers/tty/serial/atmel_serial.c                  |  45 +-
 drivers/tty/serial/clps711x.c                      | 454 +++++++------
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c        |   1 -
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c        |   1 -
 drivers/tty/serial/imx.c                           |   8 +
 drivers/tty/serial/kgdb_nmi.c                      |   1 -
 drivers/tty/serial/mxs-auart.c                     |   9 +-
 drivers/tty/serial/of_serial.c                     |   1 -
 drivers/tty/serial/pch_uart.c                      |   3 +-
 drivers/tty/serial/rp2.c                           |   2 +-
 drivers/tty/serial/sc26xx.c                        | 749 ---------------------
 drivers/tty/serial/serial_core.c                   |   8 +-
 drivers/tty/serial/sirfsoc_uart.c                  |  39 +-
 drivers/tty/synclink.c                             |   4 +-
 drivers/tty/synclink_gt.c                          |   4 +-
 drivers/tty/synclinkmp.c                           |   4 +-
 drivers/tty/tty_buffer.c                           | 111 +--
 drivers/tty/tty_ldisc.c                            |   1 -
 drivers/tty/tty_port.c                             |   1 -
 include/linux/init.h                               |   2 +
 include/linux/tty.h                                |   8 +-
 include/linux/tty_flip.h                           |  11 +-
 include/linux/tty_ldisc.h                          |   6 +-
 52 files changed, 752 insertions(+), 1368 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/cirrus,clps711x-uart.txt
 delete mode 100644 drivers/tty/serial/sc26xx.c
