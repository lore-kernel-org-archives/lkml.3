Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaLNWhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:37:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLNWhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:37:09 -0500
Date: Sun, 14 Dec 2014 14:37:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver patches for 3.19-rc1
Message-ID: <20141214223708.GA4007@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.19-rc1

for you to fetch changes up to 91905b6f4afe51e23a3f58df93e4cdc5e49cf40c:

  parport: parport_pc, do not remove parent devices early (2014-11-26 19:33:57 -0800)

----------------------------------------------------------------
Char/Misc driver patches for 3.19-rc1

Here's the big char/misc driver update for 3.19-rc1

Lots of little things all over the place in different drivers, and a new
subsystem, "coresight" has been added.  Full details are in the
shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Alexander Stein (1):
      W1: ds2490: Increase timeout when waiting for status

Alexander Usyskin (3):
      mei: drop unneeded client NULL check in cb structure
      mei: hbm: use client specific print functions
      mei: read and print all six FW status registers

Bo Shen (1):
      misc: atmel-ssc: prepare clock only when request

Cristian Stoica (2):
      devres: support sizes greater than an unsigned long
      uio: support memory sizes larger than 32 bits

Dan Carpenter (1):
      hangcheck-timer: cleanup casting in hangcheck_init()

David Fries (2):
      cn: verify msg->len before making callback
      w1: avoid potential u16 overflow

Dexuan Cui (3):
      Tools: hv: vssdaemon: ignore the EBUSY on multiple freezing the same partition
      tools: hv: ignore ENOBUFS and ENOMEM in the KVP daemon
      hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block

Dmitry Eremin-Solenikov (2):
      pcmcia: sa1111: pass sa1111_dev to badge4-specific code
      pcmcia: sa1111: pass sa1111_dev to jornada720 code

Greg Kroah-Hartman (5):
      Revert "driver core: Fix unbalanced device reference in drivers_probe"
      Revert "char: misc: document behaviour of open()"
      Revert "fbdev: pxa3xx-gcu: remove redundant implementation of open()"
      Revert "misc: always assign miscdevice to file->private_data in open()"
      Merge tag 'extcon-next-for-3.19' of git://git.kernel.org/.../chanwoo/extcon into char-misc-testing

Hans Verkuil (3):
      carma-fpga-program.c: fix compile errors
      carma-fpga: drop videobuf dependency
      carma-fpga-program: drop videobuf dependency

Ian Abbott (1):
      misc: genwqe: check for error from get_user_pages_fast()

Ian Munsie (1):
      CXL: Return error to PSL if IRQ demultiplexing fails & print clearer warning

Jiri Slaby (1):
      parport: parport_pc, do not remove parent devices early

Krzysztof Kozlowski (2):
      extcon: max77693: Fix cable name of JIG_UART_ON
      extcon: max14577: Fix obvious typo in company name in copyright

Martin Kepplinger (3):
      misc: always assign miscdevice to file->private_data in open()
      fbdev: pxa3xx-gcu: remove redundant implementation of open()
      char: misc: document behaviour of open()

Mathieu Poirier (6):
      coresight: documentation for coresight framework and drivers
      coresight: adding support for beagle and beagleXM
      coresight: adding basic support for Vexpress TC2
      ARM: removing support for etb/etm in "arch/arm/kernel/"
      coresight: Adding ABI documentation
      coresight: bindings for coresight drivers

Michael Neuling (1):
      cxl: Name interrupts in /proc/interrupt

NeilBrown (1):
      w1: support auto-load of w1_bq27000 module.

Pali Rohár (3):
      i8k: Add support for Dell Latitude E6440
      i8k: Add MODULE_DEVICE_TABLE macro
      i8k: Fix temperature bug handling in i8k_get_temp()

Pankaj Dubey (3):
      coresight: fix typo in comment in coresight-priv.h
      coresight: fixed comments in coresight.h
      coresight-replicator: remove .owner field for driver

Pratik Patel (7):
      coresight: add CoreSight core layer framework
      coresight-tmc: add CoreSight TMC driver
      coresight-tpiu: add CoreSight TPIU driver
      coresight-etb: add CoreSight ETB driver
      coresight-funnel: add CoreSight Funnel driver
      coresight-replicator: add CoreSight Replicator driver
      coresight-etm: add CoreSight ETM/PTM driver

