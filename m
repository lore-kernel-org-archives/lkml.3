Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaFDWgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:36:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFDWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:36:32 -0400
Date: Wed, 4 Jun 2014 15:35:42 -0700
Message-Id: <201406042235.s54MZgwP020553@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vdso changes for v3.16
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: gorcunov@openvz.org, hpa@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luto@amacapital.net, mingo@kernel.org,
        sasha.levin@oracle.com, stefani@seibold.net, tglx@linutronix.de,
        xemul@parallels.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Vdso cleanups and improvements largely from Andy Lutomirski.  This
makes the vdso a lot less "special".

This patchset depends on the x86/espfix changes and should be applied
*after* that patchset.

The following changes since commit 368b69a5b010cb00fc9ea04d588cff69af1a1359:

  x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET (2014-05-21 16:14:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso

for you to fetch changes up to c191920f737a09a7252088f018f6747f0d2f484d:

  x86/vdso, build: Make LE access macros clearer, host-safe (2014-05-31 03:35:27 -0700)

----------------------------------------------------------------
Andy Lutomirski (13):
      x86, mm: Ensure correct alignment of the fixmap
      x86, vdso: Clean up 32-bit vs 64-bit vdso params
      x86, vdso: Move syscall and sysenter setup into kernel/cpu/common.c
      x86, vdso: Reimplement vdso.so preparation in build-time C
      x86, vdso: Move the 32-bit vdso special pages after the text
      x86, vdso: Move the vvar and hpet mappings next to the 64-bit vDSO
      x86, vdso: Remove vestiges of VDSO_PRELINK and some outdated comments
      x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET
      mm, fs: Add vm_ops->name as an alternative to arch_vma_name
      x86, mm: Improve _install_special_mapping and fix x86 vdso naming
      x86, mm: Replace arch_vma_name with vm_ops->name for vsyscalls
      x86/vdso, build: When vdso2c fails, unlink the output
      x86/vdso, build: Fix cross-compilation from big-endian architectures

H. Peter Anvin (3):
      Merge remote-tracking branch 'origin/x86/espfix' into x86/vdso
      Merge remote-tracking branch 'origin/x86/urgent' into x86/vdso
      x86/vdso, build: Make LE access macros clearer, host-safe

 arch/x86/ia32/ia32_signal.c          |   8 +-
 arch/x86/include/asm/elf.h           |  35 +++---
 arch/x86/include/asm/fixmap.h        |  11 +-
 arch/x86/include/asm/mmu.h           |   2 +-
 arch/x86/include/asm/proto.h         |   2 -
 arch/x86/include/asm/vdso.h          |  78 +++++-------
 arch/x86/include/asm/vdso32.h        |  11 --
 arch/x86/include/asm/vvar.h          |  20 +--
 arch/x86/include/uapi/asm/vsyscall.h |   7 +-
 arch/x86/kernel/cpu/common.c         |  33 +++++
 arch/x86/kernel/hpet.c               |   3 -
 arch/x86/kernel/signal.c             |   6 +-
 arch/x86/kernel/vsyscall_64.c        |  15 +--
 arch/x86/mm/fault.c                  |   5 +-
 arch/x86/mm/init_64.c                |  29 +++--
 arch/x86/mm/ioremap.c                |   6 +
 arch/x86/mm/pgtable.c                |   6 +-
 arch/x86/um/vdso/vma.c               |   2 +-
 arch/x86/vdso/.gitignore             |   5 +-
 arch/x86/vdso/Makefile               |  90 +++++--------
 arch/x86/vdso/vclock_gettime.c       |  26 ++--
 arch/x86/vdso/vdso-layout.lds.S      |  40 +++---
 arch/x86/vdso/vdso.S                 |   3 -
 arch/x86/vdso/vdso.lds.S             |   7 +-
 arch/x86/vdso/vdso2c.c               | 173 +++++++++++++++++++++++++
 arch/x86/vdso/vdso2c.h               | 163 ++++++++++++++++++++++++
 arch/x86/vdso/vdso32-setup.c         | 204 ++++--------------------------
 arch/x86/vdso/vdso32.S               |   9 --
 arch/x86/vdso/vdso32/vdso32.lds.S    |  15 +--
 arch/x86/vdso/vdsox32.S              |   3 -
 arch/x86/vdso/vdsox32.lds.S          |   7 +-
 arch/x86/vdso/vma.c                  | 236 +++++++++++++++++++----------------
 arch/x86/xen/mmu.c                   |   8 +-
 arch/x86/xen/setup.c                 |  11 +-
 fs/binfmt_elf.c                      |   8 ++
 fs/proc/task_mmu.c                   |   6 +
 include/linux/mm.h                   |  10 +-
 include/linux/mm_types.h             |   6 +
 kernel/sysctl.c                      |   5 +
 mm/mmap.c                            |  89 ++++++++-----
 40 files changed, 794 insertions(+), 609 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 2206757..f9e181a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -383,8 +383,8 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	} else {
 		/* Return stub is in 32bit vsyscall page */
 		if (current->mm->context.vdso)
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
-						 sigreturn);
+			restorer = current->mm->context.vdso +
+				selected_vdso32->sym___kernel_sigreturn;
 		else
 			restorer = &frame->retcode;
 	}
@@ -462,8 +462,8 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		else
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
-						 rt_sigreturn);
+			restorer = current->mm->context.vdso +
+				selected_vdso32->sym___kernel_rt_sigreturn;
 		put_user_ex(ptr_to_compat(restorer), &frame->pretcode);
 
 		/*
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 2c71182..1a055c8 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -75,7 +75,12 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
 
 #include <asm/vdso.h>
 
-extern unsigned int vdso_enabled;
+#ifdef CONFIG_X86_64
+extern unsigned int vdso64_enabled;
+#endif
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+extern unsigned int vdso32_enabled;
+#endif
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
@@ -269,9 +274,9 @@ extern int force_personality32;
 
 struct task_struct;
 
-#define	ARCH_DLINFO_IA32(vdso_enabled)					\
+#define	ARCH_DLINFO_IA32						\
 do {									\
-	if (vdso_enabled) {						\
+	if (vdso32_enabled) {						\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
 	}								\
@@ -281,7 +286,7 @@ do {									\
 
 #define STACK_RND_MASK (0x7ff)
 
-#define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
+#define ARCH_DLINFO		ARCH_DLINFO_IA32
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
@@ -292,16 +297,17 @@ do {									\
 
 #define ARCH_DLINFO							\
 do {									\
-	if (vdso_enabled)						\
+	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
-			    (unsigned long)current->mm->context.vdso);	\
+			    (unsigned long __force)current->mm->context.vdso); \
 } while (0)
 
+/* As a historical oddity, the x32 and x86_64 vDSOs are controlled together. */
 #define ARCH_DLINFO_X32							\
 do {									\
-	if (vdso_enabled)						\
+	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
-			    (unsigned long)current->mm->context.vdso);	\
+			    (unsigned long __force)current->mm->context.vdso); \
 } while (0)
 
 #define AT_SYSINFO		32
