Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3KFW5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:57:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52530 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3KFW5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:21 -0500
Date: Wed, 6 Nov 2013 14:52:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.13-rc1
Message-ID: <20131106225243.GA8621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.13-rc1

for you to fetch changes up to 80d8611dd07603736d14e4a942546bdc84dd5477:

  serial: omap: fix missing comma (2013-10-31 09:03:20 -0700)

----------------------------------------------------------------
TTY/Serial driver updates for 3.13-rc1

Here's the big tty/serial driver update for 3.13-rc1.

There's some more minor n_tty work here, but nothing like previous
kernel releases.  Also some new driver ids, driver updates for new
hardware, and other small things.

All of this has been in linux-next for a while with no issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adam Borowski (2):
      vt: break a couple of obsolete SCOish codes.
      vt: properly ignore xterm-256 colour codes

Alexey Pelykh (2):
      OMAP/serial: Fix misnamed variable
      OMAP/serial: Fix Mode13 vs Mode16 priority

Angelo Butti (1):
      serial: 8250_pci: add Pericom PCIe Serial board Support (12d8:7952/4/8) - Chip PI7C9X7952/4/8

Bartlomiej Zolnierkiewicz (1):
      TTY: bfin_jtag_comm: fix incorrect placement of __initdata tag

Ben Hutchings (5):
      serial: mfd: Replace MODULE_ALIAS with MODULE_DEVICE_TABLE
      serial: pch_uart: Add MODULE_DEVICE_TABLE
      hvc_vio: Do not override preferred console set by kernel parameter
      sysrq: Document hexadecimal values for kernel.sysrq bitmask
      sysrq: Allow magic SysRq key functions to be disabled through Kconfig

Bin Gao (1):
      serial: mrst_max3110: Fix race condition between spi transfers

Chen, Jie (1):
      mrst_max3110: fix unbalanced IRQ issue during resume

Dave Jones (1):
      tty: serial: Restrict ST ASC driver to only build on !ARM when COMPILE_TEST is set.

Fabio Estevam (1):
      serial: imx: Use NULL as the last argument of add_preferred_console()

Feng Tang (1):
      serial: mrst_max3110: Check the irq number before enable/disabe irq in PM hooks

Greg Kroah-Hartman (4):
      Merge 3.12-rc3 into tty-next
      serial: 8250_pci: clean up printk() calls
      Merge 3.12-rc4 into tty-next
      serial: 8250_pci: add support for Fintek 4, 8, and 12 port cards

Hector Palacios (1):
      serial: mxs-auart: set the FIFO size to DMA buffer size

Heikki Krogerus (5):
      serial: 8250: don't change the fifo trigger level when using dma
      serial: 8250_dw: don't limit DMA support to ACPI
      serial: 8250_dw: provide a filter for DMA channel detection
      serial: 8250_pci: add support for Intel BayTrail
      serial: 8250_dw: fix broken function call

Huang Shijie (5):
      serial: imx: implement the flush_buffer hook
      serial: imx: check the DMA for imx_tx_empty
      serial: imx: fix the wrong number of scatterlist entries when xmit->head is 0
      serial: imx: use the dmaengine_tx_status
      serial: imx: optimization: remove the workqueues for DMA

Jingoo Han (11):
      serial: arc_uart: Remove casting the return value which is a void pointer
      serial: mpsc: Remove casting the return value which is a void pointer
      serial: bfin_uart: Remove casting the return value which is a void pointer
      serial: bfin_sport_uart: Remove casting the return value which is a void pointer
      serial: ifx6x60: Remove casting the return value which is a void pointer
      serial: samsung: Remove casting the return value which is a void pointer
      serial: mpc512x: Remove casting the return value which is a void pointer
      serial: mfd: remove unnecessary pci_set_drvdata()
      serial: txx9: remove unnecessary pci_set_drvdata()
      serial: 8250_pci: remove unnecessary pci_set_drvdata()
      serial: mfd: Staticize local symbols

Joe Perches (1):
      tty: Remove unnecessary semicolons

José Miguel Gonçalves (1):
      serial: samsung: add support for manual RTS setting

Lars-Peter Clausen (1):
      tty: xuartps: Force enable the UART in xuartps_console_write

Laurent Pinchart (1):
      serial: sh-sci: Enable the driver on all ARM platforms

Linus Walleij (5):
      serial: omap: delete .set_wake callback
      serial: sa1100: delete .set_wake callback
      serial: mpc52xx: remove reference to .set_wake()
      serial: pch_uart: remove reference to .set_wake()
      serial: core: delete .set_wake() callback

Michael Opdenacker (3):
      serial: tegra: remove deprecated IRQF_DISABLED
      serial: bfin_uart: remove deprecated IRQF_DISABLED
      serial: sirf: remove duplicate defines

Michal Simek (1):
      serial: Remove unnecessary amba_set_drvdata()

Nicolas Ferre (2):
      tty/serial: at91: fix uart/usart selection for older products
      tty/serial: at91: add a fallback option to determine uart/usart property

Olof Johansson (1):
      serial: imx: Change cast to handle 64-bit resource_size_t

Peter Hurley (5):
      n_tty: Remove superfluous reader wakeup
      n_tty: Remove unnecessary local variable
      n_tty: Style fix in n_tty_set_termios
      tty: Prevent tty_port destruction if tty not released
      tty: Remove unused drop() method from tty_port interface

