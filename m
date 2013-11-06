Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3KFW63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:58:29 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44295 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3KFW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:19 -0500
Date: Wed, 6 Nov 2013 14:51:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.13-rc1
Message-ID: <20131106225112.GA8235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.13-rc1

for you to fetch changes up to 425792266a40189e0b3fec02cb59a69935d8c58c:

  misc: mic: Fixes for randconfig build errors and warnings. (2013-10-30 10:19:30 -0700)

----------------------------------------------------------------
Char/Misc patches for 3.13-rc1

Here's the big char/misc driver patchset for 3.13-rc1.

Lots of stuff in here, including some new drivers for Intel's "MIC"
co-processor devices, and a new eeprom driver.  Other things include the
driver attribute cleanups, extcon driver updates, hyperv updates, and a
raft of other miscellaneous driver fixes.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (6):
      mei: mei_write correct checks for copy_from_user
      mei: prefix client log messages with client me and host ids
      mei: fix function names in debug prints
      mei: move host_clients_map cleanup to device init
      mei: print correct device state during unexpected reset
      mei: replace stray pr_debug with dev_dbg

Ashutosh Dixit (4):
      Intel MIC Host Driver Changes for Virtio Devices.
      Intel MIC Card Driver Changes for Virtio Devices.
      misc: mic: cleanups for "--strict" checkpatch.
      misc: mic: Fixes for randconfig build errors and warnings.

Ben Hutchings (1):
      uio: Pass pointers to virt_to_page(), not integers

Caz Yokoyama (1):
      Sample Implementation of Intel MIC User Space Daemon.

Chanwoo Choi (6):
      extcon: Fix up 80 column coding style issues
      extcon: class: Remove unnecessary extern declaration
      extcon: arizona: Fix up minor coding style to remove unnecessary braces
      extcon: Fix indentation coding style to improve readability
      extcon: Change field type of 'dev' in extcon_dev structure
      extcon: Simplify extcon_dev_register() prototype by removing unnecessary parameter

Charles Keepax (3):
      extcon: arizona: Clear trig_sts bits on all paths
      extcon: arizona: Correct typo in headphone detect range transitions
      extcon: arizona: Don't require micbias to be shifted in pdata

Chen Gang (1):
      drivers: misc: bmp085: remove '__init' from mp085_get_of_properties()

Cong Ding (1):
      uio: fix memory leak

Dan Carpenter (1):
      hv: vmbus: fix vmbus_recvpacket_raw() return code

Daniel Mack (4):
      drivers: misc: ti_dac7512: drop module version
      drivers: misc: ti_dac7512: drop DAC7512_DRV_NAME
      drivers: misc: ti_dac7512: provide a SPI ID table
      drivers: misc: ti_dac7512: add support for DT matching

Dasaratharaman Chandramouli (2):
      Intel MIC Host Driver Interrupt/SMPT support.
      misc: mic: Enable OSPM suspend and resume support.

Elad Wexler (1):
      Drivers: char: misc: 'misc_deregister()' changed the 'mutex_unlock' logic upon an error

Felipe Pena (1):
      drivers: hv: Fix wrong check for synic_event_page

Fengguang Wu (1):
      drivers: uio: mf624_disable_interrupt() can be static

Greg Kroah-Hartman (16):
      hv: use dev_groups for device attributes
      hv: move "state" bus attribute to dev_groups
      hv: move "monitor_id" bus attribute to dev_groups
      hv: move "modalias" bus attribute to dev_groups
      hv: move "class_id" bus attribute to dev_groups
      hv: move "device_id" bus attribute to dev_groups
      hv: make "monitor_pages" a "real" pointer array
      hv: move "client/server_monitor_pending" bus attributes to dev_groups
      hv: move "client/server_monitor_latency" bus attributes to dev_groups
      hv: move "client/server_monitor_conn_id" bus attributes to dev_groups
      hv: delete vmbus_get_debug_info()
      hv: delete struct hv_dev_port_info
      hv: move ringbuffer bus attributes to dev_groups
      Merge tag 'extcon-next-for-3.13' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next
      Merge 3.12-rc3 into char-misc-next
      Merge 3.12-rc6 into char-misc-next

Guenter Roeck (3):
      extcon: gpio: Do not unnecessarily initialize variables
      extcon: gpio: Use gpio driver/chip debounce if supported
      extcon: gpio: Add support for active-low presence to detect pins

Jan Kara (1):
      vmw_vmci: Convert driver to use get_user_pages_fast()

Jan Luebbe (1):
      misc/at25, dt: support probing at25 SPI EEPROM from DT

