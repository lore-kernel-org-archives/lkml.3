Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaHDTJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:09:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaHDTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:09:11 -0400
Date: Mon, 4 Aug 2014 12:09:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.17-rc1
Message-ID: <20140804190910.GA27392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.17-rc1

for you to fetch changes up to 5a64096700dc9761b57e767c9f0b740eb2cb84dd:

  tty/n_gsm.c: fix a memory leak in gsmld_open (2014-08-01 16:04:54 -0700)

----------------------------------------------------------------
TTY / Serial driver update for 3.17-rc1

Here's the big tty / serial driver update for 3.17-rc1.

Nothing major, just a number of fixes and new features for different
serial drivers, and some more tty core fixes and documentation of the
tty locks.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (2):
      serial: core: Make enable_ms() optional
      serial: treewide: Remove empty implementations of enable_ms()

Andy Shevchenko (3):
      serial: 8250_dw: use UPF_* constants when define flags
      serial: 8250: introduce up_to_u8250p() helper
      pch_uart: don't hardcode PCI slot to get DMA device

Arnd Bergmann (2):
      serial: pxa: fix build with !SERIAL_PXA_CONSOLE
      serial: lpc32xx uart module can't do console

Chen-Yu Tsai (2):
      serial: 8250_dw: Add optional reset control support
      serial: 8250_dw: Add support for deferred probing

Dan Carpenter (1):
      serial: txx9: remove duplicate TXX9_SIFCR_TDIL_MASK define

Daniel Thompson (2):
      serial: altera: Adopt uart_console_write()
      tty: kgdb_nmi: Automatically manage tty enable

Fabio Estevam (1):
      serial: samsung: Use %pa to print 'resource_size_t' type

Geert Uytterhoeven (1):
      serial: pch_uart: Update error message for dmaengine_prep_slave_sg() API

Greg Kroah-Hartman (3):
      Merge 3.16-rc5 into tty-next.
      Serial: allow port drivers to have a default attribute group
      Revert "ARC: [arcfpga] stdout-path now suffices for earlycon/console"

Heikki Krogerus (1):
      serial: 8250_dw: clock rate handling for all ACPI platforms

Heiko Stübner (1):
      serial: 8250_dw: add ability to handle the peripheral clock

Jingchang Lu (2):
      dt-binding: fsl-lpuart: use exact SoC revision to document binding
      tty: serial: fsl_lpuart: add 32-bit register interface support

Jiri Slaby (1):
      tty: n_gsm, use setup_timer

Johannes Thumshirn (1):
      tty: serial: men_z135_uart: Wakeup UART after transmitting

Jon Ringle (1):
      serial: sc16is7xx: Correct initialization of s->clk

Kiran Padwal (1):
      tty: serial: msm: Make of_device_id array const

Kukjin Kim (2):
      serial: samsung: no more support for S5P6440 and S5P6450 SoCs
      serial: samsung: no more support for S5PC100 SoC

Maxime COQUELIN (2):
      serial: st-asc: Don't call BUG in asc_console_setup()
      serial: st-asc: Fix overflow in baudrate calculation

Naveen Krishna Chatradhi (3):
      serial: samsung: get fifosize via device tree
      serial: samsung: correct the case and default order in switch
      serial: samsung: improve code clarity by defining a variable

Nobuhiro Iwamatsu (3):
      serial: sh-sci: Updated calculation of bit error rate and bit rate
      serial: sh-sci: Fix range check of bit-rate for HSCIF
      serial: sh-sci: Add calculation recive margin for HSCIF

Peter Hurley (14):
      serial: core: Preserve termios c_cflag for console resume
      tty: Document locking for tty driver methods
      tty: Document locking for tty_port_close{,start,end}()
      tty: Document locking for tty_port_open()
      tty: Document locking for tty_port_block_til_ready()
      tty: Document locking for tty_port_hangup()
      tty: Move tty->closing from port lock critical section
      tty: ipwireless: Remove tty->closing abort from ipw_open()
      serial: Use UPF_* constants with struct uart_port flags
      tty: Remove tty_hung_up_p() tests from tty drivers' open()
      char: synclink: Remove WARN_ON for bad port count
      tty: Call hangup method in modern style
      tty: serial: Fix termios/port flags mismatch
      serial: blackfin: Fix CTS flow control

Pradeep Goudagunta (2):
      serial: tegra: update tx_circular buffer only when TX_DMA is in progress
      serial: tegra: ack the rx dma desc after transfer terminated

