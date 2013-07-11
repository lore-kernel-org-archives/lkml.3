Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3GKNyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:15 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:44922 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3GKNyK (ORCPT
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
Subject: [PATCH 2/6] usb: chipidea: USB_CHIPIDEA_UDC should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:01 +0200
Message-Id: <1373550845-14457-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
References: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `dma_set_coherent_mask':
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
drivers/built-in.o: In function `destroy_eps':
drivers/usb/chipidea/udc.c:1598: undefined reference to `dma_pool_free'
drivers/built-in.o: In function `free_pending_td':
drivers/usb/chipidea/udc.c:540: undefined reference to `dma_pool_free'
drivers/built-in.o: In function `add_td_to_list':
drivers/usb/chipidea/udc.c:383: undefined reference to `dma_pool_alloc'
drivers/built-in.o: In function `_ep_nuke':
drivers/usb/chipidea/udc.c:639: undefined reference to `dma_pool_free'
drivers/built-in.o: In function `udc_stop':
drivers/usb/chipidea/udc.c:1855: undefined reference to `dma_pool_destroy'
drivers/built-in.o: In function `init_eps':
drivers/usb/chipidea/udc.c:1564: undefined reference to `dma_pool_alloc'
drivers/built-in.o: In function `udc_start':
drivers/usb/chipidea/udc.c:1766: undefined reference to `dma_pool_create'
drivers/usb/chipidea/udc.c:1835: undefined reference to `dma_pool_destroy'
drivers/usb/chipidea/udc.c:1837: undefined reference to `dma_pool_destroy'
drivers/built-in.o: In function `ep_free_request':
drivers/usb/chipidea/udc.c:1268: undefined reference to `dma_pool_free'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/chipidea/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index eb2aa2e..189dbc6 100644
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -12,7 +12,7 @@ if USB_CHIPIDEA
 
 config USB_CHIPIDEA_UDC
 	bool "ChipIdea device controller"
-	depends on USB_GADGET=y || USB_CHIPIDEA=m
+	depends on (USB_GADGET=y || USB_CHIPIDEA=m) && HAS_DMA
 	help
 	  Say Y here to enable device controller functionality of the
 	  ChipIdea driver.
-- 
1.7.9.5

