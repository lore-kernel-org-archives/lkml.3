Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3ICTIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:08:39 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63762 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab3ICTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:08:34 -0400
Date: Tue, 3 Sep 2013 21:08:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/RAS changes for v3.12
Message-ID: <20130903190829.GA312@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   HEAD: ead6fa95b7e9d38b4526503403ba1c029b03dd72 Merge tag 'edac_fixes_for_3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/ras

[ The reason for drivers/ updates is that Boris asked for the
  drivers/edac/ changes to go via x86/ras in this cycle. ]

Main changes:

 - AMD CPUs:

    . Add ECC event decoding support for new F15h models

    . Various erratum fixes

    . Fix single-channel on dual-channel-controllers bug.

 - Intel CPUs:

    . UC uncorrectable memory error parsing fix

    . Add support for CMC (Corrected Machine Check) 'FF' (Firmware First) 
      flag in the APEI HEST

 - Various cleanups and fixes.

out-of-topic modifications in x86-ras-for-linus:
------------------------------------------------
drivers/acpi/apei/erst.c           # cb82a2e: APEI/ERST: Fix error message form
drivers/acpi/apei/ghes.c           # cf870c7: mce: acpi/apei: Soft-offline a pa
drivers/acpi/apei/hest.c           # 7781544: x86/mce, acpi/apei: Only disable 
                                   # 9ad9587: mce: acpi/apei: Add a boot option
                                   # c3d1fb5: mce: acpi/apei: Honour Firmware F
drivers/edac/amd64_edac.c          # 4fc06b3: amd64_edac: Fix incorrect wraparo
                                   # 3f0aba4: amd64_edac: Correct erratum 505 r
                                   # a4b4bed: amd64_edac: Get rid of boot_cpu_d
                                   # 18b94f6: amd64_edac: Add ECC decoding supp
                                   # f0a56c4: amd64_edac: Fix single-channel se
drivers/edac/amd64_edac.h          # a4b4bed: amd64_edac: Get rid of boot_cpu_d
                                   # 18b94f6: amd64_edac: Add ECC decoding supp
drivers/edac/cpc925_edac.c         # 75a9551: cpc925_edac: Use proper array ter
drivers/edac/edac_mc_sysfs.c       # c542b53: EDAC: Replace strict_strtol() wit
drivers/edac/i3200_edac.c          # 166e933: i3200_edac: Make a local function
drivers/edac/x38_edac.c            # e0d391a: x38_edac: Make a local function s
include/linux/mm.h                 # cf870c7: mce: acpi/apei: Soft-offline a pa
include/linux/pci_ids.h            # 6bdaa63: pci_ids: Add PCI device ID functi
mm/memory-failure.c                # cf870c7: mce: acpi/apei: Soft-offline a pa

 Thanks,

	Ingo

------------------>
Aravind Gopalakrishnan (4):
      pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.
      x86, amd_nb: Clarify F15h, model 30h GART and L3 support
      amd64_edac: Add ECC decoding support for newer F15h models
      amd64_edac: Fix incorrect wraparounds

Borislav Petkov (4):
      amd64_edac: Fix single-channel setups
      APEI/ERST: Fix error message formatting
      amd64_edac: Get rid of boot_cpu_data accesses
      amd64_edac: Correct erratum 505 range

Jingoo Han (4):
      EDAC: Replace strict_strtol() with kstrtol()
      i3200_edac: Make a local function static
      x38_edac: Make a local function static
      cpc925_edac: Use proper array termination

Naveen N. Rao (4):
      mce: acpi/apei: Honour Firmware First for MCA banks listed in APEI HEST CMC
      mce: acpi/apei: Add a boot option to disable ff mode for corrected errors
      mce: acpi/apei: Soft-offline a page on firmware GHES notification
      x86/mce, acpi/apei: Only disable banks listed in HEST if mce is configured

Tony Luck (1):
      x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors


 Documentation/x86/x86_64/boot-options.txt |   5 +
 arch/x86/include/asm/acpi.h               |   2 +
 arch/x86/include/asm/mce.h                |  16 +-
 arch/x86/kernel/acpi/boot.c               |   5 +
 arch/x86/kernel/amd_nb.c                  |  13 +-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   3 +
 arch/x86/kernel/cpu/mcheck/mce.c          |  28 +++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |  42 +++-
 drivers/acpi/apei/erst.c                  |  51 ++---
 drivers/acpi/apei/ghes.c                  |  38 +++-
 drivers/acpi/apei/hest.c                  |  39 ++++
 drivers/edac/amd64_edac.c                 | 334 +++++++++++++++++++++++-------
 drivers/edac/amd64_edac.h                 |  60 +++++-
 drivers/edac/cpc925_edac.c                |   2 +-
 drivers/edac/edac_mc_sysfs.c              |   6 +-
 drivers/edac/i3200_edac.c                 |   3 +-
 drivers/edac/x38_edac.c                   |   3 +-
 include/linux/mm.h                        |   1 +
 include/linux/pci_ids.h                   |   2 +
 mm/memory-failure.c                       |   5 +-
 20 files changed, 523 insertions(+), 135 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index e9e8ddb..1228b22 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -176,6 +176,11 @@ ACPI
 
   acpi=noirq	Don't route interrupts
 
+  acpi=nocmcff	Disable firmware first mode for corrected errors. This
+		disables parsing the HEST CMC error source to check if
+		firmware has set the FF flag. This may result in
+		duplicate corrected error reports.
+
 PCI
 
   pci=off		Don't use PCI
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 2dfac58..b1977ba 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -86,6 +86,7 @@ extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
 extern int acpi_fix_pin2_polarity;
+extern int acpi_disable_cmcff;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
@@ -168,6 +169,7 @@ static inline void arch_acpi_set_pdc_bits(u32 *buf)
 
 #define acpi_lapic 0
 #define acpi_ioapic 0
+#define acpi_disable_cmcff 0
 static inline void acpi_noirq_set(void) { }
 static inline void acpi_disable_pci(void) { }
 static inline void disable_acpi(void) { }
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 29e3093..cbe6b9e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -32,11 +32,20 @@
 #define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
