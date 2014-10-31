Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaJaRu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:50:58 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:49700 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750771AbaJaRu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:50:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:69:327:334:355:379:541:960:966:973:981:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2828:2897:2898:2899:2901:2902:3138:3139:3140:3141:3142:3165:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:4385:4395:4423:4605:5007:6248:6261:6630:7875:7903:7904:8531:8603:8957:9389:10004:10848:11026:11232:11233:11657:11914:12043:12296:12438:12517:12519:12555:12679:12683:13019:13153:13228:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime30_7c10752358837
X-Filterd-Recvd-Size: 47031
Message-ID: <1414777846.13647.3.camel@perches.com>
Subject: [PATCH] tile: Use the more common pr_warn instead of pr_warning
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 10:50:46 -0700
In-Reply-To: <5453946F.3030803@tilera.com>
References: <cover.1414691783.git.joe@perches.com>
	 <5453946F.3030803@tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And other message logging neatening.

Other miscellanea:

o coalesce formats
o realign arguments
o standardize a couple of macros
o use __func__ instead of embedding the function name

Signed-off-by: Joe Perches <joe@perches.com>
---
In reply to the early_vprintk removal stuff Chris wrote:
> You can put my Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> on this series.  Looks like akpm is taking it into -mm so I won't bother to take it into the tile tree.

Hey Chris.

If you want, here are a few more neatenings of the
logging bits of tile on top of those patches.

