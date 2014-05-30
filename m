Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaE3Flq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:41:46 -0400
Received: from ns.horizon.com ([71.41.210.147]:23586 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751239AbaE3Flp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:41:45 -0400
Date: 30 May 2014 01:41:44 -0400
Message-ID: <20140530054144.22103.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com
Subject: [PATCH 3/3] lib: crc32: Add some additional __pure annotations
Cc: linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <20140530053505.18155.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case they help the compiler.

Signed-off-by: George Spelvin <linux@horizon.com>
---
As long as I'm messing with it.  I also have a large patch to do this
to a number of lib/ headers if anyone wants.

Redundant "extern" removed to keep things within 80 columns.

 include/linux/crc32.h | 6 +++---
 lib/crc32.c           | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index bcb8e9d3..25e57f3a 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -8,8 +8,8 @@
 #include <linux/types.h>
 #include <linux/bitrev.h>
 
-extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
-extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
+u32  crc32_le(u32 crc, unsigned char const *p, size_t len) __pure;
+u32  crc32_be(u32 crc, unsigned char const *p, size_t len) __pure;
 
 /**
  * crc32_le_combine - Combine two crc32 check values into one. For two
@@ -35,7 +35,7 @@ static inline u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
 	return crc32_le_shift(crc1, len2) ^ crc2;
 }
 
-extern u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len);
+u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len) __pure;
 
 /**
  * __crc32c_le_combine - Combine two crc32c check values into one. For two
diff --git a/lib/crc32.c b/lib/crc32.c
index 977167d6..cf0c8e08 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -54,7 +54,7 @@ MODULE_LICENSE("GPL");
 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
 /* implements slicing-by-4 or slicing-by-8 algorithm */
-static inline u32
+static inline u32 __pure
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-- 
1.9.2

