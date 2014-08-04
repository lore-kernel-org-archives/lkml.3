Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaHDMPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:15:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59488 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHDMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:15:42 -0400
Date: Mon, 4 Aug 2014 14:15:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] EFI changes for v3.17
Message-ID: <20140804121530.GA26510@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   # HEAD: 99a5603e2a1f146ac0c6414d8a3669aa749ccff8 efi/arm64: Handle missing virtual mapping for UEFI System Table

Main changes in this cycle are:

  * arm64 efi stub fixes, preservation of FP/SIMD registers across
    firmware calls, and conversion of the EFI stub code into a static
    library - Ard Biesheuvel

  * Xen EFI support - Daniel Kiper

  * Support for autoloading the efivars driver - Lee, Chun-Yi

  * Use the PE/COFF headers in the x86 EFI boot stub to request that 
    the stub be loaded with CONFIG_PHYSICAL_ALIGN alignment - Michael Brown

  * Consolidate all the x86 EFI quirks into one file - Saurabh Tangri

  * Additional error logging in x86 EFI boot stub - Ulf Winkelvos

  * Support loading initrd above 4G in EFI boot stub - Yinghai Lu

  * EFI reboot patches for ACPI hardware reduced platforms


  out-of-topic modifications in x86-efi-for-linus:
  --------------------------------------------------
  arch/arm64/Kconfig                 # f4f75ad: efi: efistub: Convert into static
                                   # e15dd49: efi/arm64: Preserve FP/SIMD regis
  arch/arm64/Makefile                # f4f75ad: efi: efistub: Convert into static
  arch/arm64/include/asm/efi.h       # a13b007: efi/arm64: efistub: Move shared d
                                   # e15dd49: efi/arm64: Preserve FP/SIMD regis
  arch/arm64/kernel/Makefile         # f4f75ad: efi: efistub: Convert into static
  arch/arm64/kernel/efi-stub.c       # f4f75ad: efi: efistub: Convert into static
                                   # bd66947: efi: efistub: Refactor stub compo
                                   # a13b007: efi/arm64: efistub: Move shared d
                                   # 6091c9c: efi/arm64: Avoid EFI_ERROR as a g
                                   # f49182ec: efi/arm64: efistub: remove local
  arch/arm64/kernel/efi.c            # 99a5603: efi/arm64: Handle missing virtual
                                   # e15dd49: efi/arm64: Preserve FP/SIMD regis
  arch/ia64/include/asm/io.h         # 4fa6248: arch/ia64: Define early_memunmap(
  arch/ia64/kernel/process.c         # 8562c99: efi/reboot: Add generic wrapper a
  drivers/firmware/efi/Kconfig       # f4f75ad: efi: efistub: Convert into static
                                   # 022ee6c: efi/x86: Move UEFI Runtime Servic
  drivers/firmware/efi/Makefile      # 8562c99: efi/reboot: Add generic wrapper a
                                   # f4f75ad: efi: efistub: Convert into static
                                   # 022ee6c: efi/x86: Move UEFI Runtime Servic
  drivers/firmware/efi/arm-stub.c    # f4f75ad: efi: efistub: Convert into static
                                   # bd66947: efi: efistub: Refactor stub compo
  drivers/firmware/efi/efi-stub-helper.c# f4f75ad: efi: efistub: Convert into static
                                   # bd66947: efi: efistub: Refactor stub compo
  drivers/firmware/efi/efi.c         # 28d5402: efi: Autoload efivars
                                   # 9f27bc5: efi: Introduce EFI_PARAVIRT flag
                                   # abc93f8: efi: Use early_mem*() instead of 
  drivers/firmware/efi/efivars.c     # 28d5402: efi: Autoload efivars
  drivers/firmware/efi/fdt.c         # f4f75ad: efi: efistub: Convert into static
                                   # bd66947: efi: efistub: Refactor stub compo
                                   # f49182ec: efi/arm64: efistub: remove local
  drivers/firmware/efi/libstub/Makefile# f4f75ad: efi: efistub: Convert into static
  drivers/firmware/efi/libstub/arm-stub.c# f4f75ad: efi: efistub: Convert into static
  drivers/firmware/efi/libstub/efi-stub-helper.c# f4f75ad: efi: efistub: Convert into static
  drivers/firmware/efi/libstub/efistub.h# f4f75ad: efi: efistub: Convert into static
  drivers/firmware/efi/libstub/fdt.c # f4f75ad: efi: efistub: Convert into static
  drivers/firmware/efi/reboot.c      # 44be28e: x86/reboot: Add EFI reboot quirk 
                                   # 0c5ed61: efi/reboot: Allow powering off ma
                                   # 8562c99: efi/reboot: Add generic wrapper a
  drivers/firmware/efi/runtime-wrappers.c# 022ee6c: efi/x86: Move UEFI Runtime Servic

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (9):
      efi/arm64: efistub: remove local copy of linux_banner
      efi/x86: Move UEFI Runtime Services wrappers to generic code
      efi/arm64: Preserve FP/SIMD registers on UEFI runtime services calls
      efi/arm64: Avoid EFI_ERROR as a generic return code
      efi/x86: efistub: Move shared dependencies to <asm/efi.h>
      efi/arm64: efistub: Move shared dependencies to <asm/efi.h>
      efi: efistub: Refactor stub components
      efi: efistub: Convert into static library
      efi/arm64: Handle missing virtual mapping for UEFI System Table

Daniel Kiper (12):
      arch/ia64: Define early_memunmap()
      efi: Use early_mem*() instead of early_io*()
      arch/x86: Do not access EFI memory map if it is not available
      efi: Introduce EFI_PARAVIRT flag
      arch/x86: Remove redundant set_bit(EFI_SYSTEM_TABLES) call
      arch/x86: Remove redundant set_bit(EFI_MEMMAP) call
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove efi_set_rtc_mmss()
      xen: Silence compiler warnings
      arch/x86/xen: Silence compiler warnings

Lee, Chun-Yi (1):
      efi: Autoload efivars

Matt Fleming (5):
      x86/efi: Use early_memunmap() to squelch sparse errors
      efi/reboot: Add generic wrapper around EfiResetSystem()
      efi/reboot: Allow powering off machines using EFI
      x86/reboot: Add EFI reboot quirk for ACPI Hardware Reduced flag
      efi: Update stale locking comment for struct efivars

Michael Brown (1):
      x86/efi: Request desired alignment via the PE/COFF headers

Saurabh Tangri (1):
      x86/efi: Move all workarounds to a separate file quirks.c

Ulf Winkelvos (1):
      x86/efi: Add better error logging to EFI boot stub

Yinghai Lu (1):
      x86/efi: Support initrd loaded above 4G


 arch/arm64/Kconfig                                 |   6 +
 arch/arm64/Makefile                                |   1 +
 arch/arm64/include/asm/efi.h                       |  33 ++
 arch/arm64/kernel/Makefile                         |   3 +-
 arch/arm64/kernel/efi-stub.c                       |  50 +--
 arch/arm64/kernel/efi.c                            |  42 +-
 arch/ia64/include/asm/io.h                         |   1 +
 arch/ia64/kernel/process.c                         |   2 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/boot/compressed/Makefile                  |   3 +-
 arch/x86/boot/compressed/eboot.c                   |  48 +-
 arch/x86/boot/compressed/eboot.h                   |  16 -
 arch/x86/boot/header.S                             |   2 +-
 arch/x86/include/asm/efi.h                         |  33 ++
 arch/x86/kernel/reboot.c                           |  24 +-
 arch/x86/kernel/setup.c                            |   4 +-
 arch/x86/platform/efi/Makefile                     |   2 +-
 arch/x86/platform/efi/efi.c                        | 483 ++-------------------
 arch/x86/platform/efi/quirks.c                     | 290 +++++++++++++
 arch/x86/xen/Makefile                              |   1 +
 arch/x86/xen/efi.c                                 |  43 ++
 arch/x86/xen/enlighten.c                           |   2 +
 arch/x86/xen/xen-ops.h                             |   8 +
 drivers/firmware/efi/Kconfig                       |   6 +
 drivers/firmware/efi/Makefile                      |   4 +-
 drivers/firmware/efi/efi.c                         |  40 +-
 drivers/firmware/efi/efivars.c                     |   1 +
 drivers/firmware/efi/libstub/Makefile              |  26 ++
 drivers/firmware/efi/{ => libstub}/arm-stub.c      |  32 +-
 .../firmware/efi/{ => libstub}/efi-stub-helper.c   |  74 ++--
 drivers/firmware/efi/libstub/efistub.h             |  42 ++
 drivers/firmware/efi/{ => libstub}/fdt.c           |  30 +-
 drivers/firmware/efi/reboot.c                      |  56 +++
 drivers/firmware/efi/runtime-wrappers.c            | 161 +++++++
 drivers/xen/Kconfig                                |   4 +
 drivers/xen/Makefile                               |   3 +
 drivers/xen/efi.c                                  | 368 ++++++++++++++++
 include/linux/efi.h                                |  63 ++-
 include/xen/interface/platform.h                   | 123 ++++++
 include/xen/xen-ops.h                              |  11 +
 40 files changed, 1508 insertions(+), 634 deletions(-)
 create mode 100644 arch/x86/platform/efi/quirks.c
 create mode 100644 arch/x86/xen/efi.c
 create mode 100644 drivers/firmware/efi/libstub/Makefile
 rename drivers/firmware/efi/{ => libstub}/arm-stub.c (93%)
 rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (88%)
 create mode 100644 drivers/firmware/efi/libstub/efistub.h
 rename drivers/firmware/efi/{ => libstub}/fdt.c (90%)
 create mode 100644 drivers/firmware/efi/reboot.c
 create mode 100644 drivers/firmware/efi/runtime-wrappers.c
 create mode 100644 drivers/xen/efi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7295419..3a0a4ce 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -292,12 +292,18 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI_STUB
+	bool
+
 config EFI
 	bool "UEFI runtime support"
 	depends on OF && !CPU_BIG_ENDIAN
 	select LIBFDT
 	select UCS2_STRING
 	select EFI_PARAMS_FROM_FDT
