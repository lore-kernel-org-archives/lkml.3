Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3J2Vsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:48:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:6535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3J2Vso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400647233"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH v2 1/3] usb: gadget: add quirks field to struct usb_gadget
Date: Tue, 29 Oct 2013 14:52:56 -0700
Message-Id: <1383083578-16447-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to USB controllers may have different restrictions, usb gadget layer
needs to provide a generic way to inform gadget functions to complain
with non-standard requirements.

This patch adds 'quirks' field to struct usb_gadget and the first quirk
called USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE necessary to inform when
controller's epout requires buffer size to be aligned to MaxPacketSize.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 include/linux/usb/gadget.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 942ef5e..7014ad9 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -540,6 +540,11 @@ struct usb_gadget {
 	struct device			dev;
 	unsigned			out_epnum;
 	unsigned			in_epnum;
+
+	u32				quirks;
+/* epout requires buffer size to be aligned to MaxPacketSize */
+#define USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE		(1 << 0)
+
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
1.8.4.rc3

