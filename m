Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbbAFQWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:22:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbbAFQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:22:17 -0500
Date: Tue, 6 Jan 2015 17:45:34 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH v2 37/40] parisc: macro whitespace fixes
Message-ID: <1420558883-10131-38-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/parisc/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/parisc/include/asm/uaccess.h | 116 +++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index 6c79311..0abdd4c 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -17,7 +17,7 @@
 #define KERNEL_DS	((mm_segment_t){0})
 #define USER_DS 	((mm_segment_t){1})
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b) ((a).seg == (b).seg)
 
 #define get_ds()	(KERNEL_DS)
 #define get_fs()	(current_thread_info()->addr_limit)
@@ -42,14 +42,14 @@ static inline long access_ok(int type, const void __user * addr,
 #if !defined(CONFIG_64BIT)
 #define LDD_KERNEL(ptr)		BUILD_BUG()
 #define LDD_USER(ptr)		BUILD_BUG()
-#define STD_KERNEL(x, ptr)	__put_kernel_asm64(x,ptr)
-#define STD_USER(x, ptr)	__put_user_asm64(x,ptr)
+#define STD_KERNEL(x, ptr)	__put_kernel_asm64(x, ptr)
+#define STD_USER(x, ptr)	__put_user_asm64(x, ptr)
 #define ASM_WORD_INSN		".word\t"
 #else
-#define LDD_KERNEL(ptr)		__get_kernel_asm("ldd",ptr)
-#define LDD_USER(ptr)		__get_user_asm("ldd",ptr)
-#define STD_KERNEL(x, ptr)	__put_kernel_asm("std",x,ptr)
-#define STD_USER(x, ptr)	__put_user_asm("std",x,ptr)
+#define LDD_KERNEL(ptr)		__get_kernel_asm("ldd", ptr)
+#define LDD_USER(ptr)		__get_user_asm("ldd", ptr)
+#define STD_KERNEL(x, ptr)	__put_kernel_asm("std", x, ptr)
+#define STD_USER(x, ptr)	__put_user_asm("std", x, ptr)
 #define ASM_WORD_INSN		".dword\t"
 #endif
 
@@ -80,68 +80,68 @@ struct exception_data {
 	unsigned long fault_addr;
 };
 
-#define __get_user(x,ptr)                               \
-({                                                      \
-	register long __gu_err __asm__ ("r8") = 0;      \
-	register long __gu_val __asm__ ("r9") = 0;      \
-							\
-	if (segment_eq(get_fs(),KERNEL_DS)) {           \
-	    switch (sizeof(*(ptr))) {                   \
-	    case 1: __get_kernel_asm("ldb",ptr); break; \
-	    case 2: __get_kernel_asm("ldh",ptr); break; \
-	    case 4: __get_kernel_asm("ldw",ptr); break; \
-	    case 8: LDD_KERNEL(ptr); break;		\
-	    default: BUILD_BUG(); break;		\
-	    }                                           \
-	}                                               \
-	else {                                          \
-	    switch (sizeof(*(ptr))) {                   \
-	    case 1: __get_user_asm("ldb",ptr); break;   \
-	    case 2: __get_user_asm("ldh",ptr); break;   \
-	    case 4: __get_user_asm("ldw",ptr); break;   \
-	    case 8: LDD_USER(ptr);  break;		\
-	    default: BUILD_BUG(); break;		\
-	    }                                           \
-	}                                               \
-							\
-	(x) = (__force __typeof__(*(ptr))) __gu_val;	\
-	__gu_err;                                       \
+#define __get_user(x, ptr)                               \
+({                                                       \
+	register long __gu_err __asm__ ("r8") = 0;       \
+	register long __gu_val __asm__ ("r9") = 0;       \
+							 \
+	if (segment_eq(get_fs(), KERNEL_DS)) {           \
+	    switch (sizeof(*(ptr))) {                    \
+	    case 1: __get_kernel_asm("ldb", ptr); break; \
+	    case 2: __get_kernel_asm("ldh", ptr); break; \
+	    case 4: __get_kernel_asm("ldw", ptr); break; \
+	    case 8: LDD_KERNEL(ptr); break;		 \
+	    default: BUILD_BUG(); break;		 \
+	    }                                            \
+	}                                                \
+	else {                                           \
+	    switch (sizeof(*(ptr))) {                    \
+	    case 1: __get_user_asm("ldb", ptr); break;   \
+	    case 2: __get_user_asm("ldh", ptr); break;   \
+	    case 4: __get_user_asm("ldw", ptr); break;   \
+	    case 8: LDD_USER(ptr);  break;		 \
+	    default: BUILD_BUG(); break;		 \
+	    }                                            \
+	}                                                \
+							 \
+	(x) = (__force __typeof__(*(ptr))) __gu_val;	 \
+	__gu_err;                                        \
 })
 
-#define __get_kernel_asm(ldx,ptr)                       \
+#define __get_kernel_asm(ldx, ptr)                      \
 	__asm__("\n1:\t" ldx "\t0(%2),%0\n\t"		\
 		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_get_user_skip_1)\
 		: "=r"(__gu_val), "=r"(__gu_err)        \
 		: "r"(ptr), "1"(__gu_err)		\
 		: "r1");
 
-#define __get_user_asm(ldx,ptr)                         \
+#define __get_user_asm(ldx, ptr)                        \
 	__asm__("\n1:\t" ldx "\t0(%%sr3,%2),%0\n\t"	\
-		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_get_user_skip_1)\
+		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_get_user_skip_1)\
 		: "=r"(__gu_val), "=r"(__gu_err)        \
 		: "r"(ptr), "1"(__gu_err)		\
 		: "r1");
 
