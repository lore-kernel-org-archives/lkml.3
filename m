Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaANHpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:45:46 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41167 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaANHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:45:40 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0E7j04Z007522, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/3] Add modules for realtek USB card reader
Date: Tue, 14 Jan 2014 15:47:33 +0800
Message-ID: <1389685656-880-1-git-send-email-rogerable@realtek.com>
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

v2:
1. Fix potential buffer overflow in rtsx_usb_seq_write_register()
2. Remove unnecessary casting and messages
2. Revise coding style and white spaces

Roger Tseng (3):
  mfd: Add realtek USB card reader driver
  mmc: Add realtek USB sdmmc host driver
  memstick: Add realtek USB memstick host driver

 drivers/memstick/host/Kconfig       |   10 +
 drivers/memstick/host/Makefile      |    1 +
 drivers/memstick/host/rtsx_usb_ms.c |  855 ++++++++++++++++++++
 drivers/mfd/Kconfig                 |   10 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/rtsx_usb.c              |  788 ++++++++++++++++++
 drivers/mmc/host/Kconfig            |    7 +
 drivers/mmc/host/Makefile           |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c   | 1509 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_usb.h        |  619 ++++++++++++++
 10 files changed, 3801 insertions(+)
 create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
 create mode 100644 drivers/mfd/rtsx_usb.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_usb.h

-- 
1.8.2