@@ -310,7 +316,7 @@ do {									\
 if (test_thread_flag(TIF_X32))						\
 	ARCH_DLINFO_X32;						\
 else									\
-	ARCH_DLINFO_IA32(sysctl_vsyscall32)
+	ARCH_DLINFO_IA32
 
 #define COMPAT_ELF_ET_DYN_BASE	(TASK_UNMAPPED_BASE + 0x1000000)
 
@@ -319,18 +325,17 @@ else									\
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
 
 #define VDSO_ENTRY							\
-	((unsigned long)VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
+	((unsigned long)current->mm->context.vdso +			\
+	 selected_vdso32->sym___kernel_vsyscall)
 
 struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
-extern int x32_setup_additional_pages(struct linux_binprm *bprm,
-				      int uses_interp);
-
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-#define compat_arch_setup_additional_pages	syscall32_setup_pages
+extern int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
+					      int uses_interp);
+#define compat_arch_setup_additional_pages compat_arch_setup_additional_pages
 
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 43f482a..b0910f9 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -24,7 +24,7 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #else
-#include <asm/vsyscall.h>
+#include <uapi/asm/vsyscall.h>
 #endif
 
 /*
@@ -41,7 +41,8 @@
 extern unsigned long __FIXADDR_TOP;
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 #else
-#define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
+#define FIXADDR_TOP	(round_up(VSYSCALL_ADDR + PAGE_SIZE, 1<<PMD_SHIFT) - \
+			 PAGE_SIZE)
 #endif
 
 
@@ -68,11 +69,7 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 #else
-	VSYSCALL_LAST_PAGE,
-	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
-			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
-	VVAR_PAGE,
-	VSYSCALL_HPET,
+	VSYSCALL_PAGE = (FIXADDR_TOP - VSYSCALL_ADDR) >> PAGE_SHIFT,
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 5f55e69..876e74e 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -18,7 +18,7 @@ typedef struct {
 #endif
 
 	struct mutex lock;
-	void *vdso;
+	void __user *vdso;
 } mm_context_t;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 6fd3fd7..a90f897 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -12,8 +12,6 @@ void ia32_syscall(void);
 void ia32_cstar_target(void);
 void ia32_sysenter_target(void);
 
-void syscall32_cpu_init(void);
-
 void x86_configure_nx(void);
 void x86_report_nx(void);
 
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index d1dc554..30be253 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -3,63 +3,51 @@
 
 #include <asm/page_types.h>
 #include <linux/linkage.h>
+#include <linux/init.h>
 
-#ifdef __ASSEMBLER__
+#ifndef __ASSEMBLER__
 
-#define DEFINE_VDSO_IMAGE(symname, filename)				\
-__PAGE_ALIGNED_DATA ;							\
-	.globl symname##_start, symname##_end ;				\
-	.align PAGE_SIZE ;						\
-	symname##_start: ;						\
-	.incbin filename ;						\
-	symname##_end: ;						\
-	.align PAGE_SIZE /* extra data here leaks to userspace. */ ;	\
-									\
-.previous ;								\
-									\
-	.globl symname##_pages ;					\
-	.bss ;								\
-	.align 8 ;							\
-	.type symname##_pages, @object ;				\
-	symname##_pages: ;						\
-	.zero (symname##_end - symname##_start + PAGE_SIZE - 1) / PAGE_SIZE * (BITS_PER_LONG / 8) ; \
-	.size symname##_pages, .-symname##_pages
+#include <linux/mm_types.h>
 
-#else
+struct vdso_image {
+	void *data;
+	unsigned long size;   /* Always a multiple of PAGE_SIZE */
 
-#define DECLARE_VDSO_IMAGE(symname)				\
-	extern char symname##_start[], symname##_end[];		\
-	extern struct page *symname##_pages[]
+	/* text_mapping.pages is big enough for data/size page pointers */
+	struct vm_special_mapping text_mapping;
 
-#if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+	unsigned long alt, alt_len;
 
-#include <asm/vdso32.h>
+	unsigned long sym_end_mapping;  /* Total size of the mapping */
 
-DECLARE_VDSO_IMAGE(vdso32_int80);
-#ifdef CONFIG_COMPAT
-DECLARE_VDSO_IMAGE(vdso32_syscall);
+	unsigned long sym_vvar_page;
+	unsigned long sym_hpet_page;
+	unsigned long sym_VDSO32_NOTE_MASK;
+	unsigned long sym___kernel_sigreturn;
+	unsigned long sym___kernel_rt_sigreturn;
+	unsigned long sym___kernel_vsyscall;
+	unsigned long sym_VDSO32_SYSENTER_RETURN;
+};
+
+#ifdef CONFIG_X86_64
+extern const struct vdso_image vdso_image_64;
+#endif
+
+#ifdef CONFIG_X86_X32
+extern const struct vdso_image vdso_image_x32;
 #endif
-DECLARE_VDSO_IMAGE(vdso32_sysenter);
 
-/*
- * Given a pointer to the vDSO image, find the pointer to VDSO32_name
- * as that symbol is defined in the vDSO sources or linker script.
- */
-#define VDSO32_SYMBOL(base, name)					\
-({									\
-	extern const char VDSO32_##name[];				\
-	(void __user *)(VDSO32_##name + (unsigned long)(base));		\
-})
+#if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+extern const struct vdso_image vdso_image_32_int80;
+#ifdef CONFIG_COMPAT
+extern const struct vdso_image vdso_image_32_syscall;
 #endif
+extern const struct vdso_image vdso_image_32_sysenter;
 
-/*
- * These symbols are defined with the addresses in the vsyscall page.
- * See vsyscall-sigreturn.S.
- */
-extern void __user __kernel_sigreturn;
-extern void __user __kernel_rt_sigreturn;
+extern const struct vdso_image *selected_vdso32;
+#endif
 
-void __init patch_vdso32(void *vdso, size_t len);
+extern void __init init_vdso_image(const struct vdso_image *image);
 
 #endif /* __ASSEMBLER__ */
 
diff --git a/arch/x86/include/asm/vdso32.h b/arch/x86/include/asm/vdso32.h
deleted file mode 100644
index 7efb701..0000000
--- a/arch/x86/include/asm/vdso32.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_X86_VDSO32_H
-#define _ASM_X86_VDSO32_H
-
-#define VDSO_BASE_PAGE	0
-#define VDSO_VVAR_PAGE	1
-#define VDSO_HPET_PAGE	2
-#define VDSO_PAGES	3
-#define VDSO_PREV_PAGES	2
-#define VDSO_OFFSET(x)	((x) * PAGE_SIZE)
-
-#endif
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 081d909..5d2b9ad 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -29,31 +29,13 @@
 
 #else
 
-#ifdef BUILD_VDSO32
+extern char __vvar_page;
 
 #define DECLARE_VVAR(offset, type, name)				\
 	extern type vvar_ ## name __attribute__((visibility("hidden")));
 
 #define VVAR(name) (vvar_ ## name)
 
-#else
-
-extern char __vvar_page;
-
-/* Base address of vvars.  This is not ABI. */
-#ifdef CONFIG_X86_64
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
-#else
-#define VVAR_ADDRESS (&__vvar_page)
-#endif
-
-#define DECLARE_VVAR(offset, type, name)				\
-	static type const * const vvaraddr_ ## name =			\
-		(void *)(VVAR_ADDRESS + (offset));
-
-#define VVAR(name) (*vvaraddr_ ## name)
-#endif
-
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
diff --git a/arch/x86/include/uapi/asm/vsyscall.h b/arch/x86/include/uapi/asm/vsyscall.h
index 85dc1b3..b97dd6e 100644
--- a/arch/x86/include/uapi/asm/vsyscall.h
+++ b/arch/x86/include/uapi/asm/vsyscall.h
@@ -7,11 +7,6 @@ enum vsyscall_num {
 	__NR_vgetcpu,
 };
 
-#define VSYSCALL_START (-10UL << 20)
-#define VSYSCALL_SIZE 1024
-#define VSYSCALL_END (-2UL << 20)
-#define VSYSCALL_MAPPED_PAGES 1
-#define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
-
+#define VSYSCALL_ADDR (-10UL << 20)
 
 #endif /* _UAPI_ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..2cbbf88 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -20,6 +20,7 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <asm/sections.h>
+#include <asm/vsyscall.h>
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <asm/pgtable.h>
@@ -953,6 +954,38 @@ static void vgetcpu_set_mode(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 }
+
+/* May not be __init: called during resume */
+static void syscall32_cpu_init(void)
+{
+	/* Load these always in case some future AMD CPU supports
+	   SYSENTER from compat mode too. */
+	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
+	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
+
+	wrmsrl(MSR_CSTAR, ia32_cstar_target);
+}
+#endif
+
+#ifdef CONFIG_X86_32
+void enable_sep_cpu(void)
+{
+	int cpu = get_cpu();
+	struct tss_struct *tss = &per_cpu(init_tss, cpu);
+
+	if (!boot_cpu_has(X86_FEATURE_SEP)) {
+		put_cpu();
+		return;
+	}
+
+	tss->x86_tss.ss1 = __KERNEL_CS;
+	tss->x86_tss.sp1 = sizeof(struct tss_struct) + (unsigned long) tss;
+	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.sp1, 0);
+	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) ia32_sysenter_target, 0);
+	put_cpu();
+}
 #endif
 
 void __init identify_boot_cpu(void)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4177bfb..a9777bb 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -74,9 +74,6 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
-#endif
 }
 
 static inline void hpet_clear_mapping(void)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de68..a0da58d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -298,7 +298,8 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	}
 
 	if (current->mm->context.vdso)
-		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
+		restorer = current->mm->context.vdso +
+			selected_vdso32->sym___kernel_sigreturn;
 	else
 		restorer = &frame->retcode;
 	if (ksig->ka.sa.sa_flags & SA_RESTORER)
