Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaLNWf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:35:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLNWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:35:48 -0500
Date: Sun, 14 Dec 2014 14:35:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.19-rc1
Message-ID: <20141214223547.GA3847@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.19-rc1

for you to fetch changes up to dd63af108f0814f0b589659f4e55a7a5af3b7e53:

  Merge 3.18-rc7 into tty-next (2014-12-06 08:17:24 -0800)

----------------------------------------------------------------
TTY/Serial driver patches for 3.19-rc1

Here's the big tty/serial driver update for 3.19-rc1.

There are a number of TTY core changes/fixes in here from Peter Hurley
that have all been teted in linux-next for a long time now.  There are
also the normal serial driver updates as well, full details in the
changelog below.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaron Sierra (2):
      serial: 8250_pci: Handle devices mapped above 4 GiB
      serial: 8250_pci: Check mapping in pci_ni8430_init

Andrew Jackson (5):
      serial: pl011: Allocate TX DMA buffer from DMA capable memory
      serial: pl011: Avoid assumptions about buffer size when refilling TX DMA
      serial: pl011: Set length of DMA transfer
      serial: pl011: Don't enable RX DMA if residue processing not supported
      serial: pl011: Add device tree support for RX DMA polling

Andy Shevchenko (2):
      serial: 8250_dma: call serial8250_tx_dma unconditionally
      serial: 8250_dma: no need to set tx_err twice

Axel Lin (1):
      tty: serial: men_z135_uart: Add terminating entry for men_z135_ids

Christian Riesch (1):
      n_tty: Fix read_buf race condition, increment read_head after pushing data

Cyrille Pitchen (1):
      tty/serial: at91: fix rx ring buffer management

Dan Carpenter (1):
      goldfish: off by one in goldfish_tty_console_setup()

Daniel Thompson (2):
      serial: imx: clean up imx_poll_put_char()
      serial: imx: add imx_poll_init()

David Daney (1):
      serial: 8250_dw: Use 64-bit access for OCTEON.

Dmitry Eremin-Solenikov (1):
      serial: pxa: hold port.lock when reporting modem line changes

Eddie Huang (1):
      tty: serial: Fix mediatek UART driver setting baudrate issue

Fabian Frederick (14):
      goldfish: fix sparse warnings
      serial: use container_of to resolve uart_sio_port from uart_port
      serial: sa1100: use container_of to resolve sa1100_port from uart_port
      serial: use container_of to resolve uart_ip22zilog_port from uart_port
      serial: mpsc: use container_of to resolve mpsc_port_info from uart_port
      serial: cpm_uart: use container_of to resolve uart_cpm_port from uart_port
      TTY: jsm: use container_of to resolve jsm_channel from uart_port
      tty: use container_of to resolve uart_pmac_port from uart_port
      serial: sunsu: use container_of to resolve uart_sunsu_port from uart_port
      serial: sunsab: use container_of to resolve uart_sunsu_port from uart_port
      serial: amba-pl010: use container_of to resolve uart_amba_port from uart_port
      serial: pnx8xxx: use container_of to resolve pnx8xxx_port from uart_port
      serial: use container_of to resolve uart_sunzilog_port from uart_port
      tty: ar933x_uart: use container_of to resolve ar933x_uart_port from uart_port

Fabio Estevam (8):
      serial: imx: Fix the reporting of interrupts
      serial: imx: Remove unneeded goto label
      serial: imx: Remove unneeded OOM error message
      serial: imx: Remove unneeded registration message
      serial: fsl_lpuart: Remove unneeded check for 'res'
      serial: fsl_lpuart: Remove unneeded registration message
      serial: imx: Fix warning when building 'allmodconfig'
      serial: mxs-auart: Fix mxs_auart_set_ldisc()

Frank Rowand (1):
      tty: serial: msm_serial: document DT alias

Frans Klaver (1):
      serial: 8250_core: actually limit char reads to max_count

Geert Uytterhoeven (1):
      serial: sh-sci: Add device tree support for r7s72100

Greg Kroah-Hartman (6):
      Merge branch 'tty-linus' into 'tty-testing'
      Merge 3.18-rc4 into tty-next.
      Revert "serial: of-serial: fetch line number from DT"
      Revert "serial: of-serial: fix up PM ops on no_console_suspend and port type"
      Revert "serial: of-serial: add PM suspend/resume support"
      Merge 3.18-rc7 into tty-next

Gregory Hermant (1):
      max310x: max3109_detect should use indirect addressing in SPI mode for REVID register

