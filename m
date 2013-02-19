Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab3BSO4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:56:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47226 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3BSO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:56:39 -0500
Date: Tue, 19 Feb 2013 15:56:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.9
Message-ID: <20130219145634.GA13562@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   HEAD: af8d102f999a41c0189bd2cce488bac2ee88c29b x86/intel/irq_remapping: Clean up x2apic opt-out security warning mess

Main changes:

 * Multiple MSI support added to the APIC, PCI and AHCI code - 
   acked by all relevant maintainers, by Alexander Gordeev.

   The advantage is that multiple AHCI ports can have multiple
   MSI irqs assigned, and can thus spread to multiple CPUs.

   [ Drivers can make use of this new facility via the
     pci_enable_msi_block_auto() method. ]

 * x86 IOAPIC code from interrupt remapping cleanups from Joerg 
   Roedel:

   These patches move all interrupt remapping specific checks 
   out of the x86 core code and replaces the respective 
   call-sites with function pointers. As a result the 
   interrupt remapping code is better abstraced from x86 core 
   interrupt handling code.

 * Various smaller improvements, fixes and cleanups.

out-of-topic modifications in x86-apic-for-linus:
-------------------------------------------------
drivers/ata/ahci.c                 # 5ca72c4: AHCI: Support multiple MSIs
drivers/ata/ahci.h                 # 5ca72c4: AHCI: Support multiple MSIs
drivers/ata/libahci.c              # 5ca72c4: AHCI: Support multiple MSIs
drivers/iommu/amd_iommu.c          # 9b1b0e4: x86, io-apic: Move CONFIG_IRQ_REM
drivers/iommu/dmar.c               # 078e1ee: x86, irq: Move irq_remapping_enab
drivers/iommu/intel-iommu.c        # 078e1ee: x86, irq: Move irq_remapping_enab
drivers/iommu/intel_irq_remapping.c# af8d102: x86/intel/irq_remapping: Clean up
                                   # 9b1b0e4: x86, io-apic: Move CONFIG_IRQ_REM
                                   # afcc8a4: x86, io_apic: Introduce x86_io_ap
drivers/iommu/irq_remapping.c      # a1bb20c: x86, irq: Move irq_remapped out o
                                   # da16532: x86, io_apic: Introduce eoi_ioapi
                                   # 7601384: x86, msi: Introduce x86_msi.compo
                                   # 2976fd8: x86, irq: Introduce setup_remappe
                                   # 11b4a1c: x86, irq: Move irq_remapped() che
                                   # 9b1b0e4: x86, io-apic: Move CONFIG_IRQ_REM
                                   # 6a9f5de: x86, io_apic: Move irq_remapping_
                                   # a6a25dd: x86, io_apic: Convert setup_ioapi
                                   # 373dd7a: x86, io_apic: Introduce set_affin
                                   # 5afba62: x86, msi: Use IRQ remapping speci
                                   # 71054d8: x86, hpet: Introduce x86_msi_ops.
                                   # 1c4248c: x86, io_apic: Introduce x86_io_ap
                                   # 70733e0: x86, apic: Move irq_remapping_ena
drivers/iommu/irq_remapping.h      # 078e1ee: x86, irq: Move irq_remapping_enab
drivers/pci/msi.c                  # 08261d8: PCI/MSI: Enable multiple MSIs wit
include/linux/irq.h                # 5afba62: x86, msi: Use IRQ remapping speci
                                   # 51906e7: x86/MSI: Support multiple MSIs in
include/linux/pci.h                # 08261d8: PCI/MSI: Enable multiple MSIs wit
kernel/irq/chip.c                  # 51906e7: x86/MSI: Support multiple MSIs in

 Thanks,

	Ingo

------------------>
Alexander Gordeev (3):
      x86/MSI: Support multiple MSIs in presense of IRQ remapping
      PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
      AHCI: Support multiple MSIs

Alok N Kataria (2):
      x86/apic: Allow x2apic without IR on VMware platform
      x86, kvm: Fix intialization warnings in kvm.c

Andy Lutomirski (1):
      x86/intel/irq_remapping: Clean up x2apic opt-out security warning mess

Dave Jones (1):
      x86/apic: Remove noisy zero-mask warning from default_send_IPI_mask_logical()

Joerg Roedel (19):
      x86, apic: Move irq_remapping_enabled checks into IRQ-remapping code
      x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
      x86, io_apic: Introduce x86_io_apic_ops.disable()
      x86, io_apic: Introduce x86_io_apic_ops.print_entries for debugging
      x86, hpet: Introduce x86_msi_ops.setup_hpet_msi
      x86, msi: Use IRQ remapping specific setup_msi_irqs routine
      x86, io_apic: Introduce set_affinity function pointer
      x86, io_apic: Convert setup_ioapic_entry to function pointer
      x86, io_apic: Move irq_remapping_enabled checks out of check_timer()
      x86, io_apic: Remove irq_remapping_enabled check in setup_timer_IRQ0_pin
      x86, irq: Move irq_remapping_enabled declaration to iommu code
      x86, irq: Add data structure to keep AMD specific irq remapping information
      x86, io-apic: Move CONFIG_IRQ_REMAP code out of x86 core
      x86, io-apic: Remove !irq_remapped() check from __target_IO_APIC_irq()
      x86, irq: Move irq_remapped() check into free_remapped_irq
      x86, irq: Introduce setup_remapped_irq()
      x86, msi: Introduce x86_msi.compose_msi_msg call-back
      x86, io_apic: Introduce eoi_ioapic_pin call-back
      x86, irq: Move irq_remapped out of x86 core code


 Documentation/PCI/MSI-HOWTO.txt      |  37 ++-
 arch/x86/include/asm/hpet.h          |   5 +-
 arch/x86/include/asm/hw_irq.h        |  13 +-
 arch/x86/include/asm/hypervisor.h    |  13 +-
 arch/x86/include/asm/io_apic.h       |  28 +++
 arch/x86/include/asm/irq_remapping.h |  40 ++-
 arch/x86/include/asm/kvm_para.h      |   8 +-
 arch/x86/include/asm/pci.h           |   3 +
 arch/x86/include/asm/x86_init.h      |  27 ++-
 arch/x86/kernel/apic/apic.c          |  28 +--
 arch/x86/kernel/apic/io_apic.c       | 457 +++++++++++++++--------------------
 arch/x86/kernel/apic/ipi.c           |   2 +-
 arch/x86/kernel/cpu/hypervisor.c     |   7 +
 arch/x86/kernel/cpu/vmware.c         |  13 +
 arch/x86/kernel/hpet.c               |   2 +-
 arch/x86/kernel/kvm.c                |   1 +
 arch/x86/kernel/x86_init.c           |  24 +-
 arch/x86/xen/enlighten.c             |   1 +
 drivers/ata/ahci.c                   |  93 ++++++-
 drivers/ata/ahci.h                   |   6 +
 drivers/ata/libahci.c                | 118 ++++++++-
 drivers/iommu/amd_iommu.c            |   8 +-
 drivers/iommu/dmar.c                 |   2 +
 drivers/iommu/intel-iommu.c          |   2 +
 drivers/iommu/intel_irq_remapping.c  |  48 +++-
 drivers/iommu/irq_remapping.c        | 231 +++++++++++++++++-
 drivers/iommu/irq_remapping.h        |   1 +
 drivers/pci/msi.c                    |  26 ++
 include/linux/irq.h                  |   8 +
 include/linux/pci.h                  |   7 +
 kernel/irq/chip.c                    |  30 ++-
 31 files changed, 918 insertions(+), 371 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 53e6fca..a091780 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,15 +127,42 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_disable_msi
