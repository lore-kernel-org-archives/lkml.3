Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbaFZRUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:20:02 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:36229 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684AbaFZRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:20:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KANtVrFNXQz8N/2dsb2JhbABagw2rRQUBAQEBAQEFAW2Yf4ENF3WEMS8jgRo3iEYBwhcXhWSJHB2ELQWaWYs6iDuCAIFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/1] drivers/usb/host/fhci-dbg.c: remove unnecessary null test before debugfs_remove
Date: Thu, 26 Jun 2014 19:18:38 +0200
Message-Id: <1403803118-8798-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch warning:
"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/host/fhci-dbg.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/fhci-dbg.c b/drivers/usb/host/fhci-dbg.c
index f238cb3..b58e7a6 100644
--- a/drivers/usb/host/fhci-dbg.c
+++ b/drivers/usb/host/fhci-dbg.c
@@ -129,11 +129,7 @@ void fhci_dfs_destroy(struct fhci_hcd *fhci)
 	if (!fhci->dfs_root)
 		return;
 
-	if (fhci->dfs_irq_stat)
-		debugfs_remove(fhci->dfs_irq_stat);
-
-	if (fhci->dfs_regs)
-		debugfs_remove(fhci->dfs_regs);
-
+	debugfs_remove(fhci->dfs_irq_stat);
+	debugfs_remove(fhci->dfs_regs);
 	debugfs_remove(fhci->dfs_root);
 }
-- 
1.8.4.5