Janusz Uzycki (7):
      serial: mxs-auart: add sysrq support
      serial: mxs-auart: clean get_mctrl and set_mctrl
      serial: mxs-auart: use mctrl_gpio helpers for handling modem signals
      serial: mxs-auart: add interrupts for modem control lines
      serial: mxs-auart: enable PPS support
      serial: mxs-auart: fix gpio change detection on interrupt
      serial: mxs-auart: fix tx_empty against shift register

Jingchang Lu (3):
      serial: of-serial: fix up PM ops on no_console_suspend and port type
      serial: fsl-lpuart: add lpuart32 power management support
      serial: of-serial: add PM suspend/resume support

Jiri Slaby (2):
      tty: warn on deprecated serial flags
      tty: bfin, define inlined structures

Joe Perches (2):
      tty: ipwireless: Fix probable mask then right shift defects
      tty: pr_warning->pr_warn and logging neatening

Johan Hovold (1):
      serial: tegra: clean up tty-flag assignments

John Crispin (3):
      serial: of: add a PORT_RT2880 definition
      serial: ralink: adds Mediatek MT7620 serial
      serial: of_serial: add "ralink,rt2880-uart" to the binding documentation

Julia Lawall (1):
      serial: icom: fix error return code

Julien CHAUVEAU (1):
      serial: 8250_dw: get index of serial line from DT aliases

Kevin Cernekee (9):
      tty: serial: bcm63xx: Allow bcm63xx_uart to be built on other platforms
      tty: serial: bcm63xx: Add support for unnamed clock outputs from DT
      tty: serial: bcm63xx: Update the Kconfig help text
      tty: serial: bcm63xx: Fix typo in MODULE_DESCRIPTION
      Documentation: DT: Add entries for bcm63xx UART
      tty: serial: bcm63xx: Enable DT earlycon support
      tty: serial: bcm63xx: Eliminate unnecessary request/release functions
      MAINTAINERS: Add entry for rp2 (Rocketport Express/Infinity) driver
      serial: core: Add big-endian iotype

Konrad Zapalowicz (9):
      drivers: serial: jsm: Add Classic board UART structure
      drivers: serial: jsm: Add the Classic board implementation
      drivers: serial: jsm: Enable support for Digi Classic adapters
      drivers: serial: jsm: Remove FSF address from the file documentation/header
      serial: jsm: Remove unnecessary parameter from clear_break()
      serial: jsm: Remove unnecessary if statement
      serial: jsm: Fix the alignment of the switch satement
      serial: jsm: Replace magic value with the proper define
      serial: jsm: Fix unnecessary space before function ptr arguments

Kumar Gala (1):
      tty/serial: earlycon: Fix print for implied MMIO case

Lars-Peter Clausen (1):
      tty: xuartps: Add support for setting modem control signals

Lucas Stach (1):
      serial: of-serial: fetch line number from DT

Markus Elfring (2):
      tty: Deletion of unnecessary checks before two function calls
      tty-hvsi_lib: Deletion of an unnecessary check before the function call "tty_kref_put"

Markus Pargmann (1):
      tty: serial: omap: Remove probe error message

Masanari Iida (1):
      tty: hvcs: Remove unnecessary KERN_ERR in hvcs.c

Maxime Ripard (1):
      serial: at91: Use dmaengine_slave_config API

Mike Skoog (1):
      8250_pci: Added driver for Endrun Technologies PTP PCIe card.

Nishanth Menon (1):
      tty: serial: omap: Increase max consoles and add check to prevent crash

Nobuhiro Iwamatsu (1):
      serial: sh-sci: Change checking for error rate of HSCIF

Paul Bolle (1):
      serial: samsung: Remove checks for CONFIG_SAMSUNG_CLOCK

Peng Fan (1):
      tty:vt remove obsolete struct initializer

Peter Hung (1):
      serial: Fix io address assign flow with Fintek PCI-to-UART Product