+4.2.3 pci_enable_msi_block_auto
+
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
+
+This variation on pci_enable_msi() call allows a device driver to request
+the maximum possible number of MSIs.  The MSI specification only allows
+interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
+
+If this function returns a positive number, it indicates that it has
+succeeded and the returned value is the number of allocated interrupts. In
+this case, the function enables MSI on this device and updates dev->irq to
+be the lowest of the new interrupts assigned to it.  The other interrupts
+assigned to the device are in the range dev->irq to dev->irq + returned
+value - 1.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If the device driver needs to know the number of interrupts the device
+supports it can pass the pointer count where that number is stored. The
+device driver must decide what action to take if pci_enable_msi_block_auto()
+succeeds, but returns a value less than the number of interrupts supported.
+If the device driver does not need to know the number of interrupts
+supported, it can set the pointer count to NULL.
+
+4.2.4 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
 This function should be used to undo the effect of pci_enable_msi() or
-pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
-interrupt number and frees the previously allocated message signaled
-interrupt(s).  The interrupt may subsequently be assigned to another
-device, so drivers should not cache the value of dev->irq.
+pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
+dev->irq to the pin-based interrupt number and frees the previously
+allocated message signaled interrupt(s).  The interrupt may subsequently be
+assigned to another device, so drivers should not cache the value of
+dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 434e210..b18df57 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -80,9 +80,9 @@ extern void hpet_msi_write(struct hpet_dev *hdev, struct msi_msg *msg);
 extern void hpet_msi_read(struct hpet_dev *hdev, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
-extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
+extern int default_setup_hpet_msi(unsigned int irq, unsigned int id);
 #else
-static inline int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
+static inline int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	return -EINVAL;
 }
@@ -111,6 +111,7 @@ extern void hpet_unregister_irq_handler(rtc_irq_handler handler);
 static inline int hpet_enable(void) { return 0; }
 static inline int is_hpet_enabled(void) { return 0; }
 #define hpet_readl(a) 0
+#define default_setup_hpet_msi	NULL
 
 #endif
 #endif /* _ASM_X86_HPET_H */
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..10a78c3 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
+/* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -108,6 +109,12 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
+/* AMD specific interrupt remapping information */
+struct irq_2_irte {
+	u16 devid; /* Device ID for IRTE table */
+	u16 index; /* Index into IRTE table*/
+};
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -120,7 +127,11 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	struct irq_2_iommu	irq_2_iommu;
+	u8			remapped : 1;
+	union {
+		struct irq_2_iommu irq_2_iommu;
+		struct irq_2_irte  irq_2_irte;
+	};
 #endif
 };
 
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b518c75..86095ed 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -25,6 +25,7 @@
 
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
+extern bool hypervisor_x2apic_available(void);
 
 /*
  * x86 hypervisor information
@@ -41,6 +42,9 @@ struct hypervisor_x86 {
 
 	/* Platform setup (run once per boot) */
 	void		(*init_platform)(void);
+
+	/* X2APIC detection (run once per boot) */
+	bool		(*x2apic_available)(void);
 };
 
 extern const struct hypervisor_x86 *x86_hyper;
@@ -51,13 +55,4 @@ extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 extern const struct hypervisor_x86 x86_hyper_kvm;
 
-static inline bool hypervisor_x2apic_available(void)
-{
-	if (kvm_para_available())
-		return true;
-	if (xen_x2apic_para_available())
-		return true;
-	return false;
-}
-
 #endif
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 73d8c53..459e50a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -144,11 +144,24 @@ extern int timer_through_8259;
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
 struct io_apic_irq_attr;
+struct irq_cfg;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
+extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
+				     unsigned int, int,
+				     struct io_apic_irq_attr *);
+extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
+				     unsigned int, int,
+				     struct io_apic_irq_attr *);
+extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
+
+extern void native_compose_msi_msg(struct pci_dev *pdev,
+				   unsigned int irq, unsigned int dest,
+				   struct msi_msg *msg, u8 hpet_id);
+extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
@@ -179,6 +192,12 @@ extern void __init native_io_apic_init_mappings(void);
 extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+extern void native_disable_io_apic(void);
+extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
+extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
+extern int native_ioapic_set_affinity(struct irq_data *,
+				      const struct cpumask *,
+				      bool);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -193,6 +212,9 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 {
 	x86_io_apic_ops.modify(apic, reg, value);
 }
+
+extern void io_apic_eoi(unsigned int apic, unsigned int vector);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -223,6 +245,12 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_read		NULL
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
+#define native_disable_io_apic		NULL
+#define native_io_apic_print_entries	NULL
+#define native_ioapic_set_affinity	NULL
+#define native_setup_ioapic_entry	NULL
+#define native_compose_msi_msg		NULL
+#define native_eoi_ioapic_pin		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5fb9bbb..95fd352 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -26,8 +26,6 @@
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern int irq_remapping_enabled;
-
 extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
 extern int irq_remapping_prepare(void);
@@ -40,21 +38,19 @@ extern int setup_ioapic_remapped_entry(int irq,
 				       unsigned int destination,
 				       int vector,
 				       struct io_apic_irq_attr *attr);
-extern int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask,
-				     bool force);
 extern void free_remapped_irq(int irq);
 extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     unsigned int irq, unsigned int dest,
 				     struct msi_msg *msg, u8 hpet_id);
-extern int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
-extern int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
+extern void panic_if_irq_remap(const char *msg);
+extern bool setup_remapped_irq(int irq,
+			       struct irq_cfg *cfg,
+			       struct irq_chip *chip);
 
-#else  /* CONFIG_IRQ_REMAP */
+void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
-#define irq_remapping_enabled	0
+#else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
@@ -71,30 +67,30 @@ static inline int setup_ioapic_remapped_entry(int irq,
 {
 	return -ENODEV;
 }
-static inline int set_remapped_irq_affinity(struct irq_data *data,
-					    const struct cpumask *mask,
-					    bool force)
-{
-	return 0;
-}
 static inline void free_remapped_irq(int irq) { }
 static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
 					    unsigned int irq, unsigned int dest,
 					    struct msi_msg *msg, u8 hpet_id)
 {
 }
-static inline int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
+static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	return -ENODEV;
 }
-static inline int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-					 int index, int sub_handle)
+
+static inline void panic_if_irq_remap(const char *msg)
+{
+}
+
+static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
-	return -ENODEV;
 }
-static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
+
+static inline bool setup_remapped_irq(int irq,
+				      struct irq_cfg *cfg,
+				      struct irq_chip *chip)
 {
-	return -ENODEV;
+	return false;
 }
 #endif /* CONFIG_IRQ_REMAP */
 
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 5ed1f161..65231e1 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,13 +85,13 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline int kvm_para_available(void)
+static inline bool kvm_para_available(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 	char signature[13];
 
 	if (boot_cpu_data.cpuid_level < 0)
-		return 0;	/* So we don't blow up on old processors */
+		return false;	/* So we don't blow up on old processors */
 
 	if (cpu_has_hypervisor) {
 		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
@@ -101,10 +101,10 @@ static inline int kvm_para_available(void)
 		signature[12] = 0;
 
 		if (strcmp(signature, "KVMKVMKVM") == 0)
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
 static inline unsigned int kvm_arch_para_features(void)
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index dba7805..c28fd02 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -121,9 +121,12 @@ static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
 #define arch_teardown_msi_irq x86_teardown_msi_irq
 #define arch_restore_msi_irqs x86_restore_msi_irqs
 /* implemented in arch/x86/kernel/apic/io_apic. */
+struct msi_desc;
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev, int irq);
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+		  unsigned int irq_base, unsigned int irq_offset);
 /* default to the implementation in drivers/lib/msi.c */
 #define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
 #define HAVE_DEFAULT_MSI_RESTORE_IRQS
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 5769349..7669941 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -181,19 +181,38 @@ struct x86_platform_ops {
 };
 
 struct pci_dev;
