Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaDASom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:44:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDASoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:44:39 -0400
Date: Tue, 1 Apr 2014 11:46:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc patches for 3.15-rc1
Message-ID: <20140401184659.GA21763@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.15-rc1

for you to fetch changes up to 1b3fa22e0234d613df967445cd34807e10fa54fa:

  Merge tag 'extcon-next-for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into char-misc-next (2014-03-19 10:05:27 -0700)

----------------------------------------------------------------

Char/Misc driver patches for 3.15-rc1

Here's the big char/misc driver updates for 3.15-rc1.

Lots of various things here, including the new mcb driver subsystem.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alessandro Rubini (4):
      FMC: support carriers with no mezzanine
      FMC: show_sdb_tree: fix offset calculation
      FMC: make eeprom attribute writable
      FMC: show_sdb_tree: dump synthesis/commit ID info

Alexander Gordeev (2):
      mic: Use pci_enable_msix_exact() instead of pci_enable_msix()
      vmw_vmci: Use pci_enable_msix_exact() instead of pci_enable_msix()

Alexander Shiyan (4):
      w1: Remove excess dependencies on W1 for masters and slaves
      w1: mxc_w1: Fix mxc_w1_ds2_reset_bus() return value
      w1: mxc_w1: Driver cleanup
      w1: mxc_w1: Enable driver compilation with COMPILE_TEST

Alexander Stein (1):
      pch_phub: Report error writing MAC back to user

Alexander Usyskin (7):
      mei: hbm: revamp client connect and disconnection status
      mei: fix potential read outside of array bounds
      mei: use helper function to find me client by id
      mei: me: put pm callbacks under PM_SLEEP ifdef
      mei: make return values consistent across the driver
      mei: fix regressions caused by removing ext_msg
      mei: report consistently copy_from/to_user failures

Arnd Bergmann (1):
      parport: fix interruptible_sleep_on race

Bjarke Istrup Pedersen (2):
      hv: Add hyperv.h to uapi headers
      Adding makefile for tools/hv

Chanwoo Choi (2):
      extcon: of: Remove unnecessary function call by using the name of device_node
      extcon: Move OF helper function to extcon core and change function name

Dan Carpenter (1):
      w1: small type cleanup in sysfs

David Fries (16):
      w1: fix w1_send_slave dropping a slave id
      w1: fixup search to support abort from netlink
      w1: Only wake up the search process if it is going to be searching
      w1: increase w1_max_slave_count, allow write access
      w1: continue slave search where previous left off
      w1: new netlink commands, add/remove/list slaves
      w1: process w1 netlink commands in w1_process thread
      connector: add portid to unicast in addition to broadcasting
      w1: reply only to the requester portid
      w1: ds2490 reduce magic numbers
      w1: ds2490 USB setup fixes
      w1: ds2490 fix and enable hardware search
      w1: use family_data instead of rom in w1_slave
      w1: format for DocBook and fixes
      w1: hold bus_mutex in netlink and search
      Revert ds1wm.c from "w1: hold bus_mutex in netlink and search"

Fengguang Wu (1):
      Drivers: hv: fcopy_open() can be static

Gerd Hoffmann (4):
      vmbus: add missing breaks
      vmbus: use resource for hyperv mmio region
      hyperv-fb: add support for generation 2 virtual machines.
      hyperv-fb: kick off efifb early

Greg Kroah-Hartman (6):
      Merge 3.14-rc3 into char-misc-next
      Merge branch 'char-misc-linus' into char-misc-next
      Merge 3.14-rc4 into char-misc-next
      misc: delete mimc200 fram driver
      Merge 3.14-rc5 into char-misc-next
      Merge tag 'extcon-next-for-3.15' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Heiko Stübner (2):
      dt-bindings: sram: describe option to reserve parts of the memory
      misc: sram: implement reserved sram areas

Ivan Khoronzhuk (2):
      memory: ti-aemif: introduce AEMIF driver
      memory: ti-aemif: add bindings for AEMIF driver

