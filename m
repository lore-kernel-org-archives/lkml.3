Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3AaMas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:30:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3AaMap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:30:45 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Stehle <v-stehle@ti.com>
Subject: [PATCH] USB: musb: Correct Kconfig in order to avoid non compilable selection
Date: Thu, 31 Jan 2013 13:30:40 +0100
Message-ID: <1359635440-20322-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is possible to have:
USB_MUSB_OMAP2PLUS=m
TWL4030_USB=y

which would result compile time error due to missing symbols.

With this change USB_MUSB_OMAP2PLUS and TWL4030_USB will be in sync.

Reported-by: Vincent Stehle <v-stehle@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Felipe,

I have also noticed that we have similar issue around USB_MUSB_HDRC,
CONFIG_USB_MUSB_TUSB6010 and CONFIG_USB_TUSB_OMAP_DMA. You can easily have a
combination of y/m of these to have non compilable kernel.
I have tried to fix it but my Kconfig skills are not adequate for it ;)

Regards,
Peter

 drivers/usb/musb/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 23a0b7f..a3fa19c 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -9,8 +9,6 @@ config USB_MUSB_HDRC
 	depends on USB && USB_GADGET
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
 	select NOP_USB_XCEIV if (SOC_TI81XX || SOC_AM33XX)
-	select TWL4030_USB if MACH_OMAP_3430SDP
-	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
@@ -49,6 +47,8 @@ config USB_MUSB_TUSB6010
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
 	depends on ARCH_OMAP2PLUS
+	select TWL4030_USB if MACH_OMAP_3430SDP
+	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 
 config USB_MUSB_AM35X
 	tristate "AM35x"
-- 
1.8.1.1

