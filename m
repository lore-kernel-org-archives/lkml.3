Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaJGWdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaJGWdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:33:54 -0400
Date: Tue, 7 Oct 2014 15:33:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver patches for 3.18-rc1
Message-ID: <20141007223353.GA5630@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.18-rc1

for you to fetch changes up to 480bd3c4ad30558dd26c16e3f8358e36522d9af0:

  mei: mei_txe_fw_sts can be static (2014-09-29 18:21:46 -0700)

----------------------------------------------------------------
Char/Misc driver patches for 3.18-rc1

Here's the big set of driver patches for char/misc drivers.  Nothing
major in here, the shortlog below goes into the details.  All have been
in the linux-next tree for a while with no issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (11):
      mei: me: wait for hw ready non-interruptible
      mei: amthif: use service function to flush amthif queue
      mei: amthif: don't check amthif client identity on amthif queues
      mei: wait for hbm start non-interruptible
      mei: bus: fix possible boundaries violation
      mei: add hbm and pg state in devstate debugfs print
      mei: debugfs: adjust print buffer
      mei: trivial: fix errors in prints in comments
      mei: drop me_client_presentation_num
      mei: fix KDoc documentation formatting
      mei: fix kernel-doc warnings

Chanwoo Choi (6):
      extcon: sm5502: Fix bug to check cable type
      extcon: sm5502: Add I2C dependency to fix build break
      extcon: sm5502: Move sm5502.h header file to extcon directory
      extcon: sm5502: Clean up codes by using checkpatch script
      extcon: rt8973a: Add Richtek RT8973A extcon driver
      dt-bindings: extcon: Add support for Richtek RT8973A MUIC device

Dan Carpenter (1):
      VMCI: integer overflow in vmci_datagram_dispatch()

Eberhard S. Amann (1):
      GenWQE: Fix problem when reading HSI and Retc

Eli Billauer (1):
      documentation: devicetree: Added xillybus to vendor-prefixes

Federico Vaga (4):
      ipoctal: reset function istead of duplicate code
      ipack: save carrier owner to allow device to get it
      ipoctal: get carrier driver to avoid rmmod
      ipoctal: clear break interrupt as soon as it occurs

Fengguang Wu (1):
      mei: mei_txe_fw_sts can be static

Frank Haverkamp (7):
      GenWQE: Check pci_get_totalvfs return code
      GenWQE: Remove sysfs entry for driver version
      GenWQE: Update author information
      GenWQE: Do not modify return code of genwqe_set_interrupt_capability
      GenWQE: Check return code of pci_sriov_enable
      GenWQE: Fix checkpatch complaints
      GenWQE: Support blocking when DDCB queue is busy

George Cherian (1):
      extcon: gpio: Fix code cleanup

Greg Kroah-Hartman (1):
      Merge tag 'extcon-next-for-3.18' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Himangi Saraogi (2):
      EEPROM: Introduce the use of devm_kzalloc
      pcie-gadget-spear: use devm_ functions

Jean Delvare (1):
      extcon: sm5502: Drop useless include

Jonghwa Lee (1):
      extcon: max77693: Fix a bug occured at changing ADC debounce time.

K. Y. Srinivasan (9):
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
      Drivers: hv: vmbus: Cleanup hv_post_message()
      Drivers: hv: vmbus: Properly protect calls to smp_processor_id()
      Drivers: hv: util: Properly pack the data for file copy functionality
      Drivers: hv: vmbus: Enable interrupt driven flow control

Krzysztof Kozlowski (1):
      extcon: max77693: Use resource managed interrupt line

Lee Jones (2):
      misc: st_core: Protect unsigned value against becoming negative
      misc: st_kim: Increase size of dev_name buffer to incorporate termination

Matwey V. Kornilov (2):
      parport: parport_pc: Introduce intel_bug_present function.
      parport: parport_pc: Implement architecture and device check to cut off false-positives

Michal Simek (1):
      char: xilinx_hwicap: Remove .owner field for driver

Rasmus Villemoes (1):
      drivers/ipack/devices/ipoctal.h: Fix typo in include guard

Steven Honeyman (1):
      i8k: Add support for Dell Latitude E6540

Takashi Iwai (1):
      misc: lattice-ecp3-config: Add missing MODULE_FIRMWARE()

