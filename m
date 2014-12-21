Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaLUUzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 15:55:43 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:36375 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLUUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 15:54:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 5/5] crypto: enable OCTEON MD5 module selection
Date: Sun, 21 Dec 2014 22:54:02 +0200
Message-Id: <1419195242-546-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable user to select OCTEON MD5 module.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 crypto/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87bbc9c..1618468 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -427,6 +427,15 @@ config CRYPTO_MD5
 	help
 	  MD5 message digest algorithm (RFC1321).
 
+config CRYPTO_MD5_OCTEON
+	tristate "MD5 digest algorithm (OCTEON)"
+	depends on CPU_CAVIUM_OCTEON
+	select CRYPTO_MD5
+	select CRYPTO_HASH
+	help
+	  MD5 message digest algorithm (RFC1321) implemented
+	  using OCTEON crypto instructions, when available.
+
 config CRYPTO_MD5_SPARC64
 	tristate "MD5 digest algorithm (SPARC64)"
 	depends on SPARC64
-- 
2.2.0