-#define MCACOD		  0xffff     /* MCA Error Code */
+
+/*
+ * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
+ * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
+ * errors to indicate that errors are being filtered by hardware.
+ * We should mask out bit 12 when looking for specific signatures
+ * of uncorrected errors - so the F bit is deliberately skipped
+ * in this #define.
+ */
+#define MCACOD		  0xefff     /* MCA Error Code */
 
 /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
 #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_SCRUBMSK	0xeff0	/* Skip bit 12 ('F' bit) */
 #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
 #define MCACOD_DATA	0x0134	/* Data Load */
 #define MCACOD_INSTR	0x0150	/* Instruction Fetch */
@@ -188,6 +197,9 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
 				    const char __user *ubuf,
 				    size_t usize, loff_t *off));
 
+/* Disable CMCI/polling for MCA bank claimed by firmware */
+extern void mce_disable_bank(int bank);
+
 /*
  * Exception handler
  */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..fead832 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -67,6 +67,7 @@ EXPORT_SYMBOL(acpi_pci_disabled);
 int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
+int acpi_disable_cmcff;
 
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
@@ -1626,6 +1627,10 @@ static int __init parse_acpi(char *arg)
 	/* "acpi=copy_dsdt" copys DSDT */
 	else if (strcmp(arg, "copy_dsdt") == 0) {
 		acpi_gbl_copy_dsdt_locally = 1;
+	}
+	/* "acpi=nocmcff" disables FF mode for corrected errors */
+	else if (strcmp(arg, "nocmcff") == 0) {
+		acpi_disable_cmcff = 1;
 	} else {
 		/* Core will printk when we return error. */
 		return -EINVAL;
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 3048ded..59554dc 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
@@ -27,6 +28,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
@@ -81,13 +83,20 @@ int amd_cache_northbridges(void)
 			next_northbridge(misc, amd_nb_misc_ids);
 		node_to_amd_nb(i)->link = link =
 			next_northbridge(link, amd_nb_link_ids);
-        }
+	}
 
+	/* GART present only on Fam15h upto model 0fh */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
+	    (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model < 0x10))
 		amd_northbridges.flags |= AMD_NB_GART;
 
 	/*
+	 * Check for L3 cache presence.
+	 */
+	if (!cpuid_edx(0x80000006))
+		return 0;
+
+	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 5b7d4fa..09edd0b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -25,15 +25,18 @@ int mce_severity(struct mce *a, int tolerant, char **msg);
 struct dentry *mce_get_debugfs_dir(void);
 
 extern struct mce_bank *mce_banks;
+extern mce_banks_t mce_banks_ce_disabled;
 
 #ifdef CONFIG_X86_MCE_INTEL
 unsigned long mce_intel_adjust_timer(unsigned long interval);
 void mce_intel_cmci_poll(void);
 void mce_intel_hcpu_update(unsigned long cpu);
+void cmci_disable_bank(int bank);
 #else
 # define mce_intel_adjust_timer mce_adjust_timer_default
 static inline void mce_intel_cmci_poll(void) { }
 static inline void mce_intel_hcpu_update(unsigned long cpu) { }
+static inline void cmci_disable_bank(int bank) { }
 #endif
 
 void mce_timer_kick(unsigned long interval);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87a65c9..b3218cd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -97,6 +97,15 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
+/*
+ * MCA banks controlled through firmware first for corrected errors.
+ * This is a global list of banks for which we won't enable CMCI and we
+ * won't poll. Firmware controls these banks and is responsible for
+ * reporting corrected errors through GHES. Uncorrected/recoverable
+ * errors are still notified through a machine check.
+ */
+mce_banks_t mce_banks_ce_disabled;
+
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
@@ -1935,6 +1944,25 @@ static struct miscdevice mce_chrdev_device = {
 	&mce_chrdev_ops,
 };
 
+static void __mce_disable_bank(void *arg)
+{
+	int bank = *((int *)arg);
+	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
+	cmci_disable_bank(bank);
+}
+
+void mce_disable_bank(int bank)
+{
+	if (bank >= mca_cfg.banks) {
+		pr_warn(FW_BUG
+			"Ignoring request to disable invalid MCA bank %d.\n",
+			bank);
+		return;
+	}
+	set_bit(bank, mce_banks_ce_disabled);
+	on_each_cpu(__mce_disable_bank, &bank, 1);
+}
+
 /*
  * mce=off Disables machine check
  * mce=no_cmci Disables CMCI
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index d5640530..4cfe045 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -203,6 +203,10 @@ static void cmci_discover(int banks)
 		if (test_bit(i, owned))
 			continue;
 
+		/* Skip banks in firmware first mode */
+		if (test_bit(i, mce_banks_ce_disabled))
+			continue;
+
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Already owned by someone else? */
@@ -271,6 +275,19 @@ void cmci_recheck(void)
 	local_irq_restore(flags);
 }
 
+/* Caller must hold the lock on cmci_discover_lock */
+static void __cmci_disable_bank(int bank)
+{
+	u64 val;
+
+	if (!test_bit(bank, __get_cpu_var(mce_banks_owned)))
+		return;
+	rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	val &= ~MCI_CTL2_CMCI_EN;
+	wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	__clear_bit(bank, __get_cpu_var(mce_banks_owned));
+}
+
 /*
  * Disable CMCI on this CPU for all banks it owns when it goes down.
  * This allows other CPUs to claim the banks on rediscovery.
@@ -280,20 +297,12 @@ void cmci_clear(void)
 	unsigned long flags;
 	int i;
 	int banks;
-	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
-			continue;
-		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~MCI_CTL2_CMCI_EN;
-		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
-		__clear_bit(i, __get_cpu_var(mce_banks_owned));
-	}
+	for (i = 0; i < banks; i++)
+		__cmci_disable_bank(i);
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
@@ -327,6 +336,19 @@ void cmci_reenable(void)
 		cmci_discover(banks);
 }
 
+void cmci_disable_bank(int bank)
+{
+	int banks;
+	unsigned long flags;
+
+	if (!cmci_supported(&banks))
+		return;
+
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	__cmci_disable_bank(bank);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
 static void intel_init_cmci(void)
 {
 	int banks;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 88d0b0f..40ffcda 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -39,7 +39,8 @@
 
 #include "apei-internal.h"
 
-#define ERST_PFX "ERST: "
+#undef pr_fmt
+#define pr_fmt(fmt) "ERST: " fmt
 
 /* ERST command status */
 #define ERST_STATUS_SUCCESS			0x0
