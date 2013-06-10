Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3FJLx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:53:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52035 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3FJLt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:49:58 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 03/15] mmc: mvsdio: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:01 +0530
Message-Id: <1370864113-17895-4-git-send-email-tushar.behera@linaro.org>
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
CC: linux-mmc@vger.kernel.org
CC: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/mvsdio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index d08fe6a..656f1f5 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -758,9 +758,9 @@ static int __init mvsd_probe(struct platform_device *pdev)
 
 	spin_lock_init(&host->lock);
 
-	host->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!host->base) {
-		ret = -ENOMEM;
+	host->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(host->base)) {
+		ret = PTR_ERR(host->base);
 		goto out;
 	}
 
-- 
1.7.9.5

