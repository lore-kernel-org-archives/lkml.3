Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaHDLeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:34:16 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52232 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaHDLeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:34:09 -0400
Date: Mon, 4 Aug 2014 13:34:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.17
Message-ID: <20140804113402.GA25437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   # HEAD: 5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7 x86/apic/vsmp: Make is_vsmp_box() static


The main changes in this cycle are:

    * Remove obsolete APIC driver abstractions. (David Rientjes)

    * Use the irqdomain facilities to dynamically allocate IRQs for 
      IOAPICs. This is a prerequisite to enable IOAPIC hotplug 
      support, and it also frees up wasted vectors. (Jiang Liu)

    * Misc fixlets.

  out-of-topic modifications in x86-apic-for-linus:
  ---------------------------------------------------
  drivers/acpi/pci_irq.c             # 6a38fa0: x86, irq, ACPI: Release IOAPIC pi
  include/linux/irqdomain.h          # 43a7759: genirq: Export irq_domain_disasso
  kernel/irq/irqdomain.c             # 43a7759: genirq: Export irq_domain_disasso

 Thanks,

	Ingo

------------------>
David Rientjes (9):
      x86, apic: Remove x86_32_numa_cpu_node callback
      x86, apic: Replace trampoline physical addresses with defaults
      x86, apic: Remove smp_callin_clear_local_apic callback
      x86, apic: Remove mps_oem_check callback
      x86, apic: Remove check_apicid_present callback
      x86, apic: Replace noop_check_apicid_used
      x86, apic: Remove multi_timer_check callback
      x86, apic: Remove setup_portio_remap callback
      x86, apic: Remove enable_apic_mode callback

H. Peter Anvin (1):
      x86/apic/vsmp: Make is_vsmp_box() static

Jiang Liu (42):
      genirq: Export irq_domain_disassociate() to architecture interrupt drivers
      x86, mpparse: Use pr_lvl() helper utilities to replace printk(KERN_LVL)
      x86, mpparse: Simplify arch/x86/include/asm/mpspec.h
      x86, acpi: Reorganize code to avoid forward declaration in boot.c
      x86, PCI, ACPI: Use kmalloc_node() to optimize for performance
      x86, acpi, irq: Kill static function irq_to_gsi()
      x86, ACPI, trivial: Minor improvements to arch/x86/kernel/acpi/boot.c
      x86, ACPI, irq: Enhance error handling in function acpi_register_gsi()
      x86, ACPI, irq: Fix possible eror in GSI to IRQ mapping for legacy IRQ
      x86, irq, trivial: Minor improvements of IRQ related code
      x86, ioapic: Kill unused global variable timer_through_8259
      x86, ioapic: Kill static variable nr_irqs_gsi
      x86, ioapic: Introduce helper utilities to walk ioapics and pins
      x86, ioapic: Use irq_cfg() instead of irq_get_chip_data() for better readability
      x86, irq: Reorganize IO_APIC_get_PCI_irq_vector() to prepare for irqdomain
      x86, irq: Introduce some helper utilities to improve readability
      x86: ce4100, irq: Make CE4100 depend on CONFIG_X86_IO_APIC
      x86: ce4100, irq: Do not set legacy_pic to null_legacy_pic
      x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY
      x86, irq: Simplify arch_early_irq_init()
      x86, ACPI, irq: Consolidate algorithm of mapping (ioapic, pin) to IRQ number
      x86, irq, ACPI: Change __acpi_register_gsi to return IRQ number instead of GSI
      x86, irq: Introduce mechanisms to support dynamically allocate IRQ for IOAPIC
      x86, irq: Enhance mp_register_ioapic() to support irqdomain
      x86, ACPI, irq: Provide basic irqdomain support
      x86, mpparse, irq: Provide basic irqdomain support
      x86, SFI, irq: Provide basic irqdomain support
      x86, devicetree, irq: Use common mechanism to support irqdomain
      x86, irq: Introduce two helper functions to support irqdomain map operation
      x86, irq, ACPI: Use common irqdomain map interface to program IOAPIC pins
      x86, irq, mpparse: Use common irqdomain map interface to program IOAPIC pins
      x86, irq, SFI: Use common irqdomain map interface to program IOAPIC pins
      x86, irq, devicetree: Use common irqdomain map interface to program IOAPIC pins
      x86, irq: Clean up unused IOAPIC interface
      x86, irq: Simplify the way to handle ISA IRQ
      x86, irq: Introduce helper functions to release IOAPIC pin
      x86, irq, ACPI: Release IOAPIC pin when PCI device is disabled
      x86, irq, mpparse: Release IOAPIC pin when PCI device is disabled
      x86, irq, SFI: Release IOAPIC pin when PCI device is disabled
      x86, irq, devicetree: Release IOAPIC pin when PCI device is disabled
      x86, irq: Clean up irqdomain transition code
      x86: intel-mid: Use the new io_apic interfaces

Oren Twaig (1):
      x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()


 arch/x86/Kconfig                                   |   2 +
 arch/x86/include/asm/apic.h                        |  46 +-
 arch/x86/include/asm/hardirq.h                     |   3 -
 arch/x86/include/asm/i8259.h                       |   5 +
 arch/x86/include/asm/io_apic.h                     |  56 +-
 arch/x86/include/asm/mpspec.h                      |  15 -
 arch/x86/include/asm/prom.h                        |   2 -
 arch/x86/include/asm/smpboot_hooks.h               |  10 +-
 arch/x86/kernel/acpi/boot.c                        | 400 ++++++-----
 arch/x86/kernel/apic/apic.c                        |  75 +-
 arch/x86/kernel/apic/apic_flat_64.c                |  16 -
 arch/x86/kernel/apic/apic_noop.c                   |  23 +-
 arch/x86/kernel/apic/apic_numachip.c               |   8 -
 arch/x86/kernel/apic/bigsmp_32.c                   |  14 -
 arch/x86/kernel/apic/io_apic.c                     | 759 +++++++++++++--------
 arch/x86/kernel/apic/probe_32.c                    |  33 +-
 arch/x86/kernel/apic/x2apic_cluster.c              |   8 -
 arch/x86/kernel/apic/x2apic_phys.c                 |   8 -
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   8 -
 arch/x86/kernel/devicetree.c                       | 207 ++----
 arch/x86/kernel/irqinit.c                          |  12 +-
 arch/x86/kernel/mpparse.c                          | 111 +--
 arch/x86/kernel/smpboot.c                          |   8 -
 arch/x86/kernel/vsmp_64.c                          |   4 +-
 arch/x86/pci/acpi.c                                |   6 +-
 arch/x86/pci/intel_mid_pci.c                       |  27 +-
 arch/x86/pci/irq.c                                 |  15 +-
 arch/x86/pci/xen.c                                 |   7 +-
 arch/x86/platform/ce4100/ce4100.c                  |  11 +-
 .../platform/intel-mid/device_libs/platform_wdt.c  |  22 +-
 arch/x86/platform/intel-mid/sfi.c                  |  56 +-
 arch/x86/platform/sfi/sfi.c                        |  10 +-
 drivers/acpi/pci_irq.c                             |   3 +-
 include/linux/irqdomain.h                          |   2 +
 kernel/irq/irqdomain.c                             |   2 +-
 35 files changed, 916 insertions(+), 1078 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..147a7b7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -429,6 +429,7 @@ config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
 	depends on PCI_GODIRECT
+	depends on X86_IO_APIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	select X86_REBOOTFIXUPS
@@ -835,6 +836,7 @@ config X86_IO_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+	select IRQ_DOMAIN
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	bool "Reroute for broken boot IRQs"
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 19b0eba..c31fded 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -85,14 +85,6 @@ static inline bool apic_from_smp_config(void)
 #include <asm/paravirt.h>
 #endif
 
-#ifdef CONFIG_X86_64
-extern int is_vsmp_box(void);
-#else
-static inline int is_vsmp_box(void)
-{
-	return 0;
-}
-#endif
 extern int setup_profiling_timer(unsigned int);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
@@ -300,7 +292,6 @@ struct apic {
 
 	int dest_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
-	unsigned long (*check_apicid_present)(int apicid);
 
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
 					 const struct cpumask *mask);
@@ -309,21 +300,11 @@ struct apic {
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
 
 	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
-	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int phys_apicid);
-	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
 
-	/*
-	 * When one of the next two hooks returns 1 the apic
-	 * is switched to this. Essentially they are additional
-	 * probe functions:
-	 */
-	int (*mps_oem_check)(struct mpc_table *mpc, char *oem, char *productid);
-
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
@@ -343,11 +324,7 @@ struct apic {
 	/* wakeup_secondary_cpu */
 	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
 
-	int trampoline_phys_low;
-	int trampoline_phys_high;
-
 	bool wait_for_init_deassert;
-	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 
 	/* apic ops */
@@ -378,14 +355,6 @@ struct apic {
 	 * won't be applied properly during early boot in this case.
 	 */
 	int (*x86_32_early_logical_apicid)(int cpu);
-
-	/*
-	 * Optional method called from setup_local_APIC() after logical
-	 * apicid is guaranteed to be known to initialize apicid -> node
-	 * mapping if NUMA initialization hasn't done so already.  Don't
-	 * add new users.
-	 */
-	int (*x86_32_numa_cpu_node)(int cpu);
 #endif
 };
 
@@ -496,14 +465,12 @@ static inline unsigned default_get_apic_id(unsigned long x)
 }
 
 /*
- * Warm reset vector default position:
+ * Warm reset vector position:
  */
-#define DEFAULT_TRAMPOLINE_PHYS_LOW		0x467
-#define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
+#define TRAMPOLINE_PHYS_LOW		0x467
+#define TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
-extern int default_acpi_madt_oem_check(char *, char *);
-
 extern void apic_send_IPI_self(int vector);
 
 DECLARE_PER_CPU(int, x2apic_extra_bits);
@@ -552,6 +519,8 @@ static inline int default_apic_id_valid(int apicid)
 	return (apicid < 255);
 }
 
+extern int default_acpi_madt_oem_check(char *, char *);
+
 extern void default_setup_apic_routing(void);
 
 extern struct apic apic_noop;
@@ -635,11 +604,6 @@ static inline unsigned long default_check_apicid_used(physid_mask_t *map, int ap
 	return physid_isset(apicid, *map);
 }
 
