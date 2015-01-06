Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbbAFPqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbbAFPp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:57 -0500
Date: Tue, 6 Jan 2015 17:45:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        =?us-ascii?B?PT9VVEYtOD9xP1V3ZT0yMEtsZWluZS1LPUMzPUI2bmlnPz0=?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 30/40] arm: macro whitespace fixes
Message-ID: <1420558883-10131-31-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/arm/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/arm/include/asm/uaccess.h | 92 +++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 74fcde7..ce0786e 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -73,7 +73,7 @@ static inline void set_fs(mm_segment_t fs)
 	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
 }
 
-#define segment_eq(a,b)	((a) == (b))
+#define segment_eq(a, b)	((a) == (b))
 
 #define __addr_ok(addr) ({ \
 	unsigned long flag; \
@@ -84,7 +84,7 @@ static inline void set_fs(mm_segment_t fs)
 	(flag == 0); })
 
 /* We use 33-bit arithmetic here... */
-#define __range_ok(addr,size) ({ \
+#define __range_ok(addr, size) ({ \
 	unsigned long flag, roksum; \
 	__chk_user_ptr(addr);	\
 	__asm__("adds %1, %2, %3; sbcccs %1, %1, %0; movcc %0, #0" \
@@ -123,7 +123,7 @@ extern int __get_user_64t_4(void *);
 #define __GUP_CLOBBER_32t_8 "lr", "cc"
 #define __GUP_CLOBBER_8	"lr", "cc"
 
-#define __get_user_x(__r2,__p,__e,__l,__s)				\
+#define __get_user_x(__r2, __p, __e, __l, __s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%1", "r2")			\
 		__asmeq("%3", "r1")					\
@@ -134,7 +134,7 @@ extern int __get_user_64t_4(void *);
 
 /* narrowing a double-word get into a single 32bit word register: */
 #ifdef __ARMEB__
-#define __get_user_x_32t(__r2, __p, __e, __l, __s)				\
+#define __get_user_x_32t(__r2, __p, __e, __l, __s)			\
 	__get_user_x(__r2, __p, __e, __l, 32t_8)
 #else
 #define __get_user_x_32t __get_user_x
@@ -158,7 +158,7 @@ extern int __get_user_64t_4(void *);
 #endif
 
 
-#define __get_user_check(x,p)							\
+#define __get_user_check(x, p)						\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
@@ -196,10 +196,10 @@ extern int __get_user_64t_4(void *);
 		__e;							\
 	})
 
-#define get_user(x,p)							\
+#define get_user(x, p)							\
 	({								\
 		might_fault();						\
-		__get_user_check(x,p);					\
+		__get_user_check(x, p);					\
 	 })
 
 extern int __put_user_1(void *, unsigned int);
@@ -207,7 +207,7 @@ extern int __put_user_2(void *, unsigned int);
 extern int __put_user_4(void *, unsigned int);
 extern int __put_user_8(void *, unsigned long long);
 
-#define __put_user_x(__r2,__p,__e,__l,__s)				\
+#define __put_user_x(__r2, __p, __e, __l, __s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%2", "r2")			\
 		__asmeq("%3", "r1")					\
@@ -216,7 +216,7 @@ extern int __put_user_8(void *, unsigned long long);
 		: "0" (__p), "r" (__r2), "r" (__l)			\
 		: "ip", "lr", "cc")
 
-#define __put_user_check(x,p)							\
+#define __put_user_check(x, p)						\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		const typeof(*(p)) __user *__tmp_p = (p);		\
@@ -242,10 +242,10 @@ extern int __put_user_8(void *, unsigned long long);
 		__e;							\
 	})
 
-#define put_user(x,p)							\
+#define put_user(x, p)							\
 	({								\
 		might_fault();						\
-		__put_user_check(x,p);					\
+		__put_user_check(x, p);					\
 	 })
 
 #else /* CONFIG_MMU */
@@ -255,21 +255,21 @@ extern int __put_user_8(void *, unsigned long long);
  */
 #define USER_DS			KERNEL_DS
 
