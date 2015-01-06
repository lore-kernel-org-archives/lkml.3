Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbbAFPqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbbAFPp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:58 -0500
Date: Tue, 6 Jan 2015 17:45:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH v2 40/40] xtensa: macro whitespace fixes
Message-ID: <1420558883-10131-41-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/xtensa/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/xtensa/include/asm/uaccess.h | 90 +++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index 876eb38..147b26e 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -182,13 +182,13 @@
 #define get_fs()	(current->thread.current_ds)
 #define set_fs(val)	(current->thread.current_ds = (val))
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 
 #define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
-#define __user_ok(addr,size) \
+#define __user_ok(addr, size) \
 		(((size) <= TASK_SIZE)&&((addr) <= TASK_SIZE-(size)))
-#define __access_ok(addr,size) (__kernel_ok || __user_ok((addr),(size)))
-#define access_ok(type,addr,size) __access_ok((unsigned long)(addr),(size))
+#define __access_ok(addr, size) (__kernel_ok || __user_ok((addr), (size)))
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr), (size))
 
 /*
  * These are the main single-value transfer routines.  They
@@ -204,8 +204,8 @@
  * (a) re-use the arguments for side effects (sizeof is ok)
  * (b) require any knowledge of processes at this stage
  */
-#define put_user(x,ptr)	__put_user_check((x),(ptr),sizeof(*(ptr)))
-#define get_user(x,ptr) __get_user_check((x),(ptr),sizeof(*(ptr)))
+#define put_user(x, ptr)	__put_user_check((x), (ptr), sizeof(*(ptr)))
+#define get_user(x, ptr) __get_user_check((x), (ptr), sizeof(*(ptr)))
 
 /*
  * The "__xxx" versions of the user access functions are versions that
@@ -213,39 +213,39 @@
  * with a separate "access_ok()" call (this is used when we do multiple
  * accesses to the same area of user memory).
  */
-#define __put_user(x,ptr) __put_user_nocheck((x),(ptr),sizeof(*(ptr)))
-#define __get_user(x,ptr) __get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __put_user(x, ptr) __put_user_nocheck((x), (ptr), sizeof(*(ptr)))
+#define __get_user(x, ptr) __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 
 
 extern long __put_user_bad(void);
 
-#define __put_user_nocheck(x,ptr,size)			\
+#define __put_user_nocheck(x, ptr, size)		\
 ({							\
 	long __pu_err;					\
-	__put_user_size((x),(ptr),(size),__pu_err);	\
+	__put_user_size((x), (ptr), (size), __pu_err);	\
 	__pu_err;					\
 })
 
