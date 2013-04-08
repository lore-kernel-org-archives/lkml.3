Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834Ab3DHDo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:44:59 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:65427 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3DHDo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:44:58 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Fix sortextable building on non-Linux systems
Message-Id: <BB7B7EFE-AAF1-4624-89B5-50471193FE62@gmail.com>
Date: Mon, 8 Apr 2013 13:44:50 +1000
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any reason why 'tools/include/tools/be_byteshift.h' and 'tools/include/tools/le_byteshift.h' needs to include 'linux/types.h'? It breaks compilation of ARM kernels on OS X since sortextable, which uses those headers, fails to build because 'linux/types.h' doesn't exist.

Included is a patch that fixes building on non-Linux systems.

Cheers,
tangrs

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 tools/include/tools/be_byteshift.h | 34 +++++++++++++++++-----------------
 tools/include/tools/le_byteshift.h | 34 +++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
index f4912e2..d51fe26 100644
--- a/tools/include/tools/be_byteshift.h
+++ b/tools/include/tools/be_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_BE_BYTESHIFT_H
 #define _TOOLS_BE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <inttypes.h>
 
-static inline __u16 __get_unaligned_be16(const __u8 *p)
+static inline uint16_t __get_unaligned_be16(const uint8_t *p)
 {
 	return p[0] << 8 | p[1];
 }
 
-static inline __u32 __get_unaligned_be32(const __u8 *p)
+static inline uint32_t __get_unaligned_be32(const uint8_t *p)
 {
 	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
-static inline __u64 __get_unaligned_be64(const __u8 *p)
+static inline uint64_t __get_unaligned_be64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_be32(p) << 32 |
+	return (uint64_t)__get_unaligned_be32(p) << 32 |
 	       __get_unaligned_be32(p + 4);
 }
 
-static inline void __put_unaligned_be16(__u16 val, __u8 *p)
+static inline void __put_unaligned_be16(uint16_t val, uint8_t *p)
 {
 	*p++ = val >> 8;
 	*p++ = val;
 }
 
-static inline void __put_unaligned_be32(__u32 val, __u8 *p)
+static inline void __put_unaligned_be32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_be16(val >> 16, p);
 	__put_unaligned_be16(val, p + 2);
 }
 
-static inline void __put_unaligned_be64(__u64 val, __u8 *p)
+static inline void __put_unaligned_be64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_be32(val >> 32, p);
 	__put_unaligned_be32(val, p + 4);
 }
 
-static inline __u16 get_unaligned_be16(const void *p)
+static inline uint16_t get_unaligned_be16(const void *p)
 {
-	return __get_unaligned_be16((const __u8 *)p);
+	return __get_unaligned_be16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_be32(const void *p)
+static inline uint32_t get_unaligned_be32(const void *p)
 {
-	return __get_unaligned_be32((const __u8 *)p);
+	return __get_unaligned_be32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_be64(const void *p)
+static inline uint64_t get_unaligned_be64(const void *p)
 {
-	return __get_unaligned_be64((const __u8 *)p);
+	return __get_unaligned_be64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_be16(__u16 val, void *p)
+static inline void put_unaligned_be16(uint16_t val, void *p)
 {
 	__put_unaligned_be16(val, p);
 }
 
-static inline void put_unaligned_be32(__u32 val, void *p)
+static inline void put_unaligned_be32(uint32_t val, void *p)
 {
 	__put_unaligned_be32(val, p);
 }
 
-static inline void put_unaligned_be64(__u64 val, void *p)
+static inline void put_unaligned_be64(uint64_t val, void *p)
 {
 	__put_unaligned_be64(val, p);
 }
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
index c99d45a..259a132 100644
--- a/tools/include/tools/le_byteshift.h
+++ b/tools/include/tools/le_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_LE_BYTESHIFT_H
 #define _TOOLS_LE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <inttypes.h>
 
-static inline __u16 __get_unaligned_le16(const __u8 *p)
+static inline uint16_t __get_unaligned_le16(const uint8_t *p)
 {
 	return p[0] | p[1] << 8;
 }
 
-static inline __u32 __get_unaligned_le32(const __u8 *p)
+static inline uint32_t __get_unaligned_le32(const uint8_t *p)
 {
 	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
 }
 
-static inline __u64 __get_unaligned_le64(const __u8 *p)
+static inline uint64_t __get_unaligned_le64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_le32(p + 4) << 32 |
+	return (uint64_t)__get_unaligned_le32(p + 4) << 32 |
 	       __get_unaligned_le32(p);
 }
 
-static inline void __put_unaligned_le16(__u16 val, __u8 *p)
+static inline void __put_unaligned_le16(uint16_t val, uint8_t *p)
 {
 	*p++ = val;
 	*p++ = val >> 8;
 }
 
-static inline void __put_unaligned_le32(__u32 val, __u8 *p)
+static inline void __put_unaligned_le32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_le16(val >> 16, p + 2);
 	__put_unaligned_le16(val, p);
 }
 
-static inline void __put_unaligned_le64(__u64 val, __u8 *p)
+static inline void __put_unaligned_le64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_le32(val >> 32, p + 4);
 	__put_unaligned_le32(val, p);
 }
 
-static inline __u16 get_unaligned_le16(const void *p)
+static inline uint16_t get_unaligned_le16(const void *p)
 {
-	return __get_unaligned_le16((const __u8 *)p);
+	return __get_unaligned_le16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_le32(const void *p)
+static inline uint32_t get_unaligned_le32(const void *p)
 {
-	return __get_unaligned_le32((const __u8 *)p);
+	return __get_unaligned_le32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_le64(const void *p)
+static inline uint64_t get_unaligned_le64(const void *p)
 {
-	return __get_unaligned_le64((const __u8 *)p);
+	return __get_unaligned_le64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_le16(__u16 val, void *p)
+static inline void put_unaligned_le16(uint16_t val, void *p)
 {
 	__put_unaligned_le16(val, p);
 }
 
-static inline void put_unaligned_le32(__u32 val, void *p)
+static inline void put_unaligned_le32(uint32_t val, void *p)
 {
 	__put_unaligned_le32(val, p);
 }
 
-static inline void put_unaligned_le64(__u64 val, void *p)
+static inline void put_unaligned_le64(uint64_t val, void *p)
 {
 	__put_unaligned_le64(val, p);
 }
-- 
1.8.1.3


