Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3BUSkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:40:25 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:64677 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3BUSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:40:20 -0500
Date: Thu, 21 Feb 2013 10:40:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.9-rc1
Message-ID: <20130221184050.GA24756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.9-rc1

for you to fetch changes up to 9e17df37d710f8998e9cb10a548304fe33d4a5c2:

  tty: mxser: improve error handling in mxser_probe() and mxser_module_init() (2013-02-18 11:05:14 -0800)

----------------------------------------------------------------
tty/serial patches for 3.9-rc1

Here's the big tty/serial driver patches for 3.9-rc1.

More tty port rework and fixes from Jiri here, as well as lots of
individual serial driver updates and fixes.

All of these have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (2):
      serial: quatech: add the other serial identifiers and preliminary control code
      goldfish: move to tty_port for flip buffers

Alexander Shiyan (5):
      serial: sccnxp: Implement polling mode
      serial: sccnxp: Rename header file to match functionality
      serial: sccnxp: Fix possible crash if no platform data supplied
      serial: sccnxp: Reset break and overrun bits in RX handler
      serial: sccnxp: Make baudrate table struct static

Alexey Khoroshilov (1):
      tty: mxser: improve error handling in mxser_probe() and mxser_module_init()

Alexey Pelykh (2):
      OMAP/serial: Support 1Mbaud and similar baudrates that require Mode16 instead of Mode13
      OMAP/serial: Fix incorrect Rx FIFO threshold setting, LSR validation on Tx, and Tx FIFO IRQ generation

Arnd Bergmann (3):
      ARM: sa1100/assabet: include platform_device.h directly
      fb/exynos: include platform_device.h
      ARM defconfigs: add missing inclusions of linux/platform_device.h

Arve Hjønnevåg (1):
      goldfish: tty driver

Barry Song (2):
      serial: sirf: add support for new SiRFmarco SMP SoC
      serial: sirf: only use lookup table to set baudrate when ioclk=150MHz

Chen Gang (3):
      serial: avoid double free after call ioc4_serial_remove_one
      drivers/tty/serial: extern function which for release resource, need check pointer, before free it
      drivers/tty/serial/8250: use strlcpy instead of strcpy

Cong Ding (6):
      tty: vt/Makefile: set the variables to static
      tty: cleanup the panic message
      tty: cleanup checkpatch warning in pty.c
      tty: add parenthesis to macro POLL_PERIOD in rocket.c
      tty: serial/68328serial.c: remove unnecessary null pointer check
      tty: serial/crisv10.c: remove unnecessary null pointer check

Dirkjan Bussink (1):
      tty: Prevent deadlock in n_gsm driver

Enric Balletbo i Serra (1):
      serial: omap: add the functionality of a 9-bit UART with userspaces CMSPAR

Fabio Estevam (2):
      serial: imx: Remove unused 'tty' variable
      serial: imx: Move imx_port_ucrs_save/restore under CONFIG_CONSOLE_POLL

George Spelvin (6):
      pps: Add pps_lookup_dev() function
      pps: Use pps_lookup_dev to reduce ldisc coupling
      pps: Fix a use-after free bug when unregistering a source.
      pps: Don't crash the machine when exiting will do
      pps: Move timestamp read into PPS code proper
      pps: Additional cleanups in uart_handle_dcd_change

Greg Kroah-Hartman (6):
      serial: 8250_pci: remove __devexit usage
      Revert "n_gsm.c: add tx_lock in gsm_send"
      Staging: sb105x: mark it BROKEN
      Merge 3.8-rc5 into tty-next
      Revert "n_tty: Unthrottle tty when flushing read buffer"
      kgdb: remove #include <linux/serial_8250.h> from kgdb.h

Haojun Bao (1):
      serial: pxa: Do not tweak clock in pxa serial write() function

