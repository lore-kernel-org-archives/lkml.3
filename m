Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3KKRhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:37:48 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:32956 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3KKRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:37:41 -0500
Date: Mon, 11 Nov 2013 18:37:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: [GIT PULL] EFI changes for v3.13
Message-ID: <20131111173736.GA13667@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   # HEAD: 88392e9dd5a524b8194f1045369c7d0eb16d9f32 Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/efi

Main changes:

 - Add support for earlyprintk=efi which uses the EFI framebuffer.
   Very useful for debugging boot problems.

 - EFI stub support for large memory maps (more than 128 entries)

 - EFI ARM support - this was mostly done by generalizing x86 <-> ARM 
   platform differences, such as by moving x86 EFI code into
   drivers/firmware/efi/ and sharing it with ARM.

 - Documentation updates

 - misc fixes

  out-of-topic modifications in x86-efi-for-linus:
  --------------------------------------------------
  arch/ia64/include/asm/io.h         # d02d054: ia64: add early_memremap() alias 
  arch/ia64/kernel/efi.c             # 272686b: efi: x86: ia64: provide a generic
  drivers/firmware/efi/efi-stub-helper.c# c158c3b: boot, efi: Remove redundant memse
                                   # 4e28308: efi: resolve warnings found on AR
                                   # 6a5fe77: efi: Fix types in EFI calls to ma
                                   # 36f8961: efi: Renames in handle_cmdline_fi
                                   # 46f4582: efi: Generalize handle_ramdisks()
                                   # 0e1cadb: efi: Allow efi_free() to be calle
                                   # 1c089c6: efi: generalize efi_get_memory_ma
                                   # 86cc653: efi: Rename __get_map() to efi_ge
                                   # 5fef387: efi: Move unicode to ASCII conver
                                   # 4a9f3a7: efi: Generalize relocate_kernel()
                                   # c6866d7: efi: Move relocate_kernel() to sh
                                   # 38dd9c0: efi: Enforce minimum alignment of
                                   # 40e4530: efi: Rename memory allocation/fre
                                   # 876dc36: efi: Add system table pointer arg
                                   # 7721da4: efi: Move common EFI stub code fr
  drivers/firmware/efi/efi.c         # 258f6fd: efi: x86: make efi_lookup_mapped_
                                   # 272686b: efi: x86: ia64: provide a generic
  drivers/firmware/efi/efivars.c     # 6f9dd30: efivars: Mark local function as s

 Thanks,

	Ingo

------------------>
Bart Kuivenhoven (1):
      x86 efi: bugfix interrupt disabling sequence

Bojan Prtvar (1):
      efivars: Mark local function as static

Leif Lindholm (4):
      ia64: add early_memremap() alias for early_ioremap()
      efi: x86: ia64: provide a generic efi_config_init()
      efi: x86: make efi_lookup_mapped_addr() a common function
      x86/efi: Fix config_table_type array termination

Linn Crosetto (1):
      x86: EFI stub support for large memory maps

Matt Fleming (1):
      x86/efi: Add EFI framebuffer earlyprintk support

Roy Franz (18):
      EFI stub documentation updates
      efi: Add proper definitions for some EFI function pointers.
      efi: Move common EFI stub code from x86 arch code to common location
      efi: Add system table pointer argument to shared functions.
      efi: Rename memory allocation/free functions
      efi: Enforce minimum alignment of 1 page on allocations.
      efi: Move relocate_kernel() to shared file.
      efi: Generalize relocate_kernel() for use by other architectures.
      efi: Move unicode to ASCII conversion to shared function.
      efi: Rename __get_map() to efi_get_memory_map()
      efi: generalize efi_get_memory_map()
      efi: use efi_get_memory_map() to get final map for x86
      efi: Allow efi_free() to be called with size of 0
      efi: Generalize handle_ramdisks() and rename to handle_cmdline_files().
      efi: Renames in handle_cmdline_files() to complete generalization.
      efi: Fix types in EFI calls to match EFI function definitions.
      efi: resolve warnings found on ARM compile
      boot, efi: Remove redundant memset()


 Documentation/{x86 => }/efi-stub.txt   |   0
 Documentation/kernel-parameters.txt    |   8 +-
 arch/ia64/include/asm/io.h             |   1 +
 arch/ia64/kernel/efi.c                 |  54 +--
 arch/x86/Kconfig                       |   2 +-
 arch/x86/Kconfig.debug                 |  10 +
 arch/x86/boot/compressed/eboot.c       | 789 ++++++++-------------------------
 arch/x86/boot/compressed/eboot.h       |   9 -
 arch/x86/include/asm/efi.h             |   2 +
 arch/x86/kernel/early_printk.c         |   7 +
 arch/x86/platform/efi/Makefile         |   1 +
 arch/x86/platform/efi/early_printk.c   | 191 ++++++++
 arch/x86/platform/efi/efi.c            | 126 +-----
 drivers/firmware/efi/efi-stub-helper.c | 636 ++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c             | 140 ++++++
 drivers/firmware/efi/efivars.c         |   2 +-
 include/linux/efi.h                    |  58 ++-
 17 files changed, 1245 insertions(+), 791 deletions(-)
 rename Documentation/{x86 => }/efi-stub.txt (100%)
 create mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 drivers/firmware/efi/efi-stub-helper.c

diff --git a/Documentation/x86/efi-stub.txt b/Documentation/efi-stub.txt
similarity index 100%
rename from Documentation/x86/efi-stub.txt
rename to Documentation/efi-stub.txt
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7f9d4f5..7a0f202 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -792,6 +792,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	earlyprintk=	[X86,SH,BLACKFIN,ARM]
 			earlyprintk=vga
+			earlyprintk=efi
 			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=serial[,0x...[,baudrate]]
@@ -805,7 +806,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Append ",keep" to not disable it when the real console
 			takes over.
 
-			Only vga or serial or usb debug port at a time.
+			Only one of vga, efi, serial, or usb debug port can
+			be used at a time.
 
 			Currently only ttyS0 and ttyS1 may be specified by
 			name.  Other I/O ports may be explicitly specified
@@ -819,8 +821,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Interaction with the standard serial driver is not
 			very good.
 
-			The VGA output is eventually overwritten by the real
-			console.
+			The VGA and EFI output is eventually overwritten by
+			the real console.
 
 			The xen output can only be used by Xen PV guests.
 
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 74a7cc3..0d2bcb3 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
+#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 51bce59..da5b462 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -44,10 +44,15 @@
 
 #define EFI_DEBUG	0
 
+static __initdata unsigned long palo_phys;
+
+static __initdata efi_config_table_type_t arch_tables[] = {
+	{PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID, "PALO", &palo_phys},
+	{NULL_GUID, NULL, 0},
+};
+
 extern efi_status_t efi_call_phys (void *, ...);
 
-struct efi efi;
-EXPORT_SYMBOL(efi);
 static efi_runtime_services_t *runtime;
 static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
 
@@ -423,9 +428,9 @@ static u8 __init palo_checksum(u8 *buffer, u32 length)
  * Parse and handle PALO table which is published at:
  * http://www.dig64.org/home/DIG64_PALO_R1_0.pdf
  */
