Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3CENdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:33:19 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57728 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab3CENdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:33:18 -0500
Message-ID: <1362490396.16460.87.camel@x61.thuisdomein>
Subject: [PATCH] crypto: caam - fix typo "CRYPTO_AHASH"
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 14:33:16 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 13:33:16.0678 (UTC) FILETIME=[FE486A60:01CE19A5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for CAAM's hash algorithm implementations has always
selected CRYPTO_AHASH. But there's no corresponding Kconfig symbol.

It seems it was intended to select CRYPTO_HASH, like other crypto
drivers do. That would apparently (indirectly) select CRYPTO_HASH2,
which would enable the ahash functionality this driver uses.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested!

1) Apparently, one can indirectly select a Kconfig symbol. That actually
surprised me. But if the kconfig parser does not work this way this
patch (and it's explanation) is bogus.

 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 65c7668..b44091c 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -78,7 +78,7 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	tristate "Register hash algorithm implementations with Crypto API"
 	depends on CRYPTO_DEV_FSL_CAAM
 	default y
-	select CRYPTO_AHASH
+	select CRYPTO_HASH
 	help
 	  Selecting this will offload ahash for users of the
 	  scatterlist crypto API to the SEC4 via job ring.
-- 
1.7.11.7

