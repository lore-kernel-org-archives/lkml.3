Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaHDM0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:26:36 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52642 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaHDM0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:26:34 -0400
Date: Mon, 4 Aug 2014 14:26:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ras changes for v3.17
Message-ID: <20140804122626.GA27308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   # HEAD: c3107e3c504d3187ed8eac8179494946faff1481 Merge tag 'please-pull-apei' into x86/ras

The main changes in this cycle are:

 * RAS tracing/events infrastructure, by Gong Chen.

 * Various generalizations of the APEI code to make it available to 
   non-x86 architectures, by Tomasz Nowicki.


  out-of-topic modifications in x86-ras-for-linus:
  --------------------------------------------------
  drivers/Kconfig                    # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/Makefile                   # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/acpi/Kconfig               # 2dfb7d5: trace, RAS: Add eMCA trace event 
  drivers/acpi/acpi_extlog.c         # 7c76bb5: RAS, extlog: Adjust init flow
                                   # d6cae93: trace, eMCA: Add a knob to adjust
                                   # 2dfb7d5: trace, RAS: Add eMCA trace event 
  drivers/acpi/apei/Kconfig          # 44a69f6: acpi, apei, ghes: Make NMI error 
  drivers/acpi/apei/apei-base.c      # 9dae3d0: apei, mce: Factor out APEI archit
  drivers/acpi/apei/ghes.c           # 594c725: acpi, apei, ghes: Factor out iore
                                   # 44a69f6: acpi, apei, ghes: Make NMI error 
                                   # 9dae3d0: apei, mce: Factor out APEI archit
  drivers/acpi/apei/hest.c           # 9dae3d0: apei, mce: Factor out APEI archit
  drivers/edac/Kconfig               # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/edac/edac_mc.c             # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/firmware/efi/cper.c        # 2dfb7d5: trace, RAS: Add eMCA trace event 
                                   # 3760cd2: CPER: Adjust code flow of some fu
  drivers/pci/pcie/aer/Kconfig       # 0a2409a: trace, AER: Move trace into unifi
  drivers/pci/pcie/aer/aerdrv_errprint.c# 0a2409a: trace, AER: Move trace into unifi
  drivers/ras/Kconfig                # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/ras/Makefile               # d963cd9: RAS, debugfs: Add debugfs interfa
                                   # 76ac827: trace, RAS: Add basic RAS trace e
  drivers/ras/debugfs.c              # d963cd9: RAS, debugfs: Add debugfs interfa
  drivers/ras/ras.c                  # 2dfb7d5: trace, RAS: Add eMCA trace event 
                                   # d963cd9: RAS, debugfs: Add debugfs interfa
                                   # 76ac827: trace, RAS: Add basic RAS trace e
  include/acpi/apei.h                # 594c725: acpi, apei, ghes: Factor out iore
                                   # 9dae3d0: apei, mce: Factor out APEI archit
  include/linux/aer.h                # 5ccb822: x86/ras: Fix build warnings in <l
  include/linux/cper.h               # 2dfb7d5: trace, RAS: Add eMCA trace event 
                                   # 3760cd2: CPER: Adjust code flow of some fu
  include/linux/nmi.h                # 44a69f6: acpi, apei, ghes: Make NMI error 
  include/linux/ras.h                # d963cd9: RAS, debugfs: Add debugfs interfa
  include/ras/ras_event.h            # 2dfb7d5: trace, RAS: Add eMCA trace event 
                                   # 0a2409a: trace, AER: Move trace into unifi
  include/trace/events/ras.h         # 0a2409a: trace, AER: Move trace into unifi

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, MCE: Kill CPU_POST_DEAD
      x86, MCE: Robustify mcheck_init_device

Chen, Gong (7):
      trace, RAS: Add basic RAS trace event
      trace, AER: Move trace into unified interface
      CPER: Adjust code flow of some functions
      RAS, debugfs: Add debugfs interface for RAS subsystem
      trace, RAS: Add eMCA trace event interface
      trace, eMCA: Add a knob to adjust where to save event log
      RAS, extlog: Adjust init flow

Mike Qiu (1):
      x86/ras: Fix build warnings in <linux/aer.h>

Tomasz Nowicki (3):
      apei, mce: Factor out APEI architecture specific MCE calls.
      acpi, apei, ghes: Make NMI error notification to be GHES architecture extension.
      acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI context.


 arch/x86/Kconfig                       |   2 +
 arch/x86/kernel/acpi/Makefile          |   1 +
 arch/x86/kernel/acpi/apei.c            |  62 +++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c       |  19 ++--
 drivers/Kconfig                        |   2 +
 drivers/Makefile                       |   1 +
 drivers/acpi/Kconfig                   |   4 +-
 drivers/acpi/acpi_extlog.c             |  46 ++++++--
 drivers/acpi/apei/Kconfig              |   8 +-
 drivers/acpi/apei/apei-base.c          |  13 +++
 drivers/acpi/apei/ghes.c               | 173 ++++++++++++++++++-----------
 drivers/acpi/apei/hest.c               |  29 +----
 drivers/edac/Kconfig                   |   1 +
 drivers/edac/edac_mc.c                 |   3 -
 drivers/firmware/efi/cper.c            | 192 +++++++++++++++++++++++----------
 drivers/pci/pcie/aer/Kconfig           |   1 +
 drivers/pci/pcie/aer/aerdrv_errprint.c |   4 +-
 drivers/ras/Kconfig                    |   2 +
 drivers/ras/Makefile                   |   1 +
 drivers/ras/debugfs.c                  |  56 ++++++++++
 drivers/ras/ras.c                      |  29 +++++
 include/acpi/apei.h                    |   4 +
 include/linux/aer.h                    |   2 +
 include/linux/cper.h                   |  32 ++++++
 include/linux/nmi.h                    |   4 +
 include/linux/ras.h                    |  14 +++
 include/ras/ras_event.h                | 128 ++++++++++++++++++++++
 include/trace/events/ras.h             |  77 -------------
 28 files changed, 659 insertions(+), 251 deletions(-)
 create mode 100644 arch/x86/kernel/acpi/apei.c
 create mode 100644 drivers/ras/Kconfig
 create mode 100644 drivers/ras/Makefile
 create mode 100644 drivers/ras/debugfs.c
 create mode 100644 drivers/ras/ras.c
 create mode 100644 include/linux/ras.h
 delete mode 100644 include/trace/events/ras.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d24887b..4387344 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,6 +132,8 @@ config X86
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select HAVE_ACPI_APEI if ACPI
+	select HAVE_ACPI_APEI_NMI if ACPI
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 163b225..3242e59 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_ACPI)		+= boot.o
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_APEI)		+= apei.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o
diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
new file mode 100644
index 0000000..c280df6
--- /dev/null
+++ b/arch/x86/kernel/acpi/apei.c
@@ -0,0 +1,62 @@
+/*
+ * Arch-specific APEI-related functions.
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
+ */
+
+#include <acpi/apei.h>
+
+#include <asm/mce.h>
+#include <asm/tlbflush.h>
+
+int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data)
+{
+#ifdef CONFIG_X86_MCE
+	int i;
+	struct acpi_hest_ia_corrected *cmc;
+	struct acpi_hest_ia_error_bank *mc_bank;
+
+	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
+		return 0;
+
+	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
+	if (!cmc->enabled)
+		return 0;
+
+	/*
+	 * We expect HEST to provide a list of MC banks that report errors
+	 * in firmware first mode. Otherwise, return non-zero value to
+	 * indicate that we are done parsing HEST.
+	 */
+	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) ||
+	    !cmc->num_hardware_banks)
+		return 1;
+
+	pr_info("HEST: Enabling Firmware First mode for corrected errors.\n");
+
+	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
+	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
+		mce_disable_bank(mc_bank->bank_number);
+#endif
+	return 1;
+}
+
+void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
+{
+#ifdef CONFIG_X86_MCE
+	apei_mce_report_mem_error(sev, mem_err);
+#endif
+}
+
+void arch_apei_flush_tlb_one(unsigned long addr)
+{
+	__flush_tlb_one(addr);
+}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38..4fc5797 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2385,6 +2385,10 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
 		mce_intel_hcpu_update(cpu);