+	select EFI_RUNTIME_WRAPPERS
+	select EFI_STUB
+	select EFI_ARMSTUB
 	default y
 	help
 	  This option provides support for runtime services provided
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 8185a91..5836717 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,6 +48,7 @@ core-$(CONFIG_XEN) += arch/arm64/xen/
 core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
+libs-$(CONFIG_EFI_STUB) += drivers/firmware/efi/libstub/
 
 # Default target when executing plain make
 KBUILD_IMAGE	:= Image.gz
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 5a46c4e..a34fd3b 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -2,6 +2,7 @@
 #define _ASM_EFI_H
 
 #include <asm/io.h>
+#include <asm/neon.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -11,4 +12,36 @@ extern void efi_idmap_init(void);
 #define efi_idmap_init()
 #endif
 
+#define efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f = efi.systab->runtime->f;			\
+	efi_status_t __s;						\
+									\
+	kernel_neon_begin();						\
+	__s = __f(__VA_ARGS__);						\
+	kernel_neon_end();						\
+	__s;								\
+})
+
+#define __efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f = efi.systab->runtime->f;			\
+									\
+	kernel_neon_begin();						\
+	__f(__VA_ARGS__);						\
+	kernel_neon_end();						\
+})
+
+/* arch specific definitions used by the stub code */
+
+/*
+ * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
+ * start of kernel and may not cross a 2MiB boundary. We set alignment to
+ * 2MiB so we know it won't cross a 2MiB boundary.
+ */
+#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
+#define MAX_FDT_OFFSET	SZ_512M
+
+#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad..afaeb73 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,8 +4,7 @@
 
 CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
-CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
-			   -I$(src)/../../../scripts/dtc/libfdt
+CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_insn.o = -pg
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 60e98a63..1317fef 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -10,48 +10,16 @@
  *
  */
 #include <linux/efi.h>
-#include <linux/libfdt.h>
+#include <asm/efi.h>
 #include <asm/sections.h>
-#include <generated/compile.h>
-#include <generated/utsrelease.h>
 
-/*
- * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
- * start of kernel and may not cross a 2MiB boundary. We set alignment to
- * 2MiB so we know it won't cross a 2MiB boundary.
- */
-#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
-#define MAX_FDT_OFFSET	SZ_512M
-
-#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
-
-static void efi_char16_printk(efi_system_table_t *sys_table_arg,
-			      efi_char16_t *str);
-
-static efi_status_t efi_open_volume(efi_system_table_t *sys_table,
-				    void *__image, void **__fh);
-static efi_status_t efi_file_close(void *handle);
-
-static efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr);
-
-static efi_status_t
-efi_file_size(efi_system_table_t *sys_table, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz);
-
-/* Include shared EFI stub code */
-#include "../../../drivers/firmware/efi/efi-stub-helper.c"
-#include "../../../drivers/firmware/efi/fdt.c"
-#include "../../../drivers/firmware/efi/arm-stub.c"
-
-
-static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
-					unsigned long *image_addr,
-					unsigned long *image_size,
-					unsigned long *reserve_addr,
-					unsigned long *reserve_size,
-					unsigned long dram_base,
-					efi_loaded_image_t *image)
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
@@ -71,7 +39,7 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 		if (*image_addr != (dram_base + TEXT_OFFSET)) {
 			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
 			efi_free(sys_table, kernel_memsize, *image_addr);
-			return EFI_ERROR;
+			return EFI_LOAD_ERROR;
 		}
 		*image_size = kernel_memsize;
 	}
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 14db1f6..e72f310 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -414,13 +414,24 @@ static int __init arm64_enter_virtual_mode(void)
 	for_each_efi_memory_desc(&memmap, md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
-		if (remap_region(md, &virt_md))
-			++count;
+		if (!remap_region(md, &virt_md))
+			goto err_unmap;
+		++count;
 	}
 
 	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
-	if (efi.systab)
-		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+	if (!efi.systab) {
+		/*
+		 * If we have no virtual mapping for the System Table at this
+		 * point, the memory map doesn't cover the physical offset where
+		 * it resides. This means the System Table will be inaccessible
+		 * to Runtime Services themselves once the virtual mapping is
+		 * installed.
+		 */
+		pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
+		goto err_unmap;
+	}
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
 	local_irq_save(flags);
 	cpu_switch_mm(idmap_pg_dir, &init_mm);
@@ -449,21 +460,18 @@ static int __init arm64_enter_virtual_mode(void)
 
 	/* Set up runtime services function pointers */
 	runtime = efi.systab->runtime;
-	efi.get_time = runtime->get_time;
-	efi.set_time = runtime->set_time;
-	efi.get_wakeup_time = runtime->get_wakeup_time;
-	efi.set_wakeup_time = runtime->set_wakeup_time;
-	efi.get_variable = runtime->get_variable;
-	efi.get_next_variable = runtime->get_next_variable;
-	efi.set_variable = runtime->set_variable;
-	efi.query_variable_info = runtime->query_variable_info;
-	efi.update_capsule = runtime->update_capsule;
-	efi.query_capsule_caps = runtime->query_capsule_caps;
-	efi.get_next_high_mono_count = runtime->get_next_high_mono_count;
-	efi.reset_system = runtime->reset_system;
-
+	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	return 0;
+
+err_unmap:
+	/* unmap all mappings that succeeded: there are 'count' of those */
+	for (virt_md = virtmap; count--; virt_md += memmap.desc_size) {
+		md = virt_md;
+		iounmap((__force void __iomem *)md->virt_addr);
+	}
+	kfree(virtmap);
+	return -1;
 }
 early_initcall(arm64_enter_virtual_mode);
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 0d2bcb3..bee0acd 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -426,6 +426,7 @@ extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
 #define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
+#define early_memunmap(addr, size)             early_iounmap(addr, size)
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
 	return ioremap(phys_addr, size);
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 55d4ba4..deed6fa 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -662,7 +662,7 @@ void
 machine_restart (char *restart_cmd)
 {
 	(void) notify_die(DIE_MACHINE_RESTART, restart_cmd, NULL, 0, 0, 0);
-	(*efi.reset_system)(EFI_RESET_WARM, 0, 0, NULL);
+	efi_reboot(REBOOT_WARM, NULL);
 }
 
 void
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fcefdda..801ed36 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1522,6 +1522,7 @@ config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
 	select UCS2_STRING
+	select EFI_RUNTIME_WRAPPERS
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0fcd913..7a801a3 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -33,7 +33,8 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
+	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
+				$(objtree)/drivers/firmware/efi/libstub/lib.a
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 0331d76..f277184 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,10 +19,7 @@
 
 static efi_system_table_t *sys_table;
 
-static struct efi_config *efi_early;
-
-#define efi_call_early(f, ...)						\
-	efi_early->call(efi_early->f, __VA_ARGS__);
+struct efi_config *efi_early;
 
 #define BOOT_SERVICES(bits)						\
 static void setup_boot_services##bits(struct efi_config *c)		\
@@ -48,8 +45,7 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
 
-static void efi_printk(efi_system_table_t *, char *);
-static void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 static efi_status_t
 __file_size32(void *__fh, efi_char16_t *filename_16,
@@ -156,7 +152,7 @@ grow:
 
 	return status;
 }
-static efi_status_t
+efi_status_t
 efi_file_size(efi_system_table_t *sys_table, void *__fh,
 	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
 {
@@ -166,7 +162,7 @@ efi_file_size(efi_system_table_t *sys_table, void *__fh,
 	return __file_size32(__fh, filename_16, handle, file_sz);
 }
 
-static inline efi_status_t
+efi_status_t
 efi_file_read(void *handle, unsigned long *size, void *addr)
 {
 	unsigned long func;
@@ -184,7 +180,7 @@ efi_file_read(void *handle, unsigned long *size, void *addr)
 	}
 }
 
-static inline efi_status_t efi_file_close(void *handle)
+efi_status_t efi_file_close(void *handle)
 {
 	if (efi_early->is64) {
 		efi_file_handle_64_t *fh = handle;
@@ -249,7 +245,7 @@ static inline efi_status_t __open_volume64(void *__image, void **__fh)
 	return status;
 }
 
-static inline efi_status_t
+efi_status_t
 efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 {
 	if (efi_early->is64)
@@ -258,7 +254,7 @@ efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 	return __open_volume32(__image, __fh);
 }
 
-static void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
 	unsigned long output_string;
 	size_t offset;
@@ -284,8 +280,6 @@ static void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 	}
 }
 
-#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
-
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
 	u8 first, len;
@@ -1038,6 +1032,7 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	int i;
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
+	unsigned long initrd_addr_max;
 
 	efi_early = c;
 	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
@@ -1100,14 +1095,21 @@ struct boot_params *make_boot_params(struct efi_config *c)
 
 	memset(sdt, 0, sizeof(*sdt));
 
+	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
+		initrd_addr_max = -1UL;
+	else
+		initrd_addr_max = hdr->initrd_addr_max;
+
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
-				      "initrd=", hdr->initrd_addr_max,
+				      "initrd=", initrd_addr_max,
 				      &ramdisk_addr, &ramdisk_size);
 	if (status != EFI_SUCCESS)
 		goto fail2;
-	hdr->ramdisk_image = ramdisk_addr;
-	hdr->ramdisk_size = ramdisk_size;
+	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
+	hdr->ramdisk_size  = ramdisk_size & 0xffffffff;
+	boot_params->ext_ramdisk_image = (u64)ramdisk_addr >> 32;
+	boot_params->ext_ramdisk_size  = (u64)ramdisk_size >> 32;
 
 	return boot_params;
 fail2:
@@ -1374,7 +1376,10 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_graphics(boot_params);
 
-	setup_efi_pci(boot_params);
+	status = setup_efi_pci(boot_params);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "setup_efi_pci() failed!\n");
+	}
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
@@ -1401,16 +1406,20 @@ struct boot_params *efi_main(struct efi_config *c,
 					     hdr->init_size, hdr->init_size,
 					     hdr->pref_address,
 					     hdr->kernel_alignment);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, "efi_relocate_kernel() failed!\n");
 			goto fail;
+		}
 
 		hdr->pref_address = hdr->code32_start;
 		hdr->code32_start = bzimage_addr;
 	}
 
 	status = exit_boot(boot_params, handle, is64);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "exit_boot() failed!\n");
 		goto fail;
