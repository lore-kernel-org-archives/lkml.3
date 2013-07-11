Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3GKN4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:56:46 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:39173 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3GKNyL (ORCPT
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
Subject: [PATCH 5/6] usb: gadget: USB_MV_U3D should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:04 +0200
Message-Id: <1373550845-14457-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
References: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `mv_u3d_done':
drivers/usb/gadget/mv_u3d_core.c:206: undefined reference to `dma_pool_free'
drivers/usb/gadget/mv_u3d_core.c:209: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `mv_u3d_build_trb_one':
drivers/usb/gadget/mv_u3d_core.c:311: undefined reference to `dma_pool_alloc'
drivers/built-in.o: In function `mv_u3d_req_to_trb':
drivers/usb/gadget/mv_u3d_core.c:480: undefined reference to `dma_map_single'
drivers/built-in.o: In function `mv_u3d_remove':
drivers/usb/gadget/mv_u3d_core.c:1770: undefined reference to `dma_pool_destroy'
drivers/usb/gadget/mv_u3d_core.c:1773: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `mv_u3d_probe':
drivers/usb/gadget/mv_u3d_core.c:1880: undefined reference to `dma_alloc_coherent'
drivers/usb/gadget/mv_u3d_core.c:1890: undefined reference to `dma_pool_create'
drivers/usb/gadget/mv_u3d_core.c:1984: undefined reference to `dma_pool_destroy'
drivers/usb/gadget/mv_u3d_core.c:1986: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8743742..3f8df56 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -336,6 +336,7 @@ config USB_MV_UDC
 	  full speed USB peripheral.
 
 config USB_MV_U3D
+	depends on HAS_DMA
 	tristate "MARVELL PXA2128 USB 3.0 controller"
 	help
 	  MARVELL PXA2128 Processor series include a super speed USB3.0 device
-- 
1.7.9.5