+
+		/* intentionally ignoring frozen here */
+		if (!(action & CPU_TASKS_FROZEN))
+			cmci_rediscover();
 		break;
 	case CPU_DOWN_PREPARE:
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
@@ -2396,11 +2400,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	}
 
-	if (action == CPU_POST_DEAD) {
-		/* intentionally ignoring frozen here */
-		cmci_rediscover();
-	}
-
 	return NOTIFY_OK;
 }
 
@@ -2451,6 +2450,12 @@ static __init int mcheck_init_device(void)
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
 		if (err) {
+			/*
+			 * Register notifier anyway (and do not unreg it) so
+			 * that we don't leave undeleted timers, see notifier
+			 * callback above.
+			 */
+			__register_hotcpu_notifier(&mce_cpu_notifier);
 			cpu_notifier_register_done();
 			goto err_device_create;
 		}
@@ -2471,10 +2476,6 @@ static __init int mcheck_init_device(void)
 err_register:
 	unregister_syscore_ops(&mce_syscore_ops);
 
-	cpu_notifier_register_begin();
-	__unregister_hotcpu_notifier(&mce_cpu_notifier);
-	cpu_notifier_register_done();
-
 err_device_create:
 	/*
 	 * We didn't keep track of which devices were created above, but
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0e87a34..4e6e66c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -176,4 +176,6 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/ras/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d..65c32b1 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -158,3 +158,4 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_RAS)		+= ras/
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index a34a228..206942b 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -370,6 +370,7 @@ config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE && X86_LOCAL_APIC
 	select UEFI_CPER
+	select RAS
 	default n
 	help
 	  Certain usages such as Predictive Failure Analysis (PFA) require
@@ -384,6 +385,7 @@ config ACPI_EXTLOG
 
 	  Enhanced MCA Logging allows firmware to provide additional error
 	  information to system software, synchronous with MCE or CMCI. This
-	  driver adds support for that functionality.
+	  driver adds support for that functionality with corresponding
+	  tracepoint which carries that information to userspace.
 
 endif	# ACPI
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 1853341..0ad6f38 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,10 +12,12 @@
 #include <linux/cper.h>
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
+#include <linux/ras.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
 #include "apei/apei-internal.h"
+#include <ras/ras_event.h>
 
 #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(51, 0) /* elog entry address mask */
 
@@ -137,8 +139,12 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	struct mce *mce = (struct mce *)data;
 	int	bank = mce->bank;
 	int	cpu = mce->extcpu;
-	struct acpi_generic_status *estatus;
-	int rc;
+	struct acpi_generic_status *estatus, *tmp;
+	struct acpi_generic_data *gdata;
+	const uuid_le *fru_id = &NULL_UUID_LE;
+	char *fru_text = "";
+	uuid_le *sec_type;
+	static u32 err_seq;
 
 	estatus = extlog_elog_entry_check(cpu, bank);
 	if (estatus == NULL)
@@ -148,8 +154,29 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status = 0;
 
-	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
+	tmp = (struct acpi_generic_status *)elog_buf;
+
+	if (!ras_userspace_consumers()) {
+		print_extlog_rcd(NULL, tmp, cpu);
+		goto out;
+	}
+
+	/* log event via trace */
+	err_seq++;
+	gdata = (struct acpi_generic_data *)(tmp + 1);
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+		fru_id = (uuid_le *)gdata->fru_id;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+		fru_text = gdata->fru_text;
+	sec_type = (uuid_le *)gdata->section_type;
+	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
+		if (gdata->error_data_length >= sizeof(*mem))
+			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+					       (u8)gdata->error_severity);
+	}
 
+out:
 	return NOTIFY_STOP;
 }
 
@@ -196,19 +223,16 @@ static int __init extlog_init(void)
 	u64 cap;
 	int rc;
 
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+
+	if (!(cap & MCG_ELOG_P) || !extlog_get_l1addr())
+		return -ENODEV;
+
 	if (get_edac_report_status() == EDAC_REPORTING_FORCE) {
 		pr_warn("Not loading eMCA, error reporting force-enabled through EDAC.\n");
 		return -EPERM;
 	}
 