Peter Hurley (78):
      serial: Fix upstat_t sparse warnings
      serial: Fix sparse warnings in uart_throttle()/uart_unthrottle()
      tty: Remove sparse lock annotations from tty_write_lock()/_unlock()
      tty: Remove tty_pair_get_tty()/tty_pair_get_pty() api
      tty: Reorder proc_set_tty() and related fns
      tty: Remove tsk parameter from proc_set_tty()
      uml: Fix unsafe pid reference to foreground process group
      tty: Replace open-coded tty_get_pgrp()
      tty: Remove !tty condition from __proc_set_tty()
      tty: Fix multiple races when setting the controlling terminal
      tty: Move session_of_pgrp() and make static
      tty: Serialize proc_set_tty() with tty_lock
      tty: Update code comment in __proc_set_tty()
      tty: WARN for attempted set_termios() of pty master
      tty: Move pty-specific set_termios() handling to pty driver
      pty: Use spin_lock_irq() for pty_set_termios()
      tty: Use spin_lock_irq() for ctrl_lock when interrupts enabled
      pty: Don't claim slave's ctrl_lock for master's packet mode
      pty: Fix packet mode setting race
      pty: Hold ctrl_lock for packet mode updates
      tty: Fix missed wakeup from packet mode status update
      n_tty: Only process packet mode data in raw mode
      n_tty: Remove stale read lock comment
      tty: Don't hold tty_lock for ldisc release
      tty: Invert tty_lock/ldisc_sem lock order
      tty: Remove TTY_HUPPING
      tty: Clarify re-open behavior of master ptys
      tty: Check tty->count instead of TTY_CLOSING in tty_reopen()
      pty: Always return -EIO if slave BSD pty opened first
      tty: Re-open /dev/tty without tty_mutex
      tty: Drop tty_mutex before tty reopen
      tty: Remove TTY_CLOSING
      tty: Don't take tty_mutex for tty count changes
      tty: Don't release tty locks for wait queue sanity check
      tty: Document check_tty_count() requires tty_lock held
      tty: Simplify pty pair teardown logic
      tty: Fold pty pair handling into tty_flush_works()
      tty: Simplify tty_ldisc_release() interface
      tty: Simplify tty_release_checks() interface
      tty: Simplify tty_release() state checks
      tty: Change tty lock order to master->slave
      tty: Preset lock subclass for nested tty locks
      tty: Remove tty_unhangup() declaration
      pty: Don't drop pty master tty lock to hangup slave
      pty, n_tty: Simplify input processing on final close
      tty: Prefix tty_ldisc_{lock,lock_nested,unlock} functions
      tty: Fix hung task on pty hangup
      tty: Fix timeout on pty set ldisc
      tty: Flush ldisc buffer atomically with tty flip buffers
      serial: Refactor uart_flush_buffer() from uart_close()
      serial: core: Flush ldisc after dropping port mutex in uart_close()
      serial: Fix locking for uart driver set_termios() method
      tty,serial: Unify UPF_* and ASYNC_* flag definitions
      tty: Document defunct ASYNC_* bits in uapi header
      serial: core: Unwrap >80 char line in uart_close()
      serial: core: Remove redundant timeout assignments
      serial: core: Colocate crucial structure linkage
      serial: core: Remove extra locking in uart_write()
      serial: core: Fix port count when uart_open() errors
      tty: Replace open-coded test with tty_hung_up_p()
      tty: Call methods in modern style
      tty: Remove defunct pcxe_open() declaration
      tty: Remove defunct serial_console_init() declaration
      serial: hp300: Remove obsolete comments
      cris: Remove obsolete ASYNC_SPLIT_TERMIOS behavior
      tty: Document defunct ASYNC_SPLIT_TERMIOS flag in uapi header
      vt: Remove vt_get_kmsg_redirect() from uapi header
      serial: 8250_em: Remove out-of-memory message
      serial: pl011: Fix build breakage with !CONFIG_DMA_ENGINE
      tty: Move tty hung up check from port->lock critical section
      tty: Convert tty->closing to int
      tty: Flush tty buffers after hardware shutdown
      tty: Allow safe access to termios for set_ldisc() handlers
      serial: core: Claim port mutex for set_ldisc()
      serial: core: Pass termios to set_ldisc() notifications
      serial: Take uart port lock for direct *_enable_ms()
      serial: Test/disable MSIs if switching from N_PPS
      vt: Fix build breakage when !CONFIG_VT_CONSOLE

Qipan Li (1):
      serial: sirf: add a new uart type support

Rabin Vincent (1):
      serial: 8250: don't attempt a trylock if in sysrq

Ray Jui (1):
      serial: 8250_dw: Add DMA support for non-ACPI platforms

Ricardo Ribalda Delgado (13):
      serial/max310x: Remove obsolete #ifset TIOC[SG]RS485
      serial/sc16is7xx: Remove obsolete #ifset TIOC[SG]RS485
      serial_core: Handle TIOC[GS]RS485 ioctls.
      serial/8250: Copy RS485 fields to serial_core
      8250/fintek: Use rs485 handler from serial_core
      serial/8250: Remove obsolete handling of rs485 ioctls
      serial/sc16is7xx: Use the rs485 functions on serial_core
      serial/mcf: Use the rs485 functions on serial_core
      serial/atmel: Use the rs485 functions on serial_core
      serial/omap: Use the rs485 functions on serial_core
      drivers/max310: Use the rs485 functions on serial_core
      serial_core: Remove call to driver-specific TIO[GS]RS485]
      tty/serial_core: Introduce lock mechanism for RS485

