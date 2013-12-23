Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3LWJuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:50:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:44796 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3LWJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:50:12 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBN9nqsA007399, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH 0/3] Add modules for realtek USB card reader
Date: Mon, 23 Dec 2013 17:52:04 +0800
Message-ID: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

This patchset adds modules to support Realtek USB vendor specific class flash
card reader: one base module in MFD subsystem and two host modules in both mmc
and memstick subsystems. The architecture is similar to rtsx_pci.

This work is done primarily to replace the staging driver: staging/rts5139,
which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
revision is applied, we may need Greg's help to remove the staging one.

Roger Tseng (3):
  mfd: Add realtek USB card reader driver
  mmc: Add realtek USB sdmmc host driver
  memstick: Add realtek USB memstick host driver

 drivers/memstick/host/Kconfig       |   10 +
 drivers/memstick/host/Makefile      |    1 +
 drivers/memstick/host/rtsx_usb_ms.c |  856 ++++++++++++++++++++
 drivers/mfd/Kconfig                 |   10 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/rtsx_usb.c              |  794 ++++++++++++++++++
 drivers/mmc/host/Kconfig            |    7 +
 drivers/mmc/host/Makefile           |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c   | 1511 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_usb.h        |  609 ++++++++++++++
 10 files changed, 3800 insertions(+)
 create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
 create mode 100644 drivers/mfd/rtsx_usb.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_usb.h

-- 
1.8.2