Heikki Krogerus (12):
      serial: 8250: Allow drivers to deliver capabilities
      serial: 8250_dw: Don't use UPF_FIXED_TYPE
      serial: 8250_dw: Map IO memory
      serial: 8250_dw: Move device tree code to separate function
      serial: 8250_dw: Set FIFO size dynamically
      serial: 8250_dw: Add ACPI 5.0 support
      serial: 8250: Add support for dmaengine
      serial: 8250_dw: Enable DMA support with ACPI
      serial: 8250_dma: Switch to using tty_port
      serial: 8250_dma: TX optimisation
      serial: 8250_dw: Use ifdef with ACPI
      serial: 8250_dw: Set maxburst size

Heiko Carstens (1):
      drivers/serial: add GENERIC_HARDIRQS dependency

Ilya Zykov (2):
      tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
      tty: Correct tty buffer flush.

Ivo Sieben (2):
      tty: Only wakeup the line discipline idle queue when queue is active
      tty: Use raw spin lock to protect the TTY read section

James Hogan (2):
      tty: metag_da: Add metag DA TTY driver
      tty: metag_da: avoid getting tty kref in dashtty_timer()

Jiri Slaby (14):
      TTY: switch tty_buffer_request_room to tty_port
      TTY: convert more flipping functions
      TTY: switch tty_insert_flip_char
      TTY: switch tty_insert_flip_string
      TTY: move low_latency to tty_port
      TTY: switch tty_flip_buffer_push
      TTY: switch tty_schedule_flip
      cyclades: push down tty_port_tty_get
      TTY: synclink, remove unneeded tests
      TTY: nozomi, remove dead code
      TTY: do not reset master's packet mode
      TTY: ip22zilog, fix tty_flip_buffer_push call
      TTY: mn10300-serial, fix build breakage
      TTY: do not update atime/mtime on read/write

Joe Millenbach (2):
      tty: Added a CONFIG_TTY option to allow removal of TTY
      input: drop unnecessary dependencies on TTY

Joe Perches (1):
      TTY: synclink: Convert + to | for bit operations

John Crispin (1):
      serial: ralink: adds support for the serial core found on ralink wisoc

Josh Cartwright (1):
      serial: xilinx_uartps: Get clock rate info from dts

Karthik Manamcheri (1):
      n_tty: Unthrottle tty when flushing read buffer

Kevin Cernekee (4):
      tty: Fix comments that reference BKL, eventd, old paths
      tty: Update serial core API documentation
      tty: rocket: Explicitly list supported PCI IDs
      serial: rp2: New driver for Comtrol RocketPort 2 cards

Laxman Dewangan (1):
      serial: tegra: add serial driver

Liang Li (3):
      pch_uart: fix a deadlock when pch_uart as console
      pch_uart: add sysrq support
      serial: pch_uart: fix sysrq handling for pch_uart

Linus Walleij (1):
      tty: serial core: decouple pm states from ACPI

Michael Chan (1):
      serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.

Michal Simek (3):
      serial: xilinx_uartps: Remove leftover __exit_p()
      tty: serial: uartlite: Fix sparse and checkpatch warnings
      tty: serial: uartlite: Support uartlite on big and little endian systems

Oleg Nesterov (1):
      tty: set_termios/set_termiox should not return -EINTR

Paul Fulghum (1):
      synclink fix ldisc buffer argument

Peter Hurley (6):
      pty: Fix BUG()s when ptmx_open() errors out
      pty: Ignore slave pty close() if never successfully opened
      tty: Document required behavior of tty driver close()
      pty: Ignore slave open count for master pty open
      tty: Remove ancient hardpps()
      pps: Fix build breakage from decoupling pps from tty

Quoc-Viet Nguyen (1):
      serial: mcf: Add support RS485 in ColdFire serial driver

Ralf Baechle (1):
      serial: Remove RM9000 series serial driver.

Randy Dunlap (1):
      lguest: select CONFIG_TTY to build properly.

Sachin Kamat (6):
      serial: Samsung: Use of_match_ptr() macro
      serial: imx: Fix checkpatch errors related to spacing
      serial: imx: Use <linux/io.h> instead of <asm/io.h>
      serial: imx: Fix coding style issue
      serial: imx: Use pr_info instead of printk
      serial: imx: Use devm_* APIs

