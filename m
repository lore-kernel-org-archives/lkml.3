Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbbAFPsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:48:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbbAFPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:33 -0500
Date: Tue, 6 Jan 2015 17:45:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH v2 33/40] cris: macro whitespace fixes
Message-ID: <1420558883-10131-34-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/cris/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/cris/include/asm/uaccess.h | 113 +++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 55 deletions(-)

diff --git a/arch/cris/include/asm/uaccess.h b/arch/cris/include/asm/uaccess.h
index 9cf5a23..a21344a 100644
--- a/arch/cris/include/asm/uaccess.h
+++ b/arch/cris/include/asm/uaccess.h
@@ -47,12 +47,13 @@
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 
 #define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
-#define __user_ok(addr,size) (((size) <= TASK_SIZE)&&((addr) <= TASK_SIZE-(size)))
-#define __access_ok(addr,size) (__kernel_ok || __user_ok((addr),(size)))
-#define access_ok(type,addr,size) __access_ok((unsigned long)(addr),(size))
+#define __user_ok(addr, size) \
+	(((size) <= TASK_SIZE)&&((addr) <= TASK_SIZE-(size)))
+#define __access_ok(addr, size) (__kernel_ok || __user_ok((addr), (size)))
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr), (size))
 
 #include <arch/uaccess.h>
 
@@ -92,56 +93,56 @@ struct exception_table_entry
  * CRIS, we can just do these as direct assignments.  (Of course, the
  * exception handling means that it's no longer "just"...)
  */
-#define get_user(x,ptr) \
-  __get_user_check((x),(ptr),sizeof(*(ptr)))
-#define put_user(x,ptr) \
-  __put_user_check((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+#define get_user(x, ptr) \
+  __get_user_check((x), (ptr), sizeof(*(ptr)))
+#define put_user(x, ptr) \
+  __put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#define __get_user(x,ptr) \
-  __get_user_nocheck((x),(ptr),sizeof(*(ptr)))
-#define __put_user(x,ptr) \
-  __put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+  __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+#define __put_user(x, ptr) \
+  __put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 extern long __put_user_bad(void);
 
-#define __put_user_size(x,ptr,size,retval)			\
-do {								\
-	retval = 0;						\
-	switch (size) {						\
-	  case 1: __put_user_asm(x,ptr,retval,"move.b"); break;	\
-	  case 2: __put_user_asm(x,ptr,retval,"move.w"); break;	\
-	  case 4: __put_user_asm(x,ptr,retval,"move.d"); break;	\
-	  case 8: __put_user_asm_64(x,ptr,retval); break;	\
-	  default: __put_user_bad();				\
-	}							\
+#define __put_user_size(x, ptr, size, retval)				\
+do {									\
+	retval = 0;							\
+	switch (size) {							\
+	  case 1: __put_user_asm(x, ptr, retval, "move.b"); break;	\
+	  case 2: __put_user_asm(x, ptr, retval, "move.w"); break;	\
+	  case 4: __put_user_asm(x, ptr, retval, "move.d"); break;	\
+	  case 8: __put_user_asm_64(x, ptr, retval); break;		\
+	  default: __put_user_bad();					\
+	}								\
 } while (0)
 
-#define __get_user_size(x,ptr,size,retval)			\
-do {								\
-	retval = 0;						\
-	switch (size) {						\
-	  case 1: __get_user_asm(x,ptr,retval,"move.b"); break;	\
-	  case 2: __get_user_asm(x,ptr,retval,"move.w"); break;	\
-	  case 4: __get_user_asm(x,ptr,retval,"move.d"); break;	\
-	  case 8: __get_user_asm_64(x,ptr,retval); break;	\
-	  default: (x) = __get_user_bad();			\
-	}							\
+#define __get_user_size(x, ptr, size, retval)				\
+do {									\
+	retval = 0;							\
+	switch (size) {							\
+	  case 1: __get_user_asm(x, ptr, retval, "move.b"); break;	\
+	  case 2: __get_user_asm(x, ptr, retval, "move.w"); break;	\
+	  case 4: __get_user_asm(x, ptr, retval, "move.d"); break;	\
+	  case 8: __get_user_asm_64(x, ptr, retval); break;		\
+	  default: (x) = __get_user_bad();				\
+	}								\
 } while (0)
 
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
 
 struct __large_struct { unsigned long buf[100]; };
@@ -149,20 +150,20 @@ struct __large_struct { unsigned long buf[100]; };
 
 
 
-#define __get_user_nocheck(x,ptr,size)				\
+#define __get_user_nocheck(x, ptr, size)			\
 ({								\
 	long __gu_err, __gu_val;				\
-	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
 	__gu_err;						\
 })
 
-#define __get_user_check(x,ptr,size)					\
+#define __get_user_check(x, ptr, size)					\
 ({									\
 	long __gu_err = -EFAULT, __gu_val = 0;				\
 	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
-	if (access_ok(VERIFY_READ,__gu_addr,size))			\
-		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
+	if (access_ok(VERIFY_READ, __gu_addr, size))			\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
@@ -180,7 +181,7 @@ static inline unsigned long
 __generic_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	if (access_ok(VERIFY_WRITE, to, n))
-		return __copy_user(to,from,n);
+		return __copy_user(to, from, n);
 	return n;
 }
 
@@ -188,7 +189,7 @@ static inline unsigned long
 __generic_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	if (access_ok(VERIFY_READ, from, n))
-		return __copy_user_zeroing(to,from,n);
+		return __copy_user_zeroing(to, from, n);
 	return n;
 }
 
@@ -196,7 +197,7 @@ static inline unsigned long
 __generic_clear_user(void __user *to, unsigned long n)
 {
 	if (access_ok(VERIFY_WRITE, to, n))
-		return __do_clear_user(to,n);
+		return __do_clear_user(to, n);
 	return n;
 }
 
@@ -373,29 +374,31 @@ static inline unsigned long
 __generic_copy_from_user_nocheck(void *to, const void __user *from,
 				 unsigned long n)
 {
-	return __copy_user_zeroing(to,from,n);
+	return __copy_user_zeroing(to, from, n);
 }
 
 static inline unsigned long
 __generic_copy_to_user_nocheck(void __user *to, const void *from,
 			       unsigned long n)
 {
-	return __copy_user(to,from,n);
+	return __copy_user(to, from, n);
 }
 
 static inline unsigned long
 __generic_clear_user_nocheck(void __user *to, unsigned long n)
 {
-	return __do_clear_user(to,n);
+	return __do_clear_user(to, n);
 }
 
 /* without checking */
 
-#define __copy_to_user(to,from,n)   __generic_copy_to_user_nocheck((to),(from),(n))
-#define __copy_from_user(to,from,n) __generic_copy_from_user_nocheck((to),(from),(n))
+#define __copy_to_user(to, from, n) \
+	__generic_copy_to_user_nocheck((to), (from), (n))
+#define __copy_from_user(to, from, n) \
+	__generic_copy_from_user_nocheck((to), (from), (n))
 #define __copy_to_user_inatomic __copy_to_user
 #define __copy_from_user_inatomic __copy_from_user
-#define __clear_user(to,n) __generic_clear_user_nocheck((to),(n))
+#define __clear_user(to, n) __generic_clear_user_nocheck((to), (n))
 
 #define strlen_user(str)	strnlen_user((str), 0x7ffffffe)
 
-- 
MST

