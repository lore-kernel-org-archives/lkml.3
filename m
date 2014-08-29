Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaH2Tbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:31:45 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:55621 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaH2Tbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:31:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: gadget: USB_RENESAS_USBHS_UDC should depend on HAS_DMA
Date: Fri, 29 Aug 2014 21:31:40 +0200
Message-Id: <1409340700-2033-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `usbhsg_dma_map_ctrl':
mod_gadget.c:(.text+0x53b226): undefined reference to `usb_gadget_map_request'
mod_gadget.c:(.text+0x53b242): undefined reference to `usb_gadget_unmap_request'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/udc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 5151f947a4f5..00171d436cf8 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -163,7 +163,7 @@ config USB_R8A66597
 
 config USB_RENESAS_USBHS_UDC
 	tristate 'Renesas USBHS controller'
-	depends on USB_RENESAS_USBHS
+	depends on USB_RENESAS_USBHS && HAS_DMA
 	help
 	   Renesas USBHS is a discrete USB host and peripheral controller chip
 	   that supports both full and high speed USB 2.0 data transfers.
-- 
1.9.1

