Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3GWAdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:33:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39378 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753941Ab3GWAcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:32:53 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 2/2] kallsyms: Remove now unused print_symbol
Date: Mon, 22 Jul 2013 17:32:41 -0700
Message-Id: <45377e0185646770df75c2391dacfe0e7fa21c37.1374539434.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5cafe992f6a42500e82433880a8500f0cd67cf72.1374539434.git.joe@perches.com>
References: <5cafe992f6a42500e82433880a8500f0cd67cf72.1374539434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more uses in the tree so remove print_symbol.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kallsyms.h | 18 ------------------
 kernel/kallsyms.c        | 11 -----------
 2 files changed, 29 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e19..b7a60ba 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -39,9 +39,6 @@ extern int sprint_symbol(char *buffer, unsigned long address);
 extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
 extern int sprint_backtrace(char *buffer, unsigned long address);
 
-/* Look up a kernel symbol and print it to the kernel messages. */
-extern void __print_symbol(const char *fmt, unsigned long address);
-
 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
@@ -103,23 +100,8 @@ static inline int lookup_symbol_attrs(unsigned long addr, unsigned long *size, u
 	return -ERANGE;
 }
 
-/* Stupid that this does nothing, but I didn't create this mess. */
-#define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
 
-/* This macro allows us to keep printk typechecking */
-static __printf(1, 2)
-void __check_printsym_format(const char *fmt, ...)
-{
-}
-
-static inline void print_symbol(const char *fmt, unsigned long addr)
-{
-	__check_printsym_format(fmt, "");
-	__print_symbol(fmt, (unsigned long)
-		       __builtin_extract_return_addr((void *)addr));
-}
-
 static inline void print_ip_sym(unsigned long ip)
 {
 	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3127ad5..9e22c8b 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -432,17 +432,6 @@ int sprint_backtrace(char *buffer, unsigned long address)
 	return __sprint_symbol(buffer, address, -1, 1);
 }
 
-/* Look up a kernel symbol and print it to the kernel messages. */
-void __print_symbol(const char *fmt, unsigned long address)
-{
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
-
-	printk(fmt, buffer);
-}
-EXPORT_SYMBOL(__print_symbol);
-
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
 struct kallsym_iter {
 	loff_t pos;
-- 
1.8.1.2.459.gbcd45b4.dirty