-#define __put_user(x,ptr)                                       \
+#define __put_user(x, ptr)                                      \
 ({								\
 	register long __pu_err __asm__ ("r8") = 0;      	\
         __typeof__(*(ptr)) __x = (__typeof__(*(ptr)))(x);	\
 								\
-	if (segment_eq(get_fs(),KERNEL_DS)) {                   \
+	if (segment_eq(get_fs(), KERNEL_DS)) {                  \
 	    switch (sizeof(*(ptr))) {                           \
-	    case 1: __put_kernel_asm("stb",__x,ptr); break;     \
-	    case 2: __put_kernel_asm("sth",__x,ptr); break;     \
-	    case 4: __put_kernel_asm("stw",__x,ptr); break;     \
-	    case 8: STD_KERNEL(__x,ptr); break;			\
+	    case 1: __put_kernel_asm("stb", __x, ptr); break;   \
+	    case 2: __put_kernel_asm("sth", __x, ptr); break;   \
+	    case 4: __put_kernel_asm("stw", __x, ptr); break;   \
+	    case 8: STD_KERNEL(__x, ptr); break;		\
 	    default: BUILD_BUG(); break;			\
 	    }                                                   \
 	}                                                       \
 	else {                                                  \
 	    switch (sizeof(*(ptr))) {                           \
-	    case 1: __put_user_asm("stb",__x,ptr); break;       \
-	    case 2: __put_user_asm("sth",__x,ptr); break;       \
-	    case 4: __put_user_asm("stw",__x,ptr); break;       \
-	    case 8: STD_USER(__x,ptr); break;			\
+	    case 1: __put_user_asm("stb", __x, ptr); break;     \
+	    case 2: __put_user_asm("sth", __x, ptr); break;     \
+	    case 4: __put_user_asm("stw", __x, ptr); break;     \
+	    case 8: STD_USER(__x, ptr); break;			\
 	    default: BUILD_BUG(); break;			\
 	    }                                                   \
 	}                                                       \
@@ -159,18 +159,18 @@ struct exception_data {
  * r8/r9 are already listed as err/val.
  */
 
-#define __put_kernel_asm(stx,x,ptr)                         \
+#define __put_kernel_asm(stx, x, ptr)                       \
 	__asm__ __volatile__ (                              \
 		"\n1:\t" stx "\t%2,0(%1)\n\t"		    \
-		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_1)\
+		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
 		: "r"(ptr), "r"(x), "0"(__pu_err)	    \
 	    	: "r1")
 
-#define __put_user_asm(stx,x,ptr)                           \
+#define __put_user_asm(stx, x, ptr)                         \
 	__asm__ __volatile__ (                              \
 		"\n1:\t" stx "\t%2,0(%%sr3,%1)\n\t"	    \
-		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_1)\
+		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
 		: "r"(ptr), "r"(x), "0"(__pu_err)	    \
 		: "r1")
@@ -178,23 +178,23 @@ struct exception_data {
 
 #if !defined(CONFIG_64BIT)
 
-#define __put_kernel_asm64(__val,ptr) do {		    \
+#define __put_kernel_asm64(__val, ptr) do {		    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%1)"			    \
 		"\n2:\tstw %R2,4(%1)\n\t"		    \
-		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
-		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
+		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_put_user_skip_2)\
+		ASM_EXCEPTIONTABLE_ENTRY(2b, fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
 		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
-#define __put_user_asm64(__val,ptr) do {	    	    \
+#define __put_user_asm64(__val, ptr) do {	    	    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%%sr3,%1)"		    \
 		"\n2:\tstw %R2,4(%%sr3,%1)\n\t"		    \
-		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
-		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
+		ASM_EXCEPTIONTABLE_ENTRY(1b, fixup_put_user_skip_2)\
+		ASM_EXCEPTIONTABLE_ENTRY(2b, fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
 		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
@@ -211,8 +211,8 @@ extern unsigned long lcopy_to_user(void __user *, const void *, unsigned long);
 extern unsigned long lcopy_from_user(void *, const void __user *, unsigned long);
 extern unsigned long lcopy_in_user(void __user *, const void __user *, unsigned long);
 extern long strncpy_from_user(char *, const char __user *, long);
-extern unsigned lclear_user(void __user *,unsigned long);
-extern long lstrnlen_user(const char __user *,long);
+extern unsigned lclear_user(void __user *, unsigned long);
+extern long lstrnlen_user(const char __user *, long);
 /*
  * Complex access routines -- macros
  */
-- 
MST

