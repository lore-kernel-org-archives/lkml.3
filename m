Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3KDWJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:09:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:50701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab3KDWIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429741872"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v4 0/4] add gadget quirk to adapt f_fs for DWC3
Date: Mon,  4 Nov 2013 14:12:53 -0800
Message-Id: <1383603177-4624-1-git-send-email-david.a.cohen@linux.intel.com>
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

Changes from v3 to v4:
 - replace u32 quirk flags by single unsigned:1 flag for ep out aligned size
   quirk on usb_gadget
 - add static inline helper to align ep out buf size

---
David Cohen (4):
  usb: gadget: move bitflags to the end of usb_gadget struct
  usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
  usb: ffs: check quirk to pad epout buf size when not aligned to
    maxpacketsize
  usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
    driver

 drivers/usb/dwc3/gadget.c  |  6 ++++++
 drivers/usb/gadget/f_fs.c  | 22 ++++++++++++++++++++++
 include/linux/usb/gadget.h | 38 +++++++++++++++++++++++++++++---------
 3 files changed, 57 insertions(+), 9 deletions(-)

-- 
1.8.4.rc3