+struct msi_msg;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
+				unsigned int dest, struct msi_msg *msg,
+			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
+	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
+struct IO_APIC_route_entry;
+struct io_apic_irq_attr;
+struct irq_data;
+struct cpumask;
+
 struct x86_io_apic_ops {
-	void		(*init)  (void);
-	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
-	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*init)   (void);
+	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
+	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*disable)(void);
+	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
+	int		(*set_affinity)(struct irq_data *data,
+					const struct cpumask *mask,
+					bool force);
+	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
+				       unsigned int destination, int vector,
+				       struct io_apic_irq_attr *attr);
+	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b994cc8..a5b4dce 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1477,8 +1477,7 @@ void __init bsp_end_local_APIC_setup(void)
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (irq_remapping_enabled)
-		irq_remap_enable_fault_handling();
+	irq_remap_enable_fault_handling();
 
 }
 
@@ -2251,8 +2250,7 @@ static int lapic_suspend(void)
 	local_irq_save(flags);
 	disable_local_APIC();
 
-	if (irq_remapping_enabled)
-		irq_remapping_disable();
+	irq_remapping_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2268,16 +2266,15 @@ static void lapic_resume(void)
 		return;
 
 	local_irq_save(flags);
-	if (irq_remapping_enabled) {
-		/*
-		 * IO-APIC and PIC have their own resume routines.
-		 * We just mask them here to make sure the interrupt
-		 * subsystem is completely quiet while we enable x2apic
-		 * and interrupt-remapping.
-		 */
-		mask_ioapic_entries();
-		legacy_pic->mask_all();
-	}
+
+	/*
+	 * IO-APIC and PIC have their own resume routines.
+	 * We just mask them here to make sure the interrupt
+	 * subsystem is completely quiet while we enable x2apic
+	 * and interrupt-remapping.
+	 */
+	mask_ioapic_entries();
+	legacy_pic->mask_all();
 
 	if (x2apic_mode)
 		enable_x2apic();
@@ -2320,8 +2317,7 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (irq_remapping_enabled)
-		irq_remapping_reenable(x2apic_mode);
+	irq_remapping_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b739d39..9ed796c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,22 +68,6 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-#ifdef CONFIG_IRQ_REMAP
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return cfg->irq_2_iommu.iommu != NULL;
-}
-#else
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return false;
-}
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-}
-#endif
-
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -300,9 +284,9 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	return cfg;
 }
 
-static int alloc_irq_from(unsigned int from, int node)
+static int alloc_irqs_from(unsigned int from, unsigned int count, int node)
 {
-	return irq_alloc_desc_from(from, node);
+	return irq_alloc_descs_from(from, count, node);
 }
 
 static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
@@ -326,7 +310,7 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
-static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
+void io_apic_eoi(unsigned int apic, unsigned int vector)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(vector, &io_apic->eoi);
@@ -573,19 +557,10 @@ static void unmask_ioapic_irq(struct irq_data *data)
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
  */
-static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
+void native_eoi_ioapic_pin(int apic, int pin, int vector)
 {
 	if (mpc_ioapic_ver(apic) >= 0x20) {
-		/*
-		 * Intr-remapping uses pin number as the virtual vector
-		 * in the RTE. Actual vector is programmed in
-		 * intr-remapping table entry. Hence for the io-apic
-		 * EOI we use the pin number.
-		 */
-		if (cfg && irq_remapped(cfg))
-			io_apic_eoi(apic, pin);
-		else
-			io_apic_eoi(apic, vector);
+		io_apic_eoi(apic, vector);
 	} else {
 		struct IO_APIC_route_entry entry, entry1;
 
@@ -606,14 +581,15 @@ static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
 	}
 }
 
-static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin)
-		__eoi_ioapic_pin(entry->apic, entry->pin, cfg->vector, cfg);
+		x86_io_apic_ops.eoi_ioapic_pin(entry->apic, entry->pin,
+					       cfg->vector);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -650,7 +626,7 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 		}
 
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		__eoi_ioapic_pin(apic, pin, entry.vector, NULL);
+		x86_io_apic_ops.eoi_ioapic_pin(apic, pin, entry.vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
@@ -1304,25 +1280,18 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 		fasteoi = false;
 	}
 
-	if (irq_remapped(cfg)) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
+	if (setup_remapped_irq(irq, cfg, chip))
 		fasteoi = trigger != 0;