Sebastian Andrzej Siewior (1):
      tty: don't deadlock while flushing workqueue

Shawn Guo (1):
      serial: imx: fix uninitialized variable warning

Stephen Chivers (1):
      serial/8250: Add suport for later SUNIX (TIMEDIA) boards.

Stephen Rothwell (1):
      sparc: explicitly include sched.h to get task_thread_info declaration

Stephen Warren (2):
      tty: of_serial: unexport tegra_serial_handle_break
      serial: tegra: assume CONFIG_OF

Thierry Reding (2):
      serial: tegra: Switch to using struct tty_port
      serial: lpc32xx: Fix fallout from tty_port conversion

Thomas Abraham (1):
      serial: samsung: remove the use of statically remapped controller address

Thomas Gleixner (1):
      serial: imx: Fix recursive locking bug

Thomas Jarosch (1):
      serial: mxs-auart: Fix typo in sanity check

Tobias Klauser (2):
      tty: serial: altera_uart: Simplify altera_uart_init()
      tty: serial: altera_jtaguart: Simplify altera_jtaguart_init()

Tony Prisk (4):
      serial: vt8500: Fix range-checking on vt8500_uart_ports
      serial: vt8500: ioremap'd resource is never freed
      serial: vt8500: UART uses gated clock rather than 24Mhz reference
      serial: vt8500: Cleanup code using devm_ function

Uwe Kleine-König (1):
      serial/efm32: parse location property

Venu Byravarasu (1):
      serial: tegra: Fix compilation error

