Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3CKUOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:14:48 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57020 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab3CKUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:14:47 -0400
Message-ID: <1363032881.3137.101.camel@x61.thuisdomein>
Subject: [PATCH] usb: gadget: remove MACH_OMAP_H4_OTG
From: Paul Bolle <pebolle@tiscali.nl>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 21:14:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 20:14:41.0925 (UTC) FILETIME=[10AFF350:01CE1E95]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig option MACH_OMAP_H4_OTG was already considered dead as of
v2.6.36, as can be seen in commit
267ecec95f7d215d2da38252640b06198515acc3 ("Removing dead
MACH_OMAP_H4_OTG"). Remove its last trace now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=arm menuconfig" (specifically whether setting
either MACH_OMAP_H2 or MACH_OMAP_H3 still selected ISP1301_OMAP).

1) By the way "if ARCH_OMAP" on the next line seems superfluous, as
ARCH_OMAP1 already selects ARCH_OMAP. Minor nit, actually.

 drivers/usb/gadget/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 5a0c541..c65b5e2 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -194,7 +194,7 @@ config USB_FUSB300
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
-	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
+	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	select USB_OTG_UTILS if ARCH_OMAP
 	help
 	   Many Texas Instruments OMAP processors have flexible full
-- 
1.7.11.7