(uncompiled so untested too)

 arch/tile/include/asm/io.h         |  5 +-
 arch/tile/include/asm/pgtable.h    |  4 +-
 arch/tile/include/asm/pgtable_64.h |  2 +-
 arch/tile/kernel/hardwall.c        |  6 +--
 arch/tile/kernel/irq.c             |  5 +-
 arch/tile/kernel/kprobes.c         |  3 +-
 arch/tile/kernel/machine_kexec.c   | 28 +++++------
 arch/tile/kernel/messaging.c       |  5 +-
 arch/tile/kernel/module.c          | 12 ++---
 arch/tile/kernel/pci.c             |  7 ++-
 arch/tile/kernel/pci_gx.c          | 95 ++++++++++++++++----------------------
 arch/tile/kernel/process.c         | 16 +++----
 arch/tile/kernel/setup.c           | 36 +++++++--------
 arch/tile/kernel/signal.c          |  6 +--
 arch/tile/kernel/single_step.c     |  6 +--
 arch/tile/kernel/smpboot.c         |  5 +-
 arch/tile/kernel/stack.c           |  7 +--
 arch/tile/kernel/time.c            |  4 +-
 arch/tile/kernel/traps.c           | 10 ++--
 arch/tile/kernel/unaligned.c       | 22 ++++-----
 arch/tile/mm/fault.c               | 34 ++++++--------
 arch/tile/mm/homecache.c           |  6 +--
 arch/tile/mm/hugetlbpage.c         | 18 ++++----
 arch/tile/mm/init.c                | 32 ++++++-------
 arch/tile/mm/pgtable.c             |  4 +-
 25 files changed, 158 insertions(+), 220 deletions(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 9fe4349..4353539 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -392,8 +392,7 @@ extern void ioport_unmap(void __iomem *addr);
 static inline long ioport_panic(void)
 {
 #ifdef __tilegx__
-	panic("PCI IO space support is disabled. Configure the kernel with"
-	      " CONFIG_TILE_PCI_IO to enable it");
+	panic("PCI IO space support is disabled. Configure the kernel with CONFIG_TILE_PCI_IO to enable it");
 #else
 	panic("inb/outb and friends do not exist on tile");
 #endif
@@ -402,7 +401,7 @@ static inline long ioport_panic(void)
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
 {
-	pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
+	pr_info("ioport_map: mapping IO resources is unsupported on tile\n");
 	return NULL;
 }
 
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index 33587f1..5d19507 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -235,9 +235,9 @@ static inline void __pte_clear(pte_t *ptep)
 #define pte_donemigrate(x) hv_pte_set_present(hv_pte_clear_migrating(x))
 
 #define pte_ERROR(e) \
-	pr_err("%s:%d: bad pte 0x%016llx.\n", __FILE__, __LINE__, pte_val(e))
+	pr_err("%s:%d: bad pte 0x%016llx\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
-	pr_err("%s:%d: bad pgd 0x%016llx.\n", __FILE__, __LINE__, pgd_val(e))
+	pr_err("%s:%d: bad pgd 0x%016llx\n", __FILE__, __LINE__, pgd_val(e))
 
 /* Return PA and protection info for a given kernel VA. */
 int va_to_cpa_and_pte(void *va, phys_addr_t *cpa, pte_t *pte);
diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
index 2c8a9cd..e96cec5 100644
--- a/arch/tile/include/asm/pgtable_64.h
+++ b/arch/tile/include/asm/pgtable_64.h
@@ -86,7 +86,7 @@ static inline int pud_huge_page(pud_t pud)
 }
 
 #define pmd_ERROR(e) \
-	pr_err("%s:%d: bad pmd 0x%016llx.\n", __FILE__, __LINE__, pmd_val(e))
+	pr_err("%s:%d: bad pmd 0x%016llx\n", __FILE__, __LINE__, pmd_val(e))
 
 static inline void pud_clear(pud_t *pudp)
 {
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index aca6000..c4646bb 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -365,8 +365,7 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 	 * to quiesce.
 	 */
 	if (rect->teardown_in_progress) {
-		pr_notice("cpu %d: detected %s hardwall violation %#lx"
-		       " while teardown already in progress\n",
+		pr_notice("cpu %d: detected %s hardwall violation %#lx while teardown already in progress\n",
 			  cpu, hwt->name,
 			  (long)mfspr_XDN(hwt, DIRECTION_PROTECT));
 		goto done;
@@ -630,8 +629,7 @@ static void _hardwall_deactivate(struct hardwall_type *hwt,
 	struct thread_struct *ts = &task->thread;
 
 	if (cpumask_weight(&task->cpus_allowed) != 1) {
-		pr_err("pid %d (%s) releasing %s hardwall with"
-		       " an affinity mask containing %d cpus!\n",
+		pr_err("pid %d (%s) releasing %s hardwall with an affinity mask containing %d cpus!\n",
 		       task->pid, task->comm, hwt->name,
 		       cpumask_weight(&task->cpus_allowed));
 		BUG();
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index ba85765..22044fc 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -107,9 +107,8 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 	{
 		long sp = stack_pointer - (long) current_thread_info();
 		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			pr_emerg("tile_dev_intr: "
-			       "stack overflow: %ld\n",
-			       sp - sizeof(struct thread_info));
+			pr_emerg("%s: stack overflow: %ld\n",
+				 __func__, sp - sizeof(struct thread_info));
 			dump_stack();
 		}
 	}
diff --git a/arch/tile/kernel/kprobes.c b/arch/tile/kernel/kprobes.c
index 27cdcac..f8a45c5 100644
--- a/arch/tile/kernel/kprobes.c
+++ b/arch/tile/kernel/kprobes.c
@@ -90,8 +90,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		return -EINVAL;
 
 	if (insn_has_control(*p->addr)) {
-		pr_notice("Kprobes for control instructions are not "
-			  "supported\n");
+		pr_notice("Kprobes for control instructions are not supported\n");
 		return -EINVAL;
 	}
 
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index f0b54a9..008aa2f 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -77,16 +77,13 @@ void machine_crash_shutdown(struct pt_regs *regs)
 int machine_kexec_prepare(struct kimage *image)
 {
 	if (num_online_cpus() > 1) {
-		pr_warning("%s: detected attempt to kexec "
-		       "with num_online_cpus() > 1\n",
-		       __func__);
+		pr_warn("%s: detected attempt to kexec with num_online_cpus() > 1\n",
+			__func__);
 		return -ENOSYS;
 	}
 	if (image->type != KEXEC_TYPE_DEFAULT) {
-		pr_warning("%s: detected attempt to kexec "
-		       "with unsupported type: %d\n",
-		       __func__,
-		       image->type);
+		pr_warn("%s: detected attempt to kexec with unsupported type: %d\n",
+			__func__, image->type);
 		return -ENOSYS;
 	}
 	return 0;
@@ -131,8 +128,8 @@ static unsigned char *kexec_bn2cl(void *pg)
 	 */
 	csum = ip_compute_csum(pg, bhdrp->b_size);
 	if (csum != 0) {
-		pr_warning("%s: bad checksum %#x (size %d)\n",
-			   __func__, csum, bhdrp->b_size);
+		pr_warn("%s: bad checksum %#x (size %d)\n",
+			__func__, csum, bhdrp->b_size);
 		return 0;
 	}
 
@@ -160,8 +157,7 @@ static unsigned char *kexec_bn2cl(void *pg)
 	while (*desc != '\0') {
 		desc++;
 		if (((unsigned long)desc & PAGE_MASK) != (unsigned long)pg) {
-			pr_info("%s: ran off end of page\n",
-			       __func__);
+			pr_info("%s: ran off end of page\n", __func__);
 			return 0;
 		}
 	}
@@ -195,20 +191,18 @@ static void kexec_find_and_set_command_line(struct kimage *image)
 	}
 
 	if (command_line != 0) {
-		pr_info("setting new command line to \"%s\"\n",
-		       command_line);
+		pr_info("setting new command line to \"%s\"\n", command_line);
 
 		hverr = hv_set_command_line(
 			(HV_VirtAddr) command_line, strlen(command_line));
 		kunmap_atomic(command_line);
 	} else {
-		pr_info("%s: no command line found; making empty\n",
-		       __func__);
+		pr_info("%s: no command line found; making empty\n", __func__);
 		hverr = hv_set_command_line((HV_VirtAddr) command_line, 0);
 	}
 	if (hverr)
-		pr_warning("%s: hv_set_command_line returned error: %d\n",
-			   __func__, hverr);
+		pr_warn("%s: hv_set_command_line returned error: %d\n",
+			__func__, hverr);
 }
 
 /*
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
index ac950be..7475af3 100644
--- a/arch/tile/kernel/messaging.c
+++ b/arch/tile/kernel/messaging.c
@@ -59,9 +59,8 @@ void hv_message_intr(struct pt_regs *regs, int intnum)
 	{
 		long sp = stack_pointer - (long) current_thread_info();
 		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			pr_emerg("hv_message_intr: "
-			       "stack overflow: %ld\n",
-			       sp - sizeof(struct thread_info));
+			pr_emerg("%s: stack overflow: %ld\n",
+				 __func__, sp - sizeof(struct thread_info));
 			dump_stack();
 		}
 	}
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index d19b13e..96447c9 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -96,8 +96,8 @@ void module_free(struct module *mod, void *module_region)
 static int validate_hw2_last(long value, struct module *me)
 {
 	if (((value << 16) >> 16) != value) {
-		pr_warning("module %s: Out of range HW2_LAST value %#lx\n",
-			   me->name, value);
+		pr_warn("module %s: Out of range HW2_LAST value %#lx\n",
+			me->name, value);
 		return 0;
 	}
 	return 1;
@@ -210,10 +210,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			value -= (unsigned long) location;  /* pc-relative */
 			value = (long) value >> 3;     /* count by instrs */
 			if (!validate_jumpoff(value)) {
-				pr_warning("module %s: Out of range jump to"
-					   " %#llx at %#llx (%p)\n", me->name,
-					   sym->st_value + rel[i].r_addend,
-					   rel[i].r_offset, location);
+				pr_warn("module %s: Out of range jump to %#llx at %#llx (%p)\n",
+					me->name,
+					sym->st_value + rel[i].r_addend,
+					rel[i].r_offset, location);
 				return -ENOEXEC;
 			}
 			MUNGE(create_JumpOff_X1);
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 1f80a88..f70c789 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -178,8 +178,8 @@ int __init tile_pci_init(void)
 				continue;
 			hv_cfg_fd1 = tile_pcie_open(i, 1);
 			if (hv_cfg_fd1 < 0) {
-				pr_err("PCI: Couldn't open config fd to HV "
-				    "for controller %d\n", i);
+				pr_err("PCI: Couldn't open config fd to HV for controller %d\n",
+				       i);
 				goto err_cont;
 			}
 
@@ -423,8 +423,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 		for (i = 0; i < 6; i++) {
 			r = &dev->resource[i];
 			if (r->flags & IORESOURCE_UNSET) {
-				pr_err("PCI: Device %s not available "
-				       "because of resource collisions\n",
+				pr_err("PCI: Device %s not available because of resource collisions\n",
 				       pci_name(dev));
 				return -EINVAL;
 			}
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index e39f9c5..47e048e 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -131,8 +131,7 @@ static int tile_irq_cpu(int irq)
 
 	count = cpumask_weight(&intr_cpus_map);
 	if (unlikely(count == 0)) {
-		pr_warning("intr_cpus_map empty, interrupts will be"
-			   " delievered to dataplane tiles\n");
+		pr_warn("intr_cpus_map empty, interrupts will be delievered to dataplane tiles\n");
 		return irq % (smp_height * smp_width);
 	}
 
@@ -197,16 +196,16 @@ static int tile_pcie_open(int trio_index)
 	/* Get the properties of the PCIe ports on this TRIO instance. */
 	ret = gxio_trio_get_port_property(context, &pcie_ports[trio_index]);
 	if (ret < 0) {
-		pr_err("PCI: PCIE_GET_PORT_PROPERTY failure, error %d,"
-		       " on TRIO %d\n", ret, trio_index);
+		pr_err("PCI: PCIE_GET_PORT_PROPERTY failure, error %d, on TRIO %d\n",
+		       ret, trio_index);
 		goto get_port_property_failure;
 	}
 
 	context->mmio_base_mac =
 		iorpc_ioremap(context->fd, 0, HV_TRIO_CONFIG_IOREMAP_SIZE);
 	if (context->mmio_base_mac == NULL) {
-		pr_err("PCI: TRIO config space mapping failure, error %d,"
-		       " on TRIO %d\n", ret, trio_index);
+		pr_err("PCI: TRIO config space mapping failure, error %d, on TRIO %d\n",
+		       ret, trio_index);
 		ret = -ENOMEM;
 
 		goto trio_mmio_mapping_failure;
@@ -622,9 +621,8 @@ static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 				    dev_control.max_read_req_sz,
 				    mac);
 	if (err < 0) {
-		pr_err("PCI: PCIE_CONFIGURE_MAC_MPS_MRS failure, "
-			"MAC %d on TRIO %d\n",
-			mac, controller->trio_index);
+		pr_err("PCI: PCIE_CONFIGURE_MAC_MPS_MRS failure, MAC %d on TRIO %d\n",
+		       mac, controller->trio_index);
 	}
 }
 
@@ -720,27 +718,24 @@ int __init pcibios_init(void)
 					 reg_offset);
 		if (!port_status.dl_up) {
 			if (rc_delay[trio_index][mac]) {
-				pr_info("Delaying PCIe RC TRIO init %d sec"
-					" on MAC %d on TRIO %d\n",
+				pr_info("Delaying PCIe RC TRIO init %d sec on MAC %d on TRIO %d\n",
 					rc_delay[trio_index][mac], mac,
 					trio_index);
 				msleep(rc_delay[trio_index][mac] * 1000);
 			}
 			ret = gxio_trio_force_rc_link_up(trio_context, mac);
 			if (ret < 0)
-				pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
-					"MAC %d on TRIO %d\n", mac, trio_index);
+				pr_err("PCI: PCIE_FORCE_LINK_UP failure, MAC %d on TRIO %d\n",
+				       mac, trio_index);
 		}
 
-		pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n", i,
-			trio_index, controller->mac);
+		pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n",
+			i, trio_index, controller->mac);
 
 		/* Delay the bus probe if needed. */
 		if (rc_delay[trio_index][mac]) {
-			pr_info("Delaying PCIe RC bus enumerating %d sec"
-				" on MAC %d on TRIO %d\n",
-				rc_delay[trio_index][mac], mac,
-				trio_index);
+			pr_info("Delaying PCIe RC bus enumerating %d sec on MAC %d on TRIO %d\n",
+				rc_delay[trio_index][mac], mac, trio_index);
 			msleep(rc_delay[trio_index][mac] * 1000);
 		} else {
 			/*
@@ -758,11 +753,10 @@ int __init pcibios_init(void)
 			if (pcie_ports[trio_index].ports[mac].removable) {
 				pr_info("PCI: link is down, MAC %d on TRIO %d\n",
 					mac, trio_index);
-				pr_info("This is expected if no PCIe card"
-					" is connected to this link\n");
+				pr_info("This is expected if no PCIe card is connected to this link\n");
 			} else
 				pr_err("PCI: link is down, MAC %d on TRIO %d\n",
-					mac, trio_index);
+				       mac, trio_index);
 			continue;
 		}
 
@@ -829,8 +823,8 @@ int __init pcibios_init(void)
 		/* Alloc a PIO region for PCI config access per MAC. */
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
-			pr_err("PCI: PCI CFG PIO alloc failure for mac %d "
-				"on TRIO %d, give up\n", mac, trio_index);
+			pr_err("PCI: PCI CFG PIO alloc failure for mac %d on TRIO %d, give up\n",
+			       mac, trio_index);
 
 			continue;
 		}
@@ -842,8 +836,8 @@ int __init pcibios_init(void)
 			trio_context->pio_cfg_index[mac],
 			mac, 0, HV_TRIO_PIO_FLAG_CONFIG_SPACE);
 		if (ret < 0) {
-			pr_err("PCI: PCI CFG PIO init failure for mac %d "
-				"on TRIO %d, give up\n", mac, trio_index);
+			pr_err("PCI: PCI CFG PIO init failure for mac %d on TRIO %d, give up\n",
+			       mac, trio_index);
 
 			continue;
 		}
@@ -865,7 +859,7 @@ int __init pcibios_init(void)
 			(TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT - 1)));
 		if (trio_context->mmio_base_pio_cfg[mac] == NULL) {
 			pr_err("PCI: PIO map failure for mac %d on TRIO %d\n",
-				mac, trio_index);
+			       mac, trio_index);
 
 			continue;
 		}