-static inline unsigned long default_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
 static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	*retmap = *phys_map;
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 230853d..0f5fb6b 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -40,9 +40,6 @@ typedef struct {
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
-/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
-#define MAX_HARDIRQS_PER_CPU NR_VECTORS
-
 #define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index a203659..ccffa53 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -67,4 +67,9 @@ struct legacy_pic {
 extern struct legacy_pic *legacy_pic;
 extern struct legacy_pic null_legacy_pic;
 
+static inline int nr_legacy_irqs(void)
+{
+	return legacy_pic->nr_legacy_irqs;
+}
+
 #endif /* _ASM_X86_I8259_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 90f97b4..0aeed5c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -98,6 +98,8 @@ struct IR_IO_APIC_route_entry {
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
 #define IOAPIC_LEVEL    1
+#define	IOAPIC_MAP_ALLOC		0x1
+#define	IOAPIC_MAP_CHECK		0x2
 
 #ifdef CONFIG_X86_IO_APIC
 
@@ -118,9 +120,6 @@ extern int mp_irq_entries;
 /* MP IRQ source entries */
 extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
-/* non-0 if default (table-less) MP configuration */
-extern int mpc_default_type;
-
 /* Older SiS APIC requires we rewrite the index register */
 extern int sis_apic_bug;
 
@@ -133,9 +132,6 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
-/* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
-extern int timer_through_8259;
-
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -145,24 +141,17 @@ extern int timer_through_8259;
 
 struct io_apic_irq_attr;
 struct irq_cfg;
-extern int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr);
-void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
 				     struct io_apic_irq_attr *);
-extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
-				     unsigned int, int,
-				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
 extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
-int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
@@ -171,15 +160,40 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
+enum ioapic_domain_type {
+	IOAPIC_DOMAIN_INVALID,
+	IOAPIC_DOMAIN_LEGACY,
+	IOAPIC_DOMAIN_STRICT,
+	IOAPIC_DOMAIN_DYNAMIC,
+};
+
+struct device_node;
+struct irq_domain;
+struct irq_domain_ops;
+
+struct ioapic_domain_cfg {
+	enum ioapic_domain_type		type;
+	const struct irq_domain_ops	*ops;
+	struct device_node		*dev;
+};
+
 struct mp_ioapic_gsi{
 	u32 gsi_base;
 	u32 gsi_end;
 };
-extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
-int mp_find_ioapic(u32 gsi);
-int mp_find_ioapic_pin(int ioapic, u32 gsi);
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+
+extern int mp_find_ioapic(u32 gsi);
+extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
+extern u32 mp_pin_to_gsi(int ioapic, int pin);
+extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
+extern void mp_unmap_irq(int irq);
+extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+				      struct ioapic_domain_cfg *cfg);
+extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
+			    irq_hw_number_t hwirq);
+extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
+extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
@@ -217,14 +231,12 @@ extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
-static const int timer_through_8259 = 0;
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
-
-struct io_apic_irq_attr;
-static inline int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr) { return 0; }
+static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
+static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
+static inline void mp_unmap_irq(int irq) { }
 
 static inline int save_ioapic_entries(void)
 {
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index f5a6179..b07233b 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -40,8 +40,6 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
-extern unsigned int max_physical_apicid;
-extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -88,15 +86,6 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
 int generic_processor_info(int apicid, int version);
-#ifdef CONFIG_ACPI
-extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
-extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
-				   u32 gsi);
-extern void mp_config_acpi_legacy_irqs(void);
-struct device;
-extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
-				 int active_high_low);
-#endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_LOCAL_APIC)
 
@@ -161,8 +150,4 @@ static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 
 extern physid_mask_t phys_cpu_present_map;
 
-extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
-
-extern int default_acpi_madt_oem_check(char *, char *);
-
 #endif /* _ASM_X86_MPSPEC_H */
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index fbeb06e..1d081ac 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -26,12 +26,10 @@
 extern int of_ioapic;
 extern u64 initial_dtb;
 extern void add_dtb(u64 data);
-extern void x86_add_irq_domains(void);
 void x86_of_pci_init(void);
 void x86_dtb_init(void);
 #else
 static inline void add_dtb(u64 data) { }
-static inline void x86_add_irq_domains(void) { }
 static inline void x86_of_pci_init(void) { }
 static inline void x86_dtb_init(void) { }
 #define of_ioapic 0
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 49adfd7..0da7409 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -17,11 +17,11 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	local_flush_tlb();
 	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
-								 start_eip >> 4;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+							start_eip >> 4;
 	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
-							 start_eip & 0xf;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+							start_eip & 0xf;
 	pr_debug("3.\n");
 }
 
@@ -42,7 +42,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	CMOS_WRITE(0, 0xf);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 86281ff..8c28023 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
@@ -43,6 +44,7 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 #include <asm/smp.h>
+#include <asm/i8259.h>
 
 #include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
@@ -97,44 +99,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 };
 
-static unsigned int gsi_to_irq(unsigned int gsi)
-{
-	unsigned int irq = gsi + NR_IRQS_LEGACY;
-	unsigned int i;
-
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		if (isa_irq_to_gsi[i] == gsi) {
-			return i;
-		}
-	}
-
-	/* Provide an identity mapping of gsi == irq
-	 * except on truly weird platforms that have
-	 * non isa irqs in the first 16 gsis.
-	 */
-	if (gsi >= NR_IRQS_LEGACY)
-		irq = gsi;
-	else
-		irq = gsi_top + gsi;
-
-	return irq;
-}
-
-static u32 irq_to_gsi(int irq)
-{
-	unsigned int gsi;
-
-	if (irq < NR_IRQS_LEGACY)
-		gsi = isa_irq_to_gsi[irq];
-	else if (irq < gsi_top)
-		gsi = irq;
-	else if (irq < (gsi_top + NR_IRQS_LEGACY))
-		gsi = irq - gsi_top;
-	else
-		gsi = 0xffffffff;
-
-	return gsi;
-}
+#define	ACPI_INVALID_GSI		INT_MIN
 
 /*
  * This is just a simple wrapper around early_ioremap(),
@@ -345,11 +310,145 @@ acpi_parse_lapic_nmi(struct acpi_subtable_header * header, const unsigned long e
 #endif				/*CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
+#define MP_ISA_BUS		0
+
+static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
+					  u32 gsi)
+{
+	int ioapic;
+	int pin;
+	struct mpc_intsrc mp_irq;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return;
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+
+	/*
+	 * TBD: This check is for faulty timer entries, where the override
+	 *      erroneously sets the trigger to level, resulting in a HUGE
+	 *      increase of timer interrupts!
+	 */
+	if ((bus_irq == 0) && (trigger == 3))
+		trigger = 1;
+
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger << 2) | polarity;
+	mp_irq.srcbus = MP_ISA_BUS;
+	mp_irq.srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
+	mp_irq.dstirq = pin;	/* INTIN# */
+
+	mp_save_irq(&mp_irq);
+
+	/*
+	 * Reset default identity mapping if gsi is also an legacy IRQ,
+	 * otherwise there will be more than one entry with the same GSI
+	 * and acpi_isa_irq_to_gsi() may give wrong result.
+	 */
+	if (gsi < nr_legacy_irqs() && isa_irq_to_gsi[gsi] == gsi)
+		isa_irq_to_gsi[gsi] = ACPI_INVALID_GSI;
+	isa_irq_to_gsi[bus_irq] = gsi;
+}
+
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
+			int polarity)
+{
+#ifdef CONFIG_X86_MPPARSE
+	struct mpc_intsrc mp_irq;
+	struct pci_dev *pdev;
+	unsigned char number;
+	unsigned int devfn;
+	int ioapic;
+	u8 pin;
+
+	if (!acpi_ioapic)
+		return 0;
+	if (!dev || !dev_is_pci(dev))
+		return 0;
+
+	pdev = to_pci_dev(dev);
+	number = pdev->bus->number;
+	devfn = pdev->devfn;
+	pin = pdev->pin;
+	/* print the entry should happen on mptable identically */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	ioapic = mp_find_ioapic(gsi);
+	mp_irq.dstapic = mpc_ioapic_id(ioapic);
+	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
+
+	mp_save_irq(&mp_irq);
+#endif
+	return 0;
+}
+
+static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
+			   int polarity)
+{
+	int irq, node;
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return gsi;
+
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (acpi_gbl_FADT.sci_interrupt == gsi)
+		return gsi;
+
+	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
+	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
+	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
+	if (mp_set_gsi_attr(gsi, trigger, polarity, node)) {
+		pr_warn("Failed to set pin attr for GSI%d\n", gsi);
+		return -1;
+	}
+
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
+	if (irq < 0)
+		return irq;
+
+	if (enable_update_mptable)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
+
+	return irq;
+}
+
+static void mp_unregister_gsi(u32 gsi)
+{
+	int irq;
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return;
+
+	if (acpi_gbl_FADT.sci_interrupt == gsi)
+		return;
+
+	irq = mp_map_gsi_to_irq(gsi, 0);
+	if (irq > 0)
+		mp_unmap_irq(irq);
+}
+
+static struct irq_domain_ops acpi_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
+};
 
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
 	struct acpi_madt_io_apic *ioapic = NULL;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &acpi_irqdomain_ops,
+	};
 
 	ioapic = (struct acpi_madt_io_apic *)header;
 
@@ -358,8 +457,12 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
-	mp_register_ioapic(ioapic->id,
-			   ioapic->address, ioapic->global_irq_base);
+	/* Statically assign IRQ numbers for IOAPICs hosting legacy IRQs */
+	if (ioapic->global_irq_base < nr_legacy_irqs())
+		cfg.type = IOAPIC_DOMAIN_LEGACY;
+
+	mp_register_ioapic(ioapic->id, ioapic->address, ioapic->global_irq_base,
+			   &cfg);
 
 	return 0;
 }
@@ -382,11 +485,6 @@ static void __init acpi_sci_ioapic_setup(u8 bus_irq, u16 polarity, u16 trigger,
 	if (acpi_sci_flags & ACPI_MADT_POLARITY_MASK)
 		polarity = acpi_sci_flags & ACPI_MADT_POLARITY_MASK;
 
-	/*
-	 * mp_config_acpi_legacy_irqs() already setup IRQs < 16
-	 * If GSI is < 16, this will update its flags,
-	 * else it will create a new mp_irqs[] entry.
-	 */
 	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
@@ -508,25 +606,28 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 	outb(new >> 8, 0x4d1);
 }
 
-int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
+int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	*irq = gsi_to_irq(gsi);
+	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
 
-#ifdef CONFIG_X86_IO_APIC
-	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-		setup_IO_APIC_irq_extra(gsi);
-#endif
+	if (irq >= 0) {
+		*irqp = irq;
+		return 0;
+	}
 
-	return 0;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq >= 16)
-		return -1;
-	*gsi = irq_to_gsi(isa_irq);
-	return 0;
+	if (isa_irq < nr_legacy_irqs() &&
+	    isa_irq_to_gsi[isa_irq] != ACPI_INVALID_GSI) {
+		*gsi = isa_irq_to_gsi[isa_irq];
+		return 0;
+	}
+
+	return -1;
 }
 
 static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
@@ -546,15 +647,25 @@ static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
 static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 				    int trigger, int polarity)
 {
+	int irq = gsi;
+
 #ifdef CONFIG_X86_IO_APIC
-	gsi = mp_register_gsi(dev, gsi, trigger, polarity);
+	irq = mp_register_gsi(dev, gsi, trigger, polarity);
 #endif
 
-	return gsi;
+	return irq;
+}
+
+static void acpi_unregister_gsi_ioapic(u32 gsi)
+{
+#ifdef CONFIG_X86_IO_APIC
+	mp_unregister_gsi(gsi);
+#endif
 }
 
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 			   int trigger, int polarity) = acpi_register_gsi_pic;
+void (*__acpi_unregister_gsi)(u32 gsi) = NULL;
 
 #ifdef CONFIG_ACPI_SLEEP
 int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
@@ -568,32 +679,22 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int irq;
-	unsigned int plat_gsi = gsi;
-
-	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
-	irq = gsi_to_irq(plat_gsi);
-
-	return irq;
+	return __acpi_register_gsi(dev, gsi, trigger, polarity);
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
 void acpi_unregister_gsi(u32 gsi)
 {
+	if (__acpi_unregister_gsi)
+		__acpi_unregister_gsi(gsi);
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
-void __init acpi_set_irq_model_pic(void)
-{
-	acpi_irq_model = ACPI_IRQ_MODEL_PIC;
-	__acpi_register_gsi = acpi_register_gsi_pic;
-	acpi_ioapic = 0;
-}
-
-void __init acpi_set_irq_model_ioapic(void)
+static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
 	__acpi_register_gsi = acpi_register_gsi_ioapic;
+	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
 
@@ -829,9 +930,8 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
 	 */
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
-				  acpi_parse_lapic_addr_ovr, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing LAPIC address override entry\n");
@@ -856,9 +956,8 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
 	 */
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
-				  acpi_parse_lapic_addr_ovr, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing LAPIC address override entry\n");
@@ -886,11 +985,10 @@ static int __init acpi_parse_madt_lapic_entries(void)
 		return count;
 	}
 