+	}
 
 	memset((char *)gdt->address, 0x0, gdt->size);
 	desc = (struct desc_struct *)gdt->address;
@@ -1470,5 +1479,6 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	return boot_params;
 fail:
+	efi_printk(sys_table, "efi_main() failed!\n");
 	return NULL;
 }
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index c88c31e..d487e72 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -103,20 +103,4 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
-struct efi_config {
-	u64 image_handle;
-	u64 table;
-	u64 allocate_pool;
-	u64 allocate_pages;
-	u64 get_memory_map;
-	u64 free_pool;
-	u64 free_pages;
-	u64 locate_handle;
-	u64 handle_protocol;
-	u64 exit_boot_services;
-	u64 text_output;
-	efi_status_t (*call)(unsigned long, ...);
-	bool is64;
-} __packed;
-
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 84c2234..1fdb350 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -155,7 +155,7 @@ extra_header_fields:
 #else
 	.quad	0				# ImageBase
 #endif
-	.long	0x20				# SectionAlignment
+	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
 	.long	0x20				# FileAlignment
 	.word	0				# MajorOperatingSystemVersion
 	.word	0				# MinorOperatingSystemVersion
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 1eb5f64..044a2fd 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -104,6 +104,8 @@ extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
 extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
+extern int __init efi_reuse_config(u64 tables, int nr_tables);
+extern void efi_delete_dummy_variable(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
@@ -156,6 +158,33 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 	return EFI_SUCCESS;
 }
 #endif /* CONFIG_EFI_MIXED */
+
+
+/* arch specific definitions used by the stub code */
+
+struct efi_config {
+	u64 image_handle;
+	u64 table;
+	u64 allocate_pool;
+	u64 allocate_pages;
+	u64 get_memory_map;
+	u64 free_pool;
+	u64 free_pages;
+	u64 locate_handle;
+	u64 handle_protocol;
+	u64 exit_boot_services;
+	u64 text_output;
+	efi_status_t (*call)(unsigned long, ...);
+	bool is64;
+} __packed;
+
+extern struct efi_config *efi_early;
+
+#define efi_call_early(f, ...)						\
+	efi_early->call(efi_early->f, __VA_ARGS__);
+
+extern bool efi_reboot_required(void);
+
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
@@ -168,6 +197,10 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 #define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
+static inline bool efi_reboot_required(void)
+{
+	return false;
+}
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_EFI_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52b1157..17962e6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -28,6 +28,7 @@
 #include <linux/mc146818rtc.h>
 #include <asm/realmode.h>
 #include <asm/x86_init.h>
+#include <asm/efi.h>
 
 /*
  * Power off function, if any
@@ -401,12 +402,25 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
+	int rv;
+
 	/*
 	 * Only do the DMI check if reboot_type hasn't been overridden
 	 * on the command line
 	 */
-	if (reboot_default)
-		dmi_check_system(reboot_dmi_table);
+	if (!reboot_default)
+		return 0;
+
+	/*
+	 * The DMI quirks table takes precedence. If no quirks entry
+	 * matches and the ACPI Hardware Reduced bit is set, force EFI
+	 * reboot.
+	 */
+	rv = dmi_check_system(reboot_dmi_table);
+
+	if (!rv && efi_reboot_required())
+		reboot_type = BOOT_EFI;
+
 	return 0;
 }
 core_initcall(reboot_init);
@@ -528,11 +542,7 @@ static void native_machine_emergency_restart(void)
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled(EFI_RUNTIME_SERVICES))
-				efi.reset_system(reboot_mode == REBOOT_WARM ?
-						 EFI_RESET_WARM :
-						 EFI_RESET_COLD,
-						 EFI_SUCCESS, 0, NULL);
+			efi_reboot(reboot_mode, NULL);
 			reboot_type = BOOT_BIOS;
 			break;
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 78a0e62..41ead8d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -924,10 +924,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
+		     EFI32_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
+		     EFI64_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index d51045a..2846aaa 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
+obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 87fc96b..850da94 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -56,13 +56,6 @@
 
 #define EFI_DEBUG
 
-#define EFI_MIN_RESERVE 5120
-
-#define EFI_DUMMY_GUID \
-	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
-
-static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
-
 struct efi_memory_map memmap;
 
 static struct efi efi_phys __initdata;
@@ -95,139 +88,6 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
-static bool efi_no_storage_paranoia;
-
-static int __init setup_storage_paranoia(char *arg)
-{
-	efi_no_storage_paranoia = true;
-	return 0;
-}
-early_param("efi_no_storage_paranoia", setup_storage_paranoia);
-
-static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_time(efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(set_time, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
-					     efi_bool_t *pending,
-					     efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(set_wakeup_time, enabled, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_get_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 *attr,
-					  unsigned long *data_size,
-					  void *data)
-{
-	return efi_call_virt(get_variable,
-			     name, vendor, attr,
-			     data_size, data);
-}
-
-static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
-					       efi_char16_t *name,
-					       efi_guid_t *vendor)
-{
-	return efi_call_virt(get_next_variable,
-			     name_size, name, vendor);
-}
-
-static efi_status_t virt_efi_set_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 attr,
-					  unsigned long data_size,
-					  void *data)
-{
-	return efi_call_virt(set_variable,
-			     name, vendor, attr,
-			     data_size, data);
-}
-
-static efi_status_t virt_efi_query_variable_info(u32 attr,
-						 u64 *storage_space,
-						 u64 *remaining_space,
-						 u64 *max_variable_size)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(query_variable_info, attr, storage_space,
-			     remaining_space, max_variable_size);
-}
-
-static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
-{
-	return efi_call_virt(get_next_high_mono_count, count);
-}
-
-static void virt_efi_reset_system(int reset_type,
-				  efi_status_t status,
-				  unsigned long data_size,
-				  efi_char16_t *data)
-{
-	__efi_call_virt(reset_system, reset_type, status,
-			data_size, data);
-}
-
-static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
-					    unsigned long count,
-					    unsigned long sg_list)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(update_capsule, capsules, count, sg_list);
-}
-
-static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
-						unsigned long count,
-						u64 *max_size,
-						int *reset_type)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			     reset_type);
-}
-
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -244,42 +104,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-int efi_set_rtc_mmss(const struct timespec *now)
-{
-	unsigned long nowtime = now->tv_sec;
-	efi_status_t	status;
-	efi_time_t	eft;
-	efi_time_cap_t	cap;
-	struct rtc_time	tm;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't read time!\n");
-		return -1;
-	}
-
-	rtc_time_to_tm(nowtime, &tm);
-	if (!rtc_valid_tm(&tm)) {
-		eft.year = tm.tm_year + 1900;
-		eft.month = tm.tm_mon + 1;
-		eft.day = tm.tm_mday;
-		eft.minute = tm.tm_min;
-		eft.second = tm.tm_sec;
-		eft.nanosecond = 0;
-	} else {
-		pr_err("%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
-		       __func__, nowtime);
-		return -1;
-	}
-
-	status = efi.set_time(&eft);
-	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't write time!\n");
-		return -1;
-	}
-	return 0;
-}
-
 void efi_get_time(struct timespec *now)
 {
 	efi_status_t status;
@@ -350,6 +174,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	struct efi_info *e = &boot_params.efi_info;
 	unsigned long pmap;
 
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
 #ifdef CONFIG_X86_32
 	/* Can't handle data above 4GB at this time */
 	if (e->efi_memmap_hi) {
@@ -392,69 +219,15 @@ static void __init print_efi_memmap(void)
 #endif  /*  EFI_DEBUG  */
 }
 
-void __init efi_reserve_boot_services(void)
-{
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		u64 start = md->phys_addr;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-		/* Only reserve where possible:
-		 * - Not within any already allocated areas
-		 * - Not over any memory area (really needed, if above?)
-		 * - Not within any part of the kernel
-		 * - Not the bios reserved area
-		*/
-		if ((start + size > __pa_symbol(_text)
-				&& start <= __pa_symbol(_end)) ||
-			!e820_all_mapped(start, start+size, E820_RAM) ||
-			memblock_is_region_reserved(start, size)) {
-			/* Could not reserve, skip it */
-			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
-				     start, start+size-1);
-		} else
-			memblock_reserve(start, size);
-	}
-}
-
 void __init efi_unmap_memmap(void)
 {
 	clear_bit(EFI_MEMMAP, &efi.flags);
 	if (memmap.map) {
-		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
 	}
 }
 
-void __init efi_free_boot_services(void)
-{
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		/* Could not reserve boot area */
-		if (!size)
-			continue;
-
-		free_bootmem_late(start, size);
-	}
-
-	efi_unmap_memmap();
-}
-
 static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
@@ -467,12 +240,12 @@ static int __init efi_systab_init(void *phys)
 			if (!data)
 				return -ENOMEM;
 		}
-		systab64 = early_ioremap((unsigned long)phys,
+		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
 			if (data)
-				early_iounmap(data, sizeof(*data));
+				early_memunmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
@@ -504,9 +277,9 @@ static int __init efi_systab_init(void *phys)
 					   systab64->tables;
 		tmp |= data ? data->tables : systab64->tables;
 
-		early_iounmap(systab64, sizeof(*systab64));
+		early_memunmap(systab64, sizeof(*systab64));
 		if (data)
-			early_iounmap(data, sizeof(*data));
+			early_memunmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -516,7 +289,7 @@ static int __init efi_systab_init(void *phys)
 	} else {
 		efi_system_table_32_t *systab32;
 
-		systab32 = early_ioremap((unsigned long)phys,
+		systab32 = early_memremap((unsigned long)phys,
 					 sizeof(*systab32));
 		if (systab32 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -537,7 +310,7 @@ static int __init efi_systab_init(void *phys)
 		efi_systab.nr_tables = systab32->nr_tables;
 		efi_systab.tables = systab32->tables;
 
-		early_iounmap(systab32, sizeof(*systab32));
+		early_memunmap(systab32, sizeof(*systab32));
 	}
 
 	efi.systab = &efi_systab;
@@ -563,7 +336,7 @@ static int __init efi_runtime_init32(void)
 {
 	efi_runtime_services_32_t *runtime;
 
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_32_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -578,7 +351,7 @@ static int __init efi_runtime_init32(void)
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_32_t));
 
 	return 0;
 }
