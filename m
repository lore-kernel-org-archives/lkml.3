Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3JLEhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:37:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54088 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750727Ab3JLEhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:37:47 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] drivers: bus: omap_l3: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:37:32 +0200
Message-Id: <1381552652-6449-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/bus/omap_l3_noc.c | 4 ++--
 drivers/bus/omap_l3_smx.c | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..6ada27a 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -187,7 +187,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = request_irq(l3->debug_irq,
 			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-dbg-irq", l3);
+			0, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
@@ -197,7 +197,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = request_irq(l3->app_irq,
 			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-app-irq", l3);
+			0, "l3-app-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->app_irq);
diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc2164..769d64c 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -238,8 +238,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = request_irq(l3->debug_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-debug-irq", l3);
+		IRQF_TRIGGER_RISING, "l3-debug-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request debug irq\n");
 		goto err1;
@@ -247,8 +246,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = request_irq(l3->app_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-app-irq", l3);
+		IRQF_TRIGGER_RISING, "l3-app-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request app irq\n");
 		goto err2;
-- 
1.8.1.2