@@ -109,8 +110,7 @@ static inline int erst_errno(int command_status)
 static int erst_timedout(u64 *t, u64 spin_unit)
 {
 	if ((s64)*t < spin_unit) {
-		pr_warning(FW_WARN ERST_PFX
-			   "Firmware does not respond in time\n");
+		pr_warn(FW_WARN "Firmware does not respond in time.\n");
 		return 1;
 	}
 	*t -= spin_unit;
@@ -186,8 +186,8 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
 
 	if (ctx->value > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
-			"Too long stall time for stall instruction: %llx.\n",
+			pr_warn(FW_WARN
+			"Too long stall time for stall instruction: 0x%llx.\n",
 				   ctx->value);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
@@ -206,8 +206,8 @@ static int erst_exec_stall_while_true(struct apei_exec_context *ctx,
 
 	if (ctx->var1 > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
-		"Too long stall time for stall while true instruction: %llx.\n",
+			pr_warn(FW_WARN
+		"Too long stall time for stall while true instruction: 0x%llx.\n",
 				   ctx->var1);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
@@ -271,8 +271,7 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
 
 	/* ioremap does not work in interrupt context */
 	if (in_interrupt()) {
-		pr_warning(ERST_PFX
-			   "MOVE_DATA can not be used in interrupt context");
+		pr_warn("MOVE_DATA can not be used in interrupt context.\n");
 		return -EBUSY;
 	}
 
@@ -522,8 +521,7 @@ retry:
 				     ERST_RECORD_ID_CACHE_SIZE_MAX);
 		if (new_size <= erst_record_id_cache.size) {
 			if (printk_ratelimit())
-				pr_warning(FW_WARN ERST_PFX
-					   "too many record ID!\n");
+				pr_warn(FW_WARN "too many record IDs!\n");
 			return 0;
 		}
 		alloc_size = new_size * sizeof(entries[0]);
@@ -759,8 +757,7 @@ static int __erst_clear_from_storage(u64 record_id)
 static void pr_unimpl_nvram(void)
 {
 	if (printk_ratelimit())
-		pr_warning(ERST_PFX
-		"NVRAM ERST Log Address Range is not implemented yet\n");
+		pr_warn("NVRAM ERST Log Address Range not implemented yet.\n");
 }
 
 static int __erst_write_to_nvram(const struct cper_record_header *record)
@@ -1120,7 +1117,7 @@ static int __init erst_init(void)
 		goto err;
 
 	if (erst_disable) {
-		pr_info(ERST_PFX
+		pr_info(
 	"Error Record Serialization Table (ERST) support is disabled.\n");
 		goto err;
 	}
@@ -1131,14 +1128,14 @@ static int __init erst_init(void)
 		goto err;
 	else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-		pr_err(ERST_PFX "Failed to get table, %s\n", msg);
+		pr_err("Failed to get table, %s\n", msg);
 		rc = -EINVAL;
 		goto err;
 	}
 
 	rc = erst_check_table(erst_tab);
 	if (rc) {
-		pr_err(FW_BUG ERST_PFX "ERST table is invalid\n");
+		pr_err(FW_BUG "ERST table is invalid.\n");
 		goto err;
 	}
 
@@ -1156,21 +1153,19 @@ static int __init erst_init(void)
 	rc = erst_get_erange(&erst_erange);
 	if (rc) {
 		if (rc == -ENODEV)
-			pr_info(ERST_PFX
+			pr_info(
 	"The corresponding hardware device or firmware implementation "
 	"is not available.\n");
 		else
-			pr_err(ERST_PFX
-			       "Failed to get Error Log Address Range.\n");
+			pr_err("Failed to get Error Log Address Range.\n");
 		goto err_unmap_reg;
 	}
 
 	r = request_mem_region(erst_erange.base, erst_erange.size, "APEI ERST");
 	if (!r) {
-		pr_err(ERST_PFX
-		"Can not request iomem region <0x%16llx-0x%16llx> for ERST.\n",
-		(unsigned long long)erst_erange.base,
-		(unsigned long long)erst_erange.base + erst_erange.size);
+		pr_err("Can not request [mem %#010llx-%#010llx] for ERST.\n",
+		       (unsigned long long)erst_erange.base,
+		       (unsigned long long)erst_erange.base + erst_erange.size - 1);
 		rc = -EIO;
 		goto err_unmap_reg;
 	}
@@ -1180,7 +1175,7 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
-	pr_info(ERST_PFX
+	pr_info(
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
@@ -1192,15 +1187,15 @@ static int __init erst_init(void)
 		rc = pstore_register(&erst_info);
 		if (rc) {
 			if (rc != -EPERM)
-				pr_info(ERST_PFX
-				"Could not register with persistent store\n");
+				pr_info(
+				"Could not register with persistent store.\n");
 			erst_info.buf = NULL;
 			erst_info.bufsize = 0;
 			kfree(buf);
 		}
 	} else
-		pr_err(ERST_PFX
-		"Failed to allocate %lld bytes for persistent store error log\n",
+		pr_err(
+		"Failed to allocate %lld bytes for persistent store error log.\n",
 		erst_erange.size);
 
 	return 0;
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ec9b57d..8ec37bb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -409,6 +409,34 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
+static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
+{
+#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
+	unsigned long pfn;
+	int sec_sev = ghes_severity(gdata->error_severity);
+	struct cper_sec_mem_err *mem_err;
+	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+
+	if (sec_sev == GHES_SEV_CORRECTED &&
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
+	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
+		pfn = mem_err->physical_addr >> PAGE_SHIFT;
+		if (pfn_valid(pfn))
+			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
+		else if (printk_ratelimit())
+			pr_warn(FW_WARN GHES_PFX
+			"Invalid address in generic error data: %#llx\n",
+			mem_err->physical_addr);
+	}
+	if (sev == GHES_SEV_RECOVERABLE &&
+	    sec_sev == GHES_SEV_RECOVERABLE &&
+	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		pfn = mem_err->physical_addr >> PAGE_SHIFT;
+		memory_failure_queue(pfn, 0, 0);
+	}
+#endif
+}
+
 static void ghes_do_proc(struct ghes *ghes,
 			 const struct acpi_hest_generic_status *estatus)
 {
@@ -428,15 +456,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
 						  mem_err);
 #endif
-#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
-			if (sev == GHES_SEV_RECOVERABLE &&
-			    sec_sev == GHES_SEV_RECOVERABLE &&
-			    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
-				unsigned long pfn;
-				pfn = mem_err->physical_addr >> PAGE_SHIFT;
-				memory_failure_queue(pfn, 0, 0);
-			}
-#endif
+			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index f5ef5d5..f5e37f3 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
+#include <asm/mce.h>
 
 #include "apei-internal.h"
 
@@ -121,6 +122,41 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
 }
 EXPORT_SYMBOL_GPL(apei_hest_parse);
 
+/*
+ * Check if firmware advertises firmware first mode. We need FF bit to be set
+ * along with a set of MC banks which work in FF mode.
+ */
+static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
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
+	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) || !cmc->num_hardware_banks)
+		return 1;
+
+	pr_info(HEST_PFX "Enabling Firmware First mode for corrected errors.\n");
+
+	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
+	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
+		mce_disable_bank(mc_bank->bank_number);
+#endif
+	return 1;
+}
+
 struct ghes_arr {
 	struct platform_device **ghes_devs;
 	unsigned int count;
@@ -227,6 +263,9 @@ void __init acpi_hest_init(void)
 		goto err;
 	}
 
+	if (!acpi_disable_cmcff)
+		apei_hest_parse(hest_parse_cmc, NULL);
+
 	if (!ghes_disable) {
 		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
 		if (rc)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8b6a034..3c9e4e9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -123,7 +123,7 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
 	u32 reg = 0;
 
 	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
-	reg &= 0xfffffffe;
+	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
 	reg |= dct;
 	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
 }
@@ -133,8 +133,9 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 {
 	u8 dct  = 0;
 
+	/* For F15 M30h, the second dct is DCT 3, refer to BKDG Section 2.10 */
 	if (addr >= 0x140 && addr <= 0x1a0) {
-		dct   = 1;
+		dct   = (pvt->model >= 0x30) ? 3 : 1;
 		addr -= 0x100;
 	}
 
@@ -202,11 +203,11 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 min_scrubrate = 0x5;
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		min_scrubrate = 0x0;
 
-	/* F15h Erratum #505 */
-	if (boot_cpu_data.x86 == 0x15)
+	/* Erratum #505 */
+	if (pvt->fam == 0x15 && pvt->model < 0x10)
 		f15h_select_dct(pvt, 0);
 
 	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
@@ -218,8 +219,8 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	u32 scrubval = 0;
 	int i, retval = -EINVAL;
 
-	/* F15h Erratum #505 */
-	if (boot_cpu_data.x86 == 0x15)
+	/* Erratum #505 */
+	if (pvt->fam == 0x15 && pvt->model < 0x10)
 		f15h_select_dct(pvt, 0);
 
 	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
@@ -335,7 +336,7 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 	u64 csbase, csmask, base_bits, mask_bits;
 	u8 addr_shift;
 
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
+	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow];
 		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
@@ -343,10 +344,11 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		addr_shift	= 4;
 
 	/*
-	* F16h needs two addr_shift values: 8 for high and 6 for low
-	* (cf. F16h BKDG).
-	*/
-	} else if (boot_cpu_data.x86 == 0x16) {
+	 * F16h and F15h, models 30h and later need two addr_shift values:
+	 * 8 for high and 6 for low (cf. F16h BKDG).
+	 */
+	} else if (pvt->fam == 0x16 ||
+		  (pvt->fam == 0x15 && pvt->model >= 0x30)) {
 		csbase          = pvt->csels[dct].csbases[csrow];
 		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
 
@@ -367,7 +369,7 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
 		addr_shift	= 8;
 
-		if (boot_cpu_data.x86 == 0x15)
+		if (pvt->fam == 0x15)
 			base_bits = mask_bits = GENMASK(19,30) | GENMASK(5,13);
 		else
 			base_bits = mask_bits = GENMASK(19,28) | GENMASK(5,13);
@@ -447,14 +449,14 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	struct amd64_pvt *pvt = mci->pvt_info;
 
 	/* only revE and later have the DRAM Hole Address Register */
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_E) {
+	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_E) {
 		edac_dbg(1, "  revision %d for node %d does not support DHAR\n",
 			 pvt->ext_model, pvt->mc_node_id);
 		return 1;
 	}
 
 	/* valid for Fam10h and above */
-	if (boot_cpu_data.x86 >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
+	if (pvt->fam >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
 		edac_dbg(1, "  Dram Memory Hoisting is DISABLED on this system\n");
 		return 1;
 	}
@@ -486,10 +488,8 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	*hole_base = dhar_base(pvt);
 	*hole_size = (1ULL << 32) - *hole_base;
 
-	if (boot_cpu_data.x86 > 0xf)
-		*hole_offset = f10_dhar_offset(pvt);
-	else
-		*hole_offset = k8_dhar_offset(pvt);
+	*hole_offset = (pvt->fam > 0xf) ? f10_dhar_offset(pvt)
+					: k8_dhar_offset(pvt);
 
 	edac_dbg(1, "  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
 		 pvt->mc_node_id, (unsigned long)*hole_base,
@@ -663,7 +663,7 @@ static unsigned long amd64_determine_edac_cap(struct amd64_pvt *pvt)
 	u8 bit;
 	unsigned long edac_cap = EDAC_FLAG_NONE;
 
-	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= K8_REV_F)
+	bit = (pvt->fam > 0xf || pvt->ext_model >= K8_REV_F)
 		? 19
 		: 17;
 
@@ -675,7 +675,7 @@ static unsigned long amd64_determine_edac_cap(struct amd64_pvt *pvt)
 
 static void amd64_debug_display_dimm_sizes(struct amd64_pvt *, u8);
 
-static void amd64_dump_dramcfg_low(u32 dclr, int chan)
+static void amd64_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
 {
 	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
 
@@ -686,7 +686,7 @@ static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 	edac_dbg(1, "  PAR/ERR parity: %s\n",
 		 (dclr & BIT(8)) ?  "enabled" : "disabled");
 
-	if (boot_cpu_data.x86 == 0x10)
+	if (pvt->fam == 0x10)
 		edac_dbg(1, "  DCT 128bit mode width: %s\n",
 			 (dclr & BIT(11)) ?  "128b" : "64b");
 
@@ -709,21 +709,21 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 		 (pvt->nbcap & NBCAP_SECDED) ? "yes" : "no",
 		 (pvt->nbcap & NBCAP_CHIPKILL) ? "yes" : "no");
 
-	amd64_dump_dramcfg_low(pvt->dclr0, 0);
+	amd64_dump_dramcfg_low(pvt, pvt->dclr0, 0);
 
 	edac_dbg(1, "F3xB0 (Online Spare): 0x%08x\n", pvt->online_spare);
 
 	edac_dbg(1, "F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, offset: 0x%08x\n",
 		 pvt->dhar, dhar_base(pvt),
-		 (boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
-		 : f10_dhar_offset(pvt));
+		 (pvt->fam == 0xf) ? k8_dhar_offset(pvt)
+				   : f10_dhar_offset(pvt));
 
 	edac_dbg(1, "  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
 
 	amd64_debug_display_dimm_sizes(pvt, 0);
 
 	/* everything below this point is Fam10h and above */
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		return;
 
 	amd64_debug_display_dimm_sizes(pvt, 1);
@@ -732,17 +732,20 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
-		amd64_dump_dramcfg_low(pvt->dclr1, 1);
+		amd64_dump_dramcfg_low(pvt, pvt->dclr1, 1);
 }
 
 /*
- * see BKDG, F2x[1,0][5C:40], F2[1,0][6C:60]
+ * See BKDG, F2x[1,0][5C:40], F2[1,0][6C:60]
  */
 static void prep_chip_selects(struct amd64_pvt *pvt)
 {
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
+	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
+	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
+		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
 	} else {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
@@ -768,7 +771,7 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *base0, reg0);
 
-		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
@@ -786,7 +789,7 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *mask0, reg0);
 
-		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
@@ -800,9 +803,9 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt, int cs)
 	enum mem_type type;
 
 	/* F15h supports only DDR3 */
