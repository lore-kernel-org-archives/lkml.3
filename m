Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3KKS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:27:19 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63697 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3KKS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:27:06 -0500
Date: Mon, 11 Nov 2013 19:27:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 RAS changes for v3.13
Message-ID: <20131111182701.GA15855@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mce-for-linus

   # HEAD: 9ebddac7ea2a1f4b4ce3335a78312a58dfaadb4d ACPI, x86: Fix extended error log driver to depend on CONFIG_X86_LOCAL_APIC

The biggest change adds support for Intel 'CPER' (UEFI Common Platform 
Error Record) error logging, which builds upon an enhanced error logging 
mechanism available on Xeon processors.
    
Full description is here:
        
  http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html
    
This change provides a module (and support code) to check for an extended 
error log and prints extra details about the error on the console.

  out-of-topic modifications in x86-mce-for-linus:
  --------------------------------------------------
  arch/ia64/kernel/setup.c           # dd6dad4: DMI: Parse memory device (type 17
  drivers/acpi/Kconfig               # 9ebddac: ACPI, x86: Fix extended error log
                                   # 7ea6c6c: Move cper.c from drivers/acpi/ape
                                   # 4b3db70: ACPI, x86: Extended error log dri
  drivers/acpi/Makefile              # 4b3db70: ACPI, x86: Extended error log dri
  drivers/acpi/acpi_extlog.c         # 4b3db70: ACPI, x86: Extended error log dri
  drivers/acpi/apei/Kconfig          # 7ea6c6c: Move cper.c from drivers/acpi/ape
  drivers/acpi/apei/Makefile         # 7ea6c6c: Move cper.c from drivers/acpi/ape
  drivers/acpi/apei/apei-internal.h  # 88f074f: ACPI, CPER: Update cper info
  drivers/acpi/apei/cper.c           # 7ea6c6c: Move cper.c from drivers/acpi/ape
                                   # f6edea7: ACPI, APEI, CPER: Cleanup CPER me
                                   # fbeef85: ACPI, APEI, CPER: Enhance memory 
                                   # 147de14: ACPI, APEI, CPER: Add UEFI 2.4 su
                                   # 88f074f: ACPI, CPER: Update cper info
                                   # 833ba4b: ACPI, APEI, CPER: Fix status chec
  drivers/acpi/apei/ghes.c           # 147de14: ACPI, APEI, CPER: Add UEFI 2.4 su
                                   # 88f074f: ACPI, CPER: Update cper info
  drivers/acpi/bus.c                 # 4b3db70: ACPI, x86: Extended error log dri
  drivers/edac/amd64_edac.c          # 10ef6b0: bitops: Introduce a more generic 
  drivers/edac/amd64_edac.h          # 10ef6b0: bitops: Introduce a more generic 
  drivers/edac/ghes_edac.c           # 5650769: EDAC, GHES: Update ghes error rec
                                   # 147de14: ACPI, APEI, CPER: Add UEFI 2.4 su
  drivers/edac/sb_edac.c             # 10ef6b0: bitops: Introduce a more generic 
  drivers/firmware/dmi_scan.c        # 0841c04: dmi: Avoid unaligned memory acces
                                   # dd6dad4: DMI: Parse memory device (type 17
  drivers/firmware/efi/Kconfig       # 7ea6c6c: Move cper.c from drivers/acpi/ape
  drivers/firmware/efi/Makefile      # 7ea6c6c: Move cper.c from drivers/acpi/ape
  drivers/firmware/efi/cper.c        # 7ea6c6c: Move cper.c from drivers/acpi/ape
  drivers/video/sis/init.c           # 10ef6b0: bitops: Introduce a more generic 
  include/acpi/actbl1.h              # 88f074f: ACPI, CPER: Update cper info
  include/acpi/ghes.h                # 88f074f: ACPI, CPER: Update cper info
  include/linux/acpi.h               # 4b3db70: ACPI, x86: Extended error log dri
  include/linux/bitops.h             # 10ef6b0: bitops: Introduce a more generic 
  include/linux/cper.h               # 147de14: ACPI, APEI, CPER: Add UEFI 2.4 su
                                   # 88f074f: ACPI, CPER: Update cper info
  include/linux/dmi.h                # dd6dad4: DMI: Parse memory device (type 17
  include/linux/edac.h               # 5650769: EDAC, GHES: Update ghes error rec

 Thanks,

	Ingo

------------------>
Chen, Gong (9):
      ACPI, APEI, CPER: Fix status check during error printing
      ACPI, CPER: Update cper info
      bitops: Introduce a more generic BITMASK macro
      ACPI, x86: Extended error log driver for x86 platform
      DMI: Parse memory device (type 17) in SMBIOS
      ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
      ACPI, APEI, CPER: Enhance memory reporting capability
      ACPI, APEI, CPER: Cleanup CPER memory error output format
      EDAC, GHES: Update ghes error record info

Tony Luck (3):
      Move cper.c from drivers/acpi/apei to drivers/firmware/efi
      dmi: Avoid unaligned memory access in save_mem_devices()
      ACPI, x86: Fix extended error log driver to depend on CONFIG_X86_LOCAL_APIC


 arch/ia64/kernel/setup.c                   |   1 +
 arch/x86/include/asm/mce.h                 |   1 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c      |   3 +-
 arch/x86/kernel/setup.c                    |   1 +
 drivers/acpi/Kconfig                       |  21 ++
 drivers/acpi/Makefile                      |   2 +
 drivers/acpi/acpi_extlog.c                 | 327 +++++++++++++++++++++++++++++
 drivers/acpi/apei/Kconfig                  |   2 +
 drivers/acpi/apei/Makefile                 |   2 +-
 drivers/acpi/apei/apei-internal.h          |  12 +-
 drivers/acpi/apei/ghes.c                   |  58 ++---
 drivers/acpi/bus.c                         |   3 +-
 drivers/edac/amd64_edac.c                  |  46 ++--
 drivers/edac/amd64_edac.h                  |   8 -
 drivers/edac/ghes_edac.c                   |  16 +-
 drivers/edac/sb_edac.c                     |   2 +-
 drivers/firmware/dmi_scan.c                |  61 ++++++
 drivers/firmware/efi/Kconfig               |   3 +
 drivers/firmware/efi/Makefile              |   1 +
 drivers/{acpi/apei => firmware/efi}/cper.c | 132 ++++++------
 drivers/video/sis/init.c                   |   5 +-
 include/acpi/actbl1.h                      |  14 +-
 include/acpi/ghes.h                        |   2 +-
 include/linux/acpi.h                       |   1 +
 include/linux/bitops.h                     |   8 +
 include/linux/cper.h                       |  13 +-
 include/linux/dmi.h                        |   5 +
 include/linux/edac.h                       |   2 +-
 28 files changed, 602 insertions(+), 150 deletions(-)
 create mode 100644 drivers/acpi/acpi_extlog.c
 rename drivers/{acpi/apei => firmware/efi}/cper.c (76%)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 4fc2e95..d86669b 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1063,6 +1063,7 @@ check_bugs (void)
 static int __init run_dmi_scan(void)
 {
 	dmi_scan_machine();
+	dmi_memdev_walk();
 	dmi_set_dump_stack_arch_desc();
 	return 0;
 }
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index cbe6b9e..c696a86 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -16,6 +16,7 @@
 #define MCG_EXT_CNT_SHIFT	16
 #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
 #define MCG_SER_P		(1ULL<<24)   /* MCA recovery/new status bits */