-#define segment_eq(a,b)		(1)
-#define __addr_ok(addr)		((void)(addr),1)
-#define __range_ok(addr,size)	((void)(addr),0)
+#define segment_eq(a, b)		(1)
+#define __addr_ok(addr)		((void)(addr), 1)
+#define __range_ok(addr, size)	((void)(addr), 0)
 #define get_fs()		(KERNEL_DS)
 
 static inline void set_fs(mm_segment_t fs)
 {
 }
 
-#define get_user(x,p)	__get_user(x,p)
-#define put_user(x,p)	__put_user(x,p)
+#define get_user(x, p)	__get_user(x, p)
+#define put_user(x, p)	__put_user(x, p)
 
 #endif /* CONFIG_MMU */
 
-#define access_ok(type,addr,size)	(__range_ok(addr,size) == 0)
+#define access_ok(type, addr, size)	(__range_ok(addr, size) == 0)
 
 #define user_addr_max() \
 	(segment_eq(get_fs(), KERNEL_DS) ? ~0UL : get_fs())
@@ -283,35 +283,35 @@ static inline void set_fs(mm_segment_t fs)
  * error occurs, and leave it unchanged on success.  Note that these
  * versions are void (ie, don't return a value as such).
  */
-#define __get_user(x,ptr)						\
+#define __get_user(x, ptr)						\
 ({									\
 	long __gu_err = 0;						\
-	__get_user_err((x),(ptr),__gu_err);				\
+	__get_user_err((x), (ptr), __gu_err);				\
 	__gu_err;							\
 })
 
-#define __get_user_error(x,ptr,err)					\
+#define __get_user_error(x, ptr, err)					\
 ({									\
-	__get_user_err((x),(ptr),err);					\
+	__get_user_err((x), (ptr), err);				\
 	(void) 0;							\
 })
 
-#define __get_user_err(x,ptr,err)					\
+#define __get_user_err(x, ptr, err)					\
 do {									\
 	unsigned long __gu_addr = (unsigned long)(ptr);			\
 	unsigned long __gu_val;						\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
-	case 1:	__get_user_asm_byte(__gu_val,__gu_addr,err);	break;	\
-	case 2:	__get_user_asm_half(__gu_val,__gu_addr,err);	break;	\
-	case 4:	__get_user_asm_word(__gu_val,__gu_addr,err);	break;	\
+	case 1:	__get_user_asm_byte(__gu_val, __gu_addr, err);	break;	\
+	case 2:	__get_user_asm_half(__gu_val, __gu_addr, err);	break;	\
+	case 4:	__get_user_asm_word(__gu_val, __gu_addr, err);	break;	\
 	default: (__gu_val) = __get_user_bad();				\
 	}								\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
 } while (0)
 
