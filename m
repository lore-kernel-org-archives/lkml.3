Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaFCFoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:44:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaFCFoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:44:38 -0400
Date: Mon, 2 Jun 2014 22:44:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver patches for 3.16-rc1
Message-ID: <20140603054434.GB2921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.16-rc1

for you to fetch changes up to a100d88df1e924e5c9678fabf054d1bae7ab74fb:

  hv: use correct order when freeing monitor_pages (2014-05-28 13:45:15 -0700)

----------------------------------------------------------------
Char / misc driver patches for 3.16-rc1

Here is the big char / misc driver updates for 3.16-rc1.

Lots of different driver updates for a variety of different drivers and
minor driver subsystems.

All have been in linux-next with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (6):
      mei: txe: add runtime pm framework
      mei: txe: use runtime PG pm domain for non wakeable devices
      mei: extract fw status registers
      mei: make return values consistent across the driver
      mei: set connecting state just upon connection request is sent to the fw
      mei: add per device configuration

Alexey Khoroshilov (1):
      w1: do not unlock unheld list_mutex in __w1_remove_master_device()

Arnd Bergmann (1):
      misc: atmel_pwm: only build for supported platforms

Bin Wang (1):
      uio: fix vma io range check in mmap

Chanwoo Choi (11):
      extcon: max14577: Change extcon name instead of static name according to device type
      Merge tag 'ib-mfd-extcon-3.16' of git://git.kernel.org/.../lee/mfd into HEAD
      extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
      extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
      extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
      extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
      extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
      extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
      extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
      extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
      extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev

Christian Engelmayer (1):
      misc: genwqe: fix uninitialized return value in genwqe_free_sync_sgl()

Daeseok Youn (1):
      drivers: uio_dmem_genirq: Fix memory leak in uio_dmem_genirq_probe()

Dan Carpenter (1):
      applicom: dereferencing NULL on error path

David Fries (2):
      connector: allow multiple messages to be sent in one packet
      w1: optional bundling of netlink kernel replies

Geert Uytterhoeven (1):
      drivers: Remove duplicate conditionally included subdirs

Greg Kroah-Hartman (1):
      Merge tag 'extcon-next-for-3.16' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Jean Delvare (2):
      misc: Add hardware dependencies to Atmel drivers
      misc: pch_phub: Fix Kconfig dependencies

Johannes Thumshirn (1):
      mcb: Add support for shared PCI IRQs

Josh Cartwright (1):
      spmi: of: fixup generic SPMI devicetree binding example

K. Y. Srinivasan (3):
      Drivers: hv: Eliminate the channel spinlock in the callback path
      Drivers: hv: vmbus: Implement per-CPU mapping of relid to channel
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kishon Vijay Abraham I (1):
      extcon: palmas: explicitly set edev name as node name

Krzysztof Kozlowski (14):
      mfd: max14577: Add muic prefix to regmap config
      mfd: max14577: Add detection of device type
      extcon: max14577: Add max14577 prefix to muic_irqs
      extcon: max14577: Choose muic_irqs according to device type
      mfd: max14577: Add MAX14577 prefix to IRQ defines
      mfd: max77836: Add MAX77836 support to max14577 driver
      extcon: max14577: Add support for MAX77836
      regulator: max14577: Add support for MAX77836 regulators
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata
      extcon: max8997: Fix NULL pointer exception on missing pdata
      extcon: max77693: Use power efficient workqueue for delayed cable detection
      extcon: max8997: Use power efficient workqueue for delayed cable detection
      extcon: max14577: Fix probe failure on successful work queue
      extcon: max14577: Properly handle regmap_irq_get_virq error

Masanari Iida (1):
      misc: genwqe: Fix format string mismatch in card_debugfs.c

Radim Krčmář (1):
      hv: use correct order when freeing monitor_pages

Rob Herring (2):
      dt/bindings: add binding for ARM Versatile character LCD
      misc: arm-charlcd: add DT probe support

Robert P. J. Day (2):
      MAINTAINERS: Add miscdevice.h to file list for char/misc drivers.
      miscdevice.h: Simple syntax fix to make pointers consistent.

Sangjung Woo (8):
      extcon: Add resource-managed extcon register function
      extcon: adc-jack: Use devm_extcon_dev_register()
      extcon: gpio: Use devm_extcon_dev_register()
      extcon: max14577: Use devm_extcon_dev_register()
      extcon: max77693: Use devm_extcon_dev_register()
      extcon: max8997: Use devm_extcon_dev_register()
      extcon: palmas: Use devm_extcon_dev_register()
      extcon: arizona: Use devm_extcon_dev_register()

Sebastien Bourdelin (1):
      misc: (ds1682) replace obsolete simple_strtoull() with kstrtoull()

Tobias Klauser (1):
      hv: Remove unnecessary comparison of unsigned against 0

