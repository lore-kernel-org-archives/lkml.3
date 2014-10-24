Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaJXLV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:21:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34980 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaJXLVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:21:24 -0400
Date: Fri, 24 Oct 2014 06:19:17 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/7] staging: skein: Inlines rotl_64
Message-ID: <5dbe104122b60b509a58a5ff804d32d40f6f41fb.1414149238.git.eric.rost@mybabylon.net>
References: <cover.1414149238.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414149238.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inlines the rotl_64 macro.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_base.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index 9f10af9..0111fa4 100644
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
@@ -49,12 +45,12 @@ enum {
 	SKEIN_BAD_HASHLEN     =      2
 };
 
-#define  SKEIN_MODIFIER_WORDS   (2) /* number of modifier (tweak) words */
+#define  SKEIN_MODIFIER_WORDS   2 /* number of modifier (tweak) words */
 
-#define  SKEIN_256_STATE_WORDS  (4)
-#define  SKEIN_512_STATE_WORDS  (8)
-#define  SKEIN_1024_STATE_WORDS (16)
-#define  SKEIN_MAX_STATE_WORDS (16)
+#define  SKEIN_256_STATE_WORDS  4
+#define  SKEIN_512_STATE_WORDS  8
+#define  SKEIN_1024_STATE_WORDS 16
+#define  SKEIN_MAX_STATE_WORDS	16
 
 #define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
 #define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
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