@@ -361,7 +362,8 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  */
-		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+		restorer = current->mm->context.vdso +
+			selected_vdso32->sym___kernel_sigreturn;
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		put_user_ex(restorer, &frame->pretcode);
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8b3b3eb..ea5b570 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -91,7 +91,7 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 {
 	int nr;
 
-	if ((addr & ~0xC00UL) != VSYSCALL_START)
+	if ((addr & ~0xC00UL) != VSYSCALL_ADDR)
 		return -EINVAL;
 
 	nr = (addr & 0xC00UL) >> 10;
@@ -330,24 +330,17 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
-	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
-	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
+	__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
 		     vsyscall_mode == NATIVE
 		     ? PAGE_KERNEL_VSYSCALL
 		     : PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_FIRST_PAGE) !=
-		     (unsigned long)VSYSCALL_START);
-
-	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
-		     (unsigned long)VVAR_ADDRESS);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
+		     (unsigned long)VSYSCALL_ADDR);
 }
 
 static int __init vsyscall_init(void)
 {
-	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
-
 	cpu_notifier_register_begin();
 
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..858b47b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,7 +18,8 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
-#include <asm/fixmap.h>			/* VSYSCALL_START		*/
+#include <asm/fixmap.h>			/* VSYSCALL_ADDR		*/
+#include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -771,7 +772,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		 * emulation.
 		 */
 		if (unlikely((error_code & PF_INSTR) &&
-			     ((address & ~0xfff) == VSYSCALL_START))) {
+			     ((address & ~0xfff) == VSYSCALL_ADDR))) {
 			if (emulate_vsyscall(regs, address))
 				return;
 		}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f35c66c..bdcde58 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1055,8 +1055,8 @@ void __init mem_init(void)
 	after_bootmem = 1;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
-			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
+	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR,
+			 PAGE_SIZE, KCORE_OTHER);
 
 	mem_init_print_info(NULL);
 }
@@ -1185,11 +1185,19 @@ int kern_addr_valid(unsigned long addr)
  * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
  * not need special handling anymore:
  */
+static const char *gate_vma_name(struct vm_area_struct *vma)
+{
+	return "[vsyscall]";
+}
+static struct vm_operations_struct gate_vma_ops = {
+	.name = gate_vma_name,
+};
 static struct vm_area_struct gate_vma = {
-	.vm_start	= VSYSCALL_START,
-	.vm_end		= VSYSCALL_START + (VSYSCALL_MAPPED_PAGES * PAGE_SIZE),
+	.vm_start	= VSYSCALL_ADDR,
+	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
-	.vm_flags	= VM_READ | VM_EXEC
+	.vm_flags	= VM_READ | VM_EXEC,
+	.vm_ops		= &gate_vma_ops,
 };
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
@@ -1218,16 +1226,7 @@ int in_gate_area(struct mm_struct *mm, unsigned long addr)
  */
 int in_gate_area_no_mm(unsigned long addr)
 {
-	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
-}
-
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
-		return "[vdso]";
-	if (vma == &gate_vma)
-		return "[vsyscall]";
-	return NULL;
+	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
 #ifdef CONFIG_X86_UV
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 597ac15..6ef98c5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -355,6 +355,12 @@ void __init early_ioremap_init(void)
 {
 	pmd_t *pmd;
 
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON((fix_to_virt(0) + PAGE_SIZE) & ((1 << PMD_SHIFT) - 1));
+#else
+	WARN_ON((fix_to_virt(0) + PAGE_SIZE) & ((1 << PMD_SHIFT) - 1));
+#endif
+
 	early_ioremap_setup();
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index c96314a..5f8bdda 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -449,9 +449,9 @@ void __init reserve_top_address(unsigned long reserve)
 {
 #ifdef CONFIG_X86_32
 	BUG_ON(fixmaps_set > 0);
-	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
-	       (int)-reserve);
-	__FIXADDR_TOP = -reserve - PAGE_SIZE;
+	__FIXADDR_TOP = round_down(-reserve, 1 << PMD_SHIFT) - PAGE_SIZE;
+	printk(KERN_INFO "Reserving virtual address space above 0x%08lx (rounded to 0x%08lx)\n",
+	       -reserve, __FIXADDR_TOP + PAGE_SIZE);
 #endif
 }
 
diff --git a/arch/x86/um/vdso/vma.c b/arch/x86/um/vdso/vma.c
index af91901..916cda4 100644
--- a/arch/x86/um/vdso/vma.c
+++ b/arch/x86/um/vdso/vma.c
@@ -12,7 +12,7 @@
 #include <asm/page.h>
 #include <linux/init.h>
 
-unsigned int __read_mostly vdso_enabled = 1;
+static unsigned int __read_mostly vdso_enabled = 1;
 unsigned long um_vdso_addr;
 
 extern unsigned long task_size;
diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 3282874..aae8ffd 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,8 +1,7 @@
 vdso.lds
-vdso-syms.lds
 vdsox32.lds
-vdsox32-syms.lds
-vdso32-syms.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
 vdso32-int80-syms.lds
+vdso-image-*.c
+vdso2c
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index c580d12..895d4b1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -24,15 +24,30 @@ vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
 
 # files to link into kernel
 obj-y				+= vma.o
-obj-$(VDSO64-y)			+= vdso.o
-obj-$(VDSOX32-y)		+= vdsox32.o
-obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
+
+# vDSO images to build
+vdso_img-$(VDSO64-y)		+= 64
+vdso_img-$(VDSOX32-y)		+= x32
+vdso_img-$(VDSO32-y)		+= 32-int80
+vdso_img-$(CONFIG_COMPAT)	+= 32-syscall
+vdso_img-$(VDSO32-y)		+= 32-sysenter
+
+obj-$(VDSO32-y)			+= vdso32-setup.o
 
 vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
+targets += vdso.lds $(vobjs-y)
+
+# Build the vDSO image C files and link them in.
+vdso_img_objs := $(vdso_img-y:%=vdso-image-%.o)
+vdso_img_cfiles := $(vdso_img-y:%=vdso-image-%.c)
+vdso_img_sodbg := $(vdso_img-y:%=vdso%.so.dbg)
+obj-y += $(vdso_img_objs)
+targets += $(vdso_img_cfiles)
+targets += $(vdso_img_sodbg)
+.SECONDARY: $(vdso_img-y:%=$(obj)/vdso-image-%.c)
 
 export CPPFLAGS_vdso.lds += -P -C
 
@@ -41,14 +56,18 @@ VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 			-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 \
 			$(DISABLE_LTO)
 
-$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
-
-$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso64.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
 
-$(obj)/%.so: OBJCOPYFLAGS := -S
-$(obj)/%.so: $(obj)/%.so.dbg FORCE
-	$(call if_changed,objcopy)
+hostprogs-y			+= vdso2c
+
+quiet_cmd_vdso2c = VDSO2C  $@
+define cmd_vdso2c
+	$(obj)/vdso2c $< $@
+endef
+
+$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso2c FORCE
+	$(call if_changed,vdso2c)
 
 #
 # Don't omit frame pointers for ease of userspace debugging, but do
@@ -68,22 +87,6 @@ CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
 
-targets += vdso-syms.lds
-obj-$(VDSO64-y)			+= vdso-syms.lds
-
-#
-# Match symbols in the DSO that look like VDSO*; produce a file of constants.
-#
-sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
-quiet_cmd_vdsosym = VDSOSYM $@
-define cmd_vdsosym
-	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
-endef
-
-$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
-	$(call if_changed,vdsosym)
-
 #
 # X32 processes use x32 vDSO to access 64bit kernel data.
 #
@@ -94,9 +97,6 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 # so that it can reach 64bit address space with 64bit pointers.
 #
 
-targets += vdsox32-syms.lds
-obj-$(VDSOX32-y)		+= vdsox32-syms.lds
-
 CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
 			   -Wl,-soname=linux-vdso.so.1 \
@@ -113,9 +113,7 @@ quiet_cmd_x32 = X32     $@
 $(obj)/%-x32.o: $(obj)/%.o FORCE
 	$(call if_changed,x32)
 
-targets += vdsox32.so vdsox32.so.dbg vdsox32.lds $(vobjx32s-y)
-
-$(obj)/vdsox32.o: $(src)/vdsox32.S $(obj)/vdsox32.so
+targets += vdsox32.lds $(vobjx32s-y)
 
 $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso)
@@ -123,7 +121,6 @@ $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 #
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
-obj-$(VDSO32-y)			+= vdso32-syms.lds
 vdso32.so-$(VDSO32-y)		+= int80
 vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
