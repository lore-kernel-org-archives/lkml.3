Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab3DCI3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:29:20 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8717 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761537Ab3DCI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:29:16 -0400
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>
Subject: [PATCH 2/4] kprobes: split blacklist into common and arch
Date: Wed, 3 Apr 2013 10:28:52 +0200
Message-ID: <1364977734-32267-3-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some blackpoints are only valid for specific architectures. To let each
architecture specify its own blackpoints the list has been split in two
lists: common and arch. The common list is kept in kernel/kprobes.c and
the arch list is kept in the arch/ directory.

Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 arch/arc/kernel/kprobes.c      |  3 ++
 arch/arm/kernel/kprobes.c      |  2 +
 arch/avr32/kernel/kprobes.c    |  3 ++
 arch/ia64/kernel/kprobes.c     |  3 ++
 arch/mips/kernel/kprobes.c     |  3 ++
 arch/mn10300/kernel/kprobes.c  |  2 +
 arch/powerpc/kernel/kprobes.c  |  3 ++
 arch/s390/kernel/kprobes.c     |  3 ++
 arch/sh/kernel/kprobes.c       |  3 ++
 arch/sparc/kernel/kprobes.c    |  3 ++
 arch/x86/kernel/kprobes/core.c |  3 ++
 kernel/kprobes.c               | 87 ++++++++++++++++++++++++++++--------------
 12 files changed, 89 insertions(+), 29 deletions(-)

