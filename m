Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaHTEb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:31:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35345 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTEbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:31:24 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        shuahkhan@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 0/4] *** SUBJECT HERE ***
Date: Wed, 20 Aug 2014 07:30:58 +0300
Message-Id: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After migrating userspace code to libudev, converting usbip-host
to a device driver and various bug fixes and enhancements, USB/IP
is fully functional and can be moved out of staging.

This patch series moves it as following:
* userspace code to tools/usb/usbip
* kernel code to drivers/usb/usbip

A warning generated in the kernel code is also solved and an entry
in MAINTAINERS file is created for this driver.

Valentina Manea (4):
  usbip: move usbip userspace code out of staging
  usbip: move usbip kernel code out of staging
  usbip: remove struct usb_device_id table
  MAINTAINERS: Add an entry for USB/IP driver

 MAINTAINERS                                        |  8 +++++++
 drivers/staging/Kconfig                            |  2 --
 drivers/staging/Makefile                           |  1 -
 drivers/usb/Kconfig                                |  2 ++
 drivers/usb/Makefile                               |  2 ++
 drivers/{staging => usb}/usbip/Kconfig             |  0
 drivers/{staging => usb}/usbip/Makefile            |  0
 drivers/{staging => usb}/usbip/README              |  0
 drivers/{staging => usb}/usbip/stub.h              |  0
 drivers/{staging => usb}/usbip/stub_dev.c          | 27 ----------------------
 drivers/{staging => usb}/usbip/stub_main.c         |  0
 drivers/{staging => usb}/usbip/stub_rx.c           |  0
 drivers/{staging => usb}/usbip/stub_tx.c           |  0
 drivers/{staging => usb}/usbip/usbip_common.c      |  0
 drivers/{staging => usb}/usbip/usbip_common.h      |  2 +-
 drivers/{staging => usb}/usbip/usbip_event.c       |  0
 drivers/{staging => usb}/usbip/usbip_protocol.txt  |  0
 drivers/{staging => usb}/usbip/vhci.h              |  0
 drivers/{staging => usb}/usbip/vhci_hcd.c          |  0
 drivers/{staging => usb}/usbip/vhci_rx.c           |  0
 drivers/{staging => usb}/usbip/vhci_sysfs.c        |  0
 drivers/{staging => usb}/usbip/vhci_tx.c           |  0
 .../usbip/uapi => include/uapi/linux}/usbip.h      |  0
 .../usbip/userspace => tools/usb/usbip}/.gitignore |  0
 .../usbip/userspace => tools/usb/usbip}/AUTHORS    |  0
 .../usbip/userspace => tools/usb/usbip}/COPYING    |  0
 .../usbip/userspace => tools/usb/usbip}/INSTALL    |  0
 .../userspace => tools/usb/usbip}/Makefile.am      |  0
 .../usbip/userspace => tools/usb/usbip}/README     |  0
 .../usbip/userspace => tools/usb/usbip}/autogen.sh |  0
 .../usbip/userspace => tools/usb/usbip}/cleanup.sh |  0
 .../userspace => tools/usb/usbip}/configure.ac     |  0
 .../userspace => tools/usb/usbip}/doc/usbip.8      |  0
 .../userspace => tools/usb/usbip}/doc/usbipd.8     |  0
 .../usb/usbip}/libsrc/Makefile.am                  |  0
 .../userspace => tools/usb/usbip}/libsrc/list.h    |  0
 .../userspace => tools/usb/usbip}/libsrc/names.c   |  0
 .../userspace => tools/usb/usbip}/libsrc/names.h   |  0
 .../usb/usbip}/libsrc/sysfs_utils.c                |  0
 .../usb/usbip}/libsrc/sysfs_utils.h                |  0
 .../usb/usbip}/libsrc/usbip_common.c               |  0
 .../usb/usbip}/libsrc/usbip_common.h               |  0
 .../usb/usbip}/libsrc/usbip_host_driver.c          |  0
 .../usb/usbip}/libsrc/usbip_host_driver.h          |  0
 .../usb/usbip}/libsrc/vhci_driver.c                |  0
 .../usb/usbip}/libsrc/vhci_driver.h                |  0
 .../userspace => tools/usb/usbip}/src/Makefile.am  |  0
 .../userspace => tools/usb/usbip}/src/usbip.c      |  0
 .../userspace => tools/usb/usbip}/src/usbip.h      |  0
 .../usb/usbip}/src/usbip_attach.c                  |  0
 .../userspace => tools/usb/usbip}/src/usbip_bind.c |  0
 .../usb/usbip}/src/usbip_detach.c                  |  0
 .../userspace => tools/usb/usbip}/src/usbip_list.c |  0
 .../usb/usbip}/src/usbip_network.c                 |  0
 .../usb/usbip}/src/usbip_network.h                 |  0
 .../userspace => tools/usb/usbip}/src/usbip_port.c |  0
 .../usb/usbip}/src/usbip_unbind.c                  |  0
 .../userspace => tools/usb/usbip}/src/usbipd.c     |  0
 .../userspace => tools/usb/usbip}/src/utils.c      |  0
 .../userspace => tools/usb/usbip}/src/utils.h      |  0
 60 files changed, 13 insertions(+), 31 deletions(-)
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

-- 
1.8.1.2

