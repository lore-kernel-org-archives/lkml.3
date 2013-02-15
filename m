Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013Ab3BOKl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:41:56 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760962Ab3BOKlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:53 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/6] metag: move usercopy.c exports out of metag_ksyms.c
Date: Fri, 15 Feb 2013 10:41:39 +0000
Message-ID: <1360924901-21404-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's less error prone to have function symbols exported immediately
after the function rather than in metag_ksyms.c. Move each EXPORT_SYMBOL
in metag_ksyms.c for symbols defined in usercopy.c into usercopy.c

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |   16 ----------------
 arch/metag/lib/usercopy.c       |   13 +++++++++++++
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 1004e26..d3260c6 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -2,29 +2,13 @@
 #include <linux/linkage.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/user.h>
 #include <linux/interrupt.h>
 #include <linux/hardirq.h>
 
 #include <asm/checksum.h>
-#include <asm/uaccess.h>
 #include <asm/ftrace.h>
 #include <asm/tbx.h>
 
-/* uaccess symbols */
-EXPORT_SYMBOL(__copy_user_zeroing);
-EXPORT_SYMBOL(__copy_user);
-EXPORT_SYMBOL(__get_user_asm_b);
-EXPORT_SYMBOL(__get_user_asm_w);
-EXPORT_SYMBOL(__get_user_asm_d);
-EXPORT_SYMBOL(__put_user_asm_b);
-EXPORT_SYMBOL(__put_user_asm_w);
-EXPORT_SYMBOL(__put_user_asm_d);
-EXPORT_SYMBOL(__put_user_asm_l);
-EXPORT_SYMBOL(__strncpy_from_user);
-EXPORT_SYMBOL(strnlen_user);
-EXPORT_SYMBOL(__do_clear_user);
-
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/metag/lib/usercopy.c b/arch/metag/lib/usercopy.c
index 92f6dbb..b3ebfe9 100644
--- a/arch/metag/lib/usercopy.c
+++ b/arch/metag/lib/usercopy.c
@@ -10,6 +10,7 @@
  * Modified for Meta by Will Newton.
  */
 
+#include <linux/export.h>
 #include <linux/uaccess.h>
 #include <asm/cache.h>			/* def of L1_CACHE_BYTES */
 
@@ -610,6 +611,7 @@ unsigned long __copy_user(void __user *pdst, const void *psrc,
 
 	return retn;
 }
+EXPORT_SYMBOL(__copy_user);
 
 #define __asm_copy_from_user_1(to, from, ret) \
 	__asm_copy_user_cont(to, from, ret,	\
@@ -936,6 +938,7 @@ unsigned long __copy_user_zeroing(void *pdst, const void __user *psrc,
 
 	return retn + n;
 }
+EXPORT_SYMBOL(__copy_user_zeroing);
 
 #define __asm_clear_8x64(to, ret) \
 	asm volatile (					\
@@ -1089,6 +1092,7 @@ unsigned long __do_clear_user(void __user *pto, unsigned long pn)
 
 	return retn;
 }
+EXPORT_SYMBOL(__do_clear_user);
 
 unsigned char __get_user_asm_b(const void __user *addr, long *err)
 {
@@ -1112,6 +1116,7 @@ unsigned char __get_user_asm_b(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
+EXPORT_SYMBOL(__get_user_asm_b);
 
 unsigned short __get_user_asm_w(const void __user *addr, long *err)
 {
@@ -1135,6 +1140,7 @@ unsigned short __get_user_asm_w(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
+EXPORT_SYMBOL(__get_user_asm_w);
 
 unsigned int __get_user_asm_d(const void __user *addr, long *err)
 {
@@ -1158,6 +1164,7 @@ unsigned int __get_user_asm_d(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
+EXPORT_SYMBOL(__get_user_asm_d);
 
 long __put_user_asm_b(unsigned int x, void __user *addr)
 {
@@ -1181,6 +1188,7 @@ long __put_user_asm_b(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
+EXPORT_SYMBOL(__put_user_asm_b);
 
 long __put_user_asm_w(unsigned int x, void __user *addr)
 {
@@ -1204,6 +1212,7 @@ long __put_user_asm_w(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
+EXPORT_SYMBOL(__put_user_asm_w);
 
 long __put_user_asm_d(unsigned int x, void __user *addr)
 {
@@ -1227,6 +1236,7 @@ long __put_user_asm_d(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
+EXPORT_SYMBOL(__put_user_asm_d);
 
 long __put_user_asm_l(unsigned long long x, void __user *addr)
 {
@@ -1250,6 +1260,7 @@ long __put_user_asm_l(unsigned long long x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
+EXPORT_SYMBOL(__put_user_asm_l);
 
 long strnlen_user(const char __user *src, long count)
 {
@@ -1286,6 +1297,7 @@ long strnlen_user(const char __user *src, long count)
 
 	return res;
 }
+EXPORT_SYMBOL(strnlen_user);
 
 long __strncpy_from_user(char *dst, const char __user *src, long count)
 {
@@ -1339,3 +1351,4 @@ long __strncpy_from_user(char *dst, const char __user *src, long count)
 
 	return res;
 }
+EXPORT_SYMBOL(__strncpy_from_user);
-- 
1.7.7.6