-	}
 
 	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
 	irq_set_chip_and_handler_name(irq, chip, hdl,
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
-			       unsigned int destination, int vector,
-			       struct io_apic_irq_attr *attr)
+int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
+			      unsigned int destination, int vector,
+			      struct io_apic_irq_attr *attr)
 {
-	if (irq_remapping_enabled)
-		return setup_ioapic_remapped_entry(irq, entry, destination,
-						   vector, attr);
-
 	memset(entry, 0, sizeof(*entry));
 
 	entry->delivery_mode = apic->irq_delivery_mode;
@@ -1370,8 +1339,8 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
 		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
-	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic %d, pin %d\n",
+	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
+		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
 
@@ -1479,9 +1448,6 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
 
-	if (irq_remapping_enabled)
-		return;
-
 	memset(&entry, 0, sizeof(entry));
 
 	/*
@@ -1513,9 +1479,63 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
-__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
+void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 {
 	int i;
+
+	pr_debug(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
+
+	for (i = 0; i <= nr_entries; i++) {
+		struct IO_APIC_route_entry entry;
+
+		entry = ioapic_read_entry(apic, i);
+
+		pr_debug(" %02x %02X  ", i, entry.dest);
+		pr_cont("%1d    %1d    %1d   %1d   %1d    "
+			"%1d    %1d    %02X\n",
+			entry.mask,
+			entry.trigger,
+			entry.irr,
+			entry.polarity,
+			entry.delivery_status,
+			entry.dest_mode,
+			entry.delivery_mode,
+			entry.vector);
+	}
+}
+
+void intel_ir_io_apic_print_entries(unsigned int apic,
+				    unsigned int nr_entries)
+{
+	int i;
+
+	pr_debug(" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
+
+	for (i = 0; i <= nr_entries; i++) {
+		struct IR_IO_APIC_route_entry *ir_entry;
+		struct IO_APIC_route_entry entry;
+
+		entry = ioapic_read_entry(apic, i);
+
+		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
+
+		pr_debug(" %02x %04X ", i, ir_entry->index);
+		pr_cont("%1d   %1d    %1d    %1d   %1d   "
+			"%1d    %1d     %X    %02X\n",
+			ir_entry->format,
+			ir_entry->mask,
+			ir_entry->trigger,
+			ir_entry->irr,
+			ir_entry->polarity,
+			ir_entry->delivery_status,
+			ir_entry->index2,
+			ir_entry->zero,
+			ir_entry->vector);
+	}
+}
+
+__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
+{
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
@@ -1568,58 +1588,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	if (irq_remapping_enabled) {
-		printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
-			" Pol Stat Indx2 Zero Vect:\n");
-	} else {
-		printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			" Stat Dmod Deli Vect:\n");
-	}
-
-	for (i = 0; i <= reg_01.bits.entries; i++) {
-		if (irq_remapping_enabled) {
-			struct IO_APIC_route_entry entry;
-			struct IR_IO_APIC_route_entry *ir_entry;
-
-			entry = ioapic_read_entry(ioapic_idx, i);
-			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
-			printk(KERN_DEBUG " %02x %04X ",
-				i,
-				ir_entry->index
-			);
-			pr_cont("%1d   %1d    %1d    %1d   %1d   "
-				"%1d    %1d     %X    %02X\n",
-				ir_entry->format,
-				ir_entry->mask,
-				ir_entry->trigger,
-				ir_entry->irr,
-				ir_entry->polarity,
-				ir_entry->delivery_status,
-				ir_entry->index2,
-				ir_entry->zero,
-				ir_entry->vector
-			);
-		} else {
-			struct IO_APIC_route_entry entry;
-
-			entry = ioapic_read_entry(ioapic_idx, i);
-			printk(KERN_DEBUG " %02x %02X  ",
-				i,
-				entry.dest
-			);
-			pr_cont("%1d    %1d    %1d   %1d   %1d    "
-				"%1d    %1d    %02X\n",
-				entry.mask,
-				entry.trigger,
-				entry.irr,
-				entry.polarity,
-				entry.delivery_status,
-				entry.dest_mode,
-				entry.delivery_mode,
-				entry.vector
-			);
-		}
-	}
+	x86_io_apic_ops.print_entries(ioapic_idx, reg_01.bits.entries);
 }
 
 __apicdebuginit(void) print_IO_APICs(void)
@@ -1921,30 +1890,14 @@ void __init enable_IO_APIC(void)
 	clear_IO_APIC();
 }
 
-/*
- * Not an __init, needed by the reboot code
- */
-void disable_IO_APIC(void)
+void native_disable_io_apic(void)
 {
 	/*
-	 * Clear the IO-APIC before rebooting:
-	 */
-	clear_IO_APIC();
-
-	if (!legacy_pic->nr_legacy_irqs)
-		return;
-
-	/*
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
 	 * so legacy interrupts can be delivered.
-	 *
-	 * With interrupt-remapping, for now we will use virtual wire A mode,
-	 * as virtual wire B is little complex (need to configure both
-	 * IOAPIC RTE as well as interrupt-remapping table entry).
-	 * As this gets called during crash dump, keep this simple for now.
 	 */
-	if (ioapic_i8259.pin != -1 && !irq_remapping_enabled) {
+	if (ioapic_i8259.pin != -1) {
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
@@ -1964,12 +1917,25 @@ void disable_IO_APIC(void)
 		ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin, entry);
 	}
 
+	if (cpu_has_apic || apic_from_smp_config())
+		disconnect_bsp_APIC(ioapic_i8259.pin != -1);
+
+}
+
+/*
+ * Not an __init, needed by the reboot code
+ */
+void disable_IO_APIC(void)
+{
 	/*
-	 * Use virtual wire A mode when interrupt remapping is enabled.
+	 * Clear the IO-APIC before rebooting:
 	 */
-	if (cpu_has_apic || apic_from_smp_config())
-		disconnect_bsp_APIC(!irq_remapping_enabled &&
-				ioapic_i8259.pin != -1);
+	clear_IO_APIC();
+
+	if (!legacy_pic->nr_legacy_irqs)
+		return;
+
+	x86_io_apic_ops.disable();
 }
 
 #ifdef CONFIG_X86_32
@@ -2322,12 +2288,8 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
 		apic = entry->apic;
 		pin = entry->pin;
-		/*
-		 * With interrupt-remapping, destination information comes
-		 * from interrupt-remapping table entry.
-		 */
-		if (!irq_remapped(cfg))
-			io_apic_write(apic, 0x11 + pin*2, dest);
+
+		io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
@@ -2369,9 +2331,10 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
-static int
-ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		    bool force)
+
+int native_ioapic_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask,
+			       bool force)
 {
 	unsigned int dest, irq = data->irq;
 	unsigned long flags;
@@ -2548,33 +2511,6 @@ static void ack_apic_level(struct irq_data *data)
 	ioapic_irqd_unmask(data, cfg, masked);
 }
 
-#ifdef CONFIG_IRQ_REMAP
-static void ir_ack_apic_edge(struct irq_data *data)
-{
-	ack_APIC_irq();
-}
-
-static void ir_ack_apic_level(struct irq_data *data)
-{
-	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, data->chip_data);
-}
-
-static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
-{
-	seq_printf(p, " IR-%s", data->chip->name);
-}
-
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-	chip->irq_print_chip = ir_print_prefix;
-	chip->irq_ack = ir_ack_apic_edge;
-	chip->irq_eoi = ir_ack_apic_level;
-
-	chip->irq_set_affinity = set_remapped_irq_affinity;
-}
-#endif /* CONFIG_IRQ_REMAP */
-
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
@@ -2582,7 +2518,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_unmask		= unmask_ioapic_irq,
 	.irq_ack		= ack_apic_edge,
 	.irq_eoi		= ack_apic_level,
-	.irq_set_affinity	= ioapic_set_affinity,
+	.irq_set_affinity	= native_ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
@@ -2781,8 +2717,7 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
-		if (irq_remapping_enabled)
-			panic("BIOS bug: timer not connected to IO-APIC");
+		panic_if_irq_remap("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2814,8 +2749,7 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
-		if (irq_remapping_enabled)
-			panic("timer doesn't work through Interrupt-remapped IO-APIC");
+		panic_if_irq_remap("timer doesn't work through Interrupt-remapped IO-APIC");
 		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
@@ -2982,37 +2916,58 @@ device_initcall(ioapic_init_ops);
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int from, int node)
+unsigned int __create_irqs(unsigned int from, unsigned int count, int node)
 {
-	struct irq_cfg *cfg;
+	struct irq_cfg **cfg;
 	unsigned long flags;
-	unsigned int ret = 0;
-	int irq;
+	int irq, i;
 
 	if (from < nr_irqs_gsi)
 		from = nr_irqs_gsi;
 
-	irq = alloc_irq_from(from, node);
-	if (irq < 0)
-		return 0;
-	cfg = alloc_irq_cfg(irq, node);
-	if (!cfg) {
-		free_irq_at(irq, NULL);
+	cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
+	if (!cfg)
 		return 0;
+
+	irq = alloc_irqs_from(from, count, node);
+	if (irq < 0)
+		goto out_cfgs;
+
+	for (i = 0; i < count; i++) {
+		cfg[i] = alloc_irq_cfg(irq + i, node);
+		if (!cfg[i])
+			goto out_irqs;
 	}
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
-		ret = irq;
+	for (i = 0; i < count; i++)
+		if (__assign_irq_vector(irq + i, cfg[i], apic->target_cpus()))
+			goto out_vecs;
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (ret) {
-		irq_set_chip_data(irq, cfg);
-		irq_clear_status_flags(irq, IRQ_NOREQUEST);
-	} else {
-		free_irq_at(irq, cfg);
+	for (i = 0; i < count; i++) {
+		irq_set_chip_data(irq + i, cfg[i]);
+		irq_clear_status_flags(irq + i, IRQ_NOREQUEST);
 	}
-	return ret;
+
+	kfree(cfg);
+	return irq;
+
+out_vecs:
+	for (i--; i >= 0; i--)
+		__clear_irq_vector(irq + i, cfg[i]);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+out_irqs:
+	for (i = 0; i < count; i++)
+		free_irq_at(irq + i, cfg[i]);
+out_cfgs:
+	kfree(cfg);
+	return 0;
+}
+
+unsigned int create_irq_nr(unsigned int from, int node)
+{
+	return __create_irqs(from, 1, node);
 }
 
 int create_irq(void)
@@ -3037,48 +2992,35 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	if (irq_remapped(cfg))
-		free_remapped_irq(irq);
+	free_remapped_irq(irq);
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	free_irq_at(irq, cfg);
 }
 
+void destroy_irqs(unsigned int irq, unsigned int count)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		destroy_irq(irq + i);
+}
+
 /*
  * MSI message composition
  */
