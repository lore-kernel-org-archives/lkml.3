Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaCHMx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:53:58 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63929 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaCHMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:53:53 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 00/18] Resend of usbip-utils migration patches and various other fixes
Date: Sat,  8 Mar 2014 14:53:18 +0200
Message-Id: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the patches sent a few days ago, including
the migration of USB/IP userspace side to use libudev instead
of libsysfs and various other fixes, all ordered in a big patch
series.

The patches have been modified according to received feedback.

Valentina Manea (18):
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
  staging: usbip: userspace: increase version to 2.0
  staging: usbip: let client choose device configuration
  staging: usbip: trigger driver probing after unbinding from usbip-host
  staging: usbip: claim ports used by shared devices
  staging: usbip: userspace: don't throw error when trying to read
    configuration specific attributes
  staging: usbip: userspace: add hwdata as optional dependency in README

 drivers/staging/usbip/stub.h                       |   1 +
 drivers/staging/usbip/stub_dev.c                   |  33 +-
 drivers/staging/usbip/stub_main.c                  |  39 +++
 drivers/staging/usbip/stub_rx.c                    |  26 +-
 drivers/staging/usbip/userspace/README             |   8 +-
 drivers/staging/usbip/userspace/configure.ac       |  12 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |   3 +-
 drivers/staging/usbip/userspace/libsrc/list.h      | 136 ++++++++
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   |  31 ++
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |   8 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  91 +++---
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  15 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     | 285 +++++------------
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   7 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 346 ++++-----------------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |  14 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |   1 -
 drivers/staging/usbip/userspace/src/usbip_attach.c |   1 -
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 149 ++++-----
 drivers/staging/usbip/userspace/src/usbip_detach.c |   2 -
 drivers/staging/usbip/userspace/src/usbip_list.c   | 153 ++++-----
 .../staging/usbip/userspace/src/usbip_network.h    |   1 -
 drivers/staging/usbip/userspace/src/usbip_unbind.c | 110 +++----
 drivers/staging/usbip/userspace/src/usbipd.c       |  30 +-
 drivers/staging/usbip/userspace/src/utils.c        |  48 +--
 drivers/usb/core/hub.c                             |   2 +
 drivers/usb/core/usb.h                             |   4 -
 include/linux/usb.h                                |   7 +
 28 files changed, 676 insertions(+), 887 deletions(-)
 create mode 100644 drivers/staging/usbip/userspace/libsrc/list.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h

-- 
1.8.1.2

