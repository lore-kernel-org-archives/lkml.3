Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaA0T1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:27:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0T13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:27:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: rostedt@goodmis.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] jump label: constify lookup functions
Date: Mon, 27 Jan 2014 14:27:19 -0500
Message-Id: <1390850839-24346-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the parameters of all the lookup and the bookkeeping functions which
should be const to const.

For example, jump_label_text_reserved() doesn't modify the memory it works on,
it just checks whether there are any jump labels there.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/include/asm/jump_label.h     |  2 +-
 arch/arm/kernel/jump_label.c          |  6 ++---
 arch/arm64/include/asm/jump_label.h   |  2 +-
 arch/arm64/kernel/jump_label.c        |  6 ++---
 arch/mips/include/asm/jump_label.h    |  2 +-
 arch/mips/kernel/jump_label.c         |  2 +-
 arch/powerpc/include/asm/jump_label.h |  2 +-
 arch/powerpc/kernel/jump_label.c      |  2 +-
 arch/s390/include/asm/jump_label.h    |  2 +-
 arch/s390/kernel/jump_label.c         | 12 ++++-----
 arch/sparc/include/asm/jump_label.h   |  2 +-
 arch/sparc/kernel/jump_label.c        |  2 +-
 arch/x86/include/asm/jump_label.h     |  2 +-
 arch/x86/include/asm/spinlock.h       |  2 +-
 arch/x86/kernel/jump_label.c          |  6 ++---
 include/linux/jump_label.h            | 27 ++++++++++----------
 kernel/jump_label.c                   | 46 ++++++++++++++++++-----------------
 17 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index 863c892..c8a5e9f 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 #define JUMP_LABEL_NOP	"nop"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm_volatile_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f78..9686fce 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -6,7 +6,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-static void __arch_jump_label_transform(struct jump_entry *entry,
+static void __arch_jump_label_transform(const struct jump_entry *entry,
 					enum jump_label_type type,
 					bool is_static)
 {
@@ -24,13 +24,13 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
 		patch_text(addr, insn);
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, false);
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, true);
diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
index 076a1c7..93ca8b3 100644
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -25,7 +25,7 @@
 
 #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("1: nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
index 263a166..c30e4ba 100644
--- a/arch/arm64/kernel/jump_label.c
+++ b/arch/arm64/kernel/jump_label.c
@@ -22,7 +22,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-static void __arch_jump_label_transform(struct jump_entry *entry,
+static void __arch_jump_label_transform(const struct jump_entry *entry,
 					enum jump_label_type type,
 					bool is_static)
 {
@@ -43,13 +43,13 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
 		aarch64_insn_patch_text(&addr, &insn, 1);
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, false);
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, true);
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index e194f95..0ac7892 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,7 +20,7 @@
 #define WORD_INSN ".word"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm_volatile_goto("1:\tnop\n\t"
 		"nop\n\t"
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610..bfba488 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -20,7 +20,7 @@
 
 #define J_RANGE_MASK ((1ul << 28) - 1)
 