-	rc = -ENODEV;
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	if (!(cap & MCG_ELOG_P))
-		return rc;
-
-	if (!extlog_get_l1addr())
-		return rc;
-
 	rc = -EINVAL;
 	/* get L1 header to fetch necessary information */
 	l1_hdr_size = sizeof(struct extlog_l1_head);
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index c4dac71..b0140c8 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,9 +1,15 @@
+config HAVE_ACPI_APEI
+	bool
+
+config HAVE_ACPI_APEI_NMI
+	bool
+
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
 	select UEFI_CPER
-	depends on X86
+	depends on HAVE_ACPI_APEI
 	help
 	  APEI allows to report errors (for example from the chipset)
 	  to the operating system. This improves NMI handling
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 8678dfe..2cd7bdd 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -745,6 +745,19 @@ struct dentry *apei_get_debugfs_dir(void)
 }
 EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
 
+int __weak arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr,
+				  void *data)
+{
+	return 1;
+}
+EXPORT_SYMBOL_GPL(arch_apei_enable_cmcff);
+
+void __weak arch_apei_report_mem_error(int sev,
+				       struct cper_sec_mem_err *mem_err)
+{
+}
+EXPORT_SYMBOL_GPL(arch_apei_report_mem_error);
+
 int apei_osc_setup(void)
 {
 	static u8 whea_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index dab7cb7..e05d84e7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -47,11 +47,11 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/nmi.h>
 
 #include <acpi/ghes.h>
-#include <asm/mce.h>
+#include <acpi/apei.h>
 #include <asm/tlbflush.h>
-#include <asm/nmi.h>
 
 #include "apei-internal.h"
 
@@ -86,8 +86,6 @@
 bool ghes_disable;
 module_param_named(disable, ghes_disable, bool, 0);
 
-static int ghes_panic_timeout	__read_mostly = 30;
-
 /*
  * All error sources notified with SCI shares one notifier function,
  * so they need to be linked and checked one by one.  This is applied
@@ -97,16 +95,9 @@ static int ghes_panic_timeout	__read_mostly = 30;
  * list changing, not for traversing.
  */
 static LIST_HEAD(ghes_sci);
-static LIST_HEAD(ghes_nmi);
 static DEFINE_MUTEX(ghes_list_mutex);
 
 /*
- * NMI may be triggered on any CPU, so ghes_nmi_lock is used for
- * mutual exclusion.
- */
-static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
-
-/*
  * Because the memory area used to transfer hardware error information
  * from BIOS to Linux can be determined only in NMI, IRQ or timer
  * handler, but general ioremap can not be used in atomic context, so
@@ -114,12 +105,16 @@ static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
  */
 
 /*
- * Two virtual pages are used, one for NMI context, the other for
- * IRQ/PROCESS context
+ * Two virtual pages are used, one for IRQ/PROCESS context, the other for
+ * NMI context (optionally).
  */
-#define GHES_IOREMAP_PAGES		2
-#define GHES_IOREMAP_NMI_PAGE(base)	(base)
-#define GHES_IOREMAP_IRQ_PAGE(base)	((base) + PAGE_SIZE)
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+#define GHES_IOREMAP_PAGES           2
+#else
+#define GHES_IOREMAP_PAGES           1
+#endif
+#define GHES_IOREMAP_IRQ_PAGE(base)	(base)
+#define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
 
 /* virtual memory area for atomic ioremap */
 static struct vm_struct *ghes_ioremap_area;
@@ -130,18 +125,8 @@ static struct vm_struct *ghes_ioremap_area;
 static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
 static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
 
-/*
- * printk is not safe in NMI context.  So in NMI handler, we allocate
- * required memory from lock-less memory allocator
- * (ghes_estatus_pool), save estatus into it, put them into lock-less
- * list (ghes_estatus_llist), then delay printk into IRQ context via
- * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
- * required pool size by all NMI error source.
- */
 static struct gen_pool *ghes_estatus_pool;
 static unsigned long ghes_estatus_pool_size_request;
-static struct llist_head ghes_estatus_llist;
-static struct irq_work ghes_proc_irq_work;
 
 struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
@@ -192,7 +177,7 @@ static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
@@ -202,7 +187,7 @@ static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static int ghes_estatus_pool_init(void)
@@ -249,11 +234,6 @@ static int ghes_estatus_pool_expand(unsigned long len)
 	return 0;
 }
 
-static void ghes_estatus_pool_shrink(unsigned long len)
-{
-	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
-}
-
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
 	struct ghes *ghes;
@@ -455,9 +435,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
-#ifdef CONFIG_X86_MCE
-			apei_mce_report_mem_error(sev, mem_err);
-#endif
+			arch_apei_report_mem_error(sev, mem_err);
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -734,6 +712,32 @@ static int ghes_notify_sci(struct notifier_block *this,
 	return ret;
 }
 
+static struct notifier_block ghes_notifier_sci = {
+	.notifier_call = ghes_notify_sci,
+};
+
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+/*
+ * printk is not safe in NMI context.  So in NMI handler, we allocate
+ * required memory from lock-less memory allocator
+ * (ghes_estatus_pool), save estatus into it, put them into lock-less
+ * list (ghes_estatus_llist), then delay printk into IRQ context via
+ * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
+ * required pool size by all NMI error source.
+ */
+static struct llist_head ghes_estatus_llist;
+static struct irq_work ghes_proc_irq_work;
+
+/*
+ * NMI may be triggered on any CPU, so ghes_nmi_lock is used for
+ * mutual exclusion.
+ */
+static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
+
+static LIST_HEAD(ghes_nmi);
+
+static int ghes_panic_timeout	__read_mostly = 30;
+
 static struct llist_node *llist_nodes_reverse(struct llist_node *llnode)
 {
 	struct llist_node *next, *tail = NULL;
@@ -877,10 +881,6 @@ out:
 	return ret;
 }
 
