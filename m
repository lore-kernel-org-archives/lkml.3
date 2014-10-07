Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaJGWcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:32:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJGWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:32:29 -0400
Date: Tue, 7 Oct 2014 15:32:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.18-rc1
Message-ID: <20141007223228.GA5490@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.18-rc1

for you to fetch changes up to 69784fa539efa477f39b5a849c27d5e630e0db27:

  Revert "serial/core: Initialize the console pm state" (2014-10-02 21:33:50 -0700)

----------------------------------------------------------------
TTY/Serial driver patches for 3.18-rc1

Here's the big tty/serial driver patchset for 3.18-rc1.

Lots of little things in here, some good work from Peter Hurley on the
tty core, and in lots of drivers.  There are also lots of other driver
updates in here as well, full details in the changelog below.

All have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (3):
      serial: clps711x: Use mctrl_gpio helpers for handling modem signals
      serial: clps711x: Fix COMPILE_TEST build for target without GPIOLIB support
      tty: serial_mctrl_gpio: Fix COMPILE_TEST build for architectures with custom termios.h

Alexey Charkov (4):
      tty: vt8500_serial: add support for UART in WM8880 chips
      tty: vt8500_serial: add missing support for RTS setting
      tty: vt8500_serial: add polled console functions
      tty: vt8500_serial: explicitly calculate base baud rate

Bill Pemberton (2):
      jsm: add support for additional Neo cards
      staging: dgnc: remove Neo card ids from device table

Bryan O'Donoghue (1):
      serial: 8250: Add Quark X1000 to 8250_pci.c

Carlo Caione (1):
      ARM: meson: serial: add MesonX SoC on-chip uart driver

Chen Gang (1):
      drivers/tty/nozomi.c: Use 'nozomi_setup_memory' instead of 'setup_memory'

Cyrill Gorcunov (1):
      tty: Fix potential use after free in release_one_tty

Daniel Thompson (4):
      serial: amba-pl011: Use container_of() to get uart_amba_port
      serial: kgdb_nmi: No CON_ENABLED by default
      serial: asc: Adopt readl_/writel_relaxed()
      serial: asc: Conditionally use readl_relaxed (COMPILE_TEST)

Daniele Forsi (1):
      serial: 8250_hp300: trivial: fix symbol name in #warning message

Dirk Behme (1):
      serial: imx: clean up imx_poll_get_char()

Frans Klaver (2):
      tty: omap-serial: fix division by zero
      tty: omap-serial: pull out calculation from baud_is_mode16

Fugang Duan (1):
      serial: imx: fix throttle/unthrottle callbacks for hardware assisted flow control

Geert Uytterhoeven (1):
      m68k: AMIGA_BUILTIN_SERIAL should depend on TTY

Greg Kroah-Hartman (2):
      Merge 3.17-rc5 into tty-next
      Revert "serial/core: Initialize the console pm state"

Hans Wennborg (1):
      TTY: fix decimal printf format specifiers prefixed with 0x

Heikki Krogerus (1):
      serial: 8250_pci: remove rts_n override from Baytrail quirk

Huang Shijie (2):
      serial: imx: terminate the RX DMA when the UART is suspending
      serial: imx: change the wait even to interruptiable

James Hogan (1):
      tty/metag_da: Add console_poll module parameter

Jingchang Lu (2):
      doc: dt-binding: of-serial: add Freescale 64-byte FIFO mode uart binding
      serial: of-serial: add PM suspend/resume support

Julia Lawall (1):
      serial: vr41xx_siu: delete double assignment

Kiran Padwal (5):
      tty: serial: msm: remove braces {} in msm_serial.c
      tty: serial: msm: Fix 'Missing a blank line after declarations' warning
      tty: serial: msm: Fix style warnings relating to printk()
      tty: serial: msm: Fix 'else is not generally useful after a break or return' warning
      tty: serial: msm: Fix 'void function return statements are not generally useful' warning

Mark Rustad (1):
      tty/vt/keyboard: Resolve many shadow warnings

Matthias Brugger (3):
      tty: fix typo in comment of tty_termios_encode_baud_rate
      tty: serial: 8250: Add Mediatek UART driver
      DTS: serial: Add bindings documention for the Mediatek UARTs

Michal Simek (3):
      tty: serial: xuartps: Remove .owner field for driver
      tty: serial: uartlite: Remove .owner field for driver
      serial: cadence: Add generic earlycon support