@@ -925,9 +919,8 @@ int __init pcibios_init(void)
 		/* Alloc a PIO region for PCI memory access for each RC port. */
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
-			pr_err("PCI: MEM PIO alloc failure on TRIO %d mac %d, "
-			       "give up\n", controller->trio_index,
-			       controller->mac);
+			pr_err("PCI: MEM PIO alloc failure on TRIO %d mac %d, give up\n",
+			       controller->trio_index, controller->mac);
 
 			continue;
 		}
@@ -944,9 +937,8 @@ int __init pcibios_init(void)
 						    0,
 						    0);
 		if (ret < 0) {
-			pr_err("PCI: MEM PIO init failure on TRIO %d mac %d, "
-			       "give up\n", controller->trio_index,
-			       controller->mac);
+			pr_err("PCI: MEM PIO init failure on TRIO %d mac %d, give up\n",
+			       controller->trio_index, controller->mac);
 
 			continue;
 		}
@@ -957,9 +949,8 @@ int __init pcibios_init(void)
 		 */
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
-			pr_err("PCI: I/O PIO alloc failure on TRIO %d mac %d, "
-			       "give up\n", controller->trio_index,
-			       controller->mac);
+			pr_err("PCI: I/O PIO alloc failure on TRIO %d mac %d, give up\n",
+			       controller->trio_index, controller->mac);
 
 			continue;
 		}