-static struct notifier_block ghes_notifier_sci = {
-	.notifier_call = ghes_notify_sci,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -896,11 +896,71 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static void ghes_estatus_pool_shrink(unsigned long len)
+{
+	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
+}
+
+static void ghes_nmi_add(struct ghes *ghes)
+{
+	unsigned long len;
+
+	len = ghes_esource_prealloc_size(ghes->generic);
+	ghes_estatus_pool_expand(len);
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_nmi))
+		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+	list_add_rcu(&ghes->list, &ghes_nmi);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static void ghes_nmi_remove(struct ghes *ghes)
+{
+	unsigned long len;
+
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	if (list_empty(&ghes_nmi))
+		unregister_nmi_handler(NMI_LOCAL, "ghes");
+	mutex_unlock(&ghes_list_mutex);
+	/*
+	 * To synchronize with NMI handler, ghes can only be
+	 * freed after NMI handler finishes.
+	 */
+	synchronize_rcu();
+	len = ghes_esource_prealloc_size(ghes->generic);
+	ghes_estatus_pool_shrink(len);
+}
+
+static void ghes_nmi_init_cxt(void)
+{
+	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+}
+#else /* CONFIG_HAVE_ACPI_APEI_NMI */
+static inline void ghes_nmi_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add NMI notification which is not supported!\n",
+	       ghes->generic->header.source_id);
+	BUG();
+}
+
+static inline void ghes_nmi_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove NMI notification which is not supported!\n",
+	       ghes->generic->header.source_id);
+	BUG();
+}
+
+static inline void ghes_nmi_init_cxt(void)
+{
+}
+#endif /* CONFIG_HAVE_ACPI_APEI_NMI */
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
-	unsigned long len;
+
 	int rc = -EINVAL;
 
 	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
@@ -911,7 +971,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_POLLED:
 	case ACPI_HEST_NOTIFY_EXTERNAL:
 	case ACPI_HEST_NOTIFY_SCI:
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
+		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
+				generic->header.source_id);
+			goto err;
+		}
 		break;
 	case ACPI_HEST_NOTIFY_LOCAL:
 		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
@@ -972,14 +1038,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		mutex_unlock(&ghes_list_mutex);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
-		len = ghes_esource_prealloc_size(generic);
-		ghes_estatus_pool_expand(len);
-		mutex_lock(&ghes_list_mutex);
-		if (list_empty(&ghes_nmi))
-			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
-						"ghes");
-		list_add_rcu(&ghes->list, &ghes_nmi);
-		mutex_unlock(&ghes_list_mutex);
+		ghes_nmi_add(ghes);
 		break;
 	default:
 		BUG();
@@ -1001,7 +1060,6 @@ static int ghes_remove(struct platform_device *ghes_dev)
 {
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
-	unsigned long len;
 
 	ghes = platform_get_drvdata(ghes_dev);
 	generic = ghes->generic;
@@ -1022,18 +1080,7 @@ static int ghes_remove(struct platform_device *ghes_dev)
 		mutex_unlock(&ghes_list_mutex);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
-		mutex_lock(&ghes_list_mutex);
-		list_del_rcu(&ghes->list);
-		if (list_empty(&ghes_nmi))
-			unregister_nmi_handler(NMI_LOCAL, "ghes");
-		mutex_unlock(&ghes_list_mutex);
-		/*
-		 * To synchronize with NMI handler, ghes can only be
-		 * freed after NMI handler finishes.
-		 */
-		synchronize_rcu();
-		len = ghes_esource_prealloc_size(generic);
-		ghes_estatus_pool_shrink(len);
+		ghes_nmi_remove(ghes);
 		break;
 	default:
 		BUG();
@@ -1077,7 +1124,7 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_nmi_init_cxt();
 
 	rc = ghes_ioremap_init();
 	if (rc)
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index f5e37f3..06e9b41 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -36,7 +36,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
-#include <asm/mce.h>
 
 #include "apei-internal.h"
 
@@ -128,33 +127,7 @@ EXPORT_SYMBOL_GPL(apei_hest_parse);
  */
 static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
 {
-#ifdef CONFIG_X86_MCE
-	int i;
-	struct acpi_hest_ia_corrected *cmc;
-	struct acpi_hest_ia_error_bank *mc_bank;
-
-	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
-		return 0;
-
-	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
-	if (!cmc->enabled)
-		return 0;
-
-	/*
-	 * We expect HEST to provide a list of MC banks that report errors
-	 * in firmware first mode. Otherwise, return non-zero value to
-	 * indicate that we are done parsing HEST.
-	 */
-	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) || !cmc->num_hardware_banks)
-		return 1;
-
-	pr_info(HEST_PFX "Enabling Firmware First mode for corrected errors.\n");
-
-	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
-	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
-		mce_disable_bank(mc_bank->bank_number);
-#endif
-	return 1;
+	return arch_apei_enable_cmcff(hest_hdr, data);
 }
 
 struct ghes_arr {
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..d3c0465 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -72,6 +72,7 @@ config EDAC_MCE_INJ
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
+	select RAS
 	help
 	  Some systems are able to detect and correct errors in main
 	  memory.  EDAC can report statistics on memory error
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2c694b5..9f134823 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -33,9 +33,6 @@
 #include <asm/edac.h>
 #include "edac_core.h"
 #include "edac_module.h"
-
-#define CREATE_TRACE_POINTS
-#define TRACE_INCLUDE_PATH ../../include/ras
 #include <ras/ras_event.h>
 
 /* lock to memory controller's control array */
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 1491dd4..437e6fd 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -34,6 +34,9 @@
 #include <linux/aer.h>
 
 #define INDENT_SP	" "
+
+static char rcd_decode_str[CPER_REC_LEN];
+
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -50,18 +53,19 @@ u64 cper_next_record_id(void)
 }
 EXPORT_SYMBOL_GPL(cper_next_record_id);
 