-	x2count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
-				  acpi_parse_x2apic_nmi, 0);
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI, acpi_parse_lapic_nmi, 0);
+	x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
+					acpi_parse_x2apic_nmi, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
+				      acpi_parse_lapic_nmi, 0);
 	if (count < 0 || x2count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
@@ -901,44 +999,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 #endif				/* CONFIG_X86_LOCAL_APIC */
 
 #ifdef	CONFIG_X86_IO_APIC
-#define MP_ISA_BUS		0
-
-void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
-{
-	int ioapic;
-	int pin;
-	struct mpc_intsrc mp_irq;
-
-	/*
-	 * Convert 'gsi' to 'ioapic.pin'.
-	 */
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return;
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	/*
-	 * TBD: This check is for faulty timer entries, where the override
-	 *      erroneously sets the trigger to level, resulting in a HUGE
-	 *      increase of timer interrupts!
-	 */
-	if ((bus_irq == 0) && (trigger == 3))
-		trigger = 1;
-
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (trigger << 2) | polarity;
-	mp_irq.srcbus = MP_ISA_BUS;
-	mp_irq.srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
-	mp_irq.dstirq = pin;	/* INTIN# */
-
-	mp_save_irq(&mp_irq);
-
-	isa_irq_to_gsi[bus_irq] = gsi;
-}
-
-void __init mp_config_acpi_legacy_irqs(void)
+static void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
 	struct mpc_intsrc mp_irq;
@@ -956,7 +1017,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
 	 */
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		int ioapic, pin;
 		unsigned int dstapic;
 		int idx;
@@ -1004,84 +1065,6 @@ void __init mp_config_acpi_legacy_irqs(void)
 	}
 }
 
-static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
-			int polarity)
-{
-#ifdef CONFIG_X86_MPPARSE
-	struct mpc_intsrc mp_irq;
-	struct pci_dev *pdev;
-	unsigned char number;
-	unsigned int devfn;
-	int ioapic;
-	u8 pin;
-
-	if (!acpi_ioapic)
-		return 0;
-	if (!dev || !dev_is_pci(dev))
-		return 0;
-
-	pdev = to_pci_dev(dev);
-	number = pdev->bus->number;
-	devfn = pdev->devfn;
-	pin = pdev->pin;
-	/* print the entry should happen on mptable identically */
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
-				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.srcbus = number;
-	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
-	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mpc_ioapic_id(ioapic);
-	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
-
-	mp_save_irq(&mp_irq);
-#endif
-	return 0;
-}
-
-int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
-{
-	int ioapic;
-	int ioapic_pin;
-	struct io_apic_irq_attr irq_attr;
-	int ret;
-
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return gsi;
-
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
-	}
-
-	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mpc_ioapic_id(ioapic),
-		       ioapic_pin);
-		return gsi;
-	}
-
-	if (enable_update_mptable)
-		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
-
-	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
-			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
-			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
-	if (ret < 0)
-		gsi = INT_MIN;
-
-	return gsi;
-}
-
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
@@ -1111,9 +1094,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return -ENODEV;
 	}
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_IO_APIC, acpi_parse_ioapic,
-				  MAX_IO_APICS);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_IO_APIC, acpi_parse_ioapic,
+				      MAX_IO_APICS);
 	if (!count) {
 		printk(KERN_ERR PREFIX "No IOAPIC entries present\n");
 		return -ENODEV;
@@ -1122,9 +1104,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return count;
 	}
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  nr_irqs);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
+				      acpi_parse_int_src_ovr, nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -1143,9 +1124,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  nr_irqs);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE,
+				      acpi_parse_nmi_src, nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ad28db7..6776027 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 /*
  * The highest APIC ID seen during enumeration.
  */
-unsigned int max_physical_apicid;
+static unsigned int max_physical_apicid;
 
 /*
  * Bitmask of physically existing CPUs:
@@ -1342,17 +1342,6 @@ void setup_local_APIC(void)
 	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
-
-	/*
-	 * Some NUMA implementations (NUMAQ) don't initialize apicid to
-	 * node mapping during NUMA init.  Now that logical apicid is
-	 * guaranteed to be known, give it another chance.  This is already
-	 * a bit too late - percpu allocation has already happened without
-	 * proper NUMA affinity.
-	 */
-	if (apic->x86_32_numa_cpu_node)
-		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
-				   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
 	/*
@@ -2053,8 +2042,6 @@ void __init connect_bsp_APIC(void)
 		imcr_pic_to_apic();
 	}
 #endif
-	if (apic->enable_apic_mode)
-		apic->enable_apic_mode();
 }
 
 /**
@@ -2451,51 +2438,6 @@ static void apic_pm_activate(void) { }
 
 #ifdef CONFIG_X86_64
 
-static int apic_cluster_num(void)
-{
-	int i, clusters, zeros;
-	unsigned id;
-	u16 *bios_cpu_apicid;
-	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
-
-	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		/* are we being called early in kernel startup? */
-		if (bios_cpu_apicid) {
-			id = bios_cpu_apicid[i];
-		} else if (i < nr_cpu_ids) {
-			if (cpu_present(i))
-				id = per_cpu(x86_bios_cpu_apicid, i);
-			else
-				continue;
-		} else
-			break;
-
-		if (id != BAD_APICID)
-			__set_bit(APIC_CLUSTERID(id), clustermap);
-	}
-
-	/* Problem:  Partially populated chassis may not have CPUs in some of
-	 * the APIC clusters they have been allocated.  Only present CPUs have
-	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
-	 * Since clusters are allocated sequentially, count zeros only if
-	 * they are bounded by ones.
-	 */
-	clusters = 0;
-	zeros = 0;
-	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
-		if (test_bit(i, clustermap)) {
-			clusters += 1 + zeros;
-			zeros = 0;
-		} else
-			++zeros;
-	}
-
-	return clusters;
-}
-
 static int multi_checked;
 static int multi;
 
