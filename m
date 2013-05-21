Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3EUM2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:28:10 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58921 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3EUM2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:28:08 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: FlorianSchandinat@gmx.de, jg1.han@samsung.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH V2] drivers: video: mxsfb: clean use of devm_ioremap_resource()
Date: Tue, 21 May 2013 14:33:49 +0200
Message-Id: <1369139629-20638-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <19650694.136921368693687337.JavaMail.weblogic@epml12>
References: <19650694.136921368693687337.JavaMail.weblogic@epml12>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check of 'res' and calls to dev_err are already done in devm_ioremap_resource,
so no need to do them twice.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/video/mxsfb.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 21223d4..6a1b338 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -883,12 +883,6 @@ static int mxsfb_probe(struct platform_device *pdev)
 	if (of_id)
 		pdev->id_entry = of_id->data;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Cannot get memory IO resource\n");
-		return -ENODEV;
-	}
-
 	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
 	if (!fb_info) {
 		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
@@ -897,9 +891,9 @@ static int mxsfb_probe(struct platform_device *pdev)
 
 	host = to_imxfb_host(fb_info);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(host->base)) {
-		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = PTR_ERR(host->base);
 		goto fb_release;
 	}
-- 
1.7.10.4

