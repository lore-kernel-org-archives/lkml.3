Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3EPL14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:27:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39817 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3EPL1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:27:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
Date: Thu, 16 May 2013 12:27:25 +0100
Message-Id: <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By providing an OF match table with a suitable compatible string, we
can ensure the ux500-crypt driver is probed by supplying an associated
DT node in a given platform's Device Tree.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 4f8b11a..d3940b7 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1772,6 +1772,11 @@ static int ux500_cryp_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
+static const struct of_device_id ux500_cryp_match[] = {
+        { .compatible = "stericsson,ux500-cryp" },
+        { },
+};
+
 static struct platform_driver cryp_driver = {
 	.probe  = ux500_cryp_probe,
 	.remove = ux500_cryp_remove,
@@ -1779,6 +1784,7 @@ static struct platform_driver cryp_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = "cryp1",
+		.of_match_table = ux500_cryp_match,
 		.pm    = &ux500_cryp_pm,
 	}
 };
-- 
1.7.10.4

