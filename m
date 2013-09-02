Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab3IBX5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:57:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3IBX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:57:04 -0400
Date: Mon, 2 Sep 2013 16:59:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.12-rc1
Message-ID: <20130902235939.GE4544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.12-rc1

for you to fetch changes up to 2d1d3f3ae985ec5676fb56ff2c7acad2e1c4e6eb:

  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc (2013-08-30 14:11:28 -0700)

----------------------------------------------------------------
TTY/Serial driver patches for 3.12-rc1

Here's the big tty/serial driver pull request for 3.12-rc1.

Lots of n_tty reworks to resolve some very long-standing issues, removing the
3-4 different locks that were taken for every character.  This code has been
beaten on for a long time in linux-next with no reported regressions.

Other than that, a range of serial and tty driver updates and revisions.  Full
details in the shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aldo Iljazi (1):
      Drivers: tty: n_gsm.c: fixed 7 errors & 6 warnings that checkpatch complained

Alexander Shiyan (8):
      serial: max310x: Driver rework
      serial: max310x: Add MAX3109 support
      serial: max310x: Add MAX14830 support
      serial: max310x: Fix dev_pm_ops
      serial: sccnxp: Disable regulator on error
      serial: sccnxp: Using CLK API for getting UART clock
      serial: sccnxp: Using structure for each supported IC instead of switch in probe
      serial: sccnxp: Add DT support

Alexandru Juncu (1):
      TTY: synclink: replace bitmasks add operation with OR operation.

Andreas Bießmann (1):
      register_console: prevent adding the same console twice

Andreas Platschek (1):
      tty: Remove dead code

Axel Lin (2):
      serial: fsl_lpuart: Return proper error on lpuart_serial_init error path
      serial: bfin_uart: Remove redundant testing for ifdef CONFIG_SERIAL_BFIN_MODULE

Barry Song (2):
      serial: sirf: add support for Marco chip
      serial: sirf: drop redundant pinctrl_get_select_default as pinctrl core does it

Christophe Leroy (1):
      tty: serial: cpm_uart: Adding proper request of GPIO used by cpm_uart driver

Clemens Ladisch (1):
      vt: make the default color configurable

Dan Carpenter (1):
      serial: icom: move array overflow checks earlier

Daniel Mack (1):
      tty: serial: pxa: remove old cruft

Darren Hart (3):
      pch_uart: Use DMI interface for board detection
      serial: pch_uart: Remove __initdata annotation from dmi_table
      serial: pch_uart: Fix signed-ness and casting of uartclk related fields

Dmitry Fink (1):
      OMAP: UART: Keep the TX fifo full when possible

Elen Song (8):
      serial: at91: correct definition from DMA to PDC
      serial: at91: use function pointer to choose pdc or pio
      serial: at91: add tx dma support
      serial: at91: add rx dma support
      serial: at91: support run time switch transfer mode
      serial: at91: distinguish usart and uart
      serial: at91: make UART support dma and pdc transfers
      serial: at91: add dma support in usart binding descriptions

Fabio Estevam (1):
      serial: amba-pl011: Use __releases/__acquires annotations

Gabor Juhos (6):
      tty: ar933x_uart: convert to use devm_* functions
      tty: ar933x_uart: use the clk API to get the uart clock
      tty: ar933x_uart: remove superfluous assignment of ar933x_uart_driver.nr
      tty: ar933x_uart: use config_enabled() macro to clean up ifdefs
      tty: ar933x_uart: allow to build the driver as a module
      tty: ar933x_uart: add device tree support and binding documentation

Govindraj.R (1):
      OMAP2+: UART: enable tx wakeup bit for wer reg

Greg Kroah-Hartman (5):
      Merge 3.11-rc3 into tty-next
      Revert "serial: sccnxp: Add DT support"
      Merge 3.11-rc4 into tty-next
      Revert "serial: omap: Fix IRQ handling return value"
      Revert "OMAP: UART: Keep the TX fifo full when possible"

