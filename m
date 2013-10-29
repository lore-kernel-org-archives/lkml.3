Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3J2BIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:08:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:61520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3J2BIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400167039"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 0/2] patchset to workaround f_fs for DWC3
Date: Mon, 28 Oct 2013 18:12:58 -0700
Message-Id: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are a proposal to workaround f_fs when using DWC3 controller.
Since DWC3 requires epout buffer size to be aligned to maxpacketsize, f_fs
needs to pad buffer size to match the above case.

This change is necessary to make Android's adbd service to work with f_fs
instead of out-of-tree android gadget. If this same situation is happening in
other still untested places, a more generic solution may be required.

---
David Cohen (2):
  usb: gadget: re-introduce gadget_is_dwc3()
  usb: ffs/dwc3: pad epout buffer size when not aligned to maxpacketsize

 drivers/usb/gadget/f_fs.c         | 19 +++++++++++++++++++
 drivers/usb/gadget/gadget_chips.h |  1 +
 2 files changed, 20 insertions(+)

-- 
1.8.4.rc3

