Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3J2Vso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:48:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:62273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab3J2Vsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400647232"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Date: Tue, 29 Oct 2013 14:52:55 -0700
Message-Id: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
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
  usb: gadget: add quirks field to struct usb_gadget
  usb: ffs: check quirk to pad epout buf size when not aligned to
    maxpacketsize
  usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
    driver

 drivers/usb/dwc3/gadget.c  |  1 +
 drivers/usb/gadget/f_fs.c  | 17 +++++++++++++++++
 include/linux/usb/gadget.h |  5 +++++
 3 files changed, 23 insertions(+)

-- 
1.8.4.rc3

