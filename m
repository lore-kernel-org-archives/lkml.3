Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3JFGsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:48:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51269 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586Ab3JFGsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:48:04 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: stern@rowland.harvard.edu, linux@prisktech.co.nz,
        gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] usb: host: uhci-platform: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 08:47:55 +0200
Message-Id: <1381042075-13011-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/usb/host/uhci-platform.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index d033a0e..ded842b 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -105,8 +105,7 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 
 	uhci->regs = hcd->regs;
 
-	ret = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED |
-								IRQF_SHARED);
+	ret = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
 	if (ret)
 		goto err_uhci;
 
-- 
1.8.1.2