-static void __init handle_palo(unsigned long palo_phys)
+static void __init handle_palo(unsigned long phys_addr)
 {
-	struct palo_table *palo = __va(palo_phys);
+	struct palo_table *palo = __va(phys_addr);
 	u8  checksum;
 
 	if (strncmp(palo->signature, PALO_SIG, sizeof(PALO_SIG) - 1)) {
@@ -467,12 +472,10 @@ void __init
 efi_init (void)
 {
 	void *efi_map_start, *efi_map_end;
-	efi_config_table_t *config_tables;
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] = "unknown";
 	int i;
-	unsigned long palo_phys;
 
 	/*
 	 * It's too early to be able to use the standard kernel command line
@@ -514,8 +517,6 @@ efi_init (void)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
-	config_tables = __va(efi.systab->tables);
-
 	/* Show what we know for posterity */
 	c16 = __va(efi.systab->fw_vendor);
 	if (c16) {
@@ -528,43 +529,10 @@ efi_init (void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
-	efi.mps        = EFI_INVALID_TABLE_ADDR;
-	efi.acpi       = EFI_INVALID_TABLE_ADDR;
-	efi.acpi20     = EFI_INVALID_TABLE_ADDR;
-	efi.smbios     = EFI_INVALID_TABLE_ADDR;
-	efi.sal_systab = EFI_INVALID_TABLE_ADDR;
-	efi.boot_info  = EFI_INVALID_TABLE_ADDR;
-	efi.hcdp       = EFI_INVALID_TABLE_ADDR;
-	efi.uga        = EFI_INVALID_TABLE_ADDR;
-
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
-	for (i = 0; i < (int) efi.systab->nr_tables; i++) {
-		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SAL_SYSTEM_TABLE_GUID) == 0) {
-			efi.sal_systab = config_tables[i].table;
-			printk(" SALsystab=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid,
-			 PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID) == 0) {
-			palo_phys = config_tables[i].table;
-			printk(" PALO=0x%lx", config_tables[i].table);
-		}
-	}
-	printk("\n");
+	if (efi_config_init(arch_tables) != 0)
+		return;
 
 	if (palo_phys != EFI_INVALID_TABLE_ADDR)
 		handle_palo(palo_phys);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..ec65b51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1579,7 +1579,7 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
-	  See Documentation/x86/efi-stub.txt for more information.
+	  See Documentation/efi-stub.txt for more information.
 
 config SECCOMP
 	def_bool y
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 78d91af..0f3621e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -59,6 +59,16 @@ config EARLY_PRINTK_DBGP
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
+config EARLY_PRINTK_EFI
+	bool "Early printk via the EFI framebuffer"
+	depends on EFI && EARLY_PRINTK
+	select FONT_SUPPORT
+	---help---
+	  Write kernel log output directly into the EFI framebuffer.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized.
+
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..a7677ba 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,214 +19,10 @@
 
 static efi_system_table_t *sys_table;
 
-static void efi_char16_printk(efi_char16_t *str)
-{
-	struct efi_simple_text_output_protocol *out;
-
-	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
-	efi_call_phys2(out->output_string, out, str);
-}
-
-static void efi_printk(char *str)
-{
-	char *s8;
-
-	for (s8 = str; *s8; s8++) {
-		efi_char16_t ch[2] = { 0 };
-
-		ch[0] = *s8;
-		if (*s8 == '\n') {
-			efi_char16_t nl[2] = { '\r', 0 };
-			efi_char16_printk(nl);
-		}
-
-		efi_char16_printk(ch);
-	}
-}
-
-static efi_status_t __get_map(efi_memory_desc_t **map, unsigned long *map_size,
-			      unsigned long *desc_size)
-{
-	efi_memory_desc_t *m = NULL;
-	efi_status_t status;
-	unsigned long key;
-	u32 desc_version;
-
-	*map_size = sizeof(*m) * 32;
-again:
-	/*
-	 * Add an additional efi_memory_desc_t because we're doing an
-	 * allocation which may be in a new descriptor region.
-	 */
-	*map_size += sizeof(*m);
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, *map_size, (void **)&m);
-	if (status != EFI_SUCCESS)
-		goto fail;
-
-	status = efi_call_phys5(sys_table->boottime->get_memory_map, map_size,
-				m, &key, desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_phys1(sys_table->boottime->free_pool, m);
-		goto again;
-	}
-
-	if (status != EFI_SUCCESS)
-		efi_call_phys1(sys_table->boottime->free_pool, m);
 
-fail:
-	*map = m;
-	return status;
-}
-
-/*
- * Allocate at the highest possible address that is not above 'max'.
- */
-static efi_status_t high_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr, unsigned long max)
-{
-	unsigned long map_size, desc_size;
-	efi_memory_desc_t *map;
-	efi_status_t status;
-	unsigned long nr_pages;
-	u64 max_addr = 0;
-	int i;
-
-	status = __get_map(&map, &map_size, &desc_size);
-	if (status != EFI_SUCCESS)
-		goto fail;
-
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-again:
-	for (i = 0; i < map_size / desc_size; i++) {
-		efi_memory_desc_t *desc;
-		unsigned long m = (unsigned long)map;
-		u64 start, end;
-
-		desc = (efi_memory_desc_t *)(m + (i * desc_size));
-		if (desc->type != EFI_CONVENTIONAL_MEMORY)
-			continue;
-
-		if (desc->num_pages < nr_pages)
-			continue;
+#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
 
-		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
 
-		if ((start + size) > end || (start + size) > max)
-			continue;
-
-		if (end - size > max)
-			end = max;
-
-		if (round_down(end - size, align) < start)
-			continue;
-
-		start = round_down(end - size, align);
-
-		/*
-		 * Don't allocate at 0x0. It will confuse code that
-		 * checks pointers against NULL.
-		 */
-		if (start == 0x0)
-			continue;
-
-		if (start > max_addr)
-			max_addr = start;
-	}
-
-	if (!max_addr)
-		status = EFI_NOT_FOUND;
-	else {
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &max_addr);
-		if (status != EFI_SUCCESS) {
-			max = max_addr;
-			max_addr = 0;
-			goto again;
-		}
-
-		*addr = max_addr;
-	}
-
-free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
-
-fail:
-	return status;
-}
-
-/*
- * Allocate at the lowest possible address.
- */
-static efi_status_t low_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr)
-{
-	unsigned long map_size, desc_size;
-	efi_memory_desc_t *map;
-	efi_status_t status;
-	unsigned long nr_pages;
-	int i;
-
-	status = __get_map(&map, &map_size, &desc_size);
-	if (status != EFI_SUCCESS)
-		goto fail;
-
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	for (i = 0; i < map_size / desc_size; i++) {
-		efi_memory_desc_t *desc;
-		unsigned long m = (unsigned long)map;
-		u64 start, end;
-
-		desc = (efi_memory_desc_t *)(m + (i * desc_size));
-
-		if (desc->type != EFI_CONVENTIONAL_MEMORY)
-			continue;
-
-		if (desc->num_pages < nr_pages)
-			continue;
-
-		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
-
-		/*
-		 * Don't allocate at 0x0. It will confuse code that
-		 * checks pointers against NULL. Skip the first 8
-		 * bytes so we start at a nice even number.
-		 */
-		if (start == 0x0)
-			start += 8;
-
-		start = round_up(start, align);
-		if ((start + size) > end)
-			continue;
-
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &start);
-		if (status == EFI_SUCCESS) {
-			*addr = start;
-			break;
-		}
-	}
-
-	if (i == map_size / desc_size)
-		status = EFI_NOT_FOUND;
-
-free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
-fail:
-	return status;
-}
-
-static void low_free(unsigned long size, unsigned long addr)
-{
-	unsigned long nr_pages;
-
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
-}
 
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
@@ -624,242 +420,6 @@ void setup_graphics(struct boot_params *boot_params)
 	}
 }
 
