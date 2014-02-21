Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaBUTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:50:30 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47023 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbaBUTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:49:59 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: musb: USB_MUSB_DUAL_ROLE/USB_MUSB_GADGET should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:49:53 +0100
Message-Id: <1393012193-22177-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `txstate':
    musb_gadget.c:(.text+0x35955a): undefined reference to `dma_unmap_single'
    musb_gadget.c:(.text+0x35957e): undefined reference to `dma_sync_single_for_cpu'
    drivers/built-in.o: In function `musb_g_giveback':
    (.text+0x359672): undefined reference to `dma_mapping_error'
    drivers/built-in.o: In function `musb_g_giveback':
    (.text+0x3596ba): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `musb_g_giveback':
    (.text+0x3596e0): undefined reference to `dma_sync_single_for_cpu'
    drivers/built-in.o: In function `rxstate':
    musb_gadget.c:(.text+0x3599d0): undefined reference to `dma_unmap_single'
    musb_gadget.c:(.text+0x3599f6): undefined reference to `dma_sync_single_for_cpu'
    drivers/built-in.o: In function `musb_gadget_queue':
    musb_gadget.c:(.text+0x35a8c0): undefined reference to `dma_map_single'
    musb_gadget.c:(.text+0x35a8d0): undefined reference to `dma_mapping_error'
    musb_gadget.c:(.text+0x35a906): undefined reference to `dma_sync_single_for_cpu'
    musb_gadget.c:(.text+0x35a9a0): undefined reference to `dma_unmap_single'
    musb_gadget.c:(.text+0x35a9c8): undefined reference to `dma_sync_single_for_cpu'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/musb/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 688dc8bb192d..8b789792f6fa 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -43,6 +43,7 @@ config USB_MUSB_HOST
 config USB_MUSB_GADGET
 	bool "Gadget only mode"
 	depends on USB_GADGET=y || USB_GADGET=USB_MUSB_HDRC
+	depends on HAS_DMA
 	help
 	  Select this when you want to use MUSB in gadget mode only,
 	  thereby the host feature will be regressed.
@@ -50,6 +51,7 @@ config USB_MUSB_GADGET
 config USB_MUSB_DUAL_ROLE
 	bool "Dual Role mode"
 	depends on ((USB=y || USB=USB_MUSB_HDRC) && (USB_GADGET=y || USB_GADGET=USB_MUSB_HDRC))
+	depends on HAS_DMA
 	help
 	  This is the default mode of working of MUSB controller where
 	  both host and gadget features are enabled.
-- 
1.7.9.5

