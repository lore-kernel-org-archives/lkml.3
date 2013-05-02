Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3EBPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3EBPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Chanho Min <chanho.min@lge.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH, RFC 09/22] crypto: lz4: don't build on ARM
Date: Thu,  2 May 2013 17:16:13 +0200
Message-Id: <1367507786-505303-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5M2TImUS4ktGM2EKbnWxsD422uJz6Tv3MkR0dN0Fbmb
 Bfe0GAX1aqnOcsJbhjHzoPdJhfywQ4yBXR5/ieSYqD6mpDtHxm
 X0yb8H2pZS10hEwKQEYbLvcWA1K9MrYN6vNuixAsdQoxHM1noB
 LWoLTraUL/yoEnECPiBExqOYVde6z6bdLN5QGZdWX1M2lOUN3L
 +HPOmKKcdB6CcQcE45ouF7jYRpM+/KsZK9S8dSpF4o/yub2jl3
 WYdRKqSy/zTyiTggGi6uiIbh9NblX28CeBOlCouSt2k8M9YsQV
 Xd+zlf9ilWJezB5UNhPY+4yzrs1IIeg60Mm9SC1zwtIWb/oxCG
 mvC7cwaz06zvrcI1WOzPOnttXxtF/f8fMeVdSGqAU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not currently possible to build the LZ4 code on ARM, so let's
remove that option in Kconfig for now.

lib/built-in.o: In function `lz4_compress64kctx':
 lib/lz4/lz4_compress.c:339: undefined reference to `__ctzsi2'
lib/built-in.o: In function `lz4_compressctx':
 lib/lz4/lz4_compress.c:157: undefined reference to `__ctzsi2'
lib/built-in.o: In function `lz4hc_commonlength':
 lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
 lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
lib/built-in.o: In function `lz4hc_insertandgetwidermatch':
 lib/lz4/lz4hc_compress.c:230: undefined reference to `__ctzsi2'

Cc: Chanho Min <chanho.min@lge.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aa3a349..1cd134b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1361,6 +1361,7 @@ config CRYPTO_842
 
 config CRYPTO_LZ4
 	tristate "LZ4 compression algorithm"
+	depends on !ARM
 	select CRYPTO_ALGAPI
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
@@ -1369,6 +1370,7 @@ config CRYPTO_LZ4
 
 config CRYPTO_LZ4HC
 	tristate "LZ4HC compression algorithm"
+	depends on !ARM
 	select CRYPTO_ALGAPI
 	select LZ4HC_COMPRESS
 	select LZ4_DECOMPRESS
-- 
1.8.1.2

