Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3JOOo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:44:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:23328 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3JOOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:44:26 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <eric@eukrea.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] crypto: atmel-sha - add sha information to the log
Date: Tue, 15 Oct 2013 16:43:38 +0200
Message-ID: <09f509fc6cfb779afb0f01c36b37a49bac05f626.1381848041.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1345d1ba7bb874b32926acc6cad05bf57b26058b.1381848041.git.nicolas.ferre@atmel.com>
References: <1345d1ba7bb874b32926acc6cad05bf57b26058b.1381848041.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on peripheral capabilities, print SHA information at the end
of the probe function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-sha.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index ecfdf72..0618be0 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1469,7 +1469,9 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	if (err)
 		goto err_algs;
 
-	dev_info(dev, "Atmel SHA1/SHA256\n");
+	dev_info(dev, "Atmel SHA1/SHA256%s%s\n",
+			sha_dd->caps.has_sha224 ? "/SHA224" : "",
+			sha_dd->caps.has_sha_384_512 ? "/SHA384/SHA512" : "");
 
 	return 0;
 
-- 
1.8.2.2

