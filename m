Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab3KHPLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:11:00 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48430 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3KHPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:10:57 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 7/7] crypto: atmel-sha - add sha information to the log
Date: Fri, 8 Nov 2013 16:08:16 +0100
Message-ID: <e8be86b81611f75ff961d93bd448996fcb5b51ef.1383922546.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
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

