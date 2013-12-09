Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3LIXvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:51:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:45379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab3LIXvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="421949711"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v7 0/5] add gadget quirk to adapt f_fs for DWC3
Date: Mon,  9 Dec 2013 15:55:33 -0800
Message-Id: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
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

Changes from v6 to v7:
 - Downgraded patch set version to v5 as per Felipe Balbi request, with some
   changes:
   - usb_ep_align_maxpacketsize() macro was change to usp_ep_align_maybe()
     in order to check gadget->quirk_ep_out_aligned_size internally.
   - updated patch 4/5 to use new macro usp_ep_align_maybe() and to fix
     following compilation warning:
     $ drivers/usb/gadget/f_fs.c: In function 'ffs_epfile_io':
     $ drivers/usb/gadget/f_fs.c:857:124: warning: comparison of distinct pointer types lacks a cast [enabled by default]

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
 include/linux/usb/gadget.h |  39 +++++++++++----
 3 files changed, 94 insertions(+), 66 deletions(-)

-- 
1.8.4.2

