Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3GSJJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:09:11 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45581 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:09:07 -0400
Date: Fri, 19 Jul 2013 12:08:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hyojun.im@lge.com, chan.jeong@lge.com
Subject: [PATCH] LZ4: compression/decompression signedness mismatch (v2)
Message-ID: <20130719090826.GB2275@swordfish>
References: <20130712092400.GA2565@swordfish>
 <CADv+DGka4s1xc2UYqu+-EqHW8jA56JrtEE_sMsMOpc6NDmc6Zw@mail.gmail.com>
 <20130712094830.GA2257@swordfish.minsk.epam.com>
 <20130718211806.GB2394@swordfish>
 <CAMuHMdXCsRKpFQRwMTteQpBCbtuJVqmb9UvszHi3ffTS=RxJmw@mail.gmail.com>
 <20130719082710.GA11597@hulk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719082710.GA11597@hulk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LZ4 compression and decompression functions require different
in signedness input/output parameters: unsigned char for
compression and signed char for decompression.

Change decompression API to require "(const) unsigned char *".

v2: minor coding style fix.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 include/linux/lz4.h      | 8 ++++----
 lib/lz4/lz4_decompress.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index d21c13f..4356686 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -67,8 +67,8 @@ int lz4hc_compress(const unsigned char *src, size_t src_len,
  *	note :  Destination buffer must be already allocated.
  *		slightly faster than lz4_decompress_unknownoutputsize()
  */
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len);
+int lz4_decompress(const unsigned char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len);
 
 /*
  * lz4_decompress_unknownoutputsize()
@@ -82,6 +82,6 @@ int lz4_decompress(const char *src, size_t *src_len, char *dest,
  *		  Error if return (< 0)
  *	note :  Destination buffer must be already allocated.
  */
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len);
+int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len);
 #endif
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index d3414ea..4c069b2 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -283,8 +283,8 @@ _output_error:
 	return (int) (-(((char *) ip) - source));
 }
 
-int lz4_decompress(const char *src, size_t *src_len, char *dest,
-		size_t actual_dest_len)
+int lz4_decompress(const unsigned char *src, size_t *src_len,
+		unsigned char *dest, size_t actual_dest_len)
 {
 	int ret = -1;
 	int input_len = 0;
@@ -302,8 +302,8 @@ exit_0:
 EXPORT_SYMBOL_GPL(lz4_decompress);
 #endif
 
-int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
-		char *dest, size_t *dest_len)
+int lz4_decompress_unknownoutputsize(const unsigned char *src, size_t src_len,
+		unsigned char *dest, size_t *dest_len)
 {
 	int ret = -1;
 	int out_len = 0;

