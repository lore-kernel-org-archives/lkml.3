Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3GARRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3GARRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:17:35 -0400
Date: Mon, 1 Jul 2013 10:17:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.11-rc1
Message-ID: <20130701171734.GA25726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.11-rc1

for you to fetch changes up to 828c6a102b1f2b8583fadc0e779c46b31d448f0b:

  Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller" (2013-06-30 09:03:06 -0700)

----------------------------------------------------------------
TTY/Serial merge for 3.11-rc1

Here is the big TTY / Serial driver merge for 3.11-rc1.

It's not all that big, nothing major changed in the tty api, which is a
nice change, just a number of serial driver fixes and updates and new
drivers, along with some n_tty fixes to help resolve some reported
issues.

All of these have been in the linux-next releases for a while, with the
exception of the last revert patch, which was reported this past weekend
by two different people as being needed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Stein (1):
      serial: imx: Add Rx Fifo overrun error message

Alexey Khoroshilov (1):
      tty/serial/sirf: fix error propagation in sirfsoc_uart_probe()

Arnd Bergmann (1):
      serial: omap: repair building without PM_SLEEP

Boris BREZILLON (1):
      tty: atmel_serial: prepare clk before calling enable

Darren Hart (1):
      pch_uart: Add uart_clk selection for the MinnowBoard

Fabio Estevam (4):
      serial: imx: Fix warning when !CONFIG_SERIAL_IMX_CONSOLE
      serial: imx: Allow module build
      serial: imx: Improve Kconfig text
      serial: imx: Fix serial clock unbalance

Feng Tang (1):
      serial: mfd: Add sysrq support

Greg Kroah-Hartman (5):
      Merge 3.10-rc3 into tty-next
      Merge 3.10-rc5 into tty-next
      Merge 3.10-rc6 into tty-next
      Merge 3.10-rc7 into tty-next
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"

Huang Shijie (3):
      serial: imx: add support for DTE mode
      serial: imx: enable the clocks only when the uart is used
      serial: imx: enable the clocks for console

Jingchang Lu (1):
      tty: serial: add Freescale lpuart driver support

Jingoo Han (3):
      serial: altera: remove unnecessary platform_set_drvdata()
      serial: use platform_{get,set}_drvdata()
      tty: replace strict_strtoul() with kstrtoul()

Jongsung Kim (1):
      tty: serial: amba-pl011: revise to use amba_rev macro

Libo Chen (1):
      driver: tty: add missing unregister in err case

Matteo Facchinetti (3):
      serial/mpc52xx_uart: prepare for adding MPC5125 PSC UART support
      serial/mpc52xx_uart: add MPC5125 PSC support
      serial/mpc52xx_uart: fix kernel panic when system reboot

Michal Simek (1):
      tty: serial: Enable uartlite for ARM zynq

Paul Bolle (1):
      stallion: final cleanup

Peter Hurley (7):
      tty: Remove TTY_HW_COOK_IN/OUT
      tty: Add timed, writer-prioritized rw semaphore
      n_tty: Encapsulate minimum_to_wake within N_TTY
      n_tty: Untangle read completion variables
      n_tty: Fix unsafe update of available buffer space
      n_tty: Buffer work should not reschedule itself
      tty: Reset itty for other pty

Sachin Kamat (1):
      serial: vt8500: Remove redundant use of of_match_ptr macro

Soren Brinkmann (1):
      tty: xuartps: Remove suspend/resume functions

Sourav Poddar (2):
      serial: Move "uart_console" def to core header file.
      serial: omap: prevent runtime PM for "no_console_suspend"

Thadeu Lima de Souza Cascardo (1):
      serial/JSM: change maintainer to myself

Tony Lindgren (1):
      serial: omap: Fix device tree based PM runtime

Wang YanQing (11):
      fbcon: convert last fbcon_takeover call to do_fbcon_takeover
      fbcon: delete unneeded function fbcon_takeover
      vt: delete unneeded functions register_con_driver|take_over_console
      vt: convert last unbind_con_driver call to do_unbind_con_driver
      vt: delete unneeded function unbind_con_driver
      vt: convert last bind_con_driver call to do_bind_con_driver
      vt: delete unneeded function bind_con_driver
      fbcon: convert last two unregister_con_driver call to do_unregister_con_driver
      vt: delete unneeded function unregister_con_driver
      TTY:vt: convert remain take_over_console's users to do_take_over_console
      TTY:console: update document console.txt

