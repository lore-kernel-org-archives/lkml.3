Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3D2QYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:24:14 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59314 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab3D2QXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:23:44 -0400
Date: Mon, 29 Apr 2013 09:22:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.10-rc1
Message-ID: <20130429162252.GA6950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.10-rc1

for you to fetch changes up to 45efcb2d32d35f6509543e477568842d8467035d:

  tty/serial/sirf: fix MODULE_DEVICE_TABLE (2013-04-23 10:43:18 -0700)

----------------------------------------------------------------
TTY/Serial driver update for 3.10-rc1

Here's the big tty/serial driver merge request for 3.10-rc1

Once again, Jiri has a number of TTY driver fixes and cleanups, and
Peter Hurley came through with a bunch of ldisc fixes that resolve a
number of reported issues.  There are some other serial driver cleanups
as well.

All of these have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (2):
      serial: sccnxp: Do not override device name
      serial: sccnxp: Replace pdata.init/exit with regulator API

Arnd Bergmann (4):
      tty: serial/samsung: prepare for common clock API
      tty: serial/samsung: make register definitions global
      tty: serial/samsung: fix modular build
      tty/serial/sirf: fix MODULE_DEVICE_TABLE

Changlong Xie (1):
      tty: tty_vhangup_session can be static

Chanho Min (2):
      ARM: PL011: Add support for Rx DMA buffer polling.
      amba-pl011: fix build error if CONFIG_DMA_ENGINE is not enabled

Emilio López (1):
      serial: 8250_dw: add support for clk api

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Greg Kroah-Hartman (4):
      Merge 3.9-rc3 into tty-next
      Revert "USB: quatech2: only write to the tty if the port is open."
      Merge 3.9-rc5 into tty-next
      Merge 3.9-rc7 intp tty-next

Heikki Krogerus (13):
      serial: 8250: Allow probe drivers to ignore tx_loadsz
      serial: of_serial: Handle fifo-size property
      serial: of_serial: Handle auto-flow-control property
      serial: 8250_dma: TX cleanup
      serial: 8250_dma: Fix RX handling
      serial: 8250_dma: Use dmaengine helpers to get the slave channels
      serial: 8250_dma: Provide default slave configuration parameters
      serial: 8250_dw: Enable runtime PM
      serial: 8250_dw: Support clk framework also with ACPI
      serial: 8250_dw: Let ACPI code extract the DMA client info
      serial: 8250_dw: Set port capabilities based on CPR register
      serial: 8250_dw: Convert to devm_ioremap()
      serial: 8250_dw: Fix the stub for dw8250_probe_acpi()

Jingoo Han (2):
      TTY: amiserial, use module_platform_driver_probe()
      serial: max3100: use spi_get_drvdata() and spi_set_drvdata()

Jiri Slaby (20):
      TTY: jsm, remove superfluous check
      TTY: synclink, remove superfluous check
      TTY: do not warn about setting speed via SPD_*
      TTY: msm_smd_tty, clean up activate/shutdown
      TTY: add tty_port_tty_wakeup helper
      TTY: quatech2, remove unneeded is_open
      TTY: add tty_port_tty_hangup helper
      TTY: serial/bfin_uart, unbreak build with KGDB enabled
      TTY: serial/msm_serial_hs, remove unused tty
      TTY: cleanup tty->hw_stopped uses
      crisv10: use flags from tty_port
      crisv10: stop returning info from handle_ser_rx_interrupt
      crisv10: remove unused members
      crisv10: use close delays from tty_port
      crisv10: use *_wait from tty_port
      crisv10: use counts from tty_port
      TTY: serial, stop accessing potential NULLs
      CAIF: fix tty->warned build error
      TTY: rocket, fix compilation warning
      TTY: pty, fix compilation warning

Johan Hovold (10):
      TTY: clean up port shutdown
      TTY: wake up processes last at hangup
      TTY: fix DTR being raised on hang up
      TTY: fix DTR not being dropped on hang up
      TTY: clean up port drain-delay handling
      TTY: fix close of uninitialised ports
      TTY: synclink: fix DTR being raised on hang up
      TTY: synclink_gt: fix DTR being raised on hang up
      TTY: synclinkmp: fix DTR being raised on hang up
      TTY: ircomm: fix DTR being raised on hang up

Jongsung Kim (1):
      ARM: PL011: add support for extended FIFO-size of PL011-r1p5

Karthik Manamcheri (1):
      serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly

Lars-Peter Clausen (4):
      tty: max3100: Use dev_pm_ops
      tty: max310x: Use dev_pm_ops
      tty: mrst_max3110: Use dev_pm_ops
      tty: ifx6x60: Remove unused suspend/resume callbacks

