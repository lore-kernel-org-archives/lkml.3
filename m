Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbbAFVkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:40:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbbAFVkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:40:09 -0500
Date: Tue, 6 Jan 2015 23:39:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: [PATCH] sparc64: minor coding style tweaks
Message-ID: <1420580314-15107-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg suggested packing single-line cases
in nocheck switch statements makes for easier to
read code.

This is on top of arch/sparc: uaccess_64 macro whitespace fixes
that I sent earlier.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/sparc/include/asm/uaccess_64.h | 100 +++++++++++++-----------------------
 1 file changed, 37 insertions(+), 63 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index 12d9594..a35194b 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -106,26 +106,16 @@ void __retl_efault(void);
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) ((struct __large_struct *)(x))
 
-#define __put_user_nocheck(data, addr, size) ({ \
-	register int __pu_ret; \
-	switch (size) { \
-	case 1: \
-		__put_user_asm(data, b, addr, __pu_ret); \
-		break; \
-	case 2: \
-		__put_user_asm(data, h, addr, __pu_ret); \
-		break; \
-	case 4: \
-		__put_user_asm(data, w, addr, __pu_ret); \
-		break; \
-	case 8: \
-		__put_user_asm(data, x, addr, __pu_ret); \
-		break; \
-	default: \
-		__pu_ret = __put_user_bad(); \
-		break; \
-	} \
-	__pu_ret; \
+#define __put_user_nocheck(data, addr, size) ({			\
+	register int __pu_ret;					\
+	switch (size) {						\
+	case 1: __put_user_asm(data, b, addr, __pu_ret); break;	\
+	case 2: __put_user_asm(data, h, addr, __pu_ret); break;	\
+	case 4: __put_user_asm(data, w, addr, __pu_ret); break;	\
+	case 8: __put_user_asm(data, x, addr, __pu_ret); break;	\
+	default: __pu_ret = __put_user_bad(); break;		\
+	}							\
+	__pu_ret;						\
 })
 
 #define __put_user_asm(x, size, addr, ret)				\
@@ -150,51 +140,35 @@ __asm__ __volatile__(							\
 
 int __put_user_bad(void);
 
-#define __get_user_nocheck(data, addr, size, type) ({ \
-	register int __gu_ret; \
-	register unsigned long __gu_val; \
-	switch (size) { \
-		case 1: \
-			__get_user_asm(__gu_val, ub, addr, __gu_ret); \
-			break; \
-		case 2: \
-			__get_user_asm(__gu_val, uh, addr, __gu_ret); \
-			break; \
-		case 4: \
-			__get_user_asm(__gu_val, uw, addr, __gu_ret); \
-			break; \
-		case 8: \
-			__get_user_asm(__gu_val, x, addr, __gu_ret); \
-			break; \
-		default: \
-			__gu_val = 0; \
-			__gu_ret = __get_user_bad(); \
-			break; \
-	} \
-	data = (__force type) __gu_val; \
-	 __gu_ret; \
+#define __get_user_nocheck(data, addr, size, type) ({			     \
+	register int __gu_ret;						     \
+	register unsigned long __gu_val;				     \
+	switch (size) {							     \
+		case 1: __get_user_asm(__gu_val, ub, addr, __gu_ret); break; \
+		case 2: __get_user_asm(__gu_val, uh, addr, __gu_ret); break; \
+		case 4: __get_user_asm(__gu_val, uw, addr, __gu_ret); break; \
+		case 8: __get_user_asm(__gu_val, x, addr, __gu_ret); break;  \
+		default:						     \
+			__gu_val = 0;					     \
+			__gu_ret = __get_user_bad();			     \
+			break;						     \
+	} 								     \
+	data = (__force type) __gu_val;					     \
+	 __gu_ret;							     \
 })
 
-#define __get_user_nocheck_ret(data, addr, size, type, retval) ({ \
-	register unsigned long __gu_val __asm__ ("l1"); \
-	switch (size) { \
-	case 1: \
-		__get_user_asm_ret(__gu_val, ub, addr, retval); \
-		break; \
-	case 2: \
-		__get_user_asm_ret(__gu_val, uh, addr, retval); \
-		break; \
-	case 4: \
-		__get_user_asm_ret(__gu_val, uw, addr, retval); \
-		break; \
-	case 8: \
-		__get_user_asm_ret(__gu_val, x, addr, retval); \
-		break; \
-	default: \
-		if (__get_user_bad()) \
-			return retval; \
-	} \
-	data = (__force type) __gu_val; \
+#define __get_user_nocheck_ret(data, addr, size, type, retval) ({	\
+	register unsigned long __gu_val __asm__ ("l1");			\
+	switch (size) {							\
+	case 1: __get_user_asm_ret(__gu_val, ub, addr, retval); break;	\
+	case 2: __get_user_asm_ret(__gu_val, uh, addr, retval); break;	\
+	case 4: __get_user_asm_ret(__gu_val, uw, addr, retval); break;	\
+	case 8: __get_user_asm_ret(__gu_val, x, addr, retval); break;	\
+	default:							\
+		if (__get_user_bad())					\
+			return retval;					\
+	}								\
+	data = (__force type) __gu_val;					\
 })
 
 #define __get_user_asm(x, size, addr, ret)				\
-- 
MST
