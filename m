Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbbAFPpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbbAFPpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:09 -0500
Date: Tue, 6 Jan 2015 17:44:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, sparclinux@vger.kernel.org
Subject: [PATCH v2 26/40] arch/sparc: uaccess_64 macro whitespace fixes
Message-ID: <1420558883-10131-27-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros within arch/sparc/include/asm/uaccess_64.h are made harder to
read because they violate a bunch of coding style rules.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/sparc/include/asm/uaccess_64.h | 246 +++++++++++++++++++++---------------
 1 file changed, 142 insertions(+), 104 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index b80866d..45d84b1 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -41,11 +41,11 @@
 #define get_fs() ((mm_segment_t){(current_thread_info()->current_ds)})
 #define get_ds() (KERNEL_DS)
 
-#define segment_eq(a,b)  ((a).seg == (b).seg)
+#define segment_eq(a, b)  ((a).seg == (b).seg)
 
 #define set_fs(val)								\
 do {										\
-	current_thread_info()->current_ds =(val).seg;				\
+	current_thread_info()->current_ds = (val).seg;				\
 	__asm__ __volatile__ ("wr %%g0, %0, %%asi" : : "r" ((val).seg));	\
 } while(0)
 
@@ -88,121 +88,159 @@ void __retl_efault(void);
  * of a performance impact. Thus we have a few rather ugly macros here,
  * and hide all the ugliness from the user.
  */
-#define put_user(x,ptr) ({ \
-unsigned long __pu_addr = (unsigned long)(ptr); \
-__chk_user_ptr(ptr); \
-__put_user_nocheck((__typeof__(*(ptr)))(x),__pu_addr,sizeof(*(ptr))); })
+#define put_user(x, ptr) ({ \
+	unsigned long __pu_addr = (unsigned long)(ptr); \
+	__chk_user_ptr(ptr); \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), __pu_addr, sizeof(*(ptr)));\
+})
 
-#define get_user(x,ptr) ({ \
-unsigned long __gu_addr = (unsigned long)(ptr); \
-__chk_user_ptr(ptr); \
-__get_user_nocheck((x),__gu_addr,sizeof(*(ptr)),__typeof__(*(ptr))); })
+#define get_user(x, ptr) ({ \
+	unsigned long __gu_addr = (unsigned long)(ptr); \
+	__chk_user_ptr(ptr); \
+	__get_user_nocheck((x), __gu_addr, sizeof(*(ptr)), __typeof__(*(ptr)));\
+})
 
-#define __put_user(x,ptr) put_user(x,ptr)
-#define __get_user(x,ptr) get_user(x,ptr)
+#define __put_user(x, ptr) put_user(x, ptr)
+#define __get_user(x, ptr) get_user(x, ptr)
 
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) ((struct __large_struct *)(x))
 