@@ -2540,20 +2482,7 @@ static void dmi_check_multi(void)
 int apic_is_clustered_box(void)
 {
 	dmi_check_multi();
-	if (multi)
-		return 1;
-
-	if (!is_vsmp_box())
-		return 0;
-
-	/*
-	 * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
-	 * not guaranteed to be synced between boards
-	 */
-	if (apic_cluster_num() > 1)
-		return 1;
-
-	return 0;
+	return multi;
 }
 #endif
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 7c1b294..de918c4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -168,21 +168,16 @@ static struct apic apic_flat =  {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
@@ -196,10 +191,7 @@ static struct apic apic_flat =  {
 	.send_IPI_all			= flat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
@@ -283,7 +275,6 @@ static struct apic apic_physflat =  {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	/* not needed, but shouldn't hurt: */
@@ -291,14 +282,10 @@ static struct apic apic_physflat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
@@ -312,10 +299,7 @@ static struct apic apic_physflat =  {
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 8c7c982..b205cdb 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -89,16 +89,6 @@ static const struct cpumask *noop_target_cpus(void)
 	return cpumask_of(0);
 }
 
-static unsigned long noop_check_apicid_used(physid_mask_t *map, int apicid)
-{
-	return physid_isset(apicid, *map);
-}
-
-static unsigned long noop_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
 static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
 					  const struct cpumask *mask)
 {
@@ -133,27 +123,21 @@ struct apic apic_noop = {
 	.target_cpus			= noop_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= noop_check_apicid_used,
-	.check_apicid_present		= noop_check_apicid_present,
+	.check_apicid_used		= default_check_apicid_used,
 
 	.vector_allocation_domain	= noop_vector_allocation_domain,
 	.init_apic_ldr			= noop_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 
 	.phys_pkg_id			= noop_phys_pkg_id,
 
-	.mps_oem_check			= NULL,
-
 	.get_apic_id			= noop_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
@@ -168,12 +152,7 @@ struct apic apic_noop = {
 
 	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
 
-	/* should be safe */
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= noop_apic_read,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index a5b45df..ae91539 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -217,21 +217,16 @@ static const struct apic apic_numachip __refconst = {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numachip_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= set_apic_id,
@@ -246,10 +241,7 @@ static const struct apic apic_numachip __refconst = {
 	.send_IPI_self			= numachip_send_IPI_self,
 
 	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL, /* REMRD not supported */
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index e4840aa..c4a8d63 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -31,11 +31,6 @@ static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 	return 0;
 }
 
-static unsigned long bigsmp_check_apicid_present(int bit)
-{
-	return 1;
-}
-
 static int bigsmp_early_logical_apicid(int cpu)
 {
 	/* on bigsmp, logical apicid is the same as physical */
@@ -168,21 +163,16 @@ static struct apic apic_bigsmp = {
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
-	.check_apicid_present		= bigsmp_check_apicid_present,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= bigsmp_get_apic_id,
 	.set_apic_id			= NULL,
@@ -196,11 +186,7 @@ static struct apic apic_bigsmp = {
 	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 81e08ef..29290f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -31,6 +31,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
+#include <linux/irqdomain.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
@@ -62,6 +63,16 @@
 
 #define __apicdebuginit(type) static type __init
 
+#define	for_each_ioapic(idx)		\
+	for ((idx) = 0; (idx) < nr_ioapics; (idx)++)
+#define	for_each_ioapic_reverse(idx)	\
+	for ((idx) = nr_ioapics - 1; (idx) >= 0; (idx)--)
+#define	for_each_pin(idx, pin)		\
+	for ((pin) = 0; (pin) < ioapics[(idx)].nr_registers; (pin)++)
+#define	for_each_ioapic_pin(idx, pin)	\
+	for_each_ioapic((idx))		\
+		for_each_pin((idx), (pin))
+
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
@@ -73,6 +84,17 @@ int sis_apic_bug = -1;
 
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
+static DEFINE_MUTEX(ioapic_mutex);
+static unsigned int ioapic_dynirq_base;
+static int ioapic_initialized;
+
+struct mp_pin_info {
+	int trigger;
+	int polarity;
+	int node;
+	int set;
+	u32 count;
+};
 
 static struct ioapic {
 	/*
@@ -87,7 +109,9 @@ static struct ioapic {
 	struct mpc_ioapic mp_config;
 	/* IO APIC gsi routing info */
 	struct mp_ioapic_gsi  gsi_config;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+	struct ioapic_domain_cfg irqdomain_cfg;
+	struct irq_domain *irqdomain;
+	struct mp_pin_info *pin_info;
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
@@ -107,6 +131,41 @@ struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 	return &ioapics[ioapic_idx].gsi_config;
 }
 
+static inline int mp_ioapic_pin_count(int ioapic)
+{
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+
+	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+}
+
+u32 mp_pin_to_gsi(int ioapic, int pin)
+{
+	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
+}
+
+/*
+ * Initialize all legacy IRQs and all pins on the first IOAPIC
+ * if we have legacy interrupt controller. Kernel boot option "pirq="
+ * may rely on non-legacy pins on the first IOAPIC.
+ */
+static inline int mp_init_irq_at_boot(int ioapic, int irq)
+{
+	if (!nr_legacy_irqs())
+		return 0;
+
+	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
+}
+
+static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
+{
+	return ioapics[ioapic_idx].pin_info + pin;
+}
+
+static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
+{
+	return ioapics[ioapic].irqdomain;
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -118,9 +177,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* GSI interrupts */
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
-
 #ifdef CONFIG_EISA
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -149,8 +205,7 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static int io_apic_setup_irq_pin(unsigned int irq, int node,
-				 struct io_apic_irq_attr *attr);
+static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
 
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
@@ -182,19 +237,15 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
-
-/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
-	int count, node, i;
+	int i, node = cpu_to_node(0);
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		ioapics[i].saved_registers =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				ioapics[i].nr_registers, GFP_KERNEL);
@@ -202,28 +253,20 @@ int __init arch_early_irq_init(void)
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
 
-	cfg = irq_cfgx;
-	count = ARRAY_SIZE(irq_cfgx);
-	node = cpu_to_node(0);
-
-	for (i = 0; i < count; i++) {
-		irq_set_chip_data(i, &cfg[i]);
-		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
-		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
-		/*
-		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
-		 */
-		if (i < legacy_pic->nr_legacy_irqs) {
-			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_setall(cfg[i].domain);
-		}
+	/*
+	 * For legacy IRQ's, start with assigning irq0 to irq15 to
+	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+	 */
+	for (i = 0; i < nr_legacy_irqs(); i++) {
+		cfg = alloc_irq_and_cfg_at(i, node);
+		cfg->vector = IRQ0_VECTOR + i;
+		cpumask_setall(cfg->domain);
 	}
 
 	return 0;
 }
 
-static struct irq_cfg *irq_cfg(unsigned int irq)
+static inline struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
 }
@@ -265,7 +308,7 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	if (res < 0) {
 		if (res != -EEXIST)
 			return NULL;
-		cfg = irq_get_chip_data(at);
+		cfg = irq_cfg(at);
 		if (cfg)
 			return cfg;
 	}
@@ -425,6 +468,21 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	return 0;
 }
 
+static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
+{
+	struct irq_pin_list **last, *entry;
+
+	last = &cfg->irq_2_pin;
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		if (entry->apic == apic && entry->pin == pin) {
+			*last = entry->next;
+			kfree(entry);
+			return;
+		} else {
+			last = &entry->next;
+		}
+}
+
 static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	if (__add_pin_to_irq_node(cfg, node, apic, pin))
@@ -627,9 +685,8 @@ static void clear_IO_APIC (void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
-			clear_IO_APIC_pin(apic, pin);
+	for_each_ioapic_pin(apic, pin)
+		clear_IO_APIC_pin(apic, pin);
 }
 
 #ifdef CONFIG_X86_32
@@ -678,13 +735,13 @@ int save_ioapic_entries(void)
 	int apic, pin;
 	int err = 0;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers) {
 			err = -ENOMEM;
 			continue;
 		}
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
+		for_each_pin(apic, pin)
 			ioapics[apic].saved_registers[pin] =
 				ioapic_read_entry(apic, pin);
 	}
@@ -699,11 +756,11 @@ void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
+		for_each_pin(apic, pin) {
 			struct IO_APIC_route_entry entry;
 
 			entry = ioapics[apic].saved_registers[pin];
@@ -722,11 +779,11 @@ int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for_each_ioapic(apic) {
 		if (!ioapics[apic].saved_registers)
 			continue;
 
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
+		for_each_pin(apic, pin)
 			ioapic_write_entry(apic, pin,
 					   ioapics[apic].saved_registers[pin]);
 	}
@@ -785,7 +842,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int ioapic_idx;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
 				return ioapic_idx;
 	}
@@ -799,7 +856,7 @@ static int __init find_isa_irq_apic(int irq, int type)
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < legacy_pic->nr_legacy_irqs) {
+	if (irq < nr_legacy_irqs()) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -939,29 +996,101 @@ static int irq_trigger(int idx)
 	return trigger;
 }
 
-static int pin_2_irq(int idx, int apic, int pin)
+static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
+{
+	int irq = -1;
+	int ioapic = (int)(long)domain->host_data;
+	int type = ioapics[ioapic].irqdomain_cfg.type;
+
+	switch (type) {
+	case IOAPIC_DOMAIN_LEGACY:
+		/*
+		 * Dynamically allocate IRQ number for non-ISA IRQs in the first 16
+		 * GSIs on some weird platforms.
+		 */
+		if (gsi < nr_legacy_irqs())
+			irq = irq_create_mapping(domain, pin);
+		else if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0)
+			irq = gsi;
+		break;
+	case IOAPIC_DOMAIN_STRICT:
+		if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0)
+			irq = gsi;
+		break;
+	case IOAPIC_DOMAIN_DYNAMIC:
+		irq = irq_create_mapping(domain, pin);
+		break;
+	default:
+		WARN(1, "ioapic: unknown irqdomain type %d\n", type);
+		break;
+	}
+
+	return irq > 0 ? irq : -1;
+}
+
+static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
+			     unsigned int flags)
 {
 	int irq;
-	int bus = mp_irqs[idx].srcbus;
-	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(apic);
+	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
+	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
+
+	if (!domain)
+		return -1;
+
+	mutex_lock(&ioapic_mutex);
 
 	/*
-	 * Debugging check, we are in big trouble if this message pops up!
+	 * Don't use irqdomain to manage ISA IRQs because there may be
+	 * multiple IOAPIC pins sharing the same ISA IRQ number and
+	 * irqdomain only supports 1:1 mapping between IOAPIC pin and
+	 * IRQ number. A typical IOAPIC has 24 pins, pin 0-15 are used
+	 * for legacy IRQs and pin 16-23 are used for PCI IRQs (PIRQ A-H).
+	 * When ACPI is disabled, only legacy IRQ numbers (IRQ0-15) are
+	 * available, and some BIOSes may use MP Interrupt Source records
+	 * to override IRQ numbers for PIRQs instead of reprogramming
+	 * the interrupt routing logic. Thus there may be multiple pins
+	 * sharing the same legacy IRQ number when ACPI is disabled.
 	 */
-	if (mp_irqs[idx].dstirq != pin)
-		pr_err("broken BIOS or MPTABLE parser, ayiee!!\n");
-
-	if (test_bit(bus, mp_bus_not_pci)) {
+	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
+		if (flags & IOAPIC_MAP_ALLOC) {
+			if (info->count == 0 &&
+			    mp_irqdomain_map(domain, irq, pin) != 0)
+				irq = -1;
+
+			/* special handling for timer IRQ0 */
+			if (irq == 0)
+				info->count++;
+		}
 	} else {
-		u32 gsi = gsi_cfg->gsi_base + pin;
+		irq = irq_find_mapping(domain, pin);
+		if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
+			irq = alloc_irq_from_domain(domain, gsi, pin);
+	}
 
-		if (gsi >= NR_IRQS_LEGACY)
-			irq = gsi;
-		else
-			irq = gsi_top + gsi;
+	if (flags & IOAPIC_MAP_ALLOC) {
+		if (irq > 0)
+			info->count++;
+		else if (info->count == 0)
+			info->set = 0;
 	}
 
+	mutex_unlock(&ioapic_mutex);
+
+	return irq > 0 ? irq : -1;
+}
+
+static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
+{
+	u32 gsi = mp_pin_to_gsi(ioapic, pin);
+
+	/*
+	 * Debugging check, we are in big trouble if this message pops up!
+	 */
+	if (mp_irqs[idx].dstirq != pin)
+		pr_err("broken BIOS or MPTABLE parser, ayiee!!\n");
+
 #ifdef CONFIG_X86_32
 	/*
 	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
@@ -972,16 +1101,58 @@ static int pin_2_irq(int idx, int apic, int pin)
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
 						"disabling PIRQ%d\n", pin-16);
 			} else {
-				irq = pirq_entries[pin-16];
+				int irq = pirq_entries[pin-16];
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
 						"using PIRQ%d -> IRQ %d\n",
 						pin-16, irq);
+				return irq;
 			}
 		}
 	}
 #endif
 
-	return irq;
+	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+}
+
+int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
+{
+	int ioapic, pin, idx;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return -1;
+
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	idx = find_irq_entry(ioapic, pin, mp_INT);
+	if ((flags & IOAPIC_MAP_CHECK) && idx < 0)
+		return -1;
+
+	return mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+}
+
+void mp_unmap_irq(int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	struct mp_pin_info *info;
+	int ioapic, pin;
+
+	if (!data || !data->domain)
+		return;
+
+	ioapic = (int)(long)data->domain->host_data;
+	pin = (int)data->hwirq;
+	info = mp_pin_info(ioapic, pin);
+
+	mutex_lock(&ioapic_mutex);
+	if (--info->count == 0) {
+		info->set = 0;
+		if (irq < nr_legacy_irqs() &&
+		    ioapics[ioapic].irqdomain_cfg.type == IOAPIC_DOMAIN_LEGACY)
+			mp_irqdomain_unmap(data->domain, irq);
+		else
+			irq_dispose_mapping(irq);
+	}
+	mutex_unlock(&ioapic_mutex);
 }
 
 /*
@@ -991,7 +1162,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int ioapic_idx, i, best_guess = -1;
+	int irq, i, best_ioapic = -1, best_idx = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -1001,44 +1172,56 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 			    "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
+
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
+		int ioapic_idx, found = 0;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		if (bus != lbus || mp_irqs[i].irqtype != mp_INT ||
+		    slot != ((mp_irqs[i].srcbusirq >> 2) & 0x1f))
+			continue;
+
+		for_each_ioapic(ioapic_idx)
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
-			    mp_irqs[i].dstapic == MP_APIC_ALL)
+			    mp_irqs[i].dstapic == MP_APIC_ALL) {
+				found = 1;
 				break;
+			}
+		if (!found)
+			continue;
 
-		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].irqtype &&
-		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
+		/* Skip ISA IRQs */
+		irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq, 0);
+		if (irq > 0 && !IO_APIC_IRQ(irq))
+			continue;
 
-			if (!(ioapic_idx || IO_APIC_IRQ(irq)))
-				continue;
+		if (pin == (mp_irqs[i].srcbusirq & 3)) {
+			best_idx = i;
+			best_ioapic = ioapic_idx;
+			goto out;
+		}
 
-			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				set_io_apic_irq_attr(irq_attr, ioapic_idx,
-						     mp_irqs[i].dstirq,
-						     irq_trigger(i),
-						     irq_polarity(i));
-				return irq;
-			}
-			/*
-			 * Use the first all-but-pin matching entry as a
-			 * best-guess fuzzy result for broken mptables.
-			 */
-			if (best_guess < 0) {
-				set_io_apic_irq_attr(irq_attr, ioapic_idx,
-						     mp_irqs[i].dstirq,
-						     irq_trigger(i),
-						     irq_polarity(i));
-				best_guess = irq;
-			}
+		/*
+		 * Use the first all-but-pin matching entry as a
+		 * best-guess fuzzy result for broken mptables.
+		 */
+		if (best_idx < 0) {
+			best_idx = i;
+			best_ioapic = ioapic_idx;
 		}
 	}
