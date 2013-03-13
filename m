Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab3CMXRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:17:49 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61069 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397Ab3CMXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:17:48 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: dma: Use devm_ioremap_resource
Date: Thu, 14 Mar 2013 01:17:06 +0200
Message-Id: <1363216626-16693-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced call to devm_request_and_ioremap with devm_ioremap_resource which
provides better error handling.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/dma/pl330.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7181531..c0a81fb 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2904,9 +2904,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
-	pi->base = devm_request_and_ioremap(&adev->dev, res);
-	if (!pi->base)
-		return -ENXIO;
+	pi->base = devm_ioremap_resource(&adev->dev, res);
+	if (IS_ERR(pi->base))
+		return PTR_ERR(pi->base);
 
 	amba_set_drvdata(adev, pdmac);
 
-- 
1.7.9.5

