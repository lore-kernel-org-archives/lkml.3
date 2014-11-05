Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaKEBUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:20:09 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53460 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaKEBTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:19:34 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 09/10] fotg210: Use ehci_dbg_port struct
Date: Tue,  4 Nov 2014 19:18:53 -0600
Message-Id: <1415150334-2402-10-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415150334-2402-1-git-send-email-chris@rorvick.com>
References: <1415150334-2402-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FUSBH200 debug port has a EHCI-compatible register layout so there
is no need to define a custom struct.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fotg210.h | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index 975d9bb..3bad178 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -86,7 +86,7 @@ struct fotg210_hcd {			/* one per controller */
 	/* glue to PCI and HCD framework */
 	struct fotg210_caps __iomem *caps;
 	struct fotg210_regs __iomem *regs;
-	struct fotg210_dbg_port __iomem *debug;
+	struct ehci_dbg_port __iomem *debug;
 
 	__u32			hcs_params;	/* cached register copy */
 	spinlock_t		lock;
@@ -295,17 +295,6 @@ struct fotg210_regs {
 #define GMIR_MDEV_INT	(1 << 0)
 };
 
-/* Appendix C, Debug port ... intended for use with special "debug devices"
- * that can help if there's no serial console.  (nonstandard enumeration.)
- */
-struct fotg210_dbg_port {
-	u32	control;
-	u32	pids;
-	u32	data03;
-	u32	data47;
-	u32	address;
-};
-
 /*-------------------------------------------------------------------------*/
 
 #define	QTD_NEXT(fotg210, dma)	cpu_to_hc32(fotg210, (u32)dma)
-- 
1.9.3

