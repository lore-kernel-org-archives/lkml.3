Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3GLJYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:24:34 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39865 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab3GLJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:24:33 -0400
Date: Fri, 12 Jul 2013 12:24:00 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yann Collet <yann.collet.73@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] LZ4: compression/decompression signedness mismatch
Message-ID: <20130712092400.GA2565@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LZ4 compression and decompression functions require different
in signedness input/output parameters: unsigned char for
compression and signed char for decompression.

Change decompression API to require unsigned char.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 include/linux/lz4.h      | 8 ++++----
 lib/lz4/lz4_decompress.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index d21c13f..c13f0bc 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -67,8 +67,8 @@ int lz4hc_compress(const unsigned char *src, size_t src_len,
  *	note :  Destination buffer must be already allocated.
  *		slightly faster than lz4_decompress_unknownoutputsize()
  */
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len);
+int lz4_decompress(unsigned const char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len);
 
 /*
  * lz4_decompress_unknownoutputsize()
@@ -82,6 +82,6 @@ int lz4_decompress(const char *src, size_t *src_len, char *dest,
  *		  Error if return (< 0)
  *	note :  Destination buffer must be already allocated.
  */
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len);
+int lz4_decompress_unknownoutputsize(unsigned const char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len);
 #endif
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index d3414ea..7ceda1f 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -283,8 +283,8 @@ _output_error:
 	return (int) (-(((char *) ip) - source));
 }
 
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len)
+int lz4_decompress(unsigned const char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len)
 {
 	int ret = -1;
 	int input_len = 0;
@@ -302,8 +302,8 @@ exit_0:
 EXPORT_SYMBOL_GPL(lz4_decompress);
 #endif
 
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len)
+int lz4_decompress_unknownoutputsize(unsigned const char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len)
 {
 	int ret = -1;
 	int out_len = 0;

