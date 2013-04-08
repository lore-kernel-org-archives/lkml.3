Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639Ab3DHXme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:42:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:17403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760469Ab3DHXmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:42:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="316268312"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3 V6] Support NFC Device on MEI CL Bus
Date: Tue,  9 Apr 2013 02:41:32 +0300
Message-Id: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5 -> v6
 1. include/linux/uapi/mei/nfc.h - provides API also for pure
    user space implementation as found under Android.
 2. Removed INTEL_MEI_BUS_NFC Kconfig option. 
    The NFC info client is disconnected as soon as we
    get the FW info and the regular client is connected only when
    mei_cl_enable_device() is explicitly called from an nfc driver.
    The mei cl bus now doesn't connect NFC  exclusively.
 3. Added pn544 to the possibly detected NFC chipsets.

Depends on: 
	mei: bus: Add device enabling and disabling API

Samuel Ortiz (3):
  mei: nfc: Initial nfc implementation
  mei: nfc: Add NFC device to the MEI bus
  mei: nfc: Implement MEI bus ops

 drivers/misc/mei/Makefile     |   1 +
 drivers/misc/mei/client.c     |   3 +
 drivers/misc/mei/init.c       |   2 +
 drivers/misc/mei/mei_dev.h    |  10 +
 drivers/misc/mei/nfc.c        | 493 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild     |   1 +
 include/uapi/linux/mei/Kbuild |   2 +
 include/uapi/linux/mei/nfc.h  | 135 ++++++++++++
 8 files changed, 647 insertions(+)
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 include/uapi/linux/mei/Kbuild
 create mode 100644 include/uapi/linux/mei/nfc.h

-- 
1.8.1.2

