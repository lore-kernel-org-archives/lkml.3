Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3C0F1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 01:27:51 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58063 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3C0F1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 01:27:49 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv2] usb: ehci: unlink_empty_async_suspended() only used with CONFIG_PM
Date: Wed, 27 Mar 2013 18:28:00 +1300
Message-Id: <1364362080-8489-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling with !CONFIG_PM generates an unused function warning on
unlink_empty_async_suspended().

Enclose the function in a #ifdef CONFIG_PM

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
v2:
Tidy up blank line as requested by Alan Stern
 drivers/usb/host/ehci-q.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 23d1369..1ea4de1 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1316,6 +1316,7 @@ static void unlink_empty_async(struct ehci_hcd *ehci)
 	}
 }
 
+#ifdef CONFIG_PM
 /* The root hub is suspended; unlink all the async QHs */
 static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
 {
@@ -1328,6 +1329,7 @@ static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
 	}
 	start_iaa_cycle(ehci, false);
 }
+#endif
 
 /* makes sure the async qh will become idle */
 /* caller must own ehci->lock */
-- 
1.7.9.5