-#define __get_user_asm_byte(x,addr,err)				\
+#define __get_user_asm_byte(x, addr, err)			\
 	__asm__ __volatile__(					\
 	"1:	" TUSER(ldrb) "	%1,[%2],#0\n"			\
 	"2:\n"							\
@@ -330,7 +330,7 @@ do {									\
 	: "cc")
 
 #ifndef __ARMEB__
-#define __get_user_asm_half(x,__gu_addr,err)			\
+#define __get_user_asm_half(x, __gu_addr, err)			\
 ({								\
 	unsigned long __b1, __b2;				\
 	__get_user_asm_byte(__b1, __gu_addr, err);		\
@@ -338,7 +338,7 @@ do {									\
 	(x) = __b1 | (__b2 << 8);				\
 })
 #else
-#define __get_user_asm_half(x,__gu_addr,err)			\
+#define __get_user_asm_half(x, __gu_addr, err)			\
 ({								\
 	unsigned long __b1, __b2;				\
 	__get_user_asm_byte(__b1, __gu_addr, err);		\
@@ -347,7 +347,7 @@ do {									\
 })
 #endif
 
-#define __get_user_asm_word(x,addr,err)				\
+#define __get_user_asm_word(x, addr, err)			\
 	__asm__ __volatile__(					\
 	"1:	" TUSER(ldr) "	%1,[%2],#0\n"			\
 	"2:\n"							\
@@ -365,35 +365,35 @@ do {									\
 	: "r" (addr), "i" (-EFAULT)				\
 	: "cc")
 
-#define __put_user(x,ptr)						\
+#define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
-	__put_user_err((x),(ptr),__pu_err);				\
+	__put_user_err((x), (ptr), __pu_err);				\
 	__pu_err;							\
 })
 
-#define __put_user_error(x,ptr,err)					\
+#define __put_user_error(x, ptr, err)					\
 ({									\
-	__put_user_err((x),(ptr),err);					\
+	__put_user_err((x), (ptr), err);				\
 	(void) 0;							\
 })
 
-#define __put_user_err(x,ptr,err)					\
+#define __put_user_err(x, ptr, err)					\
 do {									\
 	unsigned long __pu_addr = (unsigned long)(ptr);			\
 	__typeof__(*(ptr)) __pu_val = (x);				\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
-	case 1: __put_user_asm_byte(__pu_val,__pu_addr,err);	break;	\
-	case 2: __put_user_asm_half(__pu_val,__pu_addr,err);	break;	\
-	case 4: __put_user_asm_word(__pu_val,__pu_addr,err);	break;	\
-	case 8:	__put_user_asm_dword(__pu_val,__pu_addr,err);	break;	\
+	case 1: __put_user_asm_byte(__pu_val, __pu_addr, err);	break;	\
+	case 2: __put_user_asm_half(__pu_val, __pu_addr, err);	break;	\
+	case 4: __put_user_asm_word(__pu_val, __pu_addr, err);	break;	\
+	case 8:	__put_user_asm_dword(__pu_val, __pu_addr, err);	break;	\
 	default: __put_user_bad();					\
 	}								\
 } while (0)
 
-#define __put_user_asm_byte(x,__pu_addr,err)			\
+#define __put_user_asm_byte(x, __pu_addr, err)			\
 	__asm__ __volatile__(					\
 	"1:	" TUSER(strb) "	%1,[%2],#0\n"			\
 	"2:\n"							\
@@ -411,14 +411,14 @@ do {									\
 	: "cc")
 
 #ifndef __ARMEB__
-#define __put_user_asm_half(x,__pu_addr,err)			\
+#define __put_user_asm_half(x, __pu_addr, err)			\
 ({								\
 	unsigned long __temp = (__force unsigned long)(x);	\
 	__put_user_asm_byte(__temp, __pu_addr, err);		\
 	__put_user_asm_byte(__temp >> 8, __pu_addr + 1, err);	\
 })
 #else
-#define __put_user_asm_half(x,__pu_addr,err)			\
+#define __put_user_asm_half(x, __pu_addr, err)			\
 ({								\
 	unsigned long __temp = (__force unsigned long)(x);	\
 	__put_user_asm_byte(__temp >> 8, __pu_addr, err);	\
@@ -426,7 +426,7 @@ do {									\
 })
 #endif
 
-#define __put_user_asm_word(x,__pu_addr,err)			\
+#define __put_user_asm_word(x, __pu_addr, err)			\
 	__asm__ __volatile__(					\
 	"1:	" TUSER(str) "	%1,[%2],#0\n"			\
 	"2:\n"							\
@@ -451,7 +451,7 @@ do {									\
 #define	__reg_oper1	"%R2"
 #endif
 
-#define __put_user_asm_dword(x,__pu_addr,err)			\
+#define __put_user_asm_dword(x, __pu_addr, err)			\
 	__asm__ __volatile__(					\
  ARM(	"1:	" TUSER(str) "	" __reg_oper1 ", [%1], #4\n"	) \
  ARM(	"2:	" TUSER(str) "	" __reg_oper0 ", [%1]\n"	) \
@@ -480,9 +480,9 @@ extern unsigned long __must_check __copy_to_user_std(void __user *to, const void
 extern unsigned long __must_check __clear_user(void __user *addr, unsigned long n);
 extern unsigned long __must_check __clear_user_std(void __user *addr, unsigned long n);
 #else
-#define __copy_from_user(to,from,n)	(memcpy(to, (void __force *)from, n), 0)
-#define __copy_to_user(to,from,n)	(memcpy((void __force *)to, from, n), 0)
-#define __clear_user(addr,n)		(memset((void __force *)addr, 0, n), 0)
+#define __copy_from_user(to, from, n)	(memcpy(to, (void __force *)from, n), 0)
+#define __copy_to_user(to, from, n)	(memcpy((void __force *)to, from, n), 0)
+#define __clear_user(addr, n)		(memset((void __force *)addr, 0, n), 0)
 #endif
 
 static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
-- 
MST