-void arch_jump_label_transform(struct jump_entry *e,
+void arch_jump_label_transform(const struct jump_entry *e,
 			       enum jump_label_type type)
 {
 	union mips_instruction insn;
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index f016bb6..93eb7c5 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,7 +17,7 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index a1ed8a8..f9626ec 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -12,7 +12,7 @@
 #include <asm/code-patching.h>
 
 #ifdef HAVE_JUMP_LABEL
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	u32 *addr = (u32 *)(unsigned long)entry->code;
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 346b1c8..9ee8e1b 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm_volatile_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index b987ab2..15a7c60 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -18,11 +18,11 @@ struct insn {
 } __packed;
 
 struct insn_args {
-	struct jump_entry *entry;
+	const const struct jump_entry *entry;
 	enum jump_label_type type;
 };
 
-static void __jump_label_transform(struct jump_entry *entry,
+static void __jump_label_transform(const struct jump_entry *entry,
 				   enum jump_label_type type)
 {
 	struct insn insn;
@@ -42,15 +42,15 @@ static void __jump_label_transform(struct jump_entry *entry,
 	WARN_ON_ONCE(rc < 0);
 }
 
-static int __sm_arch_jump_label_transform(void *data)
+static int __sm_arch_jump_label_transform(const void *data)
 {
-	struct insn_args *args = data;
+	const struct insn_args *args = data;
 
 	__jump_label_transform(args->entry, args->type);
 	return 0;
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	struct insn_args args;
@@ -61,7 +61,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__jump_label_transform(entry, type);
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index ec2e2e2..4f1f223 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,7 +7,7 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 		asm_volatile_goto("1:\n\t"
 			 "nop\n\t"
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index 48565c1..231c10e 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -10,7 +10,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	u32 val;
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 6a2cefb..329ab91 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 # define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm_volatile_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156de..5af9269 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -41,7 +41,7 @@
 #define SPIN_THRESHOLD	(1 << 15)
 
 extern struct static_key paravirt_ticketlocks_enabled;
-static __always_inline bool static_key_false(struct static_key *key);
+static __always_inline bool static_key_false(const struct static_key *key);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 26d5a55..fe1cc9d 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -36,7 +36,7 @@ static void bug_at(unsigned char *ip, int line)
 	BUG();
 }
 
-static void __jump_label_transform(struct jump_entry *entry,
+static void __jump_label_transform(const struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t),
 				   int init)
@@ -102,7 +102,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	get_online_cpus();
@@ -118,7 +118,7 @@ static enum {
 	JL_STATE_UPDATE,
 } jlstate __initdata_or_module = JL_STATE_START;
 
-__init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
+__init_or_module void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	/*
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 5c1dfb2..2b2e358 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -86,13 +86,14 @@ struct module;
 #define JUMP_LABEL_TYPE_MASK		1UL
 
 static
-inline struct jump_entry *jump_label_get_entries(struct static_key *key)
+inline const struct jump_entry *jump_label_get_entries(
+					const struct static_key *key)
 {
 	return (struct jump_entry *)((unsigned long)key->entries
 						& ~JUMP_LABEL_TYPE_MASK);
 }
 
-static inline bool jump_label_get_branch_default(struct static_key *key)
+static inline bool jump_label_get_branch_default(const struct static_key *key)
 {
 	if (((unsigned long)key->entries & JUMP_LABEL_TYPE_MASK) ==
 	    JUMP_LABEL_TYPE_TRUE_BRANCH)
@@ -100,12 +101,12 @@ static inline bool jump_label_get_branch_default(struct static_key *key)
 	return false;
 }
 
-static __always_inline bool static_key_false(struct static_key *key)
+static __always_inline bool static_key_false(const struct static_key *key)
 {
 	return arch_static_branch(key);
 }
 
-static __always_inline bool static_key_true(struct static_key *key)
+static __always_inline bool static_key_true(const struct static_key *key)
 {
 	return !static_key_false(key);
 }
@@ -116,14 +117,14 @@ extern struct jump_entry __stop___jump_table[];
 extern void jump_label_init(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
-extern void arch_jump_label_transform(struct jump_entry *entry,
+extern void arch_jump_label_transform(const struct jump_entry *entry,
 				      enum jump_label_type type);
-extern void arch_jump_label_transform_static(struct jump_entry *entry,
+extern void arch_jump_label_transform_static(const struct jump_entry *entry,
 					     enum jump_label_type type);
-extern int jump_label_text_reserved(void *start, void *end);
+extern int jump_label_text_reserved(const void *start, const void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void jump_label_apply_nops(struct module *mod);
+extern void jump_label_apply_nops(const struct module *mod);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key)		\
 	{ .enabled = ATOMIC_INIT(1),				\
@@ -143,14 +144,14 @@ static __always_inline void jump_label_init(void)
 	static_key_initialized = true;
 }
 
-static __always_inline bool static_key_false(struct static_key *key)
+static __always_inline bool static_key_false(const struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled) > 0))
 		return true;
 	return false;
 }
 
-static __always_inline bool static_key_true(struct static_key *key)
+static __always_inline bool static_key_true(const struct static_key *key)
 {
 	if (likely(atomic_read(&key->enabled) > 0))
 		return true;
@@ -169,7 +170,7 @@ static inline void static_key_slow_dec(struct static_key *key)
 	atomic_dec(&key->enabled);
 }
 
-static inline int jump_label_text_reserved(void *start, void *end)
+static inline int jump_label_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
@@ -177,7 +178,7 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline int jump_label_apply_nops(struct module *mod)
+static inline int jump_label_apply_nops(const struct module *mod)
 {
 	return 0;
 }
@@ -192,7 +193,7 @@ static inline int jump_label_apply_nops(struct module *mod)
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
-static inline bool static_key_enabled(struct static_key *key)
+static inline bool static_key_enabled(const struct static_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 9019f15..6879f48 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -54,7 +54,7 @@ jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static void jump_label_update(struct static_key *key, int enable);
+static void jump_label_update(const struct static_key *key, int enable);
 
 void static_key_slow_inc(struct static_key *key)
 {
@@ -125,7 +125,8 @@ void jump_label_rate_limit(struct static_key_deferred *key,
 }
 EXPORT_SYMBOL_GPL(jump_label_rate_limit);
 
-static int addr_conflict(struct jump_entry *entry, void *start, void *end)
+static int addr_conflict(const struct jump_entry *entry, const void *start,
+		const void *end)
 {
 	if (entry->code <= (unsigned long)end &&
 		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
@@ -134,10 +135,11 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 	return 0;
 }
 
-static int __jump_label_text_reserved(struct jump_entry *iter_start,
-		struct jump_entry *iter_stop, void *start, void *end)
+static int __jump_label_text_reserved(const struct jump_entry *iter_start,
+		const struct jump_entry *iter_stop, const void *start,
+		const void *end)
 {
-	struct jump_entry *iter;
+	const struct jump_entry *iter;
 
 	iter = iter_start;
 	while (iter < iter_stop) {
@@ -155,15 +157,15 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
  * running code can override this to make the non-live update case
  * cheaper.
  */
-void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry *entry,
-					    enum jump_label_type type)
+void __weak __init_or_module arch_jump_label_transform_static(
+		const struct jump_entry *entry, enum jump_label_type type)
 {
 	arch_jump_label_transform(entry, type);	
 }
 
-static void __jump_label_update(struct static_key *key,
-				struct jump_entry *entry,
-				struct jump_entry *stop, int enable)
+static void __jump_label_update(const struct static_key *key,
+				const struct jump_entry *entry,
+				const struct jump_entry *stop, int enable)
 {
 	for (; (entry < stop) &&
 	      (entry->key == (jump_label_t)(unsigned long)key);
@@ -178,7 +180,7 @@ static void __jump_label_update(struct static_key *key,
 	}
 }
 
-static enum jump_label_type jump_label_type(struct static_key *key)
+static enum jump_label_type jump_label_type(const struct static_key *key)
 {
 	bool true_branch = jump_label_get_branch_default(key);
 	bool state = static_key_enabled(key);
@@ -228,9 +230,9 @@ struct static_key_mod {
 	struct module *mod;
 };
 
-static int __jump_label_mod_text_reserved(void *start, void *end)
+static int __jump_label_mod_text_reserved(const void *start, const void *end)
 {
-	struct module *mod;
+	const struct module *mod;
 
 	mod = __module_text_address((unsigned long)start);
 	if (!mod)
@@ -243,12 +245,12 @@ static int __jump_label_mod_text_reserved(void *start, void *end)
 				start, end);
 }
 
-static void __jump_label_mod_update(struct static_key *key, int enable)
+static void __jump_label_mod_update(const struct static_key *key, int enable)
 {
-	struct static_key_mod *mod = key->next;
+	const struct static_key_mod *mod = key->next;
 
 	while (mod) {
-		struct module *m = mod->mod;
+		const struct module *m = mod->mod;
 
 		__jump_label_update(key, mod->entries,
 				    m->jump_entries + m->num_jump_entries,
@@ -265,7 +267,7 @@ static void __jump_label_mod_update(struct static_key *key, int enable)
  * loads patch these with arch_get_jump_label_nop(), which is specified by
  * the arch specific jump label code.
  */
-void jump_label_apply_nops(struct module *mod)
+void jump_label_apply_nops(const struct module *mod)
 {
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
@@ -425,7 +427,7 @@ early_initcall(jump_label_init_module);
  *
  * returns 1 if there is an overlap, 0 otherwise
  */
-int jump_label_text_reserved(void *start, void *end)
+int jump_label_text_reserved(const void *start, const void *end)
 {
 	int ret = __jump_label_text_reserved(__start___jump_table,
 			__stop___jump_table, start, end);
@@ -439,13 +441,13 @@ int jump_label_text_reserved(void *start, void *end)
 	return ret;
 }
 
-static void jump_label_update(struct static_key *key, int enable)
+static void jump_label_update(const struct static_key *key, int enable)
 {
-	struct jump_entry *stop = __stop___jump_table;
-	struct jump_entry *entry = jump_label_get_entries(key);
+	const struct jump_entry *stop = __stop___jump_table;
+	const struct jump_entry *entry = jump_label_get_entries(key);
 
 #ifdef CONFIG_MODULES
-	struct module *mod = __module_address((unsigned long)key);
+	const struct module *mod = __module_address((unsigned long)key);
 
 	__jump_label_mod_update(key, enable);
 
-- 
1.8.3.2

