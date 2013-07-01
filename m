Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3GARSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:18:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GARSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:18:46 -0400
Date: Mon, 1 Jul 2013 10:18:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.11-rc1
Message-ID: <20130701171845.GA25836@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.11-rc1

for you to fetch changes up to 380672698b8e64f0b5e418412b1ed370bd366428:

  Revert "char: misc: assign file->private_data in all cases" (2013-06-26 10:12:48 -0700)

----------------------------------------------------------------
Char/Misc merge for 3.11-rc1

Here's the big char/misc driver tree merge for 3.11-rc1

A variety of different driver patches here.  All of these have been in
linux-next for a while, and the networking patches were acked-by David
Miller, as it made sense for those patches to come through this tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alessandro Rubini (8):
      FMC: create drivers/fmc and toplevel Kconfig question
      FMC: add needed headers
      FMC: add core bus driver
      FMC: add documentation for the core
      FMC: add a software carrier driver
      FMC: add a software mezzanine driver
      FMC: add a driver to write mezzanine EEPROM
      FMC: add a char-device mezzanine driver

Alexander Shiyan (2):
      pcmcia: Remove ARCH_CLPS711X dependency
      Misc: sram: Remove unneeded check

Alexander Stein (1):
      w1: add family based automatic module loading

Andy Shevchenko (2):
      pch_phub: re-use native MAC address parser
      net: core: move mac_pton() to lib/net_utils.c

Arnd Bergmann (1):
      fmc: avoid readl/writel namespace conflict

Chanwoo Choi (1):
      extcon: Change permission 'state' sysfs entry (rw -> r)

Chen Gang (1):
      Drivers: Misc: tsl2250: fix warnings, unsigned long will never < 0

Dan Carpenter (2):
      FMC: NULL dereference on allocation failure
      FMC: fix error handling in probe() function

Emil Goode (1):
      uio: uio_pruss: Fix potential NULL pointer dereference

Ezequiel Garcia (1):
      drivers: memory: Introduce Marvell EBU Device Bus driver

Fabio Estevam (1):
      w1-gpio: Let device core handle pinctrl

Fabio Porcedda (1):
      pcmcia: at91_cf: use module_platform_driver_probe()

Frode Isaksen (1):
      mei: mei_cl_connect: don't multiply the timeout twice

Graeme Gregory (1):
      extcon: Palmas Extcon Driver

Greg Kroah-Hartman (5):
      Merge 3.10-rc3 into char-misc-next
      Merge 3.10-rc5 into char-misc-next
      Merge 3.10-rc6 into char-misc-next
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
      Revert "char: misc: assign file->private_data in all cases"

H Hartley Sweeten (14):
      misc/ep93xx_pwm: use managed device resources
      misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
      misc/ep93xx_pwm: remove ep93xx_pwm_{write,read}l() inline functions
      misc/ep93xx_pwm: remove ep93xx_pwm_write_tc() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_write_dc() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_enable() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_disable() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_invert() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_normal() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_read_tc() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_is_enabled() inline function
      misc/ep93xx_pwm: remove ep93xx_pwm_is_inverted() inline function
      misc/ep93xx_pwm: use module_platform_driver()
      misc/ep93xx_pwm: use kstrtol instead of strict_strtol

Jason Wang (3):
      drivers: hv: switch to use mb() instead of smp_mb()
      drivers: hv: check interrupt mask before read_index
      drivers: hv: allocate synic structures before hv_synic_init()

Jingoo Han (4):
      misc: arm-charlcd: remove unnecessary platform_set_drvdata()
      misc: ep93xx_pwm: remove unnecessary platform_set_drvdata()
      misc: use platform_{get,set}_drvdata()
      misc: replace strict_strtoul() with kstrtoul()

Joachim Eastwood (5):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
      pcmcia: at91_cf: convert to dev_ print functions
      pcmcia: at91_cf: use devm_ functions for allocations
      pcmcia: at91_cf: clean up header includes
      pcmcia: at91_cf: add support for DT

Joe Perches (1):
      char: Convert use of typedef ctl_table to struct ctl_table

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Implement multi-channel support
      Drivers: hv: Add the GUID fot synthetic fibre channel device

Kishon Vijay Abraham I (1):
      extcon: add EXPORT_SYMBOL_GPL for exported functions