-struct initrd {
-	efi_file_handle_t *handle;
-	u64 size;
-};
-
-/*
- * Check the cmdline for a LILO-style initrd= arguments.
- *
- * We only support loading an initrd from the same filesystem as the
- * kernel image.
- */
-static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
-				    struct setup_header *hdr)
-{
-	struct initrd *initrds;
-	unsigned long initrd_addr;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
-	u64 initrd_total;
-	efi_file_io_interface_t *io;
-	efi_file_handle_t *fh;
-	efi_status_t status;
-	int nr_initrds;
-	char *str;
-	int i, j, k;
-
-	initrd_addr = 0;
-	initrd_total = 0;
-
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
-
-	j = 0;			/* See close_handles */
-
-	if (!str || !*str)
-		return EFI_SUCCESS;
-
-	for (nr_initrds = 0; *str; nr_initrds++) {
-		str = strstr(str, "initrd=");
-		if (!str)
-			break;
-
-		str += 7;
-
-		/* Skip any leading slashes */
-		while (*str == '/' || *str == '\\')
-			str++;
-
-		while (*str && *str != ' ' && *str != '\n')
-			str++;
-	}
-
-	if (!nr_initrds)
-		return EFI_SUCCESS;
-
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA,
-				nr_initrds * sizeof(*initrds),
-				&initrds);
-	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for initrds\n");
-		goto fail;
-	}
-
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
-	for (i = 0; i < nr_initrds; i++) {
-		struct initrd *initrd;
-		efi_file_handle_t *h;
-		efi_file_info_t *info;
-		efi_char16_t filename_16[256];
-		unsigned long info_sz;
-		efi_guid_t info_guid = EFI_FILE_INFO_ID;
-		efi_char16_t *p;
-		u64 file_sz;
-
-		str = strstr(str, "initrd=");
-		if (!str)
-			break;
-
-		str += 7;
-
-		initrd = &initrds[i];
-		p = filename_16;
-
-		/* Skip any leading slashes */
-		while (*str == '/' || *str == '\\')
-			str++;
-
-		while (*str && *str != ' ' && *str != '\n') {
-			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
-				break;
-
-			if (*str == '/') {
-				*p++ = '\\';
-				*str++;
-			} else {
-				*p++ = *str++;
-			}
-		}
-
-		*p = '\0';
-
-		/* Only open the volume once. */
-		if (!i) {
-			efi_boot_services_t *boottime;
-
-			boottime = sys_table->boottime;
-
-			status = efi_call_phys3(boottime->handle_protocol,
-					image->device_handle, &fs_proto, &io);
-			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to handle fs_proto\n");
-				goto free_initrds;
-			}
-
-			status = efi_call_phys2(io->open_volume, io, &fh);
-			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to open volume\n");
-				goto free_initrds;
-			}
-		}
-
-		status = efi_call_phys5(fh->open, fh, &h, filename_16,
-					EFI_FILE_MODE_READ, (u64)0);
-		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file: ");
-			efi_char16_printk(filename_16);
-			efi_printk("\n");
-			goto close_handles;
-		}
-
-		initrd->handle = h;
-
-		info_sz = 0;
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, NULL);
-		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk("Failed to get initrd info size\n");
-			goto close_handles;
-		}
-
-grow:
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-					EFI_LOADER_DATA, info_sz, &info);
-		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc mem for initrd info\n");
-			goto close_handles;
-		}
-
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, info);
-		if (status == EFI_BUFFER_TOO_SMALL) {
-			efi_call_phys1(sys_table->boottime->free_pool, info);
-			goto grow;
-		}
-
-		file_sz = info->file_size;
-		efi_call_phys1(sys_table->boottime->free_pool, info);
-
-		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to get initrd info\n");
-			goto close_handles;
-		}
-
-		initrd->size = file_sz;
-		initrd_total += file_sz;
-	}
-
-	if (initrd_total) {
-		unsigned long addr;
-
-		/*
-		 * Multiple initrd's need to be at consecutive
-		 * addresses in memory, so allocate enough memory for
-		 * all the initrd's.
-		 */
-		status = high_alloc(initrd_total, 0x1000,
-				   &initrd_addr, hdr->initrd_addr_max);
-		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc highmem for initrds\n");
-			goto close_handles;
-		}
-
-		/* We've run out of free low memory. */
-		if (initrd_addr > hdr->initrd_addr_max) {
-			efi_printk("We've run out of free low memory\n");
-			status = EFI_INVALID_PARAMETER;
-			goto free_initrd_total;
-		}
-
-		addr = initrd_addr;
-		for (j = 0; j < nr_initrds; j++) {
-			u64 size;
-
-			size = initrds[j].size;
-			while (size) {
-				u64 chunksize;
-				if (size > EFI_READ_CHUNK_SIZE)
-					chunksize = EFI_READ_CHUNK_SIZE;
-				else
-					chunksize = size;
-				status = efi_call_phys3(fh->read,
-							initrds[j].handle,
-							&chunksize, addr);
-				if (status != EFI_SUCCESS) {
-					efi_printk("Failed to read initrd\n");
-					goto free_initrd_total;
-				}
-				addr += chunksize;
-				size -= chunksize;
-			}
-
-			efi_call_phys1(fh->close, initrds[j].handle);
-		}
-
-	}
-
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
-
-	hdr->ramdisk_image = initrd_addr;
-	hdr->ramdisk_size = initrd_total;
-
-	return status;
-
-free_initrd_total:
-	low_free(initrd_total, initrd_addr);
-
-close_handles:
-	for (k = j; k < i; k++)
-		efi_call_phys1(fh->close, initrds[k].handle);
-free_initrds:
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
-fail:
-	hdr->ramdisk_image = 0;
-	hdr->ramdisk_size = 0;
-
-	return status;
-}
 
 /*
  * Because the x86 boot code expects to be passed a boot_params we
@@ -875,14 +435,15 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	struct efi_info *efi;
 	efi_loaded_image_t *image;
 	void *options;
-	u32 load_options_size;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	int options_size = 0;
 	efi_status_t status;
-	unsigned long cmdline;
+	char *cmdline_ptr;
 	u16 *s2;
 	u8 *s1;
 	int i;
+	unsigned long ramdisk_addr;
+	unsigned long ramdisk_size;
 
 	sys_table = _table;
 
@@ -893,13 +454,14 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	status = efi_call_phys3(sys_table->boottime->handle_protocol,
 				handle, &proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
 	}
 
-	status = low_alloc(0x4000, 1, (unsigned long *)&boot_params);
+	status = efi_low_alloc(sys_table, 0x4000, 1,
+			       (unsigned long *)&boot_params);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc lowmem for boot params\n");
+		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
 	}
 
@@ -926,40 +488,11 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
-	options = image->load_options;
-	load_options_size = image->load_options_size / 2; /* ASCII */
-	cmdline = 0;
-	s2 = (u16 *)options;
-
-	if (s2) {
-		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
-			s2++;
-			options_size++;
-		}
-
-		if (options_size) {
-			if (options_size > hdr->cmdline_size)
-				options_size = hdr->cmdline_size;
-
-			options_size++;	/* NUL termination */
-
-			status = low_alloc(options_size, 1, &cmdline);
-			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to alloc mem for cmdline\n");
-				goto fail;
-			}
-
-			s1 = (u8 *)(unsigned long)cmdline;
-			s2 = (u16 *)options;
-
-			for (i = 0; i < options_size - 1; i++)
-				*s1++ = *s2++;
-
-			*s1 = '\0';
-		}
-	}
-
-	hdr->cmd_line_ptr = cmdline;
+	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
+						   &options_size);
+	if (!cmdline_ptr)
+		goto fail;
+	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
 
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
@@ -969,96 +502,64 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	status = handle_ramdisks(image, hdr);
+	status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", hdr->initrd_addr_max,
+				      &ramdisk_addr, &ramdisk_size);
 	if (status != EFI_SUCCESS)
 		goto fail2;
+	hdr->ramdisk_image = ramdisk_addr;
+	hdr->ramdisk_size = ramdisk_size;
 
 	return boot_params;
 fail2:
-	if (options_size)
-		low_free(options_size, hdr->cmd_line_ptr);
+	efi_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
-	low_free(0x4000, (unsigned long)boot_params);
+	efi_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
 }
 
-static efi_status_t exit_boot(struct boot_params *boot_params,
-			      void *handle)
+static void add_e820ext(struct boot_params *params,
+			struct setup_data *e820ext, u32 nr_entries)
 {
-	struct efi_info *efi = &boot_params->efi_info;
-	struct e820entry *e820_map = &boot_params->e820_map[0];
-	struct e820entry *prev = NULL;
-	unsigned long size, key, desc_size, _size;
-	efi_memory_desc_t *mem_map;
+	struct setup_data *data;
 	efi_status_t status;
-	__u32 desc_version;
-	bool called_exit = false;
-	u8 nr_entries;
-	int i;
-
-	size = sizeof(*mem_map) * 32;
-
-again:
-	size += sizeof(*mem_map) * 2;
-	_size = size;
-	status = low_alloc(size, 1, (unsigned long *)&mem_map);
-	if (status != EFI_SUCCESS)
-		return status;
-
-get_map:
-	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
-				mem_map, &key, &desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		low_free(_size, (unsigned long)mem_map);
-		goto again;
-	}
+	unsigned long size;
 
-	if (status != EFI_SUCCESS)
-		goto free_mem_map;
+	e820ext->type = SETUP_E820_EXT;
+	e820ext->len = nr_entries * sizeof(struct e820entry);
+	e820ext->next = 0;
 
-	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
-	efi->efi_systab = (unsigned long)sys_table;
-	efi->efi_memdesc_size = desc_size;
-	efi->efi_memdesc_version = desc_version;
-	efi->efi_memmap = (unsigned long)mem_map;
-	efi->efi_memmap_size = size;
-
-#ifdef CONFIG_X86_64
-	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
-	efi->efi_memmap_hi = (unsigned long)mem_map >> 32;
-#endif
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
-	/* Might as well exit boot services now */
-	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
-				handle, key);
-	if (status != EFI_SUCCESS) {
-		/*
-		 * ExitBootServices() will fail if any of the event
-		 * handlers change the memory map. In which case, we
-		 * must be prepared to retry, but only once so that
-		 * we're guaranteed to exit on repeated failures instead
-		 * of spinning forever.
-		 */
-		if (called_exit)
-			goto free_mem_map;
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
 
-		called_exit = true;
-		goto get_map;
-	}
+	if (data)
+		data->next = (unsigned long)e820ext;
+	else
+		params->hdr.setup_data = (unsigned long)e820ext;
+}
 
