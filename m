Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbbAFPtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:49:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbbAFPpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:06 -0500
Date: Tue, 6 Jan 2015 17:44:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, sparclinux@vger.kernel.org
Subject: [PATCH v2 25/40] arch/sparc: uaccess_32 macro whitespace fixes
Message-ID: <1420558883-10131-26-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros within arch/sparc/include/asm/uaccess_32.h are made harder to
read because they violate a bunch of coding style rules.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/sparc/include/asm/uaccess_32.h | 364 ++++++++++++++++++++++--------------
 1 file changed, 226 insertions(+), 138 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index 8b571a0..03230cb 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -37,7 +37,7 @@
 #define get_fs()	(current->thread.current_ds)
 #define set_fs(val)	((current->thread.current_ds) = (val))
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b) ((a).seg == (b).seg)
 
 /* We have there a nice not-mapped page at PAGE_OFFSET - PAGE_SIZE, so that this test
  * can be fairly lightweight.
@@ -46,8 +46,8 @@
  */
 #define __user_ok(addr, size) ({ (void)(size); (addr) < STACK_TOP; })
 #define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
-#define __access_ok(addr,size) (__user_ok((addr) & get_fs().seg,(size)))
-#define access_ok(type, addr, size)					\
+#define __access_ok(addr, size) (__user_ok((addr) & get_fs().seg, (size)))
+#define access_ok(type, addr, size) \
 	({ (void)(type); __access_ok((unsigned long)(addr), size); })
 
 /*
@@ -91,158 +91,246 @@ void __ret_efault(void);
  * of a performance impact. Thus we have a few rather ugly macros here,
  * and hide all the ugliness from the user.
  */
-#define put_user(x,ptr) ({ \
-unsigned long __pu_addr = (unsigned long)(ptr); \
-__chk_user_ptr(ptr); \
-__put_user_check((__typeof__(*(ptr)))(x),__pu_addr,sizeof(*(ptr))); })
-
-#define get_user(x,ptr) ({ \
-unsigned long __gu_addr = (unsigned long)(ptr); \
-__chk_user_ptr(ptr); \
-__get_user_check((x),__gu_addr,sizeof(*(ptr)),__typeof__(*(ptr))); })
+#define put_user(x, ptr) ({ \
+	unsigned long __pu_addr = (unsigned long)(ptr); \
+	__chk_user_ptr(ptr); \
+	__put_user_check((__typeof__(*(ptr)))(x), __pu_addr, sizeof(*(ptr))); \
+})
+
+#define get_user(x, ptr) ({ \
+	unsigned long __gu_addr = (unsigned long)(ptr); \
+	__chk_user_ptr(ptr); \
+	__get_user_check((x), __gu_addr, sizeof(*(ptr)), __typeof__(*(ptr))); \
+})
 
 /*
  * The "__xxx" versions do not do address space checking, useful when
  * doing multiple accesses to the same area (the user has to do the
  * checks by hand with "access_ok()")
  */
-#define __put_user(x,ptr) __put_user_nocheck((__typeof__(*(ptr)))(x),(ptr),sizeof(*(ptr)))
-#define __get_user(x,ptr) __get_user_nocheck((x),(ptr),sizeof(*(ptr)),__typeof__(*(ptr)))
+#define __put_user(x, ptr) \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+    __get_user_nocheck((x), (ptr), sizeof(*(ptr)), __typeof__(*(ptr)))
 
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) ((struct __large_struct __user *)(x))
 