@@ -138,10 +135,8 @@ VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-m,elf_i386 -Wl,-soname=linux-gate.so.1
 override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
-targets += $(vdso32-images) $(vdso32-images:=.dbg)
 targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
-
-extra-y	+= $(vdso32-images)
+targets += vdso32/vclock_gettime.o
 
 $(obj)/vdso32.o: $(vdso32-images:%=$(obj)/%)
 
@@ -166,27 +161,6 @@ $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
 
-# Make vdso32-*-syms.lds from each image, and then make sure they match.
-# The only difference should be that some do not define VDSO32_SYSENTER_RETURN.
-
-targets += vdso32-syms.lds $(vdso32.so-y:%=vdso32-%-syms.lds)
-
-quiet_cmd_vdso32sym = VDSOSYM $@
-define cmd_vdso32sym
-	if LC_ALL=C sort -u $(filter-out FORCE,$^) > $(@D)/.tmp_$(@F) && \
-	   $(foreach H,$(filter-out FORCE,$^),\
-		     if grep -q VDSO32_SYSENTER_RETURN $H; \
-		     then diff -u $(@D)/.tmp_$(@F) $H; \
-		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
-			  diff -u - $H; fi &&) : ;\
-	then mv -f $(@D)/.tmp_$(@F) $@; \
-	else rm -f $(@D)/.tmp_$(@F); exit 1; \
-	fi
-endef
-
-$(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
-	$(call if_changed,vdso32sym)
-
 #
 # The DSO images are built using a special linker script.
 #
@@ -197,7 +171,7 @@ quiet_cmd_vdso = VDSO    $@
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
 VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
-		$(LTO_CFLAGS)
+	-Wl,-Bsymbolic $(LTO_CFLAGS)
 GCOV_PROFILE := n
 
 #
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 16d6861..b2e4f49 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -30,9 +30,12 @@ extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
 extern time_t __vdso_time(time_t *t);
 
 #ifdef CONFIG_HPET_TIMER
-static inline u32 read_hpet_counter(const volatile void *addr)
+extern u8 hpet_page
+	__attribute__((visibility("hidden")));
+
+static notrace cycle_t vread_hpet(void)
 {
-	return *(const volatile u32 *) (addr + HPET_COUNTER);
+	return *(const volatile u32 *)(&hpet_page + HPET_COUNTER);
 }
 #endif
 
@@ -43,11 +46,6 @@ static inline u32 read_hpet_counter(const volatile void *addr)
 #include <asm/fixmap.h>
 #include <asm/pvclock.h>
 
-static notrace cycle_t vread_hpet(void)
-{
-	return read_hpet_counter((const void *)fix_to_virt(VSYSCALL_HPET));
-}
-
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
@@ -137,16 +135,6 @@ static notrace cycle_t vread_pvclock(int *mode)
 
 #else
 
-extern u8 hpet_page
-	__attribute__((visibility("hidden")));
-
-#ifdef CONFIG_HPET_TIMER
-static notrace cycle_t vread_hpet(void)
-{
-	return read_hpet_counter((const void *)(&hpet_page));
-}
-#endif
-
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
@@ -154,7 +142,7 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	asm(
 		"mov %%ebx, %%edx \n"
 		"mov %2, %%ebx \n"
-		"call VDSO32_vsyscall \n"
+		"call __kernel_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
 		: "0" (__NR_clock_gettime), "g" (clock), "c" (ts)
@@ -169,7 +157,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 	asm(
 		"mov %%ebx, %%edx \n"
 		"mov %2, %%ebx \n"
-		"call VDSO32_vsyscall \n"
+		"call __kernel_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
 		: "0" (__NR_gettimeofday), "g" (tv), "c" (tz)
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 9df017a..2ec72f6 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -1,3 +1,5 @@
+#include <asm/vdso.h>
+
 /*
  * Linker script for vDSO.  This is an ELF shared object prelinked to
  * its virtual address, and with only one read-only segment.
@@ -6,20 +8,6 @@
 
 SECTIONS
 {
-#ifdef BUILD_VDSO32
-#include <asm/vdso32.h>
-
-	hpet_page = . - VDSO_OFFSET(VDSO_HPET_PAGE);
-
-	vvar = . - VDSO_OFFSET(VDSO_VVAR_PAGE);
-
-	/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) vvar_ ## name = vvar + offset;
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-#endif
 	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
@@ -60,10 +48,30 @@ SECTIONS
 	.text		: { *(.text*) }			:text	=0x90909090,
 
 	/*
-	 * The comma above works around a bug in gold:
-	 * https://sourceware.org/bugzilla/show_bug.cgi?id=16804
+	 * The remainder of the vDSO consists of special pages that are
+	 * shared between the kernel and userspace.  It needs to be at the
+	 * end so that it doesn't overlap the mapping of the actual
+	 * vDSO image.
 	 */
 
+	. = ALIGN(PAGE_SIZE);
+	vvar_page = .;
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	. = vvar_page + PAGE_SIZE;
+
+	hpet_page = .;
+	. = . + PAGE_SIZE;
+
+	. = ALIGN(PAGE_SIZE);
+	end_mapping = .;
+
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
deleted file mode 100644
index be3f23b..0000000
--- a/arch/x86/vdso/vdso.S
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdso, "arch/x86/vdso/vdso.so")
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index b96b267..75e3404 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -1,14 +1,11 @@
 /*
  * Linker script for 64-bit vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
-#define VDSO_PRELINK 0xffffffffff700000
 #include "vdso-layout.lds.S"
 
 /*
@@ -28,5 +25,3 @@ VERSION {
 	local: *;
 	};
 }
-
-VDSO64_PRELINK = VDSO_PRELINK;
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
new file mode 100644
index 0000000..deabaf5
--- /dev/null
+++ b/arch/x86/vdso/vdso2c.c
@@ -0,0 +1,173 @@
+#include <inttypes.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <err.h>
+
+#include <sys/mman.h>
+#include <sys/types.h>
+
+#include <linux/elf.h>
+#include <linux/types.h>
+
+const char *outfilename;
+
+/* Symbols that we need in vdso2c. */
+enum {
+	sym_vvar_page,
+	sym_hpet_page,
+	sym_end_mapping,
+};
+
+const int special_pages[] = {
+	sym_vvar_page,
+	sym_hpet_page,
+};
+
+char const * const required_syms[] = {
+	[sym_vvar_page] = "vvar_page",
+	[sym_hpet_page] = "hpet_page",
+	[sym_end_mapping] = "end_mapping",
+	"VDSO32_NOTE_MASK",
+	"VDSO32_SYSENTER_RETURN",
+	"__kernel_vsyscall",
+	"__kernel_sigreturn",
+	"__kernel_rt_sigreturn",
+};
+
+__attribute__((format(printf, 1, 2))) __attribute__((noreturn))
+static void fail(const char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	fprintf(stderr, "Error: ");
+	vfprintf(stderr, format, ap);
+	unlink(outfilename);
+	exit(1);
+	va_end(ap);
+}
+
+/*
+ * Evil macros to do a little-endian read.
+ */
+#define GLE(x, bits, ifnot)						\
+	__builtin_choose_expr(						\
+		(sizeof(x) == bits/8),					\
+		(__typeof__(x))le##bits##toh(x), ifnot)
+
+extern void bad_get_le(uint64_t);
+#define LAST_LE(x)							\
+	__builtin_choose_expr(sizeof(x) == 1, (x), bad_get_le(x))
+
+#define GET_LE(x)							\
+	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_LE(x))))
+
+#define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
+
+#define BITS 64
+#define GOFUNC go64
+#define Elf_Ehdr Elf64_Ehdr
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Phdr Elf64_Phdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Dyn Elf64_Dyn
+#include "vdso2c.h"
+#undef BITS
+#undef GOFUNC
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Phdr
+#undef Elf_Sym
+#undef Elf_Dyn
+
+#define BITS 32
+#define GOFUNC go32
+#define Elf_Ehdr Elf32_Ehdr
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Phdr Elf32_Phdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Dyn Elf32_Dyn
+#include "vdso2c.h"
+#undef BITS
+#undef GOFUNC
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Phdr
+#undef Elf_Sym
+#undef Elf_Dyn
+
+static void go(void *addr, size_t len, FILE *outfile, const char *name)
+{
+	Elf64_Ehdr *hdr = (Elf64_Ehdr *)addr;
+
+	if (hdr->e_ident[EI_CLASS] == ELFCLASS64) {
+		go64(addr, len, outfile, name);
+	} else if (hdr->e_ident[EI_CLASS] == ELFCLASS32) {
+		go32(addr, len, outfile, name);
+	} else {
+		fail("unknown ELF class\n");
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+	off_t len;
+	void *addr;
+	FILE *outfile;
+	char *name, *tmp;
+	int namelen;
+
+	if (argc != 3) {
+		printf("Usage: vdso2c INPUT OUTPUT\n");
+		return 1;
+	}
+
+	/*
+	 * Figure out the struct name.  If we're writing to a .so file,
+	 * generate raw output insted.
+	 */
+	name = strdup(argv[2]);
+	namelen = strlen(name);
+	if (namelen >= 3 && !strcmp(name + namelen - 3, ".so")) {
+		name = NULL;
+	} else {
+		tmp = strrchr(name, '/');
+		if (tmp)
+			name = tmp + 1;
+		tmp = strchr(name, '.');
+		if (tmp)
+			*tmp = '\0';
+		for (tmp = name; *tmp; tmp++)
+			if (*tmp == '-')
+				*tmp = '_';
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd == -1)
+		err(1, "%s", argv[1]);
+
+	len = lseek(fd, 0, SEEK_END);
+	if (len == (off_t)-1)
+		err(1, "lseek");
+
+	addr = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (addr == MAP_FAILED)
+		err(1, "mmap");
+
+	outfilename = argv[2];
+	outfile = fopen(outfilename, "w");
+	if (!outfile)
+		err(1, "%s", argv[2]);
+
+	go(addr, (size_t)len, outfile, name);
+
+	munmap(addr, len);
+	fclose(outfile);
+
+	return 0;
+}
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
new file mode 100644
index 0000000..d1e99e1
--- /dev/null
+++ b/arch/x86/vdso/vdso2c.h
@@ -0,0 +1,163 @@
+/*
+ * This file is included twice from vdso2c.c.  It generates code for 32-bit
+ * and 64-bit vDSOs.  We need both for 64-bit builds, since 32-bit vDSOs
+ * are built for 32-bit userspace.
+ */
+
+static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
+{
+	int found_load = 0;
+	unsigned long load_size = -1;  /* Work around bogus warning */
+	unsigned long data_size;
+	Elf_Ehdr *hdr = (Elf_Ehdr *)addr;
+	int i;
+	unsigned long j;
+	Elf_Shdr *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
+		*alt_sec = NULL;
+	Elf_Dyn *dyn = 0, *dyn_end = 0;
+	const char *secstrings;
+	uint64_t syms[NSYMS] = {};
+
+	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(hdr->e_phoff));
+
+	/* Walk the segment table. */
+	for (i = 0; i < GET_LE(hdr->e_phnum); i++) {
+		if (GET_LE(pt[i].p_type) == PT_LOAD) {
+			if (found_load)
+				fail("multiple PT_LOAD segs\n");
+
+			if (GET_LE(pt[i].p_offset) != 0 ||
+			    GET_LE(pt[i].p_vaddr) != 0)
+				fail("PT_LOAD in wrong place\n");
+
+			if (GET_LE(pt[i].p_memsz) != GET_LE(pt[i].p_filesz))
+				fail("cannot handle memsz != filesz\n");
+
+			load_size = GET_LE(pt[i].p_memsz);
+			found_load = 1;
+		} else if (GET_LE(pt[i].p_type) == PT_DYNAMIC) {
+			dyn = addr + GET_LE(pt[i].p_offset);
+			dyn_end = addr + GET_LE(pt[i].p_offset) +
+				GET_LE(pt[i].p_memsz);
+		}
+	}
+	if (!found_load)
+		fail("no PT_LOAD seg\n");
+	data_size = (load_size + 4095) / 4096 * 4096;
+
+	/* Walk the dynamic table */
+	for (i = 0; dyn + i < dyn_end &&
+		     GET_LE(dyn[i].d_tag) != DT_NULL; i++) {
+		typeof(dyn[i].d_tag) tag = GET_LE(dyn[i].d_tag);
+		if (tag == DT_REL || tag == DT_RELSZ ||
+		    tag == DT_RELENT || tag == DT_TEXTREL)
+			fail("vdso image contains dynamic relocations\n");
+	}
+
+	/* Walk the section table */
+	secstrings_hdr = addr + GET_LE(hdr->e_shoff) +
+		GET_LE(hdr->e_shentsize)*GET_LE(hdr->e_shstrndx);
+	secstrings = addr + GET_LE(secstrings_hdr->sh_offset);
+	for (i = 0; i < GET_LE(hdr->e_shnum); i++) {
+		Elf_Shdr *sh = addr + GET_LE(hdr->e_shoff) +
+			GET_LE(hdr->e_shentsize) * i;
+		if (GET_LE(sh->sh_type) == SHT_SYMTAB)
+			symtab_hdr = sh;
+
+		if (!strcmp(secstrings + GET_LE(sh->sh_name),
+			    ".altinstructions"))
+			alt_sec = sh;
+	}
+
+	if (!symtab_hdr)
+		fail("no symbol table\n");
+
+	strtab_hdr = addr + GET_LE(hdr->e_shoff) +
+		GET_LE(hdr->e_shentsize) * GET_LE(symtab_hdr->sh_link);
+
+	/* Walk the symbol table */
+	for (i = 0;
+	     i < GET_LE(symtab_hdr->sh_size) / GET_LE(symtab_hdr->sh_entsize);
+	     i++) {
+		int k;
+		Elf_Sym *sym = addr + GET_LE(symtab_hdr->sh_offset) +
+			GET_LE(symtab_hdr->sh_entsize) * i;
+		const char *name = addr + GET_LE(strtab_hdr->sh_offset) +
+			GET_LE(sym->st_name);
+		for (k = 0; k < NSYMS; k++) {
+			if (!strcmp(name, required_syms[k])) {
+				if (syms[k]) {
+					fail("duplicate symbol %s\n",
+					     required_syms[k]);
+				}
+				syms[k] = GET_LE(sym->st_value);
+			}
+		}
+	}
+
+	/* Validate mapping addresses. */
+	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
+		if (!syms[i])
+			continue;  /* The mapping isn't used; ignore it. */
+
+		if (syms[i] % 4096)
+			fail("%s must be a multiple of 4096\n",
+			     required_syms[i]);
+		if (syms[i] < data_size)
+			fail("%s must be after the text mapping\n",
+			     required_syms[i]);
+		if (syms[sym_end_mapping] < syms[i] + 4096)
+			fail("%s overruns end_mapping\n", required_syms[i]);
+	}
+	if (syms[sym_end_mapping] % 4096)
+		fail("end_mapping must be a multiple of 4096\n");
+
+	/* Remove sections. */
+	hdr->e_shoff = 0;
+	hdr->e_shentsize = 0;
+	hdr->e_shnum = 0;
+	hdr->e_shstrndx = htole16(SHN_UNDEF);
+
+	if (!name) {
+		fwrite(addr, load_size, 1, outfile);
+		return;
+	}
+
+	fprintf(outfile, "/* AUTOMATICALLY GENERATED -- DO NOT EDIT */\n\n");
+	fprintf(outfile, "#include <linux/linkage.h>\n");
+	fprintf(outfile, "#include <asm/page_types.h>\n");
+	fprintf(outfile, "#include <asm/vdso.h>\n");
+	fprintf(outfile, "\n");
+	fprintf(outfile,
+		"static unsigned char raw_data[%lu] __page_aligned_data = {",
+		data_size);
+	for (j = 0; j < load_size; j++) {
+		if (j % 10 == 0)
+			fprintf(outfile, "\n\t");
+		fprintf(outfile, "0x%02X, ", (int)((unsigned char *)addr)[j]);
+	}
+	fprintf(outfile, "\n};\n\n");
+
+	fprintf(outfile, "static struct page *pages[%lu];\n\n",
+		data_size / 4096);
+
+	fprintf(outfile, "const struct vdso_image %s = {\n", name);
+	fprintf(outfile, "\t.data = raw_data,\n");
+	fprintf(outfile, "\t.size = %lu,\n", data_size);
+	fprintf(outfile, "\t.text_mapping = {\n");
+	fprintf(outfile, "\t\t.name = \"[vdso]\",\n");
+	fprintf(outfile, "\t\t.pages = pages,\n");
+	fprintf(outfile, "\t},\n");
+	if (alt_sec) {
+		fprintf(outfile, "\t.alt = %lu,\n",
+			(unsigned long)GET_LE(alt_sec->sh_offset));
+		fprintf(outfile, "\t.alt_len = %lu,\n",
+			(unsigned long)GET_LE(alt_sec->sh_size));
+	}
+	for (i = 0; i < NSYMS; i++) {
+		if (syms[i])
+			fprintf(outfile, "\t.sym_%s = 0x%" PRIx64 ",\n",
+				required_syms[i], syms[i]);
+	}
+	fprintf(outfile, "};\n");
+}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 3adf2e6..e4f7781 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -8,27 +8,12 @@
 
 #include <linux/init.h>
 #include <linux/smp.h>
