Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3EJIWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:22:03 -0400
Received: from sauhun.de ([89.238.76.85]:60580 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3EJIRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:36 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [RFC 33/42] drivers/video/omap2: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:18 +0200
Message-Id: <1368173847-5661-34-git-send-email-wsa@the-dreams.de>
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
 drivers/video/omap2/vrfb.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/omap2/vrfb.c b/drivers/video/omap2/vrfb.c
index 5261229..f346b02 100644
--- a/drivers/video/omap2/vrfb.c
+++ b/drivers/video/omap2/vrfb.c
@@ -353,11 +353,6 @@ static int __init vrfb_probe(struct platform_device *pdev)
 	/* first resource is the register res, the rest are vrfb contexts */
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "can't get vrfb base address\n");
-		return -EINVAL;
-	}
-
 	vrfb_base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(vrfb_base))
 		return PTR_ERR(vrfb_base);
-- 
1.7.10.4

