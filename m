Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3JFGok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:44:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51263 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355Ab3JFGoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:44:39 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] usb: gadget: mv_u3d_core: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 08:44:35 +0200
Message-Id: <1381041875-12949-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.
Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/usb/gadget/mv_u3d_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index 561b30e..5b06c98 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -1936,7 +1936,7 @@ static int mv_u3d_probe(struct platform_device *dev)
 	}
 	u3d->irq = r->start;
 	if (request_irq(u3d->irq, mv_u3d_irq,
-		IRQF_DISABLED | IRQF_SHARED, driver_name, u3d)) {
+		IRQF_SHARED, driver_name, u3d)) {
 		u3d->irq = 0;
 		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
 			u3d->irq);
-- 
1.8.1.2

