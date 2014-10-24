Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaJXCOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:14:22 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:61220 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaJXCOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:14:20 -0400
Date: Thu, 23 Oct 2014 21:12:11 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] staging: skein: Inlines rotl_64
Message-ID: <526ddde46b763e0cf082353233751f2cf5beda55.1414116450.git.eric.rost@mybabylon.net>
References: <cover.1414116450.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414116450.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inlines the macro definition rotl_64 to avoid bugs.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_base.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index 9f10af9..769bcb4 100644
--- a/drivers/staging/skein/skein_base.h
+++ b/drivers/staging/skein/skein_base.h
@@ -33,10 +33,6 @@
 #define SKEIN512_DIGEST_BIT_SIZE 512
 #define SKEIN1024_DIGEST_BIT_SIZE 1024
 
-#ifndef rotl_64
-#define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
-#endif
-
 /* below two prototype assume we are handed aligned data */
 #define skein_put64_lsb_first(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
 #define skein_get64_lsb_first(dst64, src08, w_cnt) \
@@ -92,6 +88,11 @@ struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
 	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
+static inline int rotl_64(int x, int N) 
+{
+	return (x << N) | (x >> (64 - N));
+}
+
 /* Skein APIs for (incremental) "straight hashing" */
 int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len);
 int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len);
-- 
2.1.1