diff --git a/arch/arc/kernel/kprobes.c b/arch/arc/kernel/kprobes.c
index 3bfeacb..894eee6 100644
--- a/arch/arc/kernel/kprobes.c
+++ b/arch/arc/kernel/kprobes.c
@@ -24,6 +24,9 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	/* Attempt to probe at unaligned address */
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 170e9f3..772d9ec 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -46,6 +46,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
diff --git a/arch/avr32/kernel/kprobes.c b/arch/avr32/kernel/kprobes.c
index f820e9f..3b02c1e 100644
--- a/arch/avr32/kernel/kprobes.c
+++ b/arch/avr32/kernel/kprobes.c
@@ -24,6 +24,9 @@ static struct pt_regs jprobe_saved_regs;
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index f8280a7..239f2fd 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -42,6 +42,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 enum instruction_type {A, I, M, F, B, L, X, u};
 static enum instruction_type bundle_encoding[32][3] = {
   { M, I, I },				/* 00 */
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 12bc4eb..de6a1aa 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -53,6 +53,9 @@ static const union mips_instruction breakpoint2_insn = {
 DEFINE_PER_CPU(struct kprobe *, current_kprobe);
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 static int __kprobes insn_has_delayslot(union mips_instruction insn)
 {
 	switch (insn.i_format.opcode) {
diff --git a/arch/mn10300/kernel/kprobes.c b/arch/mn10300/kernel/kprobes.c
index 0311a7f..ed57094 100644
--- a/arch/mn10300/kernel/kprobes.c
+++ b/arch/mn10300/kernel/kprobes.c
@@ -41,6 +41,8 @@ static unsigned long cur_kprobe_bp_addr;
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
 
 /* singlestep flag bits */
 #define SINGLESTEP_BRANCH 1
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 11f5b03..b18ba45 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -47,6 +47,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 3388b2b..2077bb0 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -37,6 +37,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = { };
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
 {
 	switch (insn[0] >> 8) {
diff --git a/arch/sh/kernel/kprobes.c b/arch/sh/kernel/kprobes.c
index 42b46e6..8acfb02 100644
--- a/arch/sh/kernel/kprobes.c
+++ b/arch/sh/kernel/kprobes.c
@@ -24,6 +24,9 @@ static DEFINE_PER_CPU(struct kprobe, saved_current_opcode);
 static DEFINE_PER_CPU(struct kprobe, saved_next_opcode);
 static DEFINE_PER_CPU(struct kprobe, saved_next_opcode2);
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 #define OPCODE_JMP(x)	(((x) & 0xF0FF) == 0x402b)
 #define OPCODE_JSR(x)	(((x) & 0xF0FF) == 0x400b)
 #define OPCODE_BRA(x)	(((x) & 0xF000) == 0xa000)
diff --git a/arch/sparc/kernel/kprobes.c b/arch/sparc/kernel/kprobes.c
index e722121..627e35c 100644
--- a/arch/sparc/kernel/kprobes.c
+++ b/arch/sparc/kernel/kprobes.c
@@ -45,6 +45,9 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	if ((unsigned long) p->addr & 0x3UL)
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..4aa71a5 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -65,6 +65,9 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+const char * const arch_kprobes_blacksyms[] = {};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 #define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 71a6bee..8a98ddb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -68,7 +68,6 @@
 #endif
 
 static int kprobes_initialized;
-static int kprobe_blacklist_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
@@ -94,26 +93,55 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
  *
  * For such cases, we now have a blacklist
  */
-static struct kprobe_blackpoint kprobe_blacklist[] = {
-	{"preempt_schedule",},
-	{"native_get_debugreg",},
-	{"irq_entries_start",},
-	{"common_interrupt",},
-	{"mcount",},	/* mcount can be called from everywhere */
-	{NULL}    /* Terminator */
+static const char * const common_kprobes_blacksyms[] = {
+	"preempt_schedule",
+	"native_get_debugreg",
+	"irq_entries_start",
+	"common_interrupt",
+	"mcount",       /* mcount can be called from everywhere */
 };
+static const size_t common_kprobes_blacksyms_size =
+			ARRAY_SIZE(common_kprobes_blacksyms);
+
+extern const char * const arch_kprobes_blacksyms[];
+extern const size_t arch_kprobes_blacksyms_size;
+
+static struct kprobe_blackpoint **kprobe_blacklist;
+static size_t kprobe_blacklist_size;
+
+static void init_kprobe_blacklist_entry(struct kprobe_blackpoint *kb,
+					const char * const name)
+{
+	const char *symbol_name;
+	char *modname, namebuf[128];
+	void *addr;
+	unsigned long offset = 0, size = 0;
+
+	kb->name = name;
+	kprobe_lookup_name(kb->name, addr);
+	if (!addr)
+		return;
+
+	kb->start_addr = (unsigned long)addr;
+	symbol_name = kallsyms_lookup(kb->start_addr,
+			&size, &offset, &modname, namebuf);
+	if (!symbol_name)
+		kb->range = 0;
+	else
+		kb->range = size;
+}
 
 /* it can take some time ( > 100ms ) to initialise the
  * blacklist so we delay this until we actually need it
  */
 static void init_kprobe_blacklist(void)
 {
-	int i;
-	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
-	const char *symbol_name;
-	void *addr;
-	struct kprobe_blackpoint *kb;
+	int i, j = 0;
+
+	kprobe_blacklist_size = common_kprobes_blacksyms_size +
+				arch_kprobes_blacksyms_size;
+	kprobe_blacklist = kmalloc(sizeof(*kprobe_blacklist) *
+				   kprobe_blacklist_size, GFP_KERNEL);
 
 	/*
 	 * Lookup and populate the kprobe_blacklist.
@@ -123,18 +151,18 @@ static void init_kprobe_blacklist(void)
 	 * since a kprobe need not necessarily be at the beginning
 	 * of a function.
 	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		kprobe_lookup_name(kb->name, addr);
-		if (!addr)
-			continue;
+	for (i = 0; i < common_kprobes_blacksyms_size; i++, j++) {
+		kprobe_blacklist[j] = kzalloc(sizeof(**kprobe_blacklist),
+					      GFP_KERNEL);
+		init_kprobe_blacklist_entry(kprobe_blacklist[j],
+					    common_kprobes_blacksyms[i]);
+	}
 
-		kb->start_addr = (unsigned long)addr;
-		symbol_name = kallsyms_lookup(kb->start_addr,
-				&size, &offset, &modname, namebuf);
-		if (!symbol_name)
-			kb->range = 0;
-		else
-			kb->range = size;
+	for (i = 0; i < arch_kprobes_blacksyms_size; i++, j++) {
+		kprobe_blacklist[j] = kzalloc(sizeof(**kprobe_blacklist),
+					      GFP_KERNEL);
+		init_kprobe_blacklist_entry(kprobe_blacklist[j],
+					    arch_kprobes_blacksyms[i]);
 	}
 
 	if (kretprobe_blacklist_size) {
@@ -147,7 +175,6 @@ static void init_kprobe_blacklist(void)
 				       kretprobe_blacklist[i].name);
 		}
 	}
-	kprobe_blacklist_initialized = 1;
 }
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
@@ -1375,18 +1402,20 @@ out:
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
+	int i;
 
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
 
-	if (!kprobe_blacklist_initialized)
+	if (!kprobe_blacklist)
 		init_kprobe_blacklist();
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
 	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+	for (i = 0; i < kprobe_blacklist_size; i++) {
+		kb = kprobe_blacklist[i];
 		if (kb->start_addr) {
 			if (addr >= kb->start_addr &&
 			    addr < (kb->start_addr + kb->range))
@@ -1867,7 +1896,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	void *addr;
 
 	if (kretprobe_blacklist_size) {
-		if (!kprobe_blacklist_initialized)
+		if (!kprobe_blacklist)
 			init_kprobe_blacklist();
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))
-- 
1.8.1.5