+#define MCG_ELOG_P		(1ULL<<26)   /* Extended error log supported */
 
 /* MCG_STATUS register defines */
 #define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-apei.c b/arch/x86/kernel/cpu/mcheck/mce-apei.c
index cd8b166..de8b60a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -42,8 +42,7 @@ void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
 	struct mce m;
 
 	/* Only corrected MC is reported */
-	if (!corrected || !(mem_err->validation_bits &
-				CPER_MEM_VALID_PHYSICAL_ADDRESS))
+	if (!corrected || !(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
 
 	mce_setup(&m);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..918d489 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -993,6 +993,7 @@ void __init setup_arch(char **cmdline_p)
 		efi_init();
 
 	dmi_scan_machine();
+	dmi_memdev_walk();
 	dmi_set_dump_stack_arch_desc();
 
 	/*
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 6efe2ac..e11faae 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -372,4 +372,25 @@ config ACPI_BGRT
 
 source "drivers/acpi/apei/Kconfig"
 
+config ACPI_EXTLOG
+	tristate "Extended Error Log support"
+	depends on X86_MCE && X86_LOCAL_APIC
+	select EFI
+	select UEFI_CPER
+	default n
+	help
+	  Certain usages such as Predictive Failure Analysis (PFA) require
+	  more information about the error than what can be described in
+	  processor machine check banks. Most server processors log
+	  additional information about the error in processor uncore
+	  registers. Since the addresses and layout of these registers vary
+	  widely from one processor to another, system software cannot
+	  readily make use of them. To complicate matters further, some of
+	  the additional error information cannot be constructed without
+	  detailed knowledge about platform topology.
+
+	  Enhanced MCA Logging allows firmware to provide additional error
+	  information to system software, synchronous with MCE or CMCI. This
+	  driver adds support for that functionality.
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index cdaf68b..bce34af 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -82,3 +82,5 @@ processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
 obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
+
+obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
new file mode 100644
index 0000000..a6869e1
--- /dev/null
+++ b/drivers/acpi/acpi_extlog.c
@@ -0,0 +1,327 @@
+/*
+ * Extended Error Log driver
+ *
+ * Copyright (C) 2013 Intel Corp.
+ * Author: Chen, Gong <gong.chen@intel.com>
+ *
+ * This file is licensed under GPLv2.
+ */
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <linux/cper.h>
+#include <linux/ratelimit.h>
+#include <asm/cpu.h>
+#include <asm/mce.h>
+
+#include "apei/apei-internal.h"
+
+#define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(51, 0) /* elog entry address mask */
+
+#define EXTLOG_DSM_REV		0x0
+#define	EXTLOG_FN_QUERY		0x0
+#define	EXTLOG_FN_ADDR		0x1
+
+#define FLAG_OS_OPTIN		BIT(0)
+#define EXTLOG_QUERY_L1_EXIST	BIT(1)
+#define ELOG_ENTRY_VALID	(1ULL<<63)
+#define ELOG_ENTRY_LEN		0x1000
+
+#define EMCA_BUG \
+	"Can not request iomem region <0x%016llx-0x%016llx> - eMCA disabled\n"
+
+struct extlog_l1_head {
+	u32 ver;	/* Header Version */
+	u32 hdr_len;	/* Header Length */
+	u64 total_len;	/* entire L1 Directory length including this header */
+	u64 elog_base;	/* MCA Error Log Directory base address */
+	u64 elog_len;	/* MCA Error Log Directory length */
+	u32 flags;	/* bit 0 - OS/VMM Opt-in */
+	u8  rev0[12];
+	u32 entries;	/* Valid L1 Directory entries per logical processor */
+	u8  rev1[12];
+};
+
+static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
+
+/* L1 table related physical address */
+static u64 elog_base;
+static size_t elog_size;
+static u64 l1_dirbase;
+static size_t l1_size;
+
+/* L1 table related virtual address */
+static void __iomem *extlog_l1_addr;
+static void __iomem *elog_addr;
+
+static void *elog_buf;
+
+static u64 *l1_entry_base;
+static u32 l1_percpu_entry;
+
+#define ELOG_IDX(cpu, bank) \
+	(cpu_physical_id(cpu) * l1_percpu_entry + (bank))
+
+#define ELOG_ENTRY_DATA(idx) \
+	(*(l1_entry_base + (idx)))
+
+#define ELOG_ENTRY_ADDR(phyaddr) \
+	(phyaddr - elog_base + (u8 *)elog_addr)
+
+static struct acpi_generic_status *extlog_elog_entry_check(int cpu, int bank)
+{
+	int idx;
+	u64 data;
+	struct acpi_generic_status *estatus;
+
+	WARN_ON(cpu < 0);
+	idx = ELOG_IDX(cpu, bank);
+	data = ELOG_ENTRY_DATA(idx);
+	if ((data & ELOG_ENTRY_VALID) == 0)
+		return NULL;
+
+	data &= EXT_ELOG_ENTRY_MASK;
+	estatus = (struct acpi_generic_status *)ELOG_ENTRY_ADDR(data);
+
+	/* if no valid data in elog entry, just return */
+	if (estatus->block_status == 0)
+		return NULL;
+
+	return estatus;
+}
+
+static void __print_extlog_rcd(const char *pfx,
+			       struct acpi_generic_status *estatus, int cpu)
+{
+	static atomic_t seqno;
+	unsigned int curr_seqno;
+	char pfx_seq[64];
+
+	if (!pfx) {
+		if (estatus->error_severity <= CPER_SEV_CORRECTED)
+			pfx = KERN_INFO;
+		else
+			pfx = KERN_ERR;
+	}
+	curr_seqno = atomic_inc_return(&seqno);
+	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}", pfx, curr_seqno);
+	printk("%s""Hardware error detected on CPU%d\n", pfx_seq, cpu);
+	cper_estatus_print(pfx_seq, estatus);
+}
+
+static int print_extlog_rcd(const char *pfx,
+			    struct acpi_generic_status *estatus, int cpu)
+{
+	/* Not more than 2 messages every 5 seconds */
+	static DEFINE_RATELIMIT_STATE(ratelimit_corrected, 5*HZ, 2);
+	static DEFINE_RATELIMIT_STATE(ratelimit_uncorrected, 5*HZ, 2);
+	struct ratelimit_state *ratelimit;
+
+	if (estatus->error_severity == CPER_SEV_CORRECTED ||
+	    (estatus->error_severity == CPER_SEV_INFORMATIONAL))
+		ratelimit = &ratelimit_corrected;
+	else
+		ratelimit = &ratelimit_uncorrected;
+	if (__ratelimit(ratelimit)) {
+		__print_extlog_rcd(pfx, estatus, cpu);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int extlog_print(struct notifier_block *nb, unsigned long val,
+			void *data)
+{
+	struct mce *mce = (struct mce *)data;
+	int	bank = mce->bank;
+	int	cpu = mce->extcpu;
+	struct acpi_generic_status *estatus;
+	int rc;
+
+	estatus = extlog_elog_entry_check(cpu, bank);
+	if (estatus == NULL)
+		return NOTIFY_DONE;
+
+	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
+	/* clear record status to enable BIOS to update it again */
+	estatus->block_status = 0;
+
+	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
+
+	return NOTIFY_DONE;
+}
+
+static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
+{
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	struct acpi_object_list input;
+	union acpi_object params[4], *obj;
+	u8 uuid[16];
+	int i;
+
+	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
+	input.count = 4;
+	input.pointer = params;
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = 16;
+	params[0].buffer.pointer = uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = rev;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = func;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
+		return -1;
+
+	*ret = 0;
+	obj = (union acpi_object *)buf.pointer;
+	if (obj->type == ACPI_TYPE_INTEGER) {
+		*ret = obj->integer.value;
+	} else if (obj->type == ACPI_TYPE_BUFFER) {
+		if (obj->buffer.length <= 8) {
+			for (i = 0; i < obj->buffer.length; i++)
+				*ret |= (obj->buffer.pointer[i] << (i * 8));
+		}
+	}
+	kfree(buf.pointer);
+
+	return 0;
+}
+
+static bool extlog_get_l1addr(void)
+{
+	acpi_handle handle;
+	u64 ret;
+
+	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
+		return false;
+
+	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
+	    !(ret & EXTLOG_QUERY_L1_EXIST))
+		return false;
+
+	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_ADDR, &ret))
+		return false;
+
+	l1_dirbase = ret;
+	/* Spec says L1 directory must be 4K aligned, bail out if it isn't */
+	if (l1_dirbase & ((1 << 12) - 1)) {
+		pr_warn(FW_BUG "L1 Directory is invalid at physical %llx\n",
+			l1_dirbase);
+		return false;
+	}
+
+	return true;
+}
+static struct notifier_block extlog_mce_dec = {
+	.notifier_call	= extlog_print,
+};
+
+static int __init extlog_init(void)
+{
+	struct extlog_l1_head *l1_head;
+	void __iomem *extlog_l1_hdr;
+	size_t l1_hdr_size;
+	struct resource *r;
+	u64 cap;
+	int rc;
+
+	rc = -ENODEV;
+
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	if (!(cap & MCG_ELOG_P))
+		return rc;
+
+	if (!extlog_get_l1addr())
+		return rc;
+
+	rc = -EINVAL;
+	/* get L1 header to fetch necessary information */
+	l1_hdr_size = sizeof(struct extlog_l1_head);
+	r = request_mem_region(l1_dirbase, l1_hdr_size, "L1 DIR HDR");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)l1_dirbase,
+			(unsigned long long)l1_dirbase + l1_hdr_size);
+		goto err;
+	}
+
+	extlog_l1_hdr = acpi_os_map_memory(l1_dirbase, l1_hdr_size);
+	l1_head = (struct extlog_l1_head *)extlog_l1_hdr;
+	l1_size = l1_head->total_len;
+	l1_percpu_entry = l1_head->entries;
+	elog_base = l1_head->elog_base;
+	elog_size = l1_head->elog_len;
+	acpi_os_unmap_memory(extlog_l1_hdr, l1_hdr_size);
+	release_mem_region(l1_dirbase, l1_hdr_size);
+
+	/* remap L1 header again based on completed information */
+	r = request_mem_region(l1_dirbase, l1_size, "L1 Table");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)l1_dirbase,
+			(unsigned long long)l1_dirbase + l1_size);
+		goto err;
+	}
+	extlog_l1_addr = acpi_os_map_memory(l1_dirbase, l1_size);
+	l1_entry_base = (u64 *)((u8 *)extlog_l1_addr + l1_hdr_size);
+
+	/* remap elog table */
+	r = request_mem_region(elog_base, elog_size, "Elog Table");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)elog_base,
+			(unsigned long long)elog_base + elog_size);
+		goto err_release_l1_dir;
+	}
+	elog_addr = acpi_os_map_memory(elog_base, elog_size);
+
+	rc = -ENOMEM;
+	/* allocate buffer to save elog record */
+	elog_buf = kmalloc(ELOG_ENTRY_LEN, GFP_KERNEL);
+	if (elog_buf == NULL)
+		goto err_release_elog;
+
+	mce_register_decode_chain(&extlog_mce_dec);
+	/* enable OS to be involved to take over management from BIOS */
+	((struct extlog_l1_head *)extlog_l1_addr)->flags |= FLAG_OS_OPTIN;
+
+	return 0;
+
+err_release_elog:
+	if (elog_addr)
+		acpi_os_unmap_memory(elog_addr, elog_size);
+	release_mem_region(elog_base, elog_size);
+err_release_l1_dir:
+	if (extlog_l1_addr)
+		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+	release_mem_region(l1_dirbase, l1_size);
+err:
+	pr_warn(FW_BUG "Extended error log disabled because of problems parsing f/w tables\n");
+	return rc;
+}
+
+static void __exit extlog_exit(void)
+{
+	mce_unregister_decode_chain(&extlog_mce_dec);
+	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
+	if (extlog_l1_addr)
+		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+	if (elog_addr)
+		acpi_os_unmap_memory(elog_addr, elog_size);
+	release_mem_region(elog_base, elog_size);
+	release_mem_region(l1_dirbase, l1_size);
+	kfree(elog_buf);
+}
+
+module_init(extlog_init);
+module_exit(extlog_exit);
+
+MODULE_AUTHOR("Chen, Gong <gong.chen@intel.com>");
+MODULE_DESCRIPTION("Extended MCA Error Log Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index f0c1ce9..786294b 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -2,6 +2,8 @@ config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
+	select EFI
+	select UEFI_CPER
 	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index d1d1bc0..5d575a9 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
 
-apei-y := apei-base.o hest.o cper.o erst.o
+apei-y := apei-base.o hest.o erst.o
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index f220d64..21ba34a 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -122,11 +122,11 @@ struct dentry;
 struct dentry *apei_get_debugfs_dir(void);
 
 #define apei_estatus_for_each_section(estatus, section)			\
-	for (section = (struct acpi_hest_generic_data *)(estatus + 1);	\
+	for (section = (struct acpi_generic_data *)(estatus + 1);	\
 	     (void *)section - (void *)estatus < estatus->data_length;	\
 	     section = (void *)(section+1) + section->error_data_length)
 
-static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
+static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
 {
 	if (estatus->raw_data_length)
 		return estatus->raw_data_offset + \
@@ -135,10 +135,10 @@ static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
 		return sizeof(*estatus) + estatus->data_length;
 }
 
-void apei_estatus_print(const char *pfx,
-			const struct acpi_hest_generic_status *estatus);
-int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
-int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
+void cper_estatus_print(const char *pfx,
+			const struct acpi_generic_status *estatus);
+int cper_estatus_check_header(const struct acpi_generic_status *estatus);
+int cper_estatus_check(const struct acpi_generic_status *estatus);
 
 int apei_osc_setup(void);
 #endif
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 8ec37bb..a30bc31 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -75,13 +75,13 @@
 #define GHES_ESTATUS_CACHE_LEN(estatus_len)			\
 	(sizeof(struct ghes_estatus_cache) + (estatus_len))
 #define GHES_ESTATUS_FROM_CACHE(estatus_cache)			\
-	((struct acpi_hest_generic_status *)			\
+	((struct acpi_generic_status *)				\
 	 ((struct ghes_estatus_cache *)(estatus_cache) + 1))
 
 #define GHES_ESTATUS_NODE_LEN(estatus_len)			\
 	(sizeof(struct ghes_estatus_node) + (estatus_len))
-#define GHES_ESTATUS_FROM_NODE(estatus_node)				\
-	((struct acpi_hest_generic_status *)				\
+#define GHES_ESTATUS_FROM_NODE(estatus_node)			\
+	((struct acpi_generic_status *)				\
 	 ((struct ghes_estatus_node *)(estatus_node) + 1))
 
 bool ghes_disable;
@@ -378,17 +378,17 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 	ghes->flags |= GHES_TO_CLEAR;
 
 	rc = -EIO;
-	len = apei_estatus_len(ghes->estatus);
+	len = cper_estatus_len(ghes->estatus);
 	if (len < sizeof(*ghes->estatus))
 		goto err_read_block;
 	if (len > ghes->generic->error_block_length)
 		goto err_read_block;
-	if (apei_estatus_check_header(ghes->estatus))
+	if (cper_estatus_check_header(ghes->estatus))
 		goto err_read_block;
 	ghes_copy_tofrom_phys(ghes->estatus + 1,
 			      buf_paddr + sizeof(*ghes->estatus),
 			      len - sizeof(*ghes->estatus), 1);
-	if (apei_estatus_check(ghes->estatus))
+	if (cper_estatus_check(ghes->estatus))
 		goto err_read_block;
 	rc = 0;
 
@@ -409,7 +409,7 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
-static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
+static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
 {
 #ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
 	unsigned long pfn;
@@ -419,7 +419,7 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 
 	if (sec_sev == GHES_SEV_CORRECTED &&
 	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
-	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
+	    (mem_err->validation_bits & CPER_MEM_VALID_PA)) {
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		if (pfn_valid(pfn))
 			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
@@ -430,7 +430,7 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	}
 	if (sev == GHES_SEV_RECOVERABLE &&
 	    sec_sev == GHES_SEV_RECOVERABLE &&
-	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+	    mem_err->validation_bits & CPER_MEM_VALID_PA) {
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		memory_failure_queue(pfn, 0, 0);
 	}
@@ -438,10 +438,10 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 }
 
 static void ghes_do_proc(struct ghes *ghes,
-			 const struct acpi_hest_generic_status *estatus)
+			 const struct acpi_generic_status *estatus)
 {
 	int sev, sec_sev;
-	struct acpi_hest_generic_data *gdata;
+	struct acpi_generic_data *gdata;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
@@ -496,7 +496,7 @@ static void ghes_do_proc(struct ghes *ghes,
 
 static void __ghes_print_estatus(const char *pfx,
 				 const struct acpi_hest_generic *generic,
-				 const struct acpi_hest_generic_status *estatus)
+				 const struct acpi_generic_status *estatus)
 {
 	static atomic_t seqno;
 	unsigned int curr_seqno;
@@ -513,12 +513,12 @@ static void __ghes_print_estatus(const char *pfx,
 	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}" HW_ERR, pfx, curr_seqno);
 	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
 	       pfx_seq, generic->header.source_id);
-	apei_estatus_print(pfx_seq, estatus);
+	cper_estatus_print(pfx_seq, estatus);
 }
 
 static int ghes_print_estatus(const char *pfx,
 			      const struct acpi_hest_generic *generic,
-			      const struct acpi_hest_generic_status *estatus)
+			      const struct acpi_generic_status *estatus)
 {
 	/* Not more than 2 messages every 5 seconds */
 	static DEFINE_RATELIMIT_STATE(ratelimit_corrected, 5*HZ, 2);
@@ -540,15 +540,15 @@ static int ghes_print_estatus(const char *pfx,
  * GHES error status reporting throttle, to report more kinds of
  * errors, instead of just most frequently occurred errors.
  */
-static int ghes_estatus_cached(struct acpi_hest_generic_status *estatus)
+static int ghes_estatus_cached(struct acpi_generic_status *estatus)
 {
 	u32 len;
 	int i, cached = 0;
 	unsigned long long now;
 	struct ghes_estatus_cache *cache;
-	struct acpi_hest_generic_status *cache_estatus;
+	struct acpi_generic_status *cache_estatus;
 
-	len = apei_estatus_len(estatus);
+	len = cper_estatus_len(estatus);
 	rcu_read_lock();
 	for (i = 0; i < GHES_ESTATUS_CACHES_SIZE; i++) {
 		cache = rcu_dereference(ghes_estatus_caches[i]);
@@ -571,19 +571,19 @@ static int ghes_estatus_cached(struct acpi_hest_generic_status *estatus)
 
 static struct ghes_estatus_cache *ghes_estatus_cache_alloc(
 	struct acpi_hest_generic *generic,
-	struct acpi_hest_generic_status *estatus)
+	struct acpi_generic_status *estatus)
 {
 	int alloced;
 	u32 len, cache_len;
 	struct ghes_estatus_cache *cache;
-	struct acpi_hest_generic_status *cache_estatus;
+	struct acpi_generic_status *cache_estatus;
 
 	alloced = atomic_add_return(1, &ghes_estatus_cache_alloced);
 	if (alloced > GHES_ESTATUS_CACHE_ALLOCED_MAX) {
 		atomic_dec(&ghes_estatus_cache_alloced);
 		return NULL;
 	}
-	len = apei_estatus_len(estatus);
+	len = cper_estatus_len(estatus);
 	cache_len = GHES_ESTATUS_CACHE_LEN(len);
 	cache = (void *)gen_pool_alloc(ghes_estatus_pool, cache_len);
 	if (!cache) {
@@ -603,7 +603,7 @@ static void ghes_estatus_cache_free(struct ghes_estatus_cache *cache)
 {
 	u32 len;
 
-	len = apei_estatus_len(GHES_ESTATUS_FROM_CACHE(cache));
+	len = cper_estatus_len(GHES_ESTATUS_FROM_CACHE(cache));
 	len = GHES_ESTATUS_CACHE_LEN(len);
 	gen_pool_free(ghes_estatus_pool, (unsigned long)cache, len);
 	atomic_dec(&ghes_estatus_cache_alloced);
@@ -619,7 +619,7 @@ static void ghes_estatus_cache_rcu_free(struct rcu_head *head)
 
 static void ghes_estatus_cache_add(
 	struct acpi_hest_generic *generic,
-	struct acpi_hest_generic_status *estatus)
+	struct acpi_generic_status *estatus)
 {
 	int i, slot = -1, count;
 	unsigned long long now, duration, period, max_period = 0;
@@ -751,7 +751,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 	struct llist_node *llnode, *next;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic *generic;
-	struct acpi_hest_generic_status *estatus;
+	struct acpi_generic_status *estatus;
 	u32 len, node_len;
 
 	llnode = llist_del_all(&ghes_estatus_llist);
@@ -765,7 +765,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
 					   llnode);
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
-		len = apei_estatus_len(estatus);
+		len = cper_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
 		ghes_do_proc(estatus_node->ghes, estatus);
 		if (!ghes_estatus_cached(estatus)) {
@@ -784,7 +784,7 @@ static void ghes_print_queued_estatus(void)
 	struct llist_node *llnode;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic *generic;
-	struct acpi_hest_generic_status *estatus;
+	struct acpi_generic_status *estatus;
 	u32 len, node_len;
 
 	llnode = llist_del_all(&ghes_estatus_llist);
@@ -797,7 +797,7 @@ static void ghes_print_queued_estatus(void)
 		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
 					   llnode);
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
-		len = apei_estatus_len(estatus);
+		len = cper_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
 		generic = estatus_node->generic;
 		ghes_print_estatus(NULL, generic, estatus);
@@ -843,7 +843,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 #ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 		u32 len, node_len;
 		struct ghes_estatus_node *estatus_node;
-		struct acpi_hest_generic_status *estatus;
+		struct acpi_generic_status *estatus;
 #endif
 		if (!(ghes->flags & GHES_TO_CLEAR))
 			continue;
@@ -851,7 +851,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		if (ghes_estatus_cached(ghes->estatus))
 			goto next;
 		/* Save estatus for further processing in IRQ context */
-		len = apei_estatus_len(ghes->estatus);
+		len = cper_estatus_len(ghes->estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
 		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
 						      node_len);
@@ -923,7 +923,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 
 	rc = -EIO;
 	if (generic->error_block_length <
-	    sizeof(struct acpi_hest_generic_status)) {
+	    sizeof(struct acpi_generic_status)) {
 		pr_warning(FW_BUG GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
 			   generic->error_block_length,
 			   generic->header.source_id);
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index b587ec8..e1bd9a1 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -174,7 +174,7 @@ static void acpi_print_osc_error(acpi_handle handle,
 	printk("\n");
 }
 
-static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
+acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 {
 	int i;
 	static int opc_map_to_uuid[16] = {6, 4, 2, 0, 11, 9, 16, 14, 19, 21,
@@ -195,6 +195,7 @@ static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 	}
 	return AE_OK;
 }
+EXPORT_SYMBOL_GPL(acpi_str_to_uuid);
 
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 {
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3c9e4e9..b53d0de 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -339,8 +339,8 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow];
-		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
-		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
+		base_bits	= GENMASK_ULL(31, 21) | GENMASK_ULL(15, 9);
+		mask_bits	= GENMASK_ULL(29, 21) | GENMASK_ULL(15, 9);
 		addr_shift	= 4;
 
 	/*
@@ -352,16 +352,16 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		csbase          = pvt->csels[dct].csbases[csrow];
 		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
 
-		*base  = (csbase & GENMASK(5,  15)) << 6;
-		*base |= (csbase & GENMASK(19, 30)) << 8;
+		*base  = (csbase & GENMASK_ULL(15,  5)) << 6;
+		*base |= (csbase & GENMASK_ULL(30, 19)) << 8;
 
 		*mask = ~0ULL;
 		/* poke holes for the csmask */
-		*mask &= ~((GENMASK(5, 15)  << 6) |
-			   (GENMASK(19, 30) << 8));
+		*mask &= ~((GENMASK_ULL(15, 5)  << 6) |
+			   (GENMASK_ULL(30, 19) << 8));
 
-		*mask |= (csmask & GENMASK(5, 15))  << 6;
-		*mask |= (csmask & GENMASK(19, 30)) << 8;
+		*mask |= (csmask & GENMASK_ULL(15, 5))  << 6;
+		*mask |= (csmask & GENMASK_ULL(30, 19)) << 8;
 
 		return;
 	} else {
@@ -370,9 +370,11 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		addr_shift	= 8;
 
 		if (pvt->fam == 0x15)
-			base_bits = mask_bits = GENMASK(19,30) | GENMASK(5,13);
+			base_bits = mask_bits =
+				GENMASK_ULL(30,19) | GENMASK_ULL(13,5);
 		else
-			base_bits = mask_bits = GENMASK(19,28) | GENMASK(5,13);
+			base_bits = mask_bits =
+				GENMASK_ULL(28,19) | GENMASK_ULL(13,5);
 	}
 
 	*base  = (csbase & base_bits) << addr_shift;
@@ -561,7 +563,7 @@ static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
 	 * section 3.4.2 of AMD publication 24592: AMD x86-64 Architecture
 	 * Programmer's Manual Volume 1 Application Programming.
 	 */
-	dram_addr = (sys_addr & GENMASK(0, 39)) - dram_base;
+	dram_addr = (sys_addr & GENMASK_ULL(39, 0)) - dram_base;
 
 	edac_dbg(2, "using DRAM Base register to translate SysAddr 0x%lx to DramAddr 0x%lx\n",
 		 (unsigned long)sys_addr, (unsigned long)dram_addr);
@@ -597,7 +599,7 @@ static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
 	 * concerning translating a DramAddr to an InputAddr.
 	 */
 	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
-	input_addr = ((dram_addr >> intlv_shift) & GENMASK(12, 35)) +
+	input_addr = ((dram_addr >> intlv_shift) & GENMASK_ULL(35, 12)) +
 		      (dram_addr & 0xfff);
 
 	edac_dbg(2, "  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
@@ -849,7 +851,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 		end_bit   = 39;
 	}
 
-	addr = m->addr & GENMASK(start_bit, end_bit);
+	addr = m->addr & GENMASK_ULL(end_bit, start_bit);
 
 	/*
 	 * Erratum 637 workaround
@@ -861,7 +863,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 		u16 mce_nid;
 		u8 intlv_en;
 
-		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
+		if ((addr & GENMASK_ULL(47, 24)) >> 24 != 0x00fdf7)
 			return addr;
 
 		mce_nid	= amd_get_nb_id(m->extcpu);
@@ -871,7 +873,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 		intlv_en = tmp >> 21 & 0x7;
 
 		/* add [47:27] + 3 trailing bits */
-		cc6_base  = (tmp & GENMASK(0, 20)) << 3;
+		cc6_base  = (tmp & GENMASK_ULL(20, 0)) << 3;
 
 		/* reverse and add DramIntlvEn */
 		cc6_base |= intlv_en ^ 0x7;
@@ -880,18 +882,18 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 		cc6_base <<= 24;
 
 		if (!intlv_en)
-			return cc6_base | (addr & GENMASK(0, 23));
+			return cc6_base | (addr & GENMASK_ULL(23, 0));
 
 		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_BASE, &tmp);
 
 							/* faster log2 */
-		tmp_addr  = (addr & GENMASK(12, 23)) << __fls(intlv_en + 1);
+		tmp_addr  = (addr & GENMASK_ULL(23, 12)) << __fls(intlv_en + 1);
 
 		/* OR DramIntlvSel into bits [14:12] */
-		tmp_addr |= (tmp & GENMASK(21, 23)) >> 9;
+		tmp_addr |= (tmp & GENMASK_ULL(23, 21)) >> 9;
 
 		/* add remaining [11:0] bits from original MC4_ADDR */
-		tmp_addr |= addr & GENMASK(0, 11);
+		tmp_addr |= addr & GENMASK_ULL(11, 0);
 
 		return cc6_base | tmp_addr;
 	}
@@ -952,12 +954,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
 
-	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+	pvt->ranges[range].lim.lo &= GENMASK_ULL(15, 0);
 
 				    /* {[39:27],111b} */
 	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
 
-	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+	pvt->ranges[range].lim.hi &= GENMASK_ULL(7, 0);
 
 				    /* [47:40] */
 	pvt->ranges[range].lim.hi |= llim >> 13;
@@ -1330,7 +1332,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 			chan_off = dram_base;
 	}
 
-	return (sys_addr & GENMASK(6,47)) - (chan_off & GENMASK(23,47));
+	return (sys_addr & GENMASK_ULL(47,6)) - (chan_off & GENMASK_ULL(47,23));
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index d2443cf..6dc1fcc 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -160,14 +160,6 @@
 #define OFF false
 
 /*
- * Create a contiguous bitmask starting at bit position @lo and ending at
- * position @hi. For example
- *
- * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
- */
-#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
-
-/*
  * PCI-defined configuration space registers
  */
 #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index bb53467..d5a98a4 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -297,15 +297,14 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	}
 
 	/* Error address */
-	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+	if (mem_err->validation_bits & CPER_MEM_VALID_PA) {
 		e->page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
 		e->offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
 	}
 
 	/* Error grain */
-	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK) {
+	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
 		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
-	}
 
 	/* Memory error location, mapped on e->location */
 	p = e->location;
@@ -315,6 +314,8 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		p += sprintf(p, "card:%d ", mem_err->card);
 	if (mem_err->validation_bits & CPER_MEM_VALID_MODULE)
 		p += sprintf(p, "module:%d ", mem_err->module);
+	if (mem_err->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		p += sprintf(p, "rank:%d ", mem_err->rank);
 	if (mem_err->validation_bits & CPER_MEM_VALID_BANK)
 		p += sprintf(p, "bank:%d ", mem_err->bank);
 	if (mem_err->validation_bits & CPER_MEM_VALID_ROW)
@@ -323,6 +324,15 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		p += sprintf(p, "col:%d ", mem_err->column);
 	if (mem_err->validation_bits & CPER_MEM_VALID_BIT_POSITION)
 		p += sprintf(p, "bit_pos:%d ", mem_err->bit_pos);
+	if (mem_err->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
+		const char *bank = NULL, *device = NULL;
+		dmi_memdev_name(mem_err->mem_dev_handle, &bank, &device);
+		if (bank != NULL && device != NULL)
+			p += sprintf(p, "DIMM location:%s %s ", bank, device);
+		else
+			p += sprintf(p, "DIMM DMI handle: 0x%.4x ",
+				     mem_err->mem_dev_handle);
+	}
 	if (p > e->location)
 		*(p - 1) = '\0';
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index e04462b..88f60c5 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -50,7 +50,7 @@ static int probed;
  * Get a bit field at register value <v>, from bit <lo> to bit <hi>
  */
 #define GET_BITFIELD(v, lo, hi)	\
-	(((v) & ((1ULL << ((hi) - (lo) + 1)) - 1) << (lo)) >> (lo))
+	(((v) & GENMASK_ULL(hi, lo)) >> (lo))
 
 /*
  * sbridge Memory Controller Registers
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index fa0affb..c7e81ff 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -8,6 +8,7 @@
 #include <linux/bootmem.h>
 #include <linux/random.h>
 #include <asm/dmi.h>
+#include <asm/unaligned.h>
 
 /*
  * DMI stands for "Desktop Management Interface".  It is part
@@ -25,6 +26,13 @@ static int dmi_initialized;
 /* DMI system identification string used during boot */
 static char dmi_ids_string[128] __initdata;
 
+static struct dmi_memdev_info {
+	const char *device;
+	const char *bank;
+	u16 handle;
+} *dmi_memdev;
+static int dmi_memdev_nr;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -322,6 +330,42 @@ static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 	dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d - 1)));
 }
 
