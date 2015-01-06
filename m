Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbbAFPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:48:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbbAFPp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:27 -0500
Date: Tue, 6 Jan 2015 17:45:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH v2 29/40] alpha: macro whitespace fixes
Message-ID: <1420558883-10131-30-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/alpha/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/alpha/include/asm/uaccess.h | 82 ++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/alpha/include/asm/uaccess.h b/arch/alpha/include/asm/uaccess.h
index a234de7..9b0d400 100644
--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -27,7 +27,7 @@
 #define get_ds()  (KERNEL_DS)
 #define set_fs(x) (current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 
 /*
  * Is a address valid? This does a straightforward calculation rather
@@ -39,13 +39,13 @@
  *  - AND "addr+size" doesn't have any high-bits set
  *  - OR we are in kernel mode.
  */
-#define __access_ok(addr,size,segment) \
+#define __access_ok(addr, size, segment) \
 	(((segment).seg & (addr | size | (addr+size))) == 0)
 
-#define access_ok(type,addr,size)				\
+#define access_ok(type, addr, size)				\
 ({								\
 	__chk_user_ptr(addr);					\
-	__access_ok(((unsigned long)(addr)),(size),get_fs());	\
+	__access_ok(((unsigned long)(addr)), (size), get_fs());	\
 })
 
 /*
@@ -60,20 +60,20 @@
  * (a) re-use the arguments for side effects (sizeof/typeof is ok)
  * (b) require any knowledge of processes at this stage
  */
-#define put_user(x,ptr) \
-  __put_user_check((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)),get_fs())
-#define get_user(x,ptr) \
-  __get_user_check((x),(ptr),sizeof(*(ptr)),get_fs())
+#define put_user(x, ptr) \
+  __put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), get_fs())
+#define get_user(x, ptr) \
+  __get_user_check((x), (ptr), sizeof(*(ptr)), get_fs())
 
 /*
  * The "__xxx" versions do not do address space checking, useful when
  * doing multiple accesses to the same area (the programmer has to do the
  * checks by hand with "access_ok()")
  */
-#define __put_user(x,ptr) \
-  __put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
-#define __get_user(x,ptr) \
-  __get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __put_user(x, ptr) \
+  __put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+  __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
   
 /*
  * The "lda %1, 2b-1b(%0)" bits are magic to get the assembler to
@@ -84,7 +84,7 @@
 
 extern void __get_user_unknown(void);
 
-#define __get_user_nocheck(x,ptr,size)				\
+#define __get_user_nocheck(x, ptr, size)			\
 ({								\
 	long __gu_err = 0;					\
 	unsigned long __gu_val;					\
@@ -100,12 +100,12 @@ extern void __get_user_unknown(void);
 	__gu_err;						\
 })
 
-#define __get_user_check(x,ptr,size,segment)				\
+#define __get_user_check(x, ptr, size, segment)				\
 ({									\
 	long __gu_err = -EFAULT;					\
 	unsigned long __gu_val = 0;					\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
-	if (__access_ok((unsigned long)__gu_addr,size,segment)) {	\
+	if (__access_ok((unsigned long)__gu_addr, size, segment)) {	\
 		__gu_err = 0;						\
 		switch (size) {						\
 		  case 1: __get_user_8(__gu_addr); break;		\
@@ -201,31 +201,31 @@ struct __large_struct { unsigned long buf[100]; };
 
 extern void __put_user_unknown(void);
 
-#define __put_user_nocheck(x,ptr,size)				\
+#define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	long __pu_err = 0;					\
 	__chk_user_ptr(ptr);					\
 	switch (size) {						\
-	  case 1: __put_user_8(x,ptr); break;			\
-	  case 2: __put_user_16(x,ptr); break;			\
-	  case 4: __put_user_32(x,ptr); break;			\
-	  case 8: __put_user_64(x,ptr); break;			\
+	  case 1: __put_user_8(x, ptr); break;			\
+	  case 2: __put_user_16(x, ptr); break;			\
+	  case 4: __put_user_32(x, ptr); break;			\
+	  case 8: __put_user_64(x, ptr); break;			\
 	  default: __put_user_unknown(); break;			\
 	}							\
 	__pu_err;						\
 })
 
-#define __put_user_check(x,ptr,size,segment)				\
+#define __put_user_check(x, ptr, size, segment)				\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
-	if (__access_ok((unsigned long)__pu_addr,size,segment)) {	\
+	if (__access_ok((unsigned long)__pu_addr, size, segment)) {	\
 		__pu_err = 0;						\
 		switch (size) {						\
-		  case 1: __put_user_8(x,__pu_addr); break;		\
-		  case 2: __put_user_16(x,__pu_addr); break;		\
-		  case 4: __put_user_32(x,__pu_addr); break;		\
-		  case 8: __put_user_64(x,__pu_addr); break;		\
+		  case 1: __put_user_8(x, __pu_addr); break;		\
+		  case 2: __put_user_16(x, __pu_addr); break;		\
+		  case 4: __put_user_32(x, __pu_addr); break;		\
+		  case 8: __put_user_64(x, __pu_addr); break;		\
 		  default: __put_user_unknown(); break;			\
 		}							\
 	}								\
@@ -237,7 +237,7 @@ extern void __put_user_unknown(void);
  * instead of writing: this is because they do not write to
  * any memory gcc knows about, so there are no aliasing issues
  */