-#define __put_user_check(x,addr,size) ({ \
-register int __pu_ret; \
-if (__access_ok(addr,size)) { \
-switch (size) { \
-case 1: __put_user_asm(x,b,addr,__pu_ret); break; \
-case 2: __put_user_asm(x,h,addr,__pu_ret); break; \
-case 4: __put_user_asm(x,,addr,__pu_ret); break; \
-case 8: __put_user_asm(x,d,addr,__pu_ret); break; \
-default: __pu_ret = __put_user_bad(); break; \
-} } else { __pu_ret = -EFAULT; } __pu_ret; })
-
-#define __put_user_nocheck(x,addr,size) ({ \
-register int __pu_ret; \
-switch (size) { \
-case 1: __put_user_asm(x,b,addr,__pu_ret); break; \
-case 2: __put_user_asm(x,h,addr,__pu_ret); break; \
-case 4: __put_user_asm(x,,addr,__pu_ret); break; \
-case 8: __put_user_asm(x,d,addr,__pu_ret); break; \
-default: __pu_ret = __put_user_bad(); break; \
-} __pu_ret; })
-
-#define __put_user_asm(x,size,addr,ret)					\
+#define __put_user_check(x, addr, size) ({ \
+	register int __pu_ret; \
+	if (__access_ok(addr, size)) { \
+		switch (size) { \
+		case 1: \
+			__put_user_asm(x, b, addr, __pu_ret); \
+			break; \
+		case 2: \
+			__put_user_asm(x, h, addr, __pu_ret); \
+			break; \
+		case 4: \
+			__put_user_asm(x, , addr, __pu_ret); \
+			break; \
+		case 8: \
+			__put_user_asm(x, d, addr, __pu_ret); \
+			break; \
+		default: \
+			__pu_ret = __put_user_bad(); \
+			break; \
+		} \
+	} else { \
+		__pu_ret = -EFAULT; \
+	} \
+	__pu_ret; \
+})
+
+#define __put_user_nocheck(x, addr, size) ({ \
+	register int __pu_ret; \
+	switch (size) { \
+	case 1: \
+		__put_user_asm(x, b, addr, __pu_ret); \
+		break; \
+	case 2: \
+		__put_user_asm(x, h, addr, __pu_ret); \
+		break; \
+	case 4: \
+		__put_user_asm(x, , addr, __pu_ret); \
+		break; \
+	case 8: \
+		__put_user_asm(x, d, addr, __pu_ret); \
+		break; \
+	default: \
+		__pu_ret = __put_user_bad(); \
+		break; \
+	} __pu_ret; \
+})
+
+#define __put_user_asm(x, size, addr, ret)				\
 __asm__ __volatile__(							\
-	"/* Put user asm, inline. */\n"					\
-"1:\t"	"st"#size " %1, %2\n\t"						\
-	"clr	%0\n"							\
-"2:\n\n\t"								\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"b	2b\n\t"							\
-	" mov	%3, %0\n\t"						\
-        ".previous\n\n\t"						\
-	".section __ex_table,#alloc\n\t"				\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\t"						\
-	".previous\n\n\t"						\
-       : "=&r" (ret) : "r" (x), "m" (*__m(addr)),			\
-	 "i" (-EFAULT))
+		"/* Put user asm, inline. */\n"				\
+	"1:\t"	"st"#size " %1, %2\n\t"					\
+		"clr	%0\n"						\
+	"2:\n\n\t"							\
+		".section .fixup,#alloc,#execinstr\n\t"			\
+		".align	4\n"						\
+	"3:\n\t"							\
+		"b	2b\n\t"						\
+		" mov	%3, %0\n\t"					\
+		".previous\n\n\t"					\
+		".section __ex_table,#alloc\n\t"			\
+		".align	4\n\t"						\
+		".word	1b, 3b\n\t"					\
+		".previous\n\n\t"					\
+	       : "=&r" (ret) : "r" (x), "m" (*__m(addr)),		\
+		 "i" (-EFAULT))
 
 int __put_user_bad(void);
 