-	/* Historic? */
-	boot_params->alt_mem_k = 32 * 1024;
+static efi_status_t setup_e820(struct boot_params *params,
+			       struct setup_data *e820ext, u32 e820ext_size)
+{
+	struct e820entry *e820_map = &params->e820_map[0];
+	struct efi_info *efi = &params->efi_info;
+	struct e820entry *prev = NULL;
+	u32 nr_entries;
+	u32 nr_desc;
+	int i;
 
-	/*
-	 * Convert the EFI memory map to E820.
-	 */
 	nr_entries = 0;
-	for (i = 0; i < size / desc_size; i++) {
+	nr_desc = efi->efi_memmap_size / efi->efi_memdesc_size;
+
+	for (i = 0; i < nr_desc; i++) {
 		efi_memory_desc_t *d;
 		unsigned int e820_type = 0;
-		unsigned long m = (unsigned long)mem_map;
+		unsigned long m = efi->efi_memmap;
 
-		d = (efi_memory_desc_t *)(m + (i * desc_size));
+		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
 		switch (d->type) {
 		case EFI_RESERVED_TYPE:
 		case EFI_RUNTIME_SERVICES_CODE:
@@ -1095,61 +596,151 @@ get_map:
 
 		/* Merge adjacent mappings */
 		if (prev && prev->type == e820_type &&
-		    (prev->addr + prev->size) == d->phys_addr)
+		    (prev->addr + prev->size) == d->phys_addr) {
 			prev->size += d->num_pages << 12;
-		else {
-			e820_map->addr = d->phys_addr;
-			e820_map->size = d->num_pages << 12;
-			e820_map->type = e820_type;
-			prev = e820_map++;
-			nr_entries++;
+			continue;
+		}
+
+		if (nr_entries == ARRAY_SIZE(params->e820_map)) {
+			u32 need = (nr_desc - i) * sizeof(struct e820entry) +
+				   sizeof(struct setup_data);
+
+			if (!e820ext || e820ext_size < need)
+				return EFI_BUFFER_TOO_SMALL;
+
+			/* boot_params map full, switch to e820 extended */
+			e820_map = (struct e820entry *)e820ext->data;
 		}
+
+		e820_map->addr = d->phys_addr;
+		e820_map->size = d->num_pages << PAGE_SHIFT;
+		e820_map->type = e820_type;
+		prev = e820_map++;
+		nr_entries++;
 	}
 
-	boot_params->e820_entries = nr_entries;
+	if (nr_entries > ARRAY_SIZE(params->e820_map)) {
+		u32 nr_e820ext = nr_entries - ARRAY_SIZE(params->e820_map);
+
+		add_e820ext(params, e820ext, nr_e820ext);
+		nr_entries -= nr_e820ext;
+	}
+
+	params->e820_entries = (u8)nr_entries;
 
 	return EFI_SUCCESS;
+}
+
+static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
+				  u32 *e820ext_size)
+{
+	efi_status_t status;
+	unsigned long size;
+
+	size = sizeof(struct setup_data) +
+		sizeof(struct e820entry) * nr_desc;
+
+	if (*e820ext) {
+		efi_call_phys1(sys_table->boottime->free_pool, *e820ext);
+		*e820ext = NULL;
+		*e820ext_size = 0;
+	}
+
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, size, e820ext);
+
+	if (status == EFI_SUCCESS)
+		*e820ext_size = size;
 
-free_mem_map:
-	low_free(_size, (unsigned long)mem_map);
 	return status;
 }
 
-static efi_status_t relocate_kernel(struct setup_header *hdr)
+static efi_status_t exit_boot(struct boot_params *boot_params,
+			      void *handle)
 {
-	unsigned long start, nr_pages;
+	struct efi_info *efi = &boot_params->efi_info;
+	unsigned long map_sz, key, desc_size;
+	efi_memory_desc_t *mem_map;
+	struct setup_data *e820ext;
+	__u32 e820ext_size;
+	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
+	__u32 desc_version;
+	bool called_exit = false;
+	u8 nr_entries;
+	int i;
 
-	/*
-	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has various restrictions
-	 * on the max physical address it can run at. Attempt to move
-	 * the kernel to boot_params.pref_address, or as low as
-	 * possible.
-	 */
-	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_desc = 0;
+	e820ext = NULL;
+	e820ext_size = 0;
 
-	status = efi_call_phys4(sys_table->boottime->allocate_pages,
-				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &start);
-	if (status != EFI_SUCCESS) {
-		status = low_alloc(hdr->init_size, hdr->kernel_alignment,
-				   &start);
+get_map:
+	status = efi_get_memory_map(sys_table, &mem_map, &map_sz, &desc_size,
+				    &desc_version, &key);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	prev_nr_desc = nr_desc;
+	nr_desc = map_sz / desc_size;
+	if (nr_desc > prev_nr_desc &&
+	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
+		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
+
+		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
 		if (status != EFI_SUCCESS)
-			efi_printk("Failed to alloc mem for kernel\n");
+			goto free_mem_map;
+
+		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		goto get_map; /* Allocated memory, get map again */
 	}
 
-	if (status == EFI_SUCCESS)
-		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
-		       hdr->init_size);
+	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
+	efi->efi_systab = (unsigned long)sys_table;
+	efi->efi_memdesc_size = desc_size;
+	efi->efi_memdesc_version = desc_version;
+	efi->efi_memmap = (unsigned long)mem_map;
+	efi->efi_memmap_size = map_sz;
+
+#ifdef CONFIG_X86_64
+	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
+	efi->efi_memmap_hi = (unsigned long)mem_map >> 32;
+#endif
 
-	hdr->pref_address = hdr->code32_start;
-	hdr->code32_start = (__u32)start;
+	/* Might as well exit boot services now */
+	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
+				handle, key);
+	if (status != EFI_SUCCESS) {
+		/*
+		 * ExitBootServices() will fail if any of the event
+		 * handlers change the memory map. In which case, we
+		 * must be prepared to retry, but only once so that
+		 * we're guaranteed to exit on repeated failures instead
+		 * of spinning forever.
+		 */
+		if (called_exit)
+			goto free_mem_map;
 
+		called_exit = true;
+		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		goto get_map;
+	}
+
+	/* Historic? */
+	boot_params->alt_mem_k = 32 * 1024;
+
+	status = setup_e820(boot_params, e820ext, e820ext_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	return EFI_SUCCESS;
+
+free_mem_map:
+	efi_call_phys1(sys_table->boottime->free_pool, mem_map);
 	return status;
 }
 
+
 /*
  * On success we return a pointer to a boot_params structure, and NULL
  * on failure.
@@ -1157,7 +748,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 			     struct boot_params *boot_params)
 {
-	struct desc_ptr *gdt, *idt;
+	struct desc_ptr *gdt;
 	efi_loaded_image_t *image;
 	struct setup_header *hdr = &boot_params->hdr;
 	efi_status_t status;
@@ -1177,37 +768,33 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
 	}
 
 	gdt->size = 0x800;
-	status = low_alloc(gdt->size, 8, (unsigned long *)&gdt->address);
-	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt\n");
-		goto fail;
-	}
-
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*idt),
-				(void **)&idt);
+	status = efi_low_alloc(sys_table, gdt->size, 8,
+			   (unsigned long *)&gdt->address);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for idt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
 		goto fail;
 	}
 
-	idt->size = 0;
-	idt->address = 0;
-
 	/*
 	 * If the kernel isn't already loaded at the preferred load
 	 * address, relocate it.
 	 */
 	if (hdr->pref_address != hdr->code32_start) {
-		status = relocate_kernel(hdr);
-
+		unsigned long bzimage_addr = hdr->code32_start;
+		status = efi_relocate_kernel(sys_table, &bzimage_addr,
+					     hdr->init_size, hdr->init_size,
+					     hdr->pref_address,
+					     hdr->kernel_alignment);
 		if (status != EFI_SUCCESS)
 			goto fail;
+
+		hdr->pref_address = hdr->code32_start;
+		hdr->code32_start = bzimage_addr;
 	}
 
 	status = exit_boot(boot_params, handle);
@@ -1267,10 +854,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	desc->base2 = 0x00;
 #endif /* CONFIG_X86_64 */
 
-	asm volatile ("lidt %0" : : "m" (*idt));
-	asm volatile ("lgdt %0" : : "m" (*gdt));
-
 	asm volatile("cli");
+	asm volatile ("lgdt %0" : : "m" (*gdt));
 
 	return boot_params;
 fail:
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index e5b0a8f..81b6b65 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -11,9 +11,6 @@
 
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
-#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
-#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
-
 #define EFI_CONSOLE_OUT_DEVICE_GUID    \
 	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
 		  0x3f, 0xc1, 0x4d)
@@ -62,10 +59,4 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
-struct efi_simple_text_output_protocol {
-	void *reset;
-	void *output_string;
-	void *test_string;
-};
-
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0062a01..65c6e6e 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -109,6 +109,8 @@ static inline bool efi_is_native(void)
 	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
 }
 
