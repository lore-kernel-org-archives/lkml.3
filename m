Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaBFOdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:33:33 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:46800 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaBFOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:33:31 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s16EWlS2015337, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH v3 0/3] Add modules for realtek USB card reader
Date: Thu, 6 Feb 2014 22:35:04 +0800
Message-ID: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
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
3. Revise coding style and white spaces

v3:
1. Fix MMC detection fail when under xhci
2. Minor change of pm_runtime behavior in rtsx_usb_ms to prevent some rare
   freeze due to erroneous Memstick card(not MS-Pro)
3. Further revise coding style as suggested in the thread of v2
4. Using managed resources: devm_*
5. Change license from "GPL v2 and later" to "GPL v2"

Roger Tseng (3):
  mfd: Add realtek USB card reader driver
  mmc: Add realtek USB sdmmc host driver
  memstick: Add realtek USB memstick host driver

 drivers/memstick/host/Kconfig       |   10 +
 drivers/memstick/host/Makefile      |    1 +
 drivers/memstick/host/rtsx_usb_ms.c |  849 ++++++++++++++++++++
 drivers/mfd/Kconfig                 |   10 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/rtsx_usb.c              |  760 ++++++++++++++++++
 drivers/mmc/host/Kconfig            |    7 +
 drivers/mmc/host/Makefile           |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c   | 1500 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_usb.h        |  628 +++++++++++++++
 10 files changed, 3767 insertions(+)
 create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
 create mode 100644 drivers/mfd/rtsx_usb.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_usb.h

-- 
1.8.2

