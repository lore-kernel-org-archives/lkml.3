Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3GKNyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:17 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:39177 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3GKNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:54:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/6] usb: dwc3: USB_DWC3 should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:00 +0200
Message-Id: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `dwc3_free_one_event_buffer':
drivers/usb/dwc3/core.c:132: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `dwc3_alloc_one_event_buffer':
drivers/usb/dwc3/core.c:154: undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `dma_set_coherent_mask':
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
drivers/built-in.o: In function `dwc3_free_trb_pool':
drivers/usb/dwc3/gadget.c:407: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `dwc3_gadget_exit':
drivers/usb/dwc3/gadget.c:2693: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `dwc3_alloc_trb_pool':
drivers/usb/dwc3/gadget.c:391: undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `dwc3_gadget_init':
drivers/usb/dwc3/gadget.c:2598: undefined reference to `dma_alloc_coherent'
drivers/usb/dwc3/gadget.c:2667: undefined reference to `dma_free_coherent'
drivers/usb/dwc3/gadget.c:2674: undefined reference to `dma_free_coherent'
drivers/usb/dwc3/gadget.c:2678: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/dwc3/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 757aa18..2378958 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,6 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
-	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS
+	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
-- 
1.7.9.5