-#include <linux/thread_info.h>
-#include <linux/sched.h>
-#include <linux/gfp.h>
-#include <linux/string.h>
-#include <linux/elf.h>
-#include <linux/mm.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/mm_types.h>
 
 #include <asm/cpufeature.h>
-#include <asm/msr.h>
-#include <asm/pgtable.h>
-#include <asm/unistd.h>
-#include <asm/elf.h>
-#include <asm/tlbflush.h>
+#include <asm/processor.h>
 #include <asm/vdso.h>
-#include <asm/proto.h>
-#include <asm/fixmap.h>
-#include <asm/hpet.h>
-#include <asm/vvar.h>
 
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	0
@@ -36,22 +21,17 @@
 #define VDSO_DEFAULT	1
 #endif
 
-#ifdef CONFIG_X86_64
-#define vdso_enabled			sysctl_vsyscall32
-#define arch_setup_additional_pages	syscall32_setup_pages
-#endif
-
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;
+unsigned int __read_mostly vdso32_enabled = VDSO_DEFAULT;
 
-static int __init vdso_setup(char *s)
+static int __init vdso32_setup(char *s)
 {
-	vdso_enabled = simple_strtoul(s, NULL, 0);
+	vdso32_enabled = simple_strtoul(s, NULL, 0);
 
-	if (vdso_enabled > 1)
+	if (vdso32_enabled > 1)
 		pr_warn("vdso32 values other than 0 and 1 are no longer allowed; vdso disabled\n");
 
 	return 1;
@@ -62,178 +42,45 @@ static int __init vdso_setup(char *s)
  * behavior on both 64-bit and 32-bit kernels.
  * On 32-bit kernels, vdso=[012] means the same thing.
  */
-__setup("vdso32=", vdso_setup);
+__setup("vdso32=", vdso32_setup);
 
 #ifdef CONFIG_X86_32
-__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
-
-EXPORT_SYMBOL_GPL(vdso_enabled);
+__setup_param("vdso=", vdso_setup, vdso32_setup, 0);
 #endif
 
-static struct page **vdso32_pages;
-static unsigned vdso32_size;
-
 #ifdef CONFIG_X86_64
 
 #define	vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SYSENTER32))
 #define	vdso32_syscall()	(boot_cpu_has(X86_FEATURE_SYSCALL32))
 
-/* May not be __init: called during resume */
-void syscall32_cpu_init(void)
-{
-	/* Load these always in case some future AMD CPU supports
-	   SYSENTER from compat mode too. */
-	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
-	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
-	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
-
-	wrmsrl(MSR_CSTAR, ia32_cstar_target);
-}
-
 #else  /* CONFIG_X86_32 */
 
 #define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
 #define vdso32_syscall()	(0)
 
-void enable_sep_cpu(void)
-{
-	int cpu = get_cpu();
-	struct tss_struct *tss = &per_cpu(init_tss, cpu);
-
-	if (!boot_cpu_has(X86_FEATURE_SEP)) {
-		put_cpu();
-		return;
-	}
-
-	tss->x86_tss.ss1 = __KERNEL_CS;
-	tss->x86_tss.sp1 = sizeof(struct tss_struct) + (unsigned long) tss;
-	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
-	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.sp1, 0);
-	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) ia32_sysenter_target, 0);
-	put_cpu();	
-}
-
 #endif	/* CONFIG_X86_64 */
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+const struct vdso_image *selected_vdso32;
+#endif
+
 int __init sysenter_setup(void)
 {
-	char *vdso32_start, *vdso32_end;
-	int npages, i;
-
 #ifdef CONFIG_COMPAT
-	if (vdso32_syscall()) {
-		vdso32_start = vdso32_syscall_start;
-		vdso32_end = vdso32_syscall_end;
-		vdso32_pages = vdso32_syscall_pages;
-	} else
+	if (vdso32_syscall())
+		selected_vdso32 = &vdso_image_32_syscall;
+	else
 #endif
-	if (vdso32_sysenter()) {
-		vdso32_start = vdso32_sysenter_start;
-		vdso32_end = vdso32_sysenter_end;
-		vdso32_pages = vdso32_sysenter_pages;
-	} else {
-		vdso32_start = vdso32_int80_start;
-		vdso32_end = vdso32_int80_end;
-		vdso32_pages = vdso32_int80_pages;
-	}
-
-	npages = ((vdso32_end - vdso32_start) + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdso32_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdso32_pages[i] = virt_to_page(vdso32_start + i*PAGE_SIZE);
+	if (vdso32_sysenter())
+		selected_vdso32 = &vdso_image_32_sysenter;
+	else
+		selected_vdso32 = &vdso_image_32_int80;
 
-	patch_vdso32(vdso32_start, vdso32_size);
+	init_vdso_image(selected_vdso32);
 
 	return 0;
 }
 
-/* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long addr;
-	int ret = 0;
-	struct vm_area_struct *vma;
-	static struct page *no_pages[] = {NULL};
-
-#ifdef CONFIG_X86_X32_ABI
-	if (test_thread_flag(TIF_X32))
-		return x32_setup_additional_pages(bprm, uses_interp);
-#endif
-
-	if (vdso_enabled != 1)  /* Other values all mean "disabled" */
-		return 0;
-
-	down_write(&mm->mmap_sem);
-
-	addr = get_unmapped_area(NULL, 0, vdso32_size + VDSO_OFFSET(VDSO_PREV_PAGES), 0, 0);
-	if (IS_ERR_VALUE(addr)) {
-		ret = addr;
-		goto up_fail;
-	}
-
-	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
-
-	current->mm->context.vdso = (void *)addr;
-
-	/*
-	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 */
-	ret = install_special_mapping(mm,
-			addr,
-			vdso32_size,
-			VM_READ|VM_EXEC|
-			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-			vdso32_pages);
-
-	if (ret)
-		goto up_fail;
-
-	vma = _install_special_mapping(mm,
-			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
-			VDSO_OFFSET(VDSO_PREV_PAGES),
-			VM_READ,
-			no_pages);
-
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto up_fail;
-	}
-
-	ret = remap_pfn_range(vma,
-		addr - VDSO_OFFSET(VDSO_VVAR_PAGE),
-		__pa_symbol(&__vvar_page) >> PAGE_SHIFT,
-		PAGE_SIZE,
-		PAGE_READONLY);
-
-	if (ret)
-		goto up_fail;
-
-#ifdef CONFIG_HPET_TIMER
-	if (hpet_address) {
-		ret = io_remap_pfn_range(vma,
-			addr - VDSO_OFFSET(VDSO_HPET_PAGE),
-			hpet_address >> PAGE_SHIFT,
-			PAGE_SIZE,
-			pgprot_noncached(PAGE_READONLY));
-
-		if (ret)
-			goto up_fail;
-	}
-#endif
-
-	current_thread_info()->sysenter_return =
-		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
-
-  up_fail:
-	if (ret)
-		current->mm->context.vdso = NULL;
-
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
 #ifdef CONFIG_X86_64
 
 subsys_initcall(sysenter_setup);
