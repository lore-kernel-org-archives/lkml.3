Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaFCFrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:47:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:47:06 -0400
Date: Mon, 2 Jun 2014 22:47:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.16-rc1
Message-ID: <20140603054703.GA14839@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.16-rc1

for you to fetch changes up to 9ce4f8f3f45443922c98e25133b8c9790fc7949a:

  Revert "serial: imx: remove the DMA wait queue" (2014-05-29 19:30:54 -0700)

----------------------------------------------------------------
TTY/Serial driver patches for 3.16-rc1

Here is the big tty / serial driver pull request for 3.16-rc1.

A variety of different serial driver fixes and updates and additions,
nothing huge, and no real major core tty changes at all.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adam Borowski (1):
      vt: emulate 8- and 24-bit colour codes.

Alexander Shiyan (2):
      serial: sccnxp: Remove useless timer_pending() check
      serial: sccnxp: Add IGNPAR flag handling

Alexander Stein (1):
      pch_uart: Add uart device to irq name

Arnd Bergmann (1):
      serial: add missing SERIAL_CORE dependencies

Barry Song (1):
      serial: sirf: move to writel for TXFIFO instead of writeb

Benjamin Herrenschmidt (1):
      tty/hvc/hvc_console: Fix wakeup of HVC thread on hvc_kick()

Christopher Covington (1):
      ARM: tty: Move HVC DCC assembly to arch/arm

Daniel Thompson (7):
      serial: mux: Align SUPPORT_SYSRQ behaviour with other drivers.
      serial: st-asc: Fix data corruption during long console bursts
      serial: sirf: Fix compilation failure
      serial: cpm_uart: No LF conversion in put_poll_char()
      serial: kgdb_nmi: Use container_of() to locate private data
      serial: kgdb_nmi: Switch from tasklets to real timers
      serial: kgdb_nmi: Improve console integration with KDB I/O

Doug Anderson (1):
      serial_core: Commonalize crlf when working w/ a non open console port

Ezequiel Garcia (1):
      parport: Add support for the WCH353 1S/1P multi-IO card

Fabian Frederick (1):
      drivers/tty/n_hdlc.c: replace kmalloc/memset by kzalloc

Fabio Estevam (1):
      serial: imx: Disable new features of autobaud detection

Felipe Balbi (11):
      bluetooth: hci_ldisc: fix deadlock condition
      Revert "serial: omap: unlock the port lock"
      serial: fix UART_IIR_ID
      tty: serial: add missing braces
      tty: serial: omap: switch over to devm_request_gpio
      tty: serial: omap: cleanup variable declarations
      tty: serial: omap: switch over to platform_get_resource
      tty: serial: omap: switch over to devm_ioremap_resource
      tty: serial: omap: remove some dead code
      tty: serial: omap: remove unneeded singlethread workqueue
      tty: serial: omap: fix Sparse warnings

Geert Uytterhoeven (1):
      serial: SERIAL_FSL_LPUART should depend on HAS_DMA

Greg Kroah-Hartman (3):
      Revert "serial: sh-sci: Add device tree support for r8a7779"
      Merge 3.15-rc3 into tty-next
      Revert "serial: imx: remove the DMA wait queue"

Heikki Krogerus (1):
      serial: 8250_dma: check the result of TX buffer mapping

Huang Shijie (5):
      tty_ldisc: add more limits to the @write_wakeup
      serial: imx: reset the uart port all the time
      serial: imx: remove the redundant code
      serial: imx: remove the DMA wait queue
      serial: imx: disable the receiver ready interrupt for imx_stop_rx

Jan Moskyto Matejka (1):
      serial: sc16is7xx: compile I2C when REGMAP_I2C is module

Jean Delvare (2):
      serial: pch_uart: Fix Kconfig dependencies
      tty: n_hdlc: Drop redundant error message

Joe Perches (1):
      serial: samsung: Neaten dbg uses

