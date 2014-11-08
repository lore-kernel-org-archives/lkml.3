Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaKHQQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:16:11 -0500
Received: from mxf1.bahnhof.se ([213.80.101.25]:51554 "EHLO mxf1.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbaKHQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:16:09 -0500
X-Greylist: delayed 1568 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2014 11:16:09 EST
X-Spam-Score: 0
From: Niklas Svensson <nks@flawful.org>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, eric.rost@mybabylon.net, jason@lakedaemon.net,
        gregkh@linuxfoundation.org, Niklas Svensson <nks@flawful.org>
Subject: [PATCH] staging: skein: fixed sparse warnings related to static declarations
Date: Sat,  8 Nov 2014 16:49:18 +0100
Message-Id: <1415461758-9587-1-git-send-email-nks@flawful.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/skein/skein_generic.c:30:5: warning: symbol 'skein256_update' was not declared. Should it be static?
drivers/staging/skein/skein_generic.c:65:5: warning: symbol 'skein512_update' was not declared. Should it be static?
drivers/staging/skein/skein_generic.c:100:5: warning: symbol 'skein1024_update' was not declared. Should it be static?

Signed-off-by: Niklas Svensson <nks@flawful.org>
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

