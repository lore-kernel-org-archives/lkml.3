Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3HRUVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:21:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:50469 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3HRUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:21:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] usb: chipidea: USB_CHIPIDEA should depend on HAS_DMA
Date: Sun, 18 Aug 2013 22:20:44 +0200
Message-Id: <1376857245-2088-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `dma_set_coherent_mask':
include/linux/dma-mapping.h:93: undefined reference to `dma_supported'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/usb/chipidea/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index d1bd8ef..dbd5232 100644
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -1,6 +1,6 @@
 config USB_CHIPIDEA
 	tristate "ChipIdea Highspeed Dual Role Controller"
-	depends on USB || USB_GADGET
+	depends on (USB || USB_GADGET) && HAS_DMA
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on ChipIdea silicon IP. Currently, only the
-- 
1.7.9.5

