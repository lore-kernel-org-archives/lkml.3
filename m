Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3LIXwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:52:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:45379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3LIXvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:51:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="421949712"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v7 1/5] usb: gadget: move bitflags to the end of usb_gadget struct
Date: Mon,  9 Dec 2013 15:55:34 -0800
Message-Id: <1386633338-10919-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all bitflags to the end of usb_gadget struct in order
to improve readability.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/usb/gadget.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 942ef5e053bf..23b3bfd0a842 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -485,6 +485,11 @@ struct usb_gadget_ops {
  * @max_speed: Maximal speed the UDC can handle.  UDC must support this
  *      and all slower speeds.
  * @state: the state we are now (attached, suspended, configured, etc)
+ * @name: Identifies the controller hardware type.  Used in diagnostics
+ *	and sometimes configuration.
+ * @dev: Driver model state for this abstract device.
+ * @out_epnum: last used out ep number
+ * @in_epnum: last used in ep number
  * @sg_supported: true if we can handle scatter-gather
  * @is_otg: True if the USB device port uses a Mini-AB jack, so that the
  *	gadget driver must provide a USB OTG descriptor.
@@ -497,11 +502,6 @@ struct usb_gadget_ops {
  *	only supports HNP on a different root port.
  * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
  *	enabled HNP support.
- * @name: Identifies the controller hardware type.  Used in diagnostics
- *	and sometimes configuration.
- * @dev: Driver model state for this abstract device.
- * @out_epnum: last used out ep number
- * @in_epnum: last used in ep number
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
  * functions, handling all usb configurations and interfaces.  Gadget
@@ -530,16 +530,17 @@ struct usb_gadget {
 	enum usb_device_speed		speed;
 	enum usb_device_speed		max_speed;
 	enum usb_device_state		state;
+	const char			*name;
+	struct device			dev;
+	unsigned			out_epnum;
+	unsigned			in_epnum;
+
 	unsigned			sg_supported:1;
 	unsigned			is_otg:1;
 	unsigned			is_a_peripheral:1;
 	unsigned			b_hnp_enable:1;
 	unsigned			a_hnp_support:1;
 	unsigned			a_alt_hnp_support:1;
-	const char			*name;
-	struct device			dev;
-	unsigned			out_epnum;
-	unsigned			in_epnum;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
1.8.4.2

