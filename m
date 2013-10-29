Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3J2Vtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:49:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:62273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3J2Vsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:48:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400647235"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH v2 3/3] usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget driver
Date: Tue, 29 Oct 2013 14:52:58 -0700
Message-Id: <1383083578-16447-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
This patch adds necessary quirk for it.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5452c0f..0dcc89f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2598,6 +2598,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.sg_supported	= true;
 	dwc->gadget.name		= "dwc3-gadget";
+	dwc->gadget.quirks		= USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE;
 
 	/*
 	 * REVISIT: Here we should clear all pending IRQs to be
-- 
1.8.4.rc3

