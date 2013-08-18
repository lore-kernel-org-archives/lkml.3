Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3HRUVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:21:03 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55430 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3HRUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:21:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] usb: gadget: USB_R8A66597 should depend on HAS_DMA
Date: Sun, 18 Aug 2013 22:20:42 +0200
Message-Id: <1376857245-2088-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `sudmac_free_channel':
drivers/usb/gadget/r8a66597-udc.c:676: undefined reference to `usb_gadget_unmap_request'
drivers/built-in.o: In function `sudmac_alloc_channel':
drivers/usb/gadget/r8a66597-udc.c:666: undefined reference to `usb_gadget_map_request'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index d2e6f4f..3c1cadd 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -246,6 +246,7 @@ config USB_PXA25X_SMALL
 
 config USB_R8A66597
 	tristate "Renesas R8A66597 USB Peripheral Controller"
+	depends on HAS_DMA
 	help
 	   R8A66597 is a discrete USB host and peripheral controller chip that
 	   supports both full and high speed USB 2.0 data transfers.
-- 
1.7.9.5

