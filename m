Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3EJIVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:21:32 -0400
Received: from sauhun.de ([89.238.76.85]:60597 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3EJIRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:41 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [RFC 35/42] drivers/w1/masters: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:20 +0200
Message-Id: <1368173847-5661-36-git-send-email-wsa@the-dreams.de>
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