-	return best_guess;
+	if (best_idx < 0)
+		return -1;
+
+out:
+	irq = pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
+			IOAPIC_MAP_ALLOC);
+	if (irq > 0)
+		set_io_apic_irq_attr(irq_attr, best_ioapic,
+				     mp_irqs[best_idx].dstirq,
+				     irq_trigger(best_idx),
+				     irq_polarity(best_idx));
+	return irq;
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
@@ -1198,7 +1381,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 
@@ -1227,12 +1410,10 @@ static inline int IO_APIC_irq_trigger(int irq)
 {
 	int apic, idx, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
-				return irq_trigger(idx);
-		}
+	for_each_ioapic_pin(apic, pin) {
+		idx = find_irq_entry(apic, pin, mp_INT);
+		if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin, 0)))
+			return irq_trigger(idx);
 	}
 	/*
          * nonexistent IRQs are edge default
@@ -1330,95 +1511,29 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	}
 
 	ioapic_register_intr(irq, cfg, attr->trigger);
-	if (irq < legacy_pic->nr_legacy_irqs)
+	if (irq < nr_legacy_irqs())
 		legacy_pic->mask(irq);
 
 	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int ioapic_idx, int pin)
-{
-	if (idx != -1)
-		return false;
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(ioapic_idx), pin);
-	return true;
-}
-
-static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
-{
-	int idx, node = cpu_to_node(0);
-	struct io_apic_irq_attr attr;
-	unsigned int pin, irq;
-
-	for (pin = 0; pin < ioapics[ioapic_idx].nr_registers; pin++) {
-		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
-			continue;
-
-		irq = pin_2_irq(idx, ioapic_idx, pin);
-
-		if ((ioapic_idx > 0) && (irq > 16))
-			continue;
-
-		/*
-		 * Skip the timer IRQ if there's a quirk handler
-		 * installed and if it returns 1:
-		 */
-		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(ioapic_idx, irq))
-			continue;
-
-		set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-				     irq_polarity(idx));
-
-		io_apic_setup_irq_pin(irq, node, &attr);
-	}
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int ioapic_idx;
+	unsigned int ioapic, pin;
+	int idx;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
-		__io_apic_setup_irqs(ioapic_idx);
-}
-
-/*
- * for the gsit that is not in first ioapic
- * but could not use acpi_register_gsi()
- * like some special sci in IBM x3330
- */
-void setup_IO_APIC_irq_extra(u32 gsi)
-{
-	int ioapic_idx = 0, pin, idx, irq, node = cpu_to_node(0);
-	struct io_apic_irq_attr attr;
-
-	/*
-	 * Convert 'gsi' to 'ioapic.pin'.
-	 */
-	ioapic_idx = mp_find_ioapic(gsi);
-	if (ioapic_idx < 0)
-		return;
-
-	pin = mp_find_ioapic_pin(ioapic_idx, gsi);
-	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-	if (idx == -1)
-		return;
-
-	irq = pin_2_irq(idx, ioapic_idx, pin);
-
-	/* Only handle the non legacy irqs on secondary ioapics */
-	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
-		return;
-
-	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-			     irq_polarity(idx));
-
-	io_apic_setup_irq_pin_once(irq, node, &attr);
+	for_each_ioapic_pin(ioapic, pin) {
+		idx = find_irq_entry(ioapic, pin, mp_INT);
+		if (idx < 0)
+			apic_printk(APIC_VERBOSE,
+				    KERN_DEBUG " apic %d pin %d not connected\n",
+				    mpc_ioapic_id(ioapic), pin);
+		else
+			pin_2_irq(idx, ioapic, pin,
+				  ioapic ? 0 : IOAPIC_MAP_ALLOC);
+	}
 }
 
 /*
@@ -1586,7 +1701,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
 		       mpc_ioapic_id(ioapic_idx),
 		       ioapics[ioapic_idx].nr_registers);
@@ -1597,7 +1712,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	 */
 	printk(KERN_INFO "testing the IO APIC.......................\n");
 
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+	for_each_ioapic(ioapic_idx)
 		print_IO_APIC(ioapic_idx);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
@@ -1608,7 +1723,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		if (chip != &ioapic_chip)
 			continue;
 
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -1758,7 +1873,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1828,26 +1943,22 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 void __init enable_IO_APIC(void)
 {
 	int i8259_apic, i8259_pin;
-	int apic;
+	int apic, pin;
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
-	for(apic = 0; apic < nr_ioapics; apic++) {
-		int pin;
+	for_each_ioapic_pin(apic, pin) {
 		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
-			struct IO_APIC_route_entry entry;
-			entry = ioapic_read_entry(apic, pin);
+		struct IO_APIC_route_entry entry = ioapic_read_entry(apic, pin);
 
-			/* If the interrupt line is enabled and in ExtInt mode
-			 * I have found the pin where the i8259 is connected.
-			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
-				ioapic_i8259.apic = apic;
-				ioapic_i8259.pin  = pin;
-				goto found_i8259;
-			}
+		/* If the interrupt line is enabled and in ExtInt mode
+		 * I have found the pin where the i8259 is connected.
+		 */
+		if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
+			ioapic_i8259.apic = apic;
+			ioapic_i8259.pin  = pin;
+			goto found_i8259;
 		}
 	}
  found_i8259:
@@ -1919,7 +2030,7 @@ void disable_IO_APIC(void)
 	 */
 	clear_IO_APIC();
 
-	if (!legacy_pic->nr_legacy_irqs)
+	if (!nr_legacy_irqs())
 		return;
 
 	x86_io_apic_ops.disable();
@@ -1950,7 +2061,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+	for_each_ioapic(ioapic_idx) {
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(ioapic_idx, 0);
@@ -2123,7 +2234,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < legacy_pic->nr_legacy_irqs) {
+	if (irq < nr_legacy_irqs()) {
 		legacy_pic->mask(irq);
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
@@ -2225,7 +2336,7 @@ asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__this_cpu_write(vector_irq[vector], -1);
+		__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
@@ -2253,7 +2364,7 @@ static void irq_complete_move(struct irq_cfg *cfg)
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!cfg)
 		return;
@@ -2514,26 +2625,15 @@ static inline void init_IO_APIC_traps(void)
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
-	/*
-	 * NOTE! The local APIC isn't very good at handling
-	 * multiple interrupts at the same interrupt level.
-	 * As the interrupt level is determined by taking the
-	 * vector number and shifting that right by 4, we
-	 * want to spread these out a bit so that they don't
-	 * all fall in the same interrupt level.
-	 *
-	 * Also, we've got to be careful not to trash gate
-	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
-	 */
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < legacy_pic->nr_legacy_irqs)
+			if (irq < nr_legacy_irqs())
 				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -2649,8 +2749,6 @@ static int __init disable_timer_pin_setup(char *arg)
 }
 early_param("disable_timer_pin_1", disable_timer_pin_setup);
 
-int timer_through_8259 __initdata;
-
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2661,7 +2759,7 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(0);
+	struct irq_cfg *cfg = irq_cfg(0);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2755,7 +2853,6 @@ static inline void __init check_timer(void)
 		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
-			timer_through_8259 = 1;
 			goto out;
 		}
 		/*
@@ -2827,15 +2924,54 @@ out:
  */
 #define PIC_IRQS	(1UL << PIC_CASCADE_IR)
 
+static int mp_irqdomain_create(int ioapic)
+{
+	size_t size;
+	int hwirqs = mp_ioapic_pin_count(ioapic);
+	struct ioapic *ip = &ioapics[ioapic];
+	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+
+	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
+	ip->pin_info = kzalloc(size, GFP_KERNEL);
+	if (!ip->pin_info)
+		return -ENOMEM;
+
+	if (cfg->type == IOAPIC_DOMAIN_INVALID)
+		return 0;
+
+	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
+					      (void *)(long)ioapic);
+	if(!ip->irqdomain) {
+		kfree(ip->pin_info);
+		ip->pin_info = NULL;
+		return -ENOMEM;
+	}
+
+	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
+	    cfg->type == IOAPIC_DOMAIN_STRICT)
+		ioapic_dynirq_base = max(ioapic_dynirq_base,
+					 gsi_cfg->gsi_end + 1);
+
+	if (gsi_cfg->gsi_base == 0)
+		irq_set_default_host(ip->irqdomain);
+
+	return 0;
+}
+
 void __init setup_IO_APIC(void)
 {
+	int ioapic;
 
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
-	io_apic_irqs = legacy_pic->nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
+	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+	for_each_ioapic(ioapic)
+		BUG_ON(mp_irqdomain_create(ioapic));
+
 	/*
          * Set up IO-APIC IRQ routing.
          */
@@ -2844,8 +2980,10 @@ void __init setup_IO_APIC(void)
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
-	if (legacy_pic->nr_legacy_irqs)
+	if (nr_legacy_irqs())
 		check_timer();
+
+	ioapic_initialized = 1;
 }
 
 /*
@@ -2880,7 +3018,7 @@ static void ioapic_resume(void)
 {
 	int ioapic_idx;
 
-	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+	for_each_ioapic_reverse(ioapic_idx)
 		resume_ioapic_id(ioapic_idx);
 
 	restore_ioapic_entries();
@@ -2926,7 +3064,7 @@ int arch_setup_hwirq(unsigned int irq, int node)
 
 void arch_teardown_hwirq(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	free_remapped_irq(irq);
@@ -3053,7 +3191,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (!irq_offset)
 		write_msi_msg(irq, &msg);
 
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3192,7 +3330,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
@@ -3303,27 +3441,6 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-			       struct io_apic_irq_attr *attr)
-{
-	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
-	int ret;
-	struct IO_APIC_route_entry orig_entry;
-
-	/* Avoid redundant programming */
-	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n", mpc_ioapic_id(ioapic_idx), pin);
-		orig_entry = ioapic_read_entry(attr->ioapic, pin);
-		if (attr->trigger == orig_entry.trigger && attr->polarity == orig_entry.polarity)
-			return 0;
-		return -EBUSY;
-	}
-	ret = io_apic_setup_irq_pin(irq, node, attr);
-	if (!ret)
-		set_bit(pin, ioapics[ioapic_idx].pin_programmed);
-	return ret;
-}
-
 static int __init io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3340,20 +3457,13 @@ static int __init io_apic_get_redir_entries(int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-static void __init probe_nr_irqs_gsi(void)
-{
-	int nr;
-
-	nr = gsi_top + NR_IRQS_LEGACY;
-	if (nr > nr_irqs_gsi)
-		nr_irqs_gsi = nr;
-
-	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
-}
-
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
-	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+	/*
+	 * dmar_alloc_hwirq() may be called before setup_IO_APIC(), so use
+	 * gsi_top if ioapic_dynirq_base hasn't been initialized yet.
+	 */
+	return ioapic_initialized ? ioapic_dynirq_base : gsi_top;
 }
 
 int __init arch_probe_nr_irqs(void)
@@ -3363,33 +3473,17 @@ int __init arch_probe_nr_irqs(void)
 	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
 		nr_irqs = NR_VECTORS * nr_cpu_ids;
 
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+	nr = (gsi_top + nr_legacy_irqs()) + 8 * nr_cpu_ids;
 #if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += nr_irqs_gsi * 16;
+	nr += gsi_top * 16;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
-}
-
-int io_apic_set_pci_routing(struct device *dev, int irq,
-			    struct io_apic_irq_attr *irq_attr)
-{
-	int node;
-
-	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			    irq_attr->ioapic);
-		return -EINVAL;
-	}
-
-	node = dev ? dev_to_node(dev) : cpu_to_node(0);
-
-	return io_apic_setup_irq_pin_once(irq, node, irq_attr);
+	return 0;
 }
 
 #ifdef CONFIG_X86_32
@@ -3483,9 +3577,8 @@ static u8 __init io_apic_unique_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 
 	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
-	}
 	if (!test_bit(id, used))
 		return id;
 	return find_first_zero_bit(used, 256);
@@ -3543,14 +3636,13 @@ void __init setup_ioapic_dest(void)
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
-	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
+	for_each_ioapic_pin(ioapic, pin) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
-		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > 16))
+		irq = pin_2_irq(irq_entry, ioapic, pin, 0);
+		if (irq < 0 || !mp_init_irq_at_boot(ioapic, irq))
 			continue;
 
 		idata = irq_get_irq_data(irq);