Philippe Proulx (3):
      serial: omap: improve RS-485 performance
      serial: omap: fix a few checkpatch warnings
      serial: omap: fix missing comma

Qipan Li (1):
      serial: sirf: don't submit dma desc after timeout irqs occur

Rob Herring (1):
      TTY: hvc_dcc: probe for a JTAG connection before registering

Roel Kluin (1):
      tty: incorrect test of echo_buf() result for ECHO_OP_START

Shinya Kuribayashi (1):
      serial8250-em: convert to clk_prepare/unprepare

Soren Brinkmann (9):
      tty: xuartps: Use devm_clk_get()
      tty: xuartps: Use devm_kzalloc
      tty: xuartps: Updating set_baud_rate()
      tty: xuartps: Dynamically adjust to input frequency changes
      tty: xuartps: Implement suspend/resume callbacks
      tty: xuartps: Update copyright information
      tty: xuartps: Fix "may be used uninitialized" build warning
      tty: xuartps: Fix build error due to missing forward declaration
      tty: xuartps: Fix build error when COMMON_CLK is not set

Suneel (1):
      tty: xuartps: support 64 byte FIFO size

Tim Kryger (1):
      serial: 8250_dw: Improve unwritable LCR workaround

Tony Lindgren (1):
      serial: omap: Add support for optional wake-up

Uwe Kleine-König (1):
      serial: clps711x: drop needless devm_clk_put

Vlad Lungu (2):
      tty: xuartps: Implement BREAK detection, add SYSRQ support
      tty: xuartps: Add polled mode support for xuartps

Wei Yongjun (1):
      serial: sccnxp: missing uart_unregister_driver() on error in sccnxp_probe()

 Documentation/serial/driver          |   4 -
 Documentation/sysrq.txt              |  28 +-
 drivers/tty/bfin_jtag_comm.c         |   2 +-
 drivers/tty/hvc/hvc_dcc.c            |  21 ++
 drivers/tty/hvc/hvc_vio.c            |   5 +-
 drivers/tty/n_tty.c                  |  13 +-
 drivers/tty/nozomi.c                 |   6 +-
 drivers/tty/serial/8250/8250_core.c  |   2 +-
 drivers/tty/serial/8250/8250_dw.c    |  76 +++--
 drivers/tty/serial/8250/8250_em.c    |   6 +-
 drivers/tty/serial/8250/8250_pci.c   | 347 ++++++++++++++++++++--
 drivers/tty/serial/Kconfig           |   3 +-
 drivers/tty/serial/amba-pl010.c      |   3 -
 drivers/tty/serial/amba-pl011.c      |   3 -
 drivers/tty/serial/arc_uart.c        |   2 +-
 drivers/tty/serial/atmel_serial.c    |  28 +-
 drivers/tty/serial/bfin_sport_uart.c |  11 +-
 drivers/tty/serial/bfin_uart.c       |  21 +-
 drivers/tty/serial/clps711x.c        |   2 -
 drivers/tty/serial/ifx6x60.c         |   2 +-
 drivers/tty/serial/imx.c             |  85 +++---
 drivers/tty/serial/ip22zilog.c       |   2 +-
 drivers/tty/serial/max310x.c         |   2 +-
 drivers/tty/serial/mfd.c             |  13 +-
 drivers/tty/serial/mpc52xx_uart.c    |   5 +-
 drivers/tty/serial/mpsc.c            |   2 +-
 drivers/tty/serial/mrst_max3110.c    |  45 +--
 drivers/tty/serial/mxs-auart.c       |   9 +-
 drivers/tty/serial/omap-serial.c     | 141 ++++++---
 drivers/tty/serial/pch_uart.c        |   3 +-
 drivers/tty/serial/pmac_zilog.c      |   2 +-
 drivers/tty/serial/sa1100.c          |   5 +-
 drivers/tty/serial/samsung.c         |  22 +-
 drivers/tty/serial/samsung.h         |   2 +-
 drivers/tty/serial/sccnxp.c          |   1 +
 drivers/tty/serial/serial-tegra.c    |   2 +-
 drivers/tty/serial/serial_txx9.c     |   2 -
 drivers/tty/serial/sirfsoc_uart.c    |  11 +-
 drivers/tty/serial/sirfsoc_uart.h    |  12 -
 drivers/tty/serial/sunsab.c          |   2 +-
 drivers/tty/serial/sunsu.c           |   2 +-
 drivers/tty/serial/sunzilog.c        |   6 +-
 drivers/tty/serial/ucc_uart.c        |   2 +-
 drivers/tty/serial/xilinx_uartps.c   | 551 ++++++++++++++++++++++++++++++-----
 drivers/tty/sysrq.c                  |   2 +-
 drivers/tty/tty_port.c               |  10 +-
 drivers/tty/vt/vt.c                  |  33 ++-
 include/linux/atmel_serial.h         |   1 +
 include/linux/serial_core.h          |   1 -
 include/linux/sysrq.h                |   3 -
 include/linux/tty.h                  |   1 -
 kernel/sysctl.c                      |   2 +-
 lib/Kconfig.debug                    |   9 +
 53 files changed, 1204 insertions(+), 372 deletions(-)