Qipan Li (1):
      serial: sirf: transfer more bytes once to decrease interrupts

Rasmus Villemoes (2):
      drivers: tty: Merge alloc_tty_struct and initialize_tty_struct
      drivers: tty: Fix use-after-free in pty_common_install

Rickard Strandqvist (1):
      tty: serial: msm_serial.c: Cleaning up uninitialized variables

Stefan Agner (2):
      serial: fsl_lpuart: move DMA RX timeout calculation
      serial: fsl_lpuart: calculate DMA burst

Stephen Boyd (1):
      tty: serial: msm: Support big-endian CPUs

Tobias Klauser (2):
      serial: altera_jtaguart: Adpot uart_console_write()
      serial: altera_jtaguart: Fix putchar function passed to uart_console_write()

Tomasz Figa (3):
      Documentation: devicetree: Update samsung UART bindings
      serial: samsung: Consider DT alias when probing ports
      ARM: dts: SAMSUNG: Add aliases of UART nodes

Tushar Behera (3):
      serial: samsung: Remove redundant label
      serial: amba-pl011: Remove redundant label
      serial: amba-pl010: Use devres APIs

Uwe Kleine-König (1):
      serial: efm32: correct namespacing of location property

Vineet Gupta (11):
      serial/arc: use uart_console_write() helper
      serial/arc: Refactor by referencing to uart_port where possible
      serial/arc: Remove the workaround for legacy ISS
      serial/arc: Use generic earlycon infrastructure
      serial/arc: remove earlyprintk support and switch to earlycon
      serial/arc: remove last remanants of platform data
      serial/arc: inline the probe helper
      ARC: [arcfpga] RIP early uart platform device stuff
      serial/arc: Enable DT based earlycon
      ARC: [arcfpga] stdout-path now suffices for earlycon/console
      serial/arc: Fix warning with CONSOLE_POLL

Wolfram Sang (1):
      drivers/tty/serial: use correct type for dma_map/unmap

Yoshihiro YUNOMAE (2):
      serial/uart/8250: Add tunable RX interrupt trigger I/F of FIFO buffers
      serial/core: Fix too big allocation for attribute member