-static const char *cper_severity_strs[] = {
+static const char * const severity_strs[] = {
 	"recoverable",
 	"fatal",
 	"corrected",
 	"info",
 };
 
-static const char *cper_severity_str(unsigned int severity)
+const char *cper_severity_str(unsigned int severity)
 {
-	return severity < ARRAY_SIZE(cper_severity_strs) ?
-		cper_severity_strs[severity] : "unknown";
+	return severity < ARRAY_SIZE(severity_strs) ?
+		severity_strs[severity] : "unknown";
 }
+EXPORT_SYMBOL_GPL(cper_severity_str);
 
 /*
  * cper_print_bits - print strings for set bits
@@ -100,32 +104,32 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 		printk("%s\n", buf);
 }
 
-static const char * const cper_proc_type_strs[] = {
+static const char * const proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
 };
 
-static const char * const cper_proc_isa_strs[] = {
+static const char * const proc_isa_strs[] = {
 	"IA32",
 	"IA64",
 	"X64",
 };
 
-static const char * const cper_proc_error_type_strs[] = {
+static const char * const proc_error_type_strs[] = {
 	"cache error",
 	"TLB error",
 	"bus error",
 	"micro-architectural error",
 };
 
-static const char * const cper_proc_op_strs[] = {
+static const char * const proc_op_strs[] = {
 	"unknown or generic",
 	"data read",
 	"data write",
 	"instruction execution",
 };
 
-static const char * const cper_proc_flag_strs[] = {
+static const char * const proc_flag_strs[] = {
 	"restartable",
 	"precise IP",
 	"overflow",
@@ -137,26 +141,26 @@ static void cper_print_proc_generic(const char *pfx,
 {
 	if (proc->validation_bits & CPER_PROC_VALID_TYPE)
 		printk("%s""processor_type: %d, %s\n", pfx, proc->proc_type,
-		       proc->proc_type < ARRAY_SIZE(cper_proc_type_strs) ?
-		       cper_proc_type_strs[proc->proc_type] : "unknown");
+		       proc->proc_type < ARRAY_SIZE(proc_type_strs) ?
+		       proc_type_strs[proc->proc_type] : "unknown");
 	if (proc->validation_bits & CPER_PROC_VALID_ISA)
 		printk("%s""processor_isa: %d, %s\n", pfx, proc->proc_isa,
-		       proc->proc_isa < ARRAY_SIZE(cper_proc_isa_strs) ?
-		       cper_proc_isa_strs[proc->proc_isa] : "unknown");
+		       proc->proc_isa < ARRAY_SIZE(proc_isa_strs) ?
+		       proc_isa_strs[proc->proc_isa] : "unknown");
 	if (proc->validation_bits & CPER_PROC_VALID_ERROR_TYPE) {
 		printk("%s""error_type: 0x%02x\n", pfx, proc->proc_error_type);
 		cper_print_bits(pfx, proc->proc_error_type,
-				cper_proc_error_type_strs,
-				ARRAY_SIZE(cper_proc_error_type_strs));
+				proc_error_type_strs,
+				ARRAY_SIZE(proc_error_type_strs));
 	}
 	if (proc->validation_bits & CPER_PROC_VALID_OPERATION)
 		printk("%s""operation: %d, %s\n", pfx, proc->operation,
-		       proc->operation < ARRAY_SIZE(cper_proc_op_strs) ?
-		       cper_proc_op_strs[proc->operation] : "unknown");
+		       proc->operation < ARRAY_SIZE(proc_op_strs) ?
+		       proc_op_strs[proc->operation] : "unknown");
 	if (proc->validation_bits & CPER_PROC_VALID_FLAGS) {
 		printk("%s""flags: 0x%02x\n", pfx, proc->flags);
-		cper_print_bits(pfx, proc->flags, cper_proc_flag_strs,
-				ARRAY_SIZE(cper_proc_flag_strs));
+		cper_print_bits(pfx, proc->flags, proc_flag_strs,
+				ARRAY_SIZE(proc_flag_strs));
 	}
 	if (proc->validation_bits & CPER_PROC_VALID_LEVEL)
 		printk("%s""level: %d\n", pfx, proc->level);
@@ -177,7 +181,7 @@ static void cper_print_proc_generic(const char *pfx,
 		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
 }
 
-static const char *cper_mem_err_type_strs[] = {
+static const char * const mem_err_type_strs[] = {
 	"unknown",
 	"no error",
 	"single-bit ECC",
@@ -196,58 +200,136 @@ static const char *cper_mem_err_type_strs[] = {
 	"physical memory map-out event",
 };
 
-static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
+const char *cper_mem_err_type_str(unsigned int etype)
 {
-	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
-		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
-	if (mem->validation_bits & CPER_MEM_VALID_PA)
-		printk("%s""physical_address: 0x%016llx\n",
-		       pfx, mem->physical_addr);
-	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
-		printk("%s""physical_address_mask: 0x%016llx\n",
-		       pfx, mem->physical_addr_mask);
+	return etype < ARRAY_SIZE(mem_err_type_strs) ?
+		mem_err_type_strs[etype] : "unknown";
+}
+EXPORT_SYMBOL_GPL(cper_mem_err_type_str);
+
+static int cper_mem_err_location(struct cper_mem_err_compact *mem, char *msg)
+{
+	u32 len, n;
+
+	if (!msg)
+		return 0;
+
+	n = 0;
+	len = CPER_REC_LEN - 1;
 	if (mem->validation_bits & CPER_MEM_VALID_NODE)
-		pr_debug("node: %d\n", mem->node);
+		n += scnprintf(msg + n, len - n, "node: %d ", mem->node);
 	if (mem->validation_bits & CPER_MEM_VALID_CARD)
-		pr_debug("card: %d\n", mem->card);
+		n += scnprintf(msg + n, len - n, "card: %d ", mem->card);
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
-		pr_debug("module: %d\n", mem->module);
+		n += scnprintf(msg + n, len - n, "module: %d ", mem->module);
 	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
-		pr_debug("rank: %d\n", mem->rank);
+		n += scnprintf(msg + n, len - n, "rank: %d ", mem->rank);
 	if (mem->validation_bits & CPER_MEM_VALID_BANK)
-		pr_debug("bank: %d\n", mem->bank);
+		n += scnprintf(msg + n, len - n, "bank: %d ", mem->bank);
 	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
-		pr_debug("device: %d\n", mem->device);
+		n += scnprintf(msg + n, len - n, "device: %d ", mem->device);
 	if (mem->validation_bits & CPER_MEM_VALID_ROW)
-		pr_debug("row: %d\n", mem->row);
+		n += scnprintf(msg + n, len - n, "row: %d ", mem->row);
 	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
-		pr_debug("column: %d\n", mem->column);
+		n += scnprintf(msg + n, len - n, "column: %d ", mem->column);
 	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
-		pr_debug("bit_position: %d\n", mem->bit_pos);
+		n += scnprintf(msg + n, len - n, "bit_position: %d ",
+			       mem->bit_pos);
 	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
-		pr_debug("requestor_id: 0x%016llx\n", mem->requestor_id);
+		n += scnprintf(msg + n, len - n, "requestor_id: 0x%016llx ",
+			       mem->requestor_id);
 	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
-		pr_debug("responder_id: 0x%016llx\n", mem->responder_id);
+		n += scnprintf(msg + n, len - n, "responder_id: 0x%016llx ",
+			       mem->responder_id);
 	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
-		pr_debug("target_id: 0x%016llx\n", mem->target_id);
+		scnprintf(msg + n, len - n, "target_id: 0x%016llx ",
+			  mem->target_id);
+
+	msg[n] = '\0';
+	return n;
+}
+
+static int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
+{
+	u32 len, n;
+	const char *bank = NULL, *device = NULL;
+
+	if (!msg || !(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
+		return 0;
+
+	n = 0;
+	len = CPER_REC_LEN - 1;
+	dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
+	if (bank && device)
+		n = snprintf(msg, len, "DIMM location: %s %s ", bank, device);
+	else
+		n = snprintf(msg, len,
+			     "DIMM location: not present. DMI handle: 0x%.4x ",
+			     mem->mem_dev_handle);
+
+	msg[n] = '\0';
+	return n;
+}
+
+void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
+		       struct cper_mem_err_compact *cmem)
+{
+	cmem->validation_bits = mem->validation_bits;
+	cmem->node = mem->node;
+	cmem->card = mem->card;
+	cmem->module = mem->module;
+	cmem->bank = mem->bank;
+	cmem->device = mem->device;
+	cmem->row = mem->row;
+	cmem->column = mem->column;
+	cmem->bit_pos = mem->bit_pos;
+	cmem->requestor_id = mem->requestor_id;
+	cmem->responder_id = mem->responder_id;
+	cmem->target_id = mem->target_id;
+	cmem->rank = mem->rank;
+	cmem->mem_array_handle = mem->mem_array_handle;
+	cmem->mem_dev_handle = mem->mem_dev_handle;
+}
+
+const char *cper_mem_err_unpack(struct trace_seq *p,
+				struct cper_mem_err_compact *cmem)
+{
+	const char *ret = p->buffer + p->len;
+
+	if (cper_mem_err_location(cmem, rcd_decode_str))
+		trace_seq_printf(p, "%s", rcd_decode_str);
+	if (cper_dimm_err_location(cmem, rcd_decode_str))
+		trace_seq_printf(p, "%s", rcd_decode_str);
+	trace_seq_putc(p, '\0');
+
+	return ret;
+}
+
+static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
+{
+	struct cper_mem_err_compact cmem;
+
+	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
+		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
+	if (mem->validation_bits & CPER_MEM_VALID_PA)
+		printk("%s""physical_address: 0x%016llx\n",
+		       pfx, mem->physical_addr);
+	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
+		printk("%s""physical_address_mask: 0x%016llx\n",
+		       pfx, mem->physical_addr_mask);
+	cper_mem_err_pack(mem, &cmem);
+	if (cper_mem_err_location(&cmem, rcd_decode_str))
+		printk("%s%s\n", pfx, rcd_decode_str);
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype = mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
-		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
-		       cper_mem_err_type_strs[etype] : "unknown");
-	}
-	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
-		const char *bank = NULL, *device = NULL;
-		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
-		if (bank != NULL && device != NULL)
-			printk("%s""DIMM location: %s %s", pfx, bank, device);
-		else
-			printk("%s""DIMM DMI handle: 0x%.4x",
-			       pfx, mem->mem_dev_handle);
+		       cper_mem_err_type_str(etype));
 	}
+	if (cper_dimm_err_location(&cmem, rcd_decode_str))
+		printk("%s%s\n", pfx, rcd_decode_str);
 }
 
-static const char *cper_pcie_port_type_strs[] = {
+static const char * const pcie_port_type_strs[] = {
 	"PCIe end point",
 	"legacy PCI end point",
 	"unknown",
@@ -266,8 +348,8 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 {
 	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
 		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
-		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
-		       cper_pcie_port_type_strs[pcie->port_type] : "unknown");
+		       pcie->port_type < ARRAY_SIZE(pcie_port_type_strs) ?
+		       pcie_port_type_strs[pcie->port_type] : "unknown");
 	if (pcie->validation_bits & CPER_PCIE_VALID_VERSION)
 		printk("%s""version: %d.%d\n", pfx,
 		       pcie->version.major, pcie->version.minor);
diff --git a/drivers/pci/pcie/aer/Kconfig b/drivers/pci/pcie/aer/Kconfig
index 50e94e0..3894402 100644
--- a/drivers/pci/pcie/aer/Kconfig
+++ b/drivers/pci/pcie/aer/Kconfig
@@ -5,6 +5,7 @@
 config PCIEAER
 	boolean "Root Port Advanced Error Reporting support"
 	depends on PCIEPORTBUS
+	select RAS
 	default y
 	help
 	  This enables PCI Express Root Port Advanced Error Reporting
diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 36ed31b5..35d06e1 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -22,9 +22,7 @@
 #include <linux/cper.h>
 
 #include "aerdrv.h"
-
-#define CREATE_TRACE_POINTS
-#include <trace/events/ras.h>
+#include <ras/ras_event.h>
 
 #define AER_AGENT_RECEIVER		0
 #define AER_AGENT_REQUESTER		1
diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
new file mode 100644
index 0000000..f9da613
--- /dev/null
+++ b/drivers/ras/Kconfig
@@ -0,0 +1,2 @@
+config RAS
+	bool
diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
new file mode 100644
index 0000000..d7f7334
--- /dev/null
+++ b/drivers/ras/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_RAS) += ras.o debugfs.o
diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
new file mode 100644
index 0000000..0322acf
--- /dev/null
+++ b/drivers/ras/debugfs.c
@@ -0,0 +1,56 @@
+#include <linux/debugfs.h>
+
+static struct dentry *ras_debugfs_dir;
+
+static atomic_t trace_count = ATOMIC_INIT(0);
+
+int ras_userspace_consumers(void)
+{
+	return atomic_read(&trace_count);
+}
+EXPORT_SYMBOL_GPL(ras_userspace_consumers);
+
+static int trace_show(struct seq_file *m, void *v)
+{
+	return atomic_read(&trace_count);
+}
+
+static int trace_open(struct inode *inode, struct file *file)
+{
+	atomic_inc(&trace_count);
+	return single_open(file, trace_show, NULL);
+}
+
+static int trace_release(struct inode *inode, struct file *file)
+{
+	atomic_dec(&trace_count);
+	return single_release(inode, file);
+}
+
+static const struct file_operations trace_fops = {
+	.open    = trace_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = trace_release,
+};
+
+int __init ras_add_daemon_trace(void)
+{
+	struct dentry *fentry;
+
+	if (!ras_debugfs_dir)
+		return -ENOENT;
+
+	fentry = debugfs_create_file("daemon_active", S_IRUSR, ras_debugfs_dir,
+				     NULL, &trace_fops);
+	if (!fentry)
+		return -ENODEV;
+
+	return 0;
+
+}
+
+void __init ras_debugfs_init(void)
+{
+	ras_debugfs_dir = debugfs_create_dir("ras", NULL);
+}
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
new file mode 100644
index 0000000..b67dd36
--- /dev/null
+++ b/drivers/ras/ras.c
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ *	Chen, Gong <gong.chen@linux.intel.com>
+ */
+
+#include <linux/init.h>
+#include <linux/ras.h>
+
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
+static int __init ras_init(void)
+{
+	int rc = 0;
+
+	ras_debugfs_init();
+	rc = ras_add_daemon_trace();
+
+	return rc;
+}
+subsys_initcall(ras_init);
+
+#if defined(CONFIG_ACPI_EXTLOG) || defined(CONFIG_ACPI_EXTLOG_MODULE)
+EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
+#endif
+EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 04f349d..76284bb 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -42,5 +42,9 @@ ssize_t erst_read(u64 record_id, struct cper_record_header *record,
 		  size_t buflen);
 int erst_clear(u64 record_id);
 
+int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data);
+void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *mem_err);
+void arch_apei_flush_tlb_one(unsigned long addr);
+
 #endif
 #endif