@@ -245,7 +92,7 @@ subsys_initcall(sysenter_setup);
 static struct ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
-		.data		= &sysctl_vsyscall32,
+		.data		= &vdso32_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
@@ -272,13 +119,6 @@ __initcall(ia32_binfmt_init);
 
 #else  /* CONFIG_X86_32 */
 
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
-		return "[vdso]";
-	return NULL;
-}
-
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 	return NULL;
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
deleted file mode 100644
index 018bcd9..0000000
--- a/arch/x86/vdso/vdso32.S
+++ /dev/null
@@ -1,9 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdso32_int80, "arch/x86/vdso/vdso32-int80.so")
-
-#ifdef CONFIG_COMPAT
-DEFINE_VDSO_IMAGE(vdso32_syscall, "arch/x86/vdso/vdso32-syscall.so")
-#endif
-
-DEFINE_VDSO_IMAGE(vdso32_sysenter, "arch/x86/vdso/vdso32-sysenter.so")
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index aadb8b9..31056cf 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -1,17 +1,14 @@
 /*
  * Linker script for 32-bit vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
 #include <asm/page.h>
 
 #define BUILD_VDSO32
-#define VDSO_PRELINK 0
 
 #include "../vdso-layout.lds.S"
 
@@ -38,13 +35,3 @@ VERSION
 	local: *;
 	};
 }
-
-/*
- * Symbols we define here called VDSO* get their values into vdso32-syms.h.
- */
-VDSO32_vsyscall		= __kernel_vsyscall;
-VDSO32_sigreturn	= __kernel_sigreturn;
-VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
-VDSO32_clock_gettime	= clock_gettime;
-VDSO32_gettimeofday	= gettimeofday;
-VDSO32_time		= time;
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
deleted file mode 100644
index f4aa34e..0000000
--- a/arch/x86/vdso/vdsox32.S
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdsox32, "arch/x86/vdso/vdsox32.so")
diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
index 62272aa..46b991b 100644
--- a/arch/x86/vdso/vdsox32.lds.S
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -1,14 +1,11 @@
 /*
  * Linker script for x32 vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
-#define VDSO_PRELINK 0
 #include "vdso-layout.lds.S"
 
 /*
@@ -24,5 +21,3 @@ VERSION {
 	local: *;
 	};
 }
-
-VDSOX32_PRELINK = VDSO_PRELINK;
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 1ad1026..e1513c4 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -15,115 +15,51 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/page.h>
+#include <asm/hpet.h>
 
 #if defined(CONFIG_X86_64)
-unsigned int __read_mostly vdso_enabled = 1;
+unsigned int __read_mostly vdso64_enabled = 1;
 
-DECLARE_VDSO_IMAGE(vdso);
 extern unsigned short vdso_sync_cpuid;
-static unsigned vdso_size;
-
-#ifdef CONFIG_X86_X32_ABI
-DECLARE_VDSO_IMAGE(vdsox32);
-static unsigned vdsox32_size;
-#endif
 #endif
 
-#if defined(CONFIG_X86_32) || defined(CONFIG_X86_X32_ABI) || \
-	defined(CONFIG_COMPAT)
-void __init patch_vdso32(void *vdso, size_t len)
+void __init init_vdso_image(const struct vdso_image *image)
 {
-	Elf32_Ehdr *hdr = vdso;
-	Elf32_Shdr *sechdrs, *alt_sec = 0;
-	char *secstrings;
-	void *alt_data;
 	int i;
+	int npages = (image->size) / PAGE_SIZE;
 
-	BUG_ON(len < sizeof(Elf32_Ehdr));
-	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
-
-	sechdrs = (void *)hdr + hdr->e_shoff;
-	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		Elf32_Shdr *shdr = &sechdrs[i];
-		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
-			alt_sec = shdr;
-			goto found;
-		}
-	}
-
-	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso32: .altinstructions not found\n");
-	return;  /* nothing to patch */
+	BUG_ON(image->size % PAGE_SIZE != 0);
+	for (i = 0; i < npages; i++)
+		image->text_mapping.pages[i] =
+			virt_to_page(image->data + i*PAGE_SIZE);
 
