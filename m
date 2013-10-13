Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3JMHXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 03:23:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56369 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180Ab3JMHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 03:23:45 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: zbr@ioremap.net
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] w1: ds1wm: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 09:23:27 +0200
Message-Id: <1381649007-3429-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/w1/masters/ds1wm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 96cab6a..41613f9 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -498,7 +498,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
 	ret = devm_request_irq(&pdev->dev, ds1wm_data->irq, ds1wm_isr,
-			IRQF_DISABLED | IRQF_SHARED, "ds1wm", ds1wm_data);
+			IRQF_SHARED, "ds1wm", ds1wm_data);
 	if (ret)
 		return ret;
 
-- 
1.8.1.2