Vineet Gupta (6):
      serial/arc-uart: Don't index with -ve platform_device->id
      serial/arc-uart: split probe from probe_earlyprintk
      serial/arc-uart: platform_data order changed
      serial/arc-uart: switch to devicetree based probing
      serial/arc-uart: Fix section mistmatch
      serial/arc-uart: Miscll DT related updates (Grant's review comments)

Wei Yongjun (1):
      TTY: hvsi: use for_each_compatible_node() macro

Yi Zhang (1):
      serial: pxa: fine-tune clk useage

channing (1):
      serial:ifx6x60: Remove memset for SPI frame

fabio.estevam@freescale.com (1):
      Revert "serial: imx: Move imx_port_ucrs_save/restore under CONFIG_CONSOLE_POLL"

xiaojin (1):
      n_gsm.c: add tx_lock in gsm_send

 .../bindings/serial/nvidia,tegra20-hsuart.txt      |   24 +
 .../devicetree/bindings/tty/serial/arc-uart.txt    |   26 +
 .../devicetree/bindings/tty/serial/efm32-uart.txt  |    6 +
 Documentation/serial/driver                        |   44 +-
 arch/alpha/Kconfig                                 |    2 +
 arch/alpha/kernel/srmcons.c                        |   18 +-
 arch/arm/boot/dts/vt8500.dtsi                      |   40 +-
 arch/arm/boot/dts/wm8505.dtsi                      |   60 +-
 arch/arm/boot/dts/wm8650.dtsi                      |   20 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   |    4 +-
 arch/arm/mach-sa1100/assabet.c                     |    1 +
 arch/arm/plat-samsung/include/plat/adc.h           |    1 +
 arch/ia64/hp/sim/Kconfig                           |    1 +
 arch/ia64/hp/sim/simserial.c                       |   21 +-
 arch/m68k/Kconfig.devices                          |    2 +-
 arch/mips/sni/a20r.c                               |    2 +-
 arch/mn10300/kernel/mn10300-serial.c               |   20 +-
 arch/parisc/Kconfig                                |    1 +
 arch/parisc/kernel/pdc_cons.c                      |   10 +-
 arch/sparc/kernel/kgdb_32.c                        |    1 +
 arch/tile/Kconfig                                  |    1 +
 arch/um/Kconfig.common                             |    1 +
 arch/um/drivers/chan.h                             |    3 +-
 arch/um/drivers/chan_kern.c                        |   25 +-
 arch/um/drivers/line.c                             |    7 +-
 arch/x86/lguest/Kconfig                            |    1 +
 arch/xtensa/Kconfig                                |    1 +
 arch/xtensa/platforms/iss/console.c                |   10 +-
 drivers/bluetooth/Kconfig                          |    1 +
 drivers/char/Kconfig                               |    7 +-
 drivers/char/pcmcia/Kconfig                        |    4 +-
 drivers/char/pcmcia/synclink_cs.c                  |   62 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    1 +
 drivers/i2c/busses/Kconfig                         |    2 +-
 drivers/input/serio/Kconfig                        |    1 +
 drivers/ipack/devices/Kconfig                      |    2 +-
 drivers/ipack/devices/ipoctal.c                    |   19 +-
 drivers/isdn/Kconfig                               |    1 +
 drivers/isdn/capi/Kconfig                          |    1 +
 drivers/isdn/gigaset/Kconfig                       |    1 +
 drivers/isdn/gigaset/interface.c                   |   14 +-
 drivers/isdn/hardware/mISDN/Kconfig                |    1 +
 drivers/isdn/i4l/isdn_common.c                     |   14 +-
 drivers/isdn/i4l/isdn_common.h                     |    2 +-
 drivers/isdn/i4l/isdn_tty.c                        |   59 +-
 drivers/lguest/Kconfig                             |    2 +-
 drivers/media/radio/wl128x/Kconfig                 |    2 +-
 drivers/misc/Kconfig                               |    2 +-
 drivers/misc/ti-st/Kconfig                         |    2 +-
 drivers/mmc/card/Kconfig                           |    1 +
 drivers/mmc/card/sdio_uart.c                       |   13 +-
 drivers/net/caif/Kconfig                           |    2 +-
 drivers/net/caif/caif_serial.c                     |    2 +-
 drivers/net/can/Kconfig                            |    2 +-
 drivers/net/hamradio/Kconfig                       |    4 +-
 drivers/net/irda/Kconfig                           |    2 +-
 drivers/net/irda/irtty-sir.c                       |    2 +-
 drivers/net/ppp/Kconfig                            |    3 +
 drivers/net/slip/Kconfig                           |    1 +
 drivers/net/usb/Kconfig                            |    4 +-
 drivers/net/usb/hso.c                              |   32 +-
 drivers/net/wan/Kconfig                            |    2 +-
 drivers/parport/parport_serial.c                   |   21 +
 drivers/pps/clients/Kconfig                        |    2 +-
 drivers/pps/clients/pps-ldisc.c                    |   30 +-
 drivers/pps/pps.c                                  |   47 +-
 drivers/s390/char/Kconfig                          |    8 +-
 drivers/s390/char/con3215.c                        |   12 +-
 drivers/s390/char/keyboard.h                       |   16 +-
 drivers/s390/char/sclp_tty.c                       |   14 +-
 drivers/s390/char/sclp_vt220.c                     |   12 +-
 drivers/s390/char/tty3270.c                        |    4 +-
 drivers/staging/ccg/Kconfig                        |    2 +-
 drivers/staging/ccg/u_serial.c                     |   13 +-
 drivers/staging/dgrp/Kconfig                       |    2 +-
 drivers/staging/dgrp/dgrp_net_ops.c                |   13 +-
 drivers/staging/dgrp/dgrp_tty.c                    |    1 +
 drivers/staging/fwserial/Kconfig                   |    2 +-
 drivers/staging/fwserial/fwserial.c                |   51 +-
 drivers/staging/sb105x/Kconfig                     |    3 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   41 +-
 drivers/staging/speakup/selection.c                |    1 +
 drivers/tty/Kconfig                                |   32 +
 drivers/tty/Makefile                               |    4 +-
 drivers/tty/amiserial.c                            |   18 +-
 drivers/tty/bfin_jtag_comm.c                       |   22 +-
 drivers/tty/cyclades.c                             |  297 ++---
 drivers/tty/ehv_bytechan.c                         |   13 +-
 drivers/tty/goldfish.c                             |  328 +++++
 drivers/tty/hvc/Kconfig                            |    3 +
 drivers/tty/hvc/hvc_console.c                      |    6 +-
 drivers/tty/hvc/hvcs.c                             |    6 +-
 drivers/tty/hvc/hvsi.c                             |   32 +-
 drivers/tty/ipwireless/tty.c                       |   12 +-
 drivers/tty/isicom.c                               |   12 +-
 drivers/tty/metag_da.c                             |  677 ++++++++++
 drivers/tty/moxa.c                                 |   10 +-
 drivers/tty/mxser.c                                |   50 +-
 drivers/tty/n_gsm.c                                |  120 +-
 drivers/tty/n_tty.c                                |   59 +-
 drivers/tty/nozomi.c                               |   37 +-
 drivers/tty/pty.c                                  |   28 +-
 drivers/tty/rocket.c                               |   60 +-
 drivers/tty/serial/21285.c                         |    3 +-
 drivers/tty/serial/68328serial.c                   |   19 +-
 drivers/tty/serial/8250/8250.c                     |  132 +-
 drivers/tty/serial/8250/8250.h                     |   50 +
 drivers/tty/serial/8250/8250_dma.c                 |  216 +++
 drivers/tty/serial/8250/8250_dw.c                  |  257 +++-
 drivers/tty/serial/8250/8250_early.c               |    2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  342 +++++
 drivers/tty/serial/8250/Kconfig                    |   27 +-
 drivers/tty/serial/8250/Makefile                   |    1 +
 drivers/tty/serial/Kconfig                         |   41 +-
 drivers/tty/serial/Makefile                        |    2 +
 drivers/tty/serial/altera_jtaguart.c               |    8 +-
 drivers/tty/serial/altera_uart.c                   |    8 +-
 drivers/tty/serial/amba-pl010.c                    |    3 +-
 drivers/tty/serial/amba-pl011.c                    |   11 +-
 drivers/tty/serial/apbuart.c                       |    3 +-
 drivers/tty/serial/ar933x_uart.c                   |   15 +-
 drivers/tty/serial/arc_uart.c                      |  104 +-
 drivers/tty/serial/atmel_serial.c                  |    9 +-
 drivers/tty/serial/bcm63xx_uart.c                  |    9 +-
 drivers/tty/serial/bfin_sport_uart.c               |   12 +-
 drivers/tty/serial/bfin_uart.c                     |   10 +-
 drivers/tty/serial/clps711x.c                      |    8 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   10 +-
 drivers/tty/serial/crisv10.c                       |   35 +-
 drivers/tty/serial/dz.c                            |    4 +-
 drivers/tty/serial/efm32-uart.c                    |   52 +-
 drivers/tty/serial/icom.c                          |   10 +-
 drivers/tty/serial/ifx6x60.c                       |   11 +-
 drivers/tty/serial/imx.c                           |  282 ++--
 drivers/tty/serial/ioc3_serial.c                   |   11 +-
 drivers/tty/serial/ioc4_serial.c                   |   13 +-
 drivers/tty/serial/ip22zilog.c                     |   30 +-
 drivers/tty/serial/jsm/jsm_tty.c                   |   18 +-
 drivers/tty/serial/kgdb_nmi.c                      |   13 +-
 drivers/tty/serial/lantiq.c                        |   20 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   30 +-
 drivers/tty/serial/m32r_sio.c                      |    8 +-
 drivers/tty/serial/max3100.c                       |   10 +-
 drivers/tty/serial/max310x.c                       |    8 +-
 drivers/tty/serial/mcf.c                           |   73 +-
 drivers/tty/serial/mfd.c                           |   15 +-
 drivers/tty/serial/mpc52xx_uart.c                  |    8 +-
 drivers/tty/serial/mpsc.c                          |   15 +-
 drivers/tty/serial/mrst_max3110.c                  |   19 +-
 drivers/tty/serial/msm_serial.c                    |   16 +-
 drivers/tty/serial/msm_serial_hs.c                 |   19 +-
 drivers/tty/serial/msm_smd_tty.c                   |    4 +-
 drivers/tty/serial/mux.c                           |    9 +-
 drivers/tty/serial/mxs-auart.c                     |   11 +-
 drivers/tty/serial/netx-serial.c                   |    4 +-
 drivers/tty/serial/nwpserial.c                     |    6 +-
 drivers/tty/serial/of_serial.c                     |    7 +-
 drivers/tty/serial/omap-serial.c                   |   51 +-
 drivers/tty/serial/pch_uart.c                      |   90 +-
 drivers/tty/serial/pmac_zilog.c                    |   36 +-
 drivers/tty/serial/pnx8xxx_uart.c                  |    3 +-
 drivers/tty/serial/pxa.c                           |   17 +-
 drivers/tty/serial/rp2.c                           |  885 +++++++++++++
 drivers/tty/serial/sa1100.c                        |    3 +-
 drivers/tty/serial/samsung.c                       |   15 +-
 drivers/tty/serial/sb1250-duart.c                  |    2 +-
 drivers/tty/serial/sc26xx.c                        |   29 +-
 drivers/tty/serial/sccnxp.c                        |  171 ++-
 drivers/tty/serial/serial-tegra.c                  | 1401 ++++++++++++++++++++
 drivers/tty/serial/serial_core.c                   |   94 +-
 drivers/tty/serial/serial_ks8695.c                 |    3 +-
 drivers/tty/serial/serial_txx9.c                   |    3 +-
 drivers/tty/serial/sh-sci.c                        |   52 +-
 drivers/tty/serial/sirfsoc_uart.c                  |   55 +-
 drivers/tty/serial/sirfsoc_uart.h                  |    3 +-
 drivers/tty/serial/sn_console.c                    |   16 +-
 drivers/tty/serial/sunhv.c                         |   33 +-
 drivers/tty/serial/sunsab.c                        |   28 +-
 drivers/tty/serial/sunsu.c                         |   18 +-
 drivers/tty/serial/sunzilog.c                      |   39 +-
 drivers/tty/serial/timbuart.c                      |    6 +-
 drivers/tty/serial/uartlite.c                      |  119 +-
 drivers/tty/serial/ucc_uart.c                      |   10 +-
 drivers/tty/serial/vr41xx_siu.c                    |    4 +-
 drivers/tty/serial/vt8500_serial.c                 |   52 +-
 drivers/tty/serial/xilinx_uartps.c                 |   50 +-
 drivers/tty/serial/zs.c                            |    2 +-
 drivers/tty/synclink.c                             |   50 +-
 drivers/tty/synclink_gt.c                          |   61 +-
 drivers/tty/synclinkmp.c                           |  103 +-
 drivers/tty/tty_buffer.c                           |  131 +-
 drivers/tty/tty_io.c                               |   10 +-
 drivers/tty/tty_ioctl.c                            |   12 +-
 drivers/tty/tty_ldisc.c                            |   14 +-
 drivers/tty/vt/Makefile                            |    4 +-
 drivers/tty/vt/keyboard.c                          |   25 +-
 drivers/tty/vt/vt.c                                |   16 +-
 drivers/usb/class/Kconfig                          |    2 +-
 drivers/usb/class/cdc-acm.c                        |   13 +-
 drivers/usb/gadget/Kconfig                         |    6 +
 drivers/usb/gadget/u_serial.c                      |   15 +-
 drivers/usb/serial/Kconfig                         |    2 +-
 drivers/usb/serial/aircable.c                      |   17 +-
 drivers/usb/serial/ark3116.c                       |   12 +-
 drivers/usb/serial/belkin_sa.c                     |   12 +-
 drivers/usb/serial/cyberjack.c                     |   11 +-
 drivers/usb/serial/cypress_m8.c                    |    6 +-
 drivers/usb/serial/digi_acceleport.c               |   14 +-
 drivers/usb/serial/f81232.c                        |   15 +-
 drivers/usb/serial/ftdi_sio.c                      |   21 +-
 drivers/usb/serial/garmin_gps.c                    |    9 +-
 drivers/usb/serial/generic.c                       |   12 +-
 drivers/usb/serial/io_edgeport.c                   |   39 +-
 drivers/usb/serial/io_ti.c                         |   32 +-
 drivers/usb/serial/ir-usb.c                        |    9 +-
 drivers/usb/serial/iuu_phoenix.c                   |    9 +-
 drivers/usb/serial/keyspan.c                       |   60 +-
 drivers/usb/serial/keyspan_pda.c                   |    9 +-
 drivers/usb/serial/kl5kusb105.c                    |   10 +-
 drivers/usb/serial/kobil_sct.c                     |    9 +-
 drivers/usb/serial/mct_u232.c                      |   11 +-
 drivers/usb/serial/metro-usb.c                     |    9 +-
 drivers/usb/serial/mos7720.c                       |    9 +-
 drivers/usb/serial/mos7840.c                       |   10 +-
 drivers/usb/serial/navman.c                        |    9 +-
 drivers/usb/serial/omninet.c                       |   10 +-
 drivers/usb/serial/opticon.c                       |   11 +-
 drivers/usb/serial/oti6858.c                       |    9 +-
 drivers/usb/serial/pl2303.c                        |   15 +-
 drivers/usb/serial/quatech2.c                      |   29 +-
 drivers/usb/serial/safe_serial.c                   |   15 +-
 drivers/usb/serial/sierra.c                        |   17 +-
 drivers/usb/serial/spcp8x5.c                       |   24 +-
 drivers/usb/serial/ssu100.c                        |   31 +-
 drivers/usb/serial/symbolserial.c                  |    9 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   44 +-
 drivers/usb/serial/usb_wwan.c                      |   17 +-
 drivers/video/auo_k190x.c                          |    1 +
 drivers/video/backlight/ot200_bl.c                 |    1 +
 drivers/video/clps711xfb.c                         |    1 +
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    1 +
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |    1 +
 fs/proc/Makefile                                   |    3 +-
 include/linux/console.h                            |    5 +
 include/linux/kgdb.h                               |    1 -
 include/linux/of_serial.h                          |   17 -
 include/linux/pci_ids.h                            |   15 +
 include/linux/platform_data/s3c-hsotg.h            |    2 +
 .../platform_data/{sccnxp.h => serial-sccnxp.h}    |    6 +-
 include/linux/pps_kernel.h                         |   17 +-
 include/linux/proc_fs.h                            |    5 +
 include/linux/serial_8250.h                        |    4 +
 include/linux/serial_core.h                        |   26 +-
 include/linux/sunserialcore.h                      |    4 +
 include/linux/tty.h                                |   50 +-
 include/linux/tty_driver.h                         |    1 +
 include/linux/tty_flip.h                           |   28 +-
 include/linux/tty_ldisc.h                          |   11 +-
 include/uapi/linux/serial_core.h                   |    5 +-
 kernel/debug/debug_core.c                          |    1 +
 kernel/debug/gdbstub.c                             |    1 +
 lib/Kconfig.kgdb                                   |    1 +
 net/bluetooth/rfcomm/Kconfig                       |    1 +
 net/bluetooth/rfcomm/tty.c                         |   21 +-
 net/irda/ircomm/Kconfig                            |    2 +-
 net/irda/ircomm/ircomm_tty.c                       |    8 +-
 sound/soc/codecs/Kconfig                           |    3 +-
 267 files changed, 6862 insertions(+), 2527 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/nvidia,tegra20-hsuart.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/arc-uart.txt
 create mode 100644 drivers/tty/goldfish.c
 create mode 100644 drivers/tty/metag_da.c
 create mode 100644 drivers/tty/serial/8250/8250_dma.c
 create mode 100644 drivers/tty/serial/rp2.c
 create mode 100644 drivers/tty/serial/serial-tegra.c
 delete mode 100644 include/linux/of_serial.h
 rename include/linux/platform_data/{sccnxp.h => serial-sccnxp.h} (93%)