+extern struct console early_efi_console;
+
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index d15f575..6d3d200 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -17,6 +17,8 @@
 #include <asm/mrst.h>
 #include <asm/pgtable.h>
 #include <linux/usb/ehci_def.h>
+#include <linux/efi.h>
+#include <asm/efi.h>
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
@@ -234,6 +236,11 @@ static int __init setup_early_printk(char *buf)
 			early_console_register(&early_hsu_console, keep);
 		}
 #endif
+#ifdef CONFIG_EARLY_PRINTK_EFI
+		if (!strncmp(buf, "efi", 3))
+			early_console_register(&early_efi_console, keep);
+#endif
+
 		buf++;
 	}
 	return 0;
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 6db1cc4..b7b0b35 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
+obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
new file mode 100644
index 0000000..6599a00
--- /dev/null
+++ b/arch/x86/platform/efi/early_printk.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (C) 2013 Intel Corporation; author Matt Fleming
+ *
+ *  This file is part of the Linux kernel, and is made available under
+ *  the terms of the GNU General Public License version 2.
+ */
+
+#include <linux/console.h>
+#include <linux/efi.h>
+#include <linux/font.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <asm/setup.h>
+
+static const struct font_desc *font;
+static u32 efi_x, efi_y;
+
+static __init void early_efi_clear_scanline(unsigned int y)
+{
+	unsigned long base, *dst;
+	u16 len;
+
+	base = boot_params.screen_info.lfb_base;
+	len = boot_params.screen_info.lfb_linelength;
+
+	dst = early_ioremap(base + y*len, len);
+	if (!dst)
+		return;
+
+	memset(dst, 0, len);
+	early_iounmap(dst, len);
+}
+
+static __init void early_efi_scroll_up(void)
+{
+	unsigned long base, *dst, *src;
+	u16 len;
+	u32 i, height;
+
+	base = boot_params.screen_info.lfb_base;
+	len = boot_params.screen_info.lfb_linelength;
+	height = boot_params.screen_info.lfb_height;
+
+	for (i = 0; i < height - font->height; i++) {
+		dst = early_ioremap(base + i*len, len);
+		if (!dst)
+			return;
+
+		src = early_ioremap(base + (i + font->height) * len, len);
+		if (!src) {
+			early_iounmap(dst, len);
+			return;
+		}
+
+		memmove(dst, src, len);
+
+		early_iounmap(src, len);
+		early_iounmap(dst, len);
+	}
+}
+
+static void early_efi_write_char(u32 *dst, unsigned char c, unsigned int h)
+{
+	const u32 color_black = 0x00000000;
+	const u32 color_white = 0x00ffffff;
+	const u8 *src;
+	u8 s8;
+	int m;
+
+	src = font->data + c * font->height;
+	s8 = *(src + h);
+
+	for (m = 0; m < 8; m++) {
+		if ((s8 >> (7 - m)) & 1)
+			*dst = color_white;
+		else
+			*dst = color_black;
+		dst++;
+	}
+}
+
+static __init void
+early_efi_write(struct console *con, const char *str, unsigned int num)
+{
+	struct screen_info *si;
+	unsigned long base;
+	unsigned int len;
+	const char *s;
+	void *dst;
+
+	base = boot_params.screen_info.lfb_base;
+	si = &boot_params.screen_info;
+	len = si->lfb_linelength;
+
+	while (num) {
+		unsigned int linemax;
+		unsigned int h, count = 0;
+
+		for (s = str; *s && *s != '\n'; s++) {
+			if (count == num)
+				break;
+			count++;
+		}
+
+		linemax = (si->lfb_width - efi_x) / font->width;
+		if (count > linemax)
+			count = linemax;
+
+		for (h = 0; h < font->height; h++) {
+			unsigned int n, x;
+
+			dst = early_ioremap(base + (efi_y + h) * len, len);
+			if (!dst)
+				return;
+
+			s = str;
+			n = count;
+			x = efi_x;
+
+			while (n-- > 0) {
+				early_efi_write_char(dst + x*4, *s, h);
+				x += font->width;
+				s++;
+			}
+
+			early_iounmap(dst, len);
+		}
+
+		num -= count;
+		efi_x += count * font->width;
+		str += count;
+
+		if (num > 0 && *s == '\n') {
+			efi_x = 0;
+			efi_y += font->height;
+			str++;
+			num--;
+		}
+
+		if (efi_x >= si->lfb_width) {
+			efi_x = 0;
+			efi_y += font->height;
+		}
+
+		if (efi_y + font->height >= si->lfb_height) {
+			u32 i;
+
+			efi_y -= font->height;
+			early_efi_scroll_up();
+
+			for (i = 0; i < font->height; i++)
+				early_efi_clear_scanline(efi_y + i);
+		}
+	}
+}
+
+static __init int early_efi_setup(struct console *con, char *options)
+{
+	struct screen_info *si;
+	u16 xres, yres;
+	u32 i;
+
+	si = &boot_params.screen_info;
+	xres = si->lfb_width;
+	yres = si->lfb_height;
+
+	/*
+	 * early_efi_write_char() implicitly assumes a framebuffer with
+	 * 32-bits per pixel.
+	 */
+	if (si->lfb_depth != 32)
+		return -ENODEV;
+
+	font = get_default_font(xres, yres, -1, -1);
+	if (!font)
+		return -ENODEV;
+
+	efi_y = rounddown(yres, font->height) - font->height;
+	for (i = 0; i < (yres - efi_y) / font->height; i++)
+		early_efi_scroll_up();
+
+	return 0;
+}
+
+struct console early_efi_console = {
+	.name =		"earlyefi",
+	.write =	early_efi_write,
+	.setup =	early_efi_setup,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..1d3372a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -60,19 +60,6 @@
 
 static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
-struct efi __read_mostly efi = {
-	.mps        = EFI_INVALID_TABLE_ADDR,
-	.acpi       = EFI_INVALID_TABLE_ADDR,
-	.acpi20     = EFI_INVALID_TABLE_ADDR,
-	.smbios     = EFI_INVALID_TABLE_ADDR,
-	.sal_systab = EFI_INVALID_TABLE_ADDR,
-	.boot_info  = EFI_INVALID_TABLE_ADDR,
-	.hcdp       = EFI_INVALID_TABLE_ADDR,
-	.uga        = EFI_INVALID_TABLE_ADDR,
-	.uv_systab  = EFI_INVALID_TABLE_ADDR,
-};
-EXPORT_SYMBOL(efi);
-
 struct efi_memory_map memmap;
 
 static struct efi efi_phys __initdata;
@@ -80,6 +67,13 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
+static __initdata efi_config_table_type_t arch_tables[] = {
+#ifdef CONFIG_X86_UV
+	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
+#endif
+	{NULL_GUID, NULL, NULL},
+};
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -399,6 +393,8 @@ int __init efi_memblock_x86_reserve_range(void)
 
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
 
+	efi.memmap = &memmap;
+
 	return 0;
 }
 
@@ -578,80 +574,6 @@ static int __init efi_systab_init(void *phys)
 	return 0;
 }
 
-static int __init efi_config_init(u64 tables, int nr_tables)
-{
-	void *config_tables, *tablep;
-	int i, sz;
-
-	if (efi_enabled(EFI_64BIT))
-		sz = sizeof(efi_config_table_64_t);
-	else
-		sz = sizeof(efi_config_table_32_t);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = early_ioremap(tables, nr_tables * sz);
-	if (config_tables == NULL) {
-		pr_err("Could not map Configuration table!\n");
-		return -ENOMEM;
-	}
-
-	tablep = config_tables;
-	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
-		efi_guid_t guid;
-		unsigned long table;
-
-		if (efi_enabled(EFI_64BIT)) {
-			u64 table64;
-			guid = ((efi_config_table_64_t *)tablep)->guid;
-			table64 = ((efi_config_table_64_t *)tablep)->table;
-			table = table64;
-#ifdef CONFIG_X86_32
-			if (table64 >> 32) {
-				pr_cont("\n");
-				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
-					      efi.systab->nr_tables * sz);
-				return -EINVAL;
-			}
-#endif
-		} else {
-			guid = ((efi_config_table_32_t *)tablep)->guid;
-			table = ((efi_config_table_32_t *)tablep)->table;
-		}
-		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
-			efi.mps = table;
-			pr_cont(" MPS=0x%lx ", table);
-		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = table;
-			pr_cont(" ACPI 2.0=0x%lx ", table);
-		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
-			efi.acpi = table;
-			pr_cont(" ACPI=0x%lx ", table);
-		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
-			efi.smbios = table;
-			pr_cont(" SMBIOS=0x%lx ", table);
-#ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = table;
-			pr_cont(" UVsystab=0x%lx ", table);
-#endif
-		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
-			efi.hcdp = table;
-			pr_cont(" HCDP=0x%lx ", table);
-		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = table;
-			pr_cont(" UGA=0x%lx ", table);
-		}
-		tablep += sz;
-	}
-	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
-	return 0;
-}
-
 static int __init efi_runtime_init(void)
 {
 	efi_runtime_services_t *runtime;
@@ -745,7 +667,7 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
-	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables))
+	if (efi_config_init(arch_tables))
 		return;
 
 	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
