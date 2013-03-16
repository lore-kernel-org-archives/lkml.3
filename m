Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3CQJMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 05:12:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42841 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3CQJMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 05:12:05 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: cpuidle: Use devm_ioremap_resource function
Date: Sat, 16 Mar 2013 16:39:21 +0200
Message-Id: <1363444761-3641-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource function, which provides better error handling,
instead of devm_request_and_ioremap.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
index 670aa1e..53aad73 100644
--- a/drivers/cpuidle/cpuidle-kirkwood.c
+++ b/drivers/cpuidle/cpuidle-kirkwood.c
@@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EINVAL;
 
-	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ddr_operation_base)
-		return -EADDRNOTAVAIL;
+	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ddr_operation_base))
+		return PTR_ERR(ddr_operation_base);
 
 	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
 	device->state_count = KIRKWOOD_MAX_STATES;
-- 
1.7.9.5

