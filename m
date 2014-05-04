Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaEDI5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 04:57:34 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57021 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbaEDI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 04:57:33 -0400
Message-ID: <1399193850.8729.4.camel@x220>
Subject: [PATCH] usb: musb: tusb: remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 04 May 2014 10:57:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2014 08:57:30.0699 (UTC) FILETIME=[E1AC21B0:01CF6776]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

musb_in_tusb() is always set to 0, because CONFIG_USB_TUSB6010 is never
set (it should have been CONFIG_USB_MUSB_TUSB6010). But musb_in_tusb()
is unused anyway, so remove a few lines of dead code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Usb, musb, and tusb! Is somebody sneaking nursery rhymes in the kernel
tree? Anyhow, this patch is tested with git grep only.

 drivers/usb/musb/tusb6010.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/musb/tusb6010.h b/drivers/usb/musb/tusb6010.h
index 35c933a5d991..1864e24ac965 100644
--- a/drivers/usb/musb/tusb6010.h
+++ b/drivers/usb/musb/tusb6010.h
@@ -14,12 +14,6 @@
 
 extern u8 tusb_get_revision(struct musb *musb);
 
-#ifdef CONFIG_USB_TUSB6010
-#define musb_in_tusb()			1
-#else
-#define musb_in_tusb()			0
-#endif
-
 #ifdef CONFIG_USB_TUSB_OMAP_DMA
 #define tusb_dma_omap()			1
 #else
-- 
1.9.0

