Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3EPL1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:27:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56944 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3EPL1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:27:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 6/6] crypto: ux500/hash - Enable DT probing of the driver
Date: Thu, 16 May 2013 12:27:26 +0100
Message-Id: <1368703646-26418-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By providing an OF match table with a suitable compatible string, we
can ensure the ux500-hasht driver is probed by supplying an associated
DT node in a given platform's Device Tree.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 9ca6fbb..f89fe8a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1981,6 +1981,11 @@ static int ux500_hash_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
 
+static const struct of_device_id ux500_hash_match[] = {
+        { .compatible = "stericsson,ux500-hash" },
+        { },
+};
+
 static struct platform_driver hash_driver = {
 	.probe  = ux500_hash_probe,
 	.remove = ux500_hash_remove,
@@ -1988,6 +1993,7 @@ static struct platform_driver hash_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = "hash1",
+		.of_match_table = ux500_hash_match,
 		.pm    = &ux500_hash_pm,
 	}
 };
-- 
1.7.10.4