Grygorii Strashko (1):
      serial: omap: enable PM runtime only when its fully configured

Hendrik Brueckner (2):
      tty/hvc_console: Add DTR/RTS callback to handle HUPCL control
      tty/hvc_iucv: Disconnect IUCV connection when lowering DTR

Huang Shijie (7):
      serial: imx: remove the uart_console() check
      serial: imx: distinguish the imx6q uart from the others
      serial: imx: add DMA support for imx6q
      serial: mxs: enable the DMA only when the RTS/CTS is valid
      serial: mxs: remove the MXS_AUART_DMA_CONFIG
      ARM: dts: imx28-evk: add the RTS/CTS property for auart0
      serial: imx: initialize the local variable

Hubert Feurstein (1):
      serial/imx: fix custom-baudrate handling

Ian Abbott (4):
      pci_ids.h: move PCI_VENDOR_ID_AMCC here
      serial: 8250_pci: replace PCI_VENDOR_ID_ADDIDATA_OLD
      serial: 8250_pci: use local device ID for ADDI-DATA APCI-7800
      pci_ids.h: remove PCI_VENDOR_ID_ADDIDATA_OLD and PCI_DEVICE_ID_ADDIDATA_APCI7800

Jingoo Han (15):
      serial: remove unnecessary platform_set_drvdata()
      serial: use dev_get_platdata()
      serial: sh-sci: use dev_get_platdata()
      serial: pxa: Staticize local symbols
      serial: sirf: Staticize local symbols
      serial: samsung: fix casting warning
      serial: 8250_early: fix comparison of different types
      serial: mrst_max3110: fix casting warning
      serial: timbuart: Staticize local symbols
      serial: icom: fix casting warning
      serial: ioc4_serial: Staticize ioc4_serial_attach_one()
      serial: msm_serial: fix comparison of different types
      serial: tegra: use NULL instead of 0
      serial: st-asc: remove unnecessary platform_set_drvdata()
      TTY: amiserial, remove unnecessary platform_set_drvdata()

Joe Perches (1):
      hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc

John Crispin (1):
      serial: MIPS: lantiq: fix clock error check

Julia Lawall (2):
      tty: ar933x_uart: simplify use of devm_ioremap_resource
      serial: st-asc: replace devm_request_and_ioremap by devm_ioremap_resource

Kees Cook (1):
      serial: report base_baud after initialization

Kumar Gala (2):
      serial: fsl-imx-uart: Cleanup duplicate device tree binding
      serial: unify serial bindings into a single dir

Laurent Pinchart (1):
      serial8250-em: Convert to devm_* managed helpers

Luis Henriques (1):
      serial: pch_uart: fix compilation warning

Mark Jackson (2):
      OMAP: add RS485 support
      OMAP: serial: Remove incorrect disabling of IER interrupt

