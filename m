Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaIPWJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:09:24 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60287 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbaIPWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:08:29 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>
Date: Tue, 16 Sep 2014 23:38:37 +0000
Message-Id: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 00/18] usbip: Crypto and ACLs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As follow-up to Dominik Paulus' and Tobias Polzers series of patches from 19
Oct 2013 (which hasn't been accepted) and due to the fact that usb/ip has
recently been moved out of staging we rebased the patches on top of v3.17-rc5
and would like to resubmit.

This patch series includes:

 - The client/server authentication support using GnuTLS

 - Support for restricting the access to devices to specific IP address ranges

 - Improved error reporting and new error codes to be passed over the TCP
   protocol.

 - Minor changes to fit to the current state of usb/ip source.

As Dominik and Tobias suggested the added features justify a version bump to
1.2.0. The corresponding patch is also included. All protocol changes are
backwards-compatible, thus, we don't increment the protocol version.

Regards,

Maximilian Eschenbacher, Fjodor Schelichow and Johannes Stadlinger

---

 drivers/usb/usbip/Kconfig                  |   2 +-
 drivers/usb/usbip/stub.h                   |   8 +
 drivers/usb/usbip/stub_dev.c               | 104 +++++++-
 drivers/usb/usbip/stub_rx.c                |   2 +-
 drivers/usb/usbip/stub_tx.c                |   6 +-
 drivers/usb/usbip/usbip_common.c           | 411 ++++++++++++++++++++++++++---
 drivers/usb/usbip/usbip_common.h           |  41 ++-
 drivers/usb/usbip/vhci_hcd.c               |   4 +-
 drivers/usb/usbip/vhci_rx.c                |   2 +-
 drivers/usb/usbip/vhci_sysfs.c             |  47 +++-
 drivers/usb/usbip/vhci_tx.c                |   4 +-
 tools/usb/usbip/README                     |  72 ++---
 tools/usb/usbip/configure.ac               |  15 +-
 tools/usb/usbip/doc/usbip.8                |  14 +-
 tools/usb/usbip/doc/usbipd.8               |   7 +
 tools/usb/usbip/libsrc/list.h              |   3 +-
 tools/usb/usbip/libsrc/sysfs_utils.c       |  23 ++
 tools/usb/usbip/libsrc/sysfs_utils.h       |   1 +
 tools/usb/usbip/libsrc/usbip_common.c      |  15 ++
 tools/usb/usbip/libsrc/usbip_common.h      |  24 ++
 tools/usb/usbip/libsrc/usbip_host_driver.c |  17 +-
 tools/usb/usbip/libsrc/usbip_host_driver.h |   3 +-
 tools/usb/usbip/libsrc/vhci_driver.c       |  25 +-
 tools/usb/usbip/libsrc/vhci_driver.h       |   9 +-
 tools/usb/usbip/src/Makefile.am            |   2 +-
 tools/usb/usbip/src/usbip.c                |  30 ++-
 tools/usb/usbip/src/usbip_attach.c         |  75 +++++-
 tools/usb/usbip/src/usbip_bind.c           |  71 +++--
 tools/usb/usbip/src/usbip_list.c           |  29 +-
 tools/usb/usbip/src/usbip_network.c        | 360 ++++++++++++++++++++++---
 tools/usb/usbip/src/usbip_network.h        |  81 +++++-
 tools/usb/usbip/src/usbipd.c               | 323 ++++++++++++++++-------
 tools/usb/usbip/src/utils.c                |  88 ++++++
 tools/usb/usbip/src/utils.h                |  15 ++
 34 files changed, 1627 insertions(+), 306 deletions(-)

-- 
2.1.0

