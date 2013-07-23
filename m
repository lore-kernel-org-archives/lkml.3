Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab3GWSDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:00 -0400
Received: from sauhun.de ([89.238.76.85]:58725 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922Ab3GWSC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:58 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 09/27] drivers/media/platform: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:42 +0200
Message-Id: <1374602524-3398-10-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/media/platform/coda.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index df4ada88..6ea4717 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2032,11 +2032,6 @@ static int coda_probe(struct platform_device *pdev)
 
 	/* Get  memory for physical registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
-
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(dev->regs_base))
 		return PTR_ERR(dev->regs_base);
-- 
1.7.10.4