Liang Li (1):
      serial: pch_uart: add console poll support

Michael Spang (2):
      serial: samsung: Restore IRQ mask during noirq resume
      serial: samsung: Avoid waiting forever for TX ready

Paul Bolle (2):
      serial: sh-sci: remove obsolete Kconfig macros
      serial: 8250: remove a few lines of dead code

Peter Hurley (39):
      pty: Remove redundant itty reset
      tty: Refactor session leader SIGHUP from __tty_hangup()
      tty: Fix spinlock flavor in non-atomic __tty_hangup()
      tty: Use spin_lock() inside existing critical region
      tty: Signal foreground group processes in hangup
      tty: Signal SIGHUP before hanging up ldisc
      n_tty: Inline check_unthrottle() at lone call site
      tty: Add safe tty throttle/unthrottle functions
      n_tty: Fix stuck throttled driver
      n_tty: Fix unsafe driver-side signals
      n_tty: Lock access to tty->pgrp for POSIX job control
      tty: Fix checkpatch errors in tty_ldisc.h
      tty: Add diagnostic for halted line discipline
      n_tty: Factor packet mode status change for reuse
      n_tty: Don't flush buffer when closing ldisc
      tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
      tty: Remove unnecessary re-test of ldisc ref count
      tty: Fix ldisc halt sequence on hangup
      tty: Relocate tty_ldisc_halt() to avoid forward declaration
      tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()
      tty: Halt both ldiscs concurrently
      tty: Wait for SAK work before waiting for hangup work
      n_tty: Correct unthrottle-with-buffer-flush comments
      n_tty: Fully initialize ldisc before restarting buffer work
      tty: Don't reenable already enabled ldisc
      tty: Complete ownership transfer of flip buffers
      tty: Make core responsible for synchronizing its work
      tty: Fix 'deferred reopen' ldisc comment
      tty: Bracket ldisc release with TTY_DEBUG_HANGUP messages
      tty: Add ldisc hangup debug messages
      tty: Don't protect atomic operation with mutex
      tty: Separate release semantics of ldisc reference
      tty: Document unsafe ldisc reference acquire
      tty: Fold one-line assign function into callers
      tty: Locate get/put ldisc functions together
      tty: Remove redundant tty_wait_until_sent()
      tty: Fix recursive deadlock in tty_perform_flush()
      tty: Fix race condition if flushing tty flip buffers
      tty: Fix unsafe bit ops in tty_throttle_safe/unthrottle_safe

Sachin Kamat (2):
      serial: tegra: Convert to devm_ioremap_resource()
      serial: vt8500_serial: Convert to devm_ioremap_resource()

Steffen Trumtrar (1):
      serial: xilinx_uartps: remove superfluous IDR write

Syam Sidhardhan (1):
      tty: ipwireless: Remove redundant NULL check before kfree

Tomasz Figa (1):
      tty: serial: samsung: Disable interrupts in a suspend-friendly way

Wolfram Sang (2):
      serial: mxs: fix buffer overflow
      serial: mxs: drop superfluous {get|put}_device

Zhang Yanfei (2):
      driver: tty: serial: remove cast for kzalloc return value
      driver: tty: vt: remove cast for kmalloc return value

