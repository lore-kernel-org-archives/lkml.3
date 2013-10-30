Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3J3RE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:04:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:49122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3J3RCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401080723"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, Paul.Zimmerman@synopsys.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v3 0/3] add gadget quirk to adapt f_fs for DWC3
Date: Wed, 30 Oct 2013 10:06:15 -0700
Message-Id: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
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

---
David Cohen (3):
  usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
  usb: ffs: check quirk to pad epout buf size when not aligned to
    maxpacketsize
  usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
    driver

 drivers/usb/dwc3/gadget.c  |  6 ++++++
 drivers/usb/gadget/f_fs.c  | 17 +++++++++++++++++
 include/linux/usb/gadget.h |  3 +++
 3 files changed, 26 insertions(+)

-- 
1.8.4.rc3

