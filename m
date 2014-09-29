Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaI2Evo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:51:44 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61624 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaI2Eti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:49:38 -0400
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 05/10] fusbh200: Use ehci_dbg_port struct
Date: Sun, 28 Sep 2014 23:48:53 -0500
Message-Id: <1411966138-3053-6-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411966138-3053-1-git-send-email-chris@rorvick.com>
References: <1411966138-3053-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FUSBH200 debug port has a EHCI-compatible register layout so there
is no need to define a custom struct.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fusbh200.h | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/usb/host/fusbh200.h b/drivers/usb/host/fusbh200.h
index 47aecfc..d6e5b3d 100644
--- a/drivers/usb/host/fusbh200.h
+++ b/drivers/usb/host/fusbh200.h
@@ -86,7 +86,7 @@ struct fusbh200_hcd {			/* one per controller */
 	/* glue to PCI and HCD framework */
 	struct fusbh200_caps __iomem *caps;
 	struct fusbh200_regs __iomem *regs;
-	struct fusbh200_dbg_port __iomem *debug;
+	struct ehci_dbg_port __iomem *debug;
 
 	__u32			hcs_params;	/* cached register copy */
 	spinlock_t		lock;
@@ -287,17 +287,6 @@ struct fusbh200_regs {
 #define BMIER_VBUS_ERR_EN	(1<<0)
 };
 
-/* Appendix C, Debug port ... intended for use with special "debug devices"
- * that can help if there's no serial console.  (nonstandard enumeration.)
- */
-struct fusbh200_dbg_port {
-	u32	control;
-	u32	pids;
-	u32	data03;
-	u32	data47;
-	u32	address;
-};
-
 /*-------------------------------------------------------------------------*/
 
 #define	QTD_NEXT(fusbh200, dma)	cpu_to_hc32(fusbh200, (u32)dma)
-- 
1.9.3