Tomas Winkler (25):
      mei: use consistently me_addr in the hbm structures
      mei: use wrapper for simple hbm client message
      mei: me_client lookup function to return me_client object
      mei: use list for me clients book keeping
      mei: add me client remove functions
      mei: add mei_me_cl_by_uuid_id function
      mei: add hbm commands return status values
      mei: use disconnect name consistently
      mei: revamp connect and disconnect response handling
      mei: simplify handling of hbm client events
      mei: extract supported features from the hbm version
      mei: enable adding more IOCTL handlers
      mei: use connect_data on the stack
      mei: debugfs: add single buffer indicator
      mei: pg: fix cat and paste error in comments
      mei: fix style warning: Missing a blank line after declarations
      mei: nfc: fix style warning
      mei: kill error message for allocation failure
      mei: move mei_hbm_hdr function from hbm.h the hbm.c
      mei: push all standard settings into mei_device_init
      mei: get rid of most of the pci dependencies in mei
      mei: move fw_status back to hw ops handlers
      mei: remove the reference to pdev from mei_device
      mei: push pci cfg structure me hw
      mei: remove include to pci header from mei module files

 .../devicetree/bindings/extcon/extcon-rt8973a.txt  |  25 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/char/i8k.c                                 |  13 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |   1 -
 drivers/extcon/Kconfig                             |  13 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-gpio.c                       |  10 +-
 drivers/extcon/extcon-max77693.c                   |  37 +-
 drivers/extcon/extcon-rt8973a.c                    | 740 +++++++++++++++++++++
 drivers/extcon/extcon-rt8973a.h                    | 203 ++++++
 drivers/extcon/extcon-sm5502.c                     |  20 +-
 .../sm5502.h => drivers/extcon/extcon-sm5502.h     |   5 -
 drivers/hv/channel.c                               |  56 +-
 drivers/hv/channel_mgmt.c                          |  21 +-
 drivers/hv/connection.c                            |  17 +-
 drivers/hv/hv.c                                    |  27 +-
 drivers/hv/hyperv_vmbus.h                          |   4 +
 drivers/hv/ring_buffer.c                           |   5 +
 drivers/ipack/carriers/tpci200.c                   |   3 +-
 drivers/ipack/devices/ipoctal.c                    |  69 +-
 drivers/ipack/devices/ipoctal.h                    |   2 +-
 drivers/ipack/ipack.c                              |   4 +-
 drivers/misc/eeprom/eeprom.c                       |  23 +-
 drivers/misc/genwqe/card_base.c                    |  38 +-
 drivers/misc/genwqe/card_base.h                    |  21 +-
 drivers/misc/genwqe/card_ddcb.c                    |  77 ++-
 drivers/misc/genwqe/card_ddcb.h                    |   2 +-
 drivers/misc/genwqe/card_debugfs.c                 |  10 +-
 drivers/misc/genwqe/card_dev.c                     |  21 +-
 drivers/misc/genwqe/card_sysfs.c                   |  11 +-
 drivers/misc/genwqe/card_utils.c                   |   7 +-
 drivers/misc/genwqe/genwqe_driver.h                |   4 +-
 drivers/misc/lattice-ecp3-config.c                 |   1 +
 drivers/misc/mei/amthif.c                          | 167 +++--
 drivers/misc/mei/bus.c                             |  25 +-
 drivers/misc/mei/client.c                          | 237 ++++---
 drivers/misc/mei/client.h                          |  17 +-
 drivers/misc/mei/debugfs.c                         |  70 +-
 drivers/misc/mei/hbm.c                             | 567 +++++++++-------
 drivers/misc/mei/hbm.h                             |  17 +-
 drivers/misc/mei/hw-me.c                           | 194 ++++--
 drivers/misc/mei/hw-me.h                           |  32 +-
 drivers/misc/mei/hw-txe.c                          | 252 ++++---
 drivers/misc/mei/hw-txe.h                          |   6 +-
 drivers/misc/mei/hw.h                              |  74 ++-
 drivers/misc/mei/init.c                            | 107 +--
 drivers/misc/mei/interrupt.c                       |  96 ++-
 drivers/misc/mei/main.c                            | 143 ++--
 drivers/misc/mei/mei_dev.h                         | 279 +++++---
 drivers/misc/mei/nfc.c                             |  77 +--
 drivers/misc/mei/pci-me.c                          |  14 +-
 drivers/misc/mei/pci-txe.c                         |  13 +-
 drivers/misc/mei/wd.c                              |  59 +-
 drivers/misc/spear13xx_pcie_gadget.c               |  98 +--
 drivers/misc/ti-st/st_core.c                       |  11 +-
 drivers/misc/vmw_vmci/vmci_datagram.c              |   3 +-
 drivers/parport/parport_pc.c                       |  54 +-
 include/linux/extcon/extcon-gpio.h                 |   4 +-
 include/linux/ipack.h                              |  24 +-
 include/linux/mei_cl_bus.h                         |   1 +
 include/linux/ti_wilink_st.h                       |   2 +-
 include/uapi/linux/genwqe/genwqe_card.h            |   2 +-
 include/uapi/linux/hyperv.h                        |   2 +-
 63 files changed, 2794 insertions(+), 1345 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
 create mode 100644 drivers/extcon/extcon-rt8973a.c
 create mode 100644 drivers/extcon/extcon-rt8973a.h
 rename include/linux/extcon/sm5502.h => drivers/extcon/extcon-sm5502.h (97%)
