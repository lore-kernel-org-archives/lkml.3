Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3EPLX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:23:58 -0400
Received: from sauhun.de ([89.238.76.85]:56109 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab3EPLOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:52 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/33] drivers/mfd: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:38 +0200
Message-Id: <1368702961-4325-11-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mfd/intel_msic.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 5be3b5e..d8d5137 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -414,11 +414,6 @@ static int intel_msic_probe(struct platform_device *pdev)
 	 * the clients via intel_msic_irq_read().
 	 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get SRAM iomem resource\n");
-		return -ENODEV;
-	}
-
 	msic->irq_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(msic->irq_base))
 		return PTR_ERR(msic->irq_base);
-- 
1.7.10.4