-#ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
+void native_compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg;
-	int err;
-	unsigned dest;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	if (irq_remapped(cfg)) {
-		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
-		return err;
-	}
+	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
-		msg->address_hi = MSI_ADDR_BASE_HI |
-				  MSI_ADDR_EXT_DEST_ID(dest);
-	else
-		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
 
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
@@ -3097,8 +3039,32 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			MSI_DATA_DELIVERY_FIXED:
 			MSI_DATA_DELIVERY_LOWPRI) |
 		MSI_DATA_VECTOR(cfg->vector);
+}
 
-	return err;
+#ifdef CONFIG_PCI_MSI
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+			   struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	int err;
+	unsigned dest;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+
+	return 0;
 }
 
 static int
@@ -3136,23 +3102,28 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+		  unsigned int irq_base, unsigned int irq_offset)
 {
 	struct irq_chip *chip = &msi_chip;
 	struct msi_msg msg;
+	unsigned int irq = irq_base + irq_offset;
 	int ret;
 
 	ret = msi_compose_msg(dev, irq, &msg, -1);
 	if (ret < 0)
 		return ret;
 
-	irq_set_msi_desc(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
 
-	if (irq_remapped(irq_get_chip_data(irq))) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
-	}
+	/*
+	 * MSI-X message is written per-IRQ, the offset is always 0.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (!irq_offset)
+		write_msi_msg(irq, &msg);
+
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3163,46 +3134,26 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
+	int node, ret;
 
-	/* x86 doesn't support multiple MSI yet */
+	/* Multiple MSI vectors only supported with interrupt remapping */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
 	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
-	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
-			return -1;
+			return -ENOSPC;
+
 		irq_want = irq + 1;
-		if (!irq_remapping_enabled)
-			goto no_ir;
 
-		if (!sub_handle) {
-			/*
-			 * allocate the consecutive block of IRTE's
-			 * for 'nvec'
-			 */
-			index = msi_alloc_remapped_irq(dev, irq, nvec);
-			if (index < 0) {
-				ret = index;
-				goto error;
-			}
-		} else {
-			ret = msi_setup_remapped_irq(dev, irq, index,
-						     sub_handle);
-			if (ret < 0)
-				goto error;
-		}
-no_ir:
-		ret = setup_msi_irq(dev, msidesc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
 		if (ret < 0)
 			goto error;
-		sub_handle++;
 	}
 	return 0;
 
@@ -3298,26 +3249,19 @@ static struct irq_chip hpet_msi_type = {
 	.irq_retrigger = ioapic_retrigger_irq,
 };
 
-int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
+int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	struct irq_chip *chip = &hpet_msi_type;
 	struct msi_msg msg;
 	int ret;
 
-	if (irq_remapping_enabled) {
-		ret = setup_hpet_msi_remapped(irq, id);
-		if (ret)
-			return ret;
-	}
-
 	ret = msi_compose_msg(NULL, irq, &msg, id);
 	if (ret < 0)
 		return ret;
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(irq_get_chip_data(irq)))
-		irq_remap_modify_chip_defaults(chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
@@ -3683,10 +3627,7 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		if (irq_remapping_enabled)
-			set_remapped_irq_affinity(idata, mask, false);
-		else
-			ioapic_set_affinity(idata, mask, false);
+		x86_io_apic_ops.set_affinity(idata, mask, false);
 	}
 
 }
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index cce91bf..7434d85 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -106,7 +106,7 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
-	if (WARN_ONCE(!mask, "empty IPI mask"))
+	if (!mask)
 		return;
 
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index a8f8fa9..1e7e84a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -79,3 +79,10 @@ void __init init_hypervisor_platform(void)
 	if (x86_hyper->init_platform)
 		x86_hyper->init_platform();
 }
+
+bool __init hypervisor_x2apic_available(void)
+{
+	return x86_hyper                   &&
+	       x86_hyper->x2apic_available &&
+	       x86_hyper->x2apic_available();
+}
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index d22d0c4..03a3632 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -33,6 +33,9 @@
 
 #define VMWARE_PORT_CMD_GETVERSION	10
 #define VMWARE_PORT_CMD_GETHZ		45
+#define VMWARE_PORT_CMD_GETVCPU_INFO	68
+#define VMWARE_PORT_CMD_LEGACY_X2APIC	3
+#define VMWARE_PORT_CMD_VCPU_RESERVED	31
 
 #define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
 	__asm__("inl (%%dx)" :						\
@@ -125,10 +128,20 @@ static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 }
 