@@ -587,7 +360,7 @@ static int __init efi_runtime_init64(void)
 {
 	efi_runtime_services_64_t *runtime;
 
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_64_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -602,7 +375,7 @@ static int __init efi_runtime_init64(void)
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_64_t));
 
 	return 0;
 }
@@ -616,14 +389,24 @@ static int __init efi_runtime_init(void)
 	 * the runtime services table so that we can grab the physical
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
+	 *
+	 * When EFI_PARAVIRT is in force then we could not map runtime
+	 * service memory region because we do not have direct access to it.
+	 * However, runtime services are available through proxy functions
+	 * (e.g. in case of Xen dom0 EFI implementation they call special
+	 * hypercall which executes relevant EFI functions) and that is why
+	 * they are always enabled.
 	 */
-	if (efi_enabled(EFI_64BIT))
-		rv = efi_runtime_init64();
-	else
-		rv = efi_runtime_init32();
 
-	if (rv)
-		return rv;
+	if (!efi_enabled(EFI_PARAVIRT)) {
+		if (efi_enabled(EFI_64BIT))
+			rv = efi_runtime_init64();
+		else
+			rv = efi_runtime_init32();
+
+		if (rv)
+			return rv;
+	}
 
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
@@ -632,8 +415,11 @@ static int __init efi_runtime_init(void)
 
 static int __init efi_memmap_init(void)
 {
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
 	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
 		pr_err("Could not map the memory map!\n");
@@ -649,62 +435,6 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
-/*
- * A number of config table entries get remapped to virtual addresses
- * after entering EFI virtual mode. However, the kexec kernel requires
- * their physical addresses therefore we pass them via setup_data and
- * correct those entries to their respective physical addresses here.
- *
- * Currently only handles smbios which is necessary for some firmware
- * implementation.
- */
-static int __init efi_reuse_config(u64 tables, int nr_tables)
-{
-	int i, sz, ret = 0;
-	void *p, *tablep;
-	struct efi_setup_data *data;
-
-	if (!efi_setup)
-		return 0;
-
-	if (!efi_enabled(EFI_64BIT))
-		return 0;
-
-	data = early_memremap(efi_setup, sizeof(*data));
-	if (!data) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (!data->smbios)
-		goto out_memremap;
-
-	sz = sizeof(efi_config_table_64_t);
-
-	p = tablep = early_memremap(tables, nr_tables * sz);
-	if (!p) {
-		pr_err("Could not map Configuration table!\n");
-		ret = -ENOMEM;
-		goto out_memremap;
-	}
-
-	for (i = 0; i < efi.systab->nr_tables; i++) {
-		efi_guid_t guid;
-
-		guid = ((efi_config_table_64_t *)p)->guid;
-
-		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = data->smbios;
-		p += sz;
-	}
-	early_iounmap(tablep, nr_tables * sz);
-
-out_memremap:
-	early_iounmap(data, sizeof(*data));
-out:
-	return ret;
-}
-
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -728,8 +458,6 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
 	efi.config_table = (unsigned long)efi.systab->tables;
 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
 	efi.runtime	 = (unsigned long)efi.systab->runtime;
@@ -737,14 +465,14 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	early_memunmap(tmp, 2);
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
@@ -770,8 +498,6 @@ void __init efi_init(void)
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &efi.flags);
-
 	print_efi_memmap();
 }
 
@@ -847,22 +573,6 @@ void __init old_map_region(efi_memory_desc_t *md)
 		       (unsigned long long)md->phys_addr);
 }
 
-static void native_runtime_setup(void)
-{
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
-	efi.query_variable_info = virt_efi_query_variable_info;
-	efi.update_capsule = virt_efi_update_capsule;
-	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-}
-
 /* Merge contiguous regions of the same type and attribute */
 static void __init efi_merge_regions(void)
 {
@@ -1049,7 +759,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 */
 	efi.runtime_version = efi_systab.hdr.revision;
 
-	native_runtime_setup();
+	efi_native_runtime_setup();
 
 	efi.set_virtual_address_map = NULL;
 
@@ -1057,11 +767,7 @@ static void __init kexec_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 
 	/* clean DUMMY object */
-	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-			 EFI_VARIABLE_NON_VOLATILE |
-			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			 EFI_VARIABLE_RUNTIME_ACCESS,
-			 0, NULL);
+	efi_delete_dummy_variable();
 #endif
 }
 
@@ -1142,7 +848,7 @@ static void __init __efi_enter_virtual_mode(void)
 	efi.runtime_version = efi_systab.hdr.revision;
 
 	if (efi_is_native())
-		native_runtime_setup();
+		efi_native_runtime_setup();
 	else
 		efi_thunk_runtime_setup();
 
@@ -1179,15 +885,14 @@ static void __init __efi_enter_virtual_mode(void)
 	free_pages((unsigned long)new_memmap, pg_shift);
 
 	/* clean DUMMY object */