Johannes Thumshirn (2):
      tty: serial: Add driver for MEN's 16z135 High Speed UART.
      tty: serial: men_z135_uart: Don't activate TX Space available IRQ on startup

Jon Ringle (5):
      serial: sc16is7xx
      serial: sc16is7xx: Add bindings documentation for the SC16IS7XX UARTs
      serial: sc16is7xx: depend on I2C
      serial: sc16is7xx: fix implicit decl of func copy_{to,from}_user
      serial: sc16is7xx: dynamically allocate tx/rx buffer

Julia Lawall (1):
      tty: serial: replace del_timer by del_timer_sync

Loic Poulain (1):
      8250_dw: Support all baudrates on baytrail

Michal Simek (3):
      tty: xuartps: Fix kernel-doc errors in the driver
      tty: xuartps: Initialize ports according to aliases
      tty: serial: uartlite: Specify time for sending chars

Murali Karicheri (1):
      serial: uart: add hw flow control support configuration

Qipan Li (1):
      serial: sirf: fix spinlock deadlock issue

Richard Genoud (5):
      tty/serial: atmel_serial: Fix device tree documentation
      ARM: at91: gpio: implement get_direction
      tty/serial: Add GPIOLIB helpers for controlling modem lines
      tty/serial: at91: use mctrl_gpio helpers
      tty/serial: at91: add interrupts for modem control lines

Rob Herring (9):
      x86: move FIX_EARLYCON_MEM kconfig into x86
      tty/serial: add generic serial earlycon
      tty/serial: convert 8250 to generic earlycon
      tty/serial: pl011: add generic earlycon support
      tty/serial: add arm/arm64 semihosting earlycon
      arm64: enable FIX_EARLYCON_MEM kconfig
      arm64: remove arch specific earlyprintk
      tty/serial: add back missing setup_early_serial8250_console
      tty/serial: fix generic earlycon option parsing

Simon Horman (2):
      serial: sh-sci: Add device tree support for r8a7779
      serial: sh-sci: Add device tree support for r8a7779

Soren Brinkmann (5):
      tty: xuartps: Clean up
      tty: xuartps: Print warning in clock notifier
      tty: xuartps: Refactor read-modify-writes
      tty: xuartps: Don't write IRQ disable register to enable interrupts
      tty: xuartps: Rebrand driver as Cadence UART

Stephen Chivers (1):
      printk/of_serial: fix serial console cessation part way through boot.

Takashi Iwai (3):
      vgacon: Fix & cleanup refcounting
      console: Use explicit pointer type for vc_uni_pagedir* fields
      console: Remove superfluous readonly check

Thomee Wright (1):
      serial: Add support for Advantech PCM-3614I/PCM-3618I serial expansion cards

