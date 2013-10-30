Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3J3RCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:02:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:49116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3J3RCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401080725"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, Paul.Zimmerman@synopsys.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v3 1/3] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
Date: Wed, 30 Oct 2013 10:06:16 -0700
Message-Id: <1383152778-30739-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to USB controllers may have different restrictions, usb gadget layer
needs to provide a generic way to inform gadget functions to complain
with non-standard requirements.

This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
to inform when controller's epout requires buffer size to be aligned to
MaxPacketSize.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 include/linux/usb/gadget.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 942ef5e..9405d0f 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -540,6 +540,9 @@ struct usb_gadget {
 	struct device			dev;
 	unsigned			out_epnum;
 	unsigned			in_epnum;
+
+	/* epout requires buffer size to be aligned to MaxPacketSize */
+	unsigned			quirk_ep_out_aligned_size:1;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
1.8.4.rc3