-#define __put_user_check(x,ptr,size)				\
-({								\
-	long __pu_err = -EFAULT;				\
-	__typeof__(*(ptr)) *__pu_addr = (ptr);			\
-	if (access_ok(VERIFY_WRITE,__pu_addr,size))		\
-		__put_user_size((x),__pu_addr,(size),__pu_err);	\
-	__pu_err;						\
+#define __put_user_check(x, ptr, size)					\
+({									\
+	long __pu_err = -EFAULT;					\
+	__typeof__(*(ptr)) *__pu_addr = (ptr);				\
+	if (access_ok(VERIFY_WRITE, __pu_addr, size))			\
+		__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	__pu_err;							\
 })
 
-#define __put_user_size(x,ptr,size,retval)				\
+#define __put_user_size(x, ptr, size, retval)				\
 do {									\
 	int __cb;							\
 	retval = 0;							\
 	switch (size) {							\
-	case 1: __put_user_asm(x,ptr,retval,1,"s8i",__cb);  break;	\
-	case 2: __put_user_asm(x,ptr,retval,2,"s16i",__cb); break;	\
-	case 4: __put_user_asm(x,ptr,retval,4,"s32i",__cb); break;	\
+	case 1: __put_user_asm(x, ptr, retval, 1, "s8i", __cb);  break;	\
+	case 2: __put_user_asm(x, ptr, retval, 2, "s16i", __cb); break;	\
+	case 4: __put_user_asm(x, ptr, retval, 4, "s32i", __cb); break;	\
 	case 8: {							\
 		     __typeof__(*ptr) __v64 = x;			\
-		     retval = __copy_to_user(ptr,&__v64,8);		\
+		     retval = __copy_to_user(ptr, &__v64, 8);		\
 		     break;						\
 	        }							\
 	default: __put_user_bad();					\
@@ -316,35 +316,35 @@ __asm__ __volatile__(					\
 	:"=r" (err), "=r" (cb)				\
 	:"r" ((int)(x)), "r" (addr), "i" (-EFAULT), "0" (err))
 
-#define __get_user_nocheck(x,ptr,size)				\
+#define __get_user_nocheck(x, ptr, size)			\
 ({								\
 	long __gu_err, __gu_val;				\
-	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
-	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
 	__gu_err;						\
 })
 
-#define __get_user_check(x,ptr,size)					\
+#define __get_user_check(x, ptr, size)					\
 ({									\
 	long __gu_err = -EFAULT, __gu_val = 0;				\
 	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
-	if (access_ok(VERIFY_READ,__gu_addr,size))			\
-		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
-	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
+	if (access_ok(VERIFY_READ, __gu_addr, size))			\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
 extern long __get_user_bad(void);
 
-#define __get_user_size(x,ptr,size,retval)				\
+#define __get_user_size(x, ptr, size, retval)				\
 do {									\
 	int __cb;							\
 	retval = 0;							\
 	switch (size) {							\
-	case 1: __get_user_asm(x,ptr,retval,1,"l8ui",__cb);  break;	\
-	case 2: __get_user_asm(x,ptr,retval,2,"l16ui",__cb); break;	\
-	case 4: __get_user_asm(x,ptr,retval,4,"l32i",__cb);  break;	\
-	case 8: retval = __copy_from_user(&x,ptr,8);    break;	\
+	case 1: __get_user_asm(x, ptr, retval, 1, "l8ui", __cb);  break;\
+	case 2: __get_user_asm(x, ptr, retval, 2, "l16ui", __cb); break;\
+	case 4: __get_user_asm(x, ptr, retval, 4, "l32i", __cb);  break;\
+	case 8: retval = __copy_from_user(&x, ptr, 8);    break;	\
 	default: (x) = __get_user_bad();				\
 	}								\
 } while (0)
@@ -390,19 +390,19 @@ __asm__ __volatile__(			\
  */
 
 extern unsigned __xtensa_copy_user(void *to, const void *from, unsigned n);
-#define __copy_user(to,from,size) __xtensa_copy_user(to,from,size)
+#define __copy_user(to, from, size) __xtensa_copy_user(to, from, size)
 
 
 static inline unsigned long
 __generic_copy_from_user_nocheck(void *to, const void *from, unsigned long n)
 {
-	return __copy_user(to,from,n);
+	return __copy_user(to, from, n);
 }
 
 static inline unsigned long
 __generic_copy_to_user_nocheck(void *to, const void *from, unsigned long n)
 {
-	return __copy_user(to,from,n);
+	return __copy_user(to, from, n);
 }
 
 static inline unsigned long
@@ -410,7 +410,7 @@ __generic_copy_to_user(void *to, const void *from, unsigned long n)
 {
 	prefetch(from);
 	if (access_ok(VERIFY_WRITE, to, n))
-		return __copy_user(to,from,n);
+		return __copy_user(to, from, n);
 	return n;
 }
 
@@ -419,18 +419,18 @@ __generic_copy_from_user(void *to, const void *from, unsigned long n)
 {
 	prefetchw(to);
 	if (access_ok(VERIFY_READ, from, n))
-		return __copy_user(to,from,n);
+		return __copy_user(to, from, n);
 	else
 		memset(to, 0, n);
 	return n;
 }
 
-#define copy_to_user(to,from,n) __generic_copy_to_user((to),(from),(n))
-#define copy_from_user(to,from,n) __generic_copy_from_user((to),(from),(n))
-#define __copy_to_user(to,from,n) \
-	__generic_copy_to_user_nocheck((to),(from),(n))
-#define __copy_from_user(to,from,n) \
-	__generic_copy_from_user_nocheck((to),(from),(n))
+#define copy_to_user(to, from, n) __generic_copy_to_user((to), (from), (n))
+#define copy_from_user(to, from, n) __generic_copy_from_user((to), (from), (n))
+#define __copy_to_user(to, from, n) \
+	__generic_copy_to_user_nocheck((to), (from), (n))
+#define __copy_from_user(to, from, n) \
+	__generic_copy_from_user_nocheck((to), (from), (n))
 #define __copy_to_user_inatomic __copy_to_user
 #define __copy_from_user_inatomic __copy_from_user
 
-- 
MST

