Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaBXTAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:00:51 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59748 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbaBXTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:00:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 4/6] ftrace: Do not pass data to ftrace_dyn_arch_init
Date: Mon, 24 Feb 2014 19:59:59 +0100
Message-Id: <1393268401-24379-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
References: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the data parameter is not really used by any ftrace_dyn_arch_init,
remove that from ftrace_dyn_arch_init. This also removes the addr
local variable from ftrace_init which is now unused.

Note the documentation was imprecise as it did not suggest to set
(*data) to 0.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 Documentation/trace/ftrace-design.txt | 2 +-
 arch/arm/kernel/ftrace.c              | 2 +-
 arch/blackfin/kernel/ftrace.c         | 2 +-
 arch/ia64/kernel/ftrace.c             | 2 +-
 arch/metag/kernel/ftrace.c            | 2 +-
 arch/microblaze/kernel/ftrace.c       | 2 +-
 arch/mips/kernel/ftrace.c             | 2 +-
 arch/powerpc/kernel/ftrace.c          | 2 +-
 arch/s390/kernel/ftrace.c             | 2 +-
 arch/sh/kernel/ftrace.c               | 2 +-
 arch/sparc/kernel/ftrace.c            | 2 +-
 arch/tile/kernel/ftrace.c             | 2 +-
 arch/x86/kernel/ftrace.c              | 2 +-
 include/linux/ftrace.h                | 2 +-
 kernel/trace/ftrace.c                 | 7 ++-----
 15 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 117168884023..3f669b9e8852 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -358,7 +358,7 @@ Every arch has an init callback function.  If you need to do something early on
 to initialize some state, this is the time to do that.  Otherwise, this simple
 function below should be sufficient for most people:
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 5cd0d05edf35..c108ddcb9ba4 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -156,7 +156,7 @@ int ftrace_make_nop(struct module *mod,
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index f74c5ae6a25b..095de0fa044d 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -65,7 +65,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(ip, call, sizeof(call));
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/ia64/kernel/ftrace.c b/arch/ia64/kernel/ftrace.c
index cfaa93a8bbdf..3b0c2aa07857 100644
--- a/arch/ia64/kernel/ftrace.c
+++ b/arch/ia64/kernel/ftrace.c
@@ -198,7 +198,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 }
 
 /* run from kstop_machine */
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/metag/kernel/ftrace.c b/arch/metag/kernel/ftrace.c
index bf593932b353..ed1d685157c2 100644
--- a/arch/metag/kernel/ftrace.c
+++ b/arch/metag/kernel/ftrace.c
@@ -117,7 +117,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 }
 
 /* run from kstop_machine */
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index ffa595c7fec2..bbcd2533766c 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -171,7 +171,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 42a675ae0155..ee7ecb170d7f 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -202,7 +202,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(FTRACE_CALL_IP, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	/* Encode the instructions when booting */
 	ftrace_dyn_arch_init_insns();
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index d059664cdf16..71ce4cbb7e9f 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -531,7 +531,7 @@ void arch_ftrace_update_code(int command)
 		ftrace_disable_ftrace_graph_caller();
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 77b2f3a1f50a..54d6493c4a56 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -130,7 +130,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return 0;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 493997541d2c..3c74f53db6db 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -272,7 +272,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index ee813b82da49..0a2d2ddff543 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -82,7 +82,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(ip, old, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/tile/kernel/ftrace.c b/arch/tile/kernel/ftrace.c
index 34d9ea0bca9f..8d52d83cc516 100644
--- a/arch/tile/kernel/ftrace.c
+++ b/arch/tile/kernel/ftrace.c
@@ -167,7 +167,7 @@ int ftrace_make_nop(struct module *mod,
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index a41f31f1cdc1..e69c177d3496 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -678,7 +678,7 @@ void arch_ftrace_update_code(int command)
 	atomic_dec(&modifying_ftrace_code);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e6141be2fad5..1bbb2cd631de 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -423,7 +423,7 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable);
 
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
-extern int ftrace_dyn_arch_init(void *data);
+extern int ftrace_dyn_arch_init(void);
 extern void ftrace_replace_code(int enable);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 083c6d5fce25..5bd70e8b09b0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4372,14 +4372,11 @@ void __init ftrace_init(void)
 {
 	extern unsigned long __start_mcount_loc[];
 	extern unsigned long __stop_mcount_loc[];
-	unsigned long count, addr, flags;
+	unsigned long count, flags;
 	int ret;
 
-	/* Keep the ftrace pointer to the stub */
-	addr = (unsigned long)ftrace_stub;
-
 	local_irq_save(flags);
-	ret = ftrace_dyn_arch_init(&addr);
+	ret = ftrace_dyn_arch_init();
 	local_irq_restore(flags);
 	if (ret)
 		goto failed;
-- 
1.8.5.2