Robert Baldyga (4):
      serial: samsung: wait for transfer completion before clock disable
      serial: samsung: fix style problems
      serial: samsung: prefer to use fifosize from driver data
      serial: samsung: use port->fifosize instead of hardcoded values

Sebastian Andrzej Siewior (12):
      tty: serial: 8250: Fix wording in runtime-PM comments
      tty: serial: 8250: make serial8250_console_setup() non _init
      tty: serial: Add 8250-core based omap driver
      tty: serial: 8250_dma: handle error on TX submit
      tty: serial: 8250_dma: keep own book keeping about RX transfers
      tty: serial: 8250: allow to use custom DMA implementation
      tty: serial: 8250_omap: add custom DMA-TX callback
      tty: serial: 8250_omap: add custom DMA-RX callback
      tty: serial: 8250: omap: add custom irq handling
      tty: serial: 8250: omap: add dma support
      tty: serial: 8250: omap: line is unsigned, don't check < 0
      tty: serial: omap_serial: line is unsigned, don't check < 0

Sergej Pupykin (1):
      parport: Add support for the WCH382 2S/1P multi-IO card

Stephen Boyd (5):
      tty: serial: msm: Fix sysrq spinlock recursion on non-DM
      tty: serial: msm: Support sysrq on uartDM devices
      tty: serial: msm: Reset uartdm after baud rate change
      tty: serial: msm_serial: Use DT aliases
      tty: serial: msm_serial: Don't require DT aliases

Sudhir Sreedharan (1):
      tty: serial: 8250_core: restore the LCR register in set_sleep

Sudip Mukherjee (2):
      serial: 8250: sparse warning of incorrect type
      serial: MIPS: lantiq: use devm_iounmap instead of iounmap

