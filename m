Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3CZSOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:14:10 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63703 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3CZSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:14:09 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv2] usb: ehci: unlink_empty_async_suspended() only used with CONFIG_PM
Date: Wed, 27 Mar 2013 07:14:33 +1300
Message-Id: <1364321673-2030-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling with !CONFIG_PM generates an unused function warning on
unlink_empty_async_suspended().

Enclose the function in a #ifdef CONFIG_PM

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Fixed up the commit message.
 drivers/usb/host/ehci-q.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 23d1369..3638b28 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1316,6 +1316,7 @@ static void unlink_empty_async(struct ehci_hcd *ehci)
 	}
 }
 
+#ifdef CONFIG_PM
 /* The root hub is suspended; unlink all the async QHs */
 static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
 {
@@ -1328,7 +1329,7 @@ static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
 	}
 	start_iaa_cycle(ehci, false);
 }
-
+#endif
 /* makes sure the async qh will become idle */
 /* caller must own ehci->lock */
 
-- 
1.7.9.5

