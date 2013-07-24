Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3GXO1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:27:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45851 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344Ab3GXOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Herbert Xu" <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Kees Cook" <keescook@chromium.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.493560247@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [68/85] crypto: sanitize argument for format string
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/algapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -477,7 +477,8 @@ static struct crypto_template *__crypto_
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 

