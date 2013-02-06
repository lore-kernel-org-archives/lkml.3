Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3BFIu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:50:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49255 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab3BFIux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:50:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bigeasy@linutronix.de>
CC: <kishon@ti.com>
Subject: [PATCH] usb: gadget: make usb functions to load before gadget driver
Date: Wed, 6 Feb 2013 14:20:34 +0530
Message-ID: <1360140634-1833-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ordering in makefile makes gadget drivers to be loaded
before usb functions making usb_get_function_instance() to fail when the
modules are *built-in* the kernel.
Changed the ordering here so that USB functions are loaded before gadget
drivers.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/gadget/Makefile |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 97a13c3..82fb225 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -35,6 +35,12 @@ mv_udc-y			:= mv_udc_core.o
 obj-$(CONFIG_USB_FUSB300)	+= fusb300_udc.o
 obj-$(CONFIG_USB_MV_U3D)	+= mv_u3d_core.o
 
+# USB Functions
+obj-$(CONFIG_USB_F_ACM)		+= f_acm.o
+f_ss_lb-y			:= f_loopback.o f_sourcesink.o
+obj-$(CONFIG_USB_F_SS_LB)	+= f_ss_lb.o
+obj-$(CONFIG_USB_U_SERIAL)	+= u_serial.o
+
 #
 # USB gadget drivers
 #
@@ -74,9 +80,3 @@ obj-$(CONFIG_USB_G_WEBCAM)	+= g_webcam.o
 obj-$(CONFIG_USB_G_NCM)		+= g_ncm.o
 obj-$(CONFIG_USB_G_ACM_MS)	+= g_acm_ms.o
 obj-$(CONFIG_USB_GADGET_TARGET)	+= tcm_usb_gadget.o
-
-# USB Functions
-obj-$(CONFIG_USB_F_ACM)		+= f_acm.o
-f_ss_lb-y			:= f_loopback.o f_sourcesink.o
-obj-$(CONFIG_USB_F_SS_LB)	+= f_ss_lb.o
-obj-$(CONFIG_USB_U_SERIAL)	+= u_serial.o
-- 
1.7.10.4

