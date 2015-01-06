Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbbAFPrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:47:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbbAFPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:35 -0500
Date: Tue, 6 Jan 2015 17:45:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH v2 35/40] m32r: macro whitespace fixes
Message-ID: <1420558883-10131-36-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/m32r/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/m32r/include/asm/uaccess.h | 84 ++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index d076942..71adff2 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -54,7 +54,7 @@ static inline void set_fs(mm_segment_t s)
 
 #endif /* not CONFIG_MMU */
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 
 #define __addr_ok(addr) \
 	((unsigned long)(addr) < (current_thread_info()->addr_limit.seg))
@@ -68,7 +68,7 @@ static inline void set_fs(mm_segment_t s)
  *
  * This needs 33-bit arithmetic. We have a carry...
  */
-#define __range_ok(addr,size) ({					\
+#define __range_ok(addr, size) ({					\
 	unsigned long flag, roksum; 					\
 	__chk_user_ptr(addr);						\
 	asm ( 								\
@@ -103,7 +103,7 @@ static inline void set_fs(mm_segment_t s)
  * this function, memory access functions may still return -EFAULT.
  */
 #ifdef CONFIG_MMU
-#define access_ok(type,addr,size) (likely(__range_ok(addr,size) == 0))
+#define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
 #else
 static inline int access_ok(int type, const void *addr, unsigned long size)
 {
@@ -167,8 +167,8 @@ extern int fixup_exception(struct pt_regs *regs);
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define get_user(x,ptr)							\
-	__get_user_check((x),(ptr),sizeof(*(ptr)))
+#define get_user(x, ptr)							\
+	__get_user_check((x), (ptr), sizeof(*(ptr)))
 
 /**
  * put_user: - Write a simple value into user space.
@@ -186,8 +186,8 @@ extern int fixup_exception(struct pt_regs *regs);
  *
  * Returns zero on success, or -EFAULT on error.
  */
-#define put_user(x,ptr)							\
-	__put_user_check((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+#define put_user(x, ptr)							\
+	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
@@ -209,41 +209,41 @@ extern int fixup_exception(struct pt_regs *regs);
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define __get_user(x,ptr) \
-	__get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 
-#define __get_user_nocheck(x,ptr,size)					\
+#define __get_user_nocheck(x, ptr, size)				\
 ({									\
 	long __gu_err = 0;						\
 	unsigned long __gu_val;						\
 	might_fault();							\
-	__get_user_size(__gu_val,(ptr),(size),__gu_err);		\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err);		\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
-#define __get_user_check(x,ptr,size)					\
+#define __get_user_check(x, ptr, size)					\
 ({									\
 	long __gu_err = -EFAULT;					\
 	unsigned long __gu_val = 0;					\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
 	might_fault();							\
-	if (access_ok(VERIFY_READ,__gu_addr,size))			\
-		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
+	if (access_ok(VERIFY_READ, __gu_addr, size))			\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
 extern long __get_user_bad(void);
 
-#define __get_user_size(x,ptr,size,retval)				\
+#define __get_user_size(x, ptr, size, retval)				\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	  case 1: __get_user_asm(x,ptr,retval,"ub"); break;		\
-	  case 2: __get_user_asm(x,ptr,retval,"uh"); break;		\
-	  case 4: __get_user_asm(x,ptr,retval,""); break;		\
+	  case 1: __get_user_asm(x, ptr, retval, "ub"); break;		\
+	  case 2: __get_user_asm(x, ptr, retval, "uh"); break;		\
+	  case 4: __get_user_asm(x, ptr, retval, ""); break;		\
 	  default: (x) = __get_user_bad();				\
 	}								\
 } while (0)
@@ -288,26 +288,26 @@ do {									\
  *
  * Returns zero on success, or -EFAULT on error.
  */
-#define __put_user(x,ptr) \
-	__put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
+#define __put_user(x, ptr) \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 
-#define __put_user_nocheck(x,ptr,size)					\
+#define __put_user_nocheck(x, ptr, size)				\
 ({									\
 	long __pu_err;							\
 	might_fault();							\
-	__put_user_size((x),(ptr),(size),__pu_err);			\
+	__put_user_size((x), (ptr), (size), __pu_err);			\
 	__pu_err;							\
 })
 
 
-#define __put_user_check(x,ptr,size)					\
+#define __put_user_check(x, ptr, size)					\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
 	might_fault();							\
-	if (access_ok(VERIFY_WRITE,__pu_addr,size))			\
-		__put_user_size((x),__pu_addr,(size),__pu_err);		\
+	if (access_ok(VERIFY_WRITE, __pu_addr, size))			\
+		__put_user_size((x), __pu_addr, (size), __pu_err);	\
 	__pu_err;							\
 })
 
@@ -366,15 +366,15 @@ do {									\
 
 extern void __put_user_bad(void);
 
-#define __put_user_size(x,ptr,size,retval)				\
+#define __put_user_size(x, ptr, size, retval)				\
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	  case 1: __put_user_asm(x,ptr,retval,"b"); break;		\
-	  case 2: __put_user_asm(x,ptr,retval,"h"); break;		\
-	  case 4: __put_user_asm(x,ptr,retval,""); break;		\
-	  case 8: __put_user_u64((__typeof__(*ptr))(x),ptr,retval); break;\
+	  case 1: __put_user_asm(x, ptr, retval, "b"); break;		\
+	  case 2: __put_user_asm(x, ptr, retval, "h"); break;		\
+	  case 4: __put_user_asm(x, ptr, retval, ""); break;		\
+	  case 8: __put_user_u64((__typeof__(*ptr))(x), ptr, retval); break;\
 	  default: __put_user_bad();					\
 	}								\
 } while (0)
@@ -421,7 +421,7 @@ struct __large_struct { unsigned long buf[100]; };
 
 /* Generic arbitrary sized copy.  */
 /* Return the number of bytes NOT copied.  */
-#define __copy_user(to,from,size)					\
+#define __copy_user(to, from, size)					\
 do {									\
 	unsigned long __dst, __src, __c;				\
 	__asm__ __volatile__ (						\
@@ -478,7 +478,7 @@ do {									\
 		: "r14", "memory");					\
 } while (0)
 
-#define __copy_user_zeroing(to,from,size)				\
+#define __copy_user_zeroing(to, from, size)				\
 do {									\
 	unsigned long __dst, __src, __c;				\
 	__asm__ __volatile__ (						\
@@ -548,14 +548,14 @@ do {									\
 static inline unsigned long __generic_copy_from_user_nocheck(void *to,
 	const void __user *from, unsigned long n)
 {
-	__copy_user_zeroing(to,from,n);
+	__copy_user_zeroing(to, from, n);
 	return n;
 }
 
 static inline unsigned long __generic_copy_to_user_nocheck(void __user *to,
 	const void *from, unsigned long n)
 {
-	__copy_user(to,from,n);
+	__copy_user(to, from, n);
 	return n;
 }
 
@@ -576,8 +576,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * Returns number of bytes that could not be copied.
  * On success, this will be zero.
  */
-#define __copy_to_user(to,from,n)			\
-	__generic_copy_to_user_nocheck((to),(from),(n))
+#define __copy_to_user(to, from, n)			\
+	__generic_copy_to_user_nocheck((to), (from), (n))
 
 #define __copy_to_user_inatomic __copy_to_user
 #define __copy_from_user_inatomic __copy_from_user
@@ -595,10 +595,10 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * Returns number of bytes that could not be copied.
  * On success, this will be zero.
  */
-#define copy_to_user(to,from,n)				\
+#define copy_to_user(to, from, n)			\
 ({							\
 	might_fault();					\
-	__generic_copy_to_user((to),(from),(n));	\
+	__generic_copy_to_user((to), (from), (n));	\
 })
 
 /**
@@ -617,8 +617,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * If some data could not be copied, this function will pad the copied
  * data to the requested size using zero bytes.
  */
-#define __copy_from_user(to,from,n)			\
-	__generic_copy_from_user_nocheck((to),(from),(n))
+#define __copy_from_user(to, from, n)			\
+	__generic_copy_from_user_nocheck((to), (from), (n))
 
 /**
  * copy_from_user: - Copy a block of data from user space.
@@ -636,10 +636,10 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * If some data could not be copied, this function will pad the copied
  * data to the requested size using zero bytes.
  */
-#define copy_from_user(to,from,n)			\
+#define copy_from_user(to, from, n)			\
 ({							\
 	might_fault();					\
-	__generic_copy_from_user((to),(from),(n));	\
+	__generic_copy_from_user((to), (from), (n));	\
 })
 
 long __must_check strncpy_from_user(char *dst, const char __user *src,
-- 
MST

