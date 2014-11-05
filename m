Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaKEBTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:19:35 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50502 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaKEBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:19:32 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 08/10] fotg210: Remove duplicate ehci-dbgp declarations
Date: Tue,  4 Nov 2014 19:18:52 -0600
Message-Id: <1415150334-2402-9-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415150334-2402-1-git-send-email-chris@rorvick.com>
References: <1415150334-2402-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ehci-dbgp has its own header, use it rather than duplicating
the declarations, etc.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fotg210.h | 40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index c2e5134..975d9bb 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_FOTG210_H
 #define __LINUX_FOTG210_H
 
+#include <linux/usb/ehci-dbgp.h>
+
 /* definitions used for the EHCI driver */
 
 /*
@@ -304,44 +306,6 @@ struct fotg210_dbg_port {
 	u32	address;
 };
 
-#ifdef CONFIG_EARLY_PRINTK_DBGP
-#include <linux/init.h>
-extern int __init early_dbgp_init(char *s);
-extern struct console early_dbgp_console;
-#endif /* CONFIG_EARLY_PRINTK_DBGP */
-
-struct usb_hcd;
-
-#ifdef CONFIG_XEN_DOM0
-extern int xen_dbgp_reset_prep(struct usb_hcd *);
-extern int xen_dbgp_external_startup(struct usb_hcd *);
-#else
-static inline int xen_dbgp_reset_prep(struct usb_hcd *hcd)
-{
-	return 1; /* Shouldn't this be 0? */
-}
-
-static inline int xen_dbgp_external_startup(struct usb_hcd *hcd)
-{
-	return -1;
-}
-#endif
-
-#ifdef CONFIG_EARLY_PRINTK_DBGP
-/* Call backs from fotg210 host driver to fotg210 debug driver */
-extern int dbgp_external_startup(struct usb_hcd *);
-extern int dbgp_reset_prep(struct usb_hcd *hcd);
-#else
-static inline int dbgp_reset_prep(struct usb_hcd *hcd)
-{
-	return xen_dbgp_reset_prep(hcd);
-}
-static inline int dbgp_external_startup(struct usb_hcd *hcd)
-{
-	return xen_dbgp_external_startup(hcd);
-}
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 #define	QTD_NEXT(fotg210, dma)	cpu_to_hc32(fotg210, (u32)dma)
-- 
1.9.3