+/* Checks if hypervisor supports x2apic without VT-D interrupt remapping. */
+static bool __init vmware_legacy_x2apic_available(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	VMWARE_PORT(GETVCPU_INFO, eax, ebx, ecx, edx);
+	return (eax & (1 << VMWARE_PORT_CMD_VCPU_RESERVED)) == 0 &&
+	       (eax & (1 << VMWARE_PORT_CMD_LEGACY_X2APIC)) != 0;
+}
+
 const __refconst struct hypervisor_x86 x86_hyper_vmware = {
 	.name			= "VMware",
 	.detect			= vmware_platform,
 	.set_cpu_features	= vmware_set_cpu_features,
 	.init_platform		= vmware_platform_setup,
+	.x2apic_available	= vmware_legacy_x2apic_available,
 };
 EXPORT_SYMBOL(x86_hyper_vmware);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index e28670f..da85a8e 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -478,7 +478,7 @@ static int hpet_msi_next_event(unsigned long delta,
 
 static int hpet_setup_msi_irq(unsigned int irq)
 {
-	if (arch_setup_hpet_msi(irq, hpet_blockid)) {
+	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
 		destroy_irq(irq);
 		return -EINVAL;
 	}
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9c2bd8b..2b44ea5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -505,6 +505,7 @@ static bool __init kvm_detect(void)
 const struct hypervisor_x86 x86_hyper_kvm __refconst = {
 	.name			= "KVM",
 	.detect			= kvm_detect,
+	.x2apic_available	= kvm_para_available,
 };
 EXPORT_SYMBOL_GPL(x86_hyper_kvm);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 7a3d075..d065d67 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -19,6 +19,7 @@
 #include <asm/time.h>
 #include <asm/irq.h>
 #include <asm/io_apic.h>
+#include <asm/hpet.h>
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
@@ -111,15 +112,22 @@ struct x86_platform_ops x86_platform = {
 
 EXPORT_SYMBOL_GPL(x86_platform);
 struct x86_msi_ops x86_msi = {
-	.setup_msi_irqs = native_setup_msi_irqs,
-	.teardown_msi_irq = native_teardown_msi_irq,
-	.teardown_msi_irqs = default_teardown_msi_irqs,
-	.restore_msi_irqs = default_restore_msi_irqs,
+	.setup_msi_irqs		= native_setup_msi_irqs,
+	.compose_msi_msg	= native_compose_msi_msg,
+	.teardown_msi_irq	= native_teardown_msi_irq,
+	.teardown_msi_irqs	= default_teardown_msi_irqs,
+	.restore_msi_irqs	= default_restore_msi_irqs,
+	.setup_hpet_msi		= default_setup_hpet_msi,
 };
 
 struct x86_io_apic_ops x86_io_apic_ops = {
-	.init	= native_io_apic_init_mappings,
-	.read	= native_io_apic_read,
-	.write	= native_io_apic_write,
-	.modify	= native_io_apic_modify,
+	.init			= native_io_apic_init_mappings,
+	.read			= native_io_apic_read,
+	.write			= native_io_apic_write,
+	.modify			= native_io_apic_modify,
+	.disable		= native_disable_io_apic,
+	.print_entries		= native_io_apic_print_entries,
+	.set_affinity		= native_ioapic_set_affinity,
+	.setup_entry		= native_setup_ioapic_entry,
+	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 138e566..8b4c56d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1668,6 +1668,7 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
 	.name			= "Xen HVM",
 	.detect			= xen_hvm_platform,
 	.init_platform		= xen_hvm_guest_init,
+	.x2apic_available	= xen_x2apic_para_available,
 };
 EXPORT_SYMBOL(x86_hyper_xen_hvm);
 #endif
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4979127..495aeed 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1061,6 +1061,86 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
+int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
+{
+	int rc;
+	unsigned int maxvec;
+
+	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI)) {
+		rc = pci_enable_msi_block_auto(pdev, &maxvec);
+		if (rc > 0) {
+			if ((rc == maxvec) || (rc == 1))
+				return rc;
+			/*
+			 * Assume that advantage of multipe MSIs is negated,
+			 * so fallback to single MSI mode to save resources
+			 */
+			pci_disable_msi(pdev);
+			if (!pci_enable_msi(pdev))
+				return 1;
+		}
+	}
+
+	pci_intx(pdev, 1);
+	return 0;
+}
+
+/**
+ *	ahci_host_activate - start AHCI host, request IRQs and register it
+ *	@host: target ATA host
+ *	@irq: base IRQ number to request
+ *	@n_msis: number of MSIs allocated for this host
+ *	@irq_handler: irq_handler used when requesting IRQs
+ *	@irq_flags: irq_flags used when requesting IRQs
+ *
+ *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
+ *	when multiple MSIs were allocated. That is one MSI per port, starting
+ *	from @irq.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
+{
+	int i, rc;
+
+	/* Sharing Last Message among several ports is not supported */
+	if (n_msis < host->n_ports)
+		return -EINVAL;
+
+	rc = ata_host_start(host);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < host->n_ports; i++) {
+		rc = devm_request_threaded_irq(host->dev,
+			irq + i, ahci_hw_interrupt, ahci_thread_fn, IRQF_SHARED,
+			dev_driver_string(host->dev), host->ports[i]);
+		if (rc)
+			goto out_free_irqs;
+	}
+
+	for (i = 0; i < host->n_ports; i++)
+		ata_port_desc(host->ports[i], "irq %d", irq + i);
+
+	rc = ata_host_register(host, &ahci_sht);
+	if (rc)
+		goto out_free_all_irqs;
+
+	return 0;
+
+out_free_all_irqs:
+	i = host->n_ports;
+out_free_irqs:
+	for (i--; i >= 0; i--)
+		devm_free_irq(host->dev, irq + i, host->ports[i]);
+
+	return rc;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
@@ -1069,7 +1149,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, i, rc;
+	int n_ports, n_msis, i, rc;
 	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
@@ -1156,11 +1236,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ahci_sb600_enable_64bit(pdev))
 		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
 
-	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
-		pci_intx(pdev, 1);
-
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	n_msis = ahci_init_interrupts(pdev, hpriv);
+	if (n_msis > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
@@ -1256,6 +1337,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
+
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
+		return ahci_host_activate(host, pdev->irq, n_msis);
+
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
 }
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 9be4712..b830e6c 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -231,6 +231,7 @@ enum {
 	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
 						        port start (wait until
 						        error-handling stage) */
+	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
 
 	/* ap->flags bits */
 
@@ -297,6 +298,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+	u32			intr_status;	/* interrupts to handle */
+	spinlock_t		lock;		/* protects parent ata_port */
 	u32 			intr_mask;	/* interrupts to enable */
 	bool			fbs_supported;	/* set iff FBS is supported */
 	bool			fbs_enabled;	/* set iff FBS is enabled */
@@ -359,7 +362,10 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
 irqreturn_t ahci_interrupt(int irq, void *dev_instance);
+irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
+irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
+int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 6cd7805..34c8216 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1655,19 +1655,16 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_port_intr(struct ata_port *ap)
+static void ahci_handle_port_interrupt(struct ata_port *ap,
+				       void __iomem *port_mmio, u32 status)
 {
-	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
-	u32 status, qc_active = 0;
+	u32 qc_active = 0;
 	int rc;
 
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
 	/* ignore BAD_PMP while resetting */
 	if (unlikely(resetting))
 		status &= ~PORT_IRQ_BAD_PMP;
@@ -1743,6 +1740,107 @@ static void ahci_port_intr(struct ata_port *ap)
 	}
 }
 
+void ahci_port_intr(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 status;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	ahci_handle_port_interrupt(ap, port_mmio, status);
+}
+
+irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+{
+	struct ata_port *ap = dev_instance;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	unsigned long flags;
+	u32 status;
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	status = pp->intr_status;
+	if (status)
+		pp->intr_status = 0;
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+
+	spin_lock_bh(ap->lock);
+	ahci_handle_port_interrupt(ap, port_mmio, status);
+	spin_unlock_bh(ap->lock);
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(ahci_thread_fn);
+
+void ahci_hw_port_interrupt(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 status;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	pp->intr_status |= status;
+}
+
+irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+{
+	struct ata_port *ap_this = dev_instance;
+	struct ahci_port_priv *pp = ap_this->private_data;
+	struct ata_host *host = ap_this->host;
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	unsigned int i;
+	u32 irq_stat, irq_masked;
+
+	VPRINTK("ENTER\n");
+
+	spin_lock(&host->lock);
+
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+
+	if (!irq_stat) {
+		u32 status = pp->intr_status;
+
+		spin_unlock(&host->lock);
+
+		VPRINTK("EXIT\n");
+
+		return status ? IRQ_WAKE_THREAD : IRQ_NONE;
+	}
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		if (!(irq_masked & (1 << i)))
+			continue;
+
+		ap = host->ports[i];
+		if (ap) {
+			ahci_hw_port_interrupt(ap);
+			VPRINTK("port %u\n", i);
+		} else {
+			VPRINTK("port %u (no irq)\n", i);
+			if (ata_ratelimit())
+				dev_warn(host->dev,
+					 "interrupt on disabled port %u\n", i);
+		}
+	}
+
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	spin_unlock(&host->lock);
+
+	VPRINTK("EXIT\n");
+
+	return IRQ_WAKE_THREAD;
+}
+EXPORT_SYMBOL_GPL(ahci_hw_interrupt);
+
 irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -2196,6 +2294,14 @@ static int ahci_port_start(struct ata_port *ap)
 	 */
 	pp->intr_mask = DEF_PORT_IRQ;
 
+	/*
+	 * Switch to per-port locking in case each port has its own MSI vector.
+	 */
+	if ((hpriv->flags & AHCI_HFLAG_MULTI_MSI)) {
+		spin_lock_init(&pp->lock);
+		ap->lock = &pp->lock;
+	}
+
 	ap->private_data = pp;
 
 	/* engage engines, captain */
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c1c74e0..d33eaaf 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4017,10 +4017,10 @@ static int alloc_irq_index(struct irq_cfg *cfg, u16 devid, int count)
 
 			index -= count - 1;
 
+			cfg->remapped	      = 1;
 			irte_info             = &cfg->irq_2_iommu;
 			irte_info->sub_handle = devid;
 			irte_info->irte_index = index;
-			irte_info->iommu      = (void *)cfg;
 
 			goto out;
 		}