Vincent Stehlé (1):
      serial: efm32: add module_exit

 .../devicetree/bindings/serial/atmel-usart.txt     |   12 +-
 .../devicetree/bindings/serial/nxp,sc16is7xx.txt   |   33 +
 .../devicetree/bindings/serial/of-serial.txt       |    1 +
 .../bindings/serial/renesas,sci-serial.txt         |    1 +
 Documentation/kernel-parameters.txt                |    9 +
 Documentation/serial/driver                        |   25 +
 arch/arm/include/asm/dcc.h                         |   41 +
 arch/arm/mach-at91/at91rm9200_devices.c            |   16 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    7 -
 arch/arm/mach-at91/at91sam9261_devices.c           |    4 -
 arch/arm/mach-at91/at91sam9263_devices.c           |    4 -
 arch/arm/mach-at91/at91sam9g45_devices.c           |    5 -
 arch/arm/mach-at91/at91sam9rl_devices.c            |    5 -
 arch/arm/mach-at91/gpio.c                          |   13 +
 arch/arm64/Kconfig                                 |    3 +
 arch/arm64/Kconfig.debug                           |    9 -
 arch/arm64/kernel/Makefile                         |    1 -
 arch/arm64/kernel/early_printk.c                   |  158 ---
 arch/x86/Kconfig                                   |    3 +
 drivers/bluetooth/hci_ldisc.c                      |   24 +-
 drivers/bluetooth/hci_uart.h                       |    1 +
 drivers/parport/parport_serial.c                   |    9 +
 drivers/tty/hvc/hvc_console.c                      |    9 +-
 drivers/tty/hvc/hvc_dcc.c                          |   42 +-
 drivers/tty/n_hdlc.c                               |    8 +-
 drivers/tty/serial/8250/8250_core.c                |   11 +-
 drivers/tty/serial/8250/8250_dma.c                 |   17 +-
 drivers/tty/serial/8250/8250_dw.c                  |   81 +-
 drivers/tty/serial/8250/8250_early.c               |  138 +--
 drivers/tty/serial/8250/8250_pci.c                 |   19 +
 drivers/tty/serial/8250/Kconfig                    |    6 +-
 drivers/tty/serial/Kconfig                         |   57 +-
 drivers/tty/serial/Makefile                        |    8 +
 drivers/tty/serial/amba-pl011.c                    |   30 +-
 drivers/tty/serial/atmel_serial.c                  |  230 +++-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |    8 +-
 drivers/tty/serial/earlycon-arm-semihost.c         |   61 +
 drivers/tty/serial/earlycon.c                      |  144 +++
 drivers/tty/serial/efm32-uart.c                    |    1 +
 drivers/tty/serial/imx.c                           |   39 +-
 drivers/tty/serial/kgdb_nmi.c                      |   59 +-
 drivers/tty/serial/men_z135_uart.c                 |  867 +++++++++++++
 drivers/tty/serial/mux.c                           |    4 +-
 drivers/tty/serial/of_serial.c                     |    5 +
 drivers/tty/serial/omap-serial.c                   |   94 +-
 drivers/tty/serial/pch_uart.c                      |   13 +-
 drivers/tty/serial/pxa.c                           |    5 -
 drivers/tty/serial/samsung.c                       |   35 +-
 drivers/tty/serial/samsung.h                       |   23 +-
 drivers/tty/serial/sc16is7xx.c                     | 1277 ++++++++++++++++++++
 drivers/tty/serial/sccnxp.c                        |    6 +-
 drivers/tty/serial/serial_core.c                   |   15 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  143 +++
 drivers/tty/serial/serial_mctrl_gpio.h             |  110 ++
 drivers/tty/serial/serial_txx9.c                   |    5 -
 drivers/tty/serial/sirfsoc_uart.c                  |   51 +-
 drivers/tty/serial/sirfsoc_uart.h                  |    4 -
 drivers/tty/serial/st-asc.c                        |    8 +-
 drivers/tty/serial/uartlite.c                      |   17 +-
 drivers/tty/serial/xilinx_uartps.c                 | 1129 +++++++++--------
 drivers/tty/vt/consolemap.c                        |   54 +-
 drivers/tty/vt/vt.c                                |   89 +-
 drivers/video/console/vgacon.c                     |   17 +-
 include/linux/console_struct.h                     |    5 +-
 include/linux/platform_data/atmel.h                |    1 -
 include/linux/serial_core.h                        |   16 +
 include/linux/tty_ldisc.h                          |    5 +-
 include/uapi/linux/serial_core.h                   |    8 +-
 include/uapi/linux/serial_reg.h                    |    2 +-
 kernel/printk/printk.c                             |    1 +
 70 files changed, 4051 insertions(+), 1310 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
 create mode 100644 arch/arm/include/asm/dcc.h
 delete mode 100644 arch/arm64/kernel/early_printk.c
 create mode 100644 drivers/tty/serial/earlycon-arm-semihost.c
 create mode 100644 drivers/tty/serial/earlycon.c
 create mode 100644 drivers/tty/serial/men_z135_uart.c
 create mode 100644 drivers/tty/serial/sc16is7xx.c
 create mode 100644 drivers/tty/serial/serial_mctrl_gpio.c
 create mode 100644 drivers/tty/serial/serial_mctrl_gpio.h