Ulrich Hecht (1):
      serial: sh-sci: Add device tree support for r8a7794

 .../devicetree/bindings/serial/bcm63xx-uart.txt    |   30 +
 .../devicetree/bindings/serial/fsl-mxs-auart.txt   |   10 +-
 .../devicetree/bindings/serial/of-serial.txt       |    1 +
 Documentation/devicetree/bindings/serial/pl011.txt |   19 +-
 .../devicetree/bindings/serial/qcom,msm-uartdm.txt |   69 +-
 .../bindings/serial/renesas,sci-serial.txt         |    9 +-
 .../devicetree/bindings/serial/sirf-uart.txt       |   16 +-
 Documentation/serial/driver                        |    6 +-
 MAINTAINERS                                        |    6 +
 arch/blackfin/include/asm/bfin_serial.h            |    7 +-
 arch/um/drivers/line.c                             |    6 +-
 drivers/parport/parport_serial.c                   |   10 +
 drivers/tty/ehv_bytechan.c                         |    4 +-
 drivers/tty/goldfish.c                             |    6 +-
 drivers/tty/hvc/hvcs.c                             |    2 +-
 drivers/tty/hvc/hvsi_lib.c                         |    3 +-
 drivers/tty/ipwireless/hardware.c                  |   12 +-
 drivers/tty/isicom.c                               |   14 +-
 drivers/tty/n_tty.c                                |   90 +-
 drivers/tty/pty.c                                  |   87 +-
 drivers/tty/serial/8250/8250.h                     |    9 +-
 drivers/tty/serial/8250/8250_core.c                |  112 +-
 drivers/tty/serial/8250/8250_dma.c                 |   39 +-
 drivers/tty/serial/8250/8250_dw.c                  |   69 +-
 drivers/tty/serial/8250/8250_em.c                  |    4 +-
 drivers/tty/serial/8250/8250_fintek.c              |    8 +-
 drivers/tty/serial/8250/8250_hp300.c               |    4 -
 drivers/tty/serial/8250/8250_mtk.c                 |    4 +-
 drivers/tty/serial/8250/8250_omap.c                | 1281 ++++++++++++++++++++
 drivers/tty/serial/8250/8250_pci.c                 |  198 ++-
 drivers/tty/serial/8250/Kconfig                    |   11 +-
 drivers/tty/serial/8250/Makefile                   |    1 +
 drivers/tty/serial/Kconfig                         |   24 +-
 drivers/tty/serial/amba-pl010.c                    |   60 +-
 drivers/tty/serial/amba-pl011.c                    |   48 +-
 drivers/tty/serial/ar933x_uart.c                   |   30 +-
 drivers/tty/serial/atmel_serial.c                  |  230 ++--
 drivers/tty/serial/bcm63xx_uart.c                  |   55 +-
 drivers/tty/serial/bfin_sport_uart.c               |    5 +-
 drivers/tty/serial/bfin_uart.c                     |    5 +-
 drivers/tty/serial/clps711x.c                      |    5 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   48 +-
 drivers/tty/serial/crisv10.c                       |   12 -
 drivers/tty/serial/crisv10.h                       |    1 -
 drivers/tty/serial/earlycon.c                      |    2 +-
 drivers/tty/serial/fsl_lpuart.c                    |   25 +-
 drivers/tty/serial/icom.c                          |    4 +-
 drivers/tty/serial/imx.c                           |  153 ++-
 drivers/tty/serial/ip22zilog.c                     |   18 +-
 drivers/tty/serial/jsm/Makefile                    |    2 +-
 drivers/tty/serial/jsm/jsm.h                       |  101 +-
 drivers/tty/serial/jsm/jsm_cls.c                   |  982 +++++++++++++++
 drivers/tty/serial/jsm/jsm_driver.c                |  156 ++-
 drivers/tty/serial/jsm/jsm_neo.c                   |   36 +-
 drivers/tty/serial/jsm/jsm_tty.c                   |   39 +-
 drivers/tty/serial/lantiq.c                        |    4 +-
 drivers/tty/serial/m32r_sio.c                      |   42 +-
 drivers/tty/serial/max310x.c                       |   77 +-
 drivers/tty/serial/mcf.c                           |   42 +-
 drivers/tty/serial/men_z135_uart.c                 |    1 +
 drivers/tty/serial/mfd.c                           |    2 +-
 drivers/tty/serial/mpsc.c                          |   39 +-
 drivers/tty/serial/mrst_max3110.c                  |   27 +-
 drivers/tty/serial/msm_serial.c                    |  111 +-
 drivers/tty/serial/msm_serial.h                    |    2 +
 drivers/tty/serial/mxs-auart.c                     |  250 +++-
 drivers/tty/serial/of_serial.c                     |   75 +-
 drivers/tty/serial/omap-serial.c                   |   93 +-
 drivers/tty/serial/pmac_zilog.c                    |    9 +-
 drivers/tty/serial/pnx8xxx_uart.c                  |   48 +-
 drivers/tty/serial/pxa.c                           |    3 +
 drivers/tty/serial/sa1100.c                        |   45 +-
 drivers/tty/serial/samsung.c                       |   90 +-
 drivers/tty/serial/sc16is7xx.c                     |   57 +-
 drivers/tty/serial/serial-tegra.c                  |   36 +-
 drivers/tty/serial/serial_core.c                   |  116 +-
 drivers/tty/serial/sh-sci.c                        |    5 +-
 drivers/tty/serial/sirfsoc_uart.c                  |   34 +-
 drivers/tty/serial/sirfsoc_uart.h                  |    4 +
 drivers/tty/serial/sunsab.c                        |   36 +-
 drivers/tty/serial/sunsu.c                         |   39 +-
 drivers/tty/serial/sunzilog.c                      |   24 +-
 drivers/tty/serial/timbuart.c                      |    2 +
 drivers/tty/serial/xilinx_uartps.c                 |   22 +-
 drivers/tty/tty_buffer.c                           |   10 +-
 drivers/tty/tty_io.c                               |  440 +++----
 drivers/tty/tty_ioctl.c                            |   38 +-
 drivers/tty/tty_ldisc.c                            |  111 +-
 drivers/tty/tty_mutex.c                            |   49 +-
 drivers/tty/tty_port.c                             |   10 +-
 drivers/tty/vt/keyboard.c                          |    6 +-
 drivers/tty/vt/vt.c                                |   22 +-
 include/linux/kernel.h                             |    3 -
 include/linux/serial_8250.h                        |    3 -
 include/linux/serial_bcm63xx.h                     |    2 -
 include/linux/serial_core.h                        |   67 +-
 include/linux/tty.h                                |   28 +-
 include/uapi/linux/serial_core.h                   |    3 +-
 include/uapi/linux/serial_reg.h                    |    1 +
 include/uapi/linux/tty_flags.h                     |   19 +-
 include/uapi/linux/vt.h                            |    3 -
 kernel/exit.c                                      |   21 -
 102 files changed, 4756 insertions(+), 1603 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/bcm63xx-uart.txt
 create mode 100644 drivers/tty/serial/8250/8250_omap.c
 create mode 100644 drivers/tty/serial/jsm/jsm_cls.c
