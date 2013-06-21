Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423362Ab3FUI3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:29:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43991 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423228Ab3FUI3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:29:16 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: host: xhci-plat: release mem region while removing module
Date: Fri, 21 Jun 2013 13:59:08 +0530
Message-ID: <1371803348-9807-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a release_mem_region of the hcd resource. Without this the
subsequent insertion of module fails in request_mem_region.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..93ad67e 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -179,6 +179,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
-- 
1.8.1.4