Stephen Boyd (1):
      spmi: Remove shutdown/suspend/resume kernel-doc

Thierry Reding (2):
      pch_phub: Build context save/restore only for PM
      misc: Remove unused subdirectory

Tomas Winkler (7):
      mei: use local cl variables in wd and amthif
      mei: debugfs: display also connectionless clients
      mei: nfc: clean nfc internal struct on host exit
      mei: fix hbm MEI_HBM_STARTED ambiguity
      mei: kill cached host and me csr values
      mei: txe: add cherrytrail device id
      mei: export fw status registers through sysfs

Tomasz Figa (1):
      extcon: Implement OF-based extcon lookup properly

Valentin Rothberg (2):
      checkkconfigsymbols.sh: reimplementation in python
      checkkconfigsymbols.py: improve detection of defects

Vitaly Kuznetsov (7):
      tools: hv: introduce -n/--no-daemon option
      Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
      Drivers: hv: vmbus: Fix a race condition when unregistering a device
      Drivers: hv: vss: Introduce timeout for communication with userspace
      Drivers: hv: kvp,vss: Fast propagation of userspace communication failure
      Tools: hv: vssdaemon: report freeze errors
      Tools: hv: vssdaemon: skip all filesystems mounted readonly

Xia Kaixu (1):
      coresight: adding basic support for D01 board

 .../ABI/testing/sysfs-bus-coresight-devices-etb10  |   24 +
 .../ABI/testing/sysfs-bus-coresight-devices-etm3x  |  253 +++
 .../ABI/testing/sysfs-bus-coresight-devices-funnel |   12 +
 .../ABI/testing/sysfs-bus-coresight-devices-tmc    |    8 +
 Documentation/DocBook/uio-howto.tmpl               |    2 +-
 .../devicetree/bindings/arm/coresight.txt          |  204 +++
 Documentation/trace/coresight.txt                  |  299 +++
 MAINTAINERS                                        |    9 +
 arch/arm/Kconfig.debug                             |   63 +-
 arch/arm/boot/dts/hip04.dtsi                       |  717 ++++++++
 arch/arm/boot/dts/omap3-beagle-xm.dts              |   28 +
 arch/arm/boot/dts/omap3-beagle.dts                 |   28 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  199 ++
 arch/arm/include/asm/hardware/coresight.h          |  157 --
 arch/arm/include/asm/hardware/cp14.h               |  542 ++++++
 arch/arm/kernel/Makefile                           |    1 -
 arch/arm/kernel/etm.c                              |  654 -------
 arch/arm/kernel/hw_breakpoint.c                    |    4 +-
 arch/arm/mach-omap2/Kconfig                        |    8 -
 arch/arm/mach-omap2/Makefile                       |    1 -
 arch/arm/mach-omap2/emu.c                          |   50 -
 drivers/Makefile                                   |    1 +
 drivers/amba/bus.c                                 |    2 +-
 drivers/char/hangcheck-timer.c                     |    4 +-
 drivers/char/i8k.c                                 |   26 +-
 drivers/connector/connector.c                      |    6 +
 drivers/coresight/Makefile                         |   11 +
 drivers/coresight/coresight-etb10.c                |  537 ++++++
 drivers/coresight/coresight-etm-cp14.c             |  591 ++++++
 drivers/coresight/coresight-etm.h                  |  251 +++
 drivers/coresight/coresight-etm3x.c                | 1928 ++++++++++++++++++++
 drivers/coresight/coresight-funnel.c               |  268 +++
 drivers/coresight/coresight-priv.h                 |   63 +
 drivers/coresight/coresight-replicator.c           |  137 ++
 drivers/coresight/coresight-tmc.c                  |  776 ++++++++
 drivers/coresight/coresight-tpiu.c                 |  217 +++
 drivers/coresight/coresight.c                      |  717 ++++++++
 drivers/coresight/of_coresight.c                   |  204 +++
 drivers/extcon/extcon-class.c                      |   14 +-
 drivers/extcon/extcon-max14577.c                   |    2 +-
 drivers/extcon/extcon-max77693.c                   |   12 +-
 drivers/hv/channel_mgmt.c                          |   11 +-
 drivers/hv/hv_balloon.c                            |   10 +-
 drivers/hv/hv_kvp.c                                |    9 +-
 drivers/hv/hv_snapshot.c                           |   28 +-
 drivers/misc/atmel-ssc.c                           |    4 +-
 drivers/misc/carma/Kconfig                         |    6 +-
 drivers/misc/carma/carma-fpga-program.c            |  104 +-
 drivers/misc/carma/carma-fpga.c                    |   98 +-
 drivers/misc/cxl/cxl.h                             |   15 +-
 drivers/misc/cxl/irq.c                             |  144 +-
 drivers/misc/cxl/native.c                          |   14 +-
 drivers/misc/fuse/Makefile                         |    1 -
 drivers/misc/genwqe/card_utils.c                   |    2 +
 drivers/misc/mei/amthif.c                          |   34 +-
 drivers/misc/mei/bus.c                             |    4 +-
 drivers/misc/mei/client.c                          |    2 +-
 drivers/misc/mei/debugfs.c                         |    8 +-
 drivers/misc/mei/hbm.c                             |   23 +-
 drivers/misc/mei/hbm.h                             |    4 +-
 drivers/misc/mei/hw-me-regs.h                      |   12 +-
 drivers/misc/mei/hw-me.c                           |   49 +-
 drivers/misc/mei/hw-me.h                           |   10 +-
 drivers/misc/mei/hw-txe.c                          |    7 +-
 drivers/misc/mei/init.c                            |   38 +-
 drivers/misc/mei/interrupt.c                       |   12 +-
 drivers/misc/mei/main.c                            |   43 +-
 drivers/misc/mei/mei_dev.h                         |   39 +-
 drivers/misc/mei/nfc.c                             |   52 +-
 drivers/misc/mei/pci-me.c                          |   12 +-
 drivers/misc/mei/pci-txe.c                         |    1 +
 drivers/misc/mei/wd.c                              |    9 +-
 drivers/misc/pch_phub.c                            |    2 +
 drivers/parport/parport_pc.c                       |    7 +-
 drivers/pcmcia/sa1111_badge4.c                     |    2 +-
 drivers/pcmcia/sa1111_generic.c                    |    4 +-
 drivers/pcmcia/sa1111_generic.h                    |    4 +-
 drivers/pcmcia/sa1111_jornada720.c                 |    3 +-
 drivers/uio/uio.c                                  |    4 +-
 drivers/w1/masters/ds2490.c                        |    2 +-
 drivers/w1/slaves/w1_bq27000.c                     |    4 +-
 drivers/w1/w1.c                                    |    2 +-
 drivers/w1/w1_family.h                             |    1 +
 drivers/w1/w1_netlink.c                            |    2 +-
 include/linux/amba/bus.h                           |    1 +
 include/linux/coresight.h                          |  263 +++
 include/linux/io.h                                 |    4 +-
 include/linux/spmi.h                               |    3 -
 include/linux/uio_driver.h                         |    2 +-
 include/uapi/linux/hyperv.h                        |    1 +
 lib/devres.c                                       |    4 +-
 scripts/checkkconfigsymbols.py                     |  139 ++
 scripts/checkkconfigsymbols.sh                     |   59 -
 tools/hv/hv_fcopy_daemon.c                         |   33 +-
 tools/hv/hv_kvp_daemon.c                           |   48 +-
 tools/hv/hv_vss_daemon.c                           |   95 +-
 96 files changed, 9309 insertions(+), 1215 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-funnel
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-tmc
 create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
 create mode 100644 Documentation/trace/coresight.txt
 delete mode 100644 arch/arm/include/asm/hardware/coresight.h
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 delete mode 100644 arch/arm/kernel/etm.c
 delete mode 100644 arch/arm/mach-omap2/emu.c
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-etb10.c
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.h
 create mode 100644 drivers/coresight/coresight-etm3x.c
 create mode 100644 drivers/coresight/coresight-funnel.c
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight-replicator.c
 create mode 100644 drivers/coresight/coresight-tmc.c
 create mode 100644 drivers/coresight/coresight-tpiu.c
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 delete mode 100644 drivers/misc/fuse/Makefile
 create mode 100644 include/linux/coresight.h
 create mode 100644 scripts/checkkconfigsymbols.py
 delete mode 100755 scripts/checkkconfigsymbols.sh
