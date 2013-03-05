Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3CEWQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:16:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3CEWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:16:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/9] usb: gadget: fix omap_udc build errors
Date: Tue,  5 Mar 2013 23:16:44 +0100
Message-Id: <1362521809-22989-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9qO+VhneO9WFIGxzKIlU4g+wbfIsa4OIInbo3IKVuTa
 9fS5lj4joFVVwR8A/f+DswRnspm3T8mEuQdnvjWpislF+uuupZ
 YF41H7LY0F5yBfZ7U++d1dzOM6dpEviTcNiQ3jr1QN0B3mxDV2
 a8JT5JQOYRyUxaJ4gDvjgZiw0b3Z/EMVvXC5o52+PdQUkGAsG9
 0+ty0zTzenYGGcxTsVoahgppipOo5+8Rt4JChg7s3bF6DTpezP
 2ttY0x6K66BgYTfOgH7G05iB7f7lRErlwcSc5Ys583E0Sgzm7r
 dNTvJ/loHp0ukMnoiwT2ZS7ABp/fYiaZjJWST7c1cD0VqR3uIy
 ePG8iXrPe29dyf18vc0fVfNPOxfnihLWdTC6n0ZcA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1bf0cf6040 "usb: gadget: omap_udc: convert to udc_start/udc_stop"
made some trivial changes but was missing a ';' character.

8c4cc00552 "ARM: OMAP1: DMA: Moving OMAP1 DMA channel definitions
to mach-omap1" added a definition for OMAP_DMA_USB_W2FC_TX0 to
the driver while making the header file it was defined in
unavailable for drivers, but this driver actually needs
OMAP_DMA_USB_W2FC_RX0 as well.

Both changes appear trivial, so let's add the missing semicolon
and the macro definition.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/omap_udc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 06be85c..f844565 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -62,6 +62,7 @@
 #define	DRIVER_VERSION	"4 October 2004"
 
 #define OMAP_DMA_USB_W2FC_TX0		29
+#define OMAP_DMA_USB_W2FC_RX0		26
 
 /*
  * The OMAP UDC needs _very_ early endpoint setup:  before enabling the
@@ -1310,7 +1311,7 @@ static int omap_pullup(struct usb_gadget *gadget, int is_on)
 }
 
 static int omap_udc_start(struct usb_gadget *g,
-		struct usb_gadget_driver *driver)
+		struct usb_gadget_driver *driver);
 static int omap_udc_stop(struct usb_gadget *g,
 		struct usb_gadget_driver *driver);
 
-- 
1.8.1.2