xinhui.pan (2):
      tty/n_gsm.c: get gsm->num after gsm_activate_mux
      tty/n_gsm.c: fix a memory leak in gsmld_open

 Documentation/ABI/testing/sysfs-tty                |  16 +
 .../devicetree/bindings/serial/efm32-uart.txt      |   4 +-
 .../devicetree/bindings/serial/fsl-lpuart.txt      |   6 +-
 .../devicetree/bindings/serial/samsung_uart.txt    |  56 +-
 .../bindings/serial/snps-dw-apb-uart.txt           |  32 +
 arch/arc/boot/dts/angel4.dts                       |   2 +-
 arch/arc/plat-arcfpga/Kconfig                      |   7 -
 arch/arc/plat-arcfpga/platform.c                   |  97 +--
 arch/arm/boot/dts/exynos3250.dtsi                  |   2 +
 arch/arm/boot/dts/exynos4.dtsi                     |  12 +-
 arch/arm/boot/dts/exynos5.dtsi                     |  15 +-
 arch/arm/boot/dts/exynos5260.dtsi                  |   4 +
 arch/arm/boot/dts/exynos5410.dtsi                  |   6 +
 arch/arm/boot/dts/exynos5440.dtsi                  |   6 +-
 arch/arm/boot/dts/s3c2416.dtsi                     |   6 +-
 arch/arm/boot/dts/s3c24xx.dtsi                     |   9 +-
 arch/arm/boot/dts/s3c64xx.dtsi                     |   4 +
 drivers/char/pcmcia/synclink_cs.c                  |   4 +-
 drivers/staging/dgrp/dgrp_tty.c                    |  10 -
 drivers/tty/cyclades.c                             |   2 +-
 drivers/tty/ipwireless/tty.c                       |   5 -
 drivers/tty/n_gsm.c                                |  17 +-
 drivers/tty/pty.c                                  |  21 +-
 drivers/tty/serial/21285.c                         |   5 -
 drivers/tty/serial/8250/8250.h                     |   2 +
 drivers/tty/serial/8250/8250_core.c                | 230 +++++--
 drivers/tty/serial/8250/8250_dw.c                  | 190 +++---
 drivers/tty/serial/8250/8250_fsl.c                 |   3 +-
 drivers/tty/serial/8250/8250_pci.c                 |   6 +-
 drivers/tty/serial/Kconfig                         |   4 +-
 drivers/tty/serial/altera_jtaguart.c               |  19 +-
 drivers/tty/serial/altera_uart.c                   |  13 +-
 drivers/tty/serial/amba-pl010.c                    |  48 +-
 drivers/tty/serial/amba-pl011.c                    |  30 +-
 drivers/tty/serial/apbuart.c                       |   6 -
 drivers/tty/serial/ar933x_uart.c                   |   5 -
 drivers/tty/serial/arc_uart.c                      | 337 ++++------
 drivers/tty/serial/atmel_serial.c                  |   8 +-
 drivers/tty/serial/bfin_sport_uart.c               |  17 +-
 drivers/tty/serial/bfin_uart.c                     |  22 +-
 drivers/tty/serial/clps711x.c                      |   1 -
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   9 -
 drivers/tty/serial/crisv10.c                       |  15 +-
 drivers/tty/serial/dz.c                            |   6 -
 drivers/tty/serial/efm32-uart.c                    |  14 +-
 drivers/tty/serial/fsl_lpuart.c                    | 689 ++++++++++++++++++++-
 drivers/tty/serial/icom.c                          |   6 -
 drivers/tty/serial/ioc3_serial.c                   |   1 -
 drivers/tty/serial/ioc4_serial.c                   |   1 -
 drivers/tty/serial/jsm/jsm_tty.c                   |   6 -
 drivers/tty/serial/kgdb_nmi.c                      |  36 +-
 drivers/tty/serial/lantiq.c                        |   8 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   7 -
 drivers/tty/serial/max310x.c                       |   1 -
 drivers/tty/serial/mcf.c                           |  11 +-
 drivers/tty/serial/men_z135_uart.c                 |   6 +-
 drivers/tty/serial/mpsc.c                          |   5 -
 drivers/tty/serial/mrst_max3110.c                  |   5 -
 drivers/tty/serial/msm_serial.c                    |  32 +-
 drivers/tty/serial/msm_serial.h                    |   4 +-
 drivers/tty/serial/mux.c                           |  11 -
 drivers/tty/serial/mxs-auart.c                     |   6 -
 drivers/tty/serial/nwpserial.c                     |   6 -
 drivers/tty/serial/pch_uart.c                      |   9 +-
 drivers/tty/serial/pxa.c                           |   2 +-
 drivers/tty/serial/samsung.c                       |  44 +-
 drivers/tty/serial/sc16is7xx.c                     |  10 +-
 drivers/tty/serial/sccnxp.c                        |   6 -
 drivers/tty/serial/serial-tegra.c                  |   4 +
 drivers/tty/serial/serial_core.c                   |  59 +-
 drivers/tty/serial/serial_txx9.c                   |   7 -
 drivers/tty/serial/sh-sci.c                        |  94 ++-
 drivers/tty/serial/sirfsoc_uart.c                  |   3 +-
 drivers/tty/serial/sirfsoc_uart.h                  |   2 +-
 drivers/tty/serial/sn_console.c                    |  10 -
 drivers/tty/serial/st-asc.c                        |  20 +-
 drivers/tty/serial/sunhv.c                         |   6 -
 drivers/tty/serial/sunsab.c                        |   7 -
 drivers/tty/serial/tilegx.c                        |  10 -
 drivers/tty/serial/timbuart.c                      |   6 -
 drivers/tty/serial/uartlite.c                      |   6 -
 drivers/tty/serial/ucc_uart.c                      |  11 -
 drivers/tty/serial/xilinx_uartps.c                 |   6 -
 drivers/tty/synclink.c                             |  10 +-
 drivers/tty/synclink_gt.c                          |  10 +-
 drivers/tty/synclinkmp.c                           |  11 +-
 drivers/tty/tty_io.c                               |  39 +-
 drivers/tty/tty_port.c                             |  43 +-
 include/linux/serial_8250.h                        |   7 +
 include/linux/serial_core.h                        |   2 +
 include/linux/tty.h                                |   4 +-
 include/linux/tty_driver.h                         |   8 +-
 include/uapi/linux/serial_reg.h                    |   5 +
 net/irda/ircomm/ircomm_tty.c                       |   6 +-
 94 files changed, 1583 insertions(+), 1058 deletions(-)
