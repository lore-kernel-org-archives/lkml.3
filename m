Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaDASqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:46:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaDASq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:46:28 -0400
Date: Tue, 1 Apr 2014 11:48:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.15-rc1
Message-ID: <20140401184848.GA21898@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.15-rc1

for you to fetch changes up to 3a13884abea08a5043b98d9374486ec859d1e03a:

  tty/serial: omap: empty the RX FIFO at the end of half-duplex TX (2014-03-17 16:23:08 -0700)

----------------------------------------------------------------
TTY/Serial driver update for 3.15-rc1

Here's the big tty/serial driver update for 3.15-rc1.

Nothing major, a number of serial driver updates and a few tty core
fixes as well.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaron Sierra (2):
      serial: 8250_pci: more BayTrail error-free bauds
      serial: 8250_pci: change BayTrail default uartclk

Adam Borowski (2):
      vt: drop an useless enum and assignment.
      vt: detect and ignore OSC codes.

Alexander Shiyan (23):
      serial: max310x: Allow driver to be compiled as module
      serial: max310x: Setup baud rate generator more precisely
      serial: max310x: Remove init() and exit() callbacks
      serial: max310x: Remove excess port configure at startup
      serial: max310x: Add the loopback mode support
      serial: max310x: Remove IRQ validation
      serial: max310x: Move all SPI-dependent stuff in one place
      serial: max310x: Migrate to CLK API
      serial: max310x: Always use dynamic GPIO ID assignment
      serial: max310x: Add missing mutex_destroy() on driver exit
      serial: max310x: Add support for RS-485 mode
      serial: max310x: Driver cleanup
      serial: max310x: Add devicetree support
      serial: max310x: Add bindings documentation for the MAX310X UARTs
      serial: max310x: Fix build error
      serial: max310x: Fix build warning
      serial: max310x: Fix build error
      serial: max310x: Fix sparse warnings
      serial: max310x: Fix devicetree documentation for clock name
      serial: imx: Use devm_ioremap_resource()
      serial: imx: Use dev_name() for request_irq() to distinguish UARTs
      serial: imx: Remove init() and exit() platform callbacks
      serial: clps711x: Give a chance to perform useful tasks during wait loop

Baruch Siach (1):
      serial: sh_sci: remove HAVE_CLK build dependecy

Dimitris Lampridis (2):
      tty/serial: omap: fix RX interrupt enable/disable in half-duplex TX
      tty/serial: omap: empty the RX FIFO at the end of half-duplex TX

Florian Fainelli (3):
      tty: serial: bcm63xx_uart: include linux/io.h
      tty: serial: bcm63xx_uart: define UART_REG_SIZE constant
      tty: serial: bcm63xx_uart: add support for DT probing

Geert Uytterhoeven (11):
      serial_core: Unregister console in uart_remove_one_port()
      serial: sh-sci: Add missing call to uart_remove_one_port() in failure path
      serial: max310x: Add missing #include <linux/uaccess.h>
      serial_core: Spelling s/contro/control/
      serial_core: Grammar s/ports/port's/
      serial_core: Get a reference for port->tty in uart_remove_one_port()
      serial_core: Avoid NULL pointer dereference in uart_close()
      serial: sh-sci: Replace printk() by pr_*()
      serial: sh-sci: Remove useless casts
      serial: sh-sci: Add more register documentation
      serial: sh-sci: Replace hardcoded 3 by UART_PM_STATE_OFF

Greg Kroah-Hartman (5):
      Merge branch 'tty-linus' into tty-next
      Revert "serial: max310x: Fix build error"
      Merge 3.14-rc3 into tty-next
      Merge 3.14-rc4 into tty-next
      Merge 3.14-rc5 into tty-next

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Huang Shijie (1):
      serial: imx: always wake up the processes in the TX callback

Ingo Molnar (1):
      serial: 8250: Clean up the locking for -rt

Jingoo Han (2):
      serial: sh-sci: Fix cast warning
      serial: pch_uart: Fix build warning when CONFIG_DEBUG_FS=n

Joe Perches (1):
      serial: sh-sci: Neaten dev_<level> uses

Laurent Pinchart (2):
      serial: sh-sci: Fix compatible string in DT bindings example
      serial: sh-sci: Restrict non-COMPILE_TEST compilation

Markus Pargmann (1):
      serial: omap-serial: Move info message to probe function

