Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LIXvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:51:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:45401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab3LIXvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:51:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="421949716"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v7 5/5] usb: dwc3: set gadget's quirk ep_out_align_size
Date: Mon,  9 Dec 2013 15:55:38 -0800
Message-Id: <1386633338-10919-6-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
This patch sets necessary quirk for it.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5452c0fce360..b85ec110d6a0 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2600,6 +2600,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.name		= "dwc3-gadget";
 
 	/*
+	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
+	 * on ep out.
+	 */
+	dwc->gadget.quirk_ep_out_aligned_size = true;
+
+	/*
 	 * REVISIT: Here we should clear all pending IRQs to be
 	 * sure we're starting from a well known location.
 	 */
-- 
1.8.4.2

