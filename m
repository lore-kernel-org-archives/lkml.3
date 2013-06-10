Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3FJLui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48176 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab3FJLud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:33 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/15] Staging: netlogic: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:08 +0530
Message-Id: <1370864113-17895-11-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: devel@driverdev.osuosl.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/netlogic/xlr_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index dd98cb1..c30fa54 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -1020,12 +1020,12 @@ static int xlr_net_probe(struct platform_device *pdev)
 		goto err_gmac;
 	}
 
-	ndev->base_addr = (unsigned long) devm_request_and_ioremap
+	ndev->base_addr = (unsigned long) devm_ioremap_resource
 		(&pdev->dev, res);
-	if (!ndev->base_addr) {
+	if (IS_ERR_VALUE(ndev->base_addr)) {
 		dev_err(&pdev->dev,
-				"devm_request_and_ioremap failed\n");
-		return -EBUSY;
+				"devm_ioremap_resource failed\n");
+		return ndev->base_addr;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-- 
1.7.9.5

