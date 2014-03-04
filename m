Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaCDTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:12 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52121 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaCDTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:10 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 00/12] Migrate usbip-utils to libudev
Date: Tue,  4 Mar 2014 21:10:40 +0200
Message-Id: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series modifies the USB/IP userspace side (usbip-utils)
to use libudev instead of libsysfs. This change was necessary as
libsysfs is no longer maintained and we have discovered a bug that
affected USB/IP.
On the other hand, libudev is actively maintained and recommended
for interacting with sysfs.

Valentina Manea (12):
  staging: usbip: userspace: migrate usbip_bind to libudev
  staging: usbip: userspace: remove useless libsysfs includes
  staging: usbip: userspace: migrate usbip_unbind to libudev
  staging: usbip: userspace: migrate usbip_list to libudev
  staging: usbip: userspace: re-add interface information listing
  staging: usbip: userspace: add new list API
  staging: usbip: userspace: move sysfs_utils to libsrc
  staging: usbip: userspace: migrate usbip_host_driver to libudev
  staging: usbip: userspace: remove class device infrastructure in
    vhci_driver
  staging: usbip: userspace: migrate vhci_driver to libudev
  staging: usbip: userspace: remove libsysfs flag and autoconf check
  staging: usbip: userspace: update dependencies in README

 drivers/staging/usbip/userspace/README             |   4 +-
 drivers/staging/usbip/userspace/configure.ac       |  10 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |   4 +-
 .../staging/usbip/userspace/libsrc/build_assert.h  |  40 ++
 .../staging/usbip/userspace/libsrc/check_type.h    |  64 +++
 .../staging/usbip/userspace/libsrc/container_of.h  | 109 ++++
 drivers/staging/usbip/userspace/libsrc/list.c      |  43 ++
 drivers/staging/usbip/userspace/libsrc/list.h      | 613 +++++++++++++++++++++
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   |  36 ++
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |   8 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  74 +--
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  15 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     | 282 +++-------
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   7 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 346 ++----------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   9 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |   1 -
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 149 ++---
 drivers/staging/usbip/userspace/src/usbip_detach.c |   2 -
 drivers/staging/usbip/userspace/src/usbip_list.c   | 157 +++---
 .../staging/usbip/userspace/src/usbip_network.h    |   1 -
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  92 +---
 drivers/staging/usbip/userspace/src/usbipd.c       |  26 +-
 drivers/staging/usbip/userspace/src/utils.c        |  51 +-
 24 files changed, 1299 insertions(+), 844 deletions(-)
 create mode 100644 drivers/staging/usbip/userspace/libsrc/build_assert.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/check_type.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/container_of.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/list.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/list.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h

-- 
1.8.1.2

