Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaJIOPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:15:12 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:44959 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:15:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: gadget: USB_GADGET_XILINX should depend on HAS_DMA
Date: Thu,  9 Oct 2014 16:15:05 +0200
Message-Id: <1412864105-21411-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `xudc_done':
udc-xilinx.c:(.text+0x54f4d2): undefined reference to `usb_gadget_unmap_request'
drivers/built-in.o: In function `xudc_dma_send':
udc-xilinx.c:(.text+0x54f9f8): undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `xudc_read_fifo':
udc-xilinx.c:(.text+0x54ff4a): undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `xudc_ep_queue':
udc-xilinx.c:(.text+0x550e7c): undefined reference to `usb_gadget_map_request'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/udc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 3ea287b0e448a1e5..217365d35a2523e6 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -357,6 +357,7 @@ config USB_EG20T
 
 config USB_GADGET_XILINX
 	tristate "Xilinx USB Driver"
+	depends on HAS_DMA
 	depends on OF || COMPILE_TEST
 	help
 	  USB peripheral controller driver for Xilinx USB2 device.
-- 
1.9.1