Jingoo Han (13):
      uio: uio_aec: remove unnecessary pci_set_drvdata()
      uio: uio_cif: remove unnecessary pci_set_drvdata()
      uio: uio_mf624: remove unnecessary pci_set_drvdata()
      uio: uio_netx: remove unnecessary pci_set_drvdata()
      uio: uio_sercos3: remove unnecessary pci_set_drvdata()
      char: xilinx_hwicap: Remove casting the return value which is a void pointer
      misc: ibmasm: Remove casting the return value which is a void pointer
      misc: tifm: remove unnecessary pci_set_drvdata()
      misc: ibmasm: remove unnecessary pci_set_drvdata()
      misc: mei: remove unnecessary pci_set_drvdata()
      misc: pti: remove unnecessary pci_set_drvdata()
      extcon: Remove casting the return value which is a void pointer
      extcon: use dev_get_platdata()

Johan Hovold (1):
      misc: atmel_pwm: add deferred-probing support

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in channel rescind code

Kees Cook (3):
      lkdtm: isolate stack corruption test
      lkdtm: adjust recursion size to avoid warnings
      lkdtm: add tests for additional page permissions

Libo Chen (2):
      drivers/pcmcia/pd6729.c: convert to module_pci_driver
      drivers/pcmcia/yenta_socket.c: convert to module_pci_driver

Linus Walleij (1):
      misc: bh1780: probe from compatible string

Markus Pargmann (2):
      w1-gpio: Detect of_gpio_error for first gpio
      w1-gpio: Use devm_* functions

Michael Opdenacker (7):
      hpet: remove deprecated IRQF_DISABLED
      various char drivers: remove deprecated IRQF_DISABLED
      tlclk: remove deprecated IRQF_DISABLED
      misc: arm-charlcd: remove deprecated IRQF_DISABLED
      misc: phantom: remove deprecated IRQF_DISABLED
      w1: ds1wm: remove deprecated IRQF_DISABLED
      w1: omap-hdq: remove deprecated IRQF_DISABLED

Michal Simek (2):
      uio: Simplify uio error path by using devres functions
      char: hwicap: Remove unnecessary dev_set_drvdata()

Olaf Hering (2):
      Tools: hv: cache FQDN in kvp_daemon to avoid timeouts
      Tools: hv: use single send+recv buffer

Oliver Schinagl (1):
      ARM: sunxi: Initial support for Allwinner's Security ID fuses

Paul Bolle (1):
      mei: me: downgrade two errors to debug level

Peter Senna Tschudin (1):
      hv: Change variable type to bool

Sachin Kamat (3):
      extcon: max8997: Fix checkpatch warning
      extcon: arizona: Fix a typo in a comment
      extcon: max77693: Fix checkpatch warning

Sudeep Dutt (8):
      Intel MIC Host Driver for X100 family.
      Intel MIC Host Driver, card OS state management.
      Intel MIC Card Driver for X100 family.
      misc: mic: host driver sysfs cleanups.
      misc: mic: header file cleanups.
      misc: mic: fix a warning in the IOCTL header file.
      misc: mic: depend on X86 for both host and card drivers.
      misc: mic: Fix build issues in sample daemon.

Tomas Winkler (17):
      mei: mei_cl_link protect open_handle_count from overflow
      mei: make sure that me_clients_map big enough before copying
      mei: fix format compilation warrning on 32 bit architecture
      mei: revamp read and write length checks
      mei: mei_release: drop redundant check if cb is NULL
      mei: propagate error from write routines instead of ENODEV
      mei: push credentials inside the irq write handler
      mei: mei_cl_unlink: no need to loop over dev list
      hpet: remove useless check if fixmem32 is NULL
      mei: simplify mei_open error handling
      mei: revamp open handler counts
      mei: amthif: mei_amthif_host_init: propagate errors from called functions
      mei: me: add Lynx Point Wellsburg work station device id
      mei: nfc: fix memory leak in error path
      mei: mei_cl_link remove duplicated check for open_handle_count
      mei: bus: propagate error code returned by mei_me_cl_by_id
      mei: wd: host_init propagate error codes from called functions

Vladimir Zapolskiy (2):
      misc/93xx46: avoid infinite loop on write()
      misc/at24: avoid infinite loop on write()