Tomas Winkler (16):
      mei: implement power gating isolation hbm layer
      mei: me: introduce power gating registers
      mei: me: add power gating isolation register write wrappers
      mei: condition PGI support on HW and HBM version
      mei: expose hardware power gating state to mei layer
      mei: me: add pg exit and entry flow commands
      mei: add function to check write queues
      mei: me: add runtime pm framework
      mei: use runtime pm in write and read flow
      mei: me: use runtime PG pm domain for non wakeable devices
      mei: me: bump hbm version to 1.1 to support power gating
      mei: fix memory leak of mei_clients array
      mei: me: fix hw ready reset flow
      mei: me: drop harmful wait optimization
      mei: me: read H_CSR after asserting reset
      mei: me: move probe quirk to cfg structure

 Documentation/connector/connector.txt              |  15 +-
 .../devicetree/bindings/misc/arm-charlcd.txt       |  18 +
 Documentation/devicetree/bindings/spmi/spmi.txt    |   2 +-
 Documentation/w1/w1.generic                        |   2 +-
 Documentation/w1/w1.netlink                        |  13 +-
 MAINTAINERS                                        |   1 +
 drivers/Makefile                                   |   2 -
 drivers/char/applicom.c                            |   1 -
 drivers/connector/connector.c                      |  17 +-
 drivers/extcon/Kconfig                             |   4 +-
 drivers/extcon/extcon-adc-jack.c                   |  49 +-
 drivers/extcon/extcon-arizona.c                    |  40 +-
 drivers/extcon/extcon-class.c                      | 151 +++++
 drivers/extcon/extcon-gpio.c                       |  37 +-
 drivers/extcon/extcon-max14577.c                   | 199 +++++--
 drivers/extcon/extcon-max77693.c                   |  23 +-
 drivers/extcon/extcon-max8997.c                    |  16 +-
 drivers/extcon/extcon-palmas.c                     |  41 +-
 drivers/hv/channel.c                               |  19 +-
 drivers/hv/channel_mgmt.c                          |  52 +-
 drivers/hv/connection.c                            |  39 +-
 drivers/hv/hv.c                                    |   2 +
 drivers/hv/hv_balloon.c                            |  29 +-
 drivers/hv/hyperv_vmbus.h                          |   5 +
 drivers/mcb/mcb-core.c                             |  20 +-
 drivers/mcb/mcb-pci.c                              |  17 +-
 drivers/mfd/Kconfig                                |   6 +-
 drivers/mfd/max14577.c                             | 315 ++++++++--
 drivers/misc/Kconfig                               |   5 +-
 drivers/misc/arm-charlcd.c                         |   7 +
 drivers/misc/ds1682.c                              |   5 +-
 drivers/misc/genwqe/card_debugfs.c                 |   4 +-
 drivers/misc/genwqe/card_utils.c                   |   2 +-
 drivers/misc/mei/amthif.c                          |   2 -
 drivers/misc/mei/bus.c                             |   4 +-
 drivers/misc/mei/client.c                          |  90 ++-
 drivers/misc/mei/hbm.c                             |  97 ++-
 drivers/misc/mei/hbm.h                             |   2 +
 drivers/misc/mei/hw-me-regs.h                      |   9 +
 drivers/misc/mei/hw-me.c                           | 322 +++++++++-
 drivers/misc/mei/hw-me.h                           |  15 +-
 drivers/misc/mei/hw-txe-regs.h                     |   2 +-
 drivers/misc/mei/hw-txe.c                          | 111 +++-
 drivers/misc/mei/hw-txe.h                          |  21 +-
 drivers/misc/mei/hw.h                              |  25 +-
 drivers/misc/mei/init.c                            |  60 +-
 drivers/misc/mei/main.c                            |   1 -
 drivers/misc/mei/mei_dev.h                         | 101 +++-
 drivers/misc/mei/pci-me.c                          | 256 +++++---
 drivers/misc/mei/pci-txe.c                         | 155 ++++-
 drivers/misc/mei/wd.c                              |   2 -
 drivers/regulator/Kconfig                          |   7 +-
 drivers/regulator/max14577.c                       | 277 +++++++--
 drivers/uio/uio.c                                  |   2 +-
 drivers/uio/uio_dmem_genirq.c                      |   4 +-
 drivers/w1/w1.c                                    |   2 +
 drivers/w1/w1.h                                    |   8 -
 drivers/w1/w1_int.c                                |   4 +
 drivers/w1/w1_netlink.c                            | 649 +++++++++++++--------
 drivers/w1/w1_netlink.h                            |  36 ++
 include/linux/connector.h                          |   1 +
 include/linux/extcon.h                             |  37 ++
 include/linux/hyperv.h                             |   7 +
 include/linux/mcb.h                                |   6 +-
 include/linux/mfd/max14577-private.h               | 222 +++++--
 include/linux/mfd/max14577.h                       |  19 +-
 include/linux/mfd/palmas.h                         |   2 +-
 include/linux/miscdevice.h                         |   2 +-
 68 files changed, 2931 insertions(+), 787 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/arm-charlcd.txt
