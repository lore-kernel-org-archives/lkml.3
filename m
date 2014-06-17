Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaFQO3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:29:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48605 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995AbaFQO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:29:13 -0400
Message-ID: <53A050AE.2050401@oracle.com>
Date: Tue, 17 Jun 2014 22:29:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: herbert@gondor.apana.org.au, davem@davemloft.net
CC: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/24] crypt: return actual error code on pcrypt_init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if call kset_create_and_add() failed

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller" <davem@davemloft.net>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 crypto/pcrypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 309d345..053fb10 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -523,11 +523,13 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
-	int err = -ENOMEM;
+	int err;
 
 	pcrypt_kset = kset_create_and_add("pcrypt", NULL, kernel_kobj);
-	if (!pcrypt_kset)
+	if (IS_ERR(pcrypt_kset)) {
+		err = PTR_ERR(pcrypt_kset);
 		goto err;
+	}
 
 	err = pcrypt_init_padata(&pencrypt, "pencrypt");
 	if (err)
-- 
1.8.3.2