@@ -976,9 +967,8 @@ int __init pcibios_init(void)
 						    0,
 						    HV_TRIO_PIO_FLAG_IO_SPACE);
 		if (ret < 0) {
-			pr_err("PCI: I/O PIO init failure on TRIO %d mac %d, "
-			       "give up\n", controller->trio_index,
-			       controller->mac);
+			pr_err("PCI: I/O PIO init failure on TRIO %d mac %d, give up\n",
+			       controller->trio_index, controller->mac);
 
 			continue;
 		}
@@ -997,10 +987,9 @@ int __init pcibios_init(void)
 			ret = gxio_trio_alloc_memory_maps(trio_context, 1, 0,
 							  0);
 			if (ret < 0) {
-				pr_err("PCI: Mem-Map alloc failure on TRIO %d "
-				       "mac %d for MC %d, give up\n",
-				       controller->trio_index,
-				       controller->mac, j);
+				pr_err("PCI: Mem-Map alloc failure on TRIO %d mac %d for MC %d, give up\n",
+				       controller->trio_index, controller->mac,
+				       j);
 
 				goto alloc_mem_map_failed;
 			}
@@ -1030,10 +1019,9 @@ int __init pcibios_init(void)
 				j,
 				GXIO_TRIO_ORDER_MODE_UNORDERED);
 			if (ret < 0) {
-				pr_err("PCI: Mem-Map init failure on TRIO %d "
-				       "mac %d for MC %d, give up\n",
-				       controller->trio_index,
-				       controller->mac, j);
+				pr_err("PCI: Mem-Map init failure on TRIO %d mac %d for MC %d, give up\n",
+				       controller->trio_index, controller->mac,
+				       j);
 
 				goto alloc_mem_map_failed;
 			}
@@ -1510,9 +1498,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	 * Most PCIe endpoint devices do support 64-bit message addressing.
 	 */
 	if (desc->msi_attrib.is_64 == 0) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			"64-bit MSI message address not supported, "
-			"falling back to legacy interrupts.\n");
+		dev_info(&pdev->dev, "64-bit MSI message address not supported, falling back to legacy interrupts\n");
 
 		ret = -ENOMEM;
 		goto is_64_failure;