Naveen Krishna Chatradhi (1):
      tty/serial: samsung: enable usage for 64-bit Exynos platforms

Peter Hurley (29):
      tty: Fix spurious poll() wakeups
      Revert "serial: uart: add hw flow control support configuration"
      serial: Style fix
      serial: imx: Fix x_char handling and tx flow control
      serial: core: Fix x_char race
      serial: core: Remove unsafe x_char optimization
      serial: Fix send_xchar() handlers
      serial: mpc52xx: Use default serial core x_char handler
      serial: sunsab: Don't enable tx if tx stopped
      serial: blackfin: Fix missing gpio.h
      serial: core: Document lock requirement for UPF_* flags updates
      serial: 8250: Document serial8250_modem_status() locking
      serial: core: Unwrap tertiary assignment in uart_handle_dcd_change()
      locking: Add WARN_ON_ONCE lock assertion
      serial: core: Document and assert lock requirements for irq helpers
      serial: core: Privatize modem status enable flags
      isdn: i4l: Remove ASYNC_CTS_FLOW
      serial: core: Privatize tty->hw_stopped
      usb: serial: Remove unused tty->hw_stopped
      serial: bfin-uart: Fix auto CTS
      serial: core: Use spin_lock_irq() in uart_set_termios()
      tty: Convert tty_struct bitfield to ints
      tty: Serialize tty flow control changes with flow_lock
      tty: Move packet mode flow control notifications to pty driver
      tty: Serialize tcflow() with other tty flow control changes
      tty: Move and rename send_prio_char() as tty_send_xchar()
      tty: Hold termios_rwsem for tcflow(TCIxxx)
      tty: Workaround Alpha non-atomic byte storage in tty_struct
      tty: Fix width of unsigned long bitfield padding

Pranith Kumar (1):
      serial: Fix build failure caused by missing header file

Ricardo Ribalda Delgado (9):
      serial/8250: Add support for RS485 IOCTLs
      serial: Add support for Fintek F81216A LPC to 4 UART
      serial/8250_core: Add reference to uacess.h
      xtensa/uapi: Add definition of TIOC[SG]RS485
      parisc/uapi: Add definition of TIOC[SG]RS485
      sh/uapi: Add definition of TIOC[SG]RS485
      sparc/uapi: Add definition of TIOC[SG]RS485
      mips/uapi: Add definition of TIOC[SG]RS485
      asm/uapi: Add definition of TIOC[SG]RS485

Sebastian Andrzej Siewior (8):
      tty: serial: 8250_core: provide a function to export uart_8250_port
      tty: serial: 8250_core: allow to overwrite & export serial8250_startup()
      tty: serial: 8250_core: allow to set ->throttle / ->unthrottle callbacks
      tty: serial: 8250_core: add run time pm
      tty: serial: 8250_core: read only RX if there is something in the FIFO
      tty: serial: 8250_core: use the ->line argument as a hint in serial8250_find_match_or_unused()
      tty: serial: 8250_core: remove UART_IER_RDI in serial8250_stop_rx()
      tty: serial: 8250: use 32bit variable for rpm_tx_active

Stefano Stabellini (1):
      xen_hvc: no reason to write the type key on xenstore

Stephen Boyd (2):
      serial: msm_serial: Fix kgdb continue
      tty: serial: msm: Add earlycon support

Sudhir Sreedharan (1):
      serial/core: Initialize the console pm state

Sudip Mukherjee (1):
      serial: serial_core.c: printk replacement

Tobias Klauser (1):
      serial: altera: Make of_device_id arrays const