Wei Yongjun (3):
      VMCI: fix to pass correct device identity to free_irq()
      mmc: cb710: drop free_irq for devm_request_irq allocated irq
      tifm: fix error return code in tifm_7xx1_probe()

 Documentation/ABI/testing/sysfs-class-mic.txt      |  157 ++
 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |   22 +
 .../bindings/misc/allwinner,sunxi-sid.txt          |   17 +
 .../devicetree/bindings/misc/ti,dac7512.txt        |   20 +
 Documentation/extcon/porting-android-switch-class  |    6 +-
 Documentation/mic/mic_overview.txt                 |   51 +
 Documentation/mic/mpssd/.gitignore                 |    1 +
 Documentation/mic/mpssd/Makefile                   |   19 +
 Documentation/mic/mpssd/micctrl                    |  173 ++
 Documentation/mic/mpssd/mpss                       |  202 +++
 Documentation/mic/mpssd/mpssd.c                    | 1721 ++++++++++++++++++++
 Documentation/mic/mpssd/mpssd.h                    |  102 ++
 Documentation/mic/mpssd/sysfs.c                    |  102 ++
 drivers/char/hpet.c                                |    5 +-
 drivers/char/misc.c                                |    8 +-
 drivers/char/nwbutton.c                            |    2 +-
 drivers/char/rtc.c                                 |    5 +-
 drivers/char/snsc.c                                |    3 +-
 drivers/char/snsc_event.c                          |    3 +-
 drivers/char/tlclk.c                               |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    3 +-
 drivers/extcon/extcon-adc-jack.c                   |   27 +-
 drivers/extcon/extcon-arizona.c                    |   55 +-
 drivers/extcon/extcon-class.c                      |  102 +-
 drivers/extcon/extcon-gpio.c                       |   19 +-
 drivers/extcon/extcon-max77693.c                   |  136 +-
 drivers/extcon/extcon-max8997.c                    |   11 +-
 drivers/extcon/extcon-palmas.c                     |    5 +-
 drivers/hv/channel.c                               |   50 +-
 drivers/hv/channel_mgmt.c                          |    5 +-
 drivers/hv/connection.c                            |   21 +-
 drivers/hv/hv.c                                    |    2 +-
 drivers/hv/hv_util.c                               |    2 +-
 drivers/hv/hyperv_vmbus.h                          |    9 +-
 drivers/hv/vmbus_drv.c                             |  488 ++++--
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/arm-charlcd.c                         |    2 +-
 drivers/misc/atmel_pwm.c                           |    6 +-
 drivers/misc/bh1780gli.c                           |   11 +
 drivers/misc/bmp085.c                              |    2 +-
 drivers/misc/cb710/core.c                          |    2 +-
 drivers/misc/eeprom/Kconfig                        |   13 +
 drivers/misc/eeprom/Makefile                       |    1 +
 drivers/misc/eeprom/at24.c                         |    3 +
 drivers/misc/eeprom/at25.c                         |    7 +
 drivers/misc/eeprom/eeprom_93xx46.c                |    2 +-
 drivers/misc/eeprom/sunxi_sid.c                    |  158 ++
 drivers/misc/ibmasm/module.c                       |    4 +-
 drivers/misc/lkdtm.c                               |  107 +-
 drivers/misc/mei/amthif.c                          |   49 +-
 drivers/misc/mei/bus.c                             |    2 +-
 drivers/misc/mei/client.c                          |  129 +-
 drivers/misc/mei/client.h                          |    9 +
 drivers/misc/mei/hbm.c                             |    9 +-
 drivers/misc/mei/hw-me-regs.h                      |    1 +
 drivers/misc/mei/init.c                            |   21 +-
 drivers/misc/mei/interrupt.c                       |   47 +-
 drivers/misc/mei/main.c                            |   65 +-
 drivers/misc/mei/mei_dev.h                         |    1 +
 drivers/misc/mei/nfc.c                             |   10 +-
 drivers/misc/mei/pci-me.c                          |    8 +-
 drivers/misc/mei/wd.c                              |   12 +-
 drivers/misc/mic/Kconfig                           |   39 +
 drivers/misc/mic/Makefile                          |    6 +
 drivers/misc/mic/card/Makefile                     |   11 +
 drivers/misc/mic/card/mic_debugfs.c                |  130 ++
 drivers/misc/mic/card/mic_device.c                 |  305 ++++
 drivers/misc/mic/card/mic_device.h                 |  133 ++
 drivers/misc/mic/card/mic_virtio.c                 |  630 +++++++
 drivers/misc/mic/card/mic_virtio.h                 |   77 +
 drivers/misc/mic/card/mic_x100.c                   |  256 +++
 drivers/misc/mic/card/mic_x100.h                   |   48 +
 drivers/misc/mic/common/mic_dev.h                  |   51 +
 drivers/misc/mic/host/Makefile                     |   14 +
 drivers/misc/mic/host/mic_boot.c                   |  300 ++++
 drivers/misc/mic/host/mic_debugfs.c                |  491 ++++++
 drivers/misc/mic/host/mic_device.h                 |  203 +++
 drivers/misc/mic/host/mic_fops.c                   |  222 +++
 drivers/misc/mic/host/mic_fops.h                   |   32 +
 drivers/misc/mic/host/mic_intr.c                   |  630 +++++++
 drivers/misc/mic/host/mic_intr.h                   |  137 ++
 drivers/misc/mic/host/mic_main.c                   |  537 ++++++
 drivers/misc/mic/host/mic_smpt.c                   |  442 +++++
 drivers/misc/mic/host/mic_smpt.h                   |   98 ++
 drivers/misc/mic/host/mic_sysfs.c                  |  459 ++++++
 drivers/misc/mic/host/mic_virtio.c                 |  700 ++++++++
 drivers/misc/mic/host/mic_virtio.h                 |  138 ++
 drivers/misc/mic/host/mic_x100.c                   |  570 +++++++
 drivers/misc/mic/host/mic_x100.h                   |   98 ++
 drivers/misc/phantom.c                             |    2 +-
 drivers/misc/pti.c                                 |    1 -
 drivers/misc/ti_dac7512.c                          |   23 +-
 drivers/misc/tifm_7xx1.c                           |    7 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |    2 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |    6 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   21 +-
 drivers/pcmcia/pd6729.c                            |   13 +-
 drivers/pcmcia/yenta_socket.c                      |   16 +-
 drivers/uio/uio.c                                  |   38 +-
 drivers/uio/uio_aec.c                              |    1 -
 drivers/uio/uio_cif.c                              |    1 -
 drivers/uio/uio_mf624.c                            |    5 +-
 drivers/uio/uio_netx.c                             |    1 -
 drivers/uio/uio_pdrv_genirq.c                      |   34 +-
 drivers/uio/uio_sercos3.c                          |    1 -
 drivers/w1/masters/ds1wm.c                         |    2 +-
 drivers/w1/masters/omap_hdq.c                      |    3 +-
 drivers/w1/masters/w1-gpio.c                       |   35 +-
 include/linux/extcon.h                             |   72 +-
 include/linux/extcon/extcon-adc-jack.h             |   42 +-
 include/linux/extcon/extcon-gpio.h                 |   20 +-
 include/linux/hyperv.h                             |   37 -
 include/uapi/linux/Kbuild                          |    2 +
 include/uapi/linux/mic_common.h                    |  240 +++
 include/uapi/linux/mic_ioctl.h                     |   76 +
 tools/hv/hv_kvp_daemon.c                           |   29 +-
 tools/hv/hv_vss_daemon.c                           |    8 +-
 118 files changed, 10904 insertions(+), 830 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mic.txt
 create mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 Documentation/devicetree/bindings/misc/ti,dac7512.txt
 create mode 100644 Documentation/mic/mic_overview.txt
 create mode 100644 Documentation/mic/mpssd/.gitignore
 create mode 100644 Documentation/mic/mpssd/Makefile
 create mode 100755 Documentation/mic/mpssd/micctrl
 create mode 100755 Documentation/mic/mpssd/mpss
 create mode 100644 Documentation/mic/mpssd/mpssd.c
 create mode 100644 Documentation/mic/mpssd/mpssd.h
 create mode 100644 Documentation/mic/mpssd/sysfs.c
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c
 create mode 100644 drivers/misc/mic/Kconfig
 create mode 100644 drivers/misc/mic/Makefile
 create mode 100644 drivers/misc/mic/card/Makefile
 create mode 100644 drivers/misc/mic/card/mic_debugfs.c
 create mode 100644 drivers/misc/mic/card/mic_device.c
 create mode 100644 drivers/misc/mic/card/mic_device.h
 create mode 100644 drivers/misc/mic/card/mic_virtio.c
 create mode 100644 drivers/misc/mic/card/mic_virtio.h
 create mode 100644 drivers/misc/mic/card/mic_x100.c
 create mode 100644 drivers/misc/mic/card/mic_x100.h
 create mode 100644 drivers/misc/mic/common/mic_dev.h
 create mode 100644 drivers/misc/mic/host/Makefile
 create mode 100644 drivers/misc/mic/host/mic_boot.c
 create mode 100644 drivers/misc/mic/host/mic_debugfs.c
 create mode 100644 drivers/misc/mic/host/mic_device.h
 create mode 100644 drivers/misc/mic/host/mic_fops.c
 create mode 100644 drivers/misc/mic/host/mic_fops.h
 create mode 100644 drivers/misc/mic/host/mic_intr.c
 create mode 100644 drivers/misc/mic/host/mic_intr.h
 create mode 100644 drivers/misc/mic/host/mic_main.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.h
 create mode 100644 drivers/misc/mic/host/mic_sysfs.c
 create mode 100644 drivers/misc/mic/host/mic_virtio.c
 create mode 100644 drivers/misc/mic/host/mic_virtio.h
 create mode 100644 drivers/misc/mic/host/mic_x100.c
 create mode 100644 drivers/misc/mic/host/mic_x100.h
 create mode 100644 include/uapi/linux/mic_common.h
 create mode 100644 include/uapi/linux/mic_ioctl.h