+static void __init count_mem_devices(const struct dmi_header *dm, void *v)
+{
+	if (dm->type != DMI_ENTRY_MEM_DEVICE)
+		return;
+	dmi_memdev_nr++;
+}
+
+static void __init save_mem_devices(const struct dmi_header *dm, void *v)
+{
+	const char *d = (const char *)dm;
+	static int nr;
+
+	if (dm->type != DMI_ENTRY_MEM_DEVICE)
+		return;
+	if (nr >= dmi_memdev_nr) {
+		pr_warn(FW_BUG "Too many DIMM entries in SMBIOS table\n");
+		return;
+	}
+	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
+	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
+	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
+	nr++;
+}
+
+void __init dmi_memdev_walk(void)
+{
+	if (!dmi_available)
+		return;
+
+	if (dmi_walk_early(count_mem_devices) == 0 && dmi_memdev_nr) {
+		dmi_memdev = dmi_alloc(sizeof(*dmi_memdev) * dmi_memdev_nr);
+		if (dmi_memdev)
+			dmi_walk_early(save_mem_devices);
+	}
+}
+
 /*
  *	Process a DMI table entry. Right now all we care about are the BIOS
  *	and machine entries. For 2.5 we should pull the smbus controller info
@@ -815,3 +859,20 @@ bool dmi_match(enum dmi_field f, const char *str)
 	return !strcmp(info, str);
 }
 EXPORT_SYMBOL_GPL(dmi_match);
+
+void dmi_memdev_name(u16 handle, const char **bank, const char **device)
+{
+	int n;
+
+	if (dmi_memdev == NULL)
+		return;
+
+	for (n = 0; n < dmi_memdev_nr; n++) {
+		if (handle == dmi_memdev[n].handle) {
+			*bank = dmi_memdev[n].bank;
+			*device = dmi_memdev[n].device;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(dmi_memdev_name);
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index b0fc7c7..3150aa4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -36,4 +36,7 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
+config UEFI_CPER
+	def_bool n
+
 endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 99245ab..9ba156d 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -4,3 +4,4 @@
 obj-y					+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/acpi/apei/cper.c b/drivers/firmware/efi/cper.c
similarity index 76%
rename from drivers/acpi/apei/cper.c
rename to drivers/firmware/efi/cper.c
index 33dc6a0..1491dd4 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -5,10 +5,10 @@
  *	Author: Huang Ying <ying.huang@intel.com>
  *
  * CPER is the format used to describe platform hardware error by
- * various APEI tables, such as ERST, BERT and HEST etc.
+ * various tables, such as ERST, BERT and HEST etc.
  *
  * For more information about CPER, please refer to Appendix N of UEFI
- * Specification version 2.3.
+ * Specification version 2.4.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
@@ -28,10 +28,12 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/cper.h>
+#include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 
+#define INDENT_SP	" "
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -73,7 +75,7 @@ static const char *cper_severity_str(unsigned int severity)
  * printed, with @pfx is printed at the beginning of each line.
  */
 void cper_print_bits(const char *pfx, unsigned int bits,
-		     const char *strs[], unsigned int strs_size)
+		     const char * const strs[], unsigned int strs_size)
 {
 	int i, len = 0;
 	const char *str;
@@ -98,32 +100,32 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 		printk("%s\n", buf);
 }
 