diff --git a/include/linux/aer.h b/include/linux/aer.h
index 4dbaa70..c826d1c 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -11,6 +11,8 @@
 #define AER_FATAL			1
 #define AER_CORRECTABLE			2
 
+struct pci_dev;
+
 struct aer_header_log_regs {
 	unsigned int dw0;
 	unsigned int dw1;
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 2fc0ec3..76abba4 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -22,6 +22,7 @@
 #define LINUX_CPER_H
 
 #include <linux/uuid.h>
+#include <linux/trace_seq.h>
 
 /* CPER record signature and the size */
 #define CPER_SIG_RECORD				"CPER"
@@ -36,6 +37,13 @@
 #define CPER_RECORD_REV				0x0100
 
 /*
+ * CPER record length contains the CPER fields which are relevant for further
+ * handling of a memory error in userspace (we don't carry all the fields
+ * defined in the UEFI spec because some of them don't make any sense.)
+ * Currently, a length of 256 should be more than enough.
+ */
+#define CPER_REC_LEN					256
+/*
  * Severity difinition for error_severity in struct cper_record_header
  * and section_severity in struct cper_section_descriptor
  */
@@ -356,6 +364,24 @@ struct cper_sec_mem_err {
 	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
 };
 
+struct cper_mem_err_compact {
+	__u64	validation_bits;
+	__u16	node;
+	__u16	card;
+	__u16	module;
+	__u16	bank;
+	__u16	device;
+	__u16	row;
+	__u16	column;
+	__u16	bit_pos;
+	__u64	requestor_id;
+	__u64	responder_id;
+	__u64	target_id;
+	__u16	rank;
+	__u16	mem_array_handle;
+	__u16	mem_dev_handle;
+};
+
 struct cper_sec_pcie {
 	__u64		validation_bits;
 	__u32		port_type;
@@ -395,7 +421,13 @@ struct cper_sec_pcie {
 #pragma pack()
 
 u64 cper_next_record_id(void);
+const char *cper_severity_str(unsigned int);
+const char *cper_mem_err_type_str(unsigned int);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
+void cper_mem_err_pack(const struct cper_sec_mem_err *,
+		       struct cper_mem_err_compact *);
+const char *cper_mem_err_unpack(struct trace_seq *,
+				struct cper_mem_err_compact *);
 
 #endif
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 447775e..1d2a6ab 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -63,4 +63,8 @@ extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
 #endif
 
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+#include <asm/nmi.h>
+#endif
+
 #endif
diff --git a/include/linux/ras.h b/include/linux/ras.h
new file mode 100644
index 0000000..2aceeaf
--- /dev/null
+++ b/include/linux/ras.h
@@ -0,0 +1,14 @@
+#ifndef __RAS_H__
+#define __RAS_H__
+
+#ifdef CONFIG_DEBUG_FS
+int ras_userspace_consumers(void);
+void ras_debugfs_init(void);
+int ras_add_daemon_trace(void);
+#else
+static inline int ras_userspace_consumers(void) { return 0; }
+static inline void ras_debugfs_init(void) { return; }
+static inline int ras_add_daemon_trace(void) { return 0; }
+#endif
+
+#endif
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 21cdb0b..47da53c 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -8,6 +8,71 @@
 #include <linux/tracepoint.h>
 #include <linux/edac.h>
 #include <linux/ktime.h>
+#include <linux/aer.h>
+#include <linux/cper.h>
+
+/*
+ * MCE Extended Error Log trace event
+ *
+ * These events are generated when hardware detects a corrected or
+ * uncorrected event.
+ */
+
+/* memory trace event */
+
+#if defined(CONFIG_ACPI_EXTLOG) || defined(CONFIG_ACPI_EXTLOG_MODULE)
+TRACE_EVENT(extlog_mem_event,
+	TP_PROTO(struct cper_sec_mem_err *mem,
+		 u32 err_seq,
+		 const uuid_le *fru_id,
+		 const char *fru_text,
+		 u8 sev),
+
+	TP_ARGS(mem, err_seq, fru_id, fru_text, sev),
+
+	TP_STRUCT__entry(
+		__field(u32, err_seq)
+		__field(u8, etype)
+		__field(u8, sev)
+		__field(u64, pa)
+		__field(u8, pa_mask_lsb)
+		__field_struct(uuid_le, fru_id)
+		__string(fru_text, fru_text)
+		__field_struct(struct cper_mem_err_compact, data)
+	),
+
+	TP_fast_assign(
+		__entry->err_seq = err_seq;
+		if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
+			__entry->etype = mem->error_type;
+		else
+			__entry->etype = ~0;
+		__entry->sev = sev;
+		if (mem->validation_bits & CPER_MEM_VALID_PA)
+			__entry->pa = mem->physical_addr;
+		else
+			__entry->pa = ~0ull;
+
+		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
+			__entry->pa_mask_lsb = (u8)__ffs64(mem->physical_addr_mask);
+		else
+			__entry->pa_mask_lsb = ~0;
+		__entry->fru_id = *fru_id;
+		__assign_str(fru_text, fru_text);
+		cper_mem_err_pack(mem, &__entry->data);
+	),
+
+	TP_printk("{%d} %s error: %s physical addr: %016llx (mask lsb: %x) %sFRU: %pUl %.20s",
+		  __entry->err_seq,
+		  cper_severity_str(__entry->sev),
+		  cper_mem_err_type_str(__entry->etype),
+		  __entry->pa,
+		  __entry->pa_mask_lsb,
+		  cper_mem_err_unpack(p, &__entry->data),
+		  &__entry->fru_id,
+		  __get_str(fru_text))
+);
+#endif
 
 /*
  * Hardware Events Report
@@ -94,6 +159,69 @@ TRACE_EVENT(mc_event,
 		  __get_str(driver_detail))
 );
 
+/*
+ * PCIe AER Trace event
+ *
+ * These events are generated when hardware detects a corrected or
+ * uncorrected event on a PCIe device. The event report has
+ * the following structure:
+ *
+ * char * dev_name -	The name of the slot where the device resides
+ *			([domain:]bus:device.function).
+ * u32 status -		Either the correctable or uncorrectable register
+ *			indicating what error or errors have been seen
+ * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
+ */
+
+#define aer_correctable_errors		\
+	{BIT(0),	"Receiver Error"},		\
+	{BIT(6),	"Bad TLP"},			\
+	{BIT(7),	"Bad DLLP"},			\
+	{BIT(8),	"RELAY_NUM Rollover"},		\
+	{BIT(12),	"Replay Timer Timeout"},	\
+	{BIT(13),	"Advisory Non-Fatal"}
+
+#define aer_uncorrectable_errors		\
+	{BIT(4),	"Data Link Protocol"},		\
+	{BIT(12),	"Poisoned TLP"},		\
+	{BIT(13),	"Flow Control Protocol"},	\
+	{BIT(14),	"Completion Timeout"},		\
+	{BIT(15),	"Completer Abort"},		\
+	{BIT(16),	"Unexpected Completion"},	\
+	{BIT(17),	"Receiver Overflow"},		\
+	{BIT(18),	"Malformed TLP"},		\
+	{BIT(19),	"ECRC"},			\
+	{BIT(20),	"Unsupported Request"}
+
+TRACE_EVENT(aer_event,
+	TP_PROTO(const char *dev_name,
+		 const u32 status,
+		 const u8 severity),
+
+	TP_ARGS(dev_name, status, severity),
+
+	TP_STRUCT__entry(
+		__string(	dev_name,	dev_name	)
+		__field(	u32,		status		)
+		__field(	u8,		severity	)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__entry->status		= status;
+		__entry->severity	= severity;
+	),
+
+	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
+		__get_str(dev_name),
+		__entry->severity == AER_CORRECTABLE ? "Corrected" :
+			__entry->severity == AER_FATAL ?
+			"Fatal" : "Uncorrected, non-fatal",
+		__entry->severity == AER_CORRECTABLE ?
+		__print_flags(__entry->status, "|", aer_correctable_errors) :
+		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
+);
+
 #endif /* _TRACE_HW_EVENT_MC_H */
 
 /* This part must be outside protection */
diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
deleted file mode 100644
index 1c875ad..0000000
--- a/include/trace/events/ras.h
+++ /dev/null
@@ -1,77 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM ras
-
-#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_AER_H
-
-#include <linux/tracepoint.h>
-#include <linux/aer.h>
-
-
-/*
- * PCIe AER Trace event
- *
- * These events are generated when hardware detects a corrected or
- * uncorrected event on a PCIe device. The event report has
- * the following structure:
- *
- * char * dev_name -	The name of the slot where the device resides
- *			([domain:]bus:device.function).
- * u32 status -		Either the correctable or uncorrectable register
- *			indicating what error or errors have been seen
- * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
- */
-
-#define aer_correctable_errors		\
-	{BIT(0),	"Receiver Error"},		\
-	{BIT(6),	"Bad TLP"},			\
-	{BIT(7),	"Bad DLLP"},			\
-	{BIT(8),	"RELAY_NUM Rollover"},		\
-	{BIT(12),	"Replay Timer Timeout"},	\
-	{BIT(13),	"Advisory Non-Fatal"}
-
-#define aer_uncorrectable_errors		\
-	{BIT(4),	"Data Link Protocol"},		\
-	{BIT(12),	"Poisoned TLP"},		\
-	{BIT(13),	"Flow Control Protocol"},	\
-	{BIT(14),	"Completion Timeout"},		\
-	{BIT(15),	"Completer Abort"},		\
-	{BIT(16),	"Unexpected Completion"},	\
-	{BIT(17),	"Receiver Overflow"},		\
-	{BIT(18),	"Malformed TLP"},		\
-	{BIT(19),	"ECRC"},			\
-	{BIT(20),	"Unsupported Request"}
-
-TRACE_EVENT(aer_event,
-	TP_PROTO(const char *dev_name,
-		 const u32 status,
-		 const u8 severity),
-
-	TP_ARGS(dev_name, status, severity),
-
-	TP_STRUCT__entry(
-		__string(	dev_name,	dev_name	)
-		__field(	u32,		status		)
-		__field(	u8,		severity	)
-	),
-
-	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
-		__entry->status		= status;
-		__entry->severity	= severity;
-	),
-
-	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
-		__get_str(dev_name),
-		__entry->severity == AER_CORRECTABLE ? "Corrected" :
-			__entry->severity == AER_FATAL ?
-			"Fatal" : "Uncorrected, non-fatal",
-		__entry->severity == AER_CORRECTABLE ?
-		__print_flags(__entry->status, "|", aer_correctable_errors) :
-		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
-);
-
-#endif /* _TRACE_AER_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