@@ -3573,29 +3665,33 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(int nr_ioapics)
+static struct resource * __init ioapic_setup_resources(void)
 {
 	unsigned long n;
 	struct resource *res;
 	char *mem;
-	int i;
+	int i, num = 0;
 
-	if (nr_ioapics <= 0)
+	for_each_ioapic(i)
+		num++;
+	if (num == 0)
 		return NULL;
 
 	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
-	n *= nr_ioapics;
+	n *= num;
 
 	mem = alloc_bootmem(n);
 	res = (void *)mem;
 
-	mem += sizeof(struct resource) * nr_ioapics;
+	mem += sizeof(struct resource) * num;
 
-	for (i = 0; i < nr_ioapics; i++) {
-		res[i].name = mem;
-		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	num = 0;
+	for_each_ioapic(i) {
+		res[num].name = mem;
+		res[num].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
+		num++;
 	}
 
 	ioapic_resources = res;
@@ -3609,8 +3705,8 @@ void __init native_io_apic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources(nr_ioapics);
-	for (i = 0; i < nr_ioapics; i++) {
+	ioapic_res = ioapic_setup_resources();
+	for_each_ioapic(i) {
 		if (smp_found_config) {
 			ioapic_phys = mpc_ioapic_addr(i);
 #ifdef CONFIG_X86_32
@@ -3641,8 +3737,6 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
-
-	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
@@ -3657,7 +3751,7 @@ void __init ioapic_insert_resources(void)
 		return;
 	}
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		insert_resource(&iomem_resource, r);
 		r++;
 	}
@@ -3665,16 +3759,15 @@ void __init ioapic_insert_resources(void)
 
 int mp_find_ioapic(u32 gsi)
 {
-	int i = 0;
+	int i;
 
 	if (nr_ioapics == 0)
 		return -1;
 
 	/* Find the IOAPIC that manages this GSI. */
-	for (i = 0; i < nr_ioapics; i++) {
+	for_each_ioapic(i) {
 		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
-		if ((gsi >= gsi_cfg->gsi_base)
-		    && (gsi <= gsi_cfg->gsi_end))
+		if (gsi >= gsi_cfg->gsi_base && gsi <= gsi_cfg->gsi_end)
 			return i;
 	}
 
@@ -3686,7 +3779,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (WARN_ON(ioapic == -1))
+	if (WARN_ON(ioapic < 0))
 		return -1;
 
 	gsi_cfg = mp_ioapic_gsi_routing(ioapic);
@@ -3729,7 +3822,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			       struct ioapic_domain_cfg *cfg)
 {
 	int idx = 0;
 	int entries;
@@ -3743,6 +3837,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
+	ioapics[idx].irqdomain = NULL;
+	ioapics[idx].irqdomain_cfg = *cfg;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
@@ -3779,6 +3875,77 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	nr_ioapics++;
 }
 
+int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
+		     irq_hw_number_t hwirq)
+{
+	int ioapic = (int)(long)domain->host_data;
+	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
+	struct io_apic_irq_attr attr;
+
+	/* Get default attribute if not set by caller yet */
+	if (!info->set) {
+		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
+
+		if (acpi_get_override_irq(gsi, &info->trigger,
+					  &info->polarity) < 0) {
+			/*
+			 * PCI interrupts are always polarity one level
+			 * triggered.
+			 */
+			info->trigger = 1;
+			info->polarity = 1;
+		}
+		info->node = NUMA_NO_NODE;
+		info->set = 1;
+	}
+	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
+			     info->polarity);
+
+	return io_apic_setup_irq_pin(virq, info->node, &attr);
+}
+
+void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
+{
+	struct irq_data *data = irq_get_irq_data(virq);
+	struct irq_cfg *cfg = irq_cfg(virq);
+	int ioapic = (int)(long)domain->host_data;
+	int pin = (int)data->hwirq;
+
+	ioapic_mask_entry(ioapic, pin);
+	__remove_pin_from_irq(cfg, ioapic, pin);
+	WARN_ON(cfg->irq_2_pin != NULL);
+	arch_teardown_hwirq(virq);
+}
+
+int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
+{
+	int ret = 0;
+	int ioapic, pin;
+	struct mp_pin_info *info;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return -ENODEV;
+
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	info = mp_pin_info(ioapic, pin);
+	trigger = trigger ? 1 : 0;
+	polarity = polarity ? 1 : 0;
+
+	mutex_lock(&ioapic_mutex);
+	if (!info->set) {
+		info->trigger = trigger;
+		info->polarity = polarity;
+		info->node = node;
+		info->set = 1;
+	} else if (info->trigger != trigger || info->polarity != polarity) {
+		ret = -EBUSY;
+	}
+	mutex_unlock(&ioapic_mutex);
+
+	return ret;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index cceb352..bda4886 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -88,21 +88,16 @@ static struct apic apic_default = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= default_check_apicid_used,
-	.check_apicid_present		= default_check_apicid_present,
 
 	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= default_get_apic_id,
 	.set_apic_id			= NULL,
@@ -116,11 +111,7 @@ static struct apic apic_default = {
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
@@ -214,29 +205,7 @@ void __init generic_apic_probe(void)
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
 }
 
-/* These functions can switch the APIC even after the initial ->probe() */
-
-int __init
-generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
-{
-	struct apic **drv;
-
-	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
-		if (!((*drv)->mps_oem_check))
-			continue;
-		if (!(*drv)->mps_oem_check(mpc, oem, productid))
-			continue;
-
-		if (!cmdline_apic) {
-			apic = *drv;
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
-		}
-		return 1;
-	}
-	return 0;
-}
-
+/* This function can switch the APIC even after the initial ->probe() */
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	struct apic **drv;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e66766b..6ce600f 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -249,21 +249,16 @@ static struct apic apic_x2apic_cluster = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= cluster_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= x2apic_set_apic_id,
@@ -277,10 +272,7 @@ static struct apic apic_x2apic_cluster = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 6d600eb..6fae733 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -103,21 +103,16 @@ static struct apic apic_x2apic_phys = {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= x2apic_set_apic_id,
@@ -131,10 +126,7 @@ static struct apic apic_x2apic_phys = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 293b41d..004f017 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -365,21 +365,16 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= uv_init_apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= set_apic_id,
@@ -394,10 +389,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.send_IPI_self			= uv_send_IPI_self,
 
 	.wakeup_secondary_cpu		= uv_wakeup_secondary,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 7db54b5..3d35033 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -21,6 +21,7 @@
 #include <asm/apic.h>
 #include <asm/pci_x86.h>
 #include <asm/setup.h>
+#include <asm/i8259.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
@@ -165,82 +166,6 @@ static void __init dtb_lapic_setup(void)
 #ifdef CONFIG_X86_IO_APIC
 static unsigned int ioapic_id;
 
-static void __init dtb_add_ioapic(struct device_node *dn)
-{
-	struct resource r;
-	int ret;
-
-	ret = of_address_to_resource(dn, 0, &r);
-	if (ret) {
-		printk(KERN_ERR "Can't obtain address from node %s.\n",
-				dn->full_name);
-		return;
-	}
-	mp_register_ioapic(++ioapic_id, r.start, gsi_top);
-}
-
-static void __init dtb_ioapic_setup(void)
-{
-	struct device_node *dn;
-
-	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
-		dtb_add_ioapic(dn);
-
-	if (nr_ioapics) {
-		of_ioapic = 1;
-		return;
-	}
-	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
-}
-#else
-static void __init dtb_ioapic_setup(void) {}
-#endif
-
-static void __init dtb_apic_setup(void)
-{
-	dtb_lapic_setup();
-	dtb_ioapic_setup();
-}
-
-#ifdef CONFIG_OF_FLATTREE
-static void __init x86_flattree_get_config(void)
-{
-	u32 size, map_len;
-	void *dt;
-
-	if (!initial_dtb)
-		return;
-
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
-
-	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
-	size = of_get_flat_dt_size();
-	if (map_len < size) {
-		early_iounmap(dt, map_len);
-		initial_boot_params = dt = early_memremap(initial_dtb, size);
-		map_len = size;
-	}
-
-	unflatten_and_copy_device_tree();
-	early_iounmap(dt, map_len);
-}
-#else
-static inline void x86_flattree_get_config(void) { }
-#endif
-
-void __init x86_dtb_init(void)
-{
-	x86_flattree_get_config();
-
-	if (!of_have_populated_dt())
-		return;
-
-	dtb_setup_hpet();
-	dtb_apic_setup();
-}
-
-#ifdef CONFIG_X86_IO_APIC
-
 struct of_ioapic_type {
 	u32 out_type;
 	u32 trigger;
@@ -276,10 +201,8 @@ static int ioapic_xlate(struct irq_domain *domain,
 			const u32 *intspec, u32 intsize,
 			irq_hw_number_t *out_hwirq, u32 *out_type)
 {
-	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
-	u32 line, idx;
-	int rc;
+	u32 line, idx, gsi;
 
 	if (WARN_ON(intsize < 2))
 		return -EINVAL;
@@ -291,13 +214,10 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 	it = &of_ioapic_type[intspec[1]];
 
-	idx = (u32) domain->host_data;
-	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
-
-	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
-					cpu_to_node(0), &attr);
-	if (rc)
-		return rc;
+	idx = (u32)(long)domain->host_data;
+	gsi = mp_pin_to_gsi(idx, line);
+	if (mp_set_gsi_attr(gsi, it->trigger, it->polarity, cpu_to_node(0)))
+		return -EBUSY;
 
 	*out_hwirq = line;
 	*out_type = it->out_type;
@@ -305,81 +225,86 @@ static int ioapic_xlate(struct irq_domain *domain,
 }
 
 const struct irq_domain_ops ioapic_irq_domain_ops = {
+	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
 	.xlate = ioapic_xlate,
 };
 
-static void dt_add_ioapic_domain(unsigned int ioapic_num,
-		struct device_node *np)
+static void __init dtb_add_ioapic(struct device_node *dn)
 {
-	struct irq_domain *id;
-	struct mp_ioapic_gsi *gsi_cfg;
+	struct resource r;
 	int ret;
-	int num;
-
-	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
-	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
-
-	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
-			(void *)ioapic_num);
-	BUG_ON(!id);
-	if (gsi_cfg->gsi_base == 0) {
-		/*
-		 * The first NR_IRQS_LEGACY irq descs are allocated in
-		 * early_irq_init() and need just a mapping. The
-		 * remaining irqs need both. All of them are preallocated
-		 * and assigned so we can keep the 1:1 mapping which the ioapic
-		 * is having.
-		 */
-		irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
-
-		if (num > NR_IRQS_LEGACY) {
-			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
-					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
-			if (ret)
-				pr_err("Error creating mapping for the "
-						"remaining IRQs: %d\n", ret);
-		}
-		irq_set_default_host(id);
-	} else {
-		ret = irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
-		if (ret)
-			pr_err("Error creating IRQ mapping: %d\n", ret);
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &ioapic_irq_domain_ops,
+		.dev = dn,
+	};
+
+	ret = of_address_to_resource(dn, 0, &r);
+	if (ret) {
+		printk(KERN_ERR "Can't obtain address from node %s.\n",
+				dn->full_name);
+		return;
 	}
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top, &cfg);
 }
 
-static void __init ioapic_add_ofnode(struct device_node *np)
+static void __init dtb_ioapic_setup(void)
 {
-	struct resource r;
-	int i, ret;
+	struct device_node *dn;
 
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret) {
-		printk(KERN_ERR "Failed to obtain address for %s\n",
-				np->full_name);
+	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
+		dtb_add_ioapic(dn);
+
+	if (nr_ioapics) {
+		of_ioapic = 1;
 		return;
 	}
+	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
+}
+#else
+static void __init dtb_ioapic_setup(void) {}
+#endif
 
-	for (i = 0; i < nr_ioapics; i++) {
-		if (r.start == mpc_ioapic_addr(i)) {
-			dt_add_ioapic_domain(i, np);
-			return;
-		}
-	}
-	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
+static void __init dtb_apic_setup(void)
+{
+	dtb_lapic_setup();
+	dtb_ioapic_setup();
 }
 
-void __init x86_add_irq_domains(void)
+#ifdef CONFIG_OF_FLATTREE
+static void __init x86_flattree_get_config(void)
 {
-	struct device_node *dp;
+	u32 size, map_len;
+	void *dt;
 
-	if (!of_have_populated_dt())
+	if (!initial_dtb)
 		return;
 
-	for_each_node_with_property(dp, "interrupt-controller") {
-		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
-			ioapic_add_ofnode(dp);
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
+
+	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
+	size = of_get_flat_dt_size();
+	if (map_len < size) {
+		early_iounmap(dt, map_len);
+		initial_boot_params = dt = early_memremap(initial_dtb, size);
+		map_len = size;
 	}
+
+	unflatten_and_copy_device_tree();
+	early_iounmap(dt, map_len);
 }
 #else
-void __init x86_add_irq_domains(void) { }
+static inline void x86_flattree_get_config(void) { }
 #endif
+
+void __init x86_dtb_init(void)
+{
+	x86_flattree_get_config();
+
+	if (!of_have_populated_dt())
+		return;
+
+	dtb_setup_hpet();
+	dtb_apic_setup();
+}
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 7f50156..1e6cff5 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -78,7 +78,7 @@ void __init init_ISA_irqs(void)
 #endif
 	legacy_pic->init(0);
 
-	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
+	for (i = 0; i < nr_legacy_irqs(); i++)
 		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
 }
 
@@ -87,12 +87,6 @@ void __init init_IRQ(void)
 	int i;
 
 	/*
-	 * We probably need a better place for this, but it works for
-	 * now ...
-	 */
-	x86_add_irq_domains();
-
-	/*
 	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
 	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
 	 * then this configuration will likely be static after the boot. If
@@ -100,7 +94,7 @@ void __init init_IRQ(void)
 	 * then this vector space can be freed and re-used dynamically as the
 	 * irq's migrate etc.
 	 */
-	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
+	for (i = 0; i < nr_legacy_irqs(); i++)
 		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
 
 	x86_init.irqs.intr_init();
@@ -121,7 +115,7 @@ void setup_vector_irq(int cpu)
 	 * legacy PIC, for the new cpu that is coming online, setup the static
 	 * legacy vector to irq mapping:
 	 */
-	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+	for (irq = 0; irq < nr_legacy_irqs(); irq++)
 		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
 #endif
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..2d2a237 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/pci.h>
+#include <linux/irqdomain.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -67,7 +68,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 		boot_cpu_physical_apicid = m->apicid;
 	}
 
-	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
+	pr_info("Processor #%d%s\n", m->apicid, bootup_cpu);
 	generic_processor_info(apicid, m->apicver);
 }
 
