Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaKFN2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:28:11 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40525 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKFN2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:28:06 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] crypto: ux500/hash: Silence compiler warning for !CONFIG_PM
Date: Thu,  6 Nov 2014 14:28:01 +0100
Message-Id: <1415280481-14096-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system PM functions were unused when CONFIG_PM is unset. Let's move
them inside CONFIG_PM_SLEEP to silence the compiler warning.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1c73f4f..5af53b5 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1881,6 +1881,7 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 			__func__);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /**
  * ux500_hash_suspend - Function that suspends the hash device.
  * @dev:	Device to suspend.
@@ -1949,6 +1950,7 @@ static int ux500_hash_resume(struct device *dev)
 
 	return ret;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
 
-- 
1.9.1

