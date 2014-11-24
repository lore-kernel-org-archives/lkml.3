Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaKXTRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:17:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58661 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaKXTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:17:50 -0500
Date: Mon, 24 Nov 2014 11:17:42 -0800
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: include crypto- module prefix in template
Message-ID: <20141124191742.GA13783@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the module loading prefix "crypto-" to the template lookup
as well.

For example, attempting to load 'vfat(blowfish)' via AF_ALG now correctly
includes the "crypto-" prefix at every level, correctly rejecting "vfat":

	net-pf-38
	algif-hash
	crypto-vfat(blowfish)
	crypto-vfat(blowfish)-all
	crypto-vfat

Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/algapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e8d3a7dca8c4..71a8143e23b1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -509,8 +509,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), "%s",
-				       name);
+	return try_then_request_module(__crypto_lookup_template(name),
+				       "crypto-%s", name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