Peter Hurley (79):
      tty: Fix tty_ldisc_lock name collision
      tty: Add lock/unlock ldisc pair functions
      tty: Replace ldisc locking with ldisc_sem
      tty: Clarify ldisc variable
      tty: Fix hangup race with TIOCSETD ioctl
      tty: Clarify multiple-references comment in TIOCSETD ioctl
      tty: Don't change receive_room for ioctl(TIOCSETD)
      tty: Simplify tty buffer/ldisc interface with helper function
      tty: Make ldisc input flow control concurrency-friendly
      n_tty: Factor canonical mode copy from n_tty_read()
      n_tty: Line copy to user buffer in canonical mode
      n_tty: Split n_tty_chars_in_buffer() for reader-only interface
      tty: Deprecate ldisc .chars_in_buffer() method
      n_tty: Get read_cnt through accessor
      n_tty: Don't wrap input buffer indices at buffer size
      n_tty: Remove read_cnt
      tty: Convert termios_mutex to termios_rwsem
      n_tty: Access termios values safely
      n_tty: Replace canon_data with index comparison
      n_tty: Make N_TTY ldisc receive path lockless
      n_tty: Reset lnext if canonical mode changes
      n_tty: Fix type mismatches in receive_buf raw copy
      n_tty: Don't wait for buffer work in read() loop
      n_tty: Separate buffer indices to prevent cache-line sharing
      tty: Only guarantee termios read safety for throttle/unthrottle
      n_tty: Move chars_in_buffer() to factor throttle/unthrottle
      n_tty: Factor throttle/unthrottle into helper functions
      n_tty: Move n_tty_write_wakeup() to avoid forward declaration
      n_tty: Special case pty flow control
      n_tty: Queue buffer work on any available cpu
      tty: Compute flip buffer ptrs
      tty: Fix flip buffer free list
      tty: Factor flip buffer initialization into helper function
      tty: Merge tty_buffer_find() into tty_buffer_alloc()
      tty: Use generic names for flip buffer list cursors
      tty: Use lockless flip buffer free list
      tty: Simplify flip buffer list with 0-sized sentinel
      tty: Track flip buffer memory limit atomically
      tty: Make driver-side flip buffers lockless
      tty: Ensure single-threaded flip buffer consumer with mutex
      tty: Only perform flip buffer flush from tty_buffer_flush()
      tty: Avoid false-sharing flip buffer ptrs
      tty: Use non-atomic state to signal flip buffer flush pending
      tty: Merge __tty_flush_buffer() into lone call site
      tty: Fix unsafe vt paste_selection()
      tty: Remove private constant from global namespace
      n_tty: Remove unused echo_overrun field
      n_tty: Use separate head and tail indices for echo_buf
      n_tty: Replace echo_cnt with computed value
      n_tty: Remove echo_lock
      n_tty: Eliminate echo_commit memory barrier
      n_tty: Process echoes in blocks
      n_tty: Only flush echo output if actually output
      n_tty: Eliminate counter in __process_echoes
      n_tty: Avoid false-sharing echo buffer indices
      n_tty: Fix EOF push handling
      n_tty: Remove alias ptrs in __receive_buf()
      n_tty: Move buffers into n_tty_data
      n_tty: Rename process_char_map to char_map
      n_tty: Simplify __receive_buf loop count
      n_tty: Factor 'real raw' receive_buf into standalone fn
      n_tty: Factor signal char handling into separate fn
      n_tty: Factor flagged char handling into separate fn
      n_tty: Factor raw mode receive_buf() into separate fn
      n_tty: Special case EXTPROC receive_buf() as raw mode
      n_tty: Factor tty->closing receive_buf() into separate fn
      n_tty: Fix build breakage on ppc64
      n_tty: Factor standard per-char i/o into separate fn
      n_tty: Eliminate char tests from IXANY restart test
      n_tty: Split n_tty_receive_char()
      n_tty: Factor ISTRIP and IUCLC receive_buf into separate fn
      n_tty: Factor PARMRK from normal per-char i/o
      n_tty: Remove overflow tests from receive_buf() path
      n_tty: Un-inline single-use functions
      n_tty: Factor LNEXT processing from per-char i/o path
      tty: Remove extra wakeup from pty write() path
      tty: Fix lock order in tty_do_resize()
      tty: Only hangup once
      n_tty: Fix termios_rwsem lockdep false positive

Qipan Li (8):
      serial: sirf: make the driver also support USP-based UART
      serial: sirf: fix the hardware-flow-ctrl for USP-based UART
      serial: sirf: add DT-binding document to describle detailed properties
      serial: sirf: fix the typo for rts/cts gpio
      serial: sirf: fix the namespace of startup_uart entry
      serial: sirf: add DMA support using dmaengine APIs
      serial: sirf: define macro for some magic numbers of USP
      serial: sirf: fix the amount of serial ports

Ruchika Kharwar (2):
      OMAP: UART: Fix the revision register read.
      serial: omap: Fix IRQ handling return value

Sachin Kamat (2):
      serial: bfin_sport_uart: Fix incorrect placement of __initdata
      serial: bfin_uart: Fix incorrect placement of __initdata

