Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKFN1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:27:53 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40666 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKFN1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:27:50 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] crypto: ux500/cryp: Silence compiler warning for !CONFIG_PM
Date: Thu,  6 Nov 2014 14:27:35 +0100
Message-Id: <1415280455-14056-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system PM functions were unused when CONFIG_PM is unset. Let's move
them inside CONFIG_PM_SLEEP to silence the compiler warning.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 92105f3..83811aa 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1688,6 +1688,7 @@ static void ux500_cryp_shutdown(struct platform_device *pdev)
 
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ux500_cryp_suspend(struct device *dev)
 {
 	int ret;
@@ -1768,6 +1769,7 @@ static int ux500_cryp_resume(struct device *dev)
 
 	return ret;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
-- 
1.9.1