Jean Delvare (1):
      cs5535-mfgpt: Simplify dependencies

Jingoo Han (2):
      extcon: palmas: Use SIMPLE_DEV_PM_OPS macro
      extcon: gpio: Use SIMPLE_DEV_PM_OPS macro

Johannes Thumshirn (5):
      drivers: Introduce MEN Chameleon Bus
      mcb: Add PCI carrier for MEN Chameleon Bus
      iio: adc: Add MEN 16z188 ADC driver
      iio: adc: Fix build error discovered by 0-day build bot
      drivers: mcb: Fix build error discovered by 0-day bot

Josh Cartwright (6):
      spmi: add generic SPMI controller binding documentation
      spmi: pmic_arb: add support for interrupt handling
      spmi: document the PMIC arbiter SPMI bindings
      regmap: spmi: support base and extended register spaces
      spmi: pmic_arb: make selectable on ARCH_QCOM
      spmi: pm: drop bus-level PM suspend/resume routines

K. Y. Srinivasan (7):
      Drivers: hv: vmbus: Extract the mmio information from DSDT
      Drivers: hv: vmbus: Cleanup the packet send path
      Drivers: hv: vmbus: Support per-channel driver state
      Tools: hv: vssdaemon: Ignore VFAT mounts during the Freeze operation
      Drivers: hv: Ballon: Make pressure posting thread sleep interruptibly
      Drivers: hv: Implement the file copy service
      Drivers: hv: vmbus: Increase the limit on the number of pfns we can handle

Kees Cook (4):
      lkdtm: convert to using pr_* for reports
      lkdtm: flush icache and report actions
      lkdtm: add "WRITE_KERN" test
      lkdtm: include cacheflush.h

Kenneth Heitke (2):
      spmi: Linux driver framework for SPMI
      spmi: Add MSM PMIC Arbiter SPMI controller

Lucas De Marchi (2):
      misc: add comment on unused minors
      misc: add missing minor nodes

Martyn Welch (1):
      VME: Stop using memcpy_[to|from]io() due to unwanted behaviour

Maxime Ripard (2):
      misc: eeprom: sunxi: Change compatibles
      ARM: sunxi: dt: Convert to the new SID compatibles

Paul Gortmaker (4):
      drivers/char: delete non-required instances of include <linux/init.h>
      drivers/misc: delete non-required instances of include <linux/init.h>
      powerpc: select MEMORY for FSL_IFC to not break existing .config files
      drivers/mcb: do not set default Kconfig variable to modular

Petr Tesarik (1):
      /dev/mem: handle out-of-bounds read/write

Prabhakar Kushwaha (1):
      driver/memory:Move Freescale IFC driver to a common driver

Stephen Rothwell (1):
      mei: txe: include irqreturn.h for irqreturn_t etc

Tomas Winkler (27):
      mei: txe: add hw-txe-regs.h header file
      mei: txe: add hw-txe.h header file
      mei: txe: add hw-txe.c
      mei: txe: add pci-txe.c
      mei: txe: add Kbuild for TXE device
      mei: allow multiple retries if the hw reset has failed
      mei: export active connections to debugfs
      mei: fix compilation error with missing WATCHDOG_CORE
      mei: rename MEI_FOP_IOCTL to MEI_FOP_CONNECT
      mei: get rid of ext_msg
      mei: Remove all bus devices from the mei_dev list when stopping the MEI
      mei: wd and amthif use mei_cl_ api for dis/connection
      mei: don't of list_for_each_entry_safe when not deleting
      mei: txe: put pm callbacks under PM_SLEEP ifdef
      mei: add mei_hbuf_acquire wrapper
      mei: revamp writing slot counting
      mei: wd: simplify wd_send command
      mei: wd: fix stop completion failure
      mei: me: do not reset when less than expected data is received
      mei: fix memory leak of pending write cb objects
      mei: make me hw headers private to me hw.
      mei: drop pr_fmt macros
      mei: fix Unnecessary space after function pointer name
      mei: use cl_dbg where appropriate
      mei: client.h fix checkpatch errors
      mei: amthif: fix checkpatch error
      mei: don't use deprecated DEFINE_PCI_DEVICE_TABLE macro