@@ -4127,9 +4127,9 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	index = attr->ioapic_pin;
 
 	/* Setup IRQ remapping info */
+	cfg->remapped	      = 1;
 	irte_info->sub_handle = devid;
 	irte_info->irte_index = index;
-	irte_info->iommu      = (void *)cfg;
 
 	/* Setup IRTE for IOMMU */
 	irte.val		= 0;
@@ -4288,9 +4288,9 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	devid		= get_device_id(&pdev->dev);
 	irte_info	= &cfg->irq_2_iommu;
 
+	cfg->remapped	      = 1;
 	irte_info->sub_handle = devid;
 	irte_info->irte_index = index + offset;
-	irte_info->iommu      = (void *)cfg;
 
 	return 0;
 }
@@ -4314,9 +4314,9 @@ static int setup_hpet_msi(unsigned int irq, unsigned int id)
 	if (index < 0)
 		return index;
 
+	cfg->remapped	      = 1;
 	irte_info->sub_handle = devid;
 	irte_info->irte_index = index;
-	irte_info->iommu      = (void *)cfg;
 
 	return 0;
 }
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 86e2f4a..174bb65 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -41,6 +41,8 @@
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
+#include "irq_remapping.h"
+
 /* No locks are needed as DMA remapping hardware unit
  * list is constructed at boot time and hotplug of
  * these units are not supported by the architecture.
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b9d0911..64ae948 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -46,6 +46,8 @@
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
+#include "irq_remapping.h"
+
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..f3b8f23 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -68,6 +68,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	u16 index, start_index;
 	unsigned int mask = 0;
 	unsigned long flags;
@@ -115,6 +116,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
+	cfg->remapped = 1;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index =  index;
 	irq_iommu->sub_handle = 0;
@@ -155,6 +157,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -162,6 +165,7 @@ static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subha
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
+	cfg->remapped = 1;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
 	irq_iommu->sub_handle = subhandle;
@@ -425,11 +429,22 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 
 	/* Enable interrupt-remapping */
 	iommu->gcmd |= DMA_GCMD_IRE;
+	iommu->gcmd &= ~DMA_GCMD_CFI;  /* Block compatibility-format MSIs */
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRES), sts);
 
+	/*
+	 * With CFI clear in the Global Command register, we should be
+	 * protected from dangerous (i.e. compatibility) interrupts
+	 * regardless of x2apic status.  Check just to be sure.
+	 */
+	if (sts & DMA_GSTS_CFIS)
+		WARN(1, KERN_WARNING
+			"Compatibility-format IRQs enabled despite intr remapping;\n"
+			"you are vulnerable to IRQ injection.\n");
+
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
@@ -526,20 +541,24 @@ static int __init intel_irq_remapping_supported(void)
 static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
+	bool x2apic_present;
 	int setup = 0;
 	int eim = 0;
 
+	x2apic_present = x2apic_supported();
+
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enable interrupt remapping\n");
-		return -1;
+		goto error;
 	}
 
-	if (x2apic_supported()) {
+	if (x2apic_present) {
 		eim = !dmar_x2apic_optout();
-		WARN(!eim, KERN_WARNING
-			   "Your BIOS is broken and requested that x2apic be disabled\n"
-			   "This will leave your machine vulnerable to irq-injection attacks\n"
-			   "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
+		if (!eim)
+			printk(KERN_WARNING
+				"Your BIOS is broken and requested that x2apic be disabled.\n"
+				"This will slightly decrease performance.\n"
+				"Use 'intremap=no_x2apic_optout' to override BIOS request.\n");
 	}
 
 	for_each_drhd_unit(drhd) {
@@ -578,7 +597,7 @@ static int __init intel_enable_irq_remapping(void)
 		if (eim && !ecap_eim_support(iommu->ecap)) {
 			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
 			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
-			return -1;
+			goto error;
 		}
 	}
 
@@ -594,7 +613,7 @@ static int __init intel_enable_irq_remapping(void)
 			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
 			       " invalidation, ecap %Lx, ret %d\n",
 			       drhd->reg_base_addr, iommu->ecap, ret);
-			return -1;
+			goto error;
 		}
 	}
 
@@ -617,6 +636,14 @@ static int __init intel_enable_irq_remapping(void)
 		goto error;
 
 	irq_remapping_enabled = 1;
+
+	/*
+	 * VT-d has a different layout for IO-APIC entries when
+	 * interrupt remapping is enabled. So it needs a special routine
+	 * to print IO-APIC entries for debugging purposes too.
+	 */
+	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
+
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
@@ -625,6 +652,11 @@ error:
 	/*
 	 * handle error condition gracefully here!
 	 */
+
+	if (x2apic_present)
+		WARN(1, KERN_WARNING
+			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
+
 	return -1;
 }
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index faf85d6..d56f8c1 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -1,11 +1,18 @@
+#include <linux/seq_file.h>
+#include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/msi.h>
+#include <linux/irq.h>
+#include <linux/pci.h>
 
 #include <asm/hw_irq.h>
 #include <asm/irq_remapping.h>
+#include <asm/processor.h>
+#include <asm/x86_init.h>
+#include <asm/apic.h>
 
 #include "irq_remapping.h"
 
