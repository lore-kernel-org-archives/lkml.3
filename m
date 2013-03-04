Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3CDV2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:28:50 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58620 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437Ab3CDV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:28:49 -0500
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-usb@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] usb/gadget: initialize gadget functions helper befor functions & gadgets
Date: Mon,  4 Mar 2013 22:28:09 +0100
Message-Id: <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130206020424.GB1175@localhost>
References: <20130206020424.GB1175@localhost>
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu run into a kernel ops after he complied dummy_hcd and g_cdc
into the kernel. The problem was that u_serial was used by g_cdc before
u_serial was initialized. In the module case eveything is initialized in
the correct order but if we compile it into the kernel we rely on
Makefile order which I did wrong and now I correct this.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
I kinda assumed that this was already fixed (i.e. a patch like this was sent)
but it seems not to be that case.

 drivers/usb/gadget/Makefile |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 97a13c3..1ded3d4 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -35,6 +35,12 @@ mv_udc-y			:= mv_udc_core.o
 obj-$(CONFIG_USB_FUSB300)	+= fusb300_udc.o
 obj-$(CONFIG_USB_MV_U3D)	+= mv_u3d_core.o
 
+# USB Functions
+obj-$(CONFIG_USB_U_SERIAL)	+= u_serial.o
+obj-$(CONFIG_USB_F_ACM)		+= f_acm.o
+f_ss_lb-y			:= f_loopback.o f_sourcesink.o
+obj-$(CONFIG_USB_F_SS_LB)	+= f_ss_lb.o
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