Uwe Kleine-König (1):
      w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER better

Xiubo Li (1):
      misc: sram: cleanup the code

 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/w1.tmpl                      |  101 ++
 Documentation/connector/cn_test.c                  |    2 +-
 Documentation/devices.txt                          |    2 +
 .../{powerpc => memory-controllers}/fsl/ifc.txt    |    0
 .../bindings/memory-controllers/ti-aemif.txt       |  210 ++++
 .../bindings/misc/allwinner,sunxi-sid.txt          |    4 +-
 Documentation/devicetree/bindings/misc/sram.txt    |   35 +
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |   61 ++
 Documentation/devicetree/bindings/spmi/spmi.txt    |   41 +
 Documentation/fmc/fmc-write-eeprom.txt             |   77 +-
 Documentation/w1/masters/ds2490                    |    2 -
 Documentation/w1/w1.netlink                        |    8 +-
 MAINTAINERS                                        |    6 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |    2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |    2 +-
 arch/avr32/boards/mimc200/Makefile                 |    2 +-
 arch/avr32/boards/mimc200/fram.c                   |   82 --
 arch/powerpc/Kconfig                               |    4 -
 arch/powerpc/sysdev/Makefile                       |    1 -
 drivers/Kconfig                                    |    4 +
 drivers/Makefile                                   |    2 +
 drivers/base/regmap/regmap-spmi.c                  |  228 +++-
 drivers/char/agp/frontend.c                        |    1 -
 drivers/char/agp/generic.c                         |    1 -
 drivers/char/agp/intel-gtt.c                       |    1 -
 drivers/char/agp/sgi-agp.c                         |    1 -
 drivers/char/hw_random/bcm2835-rng.c               |    1 -
 drivers/char/hw_random/core.c                      |    1 -
 drivers/char/hw_random/exynos-rng.c                |    1 -
 drivers/char/hw_random/n2-drv.c                    |    1 -
 drivers/char/hw_random/nomadik-rng.c               |    1 -
 drivers/char/hw_random/octeon-rng.c                |    1 -
 drivers/char/ipmi/ipmi_si_intf.c                   |    1 -
 drivers/char/mem.c                                 |    6 +
 drivers/char/mwave/3780i.c                         |    1 -
 drivers/char/tile-srom.c                           |    1 -
 drivers/char/tpm/tpm_i2c_infineon.c                |    1 -
 drivers/char/tpm/tpm_i2c_stm_st33.c                |    1 -
 drivers/connector/cn_proc.c                        |   18 +-
 drivers/connector/connector.c                      |   20 +-
 drivers/extcon/Kconfig                             |    4 -
 drivers/extcon/Makefile                            |    2 -
 drivers/extcon/extcon-class.c                      |   42 +
 drivers/extcon/extcon-gpio.c                       |    4 +-
 drivers/extcon/extcon-palmas.c                     |    5 +-
 drivers/extcon/of_extcon.c                         |   64 --
 drivers/fmc/fmc-core.c                             |   22 +-
 drivers/fmc/fmc-sdb.c                              |   41 +-
 drivers/hv/Makefile                                |    2 +-
 drivers/hv/channel.c                               |   42 +-
 drivers/hv/hv_balloon.c                            |    3 +-
 drivers/hv/hv_fcopy.c                              |  414 ++++++++
 drivers/hv/hv_kvp.c                                |    4 +-
 drivers/hv/hv_snapshot.c                           |    2 +-
 drivers/hv/hv_util.c                               |   11 +
 drivers/hv/hyperv_vmbus.h                          |    8 +-
 drivers/hv/ring_buffer.c                           |   17 +-
 drivers/hv/vmbus_drv.c                             |   51 +-
 drivers/iio/adc/Kconfig                            |   10 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/men_z188_adc.c                     |  172 +++
 drivers/mcb/Kconfig                                |   31 +
 drivers/mcb/Makefile                               |    7 +
 drivers/mcb/mcb-core.c                             |  414 ++++++++
 drivers/mcb/mcb-internal.h                         |  118 +++
 drivers/mcb/mcb-parse.c                            |  159 +++
 drivers/mcb/mcb-pci.c                              |  114 ++
 drivers/md/dm-log-userspace-transfer.c             |    2 +-
 drivers/memory/Kconfig                             |   15 +
 drivers/memory/Makefile                            |    2 +
 {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c  |    8 +-
 drivers/memory/ti-aemif.c                          |  427 ++++++++
 drivers/misc/Kconfig                               |    2 +-
 drivers/misc/ad525x_dpot.c                         |    1 -
 drivers/misc/apds9802als.c                         |    1 -
 drivers/misc/bmp085.c                              |    1 -
 drivers/misc/carma/carma-fpga.c                    |    1 -
 drivers/misc/ds1682.c                              |    1 -
 drivers/misc/eeprom/at25.c                         |    1 -
 drivers/misc/eeprom/eeprom.c                       |    1 -
 drivers/misc/eeprom/eeprom_93xx46.c                |    1 -
 drivers/misc/eeprom/max6875.c                      |    1 -
 drivers/misc/eeprom/sunxi_sid.c                    |    3 +-
 drivers/misc/genwqe/card_debugfs.c                 |    1 -
 drivers/misc/hmc6352.c                             |    1 -
 drivers/misc/isl29003.c                            |    1 -
 drivers/misc/isl29020.c                            |    1 -
 drivers/misc/lattice-ecp3-config.c                 |    1 -
 drivers/misc/lis3lv02d/lis3lv02d.c                 |    1 -
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c             |    1 -
 drivers/misc/lis3lv02d/lis3lv02d_spi.c             |    1 -
 drivers/misc/lkdtm.c                               |   74 +-
 drivers/misc/mei/Kconfig                           |    9 +
 drivers/misc/mei/Makefile                          |    6 +-
 drivers/misc/mei/amthif.c                          |   72 +-
 drivers/misc/mei/bus.c                             |   21 +-
 drivers/misc/mei/client.c                          |  300 +++---
 drivers/misc/mei/client.h                          |   30 +-
 drivers/misc/mei/debugfs.c                         |   54 +
 drivers/misc/mei/hbm.c                             |  281 ++---
 drivers/misc/mei/hbm.h                             |    1 +
 drivers/misc/mei/hw-me.c                           |   30 +-
 drivers/misc/mei/hw-txe-regs.h                     |  294 ++++++
 drivers/misc/mei/hw-txe.c                          | 1107 ++++++++++++++++++++
 drivers/misc/mei/hw-txe.h                          |   74 ++
 drivers/misc/mei/hw.h                              |   20 +-
 drivers/misc/mei/init.c                            |   43 +-
 drivers/misc/mei/interrupt.c                       |  159 +--
 drivers/misc/mei/main.c                            |   23 +-
 drivers/misc/mei/mei_dev.h                         |   54 +-
 drivers/misc/mei/nfc.c                             |   14 +-
 drivers/misc/mei/pci-me.c                          |   14 +-
 drivers/misc/mei/pci-txe.c                         |  293 ++++++
 drivers/misc/mei/wd.c                              |  136 +--
 drivers/misc/mic/host/mic_intr.c                   |    2 +-
 drivers/misc/pch_phub.c                            |    5 +-
 drivers/misc/sram.c                                |  127 ++-
 drivers/misc/ti-st/st_core.c                       |    1 -
 drivers/misc/ti_dac7512.c                          |    1 -
 drivers/misc/tsl2550.c                             |    1 -
 drivers/misc/vmw_vmci/vmci_guest.c                 |    7 +-
 drivers/mtd/nand/Kconfig                           |    1 +
 drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
 drivers/parport/share.c                            |    3 +-
 drivers/spmi/Kconfig                               |   27 +
 drivers/spmi/Makefile                              |    6 +
 drivers/spmi/spmi-pmic-arb.c                       |  778 ++++++++++++++
 drivers/spmi/spmi.c                                |  574 ++++++++++
 drivers/usb/dwc3/dwc3-omap.c                       |    3 +-
 drivers/video/hyperv_fb.c                          |   88 +-
 drivers/video/uvesafb.c                            |    4 +-
 drivers/vme/bridges/vme_ca91cx42.c                 |   29 +-
 drivers/vme/bridges/vme_tsi148.c                   |   18 +-
 drivers/w1/masters/Kconfig                         |    3 +-
 drivers/w1/masters/ds2490.c                        |  155 ++-
 drivers/w1/masters/mxc_w1.c                        |   43 +-
 drivers/w1/masters/w1-gpio.c                       |   19 +-
 drivers/w1/slaves/Kconfig                          |    5 -
 drivers/w1/slaves/w1_therm.c                       |   21 +-
 drivers/w1/w1.c                                    |  269 +++--
 drivers/w1/w1.h                                    |  186 +++-
 drivers/w1/w1_family.c                             |    8 +
 drivers/w1/w1_family.h                             |   13 +
 drivers/w1/w1_int.c                                |   25 +-
 drivers/w1/w1_io.c                                 |  102 +-
 drivers/w1/w1_netlink.c                            |  359 +++++--
 drivers/w1/w1_netlink.h                            |   33 +-
 include/dt-bindings/spmi/spmi.h                    |   18 +
 include/linux/connector.h                          |    2 +-
 include/linux/extcon.h                             |   12 +
 include/linux/extcon/of_extcon.h                   |   31 -
 include/linux/fmc-sdb.h                            |    2 +
 .../include/asm => include/linux}/fsl_ifc.h        |    0
 include/linux/hyperv.h                             |  353 +------
 include/linux/mcb.h                                |  119 +++
 include/linux/miscdevice.h                         |   16 +-
 include/linux/mod_devicetable.h                    |   13 +
 include/linux/regmap.h                             |   12 +-
 include/linux/spmi.h                               |  191 ++++
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/hyperv.h                        |  390 +++++++
 tools/Makefile                                     |   11 +-
 tools/hv/Makefile                                  |   13 +
 tools/hv/hv_fcopy_daemon.c                         |  195 ++++
 tools/hv/hv_vss_daemon.c                           |    2 +
 167 files changed, 8865 insertions(+), 1722 deletions(-)
 create mode 100644 Documentation/DocBook/w1.tmpl
 rename Documentation/devicetree/bindings/{powerpc => memory-controllers}/fsl/ifc.txt (100%)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti-aemif.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt
 delete mode 100644 arch/avr32/boards/mimc200/fram.c
 delete mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 drivers/hv/hv_fcopy.c
 create mode 100644 drivers/iio/adc/men_z188_adc.c
 create mode 100644 drivers/mcb/Kconfig
 create mode 100644 drivers/mcb/Makefile
 create mode 100644 drivers/mcb/mcb-core.c
 create mode 100644 drivers/mcb/mcb-internal.h
 create mode 100644 drivers/mcb/mcb-parse.c
 create mode 100644 drivers/mcb/mcb-pci.c
 rename {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c (98%)
 create mode 100644 drivers/memory/ti-aemif.c
 create mode 100644 drivers/misc/mei/hw-txe-regs.h
 create mode 100644 drivers/misc/mei/hw-txe.c
 create mode 100644 drivers/misc/mei/hw-txe.h
 create mode 100644 drivers/misc/mei/pci-txe.c
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-pmic-arb.c
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/dt-bindings/spmi/spmi.h
 delete mode 100644 include/linux/extcon/of_extcon.h
 rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)
 create mode 100644 include/linux/mcb.h
 create mode 100644 include/linux/spmi.h
 create mode 100644 include/uapi/linux/hyperv.h
 create mode 100644 tools/hv/Makefile
 create mode 100644 tools/hv/hv_fcopy_daemon.c