-#define __put_user_nocheck(data,addr,size) ({ \
-register int __pu_ret; \
-switch (size) { \
-case 1: __put_user_asm(data,b,addr,__pu_ret); break; \
-case 2: __put_user_asm(data,h,addr,__pu_ret); break; \
-case 4: __put_user_asm(data,w,addr,__pu_ret); break; \
-case 8: __put_user_asm(data,x,addr,__pu_ret); break; \
-default: __pu_ret = __put_user_bad(); break; \
-} __pu_ret; })
-
-#define __put_user_asm(x,size,addr,ret)					\
+#define __put_user_nocheck(data, addr, size) ({ \
+	register int __pu_ret; \
+	switch (size) { \
+	case 1: \
+		__put_user_asm(data, b, addr, __pu_ret); \
+		break; \
+	case 2: \
+		__put_user_asm(data, h, addr, __pu_ret); \
+		break; \
+	case 4: \
+		__put_user_asm(data, w, addr, __pu_ret); \
+		break; \
+	case 8: \
+		__put_user_asm(data, x, addr, __pu_ret); \
+		break; \
+	default: \
+		__pu_ret = __put_user_bad(); \
+		break; \
+	} \
+	__pu_ret; \
+})
+
+#define __put_user_asm(x, size, addr, ret)				\
 __asm__ __volatile__(							\
-	"/* Put user asm, inline. */\n"					\
-"1:\t"	"st"#size "a %1, [%2] %%asi\n\t"				\
-	"clr	%0\n"							\
-"2:\n\n\t"								\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"sethi	%%hi(2b), %0\n\t"					\
-	"jmpl	%0 + %%lo(2b), %%g0\n\t"				\
-	" mov	%3, %0\n\n\t"						\
-	".previous\n\t"							\
-	".section __ex_table,\"a\"\n\t"					\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\t"						\
-	".previous\n\n\t"						\
-       : "=r" (ret) : "r" (x), "r" (__m(addr)),				\
-	 "i" (-EFAULT))
+		"/* Put user asm, inline. */\n"				\
+	"1:\t"	"st"#size "a %1, [%2] %%asi\n\t"			\
+		"clr	%0\n"						\
+	"2:\n\n\t"							\
+		".section .fixup,#alloc,#execinstr\n\t"			\
+		".align	4\n"						\
+	"3:\n\t"							\
+		"sethi	%%hi(2b), %0\n\t"				\
+		"jmpl	%0 + %%lo(2b), %%g0\n\t"			\
+		" mov	%3, %0\n\n\t"					\
+		".previous\n\t"						\
+		".section __ex_table,\"a\"\n\t"				\
+		".align	4\n\t"						\
+		".word	1b, 3b\n\t"					\
+		".previous\n\n\t"					\
+	       : "=r" (ret) : "r" (x), "r" (__m(addr)),			\
+		 "i" (-EFAULT))
 
 int __put_user_bad(void);
 
-#define __get_user_nocheck(data,addr,size,type) ({ \
-register int __gu_ret; \
-register unsigned long __gu_val; \
-switch (size) { \
-case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break; \
-case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
-case 4: __get_user_asm(__gu_val,uw,addr,__gu_ret); break; \
-case 8: __get_user_asm(__gu_val,x,addr,__gu_ret); break; \
-default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} data = (__force type) __gu_val; __gu_ret; })
-
-#define __get_user_nocheck_ret(data,addr,size,type,retval) ({ \
-register unsigned long __gu_val __asm__ ("l1"); \
-switch (size) { \
-case 1: __get_user_asm_ret(__gu_val,ub,addr,retval); break; \
-case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
-case 4: __get_user_asm_ret(__gu_val,uw,addr,retval); break; \
-case 8: __get_user_asm_ret(__gu_val,x,addr,retval); break; \
-default: if (__get_user_bad()) return retval; \
-} data = (__force type) __gu_val; })
-
-#define __get_user_asm(x,size,addr,ret)					\
+#define __get_user_nocheck(data, addr, size, type) ({ \
+	register int __gu_ret; \
+	register unsigned long __gu_val; \
+	switch (size) { \
+		case 1: \
+			__get_user_asm(__gu_val, ub, addr, __gu_ret); \
+			break; \
+		case 2: \
+			__get_user_asm(__gu_val, uh, addr, __gu_ret); \
+			break; \
+		case 4: \
+			__get_user_asm(__gu_val, uw, addr, __gu_ret); \
+			break; \
+		case 8: \
+			__get_user_asm(__gu_val, x, addr, __gu_ret); \
+			break; \
+		default: \
+			__gu_val = 0; \
+			__gu_ret = __get_user_bad(); \
+			break; \
+	} data = (__force type) __gu_val; __gu_ret; \
+})
+
+#define __get_user_nocheck_ret(data, addr, size, type, retval) ({ \
+	register unsigned long __gu_val __asm__ ("l1"); \
+	switch (size) { \
+	case 1: \
+		__get_user_asm_ret(__gu_val, ub, addr, retval); \
+		break; \
+	case 2: \
+		__get_user_asm_ret(__gu_val, uh, addr, retval); \
+		break; \
+	case 4: \
+		__get_user_asm_ret(__gu_val, uw, addr, retval); \
+		break; \
+	case 8: \
+		__get_user_asm_ret(__gu_val, x, addr, retval); \
+		break; \
+	default: \
+		if (__get_user_bad()) \
+			return retval; \
+	} \
+	data = (__force type) __gu_val; \
+})
+
+#define __get_user_asm(x, size, addr, ret)				\
 __asm__ __volatile__(							\
-	"/* Get user asm, inline. */\n"					\
-"1:\t"	"ld"#size "a [%2] %%asi, %1\n\t"				\
-	"clr	%0\n"							\
-"2:\n\n\t"								\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"sethi	%%hi(2b), %0\n\t"					\
-	"clr	%1\n\t"							\
-	"jmpl	%0 + %%lo(2b), %%g0\n\t"				\
-	" mov	%3, %0\n\n\t"						\
-	".previous\n\t"							\
-	".section __ex_table,\"a\"\n\t"					\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\n\t"						\
-	".previous\n\t"							\
-       : "=r" (ret), "=r" (x) : "r" (__m(addr)),			\
-	 "i" (-EFAULT))
-
-#define __get_user_asm_ret(x,size,addr,retval)				\
+		"/* Get user asm, inline. */\n"				\
+	"1:\t"	"ld"#size "a [%2] %%asi, %1\n\t"			\
+		"clr	%0\n"						\
+	"2:\n\n\t"							\
+		".section .fixup,#alloc,#execinstr\n\t"			\
+		".align	4\n"						\
+	"3:\n\t"							\
+		"sethi	%%hi(2b), %0\n\t"				\
+		"clr	%1\n\t"						\
+		"jmpl	%0 + %%lo(2b), %%g0\n\t"			\
+		" mov	%3, %0\n\n\t"					\
+		".previous\n\t"						\
+		".section __ex_table,\"a\"\n\t"				\
+		".align	4\n\t"						\
+		".word	1b, 3b\n\n\t"					\
+		".previous\n\t"						\
+	       : "=r" (ret), "=r" (x) : "r" (__m(addr)),		\
+		 "i" (-EFAULT))
+
+#define __get_user_asm_ret(x, size, addr, retval)			\
 if (__builtin_constant_p(retval) && retval == -EFAULT)			\