-#define __get_user_check(x,addr,size,type) ({ \
-register int __gu_ret; \
-register unsigned long __gu_val; \
-if (__access_ok(addr,size)) { \
-switch (size) { \
-case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break; \
-case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
-case 4: __get_user_asm(__gu_val,,addr,__gu_ret); break; \
-case 8: __get_user_asm(__gu_val,d,addr,__gu_ret); break; \
-default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} } else { __gu_val = 0; __gu_ret = -EFAULT; } x = (__force type) __gu_val; __gu_ret; })
-
-#define __get_user_check_ret(x,addr,size,type,retval) ({ \
-register unsigned long __gu_val __asm__ ("l1"); \
-if (__access_ok(addr,size)) { \
-switch (size) { \
-case 1: __get_user_asm_ret(__gu_val,ub,addr,retval); break; \
-case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
-case 4: __get_user_asm_ret(__gu_val,,addr,retval); break; \
-case 8: __get_user_asm_ret(__gu_val,d,addr,retval); break; \
-default: if (__get_user_bad()) return retval; \
-} x = (__force type) __gu_val; } else return retval; })
-
-#define __get_user_nocheck(x,addr,size,type) ({ \
-register int __gu_ret; \
-register unsigned long __gu_val; \
-switch (size) { \
-case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break; \
-case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
-case 4: __get_user_asm(__gu_val,,addr,__gu_ret); break; \
-case 8: __get_user_asm(__gu_val,d,addr,__gu_ret); break; \
-default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} x = (__force type) __gu_val; __gu_ret; })
-
-#define __get_user_nocheck_ret(x,addr,size,type,retval) ({ \
-register unsigned long __gu_val __asm__ ("l1"); \
-switch (size) { \
-case 1: __get_user_asm_ret(__gu_val,ub,addr,retval); break; \
-case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
-case 4: __get_user_asm_ret(__gu_val,,addr,retval); break; \
-case 8: __get_user_asm_ret(__gu_val,d,addr,retval); break; \
-default: if (__get_user_bad()) return retval; \
-} x = (__force type) __gu_val; })
-
-#define __get_user_asm(x,size,addr,ret)					\
+#define __get_user_check(x, addr, size, type) ({ \
+	register int __gu_ret; \
+	register unsigned long __gu_val; \
+	if (__access_ok(addr, size)) { \
+		switch (size) { \
+		case 1: \
+			 __get_user_asm(__gu_val, ub, addr, __gu_ret); \
+			break; \
+		case 2: \
+			__get_user_asm(__gu_val, uh, addr, __gu_ret); \
+			break; \
+		case 4: \
+			__get_user_asm(__gu_val, , addr, __gu_ret); \
+			break; \
+		case 8: \
+			__get_user_asm(__gu_val, d, addr, __gu_ret); \
+			break; \
+		default: \
+			__gu_val = 0; \
+			__gu_ret = __get_user_bad(); \
+			break; \
+		} \
+	 } else { \
+		 __gu_val = 0; \
+		 __gu_ret = -EFAULT; \
+	} \
+	x = (__force type) __gu_val; \
+	__gu_ret; \
+})
+
+#define __get_user_check_ret(x, addr, size, type, retval) ({ \
+	register unsigned long __gu_val __asm__ ("l1"); \
+	if (__access_ok(addr, size)) { \
+		switch (size) { \
+		case 1: \
+			__get_user_asm_ret(__gu_val, ub, addr, retval); \
+			break; \
+		case 2: \
+			__get_user_asm_ret(__gu_val, uh, addr, retval); \
+			break; \
+		case 4: \
+			__get_user_asm_ret(__gu_val, , addr, retval); \
+			break; \
+		case 8: \
+			__get_user_asm_ret(__gu_val, d, addr, retval); \
+			break; \
+		default: \
+			if (__get_user_bad()) \
+				return retval; \
+		} \
+		x = (__force type) __gu_val; \
+	} else \
+		return retval; \
+})
+
+#define __get_user_nocheck(x, addr, size, type) ({ \
+	register int __gu_ret; \
+	register unsigned long __gu_val; \
+	switch (size) { \
+	case 1: \
+		__get_user_asm(__gu_val, ub, addr, __gu_ret); \
+		break; \
+	case 2: \
+		__get_user_asm(__gu_val, uh, addr, __gu_ret); \
+		break; \
+	case 4: \
+		__get_user_asm(__gu_val, , addr, __gu_ret); \
+		break; \
+	case 8: \
+		__get_user_asm(__gu_val, d, addr, __gu_ret); \
+		break; \
+	default: \
+		__gu_val = 0; \
+		__gu_ret = __get_user_bad(); \
+		break; \
+	} \
+	x = (__force type) __gu_val; \
+	__gu_ret; \
+})
+
+#define __get_user_nocheck_ret(x, addr, size, type, retval) ({ \
+	register unsigned long __gu_val __asm__ ("l1"); \
+	switch (size) { \
+	case 1: \
+		__get_user_asm_ret(__gu_val, ub, addr, retval); \
+		break; \
+	case 2: \
+		__get_user_asm_ret(__gu_val, uh, addr, retval); \
+		break; \
+	case 4: \
+		__get_user_asm_ret(__gu_val, , addr, retval); \
+		break; \
+	case 8: \
+		__get_user_asm_ret(__gu_val, d, addr, retval); \
+		break; \
+	default: \
+		if (__get_user_bad()) \
+			return retval; \
+	} \
+	x = (__force type) __gu_val; \
+})
+
+#define __get_user_asm(x, size, addr, ret)				\
 __asm__ __volatile__(							\
-	"/* Get user asm, inline. */\n"					\
-"1:\t"	"ld"#size " %2, %1\n\t"						\
-	"clr	%0\n"							\
-"2:\n\n\t"								\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"clr	%1\n\t"							\
-	"b	2b\n\t"							\
-	" mov	%3, %0\n\n\t"						\
-	".previous\n\t"							\
-	".section __ex_table,#alloc\n\t"				\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\n\t"						\
-	".previous\n\t"							\
-       : "=&r" (ret), "=&r" (x) : "m" (*__m(addr)),			\
-	 "i" (-EFAULT))
-
-#define __get_user_asm_ret(x,size,addr,retval)				\
+		"/* Get user asm, inline. */\n"				\
+	"1:\t"	"ld"#size " %2, %1\n\t"					\
+		"clr	%0\n"						\
+	"2:\n\n\t"							\
+		".section .fixup,#alloc,#execinstr\n\t"			\
+		".align	4\n"						\
+	"3:\n\t"							\
+		"clr	%1\n\t"						\
+		"b	2b\n\t"						\
+		" mov	%3, %0\n\n\t"					\
+		".previous\n\t"						\
+		".section __ex_table,#alloc\n\t"			\
+		".align	4\n\t"						\
+		".word	1b, 3b\n\n\t"					\
+		".previous\n\t"						\
+	       : "=&r" (ret), "=&r" (x) : "m" (*__m(addr)),		\
+		 "i" (-EFAULT))
+
+#define __get_user_asm_ret(x, size, addr, retval)			\
 if (__builtin_constant_p(retval) && retval == -EFAULT)			\
