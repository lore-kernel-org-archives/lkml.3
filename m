Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaH2RnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:43:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaH2RnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:43:02 -0400
Date: Fri, 29 Aug 2014 10:43:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.17-rc3
Message-ID: <20140829174302.GA7272@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.17-rc3

for you to fetch changes up to a9ef803d740bfadf5e505fbc57efa57692e27025:

  USB: fix build error with CONFIG_PM_RUNTIME disabled (2014-08-27 16:55:29 -0700)

----------------------------------------------------------------
USB fixes for 3.17-rc3

Here are a bunch of fixes for the USB drivers for 3.17-rc3.

Also in here is the movement of the usbip driver out of staging, into
the "real" part of the kernel, it had to wait until after -rc1 to handle
the merge issues involved between the USB and staging trees.  The code
is identical, just file movements there.

The USB fixes are all over the place, new device ids, xhci fixes for
reported issues and the usual gadget driver fixes as well.  All have
been in linux-next for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      usb: dbgp gadget: fix use after free in dbgp_unbind()

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Bo Shen (1):
      usb: atmel_usba_udc: fix it to deal with final dma channel

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Bryan O'Donoghue (1):
      usb: pch_udc: usb gadget device support for Intel Quark X1000

Dan Carpenter (1):
      usb: dwc3: omap: signedness bug in dwc3_omap_set_utmi_mode()

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Greg Kroah-Hartman (4):
      Merge tag 'usb-serial-3.17-rc2' of git://git.kernel.org/.../johan/usb-serial into work-linus
      Merge tag 'fixes-for-v3.17-rc2' of git://git.kernel.org/.../balbi/usb into work-linus
      Revert "usb: ehci/ohci-exynos: Fix PHY getting sequence"
      USB: fix build error with CONFIG_PM_RUNTIME disabled

Hans Wennborg (1):
      usb: musb: ux500: fix decimal printf format specifiers prefixed with 0x

Hans de Goede (2):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
      xhci: Disable streams on Via XHCI with device-id 0x3432

Himangi Saraogi (1):
      usb: phy: drop kfree of devm_kzalloc's data

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jaša Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jingoo Han (2):
      usb: phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH
      usb: dwc2: gadget: Set the default EP max packet value as 8 bytes

Johan Hovold (7):
      USB: option: reduce interrupt-urb logging verbosity
      Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"
      USB: zte_ev: remove duplicate Gobi PID
      USB: zte_ev: remove duplicate Qualcom PID
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow

Julia Lawall (1):
      usb: gadget: fix error return code

Li RongQing (1):
      Revert "usb: gadget: u_ether: synchronize with transmit when stopping queue"

Mark (1):
      USB: storage: add quirk for Newer Technology uSCSI SCSI-USB converter

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers

Michael Grzeschik (1):
      usb: gadget: uvc: fix possible lockup in uvc gadget

Peter Chen (4):
      usb: dwc2: gadget: fix below build warning
      usb: core: fix below build warning
      usb: wusbcore: fix below build warning
      usb: ehci: using wIndex + 1 for hub port

Philippe Reynes (1):
      usb: gadget: remove $(PWD) in ccflags-y

Roger Quadros (1):
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Takashi Iwai (1):
      usbcore: Fix wrong device in an error message in hub_port_connect()

Valentina Manea (4):
      usbip: move usbip userspace code out of staging
      usbip: move usbip kernel code out of staging
      usbip: remove struct usb_device_id table
      MAINTAINERS: Add an entry for USB/IP driver

Vivek Gautam (1):
      usb: ehci/ohci-exynos: Fix PHY getting sequence