-__asm__ __volatile__(							\
-	"/* Get user asm ret, inline. */\n"				\
-"1:\t"	"ld"#size "a [%1] %%asi, %0\n\n\t"				\
-	".section __ex_table,\"a\"\n\t"					\
-	".align	4\n\t"							\
-	".word	1b,__ret_efault\n\n\t"					\
-	".previous\n\t"							\
-       : "=r" (x) : "r" (__m(addr)));					\
+	__asm__ __volatile__(						\
+		"/* Get user asm ret, inline. */\n"			\
+	"1:\t"	"ld"#size "a [%1] %%asi, %0\n\n\t"			\
+		".section __ex_table,\"a\"\n\t"				\
+		".align	4\n\t"						\
+		".word	1b,__ret_efault\n\n\t"				\
+		".previous\n\t"						\
+	       : "=r" (x) : "r" (__m(addr)));				\
 else									\
-__asm__ __volatile__(							\
-	"/* Get user asm ret, inline. */\n"				\
-"1:\t"	"ld"#size "a [%1] %%asi, %0\n\n\t"				\
-	".section .fixup,#alloc,#execinstr\n\t"				\
-	".align	4\n"							\
-"3:\n\t"								\
-	"ret\n\t"							\
-	" restore %%g0, %2, %%o0\n\n\t"					\
-	".previous\n\t"							\
-	".section __ex_table,\"a\"\n\t"					\
-	".align	4\n\t"							\
-	".word	1b, 3b\n\n\t"						\
-	".previous\n\t"							\
-       : "=r" (x) : "r" (__m(addr)), "i" (retval))
+	__asm__ __volatile__(						\
+		"/* Get user asm ret, inline. */\n"			\
+	"1:\t"	"ld"#size "a [%1] %%asi, %0\n\n\t"			\
+		".section .fixup,#alloc,#execinstr\n\t"			\
+		".align	4\n"						\
+	"3:\n\t"							\
+		"ret\n\t"						\
+		" restore %%g0, %2, %%o0\n\n\t"				\
+		".previous\n\t"						\
+		".section __ex_table,\"a\"\n\t"				\
+		".align	4\n\t"						\
+		".word	1b, 3b\n\n\t"					\
+		".previous\n\t"						\
+	       : "=r" (x) : "r" (__m(addr)), "i" (retval))
 
 int __get_user_bad(void);
 
-- 
MST