Yegor Yefremov (1):
      Documentation: serial: fix header path

 .../bindings/serial/cirrus,clps711x-uart.txt       |   7 +-
 .../devicetree/bindings/serial/mtk-uart.txt        |  22 +
 .../devicetree/bindings/serial/of-serial.txt       |   2 +-
 .../devicetree/bindings/serial/via,vt8500-uart.txt |  17 -
 .../devicetree/bindings/serial/vt8500-uart.txt     |   3 +-
 Documentation/kernel-parameters.txt                |  18 +
 Documentation/serial/driver                        |   2 +
 Documentation/serial/serial-rs485.txt              |   2 +-
 arch/alpha/include/uapi/asm/ioctls.h               |   2 +
 arch/m68k/Kconfig.devices                          |   2 +-
 arch/mips/include/uapi/asm/ioctls.h                |   2 +
 arch/parisc/include/uapi/asm/ioctls.h              |   2 +
 arch/sh/include/uapi/asm/ioctls.h                  |   2 +
 arch/sparc/include/uapi/asm/ioctls.h               |   2 +
 arch/xtensa/include/uapi/asm/ioctls.h              |   2 +
 drivers/isdn/i4l/isdn_tty.c                        |   5 -
 drivers/staging/dgnc/dgnc_driver.c                 |  13 -
 drivers/tty/hvc/hvc_xen.c                          |   3 -
 drivers/tty/metag_da.c                             |  14 +-
 drivers/tty/moxa.c                                 |   2 +-
 drivers/tty/n_tty.c                                |   8 +-
 drivers/tty/nozomi.c                               |   6 +-
 drivers/tty/pty.c                                  |  41 ++
 drivers/tty/serial/8250/8250.h                     |   3 +
 drivers/tty/serial/8250/8250_core.c                | 253 +++++++-
 drivers/tty/serial/8250/8250_fintek.c              | 249 ++++++++
 drivers/tty/serial/8250/8250_hp300.c               |   2 +-
 drivers/tty/serial/8250/8250_mtk.c                 | 294 ++++++++++
 drivers/tty/serial/8250/8250_pci.c                 |  34 +-
 drivers/tty/serial/8250/Kconfig                    |  15 +
 drivers/tty/serial/8250/Makefile                   |   2 +
 drivers/tty/serial/Kconfig                         |  23 +-
 drivers/tty/serial/Makefile                        |   1 +
 drivers/tty/serial/altera_jtaguart.c               |   2 +-
 drivers/tty/serial/altera_uart.c                   |   2 +-
 drivers/tty/serial/amba-pl011.c                    |  54 +-
 drivers/tty/serial/bfin_sport_uart.c               |   1 +
 drivers/tty/serial/bfin_uart.c                     |  15 +-
 drivers/tty/serial/clps711x.c                      |  32 +-
 drivers/tty/serial/imx.c                           |  99 ++--
 drivers/tty/serial/jsm/jsm.h                       |  10 +
 drivers/tty/serial/jsm/jsm_driver.c                |  38 +-
 drivers/tty/serial/kgdb_nmi.c                      |   5 +-
 drivers/tty/serial/meson_uart.c                    | 634 +++++++++++++++++++++
 drivers/tty/serial/mpc52xx_uart.c                  |  17 -
 drivers/tty/serial/msm_serial.c                    | 122 ++--
 drivers/tty/serial/mxs-auart.c                     |   2 +-
 drivers/tty/serial/nwpserial.c                     |   1 +
 drivers/tty/serial/of_serial.c                     |  31 +-
 drivers/tty/serial/omap-serial.c                   |  34 +-
 drivers/tty/serial/serial_core.c                   | 135 +++--
 drivers/tty/serial/serial_mctrl_gpio.c             |   2 +-
 drivers/tty/serial/st-asc.c                        |   8 +
 drivers/tty/serial/sunhv.c                         |   3 +
 drivers/tty/serial/sunsab.c                        |   5 +-
 drivers/tty/serial/uartlite.c                      |   1 -
 drivers/tty/serial/vr41xx_siu.c                    |   1 -
 drivers/tty/serial/vt8500_serial.c                 | 136 ++++-
 drivers/tty/serial/xilinx_uartps.c                 |  20 +-
 drivers/tty/tty_io.c                               |  96 ++--
 drivers/tty/tty_ioctl.c                            |  49 +-
 drivers/tty/vt/keyboard.c                          | 166 +++---
 drivers/usb/serial/digi_acceleport.c               |   7 +-
 drivers/usb/serial/io_ti.c                         |   7 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   7 +-
 include/linux/lockdep.h                            |   5 +
 include/linux/serial_8250.h                        |   6 +
 include/linux/serial_core.h                        |  20 +-
 include/linux/tty.h                                |  15 +-
 include/linux/tty_driver.h                         |   4 +
 include/uapi/linux/serial_core.h                   |   3 +
 71 files changed, 2298 insertions(+), 552 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
 create mode 100644 drivers/tty/serial/8250/8250_fintek.c
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c
 create mode 100644 drivers/tty/serial/meson_uart.c
