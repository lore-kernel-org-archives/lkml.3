Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaKSVfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:35:51 -0500
Received: from mxf2.bahnhof.se ([213.80.101.26]:59291 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbaKSVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:38 -0500
X-Spam-Score: 0
From: Niklas Svensson <nks@flawful.org>
To: gregkh@linuxfoundation.org, eric.rost@mybabylon.net, jason@lakedaemon.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niklas Svensson <nks@flawful.org>
Subject: [PATCH RESEND] staging: skein: fixed sparse warnings related to static declarations
Date: Wed, 19 Nov 2014 22:13:47 +0100
Message-Id: <1416431627-3876-1-git-send-email-nks@flawful.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/skein/skein_generic.c:30:5: warning: symbol 'skein256_update' was not declared. Should it be static?
drivers/staging/skein/skein_generic.c:65:5: warning: symbol 'skein512_update' was not declared. Should it be static?
drivers/staging/skein/skein_generic.c:100:5: warning: symbol 'skein1024_update' was not declared. Should it be static?

Signed-off-by: Niklas Svensson <nks@flawful.org>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/skein_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 60d16b6..85bd7d0 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -27,7 +27,7 @@ static int skein256_init(struct shash_desc *desc)
 			SKEIN256_DIGEST_BIT_SIZE);
 }
 
-int skein256_update(struct shash_desc *desc, const u8 *data,
+static int skein256_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	return skein_256_update((struct skein_256_ctx *)shash_desc_ctx(desc),
@@ -62,7 +62,7 @@ static int skein512_init(struct shash_desc *desc)
 				SKEIN512_DIGEST_BIT_SIZE);
 }
 
-int skein512_update(struct shash_desc *desc, const u8 *data,
+static int skein512_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	return skein_512_update((struct skein_512_ctx *)shash_desc_ctx(desc),
@@ -97,7 +97,7 @@ static int skein1024_init(struct shash_desc *desc)
 				SKEIN1024_DIGEST_BIT_SIZE);
 }
 
-int skein1024_update(struct shash_desc *desc, const u8 *data,
+static int skein1024_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	return skein_1024_update((struct skein_1024_ctx *)shash_desc_ctx(desc),
-- 
2.1.0