-__asm__ __volatile__(							\
-	"/* Get user asm ret, inline. */\n"				\
-"1:\t"	"ld"#size " %1, %0\n\n\t"					\
-	".section __ex_table,#alloc\n\t"				\
-	".align	4\n\t"							\
-	".word	1b,__ret_efault\n\n\t"					\
-	".previous\n\t"							\
-       : "=&r" (x) : "m" (*__m(addr)));					\
+	__asm__ __volatile__(						\
+			"/* Get user asm ret, inline. */\n"		\
+		"1:\t"	"ld"#size " %1, %0\n\n\t"			\
+			".section __ex_table,#alloc\n\t"		\
+			".align	4\n\t"					\
+			".word	1b,__ret_efault\n\n\t"			\
+			".previous\n\t"					\
+		       : "=&r" (x) : "m" (*__m(addr)));			\
 else									\
-__asm__ __volatile__(							\
-	"/* Get user asm ret, inline. */\n"				\
-"1:\t"	"ld"#size " %1, %0\n\n\t"					\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"ret\n\t"							\
-	" restore %%g0, %2, %%o0\n\n\t"					\
-	".previous\n\t"							\
-	".section __ex_table,#alloc\n\t"				\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\n\t"						\
-	".previous\n\t"							\
-       : "=&r" (x) : "m" (*__m(addr)), "i" (retval))
+	__asm__ __volatile__(						\
+			"/* Get user asm ret, inline. */\n"		\
+		"1:\t"	"ld"#size " %1, %0\n\n\t"			\
+			".section .fixup,#alloc,#execinstr\n\t"		\
+			".align	4\n"					\
+		"3:\n\t"						\
+			"ret\n\t"					\
+			" restore %%g0, %2, %%o0\n\n\t"			\
+			".previous\n\t"					\
+			".section __ex_table,#alloc\n\t"		\
+			".align	4\n\t"					\
+			".word	1b, 3b\n\n\t"				\
+			".previous\n\t"					\
+		       : "=&r" (x) : "m" (*__m(addr)), "i" (retval))
 
 int __get_user_bad(void);
 
-- 
MST