Wei Yongjun (3):
      usb: gadget: Fix return value check in ep_write()
      usb: gadget: Fix return value check in r8a66597_probe()
      usb: phy: msm: Fix return value check in msm_otg_probe()

 MAINTAINERS                                        |   8 ++
 drivers/staging/Kconfig                            |   2 -
 drivers/staging/Makefile                           |   1 -
 drivers/usb/Kconfig                                |   2 +
 drivers/usb/Makefile                               |   2 +
 drivers/usb/core/hub.c                             |  16 ++--
 drivers/usb/dwc2/gadget.c                          |   2 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/gadget/Makefile                        |   2 +-
 drivers/usb/gadget/function/Makefile               |   4 +-
 drivers/usb/gadget/function/u_ether.c              |   3 -
 drivers/usb/gadget/function/uvc_video.c            |   3 +
 drivers/usb/gadget/legacy/Makefile                 |   6 +-
 drivers/usb/gadget/legacy/dbgp.c                   |   2 +
 drivers/usb/gadget/legacy/inode.c                  |   2 +-
 drivers/usb/gadget/udc/Kconfig                     |   3 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   2 +-
 drivers/usb/gadget/udc/fusb300_udc.c               |   8 +-
 drivers/usb/gadget/udc/pch_udc.c                   |  22 ++++-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   4 +-
 drivers/usb/host/ehci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   9 ++
 drivers/usb/host/xhci-ring.c                       | 104 ++++++++-------------
 drivers/usb/host/xhci.c                            |   3 +
 drivers/usb/misc/sisusbvga/sisusb.c                |   1 +
 drivers/usb/musb/ux500_dma.c                       |   2 +-
 drivers/usb/phy/phy-gpio-vbus-usb.c                |   4 +-
 drivers/usb/phy/phy-msm-usb.c                      |   4 +-
 drivers/usb/phy/phy-samsung-usb.h                  |   2 +-
 drivers/usb/phy/phy.c                              |   3 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 ++
 drivers/usb/serial/option.c                        |  31 +++++-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/usb-serial.c                    |  37 ++++++--
 drivers/usb/serial/whiteheat.c                     |   7 +-
 drivers/usb/serial/zte_ev.c                        |  20 ----
 drivers/usb/storage/unusual_devs.h                 |   6 ++
 drivers/{staging => usb}/usbip/Kconfig             |   0
 drivers/{staging => usb}/usbip/Makefile            |   0
 drivers/{staging => usb}/usbip/README              |   0
 drivers/{staging => usb}/usbip/stub.h              |   0
 drivers/{staging => usb}/usbip/stub_dev.c          |  27 ------
 drivers/{staging => usb}/usbip/stub_main.c         |   0
 drivers/{staging => usb}/usbip/stub_rx.c           |   0
 drivers/{staging => usb}/usbip/stub_tx.c           |   0
 drivers/{staging => usb}/usbip/usbip_common.c      |   0
 drivers/{staging => usb}/usbip/usbip_common.h      |   2 +-
 drivers/{staging => usb}/usbip/usbip_event.c       |   0
 drivers/{staging => usb}/usbip/usbip_protocol.txt  |   0
 drivers/{staging => usb}/usbip/vhci.h              |   0
 drivers/{staging => usb}/usbip/vhci_hcd.c          |   0
 drivers/{staging => usb}/usbip/vhci_rx.c           |   0
 drivers/{staging => usb}/usbip/vhci_sysfs.c        |   0
 drivers/{staging => usb}/usbip/vhci_tx.c           |   0
 drivers/usb/wusbcore/wa-xfer.c                     |   3 +-
 .../usbip/uapi => include/uapi/linux}/usbip.h      |   0
 .../usbip/userspace => tools/usb/usbip}/.gitignore |   0
 .../usbip/userspace => tools/usb/usbip}/AUTHORS    |   0
 .../usbip/userspace => tools/usb/usbip}/COPYING    |   0
 .../usbip/userspace => tools/usb/usbip}/INSTALL    |   0
 .../userspace => tools/usb/usbip}/Makefile.am      |   0
 .../usbip/userspace => tools/usb/usbip}/README     |   0
 .../usbip/userspace => tools/usb/usbip}/autogen.sh |   0
 .../usbip/userspace => tools/usb/usbip}/cleanup.sh |   0
 .../userspace => tools/usb/usbip}/configure.ac     |   0
 .../userspace => tools/usb/usbip}/doc/usbip.8      |   0
 .../userspace => tools/usb/usbip}/doc/usbipd.8     |   0
 .../usb/usbip}/libsrc/Makefile.am                  |   0
 .../userspace => tools/usb/usbip}/libsrc/list.h    |   0
 .../userspace => tools/usb/usbip}/libsrc/names.c   |   0
 .../userspace => tools/usb/usbip}/libsrc/names.h   |   0
 .../usb/usbip}/libsrc/sysfs_utils.c                |   0
 .../usb/usbip}/libsrc/sysfs_utils.h                |   0
 .../usb/usbip}/libsrc/usbip_common.c               |   0
 .../usb/usbip}/libsrc/usbip_common.h               |   0
 .../usb/usbip}/libsrc/usbip_host_driver.c          |   0
 .../usb/usbip}/libsrc/usbip_host_driver.h          |   0
 .../usb/usbip}/libsrc/vhci_driver.c                |   0
 .../usb/usbip}/libsrc/vhci_driver.h                |   0
 .../userspace => tools/usb/usbip}/src/Makefile.am  |   0
 .../userspace => tools/usb/usbip}/src/usbip.c      |   0
 .../userspace => tools/usb/usbip}/src/usbip.h      |   0
 .../usb/usbip}/src/usbip_attach.c                  |   0
 .../userspace => tools/usb/usbip}/src/usbip_bind.c |   0
 .../usb/usbip}/src/usbip_detach.c                  |   0
 .../userspace => tools/usb/usbip}/src/usbip_list.c |   0
 .../usb/usbip}/src/usbip_network.c                 |   0
 .../usb/usbip}/src/usbip_network.h                 |   0
 .../userspace => tools/usb/usbip}/src/usbip_port.c |   0
 .../usb/usbip}/src/usbip_unbind.c                  |   0
 .../userspace => tools/usb/usbip}/src/usbipd.c     |   0
 .../userspace => tools/usb/usbip}/src/utils.c      |   0
 .../userspace => tools/usb/usbip}/src/utils.h      |   0
 95 files changed, 210 insertions(+), 165 deletions(-)
 rename drivers/{staging => usb}/usbip/Kconfig (100%)
 rename drivers/{staging => usb}/usbip/Makefile (100%)
 rename drivers/{staging => usb}/usbip/README (100%)
 rename drivers/{staging => usb}/usbip/stub.h (100%)
 rename drivers/{staging => usb}/usbip/stub_dev.c (90%)
 rename drivers/{staging => usb}/usbip/stub_main.c (100%)
 rename drivers/{staging => usb}/usbip/stub_rx.c (100%)
 rename drivers/{staging => usb}/usbip/stub_tx.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_common.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_common.h (99%)
 rename drivers/{staging => usb}/usbip/usbip_event.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_protocol.txt (100%)
 rename drivers/{staging => usb}/usbip/vhci.h (100%)
 rename drivers/{staging => usb}/usbip/vhci_hcd.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_rx.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_sysfs.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_tx.c (100%)
 rename {drivers/staging/usbip/uapi => include/uapi/linux}/usbip.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/.gitignore (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/AUTHORS (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/COPYING (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/INSTALL (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/README (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/autogen.sh (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/cleanup.sh (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/configure.ac (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbip.8 (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/doc/usbipd.8 (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/list.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/names.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/sysfs_utils.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_common.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/usbip_host_driver.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/libsrc/vhci_driver.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/Makefile.am (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_attach.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_bind.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_detach.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_list.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_network.h (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_port.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbip_unbind.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/usbipd.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.c (100%)
 rename {drivers/staging/usbip/userspace => tools/usb/usbip}/src/utils.h (100%)
