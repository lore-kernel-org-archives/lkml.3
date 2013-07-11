Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3GKNyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:12 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:45007 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab3GKNyK (ORCPT
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
Subject: [PATCH 4/6] usb: gadget: USB_FOTG210_UDC should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:03 +0200
Message-Id: <1373550845-14457-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
References: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `fotg210_start_dma':
drivers/usb/gadget/fotg210-udc.c:354: undefined reference to `dma_map_single'
drivers/usb/gadget/fotg210-udc.c:357: undefined reference to `dma_mapping_error'
drivers/usb/gadget/fotg210-udc.c:362: undefined reference to `dma_sync_single_for_cpu'
drivers/usb/gadget/fotg210-udc.c:376: undefined reference to `dma_unmap_single'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 95375d1..8743742 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -193,6 +193,7 @@ config USB_FUSB300
 	   Faraday usb device controller FUSB300 driver
 
 config USB_FOTG210_UDC
+	depends on HAS_DMA
 	tristate "Faraday FOTG210 USB Peripheral Controller"
 	help
 	   Faraday USB2.0 OTG controller which can be configured as
-- 
1.7.9.5

