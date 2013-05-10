Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3EJIQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:33 -0400
Received: from sauhun.de ([89.238.76.85]:60367 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3EJIQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:30 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 07/42] drivers/gpu/host1x: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:52 +0200
Message-Id: <1368173847-5661-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/host1x/dev.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 28e28a2..e615edd 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -98,12 +98,6 @@ static int host1x_probe(struct platform_device *pdev)
 	if (!id)
 		return -EINVAL;
 
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_err(&pdev->dev, "failed to get registers\n");
-		return -ENXIO;
-	}
-
 	syncpt_irq = platform_get_irq(pdev, 0);
 	if (syncpt_irq < 0) {
 		dev_err(&pdev->dev, "failed to get IRQ\n");
@@ -120,6 +114,7 @@ static int host1x_probe(struct platform_device *pdev)
 	/* set common host1x device data */
 	platform_set_drvdata(pdev, host);
 
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->regs = devm_ioremap_resource(&pdev->dev, regs);
 	if (IS_ERR(host->regs))
 		return PTR_ERR(host->regs);
-- 
1.7.10.4