Wei Yongjun (2):
      serial: samsung: missing uart_unregister_driver() on error in s3c24xx_serial_modinit()
      serial: omap: fix potential NULL pointer dereference in serial_omap_runtime_suspend()

 Documentation/console/console.txt                  |  28 +-
 .../bindings/tty/serial/fsl-imx-uart.txt           |   3 +
 .../devicetree/bindings/tty/serial/fsl-lpuart.txt  |  14 +
 Documentation/serial/00-INDEX                      |   2 -
 Documentation/serial/stallion.txt                  | 392 ---------
 MAINTAINERS                                        |   2 +-
 arch/alpha/kernel/console.c                        |   4 +-
 arch/alpha/kernel/process.c                        |   4 +-
 arch/mips/pci/pci-bcm1480.c                        |   4 +-
 arch/mips/pci/pci-sb1250.c                         |   4 +-
 arch/parisc/kernel/setup.c                         |   2 +-
 arch/powerpc/include/asm/mpc52xx_psc.h             |  49 ++
 drivers/char/Kconfig                               |  12 -
 drivers/tty/Makefile                               |   2 +-
 drivers/tty/hvc/hvc_iucv.c                         |   2 +-
 drivers/tty/n_tty.c                                |  88 ++-
 drivers/tty/serial/8250/8250_pci.c                 |   4 -
 drivers/tty/serial/8250/Kconfig                    |   5 +-
 drivers/tty/serial/Kconfig                         |  27 +-
 drivers/tty/serial/Makefile                        |   1 +
 drivers/tty/serial/altera_uart.c                   |   1 -
 drivers/tty/serial/amba-pl011.c                    |  11 +-
 drivers/tty/serial/atmel_serial.c                  |  41 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    | 874 +++++++++++++++++++++
 drivers/tty/serial/imx.c                           |  47 +-
 drivers/tty/serial/mfd.c                           |   4 +
 drivers/tty/serial/mpc52xx_uart.c                  | 424 ++++++++--
 drivers/tty/serial/of_serial.c                     |   4 +-
 drivers/tty/serial/omap-serial.c                   |  43 +-
 drivers/tty/serial/pch_uart.c                      |   5 +
 drivers/tty/serial/samsung.c                       |   8 +-
 drivers/tty/serial/sc26xx.c                        |   5 +-
 drivers/tty/serial/serial_core.c                   |   6 -
 drivers/tty/serial/sirfsoc_uart.c                  |   5 +-
 drivers/tty/serial/sunhv.c                         |   6 +-
 drivers/tty/serial/sunsab.c                        |   6 +-
 drivers/tty/serial/sunsu.c                         |   8 +-
 drivers/tty/serial/sunzilog.c                      |   6 +-
 drivers/tty/serial/ucc_uart.c                      |   9 +-
 drivers/tty/serial/vt8500_serial.c                 |   2 +-
 drivers/tty/serial/xilinx_uartps.c                 |  36 +-
 drivers/tty/sysrq.c                                |   2 +-
 drivers/tty/tty_io.c                               |  19 +-
 drivers/tty/tty_ldsem.c                            | 453 +++++++++++
 drivers/tty/vt/vt.c                                | 117 +--
 drivers/usb/misc/sisusbvga/sisusb_con.c            |  18 +-
 drivers/video/console/fbcon.c                      |  35 +-
 drivers/video/console/mdacon.c                     |   8 +-
 drivers/video/console/newport_con.c                |   9 +-
 drivers/video/console/sticon.c                     |   6 +-
 include/linux/console.h                            |   3 -
 include/linux/serial_core.h                        |   7 +
 include/linux/tty.h                                |   3 -
 include/linux/tty_ldisc.h                          |  52 ++
 include/linux/vt_kern.h                            |   2 -
 include/uapi/linux/serial_core.h                   |   3 +
 57 files changed, 2144 insertions(+), 797 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-lpuart.txt
 delete mode 100644 Documentation/serial/stallion.txt
 create mode 100644 drivers/tty/serial/fsl_lpuart.c
 create mode 100644 drivers/tty/tty_ldsem.c