-	if (boot_cpu_data.x86 >= 0x15)
+	if (pvt->fam >= 0x15)
 		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
-	else if (boot_cpu_data.x86 == 0x10 || pvt->ext_model >= K8_REV_F) {
+	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
 		if (pvt->dchr0 & DDR3_MODE)
 			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
 		else
@@ -835,14 +838,13 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 }
 
 /* On F10h and later ErrAddr is MC4_ADDR[47:1] */
-static u64 get_error_address(struct mce *m)
+static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u64 addr;
 	u8 start_bit = 1;
 	u8 end_bit   = 47;
 
-	if (c->x86 == 0xf) {
+	if (pvt->fam == 0xf) {
 		start_bit = 3;
 		end_bit   = 39;
 	}
@@ -852,7 +854,7 @@ static u64 get_error_address(struct mce *m)
 	/*
 	 * Erratum 637 workaround
 	 */
-	if (c->x86 == 0x15) {
+	if (pvt->fam == 0x15) {
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
@@ -916,15 +918,15 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
 	struct amd_northbridge *nb;
-	struct pci_dev *misc, *f1 = NULL;
-	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct pci_dev *f1 = NULL;
+	unsigned int pci_func;
 	int off = range << 3;
 	u32 llim;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
 
-	if (c->x86 == 0xf)
+	if (pvt->fam == 0xf)
 		return;
 
 	if (!dram_rw(pvt, range))
@@ -934,15 +936,17 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 
 	/* F15h: factor in CC6 save area by reading dst node's limit reg */
-	if (c->x86 != 0x15)
+	if (pvt->fam != 0x15)
 		return;
 
 	nb = node_to_amd_nb(dram_dst_node(pvt, range));
 	if (WARN_ON(!nb))
 		return;
 
-	misc = nb->misc;
-	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
+	pci_func = (pvt->model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
+					: PCI_DEVICE_ID_AMD_15H_NB_F1;
+
+	f1 = pci_get_related_function(nb->misc->vendor, pci_func, nb->misc);
 	if (WARN_ON(!f1))
 		return;
 
@@ -1089,7 +1093,7 @@ static int f1x_early_channel_count(struct amd64_pvt *pvt)
 	int i, j, channels = 0;
 
 	/* On F10h, if we are in 128 bit mode, then we are using 2 channels */
-	if (boot_cpu_data.x86 == 0x10 && (pvt->dclr0 & WIDTH_128))
+	if (pvt->fam == 0x10 && (pvt->dclr0 & WIDTH_128))
 		return 2;
 
 	/*
@@ -1173,7 +1177,7 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 }
 
 /*
- * F16h has only limited cs_modes
+ * F16h and F15h model 30h have only limited cs_modes.
  */
 static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 				unsigned cs_mode)
@@ -1190,7 +1194,7 @@ static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		return;
 
 	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
@@ -1218,6 +1222,29 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 }
 
 /*
+ * Determine channel (DCT) based on the interleaving mode (see F15h M30h BKDG,
+ * 2.10.12 Memory Interleaving Modes).
+ */
+static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
+				     u8 intlv_en, int num_dcts_intlv,
+				     u32 dct_sel)
+{
+	u8 channel = 0;
+	u8 select;
+
+	if (!(intlv_en))
+		return (u8)(dct_sel);
+
+	if (num_dcts_intlv == 2) {
+		select = (sys_addr >> 8) & 0x3;
+		channel = select ? 0x3 : 0;
+	} else if (num_dcts_intlv == 4)
+		channel = (sys_addr >> 8) & 0x7;
+
+	return channel;
+}
+
+/*
  * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
  * Interleaving Modes.
  */
@@ -1366,6 +1393,10 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 			 (in_addr & cs_mask), (cs_base & cs_mask));
 
 		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