-	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-			 EFI_VARIABLE_NON_VOLATILE |
-			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			 EFI_VARIABLE_RUNTIME_ACCESS,
-			 0, NULL);
+	efi_delete_dummy_variable();
 }
 
 void __init efi_enter_virtual_mode(void)
 {
+	if (efi_enabled(EFI_PARAVIRT))
+		return;
+
 	if (efi_setup)
 		kexec_enter_virtual_mode();
 	else
@@ -1220,6 +925,9 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
@@ -1230,86 +938,6 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
-/*
- * Some firmware implementations refuse to boot if there's insufficient space
- * in the variable store. Ensure that we never use more than a safe limit.
- *
- * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
- * store.
- */
-efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
-{
-	efi_status_t status;
-	u64 storage_size, remaining_size, max_size;
-
-	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
-		return 0;
-
-	status = efi.query_variable_info(attributes, &storage_size,
-					 &remaining_size, &max_size);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	/*
-	 * We account for that by refusing the write if permitting it would
-	 * reduce the available space to under 5KB. This figure was provided by
-	 * Samsung, so should be safe.
-	 */
-	if ((remaining_size - size < EFI_MIN_RESERVE) &&
-		!efi_no_storage_paranoia) {
-
-		/*
-		 * Triggering garbage collection may require that the firmware
-		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
-		 * that by attempting to use more space than is available.
-		 */
-		unsigned long dummy_size = remaining_size + 1024;
-		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
-
-		if (!dummy)
-			return EFI_OUT_OF_RESOURCES;
-
-		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					  EFI_VARIABLE_NON_VOLATILE |
-					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
-					  EFI_VARIABLE_RUNTIME_ACCESS,
-					  dummy_size, dummy);
-
-		if (status == EFI_SUCCESS) {
-			/*
-			 * This should have failed, so if it didn't make sure
-			 * that we delete it...
-			 */
-			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					 EFI_VARIABLE_NON_VOLATILE |
-					 EFI_VARIABLE_BOOTSERVICE_ACCESS |
-					 EFI_VARIABLE_RUNTIME_ACCESS,
-					 0, dummy);
-		}
-
-		kfree(dummy);
-
-		/*
-		 * The runtime code may now have triggered a garbage collection
-		 * run, so check the variable info again
-		 */
-		status = efi.query_variable_info(attributes, &storage_size,
-						 &remaining_size, &max_size);
-
-		if (status != EFI_SUCCESS)
-			return status;
-
-		/*
-		 * There still isn't enough room, so return an error
-		 */
-		if (remaining_size - size < EFI_MIN_RESERVE)
-			return EFI_OUT_OF_RESOURCES;
-	}
-
-	return EFI_SUCCESS;
-}
-EXPORT_SYMBOL_GPL(efi_query_variable_store);
-
 static int __init parse_efi_cmdline(char *str)
 {
 	if (*str == '=')
@@ -1321,22 +949,3 @@ static int __init parse_efi_cmdline(char *str)
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
-
-void __init efi_apply_memmap_quirks(void)
-{
-	/*
-	 * Once setup is done earlier, unmap the EFI memory map on mismatched
-	 * firmware/kernel architectures since there is no support for runtime
-	 * services.
-	 */
-	if (!efi_runtime_supported()) {
-		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
-		efi_unmap_memmap();
-	}
-
-	/*
-	 * UV doesn't support the new EFI pagetable mapping yet.
-	 */
-	if (is_uv_system())
-		set_bit(EFI_OLD_MEMMAP, &efi.flags);
-}
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
new file mode 100644
index 0000000..1c7380d
--- /dev/null
+++ b/arch/x86/platform/efi/quirks.c
@@ -0,0 +1,290 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/time.h>
+#include <linux/types.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+#include <linux/memblock.h>
+#include <linux/bootmem.h>
+#include <linux/acpi.h>
+#include <asm/efi.h>
+#include <asm/uv/uv.h>
+
+#define EFI_MIN_RESERVE 5120
+
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
+
+static bool efi_no_storage_paranoia;
+
+/*
+ * Some firmware implementations refuse to boot if there's insufficient
+ * space in the variable store. The implementation of garbage collection
+ * in some FW versions causes stale (deleted) variables to take up space
+ * longer than intended and space is only freed once the store becomes
+ * almost completely full.
+ *
+ * Enabling this option disables the space checks in
+ * efi_query_variable_store() and forces garbage collection.
+ *
+ * Only enable this option if deleting EFI variables does not free up
+ * space in your variable store, e.g. if despite deleting variables
+ * you're unable to create new ones.
+ */
+static int __init setup_storage_paranoia(char *arg)
+{
+	efi_no_storage_paranoia = true;
+	return 0;
+}
+early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+
+/*
+ * Deleting the dummy variable which kicks off garbage collection
+*/
+void efi_delete_dummy_variable(void)
+{
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
+}
+
+/*
+ * Some firmware implementations refuse to boot if there's insufficient space
+ * in the variable store. Ensure that we never use more than a safe limit.
+ *
+ * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
+ * store.
+ */
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	efi_status_t status;
+	u64 storage_size, remaining_size, max_size;
+
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
+	status = efi.query_variable_info(attributes, &storage_size,
+					 &remaining_size, &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/*
+	 * We account for that by refusing the write if permitting it would
+	 * reduce the available space to under 5KB. This figure was provided by
+	 * Samsung, so should be safe.
+	 */
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
+		/*
+		 * Triggering garbage collection may require that the firmware
+		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
+		 * that by attempting to use more space than is available.
+		 */
+		unsigned long dummy_size = remaining_size + 1024;
+		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
+
+		if (!dummy)
+			return EFI_OUT_OF_RESOURCES;
+
+		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					  EFI_VARIABLE_NON_VOLATILE |
+					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					  EFI_VARIABLE_RUNTIME_ACCESS,
+					  dummy_size, dummy);
+
+		if (status == EFI_SUCCESS) {
+			/*
+			 * This should have failed, so if it didn't make sure
+			 * that we delete it...
+			 */
+			efi_delete_dummy_variable();
+		}
+
+		kfree(dummy);
+
+		/*
+		 * The runtime code may now have triggered a garbage collection
+		 * run, so check the variable info again
+		 */
+		status = efi.query_variable_info(attributes, &storage_size,
+						 &remaining_size, &max_size);
+
+		if (status != EFI_SUCCESS)
+			return status;
+
+		/*
+		 * There still isn't enough room, so return an error
+		 */
+		if (remaining_size - size < EFI_MIN_RESERVE)
+			return EFI_OUT_OF_RESOURCES;
+	}
+
+	return EFI_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+/*
+ * The UEFI specification makes it clear that the operating system is free to do
+ * whatever it wants with boot services code after ExitBootServices() has been
+ * called. Ignoring this recommendation a significant bunch of EFI implementations 
+ * continue calling into boot services code (SetVirtualAddressMap). In order to 
+ * work around such buggy implementations we reserve boot services region during 
+ * EFI init and make sure it stays executable. Then, after SetVirtualAddressMap(), it
+* is discarded.
+*/
+void __init efi_reserve_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		u64 start = md->phys_addr;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		/* Only reserve where possible:
+		 * - Not within any already allocated areas
+		 * - Not over any memory area (really needed, if above?)
+		 * - Not within any part of the kernel
+		 * - Not the bios reserved area
+		*/
+		if ((start + size > __pa_symbol(_text)
+				&& start <= __pa_symbol(_end)) ||
+			!e820_all_mapped(start, start+size, E820_RAM) ||
+			memblock_is_region_reserved(start, size)) {
+			/* Could not reserve, skip it */
+			md->num_pages = 0;
+			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
+				     start, start+size-1);
+		} else
+			memblock_reserve(start, size);
+	}
+}
+
+void __init efi_free_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		/* Could not reserve boot area */
+		if (!size)
+			continue;
+
+		free_bootmem_late(start, size);
+	}
+
+	efi_unmap_memmap();
+}
+
+/*
+ * A number of config table entries get remapped to virtual addresses
+ * after entering EFI virtual mode. However, the kexec kernel requires
+ * their physical addresses therefore we pass them via setup_data and
+ * correct those entries to their respective physical addresses here.
+ *
+ * Currently only handles smbios which is necessary for some firmware
+ * implementation.
+ */
+int __init efi_reuse_config(u64 tables, int nr_tables)
+{
+	int i, sz, ret = 0;
+	void *p, *tablep;
+	struct efi_setup_data *data;
+
+	if (!efi_setup)
+		return 0;
+
+	if (!efi_enabled(EFI_64BIT))
+		return 0;
+
+	data = early_memremap(efi_setup, sizeof(*data));
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!data->smbios)
+		goto out_memremap;
+
+	sz = sizeof(efi_config_table_64_t);
+
+	p = tablep = early_memremap(tables, nr_tables * sz);
+	if (!p) {
+		pr_err("Could not map Configuration table!\n");
+		ret = -ENOMEM;
+		goto out_memremap;
+	}
+
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+
+		guid = ((efi_config_table_64_t *)p)->guid;
+
+		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
+			((efi_config_table_64_t *)p)->table = data->smbios;
+		p += sz;
+	}
+	early_memunmap(tablep, nr_tables * sz);
+
+out_memremap:
+	early_memunmap(data, sizeof(*data));
+out:
+	return ret;
+}
+
+void __init efi_apply_memmap_quirks(void)
+{
+	/*
+	 * Once setup is done earlier, unmap the EFI memory map on mismatched
+	 * firmware/kernel architectures since there is no support for runtime
+	 * services.
+	 */
+	if (!efi_runtime_supported()) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+	}
+
+	/*
+	 * UV doesn't support the new EFI pagetable mapping yet.
+	 */
+	if (is_uv_system())
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
+}
+
+/*
+ * For most modern platforms the preferred method of powering off is via
+ * ACPI. However, there are some that are known to require the use of
+ * EFI runtime services and for which ACPI does not work at all.
+ *
+ * Using EFI is a last resort, to be used only if no other option
+ * exists.
+ */
+bool efi_reboot_required(void)
+{
+	if (!acpi_gbl_reduced_hardware)
+		return false;
+
+	efi_reboot_quirk_mode = EFI_RESET_WARM;
+	return true;
+}
+
+bool efi_poweroff_required(void)
+{
+	return !!acpi_gbl_reduced_hardware;
+}
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 96ab2c0..7322755 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
+obj-$(CONFIG_XEN_EFI)		+= efi.o
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
new file mode 100644
index 0000000..a02e09e
--- /dev/null
+++ b/arch/x86/xen/efi.c
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2014 Oracle Co., Daniel Kiper
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/string.h>
+
+#include <xen/xen-ops.h>
+
+#include <asm/setup.h>
+
+void __init xen_efi_init(void)
+{
+	efi_system_table_t *efi_systab_xen;
+
+	efi_systab_xen = xen_efi_probe();
+
+	if (efi_systab_xen == NULL)
+		return;
+
+	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
+			sizeof(boot_params.efi_info.efi_loader_signature));
+	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
+	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
+
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_PARAVIRT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f17b292..2cd0463 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1715,6 +1715,8 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_setup_runstate_info(0);
 
+	xen_efi_init();
+
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index c834d4b..75f98fe 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -104,6 +104,14 @@ static inline void __init xen_init_apic(void)
 }
 #endif
 
+#ifdef CONFIG_XEN_EFI
+extern void xen_efi_init(void);
+#else
+static inline void __init xen_efi_init(void)
+{
+}
+#endif
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index d420ae2..f712d47 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -54,6 +54,12 @@ config EFI_PARAMS_FROM_FDT
 	  the EFI runtime support gets system table address, memory
           map address, and other parameters from the device tree.
 
+config EFI_RUNTIME_WRAPPERS
+	bool
+
+config EFI_ARMSTUB
+	bool
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9553496..d8be608 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,8 +1,10 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o vars.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
+obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
+obj-$(CONFIG_EFI_STUB)			+= libstub/
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb..36ffa17 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
@@ -104,16 +105,19 @@ static struct attribute *efi_subsys_attrs[] = {
 static umode_t efi_attr_is_visible(struct kobject *kobj,
 				   struct attribute *attr, int n)
 {
-	umode_t mode = attr->mode;
-
-	if (attr == &efi_attr_fw_vendor.attr)
-		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_runtime.attr)
-		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_config_table.attr)
-		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	if (attr == &efi_attr_fw_vendor.attr) {
+		if (efi_enabled(EFI_PARAVIRT) ||
+				efi.fw_vendor == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_runtime.attr) {
+		if (efi.runtime == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_config_table.attr) {
+		if (efi.config_table == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	}
 
-	return mode;
+	return attr->mode;
 }
 
 static struct attribute_group efi_subsys_attr_group = {
@@ -298,7 +302,7 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
+				early_memunmap(config_tables,
 					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
@@ -314,13 +318,27 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
 	return 0;
 }
 
+#ifdef CONFIG_EFI_VARS_MODULE
+static int __init efi_load_efivars(void)
+{
+	struct platform_device *pdev;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
+	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+}
+device_initcall(efi_load_efivars);
+#endif
+
 #ifdef CONFIG_EFI_PARAMS_FROM_FDT
 
 #define UEFI_PARAM(name, prop, field)			   \
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 463c565..f256ecd 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -78,6 +78,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@Dell.com>");
 MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
+MODULE_ALIAS("platform:efivars");
 
 LIST_HEAD(efivar_sysfs_list);
 EXPORT_SYMBOL_GPL(efivar_sysfs_list);
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
new file mode 100644
index 0000000..b14bc2b
--- /dev/null
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -0,0 +1,26 @@
+#
+# The stub may be linked into the kernel proper or into a separate boot binary,
+# but in either case, it executes before the kernel does (with MMU disabled) so
+# things like ftrace and stack-protector are likely to cause trouble if left
+# enabled, even if doing so doesn't break the build.
+#
+cflags-$(CONFIG_X86_32)		:= -march=i386
+cflags-$(CONFIG_X86_64)		:= -mcmodel=small
+cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
+				   -fPIC -fno-strict-aliasing -mno-red-zone \
+				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING
+
+cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
+				   -fno-builtin -fpic -mno-single-pic-base
+
+KBUILD_CFLAGS			:= $(cflags-y) \
+				   $(call cc-option,-ffreestanding) \
+				   $(call cc-option,-fno-stack-protector)
+
+GCOV_PROFILE			:= n
+
+lib-y				:= efi-stub-helper.o
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
+
+CFLAGS_fdt.o			+= -I$(srctree)/scripts/dtc/libfdt/
diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
similarity index 93%
rename from drivers/firmware/efi/arm-stub.c
rename to drivers/firmware/efi/libstub/arm-stub.c
index 41114ce..480339b 100644
--- a/drivers/firmware/efi/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -12,6 +12,11 @@
  *
  */
 
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
 static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 {
 	static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
@@ -36,8 +41,8 @@ static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 	}
 }
 
-static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
-				    void *__image, void **__fh)
+efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
+			     void *__image, void **__fh)
 {
 	efi_file_io_interface_t *io;
 	efi_loaded_image_t *image = __image;
@@ -60,14 +65,15 @@ static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 	*__fh = fh;
 	return status;
 }
-static efi_status_t efi_file_close(void *handle)
+
+efi_status_t efi_file_close(void *handle)
 {
 	efi_file_handle_t *fh = handle;
 
 	return fh->close(handle);
 }
 
-static efi_status_t
+efi_status_t
 efi_file_read(void *handle, unsigned long *size, void *addr)
 {
 	efi_file_handle_t *fh = handle;
@@ -76,7 +82,7 @@ efi_file_read(void *handle, unsigned long *size, void *addr)
 }
 
 
