Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3GKNyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:14 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:38702 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3GKNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:54:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/6] usb: gadget: USB_MV_UDC should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:02 +0200
Message-Id: <1373550845-14457-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
References: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `done':
drivers/usb/gadget/mv_udc_core.c:239: undefined reference to `dma_pool_free'
drivers/built-in.o: In function `build_dtd':
drivers/usb/gadget/mv_udc_core.c:371: undefined reference to `dma_pool_alloc'
drivers/built-in.o: In function `udc_prime_status':
drivers/usb/gadget/mv_udc_core.c:1465: undefined reference to `dma_map_single'
drivers/built-in.o: In function `mv_udc_remove':
drivers/usb/gadget/mv_udc_core.c:2087: undefined reference to `dma_pool_destroy'
drivers/usb/gadget/mv_udc_core.c:2090: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `mv_udc_probe':
drivers/usb/gadget/mv_udc_core.c:2190: undefined reference to `dma_alloc_coherent'
drivers/usb/gadget/mv_udc_core.c:2201: undefined reference to `dma_pool_create'
drivers/usb/gadget/mv_udc_core.c:2315: undefined reference to `dma_pool_destroy'
drivers/usb/gadget/mv_udc_core.c:2317: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 62f6802..95375d1 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -328,7 +328,7 @@ config USB_S3C_HSUDC
 
 config USB_MV_UDC
 	tristate "Marvell USB2.0 Device Controller"
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && HAS_DMA
 	help
 	  Marvell Socs (including PXA and MMP series) include a high speed
 	  USB2.0 OTG controller, which can be configured as high speed or
-- 
1.7.9.5

