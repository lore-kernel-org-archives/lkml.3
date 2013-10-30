Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3J3REa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:04:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:49116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3J3RCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401080728"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, Paul.Zimmerman@synopsys.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v3 3/3] usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget driver
Date: Wed, 30 Oct 2013 10:06:18 -0700
Message-Id: <1383152778-30739-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
This patch adds necessary quirk for it.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5452c0f..528c7d7 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2600,6 +2600,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.name		= "dwc3-gadget";
 
 	/*
+	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
+	 * on ep out.
+	 */
+	dwc->gadget.quirk_ep_out_aligned_size = 1;
+
+	/*
 	 * REVISIT: Here we should clear all pending IRQs to be
 	 * sure we're starting from a well known location.
 	 */
-- 
1.8.4.rc3