@@ -816,34 +738,6 @@ static void __init runtime_code_page_mkexec(void)
 	}
 }
 
-/*
- * We can't ioremap data in EFI boot services RAM, because we've already mapped
- * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
- * callable after efi_enter_virtual_mode and before efi_free_boot_services.
- */
-void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
-{
-	void *p;
-	if (WARN_ON(!memmap.map))
-		return NULL;
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
-		u64 end = md->phys_addr + size;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-		if (!md->virt_addr)
-			continue;
-		if (phys_addr >= md->phys_addr && phys_addr < end) {
-			phys_addr += md->virt_addr - md->phys_addr;
-			return (__force void __iomem *)(unsigned long)phys_addr;
-		}
-	}
-	return NULL;
-}
-
 void efi_memory_uc(u64 addr, unsigned long size)
 {
 	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
new file mode 100644
index 0000000..b6bffbf
--- /dev/null
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -0,0 +1,636 @@
+/*
+ * Helper functions used by the EFI stub on multiple
+ * architectures. This should be #included by the EFI stub
+ * implementation files.
+ *
+ * Copyright 2011 Intel Corporation; author Matt Fleming
+ *
+ * This file is part of the Linux kernel, and is made available
+ * under the terms of the GNU General Public License version 2.
+ *
+ */
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
+
+struct file_info {
+	efi_file_handle_t *handle;
+	u64 size;
+};
+
+
+
+
+static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+			      efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+
+	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
+	efi_call_phys2(out->output_string, out, str);
+}
+
+static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
+{
+	char *s8;
+
+	for (s8 = str; *s8; s8++) {
+		efi_char16_t ch[2] = { 0 };
+
+		ch[0] = *s8;
+		if (*s8 == '\n') {
+			efi_char16_t nl[2] = { '\r', 0 };
+			efi_char16_printk(sys_table_arg, nl);
+		}
+
+		efi_char16_printk(sys_table_arg, ch);
+	}
+}
+
+
+static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				       efi_memory_desc_t **map,
+				       unsigned long *map_size,
+				       unsigned long *desc_size,
+				       u32 *desc_ver,
+				       unsigned long *key_ptr)
+{
+	efi_memory_desc_t *m = NULL;
+	efi_status_t status;
+	unsigned long key;
+	u32 desc_version;
+
+	*map_size = sizeof(*m) * 32;
+again:
+	/*
+	 * Add an additional efi_memory_desc_t because we're doing an
+	 * allocation which may be in a new descriptor region.
+	 */
+	*map_size += sizeof(*m);
+	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
+				EFI_LOADER_DATA, *map_size, (void **)&m);
+	if (status != EFI_SUCCESS)
+		goto fail;
+
+	status = efi_call_phys5(sys_table_arg->boottime->get_memory_map,
+				map_size, m, &key, desc_size, &desc_version);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		goto again;
+	}
+
+	if (status != EFI_SUCCESS)
+		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+	if (key_ptr && status == EFI_SUCCESS)
+		*key_ptr = key;
+	if (desc_ver && status == EFI_SUCCESS)
+		*desc_ver = desc_version;
+
+fail:
+	*map = m;
+	return status;
+}
+
+/*
+ * Allocate at the highest possible address that is not above 'max'.
+ */
+static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			       unsigned long size, unsigned long align,
+			       unsigned long *addr, unsigned long max)
+{
+	unsigned long map_size, desc_size;
+	efi_memory_desc_t *map;
+	efi_status_t status;
+	unsigned long nr_pages;
+	u64 max_addr = 0;
+	int i;
+
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL, NULL);
+	if (status != EFI_SUCCESS)
+		goto fail;
+
+	/*
+	 * Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
+	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+again:
+	for (i = 0; i < map_size / desc_size; i++) {
+		efi_memory_desc_t *desc;
+		unsigned long m = (unsigned long)map;
+		u64 start, end;
+
+		desc = (efi_memory_desc_t *)(m + (i * desc_size));
+		if (desc->type != EFI_CONVENTIONAL_MEMORY)
+			continue;
+
+		if (desc->num_pages < nr_pages)
+			continue;
+
+		start = desc->phys_addr;
+		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+
+		if ((start + size) > end || (start + size) > max)
+			continue;
+
+		if (end - size > max)
+			end = max;
+
+		if (round_down(end - size, align) < start)
+			continue;
+
+		start = round_down(end - size, align);
+
+		/*
+		 * Don't allocate at 0x0. It will confuse code that
+		 * checks pointers against NULL.
+		 */
+		if (start == 0x0)
+			continue;
+
+		if (start > max_addr)
+			max_addr = start;
+	}
+
+	if (!max_addr)
+		status = EFI_NOT_FOUND;
+	else {
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					nr_pages, &max_addr);
+		if (status != EFI_SUCCESS) {
+			max = max_addr;
+			max_addr = 0;
+			goto again;
+		}
+
+		*addr = max_addr;
+	}
+
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+
+fail:
+	return status;
+}
+
+/*
+ * Allocate at the lowest possible address.
+ */
+static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			      unsigned long size, unsigned long align,
+			      unsigned long *addr)
+{
+	unsigned long map_size, desc_size;
+	efi_memory_desc_t *map;
+	efi_status_t status;
+	unsigned long nr_pages;
+	int i;
+
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL, NULL);
+	if (status != EFI_SUCCESS)
+		goto fail;
+
+	/*
+	 * Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
+	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	for (i = 0; i < map_size / desc_size; i++) {
+		efi_memory_desc_t *desc;
+		unsigned long m = (unsigned long)map;
+		u64 start, end;
+
+		desc = (efi_memory_desc_t *)(m + (i * desc_size));
+
+		if (desc->type != EFI_CONVENTIONAL_MEMORY)
+			continue;
+
+		if (desc->num_pages < nr_pages)
+			continue;
+
+		start = desc->phys_addr;
+		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+
+		/*
+		 * Don't allocate at 0x0. It will confuse code that
+		 * checks pointers against NULL. Skip the first 8
+		 * bytes so we start at a nice even number.
+		 */
+		if (start == 0x0)
+			start += 8;
+
+		start = round_up(start, align);
+		if ((start + size) > end)
+			continue;
+
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					nr_pages, &start);
+		if (status == EFI_SUCCESS) {
+			*addr = start;
+			break;
+		}
+	}
+
+	if (i == map_size / desc_size)
+		status = EFI_NOT_FOUND;
+
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+fail:
+	return status;
+}
+
+static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+		     unsigned long addr)
+{
+	unsigned long nr_pages;
+
+	if (!size)
+		return;
+
+	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
+}
+
+
+/*
+ * Check the cmdline for a LILO-style file= arguments.
+ *
+ * We only support loading a file from the same filesystem as
+ * the kernel image.
+ */
+static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+					 efi_loaded_image_t *image,
+					 char *cmd_line, char *option_string,
+					 unsigned long max_addr,
+					 unsigned long *load_addr,
+					 unsigned long *load_size)
+{
+	struct file_info *files;
+	unsigned long file_addr;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	u64 file_size_total;
+	efi_file_io_interface_t *io;
+	efi_file_handle_t *fh;
+	efi_status_t status;
+	int nr_files;
+	char *str;
+	int i, j, k;
+
+	file_addr = 0;
+	file_size_total = 0;
+
+	str = cmd_line;
+
+	j = 0;			/* See close_handles */
+
+	if (!load_addr || !load_size)
+		return EFI_INVALID_PARAMETER;
+
+	*load_addr = 0;
+	*load_size = 0;
+
+	if (!str || !*str)
+		return EFI_SUCCESS;
+
+	for (nr_files = 0; *str; nr_files++) {
+		str = strstr(str, option_string);
+		if (!str)
+			break;
+
+		str += strlen(option_string);
+
+		/* Skip any leading slashes */
+		while (*str == '/' || *str == '\\')
+			str++;
+
+		while (*str && *str != ' ' && *str != '\n')
+			str++;
+	}
+
+	if (!nr_files)
+		return EFI_SUCCESS;
+
+	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
+				EFI_LOADER_DATA,
+				nr_files * sizeof(*files),
+				(void **)&files);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
+		goto fail;
+	}
+
+	str = cmd_line;
+	for (i = 0; i < nr_files; i++) {
+		struct file_info *file;
+		efi_file_handle_t *h;
+		efi_file_info_t *info;
+		efi_char16_t filename_16[256];
+		unsigned long info_sz;
+		efi_guid_t info_guid = EFI_FILE_INFO_ID;
+		efi_char16_t *p;
+		u64 file_sz;
+
+		str = strstr(str, option_string);
+		if (!str)
+			break;
+
+		str += strlen(option_string);
+
+		file = &files[i];
+		p = filename_16;
+
+		/* Skip any leading slashes */
+		while (*str == '/' || *str == '\\')
+			str++;
+
+		while (*str && *str != ' ' && *str != '\n') {
+			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
+				break;
+
+			if (*str == '/') {
+				*p++ = '\\';
+				str++;
+			} else {
+				*p++ = *str++;
+			}
+		}
+
+		*p = '\0';
+
+		/* Only open the volume once. */
+		if (!i) {
+			efi_boot_services_t *boottime;
+
+			boottime = sys_table_arg->boottime;
+
+			status = efi_call_phys3(boottime->handle_protocol,
+					image->device_handle, &fs_proto,
+						(void **)&io);
+			if (status != EFI_SUCCESS) {
+				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
+				goto free_files;
+			}
+
+			status = efi_call_phys2(io->open_volume, io, &fh);
+			if (status != EFI_SUCCESS) {
+				efi_printk(sys_table_arg, "Failed to open volume\n");
+				goto free_files;
+			}
+		}
+
+		status = efi_call_phys5(fh->open, fh, &h, filename_16,
+					EFI_FILE_MODE_READ, (u64)0);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table_arg, "Failed to open file: ");
+			efi_char16_printk(sys_table_arg, filename_16);
+			efi_printk(sys_table_arg, "\n");
+			goto close_handles;
+		}
+
+		file->handle = h;
+
+		info_sz = 0;
+		status = efi_call_phys4(h->get_info, h, &info_guid,
+					&info_sz, NULL);
+		if (status != EFI_BUFFER_TOO_SMALL) {
+			efi_printk(sys_table_arg, "Failed to get file info size\n");
+			goto close_handles;
+		}
+
+grow:
+		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
+					EFI_LOADER_DATA, info_sz,
+					(void **)&info);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
+			goto close_handles;
+		}
+
+		status = efi_call_phys4(h->get_info, h, &info_guid,
+					&info_sz, info);
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			efi_call_phys1(sys_table_arg->boottime->free_pool,
+				       info);
+			goto grow;
+		}
+
+		file_sz = info->file_size;
+		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
+
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table_arg, "Failed to get file info\n");
+			goto close_handles;
+		}
+
+		file->size = file_sz;
+		file_size_total += file_sz;
+	}
+
+	if (file_size_total) {
+		unsigned long addr;
+
+		/*
+		 * Multiple files need to be at consecutive addresses in memory,
+		 * so allocate enough memory for all the files.  This is used
+		 * for loading multiple files.
+		 */
+		status = efi_high_alloc(sys_table_arg, file_size_total, 0x1000,
+				    &file_addr, max_addr);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table_arg, "Failed to alloc highmem for files\n");
+			goto close_handles;
+		}
+
+		/* We've run out of free low memory. */
+		if (file_addr > max_addr) {
+			efi_printk(sys_table_arg, "We've run out of free low memory\n");
+			status = EFI_INVALID_PARAMETER;
+			goto free_file_total;
+		}
+
+		addr = file_addr;
+		for (j = 0; j < nr_files; j++) {
+			unsigned long size;
+
+			size = files[j].size;
+			while (size) {
+				unsigned long chunksize;
+				if (size > EFI_READ_CHUNK_SIZE)
+					chunksize = EFI_READ_CHUNK_SIZE;
+				else
+					chunksize = size;
+				status = efi_call_phys3(fh->read,
+							files[j].handle,
+							&chunksize,
+							(void *)addr);
+				if (status != EFI_SUCCESS) {
+					efi_printk(sys_table_arg, "Failed to read file\n");
+					goto free_file_total;
+				}
+				addr += chunksize;
+				size -= chunksize;
+			}
+
+			efi_call_phys1(fh->close, files[j].handle);
+		}
+
+	}
+
+	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+
+	*load_addr = file_addr;
+	*load_size = file_size_total;
+
+	return status;
+
+free_file_total:
+	efi_free(sys_table_arg, file_size_total, file_addr);
+
+close_handles:
+	for (k = j; k < i; k++)
+		efi_call_phys1(fh->close, files[k].handle);
+free_files:
+	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+fail:
+	*load_addr = 0;
+	*load_size = 0;
+
+	return status;
+}
+/*
+ * Relocate a kernel image, either compressed or uncompressed.
+ * In the ARM64 case, all kernel images are currently
+ * uncompressed, and as such when we relocate it we need to
+ * allocate additional space for the BSS segment. Any low
+ * memory that this function should avoid needs to be
+ * unavailable in the EFI memory map, as if the preferred
+ * address is not available the lowest available address will
+ * be used.
+ */
+static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+					unsigned long *image_addr,
+					unsigned long image_size,
+					unsigned long alloc_size,
+					unsigned long preferred_addr,
+					unsigned long alignment)
+{
+	unsigned long cur_image_addr;
+	unsigned long new_addr = 0;
+	efi_status_t status;
+	unsigned long nr_pages;
+	efi_physical_addr_t efi_addr = preferred_addr;
+
+	if (!image_addr || !image_size || !alloc_size)
+		return EFI_INVALID_PARAMETER;
+	if (alloc_size < image_size)
+		return EFI_INVALID_PARAMETER;
+
+	cur_image_addr = *image_addr;
+
+	/*
+	 * The EFI firmware loader could have placed the kernel image
+	 * anywhere in memory, but the kernel has restrictions on the
+	 * max physical address it can run at.  Some architectures
+	 * also have a prefered address, so first try to relocate
+	 * to the preferred address.  If that fails, allocate as low
+	 * as possible while respecting the required alignment.
+	 */
+	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &efi_addr);
+	new_addr = efi_addr;
+	/*
+	 * If preferred address allocation failed allocate as low as
+	 * possible.
+	 */
+	if (status != EFI_SUCCESS) {
+		status = efi_low_alloc(sys_table_arg, alloc_size, alignment,
+				       &new_addr);
+	}
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
+		return status;
+	}
+
+	/*
+	 * We know source/dest won't overlap since both memory ranges
+	 * have been allocated by UEFI, so we can safely use memcpy.
+	 */
+	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
+
+	/* Return the new address of the relocated image. */
+	*image_addr = new_addr;
+
+	return status;
+}
+
+/*
+ * Convert the unicode UEFI command line to ASCII to pass to kernel.
+ * Size of memory allocated return in *cmd_line_len.
+ * Returns NULL on error.
+ */
+static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
+				      efi_loaded_image_t *image,
+				      int *cmd_line_len)
+{
+	u16 *s2;
+	u8 *s1 = NULL;
+	unsigned long cmdline_addr = 0;
+	int load_options_size = image->load_options_size / 2; /* ASCII */
+	void *options = image->load_options;
+	int options_size = 0;
+	efi_status_t status;
+	int i;
+	u16 zero = 0;
+
+	if (options) {
+		s2 = options;
+		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
+			s2++;
+			options_size++;
+		}
+	}
+
+	if (options_size == 0) {
+		/* No command line options, so return empty string*/
+		options_size = 1;
+		options = &zero;
+	}
+
+	options_size++;  /* NUL termination */
+#ifdef CONFIG_ARM
+	/*
+	 * For ARM, allocate at a high address to avoid reserved
+	 * regions at low addresses that we don't know the specfics of
+	 * at the time we are processing the command line.
+	 */
+	status = efi_high_alloc(sys_table_arg, options_size, 0,
+			    &cmdline_addr, 0xfffff000);
+#else
+	status = efi_low_alloc(sys_table_arg, options_size, 0,
+			    &cmdline_addr);
+#endif
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	s1 = (u8 *)cmdline_addr;
+	s2 = (u16 *)options;
+
+	for (i = 0; i < options_size - 1; i++)
+		*s1++ = *s2++;
+
+	*s1 = '\0';
+
+	*cmd_line_len = options_size;
+	return (char *)cmdline_addr;
+}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5145fa3..2e2fbde 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -13,11 +13,27 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/io.h>
+
+struct efi __read_mostly efi = {
+	.mps        = EFI_INVALID_TABLE_ADDR,
+	.acpi       = EFI_INVALID_TABLE_ADDR,
+	.acpi20     = EFI_INVALID_TABLE_ADDR,
+	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.sal_systab = EFI_INVALID_TABLE_ADDR,
+	.boot_info  = EFI_INVALID_TABLE_ADDR,
+	.hcdp       = EFI_INVALID_TABLE_ADDR,
+	.uga        = EFI_INVALID_TABLE_ADDR,
+	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+};
+EXPORT_SYMBOL(efi);
 
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
@@ -132,3 +148,127 @@ err_put:
 }
 
 subsys_initcall(efisubsys_init);
