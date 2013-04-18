Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968134Ab3DRK1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:27:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49854 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030405Ab3DRK1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:27:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 8/9] crypto: ux500/[cryp|hash] - Show successful start-up in the bootlog
Date: Thu, 18 Apr 2013 11:27:04 +0100
Message-Id: <1366280825-31136-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cryp driver is currently silent and the Hash driver prints the
name of its probe function unnecessarily. Let's just put a nice
descriptive one-liner there instead.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 ++
 drivers/crypto/ux500/hash/hash_core.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 6c4f872..7366910 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1536,6 +1536,8 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
+	dev_info(dev, "successfully registered\n");
+
 	return 0;
 
 out_power:
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index f9126f4..d3cbf5d 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1767,7 +1767,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
-	dev_info(dev, "[%s] successfully probed\n", __func__);
+	dev_info(dev, "successfully registered\n");
 	return 0;
 
 out_power:
-- 
1.7.10.4

