Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaDVHbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:31:47 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:45182 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753024AbaDVHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:31:06 -0400
From: Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas@eukrea.com>, <nicolas.ferre@atmel.com>,
        <leilei.zhao@atmel.com>
Subject: [PATCH 2/2] crypto: atmel-aes: check alignment of cfb64 mode
Date: Tue, 22 Apr 2014 15:23:24 +0800
Message-ID: <1398151404-23408-3-git-send-email-leilei.zhao@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
References: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length shoule be 64 bit alignment and the block size shoule be 64 bit in aes cfb64 mode.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
---
 drivers/crypto/atmel-aes.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 12628a7..a083474 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -716,6 +716,12 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 			return -EINVAL;
 		}
 		ctx->block_size = CFB32_BLOCK_SIZE;
+	} else if (mode & AES_FLAGS_CFB64) {
+		if (!IS_ALIGNED(req->nbytes, CFB64_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB64 blocks\n");
+			return -EINVAL;
+		}
+		ctx->block_size = CFB64_BLOCK_SIZE;
 	} else {
 		if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
 			pr_err("request size is not exact amount of AES blocks\n");
-- 
1.7.9.5