+
+
+/*
+ * We can't ioremap data in EFI boot services RAM, because we've already mapped
+ * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
+ * callable after efi_enter_virtual_mode and before efi_free_boot_services.
+ */
+void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
+{
+	struct efi_memory_map *map;
+	void *p;
+	map = efi.memmap;
+	if (!map)
+		return NULL;
+	if (WARN_ON(!map->map))
+		return NULL;
+	for (p = map->map; p < map->map_end; p += map->desc_size) {
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 end = md->phys_addr + size;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		if (!md->virt_addr)
+			continue;
+		if (phys_addr >= md->phys_addr && phys_addr < end) {
+			phys_addr += md->virt_addr - md->phys_addr;
+			return (__force void __iomem *)(unsigned long)phys_addr;
+		}
+	}
+	return NULL;
+}
+
+static __initdata efi_config_table_type_t common_tables[] = {
+	{ACPI_20_TABLE_GUID, "ACPI 2.0", &efi.acpi20},
+	{ACPI_TABLE_GUID, "ACPI", &efi.acpi},
+	{HCDP_TABLE_GUID, "HCDP", &efi.hcdp},
+	{MPS_TABLE_GUID, "MPS", &efi.mps},
+	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
+	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
+	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
+	{NULL_GUID, NULL, 0},
+};
+
+static __init int match_config_table(efi_guid_t *guid,
+				     unsigned long table,
+				     efi_config_table_type_t *table_types)
+{
+	u8 str[EFI_VARIABLE_GUID_LEN + 1];
+	int i;
+
+	if (table_types) {
+		efi_guid_unparse(guid, str);
+
+		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
+			efi_guid_unparse(&table_types[i].guid, str);
+
+			if (!efi_guidcmp(*guid, table_types[i].guid)) {
+				*(table_types[i].ptr) = table;
+				pr_cont(" %s=0x%lx ",
+					table_types[i].name, table);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int __init efi_config_init(efi_config_table_type_t *arch_tables)
+{
+	void *config_tables, *tablep;
+	int i, sz;
+
+	if (efi_enabled(EFI_64BIT))
+		sz = sizeof(efi_config_table_64_t);
+	else
+		sz = sizeof(efi_config_table_32_t);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = early_memremap(efi.systab->tables,
+				       efi.systab->nr_tables * sz);
+	if (config_tables == NULL) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
+
+	tablep = config_tables;
+	pr_info("");
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+		unsigned long table;
+
+		if (efi_enabled(EFI_64BIT)) {
+			u64 table64;
+			guid = ((efi_config_table_64_t *)tablep)->guid;
+			table64 = ((efi_config_table_64_t *)tablep)->table;
+			table = table64;
+#ifndef CONFIG_64BIT
+			if (table64 >> 32) {
+				pr_cont("\n");
+				pr_err("Table located above 4GB, disabling EFI.\n");
+				early_iounmap(config_tables,
+					       efi.systab->nr_tables * sz);
+				return -EINVAL;
+			}
+#endif
+		} else {
+			guid = ((efi_config_table_32_t *)tablep)->guid;
+			table = ((efi_config_table_32_t *)tablep)->table;
+		}
+
+		if (!match_config_table(&guid, table, common_tables))
+			match_config_table(&guid, table, arch_tables);
+
+		tablep += sz;
+	}
+	pr_cont("\n");
+	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	return 0;
+}
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8a7432a..933eb02 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -564,7 +564,7 @@ static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
 	return 0;
 }
 
-void efivars_sysfs_exit(void)
+static void efivars_sysfs_exit(void)
 {
 	/* Remove all entries and destroy */
 	__efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list, NULL, NULL);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..bc5687d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -39,6 +39,8 @@
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
 typedef u16 efi_char16_t;		/* UNICODE character */
+typedef u64 efi_physical_addr_t;
+typedef void *efi_handle_t;
 
 
 typedef struct {
@@ -96,6 +98,7 @@ typedef	struct {
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
 #define EFI_PAGE_SHIFT		12
+#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 
 typedef struct {
 	u32 type;
@@ -157,11 +160,13 @@ typedef struct {
 	efi_table_hdr_t hdr;
 	void *raise_tpl;
 	void *restore_tpl;
-	void *allocate_pages;
-	void *free_pages;
-	void *get_memory_map;
-	void *allocate_pool;
-	void *free_pool;
+	efi_status_t (*allocate_pages)(int, int, unsigned long,
+				       efi_physical_addr_t *);
+	efi_status_t (*free_pages)(efi_physical_addr_t, unsigned long);
+	efi_status_t (*get_memory_map)(unsigned long *, void *, unsigned long *,
+				       unsigned long *, u32 *);
+	efi_status_t (*allocate_pool)(int, unsigned long, void **);
+	efi_status_t (*free_pool)(void *);
 	void *create_event;
 	void *set_timer;
 	void *wait_for_event;
@@ -171,7 +176,7 @@ typedef struct {
 	void *install_protocol_interface;
 	void *reinstall_protocol_interface;
 	void *uninstall_protocol_interface;
-	void *handle_protocol;
+	efi_status_t (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
 	void *__reserved;
 	void *register_protocol_notify;
 	void *locate_handle;
@@ -181,7 +186,7 @@ typedef struct {
 	void *start_image;
 	void *exit;
 	void *unload_image;
-	void *exit_boot_services;
+	efi_status_t (*exit_boot_services)(efi_handle_t, unsigned long);
 	void *get_next_monotonic_count;
 	void *stall;
 	void *set_watchdog_timer;
@@ -404,6 +409,12 @@ typedef struct {
 	unsigned long table;
 } efi_config_table_t;
 
+typedef struct {
+	efi_guid_t guid;
+	const char *name;
+	unsigned long *ptr;
+} efi_config_table_type_t;
+
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
 
 #define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
@@ -488,10 +499,6 @@ typedef struct {
 	unsigned long unload;
 } efi_loaded_image_t;
 
-typedef struct {
-	u64 revision;
-	void *open_volume;
-} efi_file_io_interface_t;
 
 typedef struct {
 	u64 size;
@@ -504,20 +511,30 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
-typedef struct {
+typedef struct _efi_file_handle {
 	u64 revision;
-	void *open;
-	void *close;
+	efi_status_t (*open)(struct _efi_file_handle *,
+			     struct _efi_file_handle **,
+			     efi_char16_t *, u64, u64);
+	efi_status_t (*close)(struct _efi_file_handle *);
 	void *delete;
-	void *read;
+	efi_status_t (*read)(struct _efi_file_handle *, unsigned long *,
+			     void *);
 	void *write;
 	void *get_position;
 	void *set_position;
-	void *get_info;
+	efi_status_t (*get_info)(struct _efi_file_handle *, efi_guid_t *,
+			unsigned long *, void *);
 	void *set_info;
 	void *flush;
 } efi_file_handle_t;
 
+typedef struct _efi_file_io_interface {
+	u64 revision;
+	int (*open_volume)(struct _efi_file_io_interface *,
+			   efi_file_handle_t **);
+} efi_file_io_interface_t;
+
 #define EFI_FILE_MODE_READ	0x0000000000000001
 #define EFI_FILE_MODE_WRITE	0x0000000000000002
 #define EFI_FILE_MODE_CREATE	0x8000000000000000
@@ -552,6 +569,7 @@ extern struct efi {
 	efi_get_next_high_mono_count_t *get_next_high_mono_count;
 	efi_reset_system_t *reset_system;
 	efi_set_virtual_address_map_t *set_virtual_address_map;
+	struct efi_memory_map *memmap;
 } efi;
 
 static inline int
@@ -587,6 +605,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
 }
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
+extern int efi_config_init(efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
@@ -784,6 +803,13 @@ struct efivar_entry {
 	struct kobject kobj;
 };
 
+
+struct efi_simple_text_output_protocol {
+	void *reset;
+	efi_status_t (*output_string)(void *, void *);
+	void *test_string;
+};
+
 extern struct list_head efivar_sysfs_list;
 
 static inline void