Sascha Hauer (2):
      OF: Add helper for matching against linux,stdout-path
      serial: i.MX: evaluate linux,stdout-path property

Shawn Guo (1):
      serial: fsl_lpuart: restore UARTCR2 after watermark setup is done

Srinivas Kandagatla (2):
      serial:st-asc: Add ST ASC driver.
      serial: st-asc: Fix unused variable warning for non DT.

Stefan Seyfried (1):
      8250_pci: improve code comments and Kconfig help

Stephen Boyd (9):
      msm_serial: Fix NUL byte output on UARTDM
      msm_serial: Fix sparse warnings
      msm_serial: Make baud_code detection more dynamic
      msm_serial: Send more than 1 character at a time on UARTDM
      msm_serial: Switch clock consumer strings and simplify code
      msm_serial: Add support for non-GSBI UARTDM devices
      msm_serial: Send more than 1 character on the console w/ UARTDM
      devicetree: serial: Document msm_serial bindings
      ARM: dts: msm: Update uartdm compatible strings

Thomas Langer (1):
      serial: MIPS: lantiq: add clk_enable() call to driver

Tim Kryger (1):
      serial: 8250_dw: Report CTS asserted for auto flow

Uwe Kleine-König (4):
      serial/efm32-uart: use COMPILE_TEST symbol to extend compile test coverage
      serial/efm32-uart: make of_device_id array const
      serial/efm32-uart: don't use pdev->id to determine the port's line
      serial/efm32-uart: don't slur over failure in probe_dt

Vikram Pandita (1):
      serial: omap: Initialize platform_data

Vineet Gupta (2):
      serial/arc-uart: Handle Rx Error Interrupts w/o any data
      serial/arc-uart: Remove the goto/label

Viresh Kumar (25):
      tty: serial: altera_jtag: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: altera: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: apbuart: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: ar933x: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: arc: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: bcm63xx: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: bfin_sport: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: efm32: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: icom: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: lpc32xx_hs: don't call tty_flip_buffer_push() twice
      tty: serial: lpc32xx_hs: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: m32r_sio: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: mcf: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: mfd: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: mpsc: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: msm: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: netx: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: nwpserial: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: pnx8xxx: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: rp2: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: sa1100: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: samsung: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: tegra: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: sirfsoc: drop uart_port->lock before calling tty_flip_buffer_push()
      tty: serial: vt8500: drop uart_port->lock before calling tty_flip_buffer_push()

Wei Yongjun (1):
      msm_serial: add missing iounmap() on error in msm_request_port()

