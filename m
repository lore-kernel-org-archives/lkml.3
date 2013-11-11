Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3KKUNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:13:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:44050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3KKUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:12:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433422447"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v5 0/5] add gadget quirk to adapt f_fs for DWC3
Date: Mon, 11 Nov 2013 12:16:46 -0800
Message-Id: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are a proposal to add gadget quirks in an immediate objective to
adapt f_fs when using DWC3 controller. But the quirk solution is generic and
can be used by other controllers to adapt gadget functions to their
non-standard restrictions.

This change is necessary to make Android's adbd service to work on Intel
Merrifield with f_fs instead of out-of-tree android gadget.

This new patch set was tested and validated in my environment:
 - Intel Merrifield was able to use DWC3/f_fs with adbd service (it wasn't
   before).

Changes from v4 to v5:
 - Added 2 patches from Michal Nazarewicz to address comments from Alan Stern
   on f_fs driver.

---
David Cohen (3):
  usb: gadget: move bitflags to the end of usb_gadget struct
  usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
  usb: dwc3: set gadget's quirk ep_out_align_size

Michal Nazarewicz (2):
  usb: gadget: f_fs: remove loop from I/O function
  usb: f_fs: check quirk to pad epout buf size when not aligned to
    maxpacketsize

 drivers/usb/dwc3/gadget.c  |   6 +++
 drivers/usb/gadget/f_fs.c  | 115 +++++++++++++++++++++++----------------------
 include/linux/usb/gadget.h |  35 ++++++++++----
 3 files changed, 91 insertions(+), 65 deletions(-)

-- 
1.8.4.rc3