@@ -87,9 +88,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 #if MAX_MP_BUSSES < 256
 	if (m->busid >= MAX_MP_BUSSES) {
-		printk(KERN_WARNING "MP table busid value (%d) for bustype %s "
-		       " is too large, max. supported is %d\n",
-		       m->busid, str, MAX_MP_BUSSES - 1);
+		pr_warn("MP table busid value (%d) for bustype %s is too large, max. supported is %d\n",
+			m->busid, str, MAX_MP_BUSSES - 1);
 		return;
 	}
 #endif
@@ -110,19 +110,29 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
 #endif
 	} else
-		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
+		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
 
+static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
+};
+
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_LEGACY,
+		.ops = &mp_ioapic_irqdomain_ops,
+	};
+
 	if (m->flags & MPC_APIC_USABLE)
-		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top, &cfg);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
+	apic_printk(APIC_VERBOSE,
+		"Int: type %d, pol %d, trig %d, bus %02x, IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->irqtype, mp_irq->irqflag & 3,
 		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
@@ -135,8 +145,8 @@ static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
 
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
-	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
+	apic_printk(APIC_VERBOSE,
+		"Lint: type %d, pol %d, trig %d, bus %02x, IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbusid,
 		m->srcbusirq, m->destapic, m->destapiclint);
 }
@@ -148,34 +158,33 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
 	if (memcmp(mpc->signature, MPC_SIGNATURE, 4)) {
-		printk(KERN_ERR "MPTABLE: bad signature [%c%c%c%c]!\n",
+		pr_err("MPTABLE: bad signature [%c%c%c%c]!\n",
 		       mpc->signature[0], mpc->signature[1],
 		       mpc->signature[2], mpc->signature[3]);
 		return 0;
 	}
 	if (mpf_checksum((unsigned char *)mpc, mpc->length)) {
-		printk(KERN_ERR "MPTABLE: checksum error!\n");
+		pr_err("MPTABLE: checksum error!\n");
 		return 0;
 	}
 	if (mpc->spec != 0x01 && mpc->spec != 0x04) {
-		printk(KERN_ERR "MPTABLE: bad table version (%d)!!\n",
-		       mpc->spec);
+		pr_err("MPTABLE: bad table version (%d)!!\n", mpc->spec);
 		return 0;
 	}
 	if (!mpc->lapic) {
-		printk(KERN_ERR "MPTABLE: null local APIC address!\n");
+		pr_err("MPTABLE: null local APIC address!\n");
 		return 0;
 	}
 	memcpy(oem, mpc->oem, 8);
 	oem[8] = 0;
-	printk(KERN_INFO "MPTABLE: OEM ID: %s\n", oem);
+	pr_info("MPTABLE: OEM ID: %s\n", oem);
 
 	memcpy(str, mpc->productid, 12);
 	str[12] = 0;
 
-	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
+	pr_info("MPTABLE: Product ID: %s\n", str);
 
-	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->lapic);
+	pr_info("MPTABLE: APIC at: 0x%X\n", mpc->lapic);
 
 	return 1;
 }
@@ -188,8 +197,8 @@ static void skip_entry(unsigned char **ptr, int *count, int size)
 
 static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
 {
-	printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n"
-		"type %x\n", *mpt);
+	pr_err("Your mptable is wrong, contact your HW vendor!\n");
+	pr_cont("type %x\n", *mpt);
 	print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
 			1, mpc, mpc->length, 1);
 }
@@ -207,9 +216,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-#ifdef CONFIG_X86_32
-	generic_mps_oem_check(mpc, oem, str);
-#endif
 	/* Initialize the lapic mapping */
 	if (!acpi_lapic)
 		register_lapic_address(mpc->lapic);
@@ -259,7 +265,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	}
 
 	if (!num_processors)
-		printk(KERN_ERR "MPTABLE: no processors registered!\n");
+		pr_err("MPTABLE: no processors registered!\n");
 	return num_processors;
 }
 
@@ -295,16 +301,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	 *  If it does, we assume it's valid.
 	 */
 	if (mpc_default_type == 5) {
-		printk(KERN_INFO "ISA/PCI bus type with no IRQ information... "
-		       "falling back to ELCR\n");
+		pr_info("ISA/PCI bus type with no IRQ information... falling back to ELCR\n");
 
 		if (ELCR_trigger(0) || ELCR_trigger(1) || ELCR_trigger(2) ||
 		    ELCR_trigger(13))
-			printk(KERN_ERR "ELCR contains invalid data... "
-			       "not using ELCR\n");
+			pr_err("ELCR contains invalid data... not using ELCR\n");
 		else {
-			printk(KERN_INFO
-			       "Using ELCR to identify PCI interrupts\n");
+			pr_info("Using ELCR to identify PCI interrupts\n");
 			ELCR_fallback = 1;
 		}
 	}
@@ -353,7 +356,7 @@ static void __init construct_ioapic_table(int mpc_default_type)
 	bus.busid = 0;
 	switch (mpc_default_type) {
 	default:
-		printk(KERN_ERR "???\nUnknown standard configuration %d\n",
+		pr_err("???\nUnknown standard configuration %d\n",
 		       mpc_default_type);
 		/* fall through */
 	case 1:
@@ -462,8 +465,8 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 #ifdef CONFIG_X86_LOCAL_APIC
 		smp_found_config = 0;
 #endif
-		printk(KERN_ERR "BIOS bug, MP table errors detected!...\n"
-			"... disabling SMP support. (tell your hw vendor)\n");
+		pr_err("BIOS bug, MP table errors detected!...\n");
+		pr_cont("... disabling SMP support. (tell your hw vendor)\n");
 		early_iounmap(mpc, size);
 		return -1;
 	}
@@ -481,8 +484,7 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 	if (!mp_irq_entries) {
 		struct mpc_bus bus;
 
-		printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
-		       "using default mptable. (tell your hw vendor)\n");
+		pr_err("BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)\n");
 
 		bus.type = MP_BUS;
 		bus.busid = 0;
@@ -516,14 +518,14 @@ void __init default_get_smp_config(unsigned int early)
 	if (acpi_lapic && acpi_ioapic)
 		return;
 
-	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
-	       mpf->specification);
+	pr_info("Intel MultiProcessor Specification v1.%d\n",
+		mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 	if (mpf->feature2 & (1 << 7)) {
-		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
+		pr_info("    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
 	} else {
-		printk(KERN_INFO "    Virtual Wire compatibility mode.\n");
+		pr_info("    Virtual Wire compatibility mode.\n");
 		pic_mode = 0;
 	}
 #endif
@@ -539,8 +541,7 @@ void __init default_get_smp_config(unsigned int early)
 			return;
 		}
 
-		printk(KERN_INFO "Default MP configuration #%d\n",
-		       mpf->feature1);
+		pr_info("Default MP configuration #%d\n", mpf->feature1);
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
@@ -550,7 +551,7 @@ void __init default_get_smp_config(unsigned int early)
 		BUG();
 
 	if (!early)
-		printk(KERN_INFO "Processors: %d\n", num_processors);
+		pr_info("Processors: %d\n", num_processors);
 	/*
 	 * Only use the first configuration found.
 	 */
@@ -583,10 +584,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 #endif
 			mpf_found = mpf;
 
-			printk(KERN_INFO "found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
-			       (unsigned long long) virt_to_phys(mpf),
-			       (unsigned long long) virt_to_phys(mpf) +
-			       sizeof(*mpf) - 1, mpf);
+			pr_info("found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
+				(unsigned long long) virt_to_phys(mpf),
+				(unsigned long long) virt_to_phys(mpf) +
+				sizeof(*mpf) - 1, mpf);
 
 			mem = virt_to_phys(mpf);
 			memblock_reserve(mem, sizeof(*mpf));
@@ -735,7 +736,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 	int nr_m_spare = 0;
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
-	printk(KERN_INFO "mpc_length %x\n", mpc->length);
+	pr_info("mpc_length %x\n", mpc->length);
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
@@ -862,13 +863,13 @@ static int __init update_mp_table(void)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	printk(KERN_INFO "mpf: %llx\n", (u64)virt_to_phys(mpf));
-	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
+	pr_info("mpf: %llx\n", (u64)virt_to_phys(mpf));
+	pr_info("physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
-		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
-			 mpc_new_length);
+		pr_info("mpc_new_length is %ld, please use alloc_mptable=8k\n",
+			mpc_new_length);
 	}
 
 	if (!mpc_new_phys) {
@@ -879,10 +880,10 @@ static int __init update_mp_table(void)
 		mpc->checksum = 0xff;
 		new = mpf_checksum((unsigned char *)mpc, mpc->length);
 		if (old == new) {
-			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
+			pr_info("mpc is readonly, please try alloc_mptable instead\n");
 			return 0;
 		}
-		printk(KERN_INFO "use in-position replacing\n");
+		pr_info("use in-position replacing\n");
 	} else {
 		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
@@ -892,7 +893,7 @@ static int __init update_mp_table(void)
 		if (mpc_new_phys - mpf->physptr) {
 			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
-			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
+			pr_info("mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
 			memcpy(mpf_new, mpf, 16);
 			mpf = mpf_new;
@@ -900,7 +901,7 @@ static int __init update_mp_table(void)
 		}
 		mpf->checksum = 0;
 		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		printk(KERN_INFO "physptr new: %x\n", mpf->physptr);
+		pr_info("physptr new: %x\n", mpf->physptr);
 	}
 
 	/*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..2d872e0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,10 +168,6 @@ static void smp_callin(void)
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
 	 */
-
-	pr_debug("CALLIN, before setup_local_APIC()\n");
-	if (apic->smp_callin_clear_local_apic)
-		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
 
@@ -1143,10 +1139,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		enable_IO_APIC();
 
 	bsp_end_local_APIC_setup();
-
-	if (apic->setup_portio_remap)
-		apic->setup_portio_remap();
-
 	smpboot_setup_io_apic();
 	/*
 	 * Set up local APIC timer on boot CPU.
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index b99b9ad..ee22c1d 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -152,7 +152,7 @@ static void __init detect_vsmp_box(void)
 		is_vsmp = 1;
 }
 
-int is_vsmp_box(void)
+static int is_vsmp_box(void)
 {
 	if (is_vsmp != -1)
 		return is_vsmp;
@@ -166,7 +166,7 @@ int is_vsmp_box(void)
 static void __init detect_vsmp_box(void)
 {
 }
-int is_vsmp_box(void)
+static int is_vsmp_box(void)
 {
 	return 0;
 }
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 5075371..cfd1b13 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -448,7 +448,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
 		return;
 
 	size = sizeof(*info->res) * info->res_num;
-	info->res = kzalloc(size, GFP_KERNEL);
+	info->res = kzalloc_node(size, GFP_KERNEL, info->sd.node);
 	if (!info->res) {
 		info->res_num = 0;
 		return;
@@ -456,7 +456,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
 
 	size = sizeof(*info->res_offset) * info->res_num;
 	info->res_num = 0;
-	info->res_offset = kzalloc(size, GFP_KERNEL);
+	info->res_offset = kzalloc_node(size, GFP_KERNEL, info->sd.node);
 	if (!info->res_offset) {
 		kfree(info->res);
 		info->res = NULL;
@@ -499,7 +499,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (node != NUMA_NO_NODE && !node_online(node))
 		node = NUMA_NO_NODE;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc_node(sizeof(*info), GFP_KERNEL, node);
 	if (!info) {
 		printk(KERN_WARNING "pci_bus %04x:%02x: "
 		       "ignored (out of memory)\n", domain, busnum);
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 84b9d67..09fece3 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -208,27 +208,31 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 
 static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 {
-	u8 pin;
-	struct io_apic_irq_attr irq_attr;
+	int polarity;
 
-	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
+		polarity = 0; /* active high */
+	else
+		polarity = 1; /* active low */
 
 	/*
 	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
 	 * IOAPIC RTE entries, so we just enable RTE for the device.
 	 */
-	irq_attr.ioapic = mp_find_ioapic(dev->irq);
-	irq_attr.ioapic_pin = dev->irq;
-	irq_attr.trigger = 1; /* level */
-	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
-		irq_attr.polarity = 0; /* active high */
-	else
-		irq_attr.polarity = 1; /* active low */
-	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
+	if (mp_set_gsi_attr(dev->irq, 1, polarity, dev_to_node(&dev->dev)))
+		return -EBUSY;
+	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
+		return -EBUSY;
 
 	return 0;
 }
 
