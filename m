Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3AXTrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:47:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AXTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:47:08 -0500
Date: Thu, 24 Jan 2013 11:46:35 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-f684199f5de805ac50ea5bdec2b082882586a777@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120928081522.3560.75469.stgit@ltc138.sdl.hitachi.co.jp>
References: <20120928081522.3560.75469.stgit@ltc138.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: Move kprobes stuff under arch/x86/
 kernel/kprobes/
Git-Commit-ID: f684199f5de805ac50ea5bdec2b082882586a777
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:46:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f684199f5de805ac50ea5bdec2b082882586a777
Gitweb:     http://git.kernel.org/tip/f684199f5de805ac50ea5bdec2b082882586a777
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 28 Sep 2012 17:15:22 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jan 2013 13:22:37 -0500

kprobes/x86: Move kprobes stuff under arch/x86/kernel/kprobes/

Move arch-dep kprobes stuff under arch/x86/kernel/kprobes.

Link: http://lkml.kernel.org/r/20120928081522.3560.75469.stgit@ltc138.sdl.hitachi.co.jp

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ fixed whitespace and s/__attribute__((packed))/__packed/ ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/Makefile                               | 4 +---
 arch/x86/kernel/kprobes/Makefile                       | 7 +++++++
 arch/x86/kernel/{kprobes-common.h => kprobes/common.h} | 0
 arch/x86/kernel/{kprobes.c => kprobes/core.c}          | 6 +++---
 arch/x86/kernel/{kprobes-ftrace.c => kprobes/ftrace.c} | 2 +-
 arch/x86/kernel/{kprobes-opt.c => kprobes/opt.c}       | 2 +-
 6 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cc5d31f..ac3b3d0 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -65,9 +65,7 @@ obj-$(CONFIG_X86_TSC)		+= trace_clock.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
-obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_OPTPROBES)		+= kprobes-opt.o
-obj-$(CONFIG_KPROBES_ON_FTRACE)	+= kprobes-ftrace.o
+obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
diff --git a/arch/x86/kernel/kprobes/Makefile b/arch/x86/kernel/kprobes/Makefile
new file mode 100644
index 0000000..0d33169
--- /dev/null
+++ b/arch/x86/kernel/kprobes/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for kernel probes
+#
+
+obj-$(CONFIG_KPROBES)		+= core.o
+obj-$(CONFIG_OPTPROBES)		+= opt.o
+obj-$(CONFIG_KPROBES_ON_FTRACE)	+= ftrace.o
diff --git a/arch/x86/kernel/kprobes-common.h b/arch/x86/kernel/kprobes/common.h
similarity index 100%
rename from arch/x86/kernel/kprobes-common.h
rename to arch/x86/kernel/kprobes/common.h
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes/core.c
similarity index 99%
rename from arch/x86/kernel/kprobes.c
rename to arch/x86/kernel/kprobes/core.c
index 18114bf..e124554 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -58,7 +58,7 @@
 #include <asm/insn.h>
 #include <asm/debugreg.h>
 
-#include "kprobes-common.h"
+#include "common.h"
 
 void jprobe_return_end(void);
 
@@ -78,7 +78,7 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 	 * Groups, and some special opcodes can not boost.
 	 * This is non-const and volatile to keep gcc from statically
 	 * optimizing it out, as variable_test_bit makes gcc think only
-	 * *(unsigned long*) is used. 
+	 * *(unsigned long*) is used.
 	 */
 static volatile u32 twobyte_is_boostable[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
@@ -117,7 +117,7 @@ static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 	struct __arch_relative_insn {
 		u8 op;
 		s32 raddr;
-	} __attribute__((packed)) *insn;
+	} __packed *insn;
 
 	insn = (struct __arch_relative_insn *)from;
 	insn->raddr = (s32)((long)(to) - ((long)(from) + 5));
diff --git a/arch/x86/kernel/kprobes-ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
similarity index 98%
rename from arch/x86/kernel/kprobes-ftrace.c
rename to arch/x86/kernel/kprobes/ftrace.c
index 70a81c7..23ef5c5 100644
--- a/arch/x86/kernel/kprobes-ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -23,7 +23,7 @@
 #include <linux/preempt.h>
 #include <linux/ftrace.h>
 
-#include "kprobes-common.h"
+#include "common.h"
 
 static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 			     struct kprobe_ctlblk *kcb)
diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes/opt.c
similarity index 99%
rename from arch/x86/kernel/kprobes-opt.c
rename to arch/x86/kernel/kprobes/opt.c
index c5e410e..76dc6f0 100644
--- a/arch/x86/kernel/kprobes-opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -37,7 +37,7 @@
 #include <asm/insn.h>
 #include <asm/debugreg.h>
 
-#include "kprobes-common.h"
+#include "common.h"
 
 unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 {
