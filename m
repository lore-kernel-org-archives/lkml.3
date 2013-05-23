Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3EWOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:11:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:24361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab3EWOLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="306834238"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linux-usb@vger.kernel.org
Cc: <sarah.a.sharp@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC PATCH v3 0/4] Add usb2 link powermanagement BESL support
Date: Thu, 23 May 2013 17:14:27 +0300
Message-Id: <1369318471-10353-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds usb2 best effort service latency (BESL) link PM support
to xHCI. BESL is an updated alternative to host initated resume delay
(HIRD) method of describing idle link timeouts.

Additionally this series fixes port capability checking
and replaces magic numbers with port register names.

Changes since v1:
-Use kstrto* and unsigned values in sysfs functions as Alan Stern suggested    

Changes since v2:
- Add Documentation/ABI/testing/sysfs-bus-usb entries for new sysfs attributes
- store l1_timeout value in microseconds instead of xHCI specific values

Mathias Nyman (4):
  usb: xhci: check usb2 port capabilities before adding hw link PM
    support
  usb: xhci: define port register names and use them instead of magic
    numbers
  usb: xhci: add USB2 Link power management BESL support
  usb: add usb2 Link PM variables to sysfs and usb_device

 Documentation/ABI/testing/sysfs-bus-usb |   27 ++++
 drivers/usb/core/sysfs.c                |   54 +++++++
 drivers/usb/host/xhci-ext-caps.h        |    1 +
 drivers/usb/host/xhci-hub.c             |   16 +--
 drivers/usb/host/xhci-mem.c             |   33 ++++-
 drivers/usb/host/xhci.c                 |  237 ++++++++++++++++++++++---------
 drivers/usb/host/xhci.h                 |   29 ++++
 include/linux/usb.h                     |   20 +++
 8 files changed, 337 insertions(+), 80 deletions(-)

-- 
1.7.4.1

