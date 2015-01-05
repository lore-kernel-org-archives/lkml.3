Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbbAELVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:21:52 -0500
Received: from mail.eperm.de ([89.247.134.16]:59384 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbbAELVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:21:51 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: AEAD: add check for presence of auth tag
Date: Mon, 05 Jan 2015 12:21:45 +0100
Message-ID: <2529951.NL2CVhi6xs@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AEAD decryption operation requires the authentication tag to be
present as part of the cipher text buffer. The added check verifies that
the caller provides a cipher text with at least the authentication tag.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9c8776d..9099834 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1412,6 +1412,9 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
  */
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
+	if (req->cryptlen < crypto_aead_authsize(crypto_aead_reqtfm(req)))
+		return -EINVAL;
+
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
 }
 
-- 
2.1.0