@@ -1549,11 +1535,8 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 		/* SQ regions are out, allocate from map mem regions. */
 		mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
 		if (mem_map < 0) {
-			dev_printk(KERN_INFO, &pdev->dev,
-				"%s Mem-Map alloc failure. "
-				"Failed to initialize MSI interrupts. "
-				"Falling back to legacy interrupts.\n",
-				desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
+			dev_info(&pdev->dev, "%s Mem-Map alloc failure - failed to initialize MSI interrupts - falling back to legacy interrupts\n",
+				 desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
 			ret = -ENOMEM;
 			goto msi_mem_map_alloc_failure;
 		}
@@ -1580,7 +1563,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 					mem_map, mem_map_base, mem_map_limit,
 					trio_context->asid);
 	if (ret < 0) {
-		dev_printk(KERN_INFO, &pdev->dev, "HV MSI config failed.\n");
+		dev_info(&pdev->dev, "HV MSI config failed\n");
 
 		goto hv_msi_config_failure;
 	}
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 0050cbc..48e5773 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -52,7 +52,7 @@ static int __init idle_setup(char *str)
 		return -EINVAL;
 
 	if (!strcmp(str, "poll")) {
-		pr_info("using polling idle threads.\n");
+		pr_info("using polling idle threads\n");
 		cpu_idle_poll_ctrl(true);
 		return 0;
 	} else if (!strcmp(str, "halt")) {
@@ -547,27 +547,25 @@ void show_regs(struct pt_regs *regs)
 	struct task_struct *tsk = validate_current();
 	int i;
 
-	pr_err("\n");
 	if (tsk != &corrupt_current)
 		show_regs_print_info(KERN_ERR);
 #ifdef __tilegx__
 	for (i = 0; i < 17; i++)
-		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
+		pr_err(" r%-2d: " REGFMT " r%-2d: " REGFMT " r%-2d: " REGFMT "\n",
 		       i, regs->regs[i], i+18, regs->regs[i+18],
 		       i+36, regs->regs[i+36]);
-	pr_err(" r17: "REGFMT" r35: "REGFMT" tp : "REGFMT"\n",
+	pr_err(" r17: " REGFMT " r35: " REGFMT " tp : " REGFMT "\n",
 	       regs->regs[17], regs->regs[35], regs->tp);
-	pr_err(" sp : "REGFMT" lr : "REGFMT"\n", regs->sp, regs->lr);
+	pr_err(" sp : " REGFMT " lr : " REGFMT "\n", regs->sp, regs->lr);
 #else
 	for (i = 0; i < 13; i++)
-		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT
-		       " r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
+		pr_err(" r%-2d: " REGFMT " r%-2d: " REGFMT " r%-2d: " REGFMT " r%-2d: " REGFMT "\n",
 		       i, regs->regs[i], i+14, regs->regs[i+14],
 		       i+27, regs->regs[i+27], i+40, regs->regs[i+40]);
-	pr_err(" r13: "REGFMT" tp : "REGFMT" sp : "REGFMT" lr : "REGFMT"\n",
+	pr_err(" r13: " REGFMT " tp : " REGFMT " sp : " REGFMT " lr : " REGFMT "\n",
 	       regs->regs[13], regs->tp, regs->sp, regs->lr);
 #endif
-	pr_err(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
+	pr_err(" pc : " REGFMT " ex1: %ld     faultnum: %ld\n",
 	       regs->pc, regs->ex1, regs->faultnum);
 
 	dump_stack_regs(regs);
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 7f079bb..864eea6 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -130,7 +130,7 @@ static int __init setup_maxmem(char *str)
 
 	maxmem_pfn = (maxmem >> HPAGE_SHIFT) << (HPAGE_SHIFT - PAGE_SHIFT);
 	pr_info("Forcing RAM used to no more than %dMB\n",
-	       maxmem_pfn >> (20 - PAGE_SHIFT));
+		maxmem_pfn >> (20 - PAGE_SHIFT));
 	return 0;
 }
 early_param("maxmem", setup_maxmem);
@@ -149,7 +149,7 @@ static int __init setup_maxnodemem(char *str)
 	maxnodemem_pfn[node] = (maxnodemem >> HPAGE_SHIFT) <<
 		(HPAGE_SHIFT - PAGE_SHIFT);
 	pr_info("Forcing RAM used on node %ld to no more than %dMB\n",
-	       node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
+		node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
 	return 0;
 }
 early_param("maxnodemem", setup_maxnodemem);
@@ -417,8 +417,7 @@ static void __init setup_memory(void)
 			range.start = (start_pa + HPAGE_SIZE - 1) & HPAGE_MASK;
 			range.size -= (range.start - start_pa);
 			range.size &= HPAGE_MASK;
-			pr_err("Range not hugepage-aligned: %#llx..%#llx:"
-			       " now %#llx-%#llx\n",
+			pr_err("Range not hugepage-aligned: %#llx..%#llx: now %#llx-%#llx\n",
 			       start_pa, start_pa + orig_size,
 			       range.start, range.start + range.size);
 		}
@@ -437,8 +436,8 @@ static void __init setup_memory(void)
 		if (PFN_DOWN(range.size) > maxnodemem_pfn[i]) {
 			int max_size = maxnodemem_pfn[i];
 			if (max_size > 0) {
-				pr_err("Maxnodemem reduced node %d to"
-				       " %d pages\n", i, max_size);
+				pr_err("Maxnodemem reduced node %d to %d pages\n",
+				       i, max_size);
 				range.size = PFN_PHYS(max_size);
 			} else {
 				pr_err("Maxnodemem disabled node %d\n", i);
@@ -490,8 +489,8 @@ static void __init setup_memory(void)
 				NR_CPUS * (PFN_UP(per_cpu_size) >> PAGE_SHIFT);
 			if (end < pci_reserve_end_pfn + percpu_pages) {
 				end = pci_reserve_start_pfn;
-				pr_err("PCI mapping region reduced node %d to"
-				       " %ld pages\n", i, end - start);
+				pr_err("PCI mapping region reduced node %d to %ld pages\n",
+				       i, end - start);
 			}
 		}
 #endif
@@ -555,10 +554,9 @@ static void __init setup_memory(void)
 		MAXMEM_PFN : mappable_physpages;
 	highmem_pages = (long) (physpages - lowmem_pages);
 
-	pr_notice("%ldMB HIGHMEM available.\n",
-	       pages_to_mb(highmem_pages > 0 ? highmem_pages : 0));
-	pr_notice("%ldMB LOWMEM available.\n",
-			pages_to_mb(lowmem_pages));
+	pr_notice("%ldMB HIGHMEM available\n",
+		  pages_to_mb(highmem_pages > 0 ? highmem_pages : 0));
+	pr_notice("%ldMB LOWMEM available\n", pages_to_mb(lowmem_pages));
 #else
 	/* Set max_low_pfn based on what node 0 can directly address. */
 	max_low_pfn = node_end_pfn[0];
@@ -571,8 +569,8 @@ static void __init setup_memory(void)
 		max_pfn = MAXMEM_PFN;
 		node_end_pfn[0] = MAXMEM_PFN;
 	} else {
-		pr_notice("%ldMB memory available.\n",
-		       pages_to_mb(node_end_pfn[0]));
+		pr_notice("%ldMB memory available\n",
+			  pages_to_mb(node_end_pfn[0]));
 	}
 	for (i = 1; i < MAX_NUMNODES; ++i) {
 		node_start_pfn[i] = 0;
@@ -587,8 +585,7 @@ static void __init setup_memory(void)
 		if (pages)
 			high_memory = pfn_to_kaddr(node_end_pfn[i]);
 	}
-	pr_notice("%ldMB memory available.\n",
-	       pages_to_mb(lowmem_pages));
+	pr_notice("%ldMB memory available\n", pages_to_mb(lowmem_pages));
 #endif
 #endif
 }
@@ -1535,8 +1532,7 @@ static void __init pcpu_fc_populate_pte(unsigned long addr)
 
 	BUG_ON(pgd_addr_invalid(addr));
 	if (addr < VMALLOC_START || addr >= VMALLOC_END)
-		panic("PCPU addr %#lx outside vmalloc range %#lx..%#lx;"
-		      " try increasing CONFIG_VMALLOC_RESERVE\n",
+		panic("PCPU addr %#lx outside vmalloc range %#lx..%#lx; try increasing CONFIG_VMALLOC_RESERVE\n",
 		      addr, VMALLOC_START, VMALLOC_END);
 
 	pgd = swapper_pg_dir + pgd_index(addr);
@@ -1591,8 +1587,8 @@ void __init setup_per_cpu_areas(void)
 			lowmem_va = (unsigned long)pfn_to_kaddr(pfn);
 			ptep = virt_to_kpte(lowmem_va);
 			if (pte_huge(*ptep)) {
-				printk(KERN_DEBUG "early shatter of huge page"
-				       " at %#lx\n", lowmem_va);
+				printk(KERN_DEBUG "early shatter of huge page at %#lx\n",
+				       lowmem_va);
 				shatter_pmd((pmd_t *)ptep);
 				ptep = virt_to_kpte(lowmem_va);
 				BUG_ON(pte_huge(*ptep));
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 7c2fecc..bca1c67 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -345,7 +345,6 @@ static void dump_mem(void __user *address)
 	int i, j, k;
 	int found_readable_mem = 0;
 
-	pr_err("\n");
 	if (!access_ok(VERIFY_READ, address, 1)) {
 		pr_err("Not dumping at address 0x%lx (kernel address)\n",
 		       (unsigned long)address);
@@ -367,7 +366,7 @@ static void dump_mem(void __user *address)
 			       (unsigned long)address);
 			found_readable_mem = 1;
 		}
-		j = sprintf(line, REGFMT":", (unsigned long)addr);
+		j = sprintf(line, REGFMT ":", (unsigned long)addr);
 		for (k = 0; k < bytes_per_line; ++k)
 			j += sprintf(&line[j], " %02x", buf[k]);
 		pr_err("%s\n", line);
@@ -411,8 +410,7 @@ void trace_unhandled_signal(const char *type, struct pt_regs *regs,
 		case SIGFPE:
 		case SIGSEGV:
 		case SIGBUS:
-			pr_err("User crash: signal %d,"
-			       " trap %ld, address 0x%lx\n",
+			pr_err("User crash: signal %d, trap %ld, address 0x%lx\n",
 			       sig, regs->faultnum, address);
 			show_regs(regs);
 			dump_mem((void __user *)address);
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 6cb2ce3..8629730 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -222,11 +222,9 @@ static tilepro_bundle_bits rewrite_load_store_unaligned(
 	}
 
 	if (unaligned_printk || unaligned_fixup_count == 0) {
-		pr_info("Process %d/%s: PC %#lx: Fixup of"
-			" unaligned %s at %#lx.\n",
+		pr_info("Process %d/%s: PC %#lx: Fixup of unaligned %s at %#lx\n",
 			current->pid, current->comm, regs->pc,
-			(mem_op == MEMOP_LOAD ||
-			 mem_op == MEMOP_LOAD_POSTINCR) ?
+			mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR ?
 			"load" : "store",
 			(unsigned long)addr);
 		if (!unaligned_printk) {
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 0d59a1b..20d52a9 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -127,8 +127,7 @@ static __init int reset_init_affinity(void)
 {
 	long rc = sched_setaffinity(current->pid, &init_affinity);
 	if (rc != 0)
-		pr_warning("couldn't reset init affinity (%ld)\n",
-		       rc);
+		pr_warn("couldn't reset init affinity (%ld)\n", rc);
 	return 0;
 }
 late_initcall(reset_init_affinity);
@@ -174,7 +173,7 @@ static void start_secondary(void)
 	/* Indicate that we're ready to come up. */
 	/* Must not do this before we're ready to receive messages */
 	if (cpumask_test_and_set_cpu(cpuid, &cpu_started)) {
-		pr_warning("CPU#%d already started!\n", cpuid);
+		pr_warn("CPU#%d already started!\n", cpuid);
 		for (;;)
 			local_irq_enable();
 	}
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index c93977a..7ff5afd 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -387,9 +387,7 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		 * then bust_spinlocks() spit out a space in front of us
 		 * and it will mess up our KERN_ERR.
 		 */
-		pr_err("\n");
-		pr_err("Starting stack dump of tid %d, pid %d (%s)"
-		       " on cpu %d at cycle %lld\n",
+		pr_err("Starting stack dump of tid %d, pid %d (%s) on cpu %d at cycle %lld\n",
 		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
 		       raw_smp_processor_id(), get_cycles());
 	}
@@ -411,8 +409,7 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		       i++, address, namebuf, (unsigned long)(kbt->it.sp));
 
 		if (i >= 100) {
-			pr_err("Stack dump truncated"
-			       " (%d frames)\n", i);
+			pr_err("Stack dump truncated (%d frames)\n", i);
 			break;
 		}
 	}
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index b854a1c..d412b08 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -98,8 +98,8 @@ void __init calibrate_delay(void)
 {
 	loops_per_jiffy = get_clock_rate() / HZ;
 	pr_info("Clock rate yields %lu.%02lu BogoMIPS (lpj=%lu)\n",
-		loops_per_jiffy/(500000/HZ),
-		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+		loops_per_jiffy / (500000 / HZ),
+		(loops_per_jiffy / (5000 / HZ)) % 100, loops_per_jiffy);
 }
 
 /* Called fairly late in init/main.c, but before we go smp. */
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 86900cc..bf841ca 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -46,9 +46,9 @@ static int __init setup_unaligned_fixup(char *str)
 		return 0;
 
 	pr_info("Fixups for unaligned data accesses are %s\n",
-	       unaligned_fixup >= 0 ?
-	       (unaligned_fixup ? "enabled" : "disabled") :
-	       "completely disabled");
+		unaligned_fixup >= 0 ?
+		(unaligned_fixup ? "enabled" : "disabled") :
+		"completely disabled");
 	return 1;
 }
 __setup("unaligned_fixup=", setup_unaligned_fixup);
@@ -305,8 +305,8 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	case INT_ILL:
 		if (copy_from_user(&instr, (void __user *)regs->pc,
 				   sizeof(instr))) {
-			pr_err("Unreadable instruction for INT_ILL:"
-			       " %#lx\n", regs->pc);
+			pr_err("Unreadable instruction for INT_ILL: %#lx\n",
+			       regs->pc);
 			do_exit(SIGKILL);
 			return;
 		}
diff --git a/arch/tile/kernel/unaligned.c b/arch/tile/kernel/unaligned.c
index c02ea2a..7d9a83b 100644
--- a/arch/tile/kernel/unaligned.c
+++ b/arch/tile/kernel/unaligned.c
@@ -969,8 +969,7 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 		unaligned_fixup_count++;
 
 		if (unaligned_printk) {
-			pr_info("%s/%d. Unalign fixup for kernel access "
-				"to userspace %lx.",
+			pr_info("%s/%d - Unalign fixup for kernel access to userspace %lx\n",
 				current->comm, current->pid, regs->regs[ra]);
 		}
 
@@ -985,7 +984,7 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 			.si_addr = (unsigned char __user *)0
 		};
 		if (unaligned_printk)
-			pr_info("Unalign bundle: unexp @%llx, %llx",
+			pr_info("Unalign bundle: unexp @%llx, %llx\n",
 				(unsigned long long)regs->pc,
 				(unsigned long long)bundle);
 
@@ -1370,8 +1369,7 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 		frag.bundle = bundle;
 
 		if (unaligned_printk) {
-			pr_info("%s/%d, Unalign fixup: pc=%lx "
-				"bundle=%lx %d %d %d %d %d %d %d %d.",
+			pr_info("%s/%d, Unalign fixup: pc=%lx bundle=%lx %d %d %d %d %d %d %d %d\n",
 				current->comm, current->pid,
 				(unsigned long)frag.pc,
 				(unsigned long)frag.bundle,
@@ -1380,8 +1378,8 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 				(int)y1_lr, (int)y1_br, (int)x1_add);
 
 			for (k = 0; k < n; k += 2)
-				pr_info("[%d] %016llx %016llx", k,
-					(unsigned long long)frag.insn[k],
+				pr_info("[%d] %016llx %016llx\n",
+					k, (unsigned long long)frag.insn[k],
 					(unsigned long long)frag.insn[k+1]);
 		}
 
@@ -1402,7 +1400,7 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 				.si_addr = (void __user *)&jit_code_area[idx]
 			};
 
-			pr_warn("Unalign fixup: pid=%d %s jit_code_area=%llx",
+			pr_warn("Unalign fixup: pid=%d %s jit_code_area=%llx\n",
 				current->pid, current->comm,
 				(unsigned long long)&jit_code_area[idx]);
 
@@ -1485,7 +1483,7 @@ void do_unaligned(struct pt_regs *regs, int vecnum)
 			/* If exception came from kernel, try fix it up. */
 			if (fixup_exception(regs)) {
 				if (unaligned_printk)
-					pr_info("Unalign fixup: %d %llx @%llx",
+					pr_info("Unalign fixup: %d %llx @%llx\n",
 						(int)unaligned_fixup,
 						(unsigned long long)regs->ex1,
 						(unsigned long long)regs->pc);
@@ -1519,7 +1517,7 @@ void do_unaligned(struct pt_regs *regs, int vecnum)
 		};
 
 		if (unaligned_printk)
-			pr_info("Unalign fixup: %d %llx @%llx",
+			pr_info("Unalign fixup: %d %llx @%llx\n",
 				(int)unaligned_fixup,
 				(unsigned long long)regs->ex1,
 				(unsigned long long)regs->pc);
@@ -1579,14 +1577,14 @@ void do_unaligned(struct pt_regs *regs, int vecnum)
 						    0);
 
 		if (IS_ERR((void __force *)user_page)) {
-			pr_err("Out of kernel pages trying do_mmap.\n");
+			pr_err("Out of kernel pages trying do_mmap\n");
 			return;
 		}
 
 		/* Save the address in the thread_info struct */
 		info->unalign_jit_base = user_page;
 		if (unaligned_printk)
-			pr_info("Unalign bundle: %d:%d, allocate page @%llx",
+			pr_info("Unalign bundle: %d:%d, allocate page @%llx\n",
 				raw_smp_processor_id(), current->pid,
 				(unsigned long long)user_page);
 	}
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 6c05712..565e25a 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -169,8 +169,7 @@ static void wait_for_migration(pte_t *pte)
 		while (pte_migrating(*pte)) {
 			barrier();
 			if (++retries > bound)
-				panic("Hit migrating PTE (%#llx) and"
-				      " page PFN %#lx still migrating",
+				panic("Hit migrating PTE (%#llx) and page PFN %#lx still migrating",
 				      pte->val, pte_pfn(*pte));
 		}
 	}
@@ -292,11 +291,10 @@ static int handle_page_fault(struct pt_regs *regs,
 	 */
 	stack_offset = stack_pointer & (THREAD_SIZE-1);
 	if (stack_offset < THREAD_SIZE / 8) {
-		pr_alert("Potential stack overrun: sp %#lx\n",
-		       stack_pointer);
+		pr_alert("Potential stack overrun: sp %#lx\n", stack_pointer);
 		show_regs(regs);
 		pr_alert("Killing current process %d/%s\n",
-		       tsk->pid, tsk->comm);
+			 tsk->pid, tsk->comm);
 		do_group_exit(SIGKILL);
 	}
 
@@ -421,7 +419,7 @@ good_area:
 	} else if (write) {
 #ifdef TEST_VERIFY_AREA
 		if (!is_page_fault && regs->cs == KERNEL_CS)
-			pr_err("WP fault at "REGFMT"\n", regs->eip);
+			pr_err("WP fault at " REGFMT "\n", regs->eip);
 #endif
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
@@ -519,16 +517,15 @@ no_context:
 		pte_t *pte = lookup_address(address);
 
 		if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
-			pr_crit("kernel tried to execute"
-			       " non-executable page - exploit attempt?"
-			       " (uid: %d)\n", current->uid);
+			pr_crit("kernel tried to execute non-executable page - exploit attempt? (uid: %d)\n",
+				current->uid);
 	}
 #endif
 	if (address < PAGE_SIZE)
 		pr_alert("Unable to handle kernel NULL pointer dereference\n");
 	else
 		pr_alert("Unable to handle kernel paging request\n");
-	pr_alert(" at virtual address "REGFMT", pc "REGFMT"\n",
+	pr_alert(" at virtual address " REGFMT ", pc " REGFMT "\n",
 		 address, regs->pc);
 
 	show_regs(regs);
@@ -575,9 +572,10 @@ do_sigbus:
 #ifndef __tilegx__
 
 /* We must release ICS before panicking or we won't get anywhere. */
-#define ics_panic(fmt, ...) do { \
-	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0); \
-	panic(fmt, __VA_ARGS__); \
+#define ics_panic(fmt, ...)					\
+do {								\
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);	\
+	panic(fmt, ##__VA_ARGS__);				\
 } while (0)
 
 /*
@@ -615,8 +613,7 @@ struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 	     fault_num != INT_DTLB_ACCESS)) {
 		unsigned long old_pc = regs->pc;
 		regs->pc = pc;
-		ics_panic("Bad ICS page fault args:"
-			  " old PC %#lx, fault %d/%d at %#lx\n",
+		ics_panic("Bad ICS page fault args: old PC %#lx, fault %d/%d at %#lx",
 			  old_pc, fault_num, write, address);
 	}
 
@@ -669,8 +666,8 @@ struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 #endif
 		fixup = search_exception_tables(pc);
 		if (!fixup)
-			ics_panic("ICS atomic fault not in table:"
-				  " PC %#lx, fault %d", pc, fault_num);
+			ics_panic("ICS atomic fault not in table: PC %#lx, fault %d",
+				  pc, fault_num);
 		regs->pc = fixup->fixup;
 		regs->ex1 = PL_ICS_EX1(KERNEL_PL, 0);
 	}
@@ -826,8 +823,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 
 			set_thread_flag(TIF_ASYNC_TLB);
 			if (async->fault_num != 0) {
-				panic("Second async fault %d;"
-				      " old fault was %d (%#lx/%ld)",
+				panic("Second async fault %d; old fault was %d (%#lx/%ld)",
 				      fault_num, async->fault_num,
 				      address, write);
 			}
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 33294fd..cd33873 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -152,12 +152,10 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
 	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
 
-	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s],"
-	       " %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
+	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s], %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
 	       cache_pa, cache_control, cache_cpumask, cache_buf,
 	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
-	       tlb_cpumask, tlb_buf,
-	       asids, asidcount, rc);
+	       tlb_cpumask, tlb_buf, asids, asidcount, rc);
 	panic("Unsafe to continue.");
 }
 
diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
index e514899..3270e00 100644
--- a/arch/tile/mm/hugetlbpage.c
+++ b/arch/tile/mm/hugetlbpage.c
@@ -284,22 +284,21 @@ static __init int __setup_hugepagesz(unsigned long ps)
 	int level, base_shift;
 
 	if ((1UL << log_ps) != ps || (log_ps & 1) != 0) {
-		pr_warn("Not enabling %ld byte huge pages;"
-			" must be a power of four.\n", ps);
+		pr_warn("Not enabling %ld byte huge pages; must be a power of four\n",
+			ps);
 		return -EINVAL;
 	}
 
 	if (ps > 64*1024*1024*1024UL) {
-		pr_warn("Not enabling %ld MB huge pages;"
-			" largest legal value is 64 GB .\n", ps >> 20);
+		pr_warn("Not enabling %ld MB huge pages; largest legal value is 64 GB\n",
+			ps >> 20);
 		return -EINVAL;
 	} else if (ps >= PUD_SIZE) {
 		static long hv_jpage_size;
 		if (hv_jpage_size == 0)
 			hv_jpage_size = hv_sysconf(HV_SYSCONF_PAGE_SIZE_JUMBO);
 		if (hv_jpage_size != PUD_SIZE) {
-			pr_warn("Not enabling >= %ld MB huge pages:"
-				" hypervisor reports size %ld\n",
+			pr_warn("Not enabling >= %ld MB huge pages: hypervisor reports size %ld\n",
 				PUD_SIZE >> 20, hv_jpage_size);
 			return -EINVAL;
 		}
@@ -320,14 +319,13 @@ static __init int __setup_hugepagesz(unsigned long ps)
 		int shift_val = log_ps - base_shift;
 		if (huge_shift[level] != 0) {
 			int old_shift = base_shift + huge_shift[level];
-			pr_warn("Not enabling %ld MB huge pages;"
-				" already have size %ld MB.\n",
+			pr_warn("Not enabling %ld MB huge pages; already have size %ld MB\n",
 				ps >> 20, (1UL << old_shift) >> 20);
 			return -EINVAL;
 		}
 		if (hv_set_pte_super_shift(level, shift_val) != 0) {
-			pr_warn("Not enabling %ld MB huge pages;"
-				" no hypervisor support.\n", ps >> 20);
+			pr_warn("Not enabling %ld MB huge pages; no hypervisor support\n",
+				ps >> 20);
 			return -EINVAL;
 		}
 		printk(KERN_DEBUG "Enabled %ld MB huge pages\n", ps >> 20);
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index caa2701..be240cc 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -357,11 +357,11 @@ static int __init setup_ktext(char *str)
 		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
 		if (cpumask_weight(&ktext_mask) > 1) {
 			ktext_small = 1;
-			pr_info("ktext: using caching neighborhood %s "
-			       "with small pages\n", buf);
+			pr_info("ktext: using caching neighborhood %s with small pages\n",
+				buf);
 		} else {
 			pr_info("ktext: caching on cpu %s with one huge page\n",
-			       buf);
+				buf);
 		}
 	}
 
@@ -413,19 +413,16 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	int rc, i;
 
 	if (ktext_arg_seen && ktext_hash) {
-		pr_warning("warning: \"ktext\" boot argument ignored"
-			   " if \"kcache_hash\" sets up text hash-for-home\n");
+		pr_warn("warning: \"ktext\" boot argument ignored if \"kcache_hash\" sets up text hash-for-home\n");
 		ktext_small = 0;
 	}
 
 	if (kdata_arg_seen && kdata_hash) {
-		pr_warning("warning: \"kdata\" boot argument ignored"
-			   " if \"kcache_hash\" sets up data hash-for-home\n");
+		pr_warn("warning: \"kdata\" boot argument ignored if \"kcache_hash\" sets up data hash-for-home\n");
 	}
 
 	if (kdata_huge && !hash_default) {
-		pr_warning("warning: disabling \"kdata=huge\"; requires"
-			  " kcache_hash=all or =allbutstack\n");
+		pr_warn("warning: disabling \"kdata=huge\"; requires kcache_hash=all or =allbutstack\n");
 		kdata_huge = 0;
 	}
 
@@ -470,8 +467,8 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 					pte[pte_ofs] = pfn_pte(pfn, prot);
 			} else {
 				if (kdata_huge)
-					printk(KERN_DEBUG "pre-shattered huge"
-					       " page at %#lx\n", address);
+					printk(KERN_DEBUG "pre-shattered huge page at %#lx\n",
+					       address);
 				for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE;
 				     pfn++, pte_ofs++, address += PAGE_SIZE) {
 					pgprot_t prot = init_pgprot(address);
@@ -501,8 +498,8 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 			pr_info("ktext: not using unavailable cpus %s\n", buf);
 		}
 		if (cpumask_empty(&ktext_mask)) {
-			pr_warning("ktext: no valid cpus; caching on %d.\n",
-				   smp_processor_id());
+			pr_warn("ktext: no valid cpus; caching on %d\n",
+				smp_processor_id());
 			cpumask_copy(&ktext_mask,
 				     cpumask_of(smp_processor_id()));
 		}
@@ -798,11 +795,9 @@ void __init mem_init(void)
 #ifdef CONFIG_HIGHMEM
 	/* check that fixmap and pkmap do not overlap */
 	if (PKMAP_ADDR(LAST_PKMAP-1) >= FIXADDR_START) {
-		pr_err("fixmap and kmap areas overlap"
-		       " - this will crash\n");
+		pr_err("fixmap and kmap areas overlap - this will crash\n");
 		pr_err("pkstart: %lxh pkend: %lxh fixstart %lxh\n",
-		       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP-1),
-		       FIXADDR_START);
+		       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP-1), FIXADDR_START);
 		BUG();
 	}
 #endif
@@ -926,8 +921,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	unsigned long addr = (unsigned long) begin;
 
 	if (kdata_huge && !initfree) {
-		pr_warning("Warning: ignoring initfree=0:"
-			   " incompatible with kdata=huge\n");
+		pr_warn("Warning: ignoring initfree=0: incompatible with kdata=huge\n");
 		initfree = 1;
 	}
 	end = (end + PAGE_SIZE - 1) & PAGE_MASK;
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 5e86eac..7bf2491 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -44,9 +44,7 @@ void show_mem(unsigned int filter)
 {
 	struct zone *zone;
 
-	pr_err("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu"
-	       " free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu"
-	       " pagecache:%lu swap:%lu\n",
+	pr_err("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu pagecache:%lu swap:%lu\n",
 	       (global_page_state(NR_ACTIVE_ANON) +
 		global_page_state(NR_ACTIVE_FILE)),
 	       (global_page_state(NR_INACTIVE_ANON) +
-- 
2.1.2



