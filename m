Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3EPLPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:37 -0400
Received: from sauhun.de ([89.238.76.85]:56257 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3EPLPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:33 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 27/33] drivers/w1/masters: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:55 +0200
Message-Id: <1368702961-4325-28-git-send-email-wsa@the-dreams.de>
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
 drivers/w1/masters/omap_hdq.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index db2390a..6e94d8dd 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -555,11 +555,6 @@ static int omap_hdq_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, hdq_data);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_dbg(&pdev->dev, "unable to get resource\n");
-		return -ENXIO;
-	}
-
 	hdq_data->hdq_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(hdq_data->hdq_base))
 		return PTR_ERR(hdq_data->hdq_base);
-- 
1.7.10.4

