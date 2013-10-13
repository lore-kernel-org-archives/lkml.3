Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3JMHUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 03:20:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753781Ab3JMHUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 03:20:21 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: zbr@ioremap.net
Cc: gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] w1: omap-hdq: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 09:20:05 +0200
Message-Id: <1381648805-3372-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/w1/masters/omap_hdq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 6e94d8dd..9900e8e 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -577,8 +577,7 @@ static int omap_hdq_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	ret = devm_request_irq(dev, irq, hdq_isr, IRQF_DISABLED,
-			"omap_hdq", hdq_data);
+	ret = devm_request_irq(dev, irq, hdq_isr, 0, "omap_hdq", hdq_data);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
 		goto err_irq;
-- 
1.8.1.2

