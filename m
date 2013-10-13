Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab3JMFAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:00:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56098 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791Ab3JMFAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:00:05 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linus.walleij@linaro.org, vinod.koul@intel.com, dan.j.williams@intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] dma: coh901318: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:00:00 +0200
Message-Id: <1381640400-7146-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/dma/coh901318.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 31011d2..3025b91 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -2694,7 +2694,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, IRQF_DISABLED,
+	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, 0,
 			       "coh901318", base);
 	if (err)
 		return err;
-- 
1.8.1.2

