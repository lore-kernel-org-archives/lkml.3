Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3GKNyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:16 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:44923 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3GKNyK (ORCPT
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
Subject: [PATCH 6/6] [RFC] usb: gadget: USB_GADGET should depend on HAS_DMA
Date: Thu, 11 Jul 2013 15:54:05 +0200
Message-Id: <1373550845-14457-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
References: <1373550845-14457-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `dma_set_coherent_mask':
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
drivers/built-in.o: In function `usb_gadget_unmap_request':
drivers/usb/gadget/udc-core.c:91: undefined reference to `dma_unmap_sg'
drivers/usb/gadget/udc-core.c:96: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `usb_gadget_map_request':
drivers/usb/gadget/udc-core.c:62: undefined reference to `dma_map_sg'
drivers/usb/gadget/udc-core.c:71: undefined reference to `dma_map_single'
drivers/usb/gadget/udc-core.c:74: undefined reference to `dma_mapping_error'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This one is very debatable: probably the parts using the DMA API should
be factored out, instead of disabling the whole USB gadget subsystem.

 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3f8df56..a88fc47 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -15,6 +15,7 @@
 
 menuconfig USB_GADGET
 	tristate "USB Gadget Support"
+	depends on HAS_DMA
 	select NLS
 	help
 	   USB is a master/slave protocol, organized with one master
-- 
1.7.9.5

