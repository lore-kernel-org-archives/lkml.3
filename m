Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3EJIQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:45 -0400
Received: from sauhun.de ([89.238.76.85]:60403 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3EJIQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:43 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 12/42] drivers/memory: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:57 +0200
Message-Id: <1368173847-5661-13-git-send-email-wsa@the-dreams.de>
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
 drivers/memory/emif.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index cadf1cc..04644e7 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1560,12 +1560,6 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, emif);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(emif->dev, "%s: error getting memory resource\n",
-			__func__);
-		goto error;
-	}
-
 	emif->base = devm_ioremap_resource(emif->dev, res);
 	if (IS_ERR(emif->base))
 		goto error;
-- 
1.7.10.4