-static const char *cper_proc_type_strs[] = {
+static const char * const cper_proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
 };
 
-static const char *cper_proc_isa_strs[] = {
+static const char * const cper_proc_isa_strs[] = {
 	"IA32",
 	"IA64",
 	"X64",
 };
 
-static const char *cper_proc_error_type_strs[] = {
+static const char * const cper_proc_error_type_strs[] = {
 	"cache error",
 	"TLB error",
 	"bus error",
 	"micro-architectural error",
 };
 
-static const char *cper_proc_op_strs[] = {
+static const char * const cper_proc_op_strs[] = {
 	"unknown or generic",
 	"data read",
 	"data write",
 	"instruction execution",
 };
 
-static const char *cper_proc_flag_strs[] = {
+static const char * const cper_proc_flag_strs[] = {
 	"restartable",
 	"precise IP",
 	"overflow",
@@ -191,46 +193,58 @@ static const char *cper_mem_err_type_strs[] = {
 	"memory sparing",
 	"scrub corrected error",
 	"scrub uncorrected error",
+	"physical memory map-out event",
 };
 
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 {
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
 		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
-	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
+	if (mem->validation_bits & CPER_MEM_VALID_PA)
 		printk("%s""physical_address: 0x%016llx\n",
 		       pfx, mem->physical_addr);
-	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK)
+	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
 		printk("%s""physical_address_mask: 0x%016llx\n",
 		       pfx, mem->physical_addr_mask);
 	if (mem->validation_bits & CPER_MEM_VALID_NODE)
-		printk("%s""node: %d\n", pfx, mem->node);
+		pr_debug("node: %d\n", mem->node);
 	if (mem->validation_bits & CPER_MEM_VALID_CARD)
-		printk("%s""card: %d\n", pfx, mem->card);
+		pr_debug("card: %d\n", mem->card);
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
-		printk("%s""module: %d\n", pfx, mem->module);
+		pr_debug("module: %d\n", mem->module);
+	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		pr_debug("rank: %d\n", mem->rank);
 	if (mem->validation_bits & CPER_MEM_VALID_BANK)
-		printk("%s""bank: %d\n", pfx, mem->bank);
+		pr_debug("bank: %d\n", mem->bank);
 	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
-		printk("%s""device: %d\n", pfx, mem->device);
+		pr_debug("device: %d\n", mem->device);
 	if (mem->validation_bits & CPER_MEM_VALID_ROW)
-		printk("%s""row: %d\n", pfx, mem->row);
+		pr_debug("row: %d\n", mem->row);
 	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
-		printk("%s""column: %d\n", pfx, mem->column);
+		pr_debug("column: %d\n", mem->column);
 	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
-		printk("%s""bit_position: %d\n", pfx, mem->bit_pos);
+		pr_debug("bit_position: %d\n", mem->bit_pos);
 	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
-		printk("%s""requestor_id: 0x%016llx\n", pfx, mem->requestor_id);
+		pr_debug("requestor_id: 0x%016llx\n", mem->requestor_id);
 	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
-		printk("%s""responder_id: 0x%016llx\n", pfx, mem->responder_id);
+		pr_debug("responder_id: 0x%016llx\n", mem->responder_id);
 	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
-		printk("%s""target_id: 0x%016llx\n", pfx, mem->target_id);
+		pr_debug("target_id: 0x%016llx\n", mem->target_id);
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype = mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
 		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
 		       cper_mem_err_type_strs[etype] : "unknown");
 	}
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
+		const char *bank = NULL, *device = NULL;
+		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
+		if (bank != NULL && device != NULL)
+			printk("%s""DIMM location: %s %s", pfx, bank, device);
+		else
+			printk("%s""DIMM DMI handle: 0x%.4x",
+			       pfx, mem->mem_dev_handle);
+	}
 }
 
 static const char *cper_pcie_port_type_strs[] = {
@@ -248,7 +262,7 @@ static const char *cper_pcie_port_type_strs[] = {
 };
 
 static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
-			    const struct acpi_hest_generic_data *gdata)
+			    const struct acpi_generic_data *gdata)
 {
 	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
 		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
@@ -283,55 +297,45 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
-static const char *apei_estatus_section_flag_strs[] = {
-	"primary",
-	"containment warning",
-	"reset",
-	"threshold exceeded",
-	"resource not accessible",
-	"latent error",
-};
-
-static void apei_estatus_print_section(
-	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
+static void cper_estatus_print_section(
+	const char *pfx, const struct acpi_generic_data *gdata, int sec_no)
 {
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
+	char newpfx[64];
 
 	severity = gdata->error_severity;
-	printk("%s""section: %d, severity: %d, %s\n", pfx, sec_no, severity,
+	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
-	printk("%s""flags: 0x%02x\n", pfx, gdata->flags);
-	cper_print_bits(pfx, gdata->flags, apei_estatus_section_flag_strs,
-			ARRAY_SIZE(apei_estatus_section_flag_strs));
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
 		printk("%s""fru_id: %pUl\n", pfx, (uuid_le *)gdata->fru_id);
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
 		printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
 
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
 		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
-		printk("%s""section_type: general processor error\n", pfx);
+		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
-			cper_print_proc_generic(pfx, proc_err);
+			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
 		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
-		printk("%s""section_type: memory error\n", pfx);
+		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*mem_err))
-			cper_print_mem(pfx, mem_err);
+			cper_print_mem(newpfx, mem_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
 		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
-		printk("%s""section_type: PCIe error\n", pfx);
+		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
-			cper_print_pcie(pfx, pcie, gdata);
+			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
 	} else
-		printk("%s""section type: unknown, %pUl\n", pfx, sec_type);
+		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
 
 	return;
 
@@ -339,34 +343,38 @@ err_section_too_small:
 	pr_err(FW_WARN "error section length is too small\n");
 }
 
-void apei_estatus_print(const char *pfx,
-			const struct acpi_hest_generic_status *estatus)
+void cper_estatus_print(const char *pfx,
+			const struct acpi_generic_status *estatus)
 {
-	struct acpi_hest_generic_data *gdata;
+	struct acpi_generic_data *gdata;
 	unsigned int data_len, gedata_len;
 	int sec_no = 0;
+	char newpfx[64];
 	__u16 severity;
 
-	printk("%s""APEI generic hardware error status\n", pfx);
 	severity = estatus->error_severity;
-	printk("%s""severity: %d, %s\n", pfx, severity,
-	       cper_severity_str(severity));
+	if (severity == CPER_SEV_CORRECTED)
+		printk("%s%s\n", pfx,
+		       "It has been corrected by h/w "
+		       "and requires no further action");
+	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
-	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len > sizeof(*gdata)) {
+	gdata = (struct acpi_generic_data *)(estatus + 1);
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+	while (data_len >= sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
-		apei_estatus_print_section(pfx, gdata, sec_no);
+		cper_estatus_print_section(newpfx, gdata, sec_no);
 		data_len -= gedata_len + sizeof(*gdata);
 		gdata = (void *)(gdata + 1) + gedata_len;
 		sec_no++;
 	}
 }
-EXPORT_SYMBOL_GPL(apei_estatus_print);
+EXPORT_SYMBOL_GPL(cper_estatus_print);
 
-int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus)
+int cper_estatus_check_header(const struct acpi_generic_status *estatus)
 {
 	if (estatus->data_length &&
-	    estatus->data_length < sizeof(struct acpi_hest_generic_data))
+	    estatus->data_length < sizeof(struct acpi_generic_data))
 		return -EINVAL;
 	if (estatus->raw_data_length &&
 	    estatus->raw_data_offset < sizeof(*estatus) + estatus->data_length)
