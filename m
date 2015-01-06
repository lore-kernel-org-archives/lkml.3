Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbbAFWK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:10:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbbAFWK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:10:27 -0500
Date: Wed, 7 Jan 2015 00:10:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: [PATCH] sparc32: nocheck uaccess coding style tweaks
Message-ID: <1420582149-23235-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg suggested packing single-lines cases in switch statements
in nocheck uaccess macros makes for easier to read code.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is on top of coding style fixes that David already acked.

Sam - you only commented on uaccess_64 but I'm guessing same thing
applies to uaccess_32?

 arch/sparc/include/asm/uaccess_32.h | 96 ++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 61 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index f966562..64ee103 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -142,24 +142,14 @@ struct __large_struct { unsigned long buf[100]; };
 	__pu_ret; \
 })
 
-#define __put_user_nocheck(x, addr, size) ({ \
-	register int __pu_ret; \
-	switch (size) { \
-	case 1: \
-		__put_user_asm(x, b, addr, __pu_ret); \
-		break; \
-	case 2: \
-		__put_user_asm(x, h, addr, __pu_ret); \
-		break; \
-	case 4: \
-		__put_user_asm(x, , addr, __pu_ret); \
-		break; \
-	case 8: \
-		__put_user_asm(x, d, addr, __pu_ret); \
-		break; \
-	default: \
-		__pu_ret = __put_user_bad(); \
-		break; \
+#define __put_user_nocheck(x, addr, size) ({			\
+	register int __pu_ret;					\
+	switch (size) {						\
+	case 1: __put_user_asm(x, b, addr, __pu_ret); break;	\
+	case 2: __put_user_asm(x, h, addr, __pu_ret); break;	\
+	case 4: __put_user_asm(x, , addr, __pu_ret); break;	\
+	case 8: __put_user_asm(x, d, addr, __pu_ret); break;	\
+	default: __pu_ret = __put_user_bad(); break;		\
 	} \
 	__pu_ret; \
 })
@@ -240,51 +230,35 @@ int __put_user_bad(void);
 		return retval; \
 })
 
-#define __get_user_nocheck(x, addr, size, type) ({ \
-	register int __gu_ret; \
-	register unsigned long __gu_val; \
-	switch (size) { \
-	case 1: \
-		__get_user_asm(__gu_val, ub, addr, __gu_ret); \
-		break; \
-	case 2: \
-		__get_user_asm(__gu_val, uh, addr, __gu_ret); \
-		break; \
-	case 4: \
-		__get_user_asm(__gu_val, , addr, __gu_ret); \
-		break; \
-	case 8: \
-		__get_user_asm(__gu_val, d, addr, __gu_ret); \
-		break; \
-	default: \
-		__gu_val = 0; \
-		__gu_ret = __get_user_bad(); \
-		break; \
-	} \
-	x = (__force type) __gu_val; \
-	__gu_ret; \
+#define __get_user_nocheck(x, addr, size, type) ({			\
+	register int __gu_ret;						\
+	register unsigned long __gu_val;				\
+	switch (size) {							\
+	case 1: __get_user_asm(__gu_val, ub, addr, __gu_ret); break;	\
+	case 2: __get_user_asm(__gu_val, uh, addr, __gu_ret); break;	\
+	case 4: __get_user_asm(__gu_val, , addr, __gu_ret); break;	\
+	case 8: __get_user_asm(__gu_val, d, addr, __gu_ret); break;	\
+	default:							\
+		__gu_val = 0;						\
+		__gu_ret = __get_user_bad();				\
+		break;							\
+	}								\
+	x = (__force type) __gu_val;					\
+	__gu_ret;							\
 })
 
-#define __get_user_nocheck_ret(x, addr, size, type, retval) ({ \
-	register unsigned long __gu_val __asm__ ("l1"); \
-	switch (size) { \
-	case 1: \
-		__get_user_asm_ret(__gu_val, ub, addr, retval); \
-		break; \
-	case 2: \
-		__get_user_asm_ret(__gu_val, uh, addr, retval); \
-		break; \
-	case 4: \
-		__get_user_asm_ret(__gu_val, , addr, retval); \
-		break; \
-	case 8: \
-		__get_user_asm_ret(__gu_val, d, addr, retval); \
-		break; \
-	default: \
-		if (__get_user_bad()) \
-			return retval; \
-	} \
-	x = (__force type) __gu_val; \
+#define __get_user_nocheck_ret(x, addr, size, type, retval) ({		\
+	register unsigned long __gu_val __asm__ ("l1");			\
+	switch (size) {							\
+	case 1: __get_user_asm_ret(__gu_val, ub, addr, retval); break;	\
+	case 2: __get_user_asm_ret(__gu_val, uh, addr, retval); break;	\
+	case 4: __get_user_asm_ret(__gu_val, , addr, retval);  break;	\
+	case 8: __get_user_asm_ret(__gu_val, d, addr, retval); break;	\
+	default:							\
+		if (__get_user_bad())					\
+			return retval;					\
+	}								\
+	x = (__force type) __gu_val;					\
 })
 
 #define __get_user_asm(x, size, addr, ret)				\
-- 
MST
