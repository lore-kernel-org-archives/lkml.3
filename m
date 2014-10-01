Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaJAKPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:15:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33370 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbaJAKPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:15:14 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: nm@ti.com, peter.ujfalusi@ti.com, santosh.shilimkar@ti.com,
        tony@atomide.com, rnayak@ti.com, r.sricharan@ti.com, afzal@ti.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] drivers: bus: omap_l3: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 12:15:07 +0200
Message-Id: <1412158507-7229-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395130217-17828-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1395130217-17828-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from drivers/bus/omap_l3_*

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/bus/omap_l3_noc.c | 4 ++--
 drivers/bus/omap_l3_smx.c | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 531ae591783b..547a0fdba583 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -280,7 +280,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(l3->dev, l3->debug_irq, l3_interrupt_handler,
-			       IRQF_DISABLED, "l3-dbg-irq", l3);
+			       0, "l3-dbg-irq", l3);
 	if (ret) {
 		dev_err(l3->dev, "request_irq failed for %d\n",
 			l3->debug_irq);
@@ -289,7 +289,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = devm_request_irq(l3->dev, l3->app_irq, l3_interrupt_handler,
-			       IRQF_DISABLED, "l3-app-irq", l3);
+			       0, "l3-app-irq", l3);
 	if (ret)
 		dev_err(l3->dev, "request_irq failed for %d\n", l3->app_irq);
 
diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc216491b8a..769d64c0b0fe 100644
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
1.9.1

