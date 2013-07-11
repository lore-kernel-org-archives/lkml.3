Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3GKOpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:45:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab3GKO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/98] crypto: sanitize argument for format string
Date: Thu, 11 Jul 2013 15:24:06 +0100
Message-Id: <1373552708-15235-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 1c8fca1d92e14859159a82b8a380d220139b7344 upstream.

The template lookup interface does not provide a way to use format
strings, so make sure that the interface cannot be abused accidentally.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/algapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 056571b..b4c046c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -512,7 +512,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
-- 
1.8.1.2

