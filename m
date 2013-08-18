Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3HRUVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:21:04 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:39758 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3HRUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:21:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] usb: gadget: USB_FUSB300 should depend on HAS_DMA
Date: Sun, 18 Aug 2013 22:20:41 +0200
Message-Id: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `fusb300_set_idma':
drivers/usb/gadget/fusb300_udc.c:946: undefined reference to `usb_gadget_map_request'
drivers/usb/gadget/fusb300_udc.c:958: undefined reference to `usb_gadget_unmap_request'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8e93683..d2e6f4f 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -188,7 +188,7 @@ config USB_FSL_USB2
 
 config USB_FUSB300
 	tristate "Faraday FUSB300 USB Peripheral Controller"
-	depends on !PHYS_ADDR_T_64BIT
+	depends on !PHYS_ADDR_T_64BIT && HAS_DMA
 	help
 	   Faraday usb device controller FUSB300 driver
 
-- 
1.7.9.5