Laurent Navet (2):
      drivers: misc: use devm_ioremap_resource()
      pcmcia/trivial: at91_cf: fix checkpatch error

Libin (1):
      char: Use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

Martyn Welch (4):
      vme: Free DMA resource allocation structure
      vme: tsi148: Only store VME bus errors if they will be checked
      vme: tsi148: CR/CSR logic arround the wrong way
      vme: tsi148: Window reserved for accessing CR/CSR does not need attributes set

Michal Simek (2):
      char: xilinx_hwicap: Checkpatch.pl cleanup
      char: xilinx_hwicap: Fix typo in comment and extend it

Nikolay Balandin (2):
      drivers/misc: at24: convert to use devm_kzalloc
      drivers/misc: at25: convert to use devm_kzalloc

Pavel Machek (2):
      UIO: allow binding uio_pdrv_genirq.c to devices using command line option
      UIO: fix uio_pdrv_genirq with device tree but no interrupt

Peter Huewe (5):
      uio/uio_aec: Use module_pci_driver to register driver
      uio/uio_sercos3: Use module_pci_driver to register driver
      uio/uio_netx: Use module_pci_driver to register driver
      uio/uio_cif: Use module_pci_driver to register driver
      uio/uio_pci_generic: Use module_pci_driver to register driver

Rasmus Villemoes (1):
      drivers: char: mem: use IS_ERR_VALUE() in memory_lseek()

Sachin Kamat (2):
      drivers: uio_dmem_genirq: Use of_match_ptr() macro
      drivers: uio_pdrv_genirq: Use of_match_ptr() macro

Thomas Petazzoni (1):
      char: misc: assign file->private_data in all cases

Tomas Hozza (5):
      tools: hv: Check return value of setsockopt call
      tools: hv: Check return value of poll call
      tools: hv: Check retrun value of strchr call
      tools: hv: Fix file descriptor leaks
      tools: hv: Improve error logging in KVP daemon.

Tomas Winkler (11):
      mei: move mei_cl_complete to client.c
      mei: revamp interrupt thread handlers
      mei: fix out of array access to me clients array
      mei: deprecate the mei_wd_state_independence_msg
      mei: fix read after read scenario
      mei: me: remove artificial singleton requirement
      mei: support HBM versioning
      mei: move mei_cl_irq_write_complete to client.c
      mei: do not override a client writing state when buffering
      mei: check if the hardware reset succeeded
      mei: check whether hw start has succeeded

Tuomas Tynkkynen (2):
      memory: tegra20-mc: Fix hang in IRQ handler.
      memory: tegra30-mc: Fix IRQ handler.

Vitalii Demianets (1):
      UIO: Fix concurrency issue

Wei Yongjun (4):
      pcie-gadget-spear: fix error return code in spear_pcie_gadget_probe()
      pch_phub: fix error return code in pch_phub_probe()
      pcmcia: pd6729: fix error return code in pd6729_pci_probe()
      vme: vme_tsi148.c: fix error return code in tsi148_probe()