-#define __put_user_64(x,addr)					\
+#define __put_user_64(x, addr)					\
 __asm__ __volatile__("1: stq %r2,%1\n"				\
 	"2:\n"							\
 	".section __ex_table,\"a\"\n"				\
@@ -247,7 +247,7 @@ __asm__ __volatile__("1: stq %r2,%1\n"				\
 		: "=r"(__pu_err)				\
 		: "m" (__m(addr)), "rJ" (x), "0"(__pu_err))
 
-#define __put_user_32(x,addr)					\
+#define __put_user_32(x, addr)					\
 __asm__ __volatile__("1: stl %r2,%1\n"				\
 	"2:\n"							\
 	".section __ex_table,\"a\"\n"				\
@@ -260,7 +260,7 @@ __asm__ __volatile__("1: stl %r2,%1\n"				\
 #ifdef __alpha_bwx__
 /* Those lucky bastards with ev56 and later CPUs can do byte/word moves.  */
 
-#define __put_user_16(x,addr)					\
+#define __put_user_16(x, addr)					\
 __asm__ __volatile__("1: stw %r2,%1\n"				\
 	"2:\n"							\
 	".section __ex_table,\"a\"\n"				\
@@ -270,7 +270,7 @@ __asm__ __volatile__("1: stw %r2,%1\n"				\
 		: "=r"(__pu_err)				\
 		: "m"(__m(addr)), "rJ"(x), "0"(__pu_err))
 
-#define __put_user_8(x,addr)					\
+#define __put_user_8(x, addr)					\
 __asm__ __volatile__("1: stb %r2,%1\n"				\
 	"2:\n"							\
 	".section __ex_table,\"a\"\n"				\
@@ -283,7 +283,7 @@ __asm__ __volatile__("1: stb %r2,%1\n"				\
 /* Unfortunately, we can't get an unaligned access trap for the sub-word
    write, so we have to do a general unaligned operation.  */
 
-#define __put_user_16(x,addr)					\
+#define __put_user_16(x, addr)					\
 {								\
 	long __pu_tmp1, __pu_tmp2, __pu_tmp3, __pu_tmp4;	\
 	__asm__ __volatile__(					\
@@ -308,13 +308,13 @@ __asm__ __volatile__("1: stb %r2,%1\n"				\
 	"	.long 4b - .\n"					\
 	"	lda $31, 5b-4b(%0)\n"				\
 	".previous"						\
-		: "=r"(__pu_err), "=&r"(__pu_tmp1),		\
-		  "=&r"(__pu_tmp2), "=&r"(__pu_tmp3),		\
+		: "=r"(__pu_err), "=&r"(__pu_tmp1), 		\
+		  "=&r"(__pu_tmp2), "=&r"(__pu_tmp3), 		\
 		  "=&r"(__pu_tmp4)				\
 		: "r"(addr), "r"((unsigned long)(x)), "0"(__pu_err)); \
 }
 
-#define __put_user_8(x,addr)					\
+#define __put_user_8(x, addr)					\
 {								\
 	long __pu_tmp1, __pu_tmp2;				\
 	__asm__ __volatile__(					\
@@ -330,7 +330,7 @@ __asm__ __volatile__("1: stb %r2,%1\n"				\
 	"	.long 2b - .\n"					\
 	"	lda $31, 3b-2b(%0)\n"				\
 	".previous"						\
-		: "=r"(__pu_err),				\
+		: "=r"(__pu_err), 				\
 	  	  "=&r"(__pu_tmp1), "=&r"(__pu_tmp2)		\
 		: "r"((unsigned long)(x)), "r"(addr), "0"(__pu_err)); \
 }
@@ -366,7 +366,7 @@ __copy_tofrom_user_nocheck(void *to, const void *from, long len)
 		: "=r" (__cu_len), "=r" (__cu_from), "=r" (__cu_to)
 		: __module_address(__copy_user)
 		  "0" (__cu_len), "1" (__cu_from), "2" (__cu_to)
-		: "$1","$2","$3","$4","$5","$28","memory");
+		: "$1", "$2", "$3", "$4", "$5", "$28", "memory");
 
 	return __cu_len;
 }
@@ -379,15 +379,15 @@ __copy_tofrom_user(void *to, const void *from, long len, const void __user *vali
 	return len;
 }
 
-#define __copy_to_user(to,from,n)					\
+#define __copy_to_user(to, from, n)					\
 ({									\
 	__chk_user_ptr(to);						\
-	__copy_tofrom_user_nocheck((__force void *)(to),(from),(n));	\
+	__copy_tofrom_user_nocheck((__force void *)(to), (from), (n));	\
 })
-#define __copy_from_user(to,from,n)					\
+#define __copy_from_user(to, from, n)					\
 ({									\
 	__chk_user_ptr(from);						\
-	__copy_tofrom_user_nocheck((to),(__force void *)(from),(n));	\
+	__copy_tofrom_user_nocheck((to), (__force void *)(from), (n));	\
 })
 
 #define __copy_to_user_inatomic __copy_to_user
@@ -418,7 +418,7 @@ __clear_user(void __user *to, long len)
 		: "=r"(__cl_len), "=r"(__cl_to)
 		: __module_address(__do_clear_user)
 		  "0"(__cl_len), "1"(__cl_to)
-		: "$1","$2","$3","$4","$5","$28","memory");
+		: "$1", "$2", "$3", "$4", "$5", "$28", "memory");
 	return __cl_len;
 }
 
-- 
MST