zhangwei(Jovi) (1):
      sysrq: fix inconstistent help message of sysrq key

 .../devicetree/bindings/tty/serial/of-serial.txt   |   4 +
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |   5 +
 arch/arm/mach-s3c24xx/common.c                     |   5 +
 arch/arm/plat-samsung/include/plat/regs-serial.h   | 282 +-----------------
 arch/ia64/hp/sim/simserial.c                       |  16 +-
 arch/um/drivers/chan_kern.c                        |   6 +-
 arch/um/drivers/line.c                             |   8 +-
 drivers/isdn/capi/capi.c                           |   7 +-
 drivers/isdn/gigaset/interface.c                   |   6 +-
 drivers/isdn/i4l/isdn_tty.c                        |   3 -
 drivers/mmc/card/sdio_uart.c                       |  13 +-
 drivers/net/caif/caif_serial.c                     |   4 +-
 drivers/net/ppp/ppp_async.c                        |   2 +-
 drivers/net/ppp/ppp_synctty.c                      |   2 +-
 drivers/net/usb/hso.c                              |  20 +-
 drivers/s390/char/sclp_tty.c                       |   9 +-
 drivers/s390/char/sclp_vt220.c                     |   8 +-
 drivers/staging/fwserial/fwserial.c                |  10 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   7 +-
 drivers/tty/amiserial.c                            |  14 +-
 drivers/tty/cyclades.c                             |  10 +-
 drivers/tty/ehv_bytechan.c                         |   6 +-
 drivers/tty/hvc/hvsi.c                             |   7 +-
 drivers/tty/ipwireless/hardware.c                  |   3 +-
 drivers/tty/moxa.c                                 |  19 +-
 drivers/tty/mxser.c                                |   4 +
 drivers/tty/n_gsm.c                                |  10 +-
 drivers/tty/n_tty.c                                | 172 ++++++-----
 drivers/tty/nozomi.c                               |  15 +-
 drivers/tty/pty.c                                  |  13 +-
 drivers/tty/rocket.c                               |  66 ++---
 drivers/tty/serial/68328serial.c                   |   9 +-
 drivers/tty/serial/8250/8250.h                     |   7 -
 drivers/tty/serial/8250/8250_core.c                |  18 +-
 drivers/tty/serial/8250/8250_dma.c                 |  52 ++--
 drivers/tty/serial/8250/8250_dw.c                  | 194 ++++++------
 drivers/tty/serial/amba-pl011.c                    | 181 ++++++++++--
 drivers/tty/serial/arc_uart.c                      |   2 +-
 drivers/tty/serial/bfin_uart.c                     |  23 --
 drivers/tty/serial/crisv10.c                       | 168 +++++------
 drivers/tty/serial/crisv10.h                       |  14 -
 drivers/tty/serial/icom.c                          |   3 +-
 drivers/tty/serial/ifx6x60.c                       |  80 +----
 drivers/tty/serial/jsm/jsm_tty.c                   |   6 -
 drivers/tty/serial/max3100.c                       |  24 +-
 drivers/tty/serial/max310x.c                       |  24 +-
 drivers/tty/serial/mrst_max3110.c                  |  19 +-
 drivers/tty/serial/msm_serial_hs.c                 |   2 -
 drivers/tty/serial/msm_smd_tty.c                   |  14 +-
 drivers/tty/serial/mxs-auart.c                     |   6 +-
 drivers/tty/serial/of_serial.c                     |  17 +-
 drivers/tty/serial/pch_uart.c                      | 103 +++++--
 drivers/tty/serial/samsung.c                       |  63 +++-
 drivers/tty/serial/samsung.h                       |   4 +-
 drivers/tty/serial/sccnxp.c                        |  23 +-
 drivers/tty/serial/serial-tegra.c                  |   9 +-
 drivers/tty/serial/serial_core.c                   |   4 +
 drivers/tty/serial/sh-sci.h                        |   2 -
 drivers/tty/serial/sirfsoc_uart.c                  |   2 +-
 drivers/tty/serial/sunsab.c                        |   2 +-
 drivers/tty/serial/sunzilog.c                      |   2 +-
 drivers/tty/serial/vt8500_serial.c                 |   7 +-
 drivers/tty/serial/xilinx_uartps.c                 |   3 -
 drivers/tty/synclink.c                             |   5 +-
 drivers/tty/synclink_gt.c                          |   2 +-
 drivers/tty/synclinkmp.c                           |   2 +-
 drivers/tty/sysrq.c                                |  38 +--
 drivers/tty/tty_buffer.c                           |  22 +-
 drivers/tty/tty_io.c                               | 170 +++++++----
 drivers/tty/tty_ioctl.c                            | 120 +++++---
 drivers/tty/tty_ldisc.c                            | 326 ++++++++++-----------
 drivers/tty/tty_port.c                             | 111 +++++--
 drivers/tty/vt/consolemap.c                        |   3 +-
 drivers/usb/class/cdc-acm.c                        |  31 +-
 drivers/usb/serial/digi_acceleport.c               |  17 +-
 drivers/usb/serial/io_edgeport.c                   |  28 +-
 drivers/usb/serial/keyspan.c                       |  43 +--
 drivers/usb/serial/keyspan_pda.c                   |   6 +-
 drivers/usb/serial/mos7720.c                       |   8 +-
 drivers/usb/serial/mos7840.c                       |   7 +-
 drivers/usb/serial/option.c                        |   9 +-
 drivers/usb/serial/quatech2.c                      |  17 +-
 drivers/usb/serial/sierra.c                        |   8 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   7 +-
 drivers/usb/serial/usb-serial.c                    |  10 +-
 include/linux/amba/serial.h                        |   3 +
 include/linux/platform_data/serial-sccnxp.h        |   4 -
 include/linux/serial_s3c.h                         | 260 ++++++++++++++++
 include/linux/tty.h                                |  41 ++-
 include/linux/tty_ldisc.h                          | 132 ++++-----
 net/irda/ircomm/ircomm_tty.c                       |   2 +-
 net/irda/ircomm/ircomm_tty_attach.c                |   6 +-
 92 files changed, 1670 insertions(+), 1611 deletions(-)
 create mode 100644 include/linux/serial_s3c.h