-static efi_status_t
+efi_status_t
 efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
 	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
 {
@@ -129,7 +135,7 @@ grow:
 
 
 
-static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str)
 {
 	struct efi_simple_text_output_protocol *out;
@@ -145,13 +151,13 @@ static void efi_char16_printk(efi_system_table_t *sys_table_arg,
  * must be reserved. On failure it is required to free all
  * all allocations it has made.
  */
-static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
-					unsigned long *image_addr,
-					unsigned long *image_size,
-					unsigned long *reserve_addr,
-					unsigned long *reserve_size,
-					unsigned long dram_base,
-					efi_loaded_image_t *image);
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image);
 /*
  * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
  * that is described in the PE/COFF header.  Most of the code is the same
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
similarity index 88%
rename from drivers/firmware/efi/efi-stub-helper.c
rename to drivers/firmware/efi/libstub/efi-stub-helper.c
index eb6d4be..32d5cca 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -9,18 +9,20 @@
  * under the terms of the GNU General Public License version 2.
  *
  */
-#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
-/* error code which can't be mistaken for valid address */
-#define EFI_ERROR	(~0UL)
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
 
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
 };
 
-static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
+void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 {
 	char *s8;
 
@@ -37,16 +39,12 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
-#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
-#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
-
-
-static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
-				       efi_memory_desc_t **map,
-				       unsigned long *map_size,
-				       unsigned long *desc_size,
-				       u32 *desc_ver,
-				       unsigned long *key_ptr)
+efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				efi_memory_desc_t **map,
+				unsigned long *map_size,
+				unsigned long *desc_size,
+				u32 *desc_ver,
+				unsigned long *key_ptr)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -88,7 +86,7 @@ fail:
 }
 
 
-static unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
+unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
 {
 	efi_status_t status;
 	unsigned long map_size;
@@ -116,9 +114,9 @@ static unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
-			       unsigned long size, unsigned long align,
-			       unsigned long *addr, unsigned long max)
+efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			    unsigned long size, unsigned long align,
+			    unsigned long *addr, unsigned long max)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -202,9 +200,9 @@ fail:
 /*
  * Allocate at the lowest possible address.
  */
-static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
-			      unsigned long size, unsigned long align,
-			      unsigned long *addr)
+efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			   unsigned long size, unsigned long align,
+			   unsigned long *addr)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -271,8 +269,8 @@ fail:
 	return status;
 }
 
-static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
-		     unsigned long addr)
+void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+	      unsigned long addr)
 {
 	unsigned long nr_pages;
 
@@ -290,12 +288,12 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
  * We only support loading a file from the same filesystem as
  * the kernel image.
  */
-static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
-					 efi_loaded_image_t *image,
-					 char *cmd_line, char *option_string,
-					 unsigned long max_addr,
-					 unsigned long *load_addr,
-					 unsigned long *load_size)
+efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+				  efi_loaded_image_t *image,
+				  char *cmd_line, char *option_string,
+				  unsigned long max_addr,
+				  unsigned long *load_addr,
+				  unsigned long *load_size)
 {
 	struct file_info *files;
 	unsigned long file_addr;
@@ -477,12 +475,12 @@ fail:
  * address is not available the lowest available address will
  * be used.
  */
-static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
-					unsigned long *image_addr,
-					unsigned long image_size,
-					unsigned long alloc_size,
-					unsigned long preferred_addr,
-					unsigned long alignment)
+efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+				 unsigned long *image_addr,
+				 unsigned long image_size,
+				 unsigned long alloc_size,
+				 unsigned long preferred_addr,
+				 unsigned long alignment)
 {
 	unsigned long cur_image_addr;
 	unsigned long new_addr = 0;
@@ -589,9 +587,9 @@ static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
-				 efi_loaded_image_t *image,
-				 int *cmd_line_len)
+char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+			  efi_loaded_image_t *image,
+			  int *cmd_line_len)
 {
 	const u16 *s2;
 	u8 *s1 = NULL;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
new file mode 100644
index 0000000..304ab29
--- /dev/null
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -0,0 +1,42 @@
+
+#ifndef _DRIVERS_FIRMWARE_EFI_EFISTUB_H
+#define _DRIVERS_FIRMWARE_EFI_EFISTUB_H
+
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+
+efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
+			     void **__fh);
+
+efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
+			   efi_char16_t *filename_16, void **handle,
+			   u64 *file_sz);
+
+efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr);
+
+efi_status_t efi_file_close(void *handle);
+
+unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
+
+efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			unsigned long orig_fdt_size,
+			void *fdt, int new_fdt_size, char *cmdline_ptr,
+			u64 initrd_addr, u64 initrd_size,
+			efi_memory_desc_t *memory_map,
+			unsigned long map_size, unsigned long desc_size,
+			u32 desc_ver);
+
+efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
+					    void *handle,
+					    unsigned long *new_fdt_addr,
+					    unsigned long max_addr,
+					    u64 initrd_addr, u64 initrd_size,
+					    char *cmdline_ptr,
+					    unsigned long fdt_addr,
+					    unsigned long fdt_size);
+
+void *get_fdt(efi_system_table_t *sys_table);
+
+#endif
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/libstub/fdt.c
similarity index 90%
rename from drivers/firmware/efi/fdt.c
rename to drivers/firmware/efi/libstub/fdt.c
index 5c6a8e8..86d2934 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -10,29 +10,23 @@
  *
  */
 
-static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
-			       unsigned long orig_fdt_size,
-			       void *fdt, int new_fdt_size, char *cmdline_ptr,
-			       u64 initrd_addr, u64 initrd_size,
-			       efi_memory_desc_t *memory_map,
-			       unsigned long map_size, unsigned long desc_size,
-			       u32 desc_ver)
+#include <linux/efi.h>
+#include <linux/libfdt.h>
+#include <asm/efi.h>
+
+efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			unsigned long orig_fdt_size,
+			void *fdt, int new_fdt_size, char *cmdline_ptr,
+			u64 initrd_addr, u64 initrd_size,
+			efi_memory_desc_t *memory_map,
+			unsigned long map_size, unsigned long desc_size,
+			u32 desc_ver)
 {
 	int node, prev;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
 
-	/*
-	 * Copy definition of linux_banner here.  Since this code is
-	 * built as part of the decompressor for ARM v7, pulling
-	 * in version.c where linux_banner is defined for the
-	 * kernel brings other kernel dependencies with it.
-	 */
-	const char linux_banner[] =
-	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
-
 	/* Do some checks on provided FDT, if it exists*/
 	if (orig_fdt) {
 		if (fdt_check_header(orig_fdt)) {
@@ -265,7 +259,7 @@ fail:
 	return EFI_LOAD_ERROR;
 }
 
-static void *get_fdt(efi_system_table_t *sys_table)
+void *get_fdt(efi_system_table_t *sys_table)
 {
 	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
 	efi_config_table_t *tables;
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
new file mode 100644
index 0000000..9c59d1c
--- /dev/null
+++ b/drivers/firmware/efi/reboot.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2014 Intel Corporation; author Matt Fleming
+ * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>
+ */
+#include <linux/efi.h>
+#include <linux/reboot.h>
+
+int efi_reboot_quirk_mode = -1;
+
+void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
+{
+	int efi_mode;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return;
+
+	switch (reboot_mode) {
+	case REBOOT_WARM:
+	case REBOOT_SOFT:
+		efi_mode = EFI_RESET_WARM;
+		break;
+	default:
+		efi_mode = EFI_RESET_COLD;
+		break;
+	}
+
+	/*
+	 * If a quirk forced an EFI reset mode, always use that.
+	 */
+	if (efi_reboot_quirk_mode != -1)
+		efi_mode = efi_reboot_quirk_mode;
+
+	efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
+}
+
+bool __weak efi_poweroff_required(void)
+{
+	return false;
+}
+
+static void efi_power_off(void)
+{
+	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
+}
+
+static int __init efi_shutdown_init(void)
+{
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	if (efi_poweroff_required())
+		pm_power_off = efi_power_off;
+
+	return 0;
+}
+late_initcall(efi_shutdown_init);
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
new file mode 100644
index 0000000..10daa4b
--- /dev/null
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -0,0 +1,161 @@
+/*
+ * runtime-wrappers.c - Runtime Services function call wrappers
+ *
+ * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * Split off from arch/x86/platform/efi/efi.c
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ * Copyright (C) 2005-2008 Intel Co.
+ * Copyright (C) 2013 SuSE Labs
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/efi.h>
+#include <linux/spinlock.h>             /* spinlock_t */
+#include <asm/efi.h>
+
+/*
+ * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
+ * the EFI specification requires that callers of the time related runtime
+ * functions serialize with other CMOS accesses in the kernel, as the EFI time
+ * functions may choose to also use the legacy CMOS RTC.
+ */
+__weak DEFINE_SPINLOCK(rtc_lock);
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(get_time, tm, tc);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_set_time(efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(set_time, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
+					     efi_bool_t *pending,
+					     efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	return efi_call_virt(get_next_variable, name_size, name, vendor);
+}
+
+static efi_status_t virt_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_query_variable_info(u32 attr,
+						 u64 *storage_space,
+						 u64 *remaining_space,
+						 u64 *max_variable_size)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(query_variable_info, attr, storage_space,
+			     remaining_space, max_variable_size);
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
+{
+	return efi_call_virt(get_next_high_mono_count, count);
+}
+
+static void virt_efi_reset_system(int reset_type,
+				  efi_status_t status,
+				  unsigned long data_size,
+				  efi_char16_t *data)
+{
+	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+}
+
+static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
+					    unsigned long count,
+					    unsigned long sg_list)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(update_capsule, capsules, count, sg_list);
+}
+
+static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+						unsigned long count,
+						u64 *max_size,
+						int *reset_type)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			     reset_type);
+}
+
+void efi_native_runtime_setup(void)
+{
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+}
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 38fb36e..8bc0183 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -240,4 +240,8 @@ config XEN_MCE_LOG
 config XEN_HAVE_PVMMU
        bool
 
+config XEN_EFI
+	def_bool y
+	depends on X86_64 && EFI
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 45e00af..84044b5 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,6 +9,8 @@ obj-y	+= xenbus/
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
+CFLAGS_efi.o				+= -fshort-wchar
+
 dom0-$(CONFIG_PCI) += pci.o
 dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
 dom0-$(CONFIG_ACPI) += acpi.o $(xen-pad-y)