-found:
-	alt_data = (void *)hdr + alt_sec->sh_offset;
-	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+	apply_alternatives((struct alt_instr *)(image->data + image->alt),
+			   (struct alt_instr *)(image->data + image->alt +
+						image->alt_len));
 }
-#endif
 
 #if defined(CONFIG_X86_64)
-static void __init patch_vdso64(void *vdso, size_t len)
-{
-	Elf64_Ehdr *hdr = vdso;
-	Elf64_Shdr *sechdrs, *alt_sec = 0;
-	char *secstrings;
-	void *alt_data;
-	int i;
-
-	BUG_ON(len < sizeof(Elf64_Ehdr));
-	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
-
-	sechdrs = (void *)hdr + hdr->e_shoff;
-	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		Elf64_Shdr *shdr = &sechdrs[i];
-		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
-			alt_sec = shdr;
-			goto found;
-		}
-	}
-
-	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso64: .altinstructions not found\n");
-	return;  /* nothing to patch */
-
-found:
-	alt_data = (void *)hdr + alt_sec->sh_offset;
-	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
-}
-
 static int __init init_vdso(void)
 {
-	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
-	int i;
-
-	patch_vdso64(vdso_start, vdso_end - vdso_start);
-
-	vdso_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
+	init_vdso_image(&vdso_image_64);
 
 #ifdef CONFIG_X86_X32_ABI
-	patch_vdso32(vdsox32_start, vdsox32_end - vdsox32_start);
-	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdsox32_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdsox32_pages[i] = virt_to_page(vdsox32_start + i*PAGE_SIZE);
+	init_vdso_image(&vdso_image_x32);
 #endif
 
 	return 0;
 }
 subsys_initcall(init_vdso);
+#endif
 
 struct linux_binprm;
 
 /* Put the vdso above the (randomized) stack with another randomized offset.
    This way there is no hole in the middle of address space.
    To save memory make sure it is still in the same PTE as the stack top.
-   This doesn't give that many random bits */
+   This doesn't give that many random bits.
+
+   Only used for the 64-bit and x32 vdsos. */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
 	unsigned long addr, end;
@@ -149,61 +85,149 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	return addr;
 }
 
-/* Setup a VMA at program startup for the vsyscall page.
-   Not called for compat tasks */
-static int setup_additional_pages(struct linux_binprm *bprm,
-				  int uses_interp,
-				  struct page **pages,
-				  unsigned size)
+static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
 	unsigned long addr;
-	int ret;
-
-	if (!vdso_enabled)
-		return 0;
+	int ret = 0;
+	static struct page *no_pages[] = {NULL};
+	static struct vm_special_mapping vvar_mapping = {
+		.name = "[vvar]",
+		.pages = no_pages,
+	};
+
+	if (calculate_addr) {
+		addr = vdso_addr(current->mm->start_stack,
+				 image->sym_end_mapping);
+	} else {
+		addr = 0;
+	}
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, size);
-	addr = get_unmapped_area(NULL, addr, size, 0, 0);
+
+	addr = get_unmapped_area(NULL, addr, image->sym_end_mapping, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
-	current->mm->context.vdso = (void *)addr;
+	current->mm->context.vdso = (void __user *)addr;
 
-	ret = install_special_mapping(mm, addr, size,
-				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				      pages);
-	if (ret) {
-		current->mm->context.vdso = NULL;
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 */
+	vma = _install_special_mapping(mm,
+				       addr,
+				       image->size,
+				       VM_READ|VM_EXEC|
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				       &image->text_mapping);
+
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
 		goto up_fail;
 	}
 
+	vma = _install_special_mapping(mm,
+				       addr + image->size,
+				       image->sym_end_mapping - image->size,
+				       VM_READ,
+				       &vvar_mapping);
+
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
+		goto up_fail;
+	}
+
+	if (image->sym_vvar_page)
+		ret = remap_pfn_range(vma,
+				      addr + image->sym_vvar_page,
+				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
+				      PAGE_SIZE,
+				      PAGE_READONLY);
+
+	if (ret)
+		goto up_fail;
+
+#ifdef CONFIG_HPET_TIMER
+	if (hpet_address && image->sym_hpet_page) {
+		ret = io_remap_pfn_range(vma,
+			addr + image->sym_hpet_page,
+			hpet_address >> PAGE_SHIFT,
+			PAGE_SIZE,
+			pgprot_noncached(PAGE_READONLY));
+
+		if (ret)
+			goto up_fail;
+	}
+#endif
+
 up_fail:
+	if (ret)
+		current->mm->context.vdso = NULL;
+
 	up_write(&mm->mmap_sem);
 	return ret;
 }
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+static int load_vdso32(void)
+{
+	int ret;
+
+	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
+		return 0;
+
+	ret = map_vdso(selected_vdso32, false);
+	if (ret)
+		return ret;
+
+	if (selected_vdso32->sym_VDSO32_SYSENTER_RETURN)
+		current_thread_info()->sysenter_return =
+			current->mm->context.vdso +
+			selected_vdso32->sym_VDSO32_SYSENTER_RETURN;
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_X86_64
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdso_pages,
-				      vdso_size);
+	if (!vdso64_enabled)
+		return 0;
+
+	return map_vdso(&vdso_image_64, true);
 }
 