+			if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+				cs_found =  csrow;
+				break;
+			}
 			cs_found = f10_process_possible_spare(pvt, dct, csrow);
 
 			edac_dbg(1, " MATCH csrow=%d\n", cs_found);
@@ -1384,11 +1415,9 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 {
 	u32 swap_reg, swap_base, swap_limit, rgn_size, tmp_addr;
 
-	if (boot_cpu_data.x86 == 0x10) {
+	if (pvt->fam == 0x10) {
 		/* only revC3 and revE have that feature */
-		if (boot_cpu_data.x86_model < 4 ||
-		    (boot_cpu_data.x86_model < 0xa &&
-		     boot_cpu_data.x86_mask < 3))
+		if (pvt->model < 4 || (pvt->model < 0xa && pvt->stepping < 3))
 			return sys_addr;
 	}
 
@@ -1492,20 +1521,143 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	return cs_found;
 }
 
-static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
-				       int *chan_sel)
+static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
+					u64 sys_addr, int *chan_sel)
+{
+	int cs_found = -EINVAL;
+	int num_dcts_intlv = 0;
+	u64 chan_addr, chan_offset;
+	u64 dct_base, dct_limit;
+	u32 dct_cont_base_reg, dct_cont_limit_reg, tmp;
+	u8 channel, alias_channel, leg_mmio_hole, dct_sel, dct_offset_en;
+
+	u64 dhar_offset		= f10_dhar_offset(pvt);
+	u8 intlv_addr		= dct_sel_interleave_addr(pvt);
+	u8 node_id		= dram_dst_node(pvt, range);
+	u8 intlv_en		= dram_intlv_en(pvt, range);
+
+	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &dct_cont_base_reg);
+	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &dct_cont_limit_reg);
+
+	dct_offset_en		= (u8) ((dct_cont_base_reg >> 3) & BIT(0));
+	dct_sel			= (u8) ((dct_cont_base_reg >> 4) & 0x7);
+
+	edac_dbg(1, "(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
+		 range, sys_addr, get_dram_limit(pvt, range));
+
+	if (!(get_dram_base(pvt, range)  <= sys_addr) &&
+	    !(get_dram_limit(pvt, range) >= sys_addr))
+		return -EINVAL;
+
+	if (dhar_valid(pvt) &&
+	    dhar_base(pvt) <= sys_addr &&
+	    sys_addr < BIT_64(32)) {
+		amd64_warn("Huh? Address is in the MMIO hole: 0x%016llx\n",
+			    sys_addr);
+		return -EINVAL;
+	}
+
+	/* Verify sys_addr is within DCT Range. */
+	dct_base = (u64) dct_sel_baseaddr(pvt);
+	dct_limit = (dct_cont_limit_reg >> 11) & 0x1FFF;
+
+	if (!(dct_cont_base_reg & BIT(0)) &&
+	    !(dct_base <= (sys_addr >> 27) &&
+	      dct_limit >= (sys_addr >> 27)))
+		return -EINVAL;
+
+	/* Verify number of dct's that participate in channel interleaving. */
+	num_dcts_intlv = (int) hweight8(intlv_en);
+
+	if (!(num_dcts_intlv % 2 == 0) || (num_dcts_intlv > 4))
+		return -EINVAL;
+
+	channel = f15_m30h_determine_channel(pvt, sys_addr, intlv_en,
+					     num_dcts_intlv, dct_sel);
+
+	/* Verify we stay within the MAX number of channels allowed */
+	if (channel > 4 || channel < 0)
+		return -EINVAL;
+
+	leg_mmio_hole = (u8) (dct_cont_base_reg >> 1 & BIT(0));
+
+	/* Get normalized DCT addr */
+	if (leg_mmio_hole && (sys_addr >= BIT_64(32)))
+		chan_offset = dhar_offset;
+	else
+		chan_offset = dct_base << 27;
+
+	chan_addr = sys_addr - chan_offset;
+
+	/* remove channel interleave */
+	if (num_dcts_intlv == 2) {
+		if (intlv_addr == 0x4)
+			chan_addr = ((chan_addr >> 9) << 8) |
+						(chan_addr & 0xff);
+		else if (intlv_addr == 0x5)
+			chan_addr = ((chan_addr >> 10) << 9) |
+						(chan_addr & 0x1ff);
+		else
+			return -EINVAL;
+
+	} else if (num_dcts_intlv == 4) {
+		if (intlv_addr == 0x4)
+			chan_addr = ((chan_addr >> 10) << 8) |
+							(chan_addr & 0xff);
+		else if (intlv_addr == 0x5)
+			chan_addr = ((chan_addr >> 11) << 9) |
+							(chan_addr & 0x1ff);
+		else
+			return -EINVAL;
+	}
+
+	if (dct_offset_en) {
+		amd64_read_pci_cfg(pvt->F1,
+				   DRAM_CONT_HIGH_OFF + (int) channel * 4,
+				   &tmp);
+		chan_addr +=  (u64) ((tmp >> 11) & 0xfff) << 27;
+	}
+
+	f15h_select_dct(pvt, channel);
+
+	edac_dbg(1, "   Normalized DCT addr: 0x%llx\n", chan_addr);
+
+	/*
+	 * Find Chip select:
+	 * if channel = 3, then alias it to 1. This is because, in F15 M30h,
+	 * there is support for 4 DCT's, but only 2 are currently functional.
+	 * They are DCT0 and DCT3. But we have read all registers of DCT3 into
+	 * pvt->csels[1]. So we need to use '1' here to get correct info.
+	 * Refer F15 M30h BKDG Section 2.10 and 2.10.3 for clarifications.
+	 */
+	alias_channel =  (channel == 3) ? 1 : channel;
+
+	cs_found = f1x_lookup_addr_in_dct(chan_addr, node_id, alias_channel);
+
+	if (cs_found >= 0)
+		*chan_sel = alias_channel;
+
+	return cs_found;
+}
+
+static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt,
+					u64 sys_addr,
+					int *chan_sel)
 {
 	int cs_found = -EINVAL;
 	unsigned range;
 
 	for (range = 0; range < DRAM_RANGES; range++) {
-
 		if (!dram_rw(pvt, range))
 			continue;
 
-		if ((get_dram_base(pvt, range)  <= sys_addr) &&
-		    (get_dram_limit(pvt, range) >= sys_addr)) {
+		if (pvt->fam == 0x15 && pvt->model >= 0x30)
+			cs_found = f15_m30h_match_to_this_node(pvt, range,
+							       sys_addr,
+							       chan_sel);
 
+		else if ((get_dram_base(pvt, range)  <= sys_addr) &&
+			 (get_dram_limit(pvt, range) >= sys_addr)) {
 			cs_found = f1x_match_to_this_node(pvt, range,
 							  sys_addr, chan_sel);
 			if (cs_found >= 0)
@@ -1554,7 +1706,7 @@ static void amd64_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 	u32 *dcsb = ctrl ? pvt->csels[1].csbases : pvt->csels[0].csbases;
 	u32 dbam  = ctrl ? pvt->dbam1 : pvt->dbam0;
 
-	if (boot_cpu_data.x86 == 0xf) {
+	if (pvt->fam == 0xf) {
 		/* K8 families < revF not supported yet */
 	       if (pvt->ext_model < K8_REV_F)
 			return;
@@ -1624,6 +1776,17 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
+	[F15_M30H_CPUS] = {
+		.ctl_name = "F15h_M30h",
+		.f1_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f16_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
+		}
+	},
 	[F16_CPUS] = {
 		.ctl_name = "F16h",
 		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
@@ -1860,7 +2023,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 
 	memset(&err, 0, sizeof(err));
 
-	sys_addr = get_error_address(m);
+	sys_addr = get_error_address(pvt, m);
 
 	if (ecc_type == 2)
 		err.syndrome = extract_syndrome(m->status);
@@ -1921,10 +2084,9 @@ static void free_mc_sibling_devs(struct amd64_pvt *pvt)
  */
 static void read_mc_regs(struct amd64_pvt *pvt)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
+	unsigned range;
 	u64 msr_val;
 	u32 tmp;
-	unsigned range;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
@@ -1985,14 +2147,14 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	pvt->ecc_sym_sz = 4;
 
-	if (c->x86 >= 0x10) {
+	if (pvt->fam >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		if (c->x86 != 0x16)
+		if (pvt->fam != 0x16)
 			/* F16h has only DCT0 */
 			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
-		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
+		if ((pvt->fam > 0x10 || pvt->model > 7) && tmp & BIT(25))
 			pvt->ecc_sym_sz = 8;
 	}
 	dump_misc_regs(pvt);
@@ -2086,7 +2248,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		bool row_dct0 = !!csrow_enabled(i, 0, pvt);
 		bool row_dct1 = false;
 
-		if (boot_cpu_data.x86 != 0xf)
+		if (pvt->fam != 0xf)
 			row_dct1 = !!csrow_enabled(i, 1, pvt);
 
 		if (!row_dct0 && !row_dct1)
@@ -2104,7 +2266,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		}
 
 		/* K8 has only one DCT */
-		if (boot_cpu_data.x86 != 0xf && row_dct1) {
+		if (pvt->fam != 0xf && row_dct1) {
 			int row_dct1_pages = amd64_csrow_nr_pages(pvt, 1, i);
 
 			csrow->channels[1]->dimm->nr_pages = row_dct1_pages;
@@ -2333,13 +2495,14 @@ static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 
 static int set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
 	int rc;
 
 	rc = amd64_create_sysfs_dbg_files(mci);
 	if (rc < 0)
 		return rc;
 
-	if (boot_cpu_data.x86 >= 0x10) {
+	if (pvt->fam >= 0x10) {
 		rc = amd64_create_sysfs_inject_files(mci);
 		if (rc < 0)
 			return rc;
@@ -2350,9 +2513,11 @@ static int set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 
 static void del_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
+
 	amd64_remove_sysfs_dbg_files(mci);
 
-	if (boot_cpu_data.x86 >= 0x10)
+	if (pvt->fam >= 0x10)
 		amd64_remove_sysfs_inject_files(mci);
 }
 
@@ -2387,10 +2552,14 @@ static void setup_mci_misc_attrs(struct mem_ctl_info *mci,
  */
 static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 {
-	u8 fam = boot_cpu_data.x86;
 	struct amd64_family_type *fam_type = NULL;
 
-	switch (fam) {
+	pvt->ext_model  = boot_cpu_data.x86_model >> 4;
+	pvt->stepping	= boot_cpu_data.x86_mask;
+	pvt->model	= boot_cpu_data.x86_model;
+	pvt->fam	= boot_cpu_data.x86;
+
+	switch (pvt->fam) {
 	case 0xf:
 		fam_type		= &amd64_family_types[K8_CPUS];
 		pvt->ops		= &amd64_family_types[K8_CPUS].ops;
@@ -2402,6 +2571,12 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		break;
 
 	case 0x15:
+		if (pvt->model == 0x30) {
+			fam_type	= &amd64_family_types[F15_M30H_CPUS];
+			pvt->ops	= &amd64_family_types[F15_M30H_CPUS].ops;
+			break;
+		}
+
 		fam_type		= &amd64_family_types[F15_CPUS];
 		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
 		break;
@@ -2416,10 +2591,8 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		return NULL;
 	}
 
-	pvt->ext_model = boot_cpu_data.x86_model >> 4;
-
 	amd64_info("%s %sdetected (node %d).\n", fam_type->ctl_name,
-		     (fam == 0xf ?
+		     (pvt->fam == 0xf ?
 				(pvt->ext_model >= K8_REV_F  ? "revF or later "
 							     : "revE or earlier ")
 				 : ""), pvt->mc_node_id);
@@ -2470,8 +2643,15 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	layers[0].size = pvt->csels[0].b_cnt;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = pvt->channel_count;
+
+	/*
+	 * Always allocate two channels since we can have setups with DIMMs on
+	 * only one channel. Also, this simplifies handling later for the price
+	 * of a couple of KBs tops.
+	 */
+	layers[1].size = 2;
 	layers[1].is_virt_csrow = false;
+
 	mci = edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, 0);
 	if (!mci)
 		goto err_siblings;
@@ -2579,6 +2759,8 @@ static void amd64_remove_one_instance(struct pci_dev *pdev)
 	struct ecc_settings *s = ecc_stngs[nid];
 
 	mci = find_mci_by_dev(&pdev->dev);
+	WARN_ON(!mci);
+
 	del_mc_sysfs_attrs(mci);
 	/* Remove from EDAC CORE tracking list */
 	mci = edac_mc_del_mc(&pdev->dev);
@@ -2638,6 +2820,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_15H_M30H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 2c6f113..d2443cf 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -170,6 +170,8 @@
 /*
  * PCI-defined configuration space registers
  */
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
@@ -181,13 +183,22 @@
 #define DRAM_BASE_LO			0x40
 #define DRAM_LIMIT_LO			0x44
 
-#define dram_intlv_en(pvt, i)		((u8)((pvt->ranges[i].base.lo >> 8) & 0x7))
+/*
+ * F15 M30h D18F1x2[1C:00]
+ */
+#define DRAM_CONT_BASE			0x200
+#define DRAM_CONT_LIMIT			0x204
+
+/*
+ * F15 M30h D18F1x2[4C:40]
+ */
+#define DRAM_CONT_HIGH_OFF		0x240
+
 #define dram_rw(pvt, i)			((u8)(pvt->ranges[i].base.lo & 0x3))
 #define dram_intlv_sel(pvt, i)		((u8)((pvt->ranges[i].lim.lo >> 8) & 0x7))
 #define dram_dst_node(pvt, i)		((u8)(pvt->ranges[i].lim.lo & 0x7))
 
 #define DHAR				0xf0
-#define dhar_valid(pvt)			((pvt)->dhar & BIT(0))
 #define dhar_mem_hoist_valid(pvt)	((pvt)->dhar & BIT(1))
 #define dhar_base(pvt)			((pvt)->dhar & 0xff000000)
 #define k8_dhar_offset(pvt)		(((pvt)->dhar & 0x0000ff00) << 16)
@@ -234,8 +245,6 @@
 #define DDR3_MODE			BIT(8)
 
 #define DCT_SEL_LO			0x110
-#define dct_sel_baseaddr(pvt)		((pvt)->dct_sel_lo & 0xFFFFF800)
-#define dct_sel_interleave_addr(pvt)	(((pvt)->dct_sel_lo >> 6) & 0x3)
 #define dct_high_range_enabled(pvt)	((pvt)->dct_sel_lo & BIT(0))
 #define dct_interleave_enabled(pvt)	((pvt)->dct_sel_lo & BIT(2))
 
@@ -297,6 +306,7 @@ enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
 	F15_CPUS,
+	F15_M30H_CPUS,
 	F16_CPUS,
 	NUM_FAMILIES,
 };
@@ -337,6 +347,10 @@ struct amd64_pvt {
 	struct pci_dev *F1, *F2, *F3;
 
 	u16 mc_node_id;		/* MC index of this MC node */
+	u8 fam;			/* CPU family */
+	u8 model;		/* ... model */
+	u8 stepping;		/* ... stepping */
+
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -414,6 +428,14 @@ static inline u16 extract_syndrome(u64 status)
 	return ((status >> 47) & 0xff) | ((status >> 16) & 0xff00);
 }
 
+static inline u8 dct_sel_interleave_addr(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30)
+		return (((pvt->dct_sel_hi >> 9) & 0x1) << 2) |
+			((pvt->dct_sel_lo >> 6) & 0x3);
+
+	return	((pvt)->dct_sel_lo >> 6) & 0x3;
+}
 /*
  * per-node ECC settings descriptor
  */
@@ -504,3 +526,33 @@ static inline void enable_caches(void *dummy)
 {
 	write_cr0(read_cr0() & ~X86_CR0_CD);
 }
+
+static inline u8 dram_intlv_en(struct amd64_pvt *pvt, unsigned int i)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &tmp);
+		return (u8) tmp & 0xF;
+	}
+	return (u8) (pvt->ranges[i].base.lo >> 8) & 0x7;
+}
+
+static inline u8 dhar_valid(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
+		return (tmp >> 1) & BIT(0);
+	}
+	return (pvt)->dhar & BIT(0);
+}
+
+static inline u32 dct_sel_baseaddr(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
+		return (tmp >> 11) & 0x1FFF;
+	}
+	return (pvt)->dct_sel_lo & 0xFFFFF800;
+}
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 7f3c571..df6575f 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -789,7 +789,7 @@ static struct cpc925_dev_info cpc925_devs[] = {
 	.exit = cpc925_htlink_exit,
 	.check = cpc925_htlink_check,
 	},
-	{0}, /* Terminated by NULL */
+	{ }
 };
 
 /*
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index e7c32c4..9f7e0e60 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -58,8 +58,10 @@ static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
+	ret = kstrtol(val, 0, &l);
+	if (ret)
+		return ret;
+	if ((int)l != l)
 		return -EINVAL;
 	*((int *)kp->arg) = l;
 
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index aa44c17..be10a74 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -260,8 +260,7 @@ static void i3200_check(struct mem_ctl_info *mci)
 	i3200_process_error_info(mci, &info);
 }
 
-
-void __iomem *i3200_map_mchbar(struct pci_dev *pdev)
+static void __iomem *i3200_map_mchbar(struct pci_dev *pdev)
 {
 	union {
 		u64 mchbar;
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index c9db24d..1a4df82 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -248,8 +248,7 @@ static void x38_check(struct mem_ctl_info *mci)
 	x38_process_error_info(mci, &info);
 }
 
-
-void __iomem *x38_map_mchbar(struct pci_dev *pdev)
+static void __iomem *x38_map_mchbar(struct pci_dev *pdev)
 {
 	union {
 		u64 mchbar;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f022460..d2d59b4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1798,6 +1798,7 @@ enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
 	MF_MUST_KILL = 1 << 2,
+	MF_SOFT_OFFLINE = 1 << 3,
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bed2e8..d1fe5d0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,8 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2c13aa7..55d7c80 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1286,7 +1286,10 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		memory_failure(entry.pfn, entry.trapno, entry.flags);
+		if (entry.flags & MF_SOFT_OFFLINE)
+			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
+		else
+			memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }
 
