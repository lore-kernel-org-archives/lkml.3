Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3HRUVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:21:05 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42134 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3HRUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:21:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/4] usb: gadget: USB_NET2272_DMA should depend on HAS_DMA
Date: Sun, 18 Aug 2013 22:20:43 +0200
Message-Id: <1376857245-2088-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `net2272_done':
drivers/usb/gadget/net2272.c:386: undefined reference to `usb_gadget_unmap_request'
drivers/built-in.o: In function `net2272_queue':
drivers/usb/gadget/net2272.c:848: undefined reference to `usb_gadget_map_request'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3c1cadd..324dc61 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -403,7 +403,7 @@ config USB_NET2272
 
 config USB_NET2272_DMA
 	boolean "Support external DMA controller"
-	depends on USB_NET2272
+	depends on USB_NET2272 && HAS_DMA
 	help
 	  The NET2272 part can optionally support an external DMA
 	  controller, but your board has to have support in the
-- 
1.7.9.5