+#ifdef CONFIG_COMPAT
+int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
+				       int uses_interp)
+{
 #ifdef CONFIG_X86_X32_ABI
-int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+	if (test_thread_flag(TIF_X32)) {
+		if (!vdso64_enabled)
+			return 0;
+
+		return map_vdso(&vdso_image_x32, true);
+	}
+#endif
+
+	return load_vdso32();
+}
+#endif
+#else
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdsox32_pages,
-				      vdsox32_size);
+	return load_vdso32();
 }
 #endif
 
+#ifdef CONFIG_X86_64
 static __init int vdso_setup(char *s)
 {
-	vdso_enabled = simple_strtoul(s, NULL, 0);
+	vdso64_enabled = simple_strtoul(s, NULL, 0);
 	return 0;
 }
 __setup("vdso=", vdso_setup);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 86e02ea..3060568 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1494,7 +1494,7 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 		page->private = (unsigned long)user_pgd;
 
 		if (user_pgd != NULL) {
-			user_pgd[pgd_index(VSYSCALL_START)] =
+			user_pgd[pgd_index(VSYSCALL_ADDR)] =
 				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
 			ret = 0;
 		}
@@ -2062,8 +2062,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
 #else
-	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
-	case VVAR_PAGE:
+	case VSYSCALL_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -2104,8 +2103,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
-	    idx == VVAR_PAGE) {
+	if (idx == VSYSCALL_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 0982233..7225a95 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -516,10 +516,17 @@ char * __init xen_memory_setup(void)
 static void __init fiddle_vdso(void)
 {
 #ifdef CONFIG_X86_32
+	/*
+	 * This could be called before selected_vdso32 is initialized, so
+	 * just fiddle with both possible images.  vdso_image_32_syscall
+	 * can't be selected, since it only exists on 64-bit systems.
+	 */
 	u32 *mask;
-	mask = VDSO32_SYMBOL(&vdso32_int80_start, NOTE_MASK);
+	mask = vdso_image_32_int80.data +
+		vdso_image_32_int80.sym_VDSO32_NOTE_MASK;
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
-	mask = VDSO32_SYMBOL(&vdso32_sysenter_start, NOTE_MASK);
+	mask = vdso_image_32_sysenter.data +
+		vdso_image_32_sysenter.sym_VDSO32_NOTE_MASK;
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 #endif
 }
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aa3cb62..df9ea41 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1108,6 +1108,14 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 	/* Any vsyscall mappings? */
 	if (vma == get_gate_vma(vma->vm_mm))
 		return true;
+
+	/*
+	 * Assume that all vmas with a .name op should always be dumped.
+	 * If this changes, a new vm_ops field can easily be added.
+	 */
+	if (vma->vm_ops && vma->vm_ops->name && vma->vm_ops->name(vma))
+		return true;
+
 	/*
 	 * arch_vma_name() returns non-NULL for special architecture mappings,
 	 * such as vDSO sections.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..9b2f5d6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -300,6 +300,12 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 		goto done;
 	}
 
+	if (vma->vm_ops && vma->vm_ops->name) {
+		name = vma->vm_ops->name(vma);
+		if (name)
+			goto done;
+	}
+
 	name = arch_vma_name(vma);
 	if (!name) {
 		pid_t tid;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d677706..fb27946 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -239,6 +239,12 @@ struct vm_operations_struct {
 	 */
 	int (*access)(struct vm_area_struct *vma, unsigned long addr,
 		      void *buf, int len, int write);
+
+	/* Called by the /proc/PID/maps code to ask the vma whether it
+	 * has a special name.  Returning non-NULL will also cause this
+	 * vma to be dumped unconditionally. */
+	const char *(*name)(struct vm_area_struct *vma);
+
 #ifdef CONFIG_NUMA
 	/*
 	 * set_policy() op must add a reference to any non-NULL @new mempolicy
@@ -1778,7 +1784,9 @@ extern struct file *get_mm_exe_file(struct mm_struct *mm);
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
-				   unsigned long flags, struct page **pages);
+				   unsigned long flags,
+				   const struct vm_special_mapping *spec);
+/* This is an obsolete alternative to _install_special_mapping. */
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8967e20..22c6f4e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -510,4 +510,10 @@ static inline void clear_tlb_flush_pending(struct mm_struct *mm)
 }
 #endif
 
+struct vm_special_mapping
+{
+	const char *name;
+	struct page **pages;
+};
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b58..420d77a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1418,8 +1418,13 @@ static struct ctl_table vm_table[] = {
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
 		.procname	= "vdso_enabled",
+#ifdef CONFIG_X86_32
+		.data		= &vdso32_enabled,
+		.maxlen		= sizeof(vdso32_enabled),
+#else
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
+#endif
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
diff --git a/mm/mmap.c b/mm/mmap.c
index b1202cf..52bbc95 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2872,6 +2872,31 @@ int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 	return 1;
 }
 
+static int special_mapping_fault(struct vm_area_struct *vma,
+				 struct vm_fault *vmf);
+
+/*
+ * Having a close hook prevents vma merging regardless of flags.
+ */
+static void special_mapping_close(struct vm_area_struct *vma)
+{
+}
+
+static const char *special_mapping_name(struct vm_area_struct *vma)
+{
+	return ((struct vm_special_mapping *)vma->vm_private_data)->name;
+}
+
+static const struct vm_operations_struct special_mapping_vmops = {
+	.close = special_mapping_close,
+	.fault = special_mapping_fault,
+	.name = special_mapping_name,
+};
+
+static const struct vm_operations_struct legacy_special_mapping_vmops = {
+	.close = special_mapping_close,
+	.fault = special_mapping_fault,
+};
 
 static int special_mapping_fault(struct vm_area_struct *vma,
 				struct vm_fault *vmf)
@@ -2887,7 +2912,13 @@ static int special_mapping_fault(struct vm_area_struct *vma,
 	 */
 	pgoff = vmf->pgoff - vma->vm_pgoff;
 
-	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
+	if (vma->vm_ops == &legacy_special_mapping_vmops)
+		pages = vma->vm_private_data;
+	else
+		pages = ((struct vm_special_mapping *)vma->vm_private_data)->
+			pages;
+
+	for (; pgoff && *pages; ++pages)
 		pgoff--;
 
 	if (*pages) {
@@ -2900,30 +2931,11 @@ static int special_mapping_fault(struct vm_area_struct *vma,
 	return VM_FAULT_SIGBUS;
 }
 
-/*
- * Having a close hook prevents vma merging regardless of flags.
- */
-static void special_mapping_close(struct vm_area_struct *vma)
-{
-}
-
-static const struct vm_operations_struct special_mapping_vmops = {
-	.close = special_mapping_close,
-	.fault = special_mapping_fault,
-};
-
-/*
- * Called with mm->mmap_sem held for writing.
- * Insert a new vma covering the given region, with the given flags.
- * Its pages are supplied by the given array of struct page *.
- * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
- * The region past the last page supplied will always produce SIGBUS.
- * The array pointer and the pages it points to are assumed to stay alive
- * for as long as this mapping might exist.
- */
-struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
-			    unsigned long addr, unsigned long len,
-			    unsigned long vm_flags, struct page **pages)
+static struct vm_area_struct *__install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	unsigned long vm_flags, const struct vm_operations_struct *ops,
+	void *priv)
 {
 	int ret;
 	struct vm_area_struct *vma;
@@ -2940,8 +2952,8 @@ struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	vma->vm_ops = &special_mapping_vmops;
-	vma->vm_private_data = pages;
+	vma->vm_ops = ops;
+	vma->vm_private_data = priv;
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
@@ -2958,12 +2970,31 @@ out:
 	return ERR_PTR(ret);
 }
 
+/*
+ * Called with mm->mmap_sem held for writing.
+ * Insert a new vma covering the given region, with the given flags.
+ * Its pages are supplied by the given array of struct page *.
+ * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
+ * The region past the last page supplied will always produce SIGBUS.
+ * The array pointer and the pages it points to are assumed to stay alive
+ * for as long as this mapping might exist.
+ */
+struct vm_area_struct *_install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	unsigned long vm_flags, const struct vm_special_mapping *spec)
+{
+	return __install_special_mapping(mm, addr, len, vm_flags,
+					 &special_mapping_vmops, (void *)spec);
+}
+
 int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
-	struct vm_area_struct *vma = _install_special_mapping(mm,
-			    addr, len, vm_flags, pages);
+	struct vm_area_struct *vma = __install_special_mapping(
+		mm, addr, len, vm_flags, &legacy_special_mapping_vmops,
+		(void *)pages);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