Nicolas Ferre (1):
      tty/serial: atmel_serial: remove dev_dbg in atmel_set_termios

Paul Bolle (1):
      tty: serial: crisv10: Drop remaining code for CRISv10 CPU simulator

Paul Gortmaker (2):
      hvc: ensure hvc_init is only ever called once in hvc_console.c
      drivers/tty/serial: deal with 8250_core.c uninitialized warning for good

Peter Hurley (2):
      n_tty: Simplify input_available_p()
      tty: Fix low_latency BUG

Qipan Li (1):
      serial: sirf: move to use generic dma dt-binding to get dma channels

Richard Genoud (2):
      tty/serial: at91: use dev_err instead of printk
      tty/serial: at91: remove unused open/close hooks

Sachin Kamat (1):
      tty: tty_ldisc.h: Remove duplicate include

Salva Peiró (1):
      synclink: fix info leak in ioctl

Stephen Boyd (1):
      msm_serial: Add support for poll_{get,put}_char()

Tushar Behera (2):
      serial: samsung: Move uart_register_driver call to device probe
      serial: pl011: Move uart_register_driver call to device probe

Uwe Kleine-König (1):
      serial: efm32: properly namespace location property

Yuan Yao (2):
      serial: fsl_lpuart: add DMA support
      serial: fsl_lpuart: documented the clock requirement.

 .../devicetree/bindings/serial/efm32-uart.txt      |   4 +-
 .../devicetree/bindings/serial/fsl-lpuart.txt      |  21 +-
 .../devicetree/bindings/serial/maxim,max310x.txt   |  36 ++
 .../bindings/serial/renesas,sci-serial.txt         |   2 +-
 arch/arm/boot/dts/atlas6.dtsi                      |  17 +-
 arch/arm/boot/dts/prima2.dtsi                      |  20 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |  21 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/ipwireless/tty.c                       |   3 -
 drivers/tty/n_tty.c                                |  11 +-
 drivers/tty/serial/8250/8250_core.c                |  19 +-
 drivers/tty/serial/8250/8250_pci.c                 |  43 ++-
 drivers/tty/serial/Kconfig                         |   4 +-
 drivers/tty/serial/amba-pl011.c                    |  21 +-
 drivers/tty/serial/atmel_serial.c                  |  28 +-
 drivers/tty/serial/bcm63xx_uart.c                  |  16 +-
 drivers/tty/serial/clps711x.c                      |  21 +-
 drivers/tty/serial/crisv10.c                       | 112 ------
 drivers/tty/serial/efm32-uart.c                    |   5 +-
 drivers/tty/serial/fsl_lpuart.c                    | 430 ++++++++++++++++++++-
 drivers/tty/serial/imx.c                           |  82 +---
 drivers/tty/serial/max310x.c                       | 417 +++++++++++---------
 drivers/tty/serial/msm_serial.c                    | 140 ++++++-
 drivers/tty/serial/msm_serial.h                    |   9 +
 drivers/tty/serial/omap-serial.c                   |  11 +-
 drivers/tty/serial/pch_uart.c                      |   2 +
 drivers/tty/serial/samsung.c                       |  40 +-
 drivers/tty/serial/serial_core.c                   |  20 +-
 drivers/tty/serial/sh-sci.c                        |  86 ++---
 drivers/tty/serial/sirfsoc_uart.c                  | 195 +++-------
 drivers/tty/serial/sirfsoc_uart.h                  |   5 -
 drivers/tty/synclink.c                             |   1 +
 drivers/tty/synclinkmp.c                           |   1 +
 drivers/tty/tty_buffer.c                           |  20 +-
 drivers/tty/tty_io.c                               |  23 +-
 drivers/tty/vt/vt.c                                |  20 +-
 drivers/usb/gadget/u_serial.c                      |   4 +-
 include/linux/platform_data/max310x.h              |  64 ---
 include/linux/platform_data/serial-imx.h           |   2 -
 include/linux/serial_bcm63xx.h                     |   2 +
 include/linux/serial_sci.h                         |  93 +++--
 include/linux/tty.h                                |   2 +-
 include/linux/tty_ldisc.h                          |   1 -
 43 files changed, 1233 insertions(+), 847 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/maxim,max310x.txt
 delete mode 100644 include/linux/platform_data/max310x.h
