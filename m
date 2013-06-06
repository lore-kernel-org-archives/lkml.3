Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3FFUz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:55:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56301 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab3FFUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:55:54 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/8] crypto: sanitize argument for format string
Date: Thu,  6 Jun 2013 13:52:20 -0700
Message-Id: <1370551945-8444-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370551945-8444-1-git-send-email-keescook@chromium.org>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The template lookup interface does not provide a way to use format
strings, so make sure that the interface cannot be abused accidentally.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 crypto/algapi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6149a6e..7a1ae87 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -495,7 +495,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
-- 
1.7.9.5