@@ -17,6 +24,152 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
+static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
+static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle);
+static int set_remapped_irq_affinity(struct irq_data *data,
+				     const struct cpumask *mask,
+				     bool force);
+
+static bool irq_remapped(struct irq_cfg *cfg)
+{
+	return (cfg->remapped == 1);
+}
+
+static void irq_remapping_disable_io_apic(void)
+{
+	/*
+	 * With interrupt-remapping, for now we will use virtual wire A
+	 * mode, as virtual wire B is little complex (need to configure
+	 * both IOAPIC RTE as well as interrupt-remapping table entry).
+	 * As this gets called during crash dump, keep this simple for
+	 * now.
+	 */
+	if (cpu_has_apic || apic_from_smp_config())
+		disconnect_bsp_APIC(0);
+}
+
+static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
+{
+	int node, ret, sub_handle, index = 0;
+	unsigned int irq;
+	struct msi_desc *msidesc;
+
+	nvec = __roundup_pow_of_two(nvec);
+
+	WARN_ON(!list_is_singular(&dev->msi_list));
+	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+	WARN_ON(msidesc->irq);
+	WARN_ON(msidesc->msi_attrib.multiple);
+
+	node = dev_to_node(&dev->dev);
+	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
+	if (irq == 0)
+		return -ENOSPC;
+
+	msidesc->msi_attrib.multiple = ilog2(nvec);
+	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
+		if (!sub_handle) {
+			index = msi_alloc_remapped_irq(dev, irq, nvec);
+			if (index < 0) {
+				ret = index;
+				goto error;
+			}
+		} else {
+			ret = msi_setup_remapped_irq(dev, irq + sub_handle,
+						     index, sub_handle);
+			if (ret < 0)
+				goto error;
+		}
+		ret = setup_msi_irq(dev, msidesc, irq, sub_handle);
+		if (ret < 0)
+			goto error;
+	}
+	return 0;
+
+error:
+	destroy_irqs(irq, nvec);
+
+	/*
+	 * Restore altered MSI descriptor fields and prevent just destroyed
+	 * IRQs from tearing down again in default_teardown_msi_irqs()
+	 */
+	msidesc->irq = 0;
+	msidesc->msi_attrib.multiple = 0;
+
+	return ret;
+}
+
+static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
+{
+	int node, ret, sub_handle, index = 0;
+	struct msi_desc *msidesc;
+	unsigned int irq;
+
+	node		= dev_to_node(&dev->dev);
+	irq		= get_nr_irqs_gsi();
+	sub_handle	= 0;
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+
+		irq = create_irq_nr(irq, node);
+		if (irq == 0)
+			return -1;
+
+		if (sub_handle == 0)
+			ret = index = msi_alloc_remapped_irq(dev, irq, nvec);
+		else
+			ret = msi_setup_remapped_irq(dev, irq, index, sub_handle);
+
+		if (ret < 0)
+			goto error;
+
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		if (ret < 0)
+			goto error;
+
+		sub_handle += 1;
+		irq        += 1;
+	}
+
+	return 0;
+
+error:
+	destroy_irq(irq);
+	return ret;
+}
+
+static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
+					int nvec, int type)
+{
+	if (type == PCI_CAP_ID_MSI)
+		return do_setup_msi_irqs(dev, nvec);
+	else
+		return do_setup_msix_irqs(dev, nvec);
+}
+
+void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
+{
+	/*
+	 * Intr-remapping uses pin number as the virtual vector
+	 * in the RTE. Actual vector is programmed in
+	 * intr-remapping table entry. Hence for the io-apic
+	 * EOI we use the pin number.
+	 */
+	io_apic_eoi(apic, pin);
+}
+
+static void __init irq_remapping_modify_x86_ops(void)
+{
+	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
+	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
+	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
+	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
+	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
+	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
+	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
+}
+
 static __init int setup_nointremap(char *str)
 {
 	disable_irq_remap = 1;
@@ -79,15 +232,24 @@ int __init irq_remapping_prepare(void)
 
 int __init irq_remapping_enable(void)
 {
+	int ret;
+
 	if (!remap_ops || !remap_ops->enable)
 		return -ENODEV;
 
-	return remap_ops->enable();
+	ret = remap_ops->enable();
+
+	if (irq_remapping_enabled)
+		irq_remapping_modify_x86_ops();
+
+	return ret;
 }
 
 void irq_remapping_disable(void)
 {
-	if (!remap_ops || !remap_ops->disable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->disable)
 		return;
 
 	remap_ops->disable();
@@ -95,7 +257,9 @@ void irq_remapping_disable(void)
 
 int irq_remapping_reenable(int mode)
 {
-	if (!remap_ops || !remap_ops->reenable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->reenable)
 		return 0;
 
 	return remap_ops->reenable(mode);
@@ -103,6 +267,9 @@ int irq_remapping_reenable(int mode)
 
 int __init irq_remap_enable_fault_handling(void)
 {
+	if (!irq_remapping_enabled)
+		return 0;
+
 	if (!remap_ops || !remap_ops->enable_faulting)
 		return -ENODEV;
 
@@ -133,23 +300,28 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 
 void free_remapped_irq(int irq)
 {
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
+
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
 
-	remap_ops->free_irq(irq);
+	if (irq_remapped(cfg))
+		remap_ops->free_irq(irq);
 }
 
 void compose_remapped_msi_msg(struct pci_dev *pdev,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
-	if (!remap_ops || !remap_ops->compose_msi_msg)
-		return;
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 
-	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+	if (!irq_remapped(cfg))
+		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+	else if (remap_ops && remap_ops->compose_msi_msg)
+		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
 }
 
-int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
+static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
 	if (!remap_ops || !remap_ops->msi_alloc_irq)
 		return -ENODEV;
@@ -157,8 +329,8 @@ int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
 }
 
-int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-			   int index, int sub_handle)
+static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle)
 {
 	if (!remap_ops || !remap_ops->msi_setup_irq)
 		return -ENODEV;
@@ -173,3 +345,42 @@ int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 
 	return remap_ops->setup_hpet_msi(irq, id);
 }
+
+void panic_if_irq_remap(const char *msg)
+{
+	if (irq_remapping_enabled)
+		panic(msg);
+}
+
+static void ir_ack_apic_edge(struct irq_data *data)
+{
+	ack_APIC_irq();
+}
+
+static void ir_ack_apic_level(struct irq_data *data)
+{
+	ack_APIC_irq();
+	eoi_ioapic_irq(data->irq, data->chip_data);
+}
+
+static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " IR-%s", data->chip->name);
+}
+
+void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+	chip->irq_print_chip = ir_print_prefix;
+	chip->irq_ack = ir_ack_apic_edge;
+	chip->irq_eoi = ir_ack_apic_level;
+	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
+}
+
+bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
+{
+	if (!irq_remapped(cfg))
+		return false;
+	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+	irq_remap_modify_chip_defaults(chip);
+	return true;
+}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 95363ac..ecb6376 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -34,6 +34,7 @@ struct msi_msg;
 extern int disable_irq_remap;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
+extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
 	/* Check whether Interrupt Remapping is supported */
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5099636..00cc78c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -845,6 +845,32 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	int ret, pos, nvec;
+	u16 msgctl;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
+	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	if (maxvec)
+		*maxvec = ret;
+
+	do {
+		nvec = ret;
+		ret = pci_enable_msi_block(dev, nvec);
+	} while (ret > 0);
+
+	if (ret < 0)
+		return ret;
+	return nvec;
+}
+EXPORT_SYMBOL(pci_enable_msi_block_auto);
+
 void pci_msi_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *desc;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fdf2c4a..bc4e066 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -509,8 +509,11 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 
 /* Handle dynamic irq creation and destruction */
 extern unsigned int create_irq_nr(unsigned int irq_want, int node);
+extern unsigned int __create_irqs(unsigned int from, unsigned int count,
+				  int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
+extern void destroy_irqs(unsigned int irq, unsigned int count);
 
 /*
  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
@@ -528,6 +531,8 @@ extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
+extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
+				struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
@@ -590,6 +595,9 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 #define irq_alloc_desc_from(from, node)		\
 	irq_alloc_descs(-1, from, 1, node)
 
+#define irq_alloc_descs_from(from, cnt, node)	\
+	irq_alloc_descs(-1, from, cnt, node)
+
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 15472d6..6fa4dd2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1101,6 +1101,12 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 	return -1;
 }
 
+static inline int
+pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	return -1;
+}
+
 static inline void pci_msi_shutdown(struct pci_dev *dev)
 { }
 static inline void pci_disable_msi(struct pci_dev *dev)
@@ -1132,6 +1138,7 @@ static inline int pci_msi_enabled(void)
 }
 #else
 extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
+extern int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_msix_table_size(struct pci_dev *dev);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3aca9f2..cbd97ce 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -90,27 +90,41 @@ int irq_set_handler_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
- *	irq_set_msi_desc - set MSI descriptor data for an irq
- *	@irq:	Interrupt number
- *	@entry:	Pointer to MSI descriptor data
+ *	irq_set_msi_desc_off - set MSI descriptor data for an irq at offset
+ *	@irq_base:	Interrupt number base
+ *	@irq_offset:	Interrupt number offset
+ *	@entry:		Pointer to MSI descriptor data
  *
- *	Set the MSI descriptor entry for an irq
+ *	Set the MSI descriptor entry for an irq at offset
  */
-int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
+int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
+			 struct msi_desc *entry)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_lock(irq_base + irq_offset, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
 	desc->irq_data.msi_desc = entry;
-	if (entry)
-		entry->irq = irq;
+	if (entry && !irq_offset)
+		entry->irq = irq_base;
 	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
 
 /**
+ *	irq_set_msi_desc - set MSI descriptor data for an irq
+ *	@irq:	Interrupt number
+ *	@entry:	Pointer to MSI descriptor data
+ *
+ *	Set the MSI descriptor entry for an irq
+ */
+int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
+{
+	return irq_set_msi_desc_off(irq, 0, entry);
+}
+
+/**
  *	irq_set_chip_data - set irq chip data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to chip specific data