Wolfram Sang (1):
      drivers/tty/serial: don't use devm_pinctrl_get_select_default() in probe

 .../bindings/{tty => }/serial/arc-uart.txt         |    0
 .../bindings/{tty => }/serial/atmel-usart.txt      |   18 +-
 .../bindings/{tty => }/serial/efm32-uart.txt       |    0
 .../devicetree/bindings/serial/fsl-imx-uart.txt    |   22 +-
 .../bindings/{tty => }/serial/fsl-lpuart.txt       |    0
 .../bindings/{tty => }/serial/fsl-mxs-auart.txt    |    4 +
 .../{tty => }/serial/nxp-lpc32xx-hsuart.txt        |    0
 .../bindings/{tty => }/serial/of-serial.txt        |    0
 .../devicetree/bindings/serial/qcom,msm-uart.txt   |   25 +
 .../devicetree/bindings/serial/qcom,msm-uartdm.txt |   53 +
 .../devicetree/bindings/serial/sirf-uart.txt       |   33 +
 .../bindings/{tty => }/serial/snps-dw-apb-uart.txt |    0
 .../devicetree/bindings/serial/st-asc.txt          |   18 +
 .../bindings/{tty => }/serial/via,vt8500-uart.txt  |    0
 .../bindings/tty/serial/fsl-imx-uart.txt           |   22 -
 .../devicetree/bindings/tty/serial/msm_serial.txt  |   27 -
 .../bindings/tty/serial/qca,ar9330-uart.txt        |   34 +
 Documentation/kernel-parameters.txt                |   10 +
 arch/arm/boot/dts/imx28-evk.dts                    |    1 +
 arch/arm/boot/dts/msm8660-surf.dts                 |    2 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c                |    6 +-
 arch/arm/mach-msm/devices-msm7x30.c                |    2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |    6 +-
 arch/mips/sni/a20r.c                               |    1 -
 drivers/net/irda/irtty-sir.c                       |    8 +-
 drivers/of/base.c                                  |   26 +
 drivers/staging/comedi/comedidev.h                 |    1 -
 drivers/staging/dgrp/dgrp_tty.c                    |    2 +
 drivers/tty/amiserial.c                            |    2 -
 drivers/tty/hvc/hvc_console.c                      |   11 +-
 drivers/tty/hvc/hvc_console.h                      |    3 +
 drivers/tty/hvc/hvc_iucv.c                         |   64 +-
 drivers/tty/hvc/hvc_xen.c                          |    6 +-
 drivers/tty/n_gsm.c                                |   29 +-
 drivers/tty/n_tty.c                                | 1414 ++++++++++++--------
 drivers/tty/pty.c                                  |   18 +-
 drivers/tty/serial/8250/8250_core.c                |    2 +-
 drivers/tty/serial/8250/8250_dw.c                  |   34 +-
 drivers/tty/serial/8250/8250_early.c               |    2 +-
 drivers/tty/serial/8250/8250_em.c                  |   27 +-
 drivers/tty/serial/8250/8250_pci.c                 |   15 +-
 drivers/tty/serial/8250/Kconfig                    |    2 +
 drivers/tty/serial/Kconfig                         |   33 +-
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/altera_jtaguart.c               |    5 +-
 drivers/tty/serial/altera_uart.c                   |    4 +-
 drivers/tty/serial/amba-pl010.c                    |    2 +-
 drivers/tty/serial/amba-pl011.c                    |   18 +-
 drivers/tty/serial/apbuart.c                       |    2 +
 drivers/tty/serial/ar933x_uart.c                   |  111 +-
 drivers/tty/serial/arc_uart.c                      |   35 +-
 drivers/tty/serial/atmel_serial.c                  |  857 ++++++++++--
 drivers/tty/serial/bcm63xx_uart.c                  |    3 +-
 drivers/tty/serial/bfin_sport_uart.c               |   14 +-
 drivers/tty/serial/bfin_uart.c                     |   21 +-
 drivers/tty/serial/clps711x.c                      |   11 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   28 +-
 drivers/tty/serial/efm32-uart.c                    |   29 +-
 drivers/tty/serial/fsl_lpuart.c                    |    7 +-
 drivers/tty/serial/icom.c                          |  103 +-
 drivers/tty/serial/ifx6x60.c                       |    2 +-
 drivers/tty/serial/imx.c                           |  520 ++++++-
 drivers/tty/serial/ioc4_serial.c                   |    4 +-
 drivers/tty/serial/lantiq.c                        |    7 +-
 drivers/tty/serial/lpc32xx_hs.c                    |    7 +-
 drivers/tty/serial/m32r_sio.c                      |    3 +
 drivers/tty/serial/max3100.c                       |    2 +-
 drivers/tty/serial/max310x.c                       |  991 +++++++-------
 drivers/tty/serial/mcf.c                           |    5 +-
 drivers/tty/serial/mfd.c                           |   14 +-
 drivers/tty/serial/mpsc.c                          |   15 +-
 drivers/tty/serial/mrst_max3110.c                  |    4 +-
 drivers/tty/serial/msm_serial.c                    |  276 ++--
 drivers/tty/serial/msm_serial.h                    |   19 +-
 drivers/tty/serial/msm_serial_hs.c                 |    2 +-
 drivers/tty/serial/mxs-auart.c                     |   16 +-
 drivers/tty/serial/netx-serial.c                   |    8 +-
 drivers/tty/serial/nwpserial.c                     |    3 +
 drivers/tty/serial/omap-serial.c                   |  214 ++-
 drivers/tty/serial/pch_uart.c                      |   84 +-
 drivers/tty/serial/pmac_zilog.c                    |    1 -
 drivers/tty/serial/pnx8xxx_uart.c                  |    5 +-
 drivers/tty/serial/pxa.c                           |   33 +-
 drivers/tty/serial/rp2.c                           |    2 +
 drivers/tty/serial/sa1100.c                        |    5 +-
 drivers/tty/serial/samsung.c                       |    9 +-
 drivers/tty/serial/samsung.h                       |    3 +-
 drivers/tty/serial/sc26xx.c                        |    2 +-
 drivers/tty/serial/sccnxp.c                        |  339 +++--
 drivers/tty/serial/serial-tegra.c                  |   16 +-
 drivers/tty/serial/serial_core.c                   |    4 +-
 drivers/tty/serial/serial_txx9.c                   |    2 +-
 drivers/tty/serial/sh-sci.c                        |    4 +-
 drivers/tty/serial/sirfsoc_uart.c                  | 1195 ++++++++++++++---
 drivers/tty/serial/sirfsoc_uart.h                  |  501 +++++--
 drivers/tty/serial/st-asc.c                        |  932 +++++++++++++
 drivers/tty/serial/timbuart.c                      |    4 +-
 drivers/tty/serial/vr41xx_siu.c                    |    2 +-
 drivers/tty/serial/vt8500_serial.c                 |    3 +-
 drivers/tty/synclink.c                             |  130 +-
 drivers/tty/tty_buffer.c                           |  417 +++---
 drivers/tty/tty_io.c                               |   33 +-
 drivers/tty/tty_ioctl.c                            |   90 +-
 drivers/tty/tty_ldisc.c                            |  461 +++----
 drivers/tty/vt/keyboard.c                          |   21 +-
 drivers/tty/vt/selection.c                         |    8 +-
 drivers/tty/vt/vt.c                                |    8 +-
 include/linux/atmel_serial.h                       |    2 +
 include/linux/kbd_kern.h                           |    3 +-
 include/linux/llist.h                              |   23 +
 include/linux/of.h                                 |    7 +
 include/linux/pci_ids.h                            |    4 +-
 include/linux/platform_data/max310x.h              |    9 +-
 include/linux/platform_data/serial-sccnxp.h        |    3 -
 include/linux/tty.h                                |   66 +-
 include/linux/tty_flip.h                           |    8 +-
 include/linux/tty_ldisc.h                          |   16 +-
 include/uapi/linux/serial_core.h                   |    3 +
 kernel/printk/printk.c                             |    7 +
 120 files changed, 6773 insertions(+), 3040 deletions(-)
 rename Documentation/devicetree/bindings/{tty => }/serial/arc-uart.txt (100%)
 rename Documentation/devicetree/bindings/{tty => }/serial/atmel-usart.txt (58%)
 rename Documentation/devicetree/bindings/{tty => }/serial/efm32-uart.txt (100%)
 rename Documentation/devicetree/bindings/{tty => }/serial/fsl-lpuart.txt (100%)
 rename Documentation/devicetree/bindings/{tty => }/serial/fsl-mxs-auart.txt (86%)
 rename Documentation/devicetree/bindings/{tty => }/serial/nxp-lpc32xx-hsuart.txt (100%)
 rename Documentation/devicetree/bindings/{tty => }/serial/of-serial.txt (100%)
 create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sirf-uart.txt
 rename Documentation/devicetree/bindings/{tty => }/serial/snps-dw-apb-uart.txt (100%)
 create mode 100644 Documentation/devicetree/bindings/serial/st-asc.txt
 rename Documentation/devicetree/bindings/{tty => }/serial/via,vt8500-uart.txt (100%)
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/qca,ar9330-uart.txt
 create mode 100644 drivers/tty/serial/st-asc.c