@@ -33,6 +35,7 @@ obj-$(CONFIG_XEN_STUB)			+= xen-stub.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+= xen-acpi-memhotplug.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_CPU)	+= xen-acpi-cpuhotplug.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
+obj-$(CONFIG_XEN_EFI)			+= efi.o
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
 xen-gntalloc-y				:= gntalloc.o
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
new file mode 100644
index 0000000..31f618a
--- /dev/null
+++ b/drivers/xen/efi.c
@@ -0,0 +1,368 @@
+/*
+ * EFI support for Xen.
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2011 Novell Co.
+ *	Jan Beulich <JBeulich@suse.com>
+ * Copyright (C) 2011-2012 Oracle Co.
+ *	Liang Tang <liang.tang@oracle.com>
+ * Copyright (c) 2014 Oracle Co., Daniel Kiper
+ */
+
+#include <linux/bug.h>
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/string.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/platform.h>
+#include <xen/xen.h>
+
+#include <asm/xen/hypercall.h>
+
+#define INIT_EFI_OP(name) \
+	{.cmd = XENPF_efi_runtime_call, \
+	 .u.efi_runtime_call.function = XEN_EFI_##name, \
+	 .u.efi_runtime_call.misc = 0}
+
+#define efi_data(op)	(op.u.efi_runtime_call)
+
+static efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	struct xen_platform_op op = INIT_EFI_OP(get_time);
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(efi_data(op).u.get_time.time));
+		memcpy(tm, &efi_data(op).u.get_time.time, sizeof(*tm));
+	}
+
+	if (tc) {
+		tc->resolution = efi_data(op).u.get_time.resolution;
+		tc->accuracy = efi_data(op).u.get_time.accuracy;
+		tc->sets_to_zero = !!(efi_data(op).misc &
+				      XEN_EFI_GET_TIME_SET_CLEARS_NS);
+	}
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_set_time(efi_time_t *tm)
+{
+	struct xen_platform_op op = INIT_EFI_OP(set_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(efi_data(op).u.set_time));
+	memcpy(&efi_data(op).u.set_time, tm, sizeof(*tm));
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled,
+					    efi_bool_t *pending,
+					    efi_time_t *tm)
+{
+	struct xen_platform_op op = INIT_EFI_OP(get_wakeup_time);
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(efi_data(op).u.get_wakeup_time));
+		memcpy(tm, &efi_data(op).u.get_wakeup_time, sizeof(*tm));
+	}
+
+	if (enabled)
+		*enabled = !!(efi_data(op).misc & XEN_EFI_GET_WAKEUP_TIME_ENABLED);
+
+	if (pending)
+		*pending = !!(efi_data(op).misc & XEN_EFI_GET_WAKEUP_TIME_PENDING);
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	struct xen_platform_op op = INIT_EFI_OP(set_wakeup_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(efi_data(op).u.set_wakeup_time));
+	if (enabled)
+		efi_data(op).misc = XEN_EFI_SET_WAKEUP_TIME_ENABLE;
+	if (tm)
+		memcpy(&efi_data(op).u.set_wakeup_time, tm, sizeof(*tm));
+	else
+		efi_data(op).misc |= XEN_EFI_SET_WAKEUP_TIME_ENABLE_ONLY;
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_get_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 *attr,
+					 unsigned long *data_size,
+					 void *data)
+{
+	struct xen_platform_op op = INIT_EFI_OP(get_variable);
+
+	set_xen_guest_handle(efi_data(op).u.get_variable.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(efi_data(op).u.get_variable.vendor_guid));
+	memcpy(&efi_data(op).u.get_variable.vendor_guid, vendor, sizeof(*vendor));
+	efi_data(op).u.get_variable.size = *data_size;
+	set_xen_guest_handle(efi_data(op).u.get_variable.data, data);
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	*data_size = efi_data(op).u.get_variable.size;
+	if (attr)
+		*attr = efi_data(op).misc;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
+					      efi_char16_t *name,
+					      efi_guid_t *vendor)
+{
+	struct xen_platform_op op = INIT_EFI_OP(get_next_variable_name);
+
+	efi_data(op).u.get_next_variable_name.size = *name_size;
+	set_xen_guest_handle(efi_data(op).u.get_next_variable_name.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(efi_data(op).u.get_next_variable_name.vendor_guid));
+	memcpy(&efi_data(op).u.get_next_variable_name.vendor_guid, vendor,
+	       sizeof(*vendor));
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	*name_size = efi_data(op).u.get_next_variable_name.size;
+	memcpy(vendor, &efi_data(op).u.get_next_variable_name.vendor_guid,
+	       sizeof(*vendor));
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_set_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 attr,
+					 unsigned long data_size,
+					 void *data)
+{
+	struct xen_platform_op op = INIT_EFI_OP(set_variable);
+
+	set_xen_guest_handle(efi_data(op).u.set_variable.name, name);
+	efi_data(op).misc = attr;
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(efi_data(op).u.set_variable.vendor_guid));
+	memcpy(&efi_data(op).u.set_variable.vendor_guid, vendor, sizeof(*vendor));
+	efi_data(op).u.set_variable.size = data_size;
+	set_xen_guest_handle(efi_data(op).u.set_variable.data, data);
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_query_variable_info(u32 attr,
+						u64 *storage_space,
+						u64 *remaining_space,
+						u64 *max_variable_size)
+{
+	struct xen_platform_op op = INIT_EFI_OP(query_variable_info);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	efi_data(op).u.query_variable_info.attr = attr;
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	*storage_space = efi_data(op).u.query_variable_info.max_store_size;
+	*remaining_space = efi_data(op).u.query_variable_info.remain_store_size;
+	*max_variable_size = efi_data(op).u.query_variable_info.max_size;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
+{
+	struct xen_platform_op op = INIT_EFI_OP(get_next_high_monotonic_count);
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	*count = efi_data(op).misc;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
+					   unsigned long count,
+					   unsigned long sg_list)
+{
+	struct xen_platform_op op = INIT_EFI_OP(update_capsule);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(efi_data(op).u.update_capsule.capsule_header_array,
+			     capsules);
+	efi_data(op).u.update_capsule.capsule_count = count;
+	efi_data(op).u.update_capsule.sg_list = sg_list;
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	return efi_data(op).status;
+}
+
+static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+					       unsigned long count,
+					       u64 *max_size,
+					       int *reset_type)
+{
+	struct xen_platform_op op = INIT_EFI_OP(query_capsule_capabilities);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(efi_data(op).u.query_capsule_capabilities.capsule_header_array,
+					capsules);
+	efi_data(op).u.query_capsule_capabilities.capsule_count = count;
+
+	if (HYPERVISOR_dom0_op(&op) < 0)
+		return EFI_UNSUPPORTED;
+
+	*max_size = efi_data(op).u.query_capsule_capabilities.max_capsule_size;
+	*reset_type = efi_data(op).u.query_capsule_capabilities.reset_type;
+
+	return efi_data(op).status;
+}
+
+static efi_char16_t vendor[100] __initdata;
+
+static efi_system_table_t efi_systab_xen __initdata = {
+	.hdr = {
+		.signature	= EFI_SYSTEM_TABLE_SIGNATURE,
+		.revision	= 0, /* Initialized later. */
+		.headersize	= 0, /* Ignored by Linux Kernel. */
+		.crc32		= 0, /* Ignored by Linux Kernel. */
+		.reserved	= 0
+	},
+	.fw_vendor	= EFI_INVALID_TABLE_ADDR, /* Initialized later. */
+	.fw_revision	= 0,			  /* Initialized later. */
+	.con_in_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_in		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.runtime	= (efi_runtime_services_t *)EFI_INVALID_TABLE_ADDR,
+						  /* Not used under Xen. */
+	.boottime	= (efi_boot_services_t *)EFI_INVALID_TABLE_ADDR,
+						  /* Not used under Xen. */
+	.nr_tables	= 0,			  /* Initialized later. */
+	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
+};
+
+static const struct efi efi_xen __initconst = {
+	.systab                   = NULL, /* Initialized later. */
+	.runtime_version	  = 0,    /* Initialized later. */
+	.mps                      = EFI_INVALID_TABLE_ADDR,
+	.acpi                     = EFI_INVALID_TABLE_ADDR,
+	.acpi20                   = EFI_INVALID_TABLE_ADDR,
+	.smbios                   = EFI_INVALID_TABLE_ADDR,
+	.sal_systab               = EFI_INVALID_TABLE_ADDR,
+	.boot_info                = EFI_INVALID_TABLE_ADDR,
+	.hcdp                     = EFI_INVALID_TABLE_ADDR,
+	.uga                      = EFI_INVALID_TABLE_ADDR,
+	.uv_systab                = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
+	.runtime                  = EFI_INVALID_TABLE_ADDR,
+	.config_table             = EFI_INVALID_TABLE_ADDR,
+	.get_time                 = xen_efi_get_time,
+	.set_time                 = xen_efi_set_time,
+	.get_wakeup_time          = xen_efi_get_wakeup_time,
+	.set_wakeup_time          = xen_efi_set_wakeup_time,
+	.get_variable             = xen_efi_get_variable,
+	.get_next_variable        = xen_efi_get_next_variable,
+	.set_variable             = xen_efi_set_variable,
+	.query_variable_info      = xen_efi_query_variable_info,
+	.update_capsule           = xen_efi_update_capsule,
+	.query_capsule_caps       = xen_efi_query_capsule_caps,
+	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
+	.reset_system             = NULL, /* Functionality provided by Xen. */
+	.set_virtual_address_map  = NULL, /* Not used under Xen. */
+	.memmap                   = NULL, /* Not used under Xen. */
+	.flags			  = 0     /* Initialized later. */
+};
+
+efi_system_table_t __init *xen_efi_probe(void)
+{
+	struct xen_platform_op op = {
+		.cmd = XENPF_firmware_info,
+		.u.firmware_info = {
+			.type = XEN_FW_EFI_INFO,
+			.index = XEN_FW_EFI_CONFIG_TABLE
+		}
+	};
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op) < 0)
+		return NULL;
+
+	/* Here we know that Xen runs on EFI platform. */
+
+	efi = efi_xen;
+
+	efi_systab_xen.tables = info->cfg.addr;
+	efi_systab_xen.nr_tables = info->cfg.nent;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
+	info->vendor.bufsz = sizeof(vendor);
+	set_xen_guest_handle(info->vendor.name, vendor);
+
+	if (HYPERVISOR_dom0_op(&op) == 0) {
+		efi_systab_xen.fw_vendor = __pa_symbol(vendor);
+		efi_systab_xen.fw_revision = info->vendor.revision;
+	} else
+		efi_systab_xen.fw_vendor = __pa_symbol(L"UNKNOWN");
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
+
+	if (HYPERVISOR_dom0_op(&op) == 0)
+		efi_systab_xen.hdr.revision = info->version;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
+
+	if (HYPERVISOR_dom0_op(&op) == 0)
+		efi.runtime_version = info->version;
+
+	return &efi_systab_xen;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8b..efc681f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -20,6 +20,7 @@
 #include <linux/ioport.h>
 #include <linux/pfn.h>
 #include <linux/pstore.h>