Wolfram Sang (1):
      drivers/misc: don't check resource with devm_ioremap_resource

 Documentation/00-INDEX                             |   2 +
 .../devicetree/bindings/ata/atmel-at91_cf.txt      |  19 ++
 .../devicetree/bindings/extcon/extcon-twl.txt      |  15 +
 .../bindings/memory-controllers/mvebu-devbus.txt   | 156 +++++++++
 Documentation/fmc/00-INDEX                         |  38 +++
 Documentation/fmc/API.txt                          |  47 +++
 Documentation/fmc/FMC-and-SDB.txt                  |  88 +++++
 Documentation/fmc/carrier.txt                      | 311 ++++++++++++++++++
 Documentation/fmc/fmc-chardev.txt                  |  64 ++++
 Documentation/fmc/fmc-fakedev.txt                  |  36 +++
 Documentation/fmc/fmc-trivial.txt                  |  17 +
 Documentation/fmc/fmc-write-eeprom.txt             | 125 ++++++++
 Documentation/fmc/identifiers.txt                  | 168 ++++++++++
 Documentation/fmc/mezzanine.txt                    | 123 +++++++
 Documentation/fmc/parameters.txt                   |  56 ++++
 Documentation/w1/w1.generic                        |   4 +-
 MAINTAINERS                                        |  10 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/char/hpet.c                                |   6 +-
 drivers/char/ipmi/ipmi_poweroff.c                  |   6 +-
 drivers/char/mem.c                                 |   2 +-
 drivers/char/mspec.c                               |   2 +-
 drivers/char/random.c                              |   8 +-
 drivers/char/rtc.c                                 |   6 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.h         |  10 +-
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-class.c                      |  25 +-
 drivers/extcon/extcon-palmas.c                     | 246 ++++++++++++++
 drivers/fmc/Kconfig                                |  51 +++
 drivers/fmc/Makefile                               |  13 +
 drivers/fmc/fmc-chardev.c                          | 202 ++++++++++++
 drivers/fmc/fmc-core.c                             | 296 +++++++++++++++++
 drivers/fmc/fmc-dump.c                             | 100 ++++++
 drivers/fmc/fmc-fakedev.c                          | 355 +++++++++++++++++++++
 drivers/fmc/fmc-match.c                            | 114 +++++++
 drivers/fmc/fmc-sdb.c                              | 266 +++++++++++++++
 drivers/fmc/fmc-trivial.c                          | 107 +++++++
 drivers/fmc/fmc-write-eeprom.c                     | 176 ++++++++++
 drivers/fmc/fru-parse.c                            |  82 +++++
 drivers/hv/channel.c                               |  50 ++-
 drivers/hv/channel_mgmt.c                          | 119 ++++++-
 drivers/hv/connection.c                            |  14 +
 drivers/hv/hv.c                                    |  85 +++--
 drivers/hv/hyperv_vmbus.h                          |   4 +
 drivers/hv/ring_buffer.c                           |  12 +-
 drivers/hv/vmbus_drv.c                             |  10 +-
 drivers/memory/Kconfig                             |  10 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/mvebu-devbus.c                      | 340 ++++++++++++++++++++
 drivers/memory/tegra20-mc.c                        |   5 +-
 drivers/memory/tegra30-mc.c                        |   9 +-
 drivers/misc/Kconfig                               |   1 +
 drivers/misc/ad525x_dpot.c                         |   2 +-
 drivers/misc/apds9802als.c                         |   5 +-
 drivers/misc/apds990x.c                            |  37 ++-
 drivers/misc/arm-charlcd.c                         |   5 +-
 drivers/misc/bh1770glc.c                           |  59 ++--
 drivers/misc/bh1780gli.c                           |   2 +-
 drivers/misc/carma/carma-fpga-program.c            |  14 +-
 drivers/misc/carma/carma-fpga.c                    |   8 +-
 drivers/misc/eeprom/at24.c                         |  44 +--
 drivers/misc/eeprom/at25.c                         |  25 +-
 drivers/misc/ep93xx_pwm.c                          | 188 +++--------
 drivers/misc/hmc6352.c                             |   5 +-
 drivers/misc/isl29003.c                            |  24 +-
 drivers/misc/isl29020.c                            |   6 +-
 drivers/misc/lis3lv02d/lis3lv02d.c                 |   6 +-
 drivers/misc/mei/amthif.c                          |   6 +-
 drivers/misc/mei/client.c                          |  92 +++++-
 drivers/misc/mei/client.h                          |   4 +
 drivers/misc/mei/hbm.c                             |  37 ++-
 drivers/misc/mei/hbm.h                             |   2 +-
 drivers/misc/mei/hw-me.c                           |   3 +-
 drivers/misc/mei/init.c                            |  18 +-
 drivers/misc/mei/interrupt.c                       | 205 ++++--------
 drivers/misc/mei/main.c                            |  49 +--
 drivers/misc/mei/mei_dev.h                         |  29 +-
 drivers/misc/mei/pci-me.c                          |  19 --
 drivers/misc/mei/wd.c                              |   6 -
 drivers/misc/pch_phub.c                            |  44 ++-
 drivers/misc/sgi-gru/gruprocfs.c                   |  14 +-
 drivers/misc/spear13xx_pcie_gadget.c               |  69 ++--
 drivers/misc/sram.c                                |   9 +-
 drivers/misc/ti-st/st_kim.c                        |   6 +-
 drivers/misc/ti_dac7512.c                          |   6 +-
 drivers/misc/tsl2550.c                             |   4 +-
 drivers/net/netconsole.c                           |   1 +
 drivers/pcmcia/Kconfig                             |   4 +-
 drivers/pcmcia/at91_cf.c                           | 176 +++++-----
 drivers/pcmcia/pd6729.c                            |   2 +
 drivers/uio/uio_aec.c                              |  14 +-
 drivers/uio/uio_cif.c                              |  14 +-
 drivers/uio/uio_dmem_genirq.c                      |   4 +-
 drivers/uio/uio_netx.c                             |  14 +-
 drivers/uio/uio_pci_generic.c                      |  17 +-
 drivers/uio/uio_pdrv_genirq.c                      |  54 ++--
 drivers/uio/uio_pruss.c                            |   2 +-
 drivers/uio/uio_sercos3.c                          |  14 +-
 drivers/vme/bridges/vme_tsi148.c                   |  45 +--
 drivers/vme/vme.c                                  |   2 +
 drivers/w1/masters/w1-gpio.c                       |   6 -
 drivers/w1/slaves/w1_ds2408.c                      |   1 +
 drivers/w1/slaves/w1_ds2413.c                      |   1 +
 drivers/w1/slaves/w1_ds2423.c                      |   1 +
 drivers/w1/slaves/w1_ds2431.c                      |   1 +
 drivers/w1/slaves/w1_ds2433.c                      |   1 +
 drivers/w1/slaves/w1_ds2760.c                      |   1 +
 drivers/w1/slaves/w1_ds2780.c                      |   1 +
 drivers/w1/slaves/w1_ds2781.c                      |   1 +
 drivers/w1/slaves/w1_ds28e04.c                     |   1 +
 drivers/w1/slaves/w1_smem.c                        |   2 +
 drivers/w1/slaves/w1_therm.c                       |   5 +
 drivers/w1/w1.c                                    |   2 +
 include/linux/fmc-sdb.h                            |  36 +++
 include/linux/fmc.h                                | 237 ++++++++++++++
 include/linux/hyperv.h                             |  70 ++++
 include/linux/if_ether.h                           |   1 -
 include/linux/ipmi-fru.h                           | 135 ++++++++
 include/linux/kernel.h                             |   2 +
 include/linux/mfd/palmas.h                         |  26 +-
 include/linux/sdb.h                                | 159 +++++++++
 lib/Kconfig                                        |   3 +
 lib/Makefile                                       |   2 +
 lib/net_utils.c                                    |  26 ++
 net/Kconfig                                        |   1 +
 net/core/netpoll.c                                 |   1 +
 net/core/utils.c                                   |  22 --
 tools/hv/hv_kvp_daemon.c                           |  58 +++-
 130 files changed, 5322 insertions(+), 919 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/atmel-at91_cf.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-twl.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/mvebu-devbus.txt
 create mode 100644 Documentation/fmc/00-INDEX
 create mode 100644 Documentation/fmc/API.txt
 create mode 100644 Documentation/fmc/FMC-and-SDB.txt
 create mode 100644 Documentation/fmc/carrier.txt
 create mode 100644 Documentation/fmc/fmc-chardev.txt
 create mode 100644 Documentation/fmc/fmc-fakedev.txt
 create mode 100644 Documentation/fmc/fmc-trivial.txt
 create mode 100644 Documentation/fmc/fmc-write-eeprom.txt
 create mode 100644 Documentation/fmc/identifiers.txt
 create mode 100644 Documentation/fmc/mezzanine.txt
 create mode 100644 Documentation/fmc/parameters.txt
 create mode 100644 drivers/extcon/extcon-palmas.c
 create mode 100644 drivers/fmc/Kconfig
 create mode 100644 drivers/fmc/Makefile
 create mode 100644 drivers/fmc/fmc-chardev.c
 create mode 100644 drivers/fmc/fmc-core.c
 create mode 100644 drivers/fmc/fmc-dump.c
 create mode 100644 drivers/fmc/fmc-fakedev.c
 create mode 100644 drivers/fmc/fmc-match.c
 create mode 100644 drivers/fmc/fmc-sdb.c
 create mode 100644 drivers/fmc/fmc-trivial.c
 create mode 100644 drivers/fmc/fmc-write-eeprom.c
 create mode 100644 drivers/fmc/fru-parse.c
 create mode 100644 drivers/memory/mvebu-devbus.c
 create mode 100644 include/linux/fmc-sdb.h
 create mode 100644 include/linux/fmc.h
 create mode 100644 include/linux/ipmi-fru.h
 create mode 100644 include/linux/sdb.h
 create mode 100644 lib/net_utils.c