+static void intel_mid_pci_irq_disable(struct pci_dev *dev)
+{
+	if (dev->irq > 0)
+		mp_unmap_irq(dev->irq);
+}
+
 struct pci_ops intel_mid_pci_ops = {
 	.read = pci_read,
 	.write = pci_write,
@@ -245,6 +249,7 @@ int __init intel_mid_pci_init(void)
 	pr_info("Intel MID platform detected, using MID PCI ops\n");
 	pci_mmcfg_late_init();
 	pcibios_enable_irq = intel_mid_pci_irq_enable;
+	pcibios_disable_irq = intel_mid_pci_irq_disable;
 	pci_root_ops = intel_mid_pci_ops;
 	pci_soc_mode = 1;
 	/* Continue with standard init */
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 84112f5..748cfe8 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -26,6 +26,7 @@ static int acer_tm360_irqrouting;
 static struct irq_routing_table *pirq_table;
 
 static int pirq_enable_irq(struct pci_dev *dev);
+static void pirq_disable_irq(struct pci_dev *dev);
 
 /*
  * Never use: 0, 1, 2 (timer, keyboard, and cascade)
@@ -53,7 +54,7 @@ struct irq_router_handler {
 };
 
 int (*pcibios_enable_irq)(struct pci_dev *dev) = pirq_enable_irq;
-void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
+void (*pcibios_disable_irq)(struct pci_dev *dev) = pirq_disable_irq;
 
 /*
  *  Check passed address for the PCI IRQ Routing Table signature
@@ -1186,7 +1187,7 @@ void pcibios_penalize_isa_irq(int irq, int active)
 
 static int pirq_enable_irq(struct pci_dev *dev)
 {
-	u8 pin;
+	u8 pin = 0;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin && !pcibios_lookup_irq(dev, 1)) {
@@ -1227,8 +1228,6 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				io_apic_set_pci_routing(&dev->dev, irq,
-							 &irq_attr);
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
@@ -1254,3 +1253,11 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	}
 	return 0;
 }
+
+static void pirq_disable_irq(struct pci_dev *dev)
+{
+	if (io_apic_assign_pci_irqs && dev->irq) {
+		mp_unmap_irq(dev->irq);
+		dev->irq = 0;
+	}
+}
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f..093f5f4 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -23,6 +23,7 @@
 #include <xen/features.h>
 #include <xen/events.h>
 #include <asm/xen/pci.h>
+#include <asm/i8259.h>
 
 static int xen_pcifront_enable_irq(struct pci_dev *dev)
 {
@@ -40,7 +41,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	/* In PV DomU the Xen PCI backend puts the PIRQ in the interrupt line.*/
 	pirq = gsi;
 
-	if (gsi < NR_IRQS_LEGACY)
+	if (gsi < nr_legacy_irqs())
 		share = 0;
 
 	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
@@ -511,7 +512,7 @@ int __init pci_xen_initial_domain(void)
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 	/* Pre-allocate legacy irqs */
-	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+	for (irq = 0; irq < nr_legacy_irqs(); irq++) {
 		int trigger, polarity;
 
 		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
@@ -522,7 +523,7 @@ int __init pci_xen_initial_domain(void)
 			true /* Map GSI to PIRQ */);
 	}
 	if (0 == nr_ioapics) {
-		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+		for (irq = 0; irq < nr_legacy_irqs(); irq++)
 			xen_bind_pirq_gsi_to_irq(irq, irq, 0, "xt-pic");
 	}
 	return 0;
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 8244f5e..701fd58 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -135,14 +135,10 @@ static void __init sdv_arch_setup(void)
 	sdv_serial_fixup();
 }
 
-#ifdef CONFIG_X86_IO_APIC
 static void sdv_pci_init(void)
 {
 	x86_of_pci_init();
-	/* We can't set this earlier, because we need to calibrate the timer */
-	legacy_pic = &null_legacy_pic;
 }
-#endif
 
 /*
  * CE4100 specific x86_init function overrides and early setup
@@ -155,7 +151,9 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 	x86_init.pci.init = ce4100_pci_init;
+	x86_init.pci.init_irq = sdv_pci_init;
 
 	/*
 	 * By default, the reboot method is ACPI which is supported by the
@@ -166,10 +164,5 @@ void __init x86_ce4100_early_setup(void)
 	 */
 	reboot_type = BOOT_KBD;
 
-#ifdef CONFIG_X86_IO_APIC
-	x86_init.pci.init_irq = sdv_pci_init;
-	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
-#endif
-
 	pm_power_off = ce4100_power_off;
 }
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
index 973cf3b..0b283d4 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -26,28 +26,18 @@ static struct platform_device wdt_dev = {
 
 static int tangier_probe(struct platform_device *pdev)
 {
-	int ioapic;
-	int irq;
+	int gsi;
 	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
-	struct io_apic_irq_attr irq_attr = { 0 };
 
 	if (!pdata)
 		return -EINVAL;
 
-	irq = pdata->irq;
-	ioapic = mp_find_ioapic(irq);
-	if (ioapic >= 0) {
-		int ret;
-		irq_attr.ioapic = ioapic;
-		irq_attr.ioapic_pin = irq;
-		irq_attr.trigger = 1;
-		/* irq_attr.polarity = 0; -> Active high */
-		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
-		if (ret)
-			return ret;
-	} else {
+	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
+	gsi = pdata->irq;
+	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
+	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC) <= 0) {
 		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
-			 irq);
+			 gsi);
 		return -EINVAL;
 	}
 
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 994c40b..3c53a90 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -432,9 +432,8 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 	struct sfi_table_simple *sb;
 	struct sfi_device_table_entry *pentry;
 	struct devs_id *dev = NULL;
-	int num, i;
-	int ioapic;
-	struct io_apic_irq_attr irq_attr;
+	int num, i, ret;
+	int polarity;
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
@@ -448,35 +447,30 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			 * devices, but they have separate RTE entry in IOAPIC
 			 * so we have to enable them one by one here
 			 */
-			ioapic = mp_find_ioapic(irq);
-			if (ioapic >= 0) {
-				irq_attr.ioapic = ioapic;
-				irq_attr.ioapic_pin = irq;
-				irq_attr.trigger = 1;
-				if (intel_mid_identify_cpu() ==
-						INTEL_MID_CPU_CHIP_TANGIER) {
-					if (!strncmp(pentry->name,
-							"r69001-ts-i2c", 13))
-						/* active low */
-						irq_attr.polarity = 1;
-					else if (!strncmp(pentry->name,
-							"synaptics_3202", 14))
-						/* active low */
-						irq_attr.polarity = 1;
-					else if (irq == 41)
-						/* fast_int_1 */
-						irq_attr.polarity = 1;
-					else
-						/* active high */
-						irq_attr.polarity = 0;
-				} else {
-					/* PNW and CLV go with active low */
-					irq_attr.polarity = 1;
-				}
-				io_apic_set_pci_routing(NULL, irq, &irq_attr);
+			if (intel_mid_identify_cpu() ==
+					INTEL_MID_CPU_CHIP_TANGIER) {
+				if (!strncmp(pentry->name, "r69001-ts-i2c", 13))
+					/* active low */
+					polarity = 1;
+				else if (!strncmp(pentry->name,
+						"synaptics_3202", 14))
+					/* active low */
+					polarity = 1;
+				else if (irq == 41)
+					/* fast_int_1 */
+					polarity = 1;
+				else
+					/* active high */
+					polarity = 0;
+			} else {
+				/* PNW and CLV go with active low */
+				polarity = 1;
 			}
-		} else {
-			irq = 0; /* No irq */
+
+			ret = mp_set_gsi_attr(irq, 1, polarity, NUMA_NO_NODE);
+			if (ret == 0)
+				ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC);
+			WARN_ON(ret < 0);
 		}
 
 		dev = get_device_id(pentry->type, pentry->name);
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index bcd1a70..2a8a74f 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/sfi.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 
 #include <asm/io_apic.h>
 #include <asm/mpspec.h>
@@ -70,19 +71,26 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
+static struct irq_domain_ops sfi_ioapic_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_apic_table_entry *pentry;
 	int i, num;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_STRICT,
+		.ops = &sfi_ioapic_irqdomain_ops,
+	};
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_apic_table_entry);
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top, &cfg);
 		pentry++;
 	}
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 9c62340..6ba463c 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -498,5 +498,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	acpi_unregister_gsi(gsi);
+	if (gsi >= 0 && dev->irq > 0)
+		acpi_unregister_gsi(gsi);
 }
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed1..b0f9d16 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -172,6 +172,8 @@ extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
 extern void irq_domain_associate_many(struct irq_domain *domain,
 				      unsigned int irq_base,
 				      irq_hw_number_t hwirq_base, int count);
+extern void irq_domain_disassociate(struct irq_domain *domain,
+				    unsigned int irq);
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index eb5e10e..6534ff6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -231,7 +231,7 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 	irq_hw_number_t hwirq;