+#include <linux/reboot.h>
 
 #include <asm/page.h>
 
@@ -521,6 +522,8 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      int *reset_type);
 typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
+void efi_native_runtime_setup(void);
+
 /*
  *  EFI Configuration Table and GUID definitions
  */
@@ -870,11 +873,13 @@ extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
-extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
+extern int efi_reboot_quirk_mode;
+extern bool efi_poweroff_required(void);
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc(m, md)					   \
 	for ((md) = (m)->map;						   \
@@ -916,7 +921,8 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
-#define EFI_ARCH_1		6	/* First arch-specific bit */
+#define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
+#define EFI_ARCH_1		7	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 /*
@@ -926,11 +932,14 @@ static inline bool efi_enabled(int feature)
 {
 	return test_bit(feature, &efi.flags) != 0;
 }
+extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
 #else
 static inline bool efi_enabled(int feature)
 {
 	return false;
 }
+static inline void
+efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
 #endif
 
 /*
@@ -1031,12 +1040,8 @@ struct efivar_operations {
 struct efivars {
 	/*
 	 * ->lock protects two things:
-	 * 1) ->list - adds, removals, reads, writes
-	 * 2) ops.[gs]et_variable() calls.
-	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * ops.get_next_variable() is only called from register_efivars()
-	 * or efivar_update_sysfs_entries(),
-	 * which is protected by the BKL, so that path is safe.
+	 * 1) efivarfs_list and efivars_sysfs_list
+	 * 2) ->ops calls
 	 */
 	spinlock_t lock;
 	struct kset *kset;
@@ -1161,4 +1166,46 @@ static inline void
 efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
 #endif
 
+/* prototypes shared between arch specific and generic stub code */
+
+#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
+void efi_printk(efi_system_table_t *sys_table_arg, char *str);
+
+void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+	      unsigned long addr);
+
+char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+			  efi_loaded_image_t *image, int *cmd_line_len);
+
+efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				efi_memory_desc_t **map,
+				unsigned long *map_size,
+				unsigned long *desc_size,
+				u32 *desc_ver,
+				unsigned long *key_ptr);
+
+efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			   unsigned long size, unsigned long align,
+			   unsigned long *addr);
+
+efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			    unsigned long size, unsigned long align,
+			    unsigned long *addr, unsigned long max);
+
+efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+				 unsigned long *image_addr,
+				 unsigned long image_size,
+				 unsigned long alloc_size,
+				 unsigned long preferred_addr,
+				 unsigned long alignment);
+
+efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+				  efi_loaded_image_t *image,
+				  char *cmd_line, char *option_string,
+				  unsigned long max_addr,
+				  unsigned long *load_addr,
+				  unsigned long *load_size);
+
 #endif /* _LINUX_EFI_H */
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index f1331e3..5cc49ea 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -108,11 +108,113 @@ struct xenpf_platform_quirk {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_platform_quirk_t);
 
+#define XENPF_efi_runtime_call    49
+#define XEN_EFI_get_time                      1
+#define XEN_EFI_set_time                      2
+#define XEN_EFI_get_wakeup_time               3
+#define XEN_EFI_set_wakeup_time               4
+#define XEN_EFI_get_next_high_monotonic_count 5
+#define XEN_EFI_get_variable                  6
+#define XEN_EFI_set_variable                  7
+#define XEN_EFI_get_next_variable_name        8
+#define XEN_EFI_query_variable_info           9
+#define XEN_EFI_query_capsule_capabilities   10
+#define XEN_EFI_update_capsule               11
+
+struct xenpf_efi_runtime_call {
+	uint32_t function;
+	/*
+	 * This field is generally used for per sub-function flags (defined
+	 * below), except for the XEN_EFI_get_next_high_monotonic_count case,
+	 * where it holds the single returned value.
+	 */
+	uint32_t misc;
+	xen_ulong_t status;
+	union {
+#define XEN_EFI_GET_TIME_SET_CLEARS_NS 0x00000001
+		struct {
+			struct xenpf_efi_time {
+				uint16_t year;
+				uint8_t month;
+				uint8_t day;
+				uint8_t hour;
+				uint8_t min;
+				uint8_t sec;
+				uint32_t ns;
+				int16_t tz;
+				uint8_t daylight;
+			} time;
+			uint32_t resolution;
+			uint32_t accuracy;
+		} get_time;
+
+		struct xenpf_efi_time set_time;
+
+#define XEN_EFI_GET_WAKEUP_TIME_ENABLED 0x00000001
+#define XEN_EFI_GET_WAKEUP_TIME_PENDING 0x00000002
+		struct xenpf_efi_time get_wakeup_time;
+
+#define XEN_EFI_SET_WAKEUP_TIME_ENABLE      0x00000001
+#define XEN_EFI_SET_WAKEUP_TIME_ENABLE_ONLY 0x00000002
+		struct xenpf_efi_time set_wakeup_time;
+
+#define XEN_EFI_VARIABLE_NON_VOLATILE       0x00000001
+#define XEN_EFI_VARIABLE_BOOTSERVICE_ACCESS 0x00000002
+#define XEN_EFI_VARIABLE_RUNTIME_ACCESS     0x00000004
+		struct {
+			GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
+			xen_ulong_t size;
+			GUEST_HANDLE(void) data;
+			struct xenpf_efi_guid {
+				uint32_t data1;
+				uint16_t data2;
+				uint16_t data3;
+				uint8_t data4[8];
+			} vendor_guid;
+		} get_variable, set_variable;
+
+		struct {
+			xen_ulong_t size;
+			GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
+			struct xenpf_efi_guid vendor_guid;
+		} get_next_variable_name;
+
+		struct {
+			uint32_t attr;
+			uint64_t max_store_size;
+			uint64_t remain_store_size;
+			uint64_t max_size;
+		} query_variable_info;
+
+		struct {
+			GUEST_HANDLE(void) capsule_header_array;
+			xen_ulong_t capsule_count;
+			uint64_t max_capsule_size;
+			uint32_t reset_type;
+		} query_capsule_capabilities;
+
+		struct {
+			GUEST_HANDLE(void) capsule_header_array;
+			xen_ulong_t capsule_count;
+			uint64_t sg_list; /* machine address */
+		} update_capsule;
+	} u;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_efi_runtime_call);
+
+#define  XEN_FW_EFI_VERSION        0
+#define  XEN_FW_EFI_CONFIG_TABLE   1
+#define  XEN_FW_EFI_VENDOR         2
+#define  XEN_FW_EFI_MEM_INFO       3
+#define  XEN_FW_EFI_RT_VERSION     4
+
 #define XENPF_firmware_info       50
 #define XEN_FW_DISK_INFO          1 /* from int 13 AH=08/41/48 */
 #define XEN_FW_DISK_MBR_SIGNATURE 2 /* from MBR offset 0x1b8 */
 #define XEN_FW_VBEDDC_INFO        3 /* from int 10 AX=4f15 */
+#define XEN_FW_EFI_INFO           4 /* from EFI */
 #define XEN_FW_KBD_SHIFT_FLAGS    5 /* Int16, Fn02: Get keyboard shift flags. */
+
 struct xenpf_firmware_info {
 	/* IN variables. */
 	uint32_t type;
@@ -144,6 +246,26 @@ struct xenpf_firmware_info {
 			GUEST_HANDLE(uchar) edid;
 		} vbeddc_info; /* XEN_FW_VBEDDC_INFO */
 
+		union xenpf_efi_info {
+			uint32_t version;
+			struct {
+				uint64_t addr;   /* EFI_CONFIGURATION_TABLE */
+				uint32_t nent;
+			} cfg;
+			struct {
+				uint32_t revision;
+				uint32_t bufsz;  /* input, in bytes */
+				GUEST_HANDLE(void) name;
+				/* UCS-2/UTF-16 string */
+			} vendor;
+			struct {
+				uint64_t addr;
+				uint64_t size;
+				uint64_t attr;
+				uint32_t type;
+			} mem;
+		} efi_info; /* XEN_FW_EFI_INFO */
+
 		uint8_t kbd_shift_flags; /* XEN_FW_KBD_SHIFT_FLAGS */
 	} u;
 };
@@ -362,6 +484,7 @@ struct xen_platform_op {
 		struct xenpf_read_memtype      read_memtype;
 		struct xenpf_microcode_update  microcode;
 		struct xenpf_platform_quirk    platform_quirk;
+		struct xenpf_efi_runtime_call  efi_runtime_call;
 		struct xenpf_firmware_info     firmware_info;
 		struct xenpf_enter_acpi_sleep  enter_acpi_sleep;
 		struct xenpf_change_freq       change_freq;
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 0b3149e..7491ee5 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -3,6 +3,7 @@
 
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/efi.h>
 #include <asm/xen/interface.h>
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
@@ -35,4 +36,14 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 			       int numpgs, struct page **pages);
 
 bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
+
+#ifdef CONFIG_XEN_EFI
+extern efi_system_table_t *xen_efi_probe(void);
+#else
+static inline efi_system_table_t __init *xen_efi_probe(void)
+{
+	return NULL;
+}
+#endif
+
 #endif /* INCLUDE_XEN_OPS_H */
