Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbaCRUME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:12:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65185 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaCRUMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:12:02 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 0/3] usbip: move usbip out of staging
Date: Tue, 18 Mar 2014 22:11:20 +0200
Message-Id: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
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

Besides this, a warning generated in the kernel code is solved.

Valentina Manea (3):
  usbip: move usbip userspace code out of staging
  usbip: move usbip kernel code out of staging
  usbip: remove struct usb_device_id table

 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/usbip/Kconfig                      |   45 -
 drivers/staging/usbip/Makefile                     |   10 -
 drivers/staging/usbip/README                       |    7 -
 drivers/staging/usbip/stub.h                       |  113 --
 drivers/staging/usbip/stub_dev.c                   |  524 ---------
 drivers/staging/usbip/stub_main.c                  |  339 ------
 drivers/staging/usbip/stub_rx.c                    |  595 ----------
 drivers/staging/usbip/stub_tx.c                    |  397 -------
 drivers/staging/usbip/uapi/usbip.h                 |   26 -
 drivers/staging/usbip/usbip_common.c               |  803 --------------
 drivers/staging/usbip/usbip_common.h               |  334 ------
 drivers/staging/usbip/usbip_event.c                |  128 ---
 drivers/staging/usbip/usbip_protocol.txt           |  358 ------
 drivers/staging/usbip/userspace/.gitignore         |   28 -
 drivers/staging/usbip/userspace/AUTHORS            |    3 -
 drivers/staging/usbip/userspace/COPYING            |  340 ------
 drivers/staging/usbip/userspace/INSTALL            |  237 ----
 drivers/staging/usbip/userspace/Makefile.am        |    6 -
 drivers/staging/usbip/userspace/README             |  203 ----
 drivers/staging/usbip/userspace/autogen.sh         |    9 -
 drivers/staging/usbip/userspace/cleanup.sh         |   12 -
 drivers/staging/usbip/userspace/configure.ac       |  111 --
 drivers/staging/usbip/userspace/doc/usbip.8        |   95 --
 drivers/staging/usbip/userspace/doc/usbipd.8       |   91 --
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    8 -
 drivers/staging/usbip/userspace/libsrc/list.h      |  136 ---
 drivers/staging/usbip/userspace/libsrc/names.c     |  504 ---------
 drivers/staging/usbip/userspace/libsrc/names.h     |   41 -
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   |   31 -
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |    8 -
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  285 -----
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  137 ---
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  276 -----
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   49 -
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  411 -------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   59 -
 drivers/staging/usbip/userspace/src/Makefile.am    |   11 -
 drivers/staging/usbip/userspace/src/usbip.c        |  201 ----
 drivers/staging/usbip/userspace/src/usbip.h        |   40 -
 drivers/staging/usbip/userspace/src/usbip_attach.c |  240 ----
 drivers/staging/usbip/userspace/src/usbip_bind.c   |  214 ----
 drivers/staging/usbip/userspace/src/usbip_detach.c |  110 --
 drivers/staging/usbip/userspace/src/usbip_list.c   |  283 -----
 .../staging/usbip/userspace/src/usbip_network.c    |  303 -----
 .../staging/usbip/userspace/src/usbip_network.h    |  185 ----
 drivers/staging/usbip/userspace/src/usbip_port.c   |   57 -
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  141 ---
 drivers/staging/usbip/userspace/src/usbipd.c       |  675 -----------
 drivers/staging/usbip/userspace/src/utils.c        |   52 -
 drivers/staging/usbip/userspace/src/utils.h        |   25 -
 drivers/staging/usbip/vhci.h                       |  129 ---
 drivers/staging/usbip/vhci_hcd.c                   | 1168 --------------------
 drivers/staging/usbip/vhci_rx.c                    |  270 -----
 drivers/staging/usbip/vhci_sysfs.c                 |  252 -----
 drivers/staging/usbip/vhci_tx.c                    |  224 ----
 drivers/usb/Kconfig                                |    2 +
 drivers/usb/Makefile                               |    2 +
 drivers/usb/usbip/Kconfig                          |   45 +
 drivers/usb/usbip/Makefile                         |   10 +
 drivers/usb/usbip/README                           |    7 +
 drivers/usb/usbip/stub.h                           |  113 ++
 drivers/usb/usbip/stub_dev.c                       |  497 +++++++++
 drivers/usb/usbip/stub_main.c                      |  339 ++++++
 drivers/usb/usbip/stub_rx.c                        |  595 ++++++++++
 drivers/usb/usbip/stub_tx.c                        |  397 +++++++
 drivers/usb/usbip/usbip_common.c                   |  803 ++++++++++++++
 drivers/usb/usbip/usbip_common.h                   |  334 ++++++
 drivers/usb/usbip/usbip_event.c                    |  128 +++
 drivers/usb/usbip/usbip_protocol.txt               |  358 ++++++
 drivers/usb/usbip/vhci.h                           |  129 +++
 drivers/usb/usbip/vhci_hcd.c                       | 1168 ++++++++++++++++++++
 drivers/usb/usbip/vhci_rx.c                        |  270 +++++
 drivers/usb/usbip/vhci_sysfs.c                     |  252 +++++
 drivers/usb/usbip/vhci_tx.c                        |  224 ++++
 include/uapi/linux/usbip.h                         |   26 +
 tools/usb/usbip/.gitignore                         |   28 +
 tools/usb/usbip/AUTHORS                            |    3 +
 tools/usb/usbip/COPYING                            |  340 ++++++
 tools/usb/usbip/INSTALL                            |  237 ++++
 tools/usb/usbip/Makefile.am                        |    6 +
 tools/usb/usbip/README                             |  203 ++++
 tools/usb/usbip/autogen.sh                         |    9 +
 tools/usb/usbip/cleanup.sh                         |   12 +
 tools/usb/usbip/configure.ac                       |  111 ++
 tools/usb/usbip/doc/usbip.8                        |   95 ++
 tools/usb/usbip/doc/usbipd.8                       |   91 ++
 tools/usb/usbip/libsrc/Makefile.am                 |    8 +
 tools/usb/usbip/libsrc/list.h                      |  136 +++
 tools/usb/usbip/libsrc/names.c                     |  504 +++++++++
 tools/usb/usbip/libsrc/names.h                     |   41 +
 tools/usb/usbip/libsrc/sysfs_utils.c               |   31 +
 tools/usb/usbip/libsrc/sysfs_utils.h               |    8 +
 tools/usb/usbip/libsrc/usbip_common.c              |  285 +++++
 tools/usb/usbip/libsrc/usbip_common.h              |  137 +++
 tools/usb/usbip/libsrc/usbip_host_driver.c         |  276 +++++
 tools/usb/usbip/libsrc/usbip_host_driver.h         |   49 +
 tools/usb/usbip/libsrc/vhci_driver.c               |  411 +++++++
 tools/usb/usbip/libsrc/vhci_driver.h               |   59 +
 tools/usb/usbip/src/Makefile.am                    |   11 +
 tools/usb/usbip/src/usbip.c                        |  201 ++++
 tools/usb/usbip/src/usbip.h                        |   40 +
 tools/usb/usbip/src/usbip_attach.c                 |  240 ++++
 tools/usb/usbip/src/usbip_bind.c                   |  214 ++++
 tools/usb/usbip/src/usbip_detach.c                 |  110 ++
 tools/usb/usbip/src/usbip_list.c                   |  283 +++++
 tools/usb/usbip/src/usbip_network.c                |  303 +++++
 tools/usb/usbip/src/usbip_network.h                |  185 ++++
 tools/usb/usbip/src/usbip_port.c                   |   57 +
 tools/usb/usbip/src/usbip_unbind.c                 |  141 +++
 tools/usb/usbip/src/usbipd.c                       |  675 +++++++++++
 tools/usb/usbip/src/utils.c                        |   52 +
 tools/usb/usbip/src/utils.h                        |   25 +
 114 files changed, 11316 insertions(+), 11342 deletions(-)
 delete mode 100644 drivers/staging/usbip/Kconfig
 delete mode 100644 drivers/staging/usbip/Makefile
 delete mode 100644 drivers/staging/usbip/README
 delete mode 100644 drivers/staging/usbip/stub.h
 delete mode 100644 drivers/staging/usbip/stub_dev.c
 delete mode 100644 drivers/staging/usbip/stub_main.c
 delete mode 100644 drivers/staging/usbip/stub_rx.c
 delete mode 100644 drivers/staging/usbip/stub_tx.c
 delete mode 100644 drivers/staging/usbip/uapi/usbip.h
 delete mode 100644 drivers/staging/usbip/usbip_common.c
 delete mode 100644 drivers/staging/usbip/usbip_common.h
 delete mode 100644 drivers/staging/usbip/usbip_event.c
 delete mode 100644 drivers/staging/usbip/usbip_protocol.txt
 delete mode 100644 drivers/staging/usbip/userspace/.gitignore
 delete mode 100644 drivers/staging/usbip/userspace/AUTHORS
 delete mode 100644 drivers/staging/usbip/userspace/COPYING
 delete mode 100644 drivers/staging/usbip/userspace/INSTALL
 delete mode 100644 drivers/staging/usbip/userspace/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/README
 delete mode 100755 drivers/staging/usbip/userspace/autogen.sh
 delete mode 100755 drivers/staging/usbip/userspace/cleanup.sh
 delete mode 100644 drivers/staging/usbip/userspace/configure.ac
 delete mode 100644 drivers/staging/usbip/userspace/doc/usbip.8
 delete mode 100644 drivers/staging/usbip/userspace/doc/usbipd.8
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/list.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/names.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/names.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/src/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip.h
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_attach.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_bind.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_detach.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_list.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_network.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_network.h
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_port.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_unbind.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbipd.c
 delete mode 100644 drivers/staging/usbip/userspace/src/utils.c
 delete mode 100644 drivers/staging/usbip/userspace/src/utils.h
 delete mode 100644 drivers/staging/usbip/vhci.h
 delete mode 100644 drivers/staging/usbip/vhci_hcd.c
 delete mode 100644 drivers/staging/usbip/vhci_rx.c
 delete mode 100644 drivers/staging/usbip/vhci_sysfs.c
 delete mode 100644 drivers/staging/usbip/vhci_tx.c
 create mode 100644 drivers/usb/usbip/Kconfig
 create mode 100644 drivers/usb/usbip/Makefile
 create mode 100644 drivers/usb/usbip/README
 create mode 100644 drivers/usb/usbip/stub.h
 create mode 100644 drivers/usb/usbip/stub_dev.c
 create mode 100644 drivers/usb/usbip/stub_main.c
 create mode 100644 drivers/usb/usbip/stub_rx.c
 create mode 100644 drivers/usb/usbip/stub_tx.c
 create mode 100644 drivers/usb/usbip/usbip_common.c
 create mode 100644 drivers/usb/usbip/usbip_common.h
 create mode 100644 drivers/usb/usbip/usbip_event.c
 create mode 100644 drivers/usb/usbip/usbip_protocol.txt
 create mode 100644 drivers/usb/usbip/vhci.h
 create mode 100644 drivers/usb/usbip/vhci_hcd.c
 create mode 100644 drivers/usb/usbip/vhci_rx.c
 create mode 100644 drivers/usb/usbip/vhci_sysfs.c
 create mode 100644 drivers/usb/usbip/vhci_tx.c
 create mode 100644 include/uapi/linux/usbip.h
 create mode 100644 tools/usb/usbip/.gitignore
 create mode 100644 tools/usb/usbip/AUTHORS
 create mode 100644 tools/usb/usbip/COPYING
 create mode 100644 tools/usb/usbip/INSTALL
 create mode 100644 tools/usb/usbip/Makefile.am
 create mode 100644 tools/usb/usbip/README
 create mode 100755 tools/usb/usbip/autogen.sh
 create mode 100755 tools/usb/usbip/cleanup.sh
 create mode 100644 tools/usb/usbip/configure.ac
 create mode 100644 tools/usb/usbip/doc/usbip.8
 create mode 100644 tools/usb/usbip/doc/usbipd.8
 create mode 100644 tools/usb/usbip/libsrc/Makefile.am
 create mode 100644 tools/usb/usbip/libsrc/list.h
 create mode 100644 tools/usb/usbip/libsrc/names.c
 create mode 100644 tools/usb/usbip/libsrc/names.h
 create mode 100644 tools/usb/usbip/libsrc/sysfs_utils.c
 create mode 100644 tools/usb/usbip/libsrc/sysfs_utils.h
 create mode 100644 tools/usb/usbip/libsrc/usbip_common.c
 create mode 100644 tools/usb/usbip/libsrc/usbip_common.h
 create mode 100644 tools/usb/usbip/libsrc/usbip_host_driver.c
 create mode 100644 tools/usb/usbip/libsrc/usbip_host_driver.h
 create mode 100644 tools/usb/usbip/libsrc/vhci_driver.c
 create mode 100644 tools/usb/usbip/libsrc/vhci_driver.h
 create mode 100644 tools/usb/usbip/src/Makefile.am
 create mode 100644 tools/usb/usbip/src/usbip.c
 create mode 100644 tools/usb/usbip/src/usbip.h
 create mode 100644 tools/usb/usbip/src/usbip_attach.c
 create mode 100644 tools/usb/usbip/src/usbip_bind.c
 create mode 100644 tools/usb/usbip/src/usbip_detach.c
 create mode 100644 tools/usb/usbip/src/usbip_list.c
 create mode 100644 tools/usb/usbip/src/usbip_network.c
 create mode 100644 tools/usb/usbip/src/usbip_network.h
 create mode 100644 tools/usb/usbip/src/usbip_port.c
 create mode 100644 tools/usb/usbip/src/usbip_unbind.c
 create mode 100644 tools/usb/usbip/src/usbipd.c
 create mode 100644 tools/usb/usbip/src/utils.c
 create mode 100644 tools/usb/usbip/src/utils.h

-- 
1.8.1.2

