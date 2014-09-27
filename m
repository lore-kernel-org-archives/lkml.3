Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaI0A5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:57:43 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40180 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaI0A5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:57:40 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Loc Ho <lho@apm.com>
Subject: [PATCH 03/10] power/reset: xgene: Drop devm_kfree
Date: Fri, 26 Sep 2014 17:57:11 -0700
Message-Id: <1411779438-23127-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling devm_kfree is unnecessary. Drop it.

Cc: Loc Ho <lho@apm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/xgene-reboot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index 20cf7c3..aac0287 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -66,7 +66,6 @@ static int xgene_reboot_probe(struct platform_device *pdev)
 
 	ctx->csr = of_iomap(pdev->dev.of_node, 0);
 	if (!ctx->csr) {
-		devm_kfree(&pdev->dev, ctx);
 		dev_err(&pdev->dev, "can not map resource\n");
 		return -ENODEV;
 	}
-- 
1.9.1