@@ -374,19 +382,19 @@ int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(apei_estatus_check_header);
+EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 
-int apei_estatus_check(const struct acpi_hest_generic_status *estatus)
+int cper_estatus_check(const struct acpi_generic_status *estatus)
 {
-	struct acpi_hest_generic_data *gdata;
+	struct acpi_generic_data *gdata;
 	unsigned int data_len, gedata_len;
 	int rc;
 
-	rc = apei_estatus_check_header(estatus);
+	rc = cper_estatus_check_header(estatus);
 	if (rc)
 		return rc;
 	data_len = estatus->data_length;
-	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+	gdata = (struct acpi_generic_data *)(estatus + 1);
 	while (data_len >= sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
 		if (gedata_len > data_len - sizeof(*gdata))
@@ -399,4 +407,4 @@ int apei_estatus_check(const struct acpi_hest_generic_status *estatus)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(apei_estatus_check);
+EXPORT_SYMBOL_GPL(cper_estatus_check);
diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index f082ae5..4f26bc2 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -3320,9 +3320,8 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 }
 
 #ifndef GETBITSTR
-#define BITMASK(h,l)    	(((unsigned)(1U << ((h)-(l)+1))-1)<<(l))
-#define GENMASK(mask)   	BITMASK(1?mask,0?mask)
-#define GETBITS(var,mask)   	(((var) & GENMASK(mask)) >> (0?mask))
+#define GENBITSMASK(mask)   	GENMASK(1?mask,0?mask)
+#define GETBITS(var,mask)   	(((var) & GENBITSMASK(mask)) >> (0?mask))
 #define GETBITSTR(val,from,to)  ((GETBITS(val,from)) << (0?to))
 #endif
 
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 0bd750e..556c83ee 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -596,7 +596,7 @@ struct acpi_hest_generic {
 
 /* Generic Error Status block */
 
-struct acpi_hest_generic_status {
+struct acpi_generic_status {
 	u32 block_status;
 	u32 raw_data_offset;
 	u32 raw_data_length;
@@ -606,15 +606,15 @@ struct acpi_hest_generic_status {
 
 /* Values for block_status flags above */
 
-#define ACPI_HEST_UNCORRECTABLE             (1)
-#define ACPI_HEST_CORRECTABLE               (1<<1)
-#define ACPI_HEST_MULTIPLE_UNCORRECTABLE    (1<<2)
-#define ACPI_HEST_MULTIPLE_CORRECTABLE      (1<<3)
-#define ACPI_HEST_ERROR_ENTRY_COUNT         (0xFF<<4)	/* 8 bits, error count */
+#define ACPI_GEN_ERR_UC			BIT(0)
+#define ACPI_GEN_ERR_CE			BIT(1)
+#define ACPI_GEN_ERR_MULTI_UC		BIT(2)
+#define ACPI_GEN_ERR_MULTI_CE		BIT(3)
+#define ACPI_GEN_ERR_COUNT_SHIFT	(0xFF<<4) /* 8 bits, error count */
 
 /* Generic Error Data entry */
 
-struct acpi_hest_generic_data {
+struct acpi_generic_data {
 	u8 section_type[16];
 	u32 error_severity;
 	u16 revision;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 720446c..dfd60d0 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -14,7 +14,7 @@
 
 struct ghes {
 	struct acpi_hest_generic *generic;
-	struct acpi_hest_generic_status *estatus;
+	struct acpi_generic_status *estatus;
 	u64 buffer_paddr;
 	unsigned long flags;
 	union {
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index a5db4ae..c30bac8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -311,6 +311,7 @@ struct acpi_osc_context {
 #define OSC_INVALID_REVISION_ERROR	8
 #define OSC_CAPABILITIES_MASK_ERROR	16
 
+acpi_status acpi_str_to_uuid(char *str, u8 *uuid);
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 
 /* platform-wide _OSC bits */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..bd0c459 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -10,6 +10,14 @@
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
+/*
+ * Create a contiguous bitmask starting at bit position @l and ending at
+ * position @h. For example
+ * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
+ */
+#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
+#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
+
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
 extern unsigned int __sw_hweight32(unsigned int w);
diff --git a/include/linux/cper.h b/include/linux/cper.h
index c230494..2fc0ec3 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -218,8 +218,8 @@ enum {
 #define CPER_PROC_VALID_IP			0x1000
 
 #define CPER_MEM_VALID_ERROR_STATUS		0x0001
-#define CPER_MEM_VALID_PHYSICAL_ADDRESS		0x0002
-#define CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK	0x0004
+#define CPER_MEM_VALID_PA			0x0002
+#define CPER_MEM_VALID_PA_MASK			0x0004
 #define CPER_MEM_VALID_NODE			0x0008
 #define CPER_MEM_VALID_CARD			0x0010
 #define CPER_MEM_VALID_MODULE			0x0020
@@ -232,6 +232,9 @@ enum {
 #define CPER_MEM_VALID_RESPONDER_ID		0x1000
 #define CPER_MEM_VALID_TARGET_ID		0x2000
 #define CPER_MEM_VALID_ERROR_TYPE		0x4000
+#define CPER_MEM_VALID_RANK_NUMBER		0x8000
+#define CPER_MEM_VALID_CARD_HANDLE		0x10000
+#define CPER_MEM_VALID_MODULE_HANDLE		0x20000
 
 #define CPER_PCIE_VALID_PORT_TYPE		0x0001
 #define CPER_PCIE_VALID_VERSION			0x0002
@@ -347,6 +350,10 @@ struct cper_sec_mem_err {
 	__u64	responder_id;
 	__u64	target_id;
 	__u8	error_type;
+	__u8	reserved;
+	__u16	rank;
+	__u16	mem_array_handle;	/* card handle in UEFI 2.4 */
+	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
 };
 
 struct cper_sec_pcie {
@@ -389,6 +396,6 @@ struct cper_sec_pcie {
 
 u64 cper_next_record_id(void);
 void cper_print_bits(const char *prefix, unsigned int bits,
-		     const char *strs[], unsigned int strs_size);
+		     const char * const strs[], unsigned int strs_size);
 
 #endif
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index b6eb7a0..f820f0a 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -99,6 +99,7 @@ extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
 extern void dmi_scan_machine(void);
+extern void dmi_memdev_walk(void);
 extern void dmi_set_dump_stack_arch_desc(void);
 extern bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp);
 extern int dmi_name_in_vendors(const char *str);
@@ -107,6 +108,7 @@ extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
 	void *private_data);
 extern bool dmi_match(enum dmi_field f, const char *str);
+extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
 
 #else
 
@@ -115,6 +117,7 @@ static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from) { return NULL; }
 static inline void dmi_scan_machine(void) { return; }
+static inline void dmi_memdev_walk(void) { }
 static inline void dmi_set_dump_stack_arch_desc(void) { }
 static inline bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
 {
@@ -133,6 +136,8 @@ static inline int dmi_walk(void (*decode)(const struct dmi_header *, void *),
 	void *private_data) { return -1; }
 static inline bool dmi_match(enum dmi_field f, const char *str)
 	{ return false; }
+static inline void dmi_memdev_name(u16 handle, const char **bank,
+		const char **device) { }
 static inline const struct dmi_system_id *
 	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 5c6d7fb..dbdffe8 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -51,7 +51,7 @@ static inline void opstate_init(void)
 #define EDAC_MC_LABEL_LEN	31
 
 /* Maximum size of the location string */
-#define LOCATION_SIZE 80
+#define LOCATION_SIZE 256
 
 /* Defines the maximum number of labels that can be reported */
 #define EDAC_MAX_LABELS		8
