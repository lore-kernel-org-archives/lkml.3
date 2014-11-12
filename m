Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaKLNnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:41727 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaKLNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:16 -0500
Message-Id: <20141112134121.115015986@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 15/16] PCI/MSI: Rename write_msi_msg() to pci_write_msi_msg()
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rfc-part4-v1-12-17-pci-msi-rename-__write_msi_msg-as-__pci_write_msi_msg.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Rename write_msi_msg() to pci_write_msi_msg() to mark it as PCI
specific.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-iop13xx/msi.c            |    2 +-
 arch/ia64/kernel/msi_ia64.c            |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c           |    4 ++--
 arch/mips/pci/msi-octeon.c             |    2 +-
 arch/mips/pci/msi-xlp.c                |    2 +-
 arch/mips/pci/pci-xlr.c                |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c |    2 +-
 arch/powerpc/platforms/powernv/pci.c   |    2 +-
 arch/powerpc/sysdev/fsl_msi.c          |    2 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c  |    2 +-
 arch/powerpc/sysdev/mpic_u3msi.c       |    2 +-
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  |    2 +-
 arch/powerpc/sysdev/ppc4xx_msi.c       |    2 +-
 arch/s390/pci/pci.c                    |    2 +-
 arch/sparc/kernel/pci_msi.c            |    2 +-
 arch/tile/kernel/pci_gx.c              |    2 +-
 arch/x86/kernel/apic/io_apic.c         |    4 ++--
 arch/x86/pci/xen.c                     |    2 +-
 drivers/irqchip/irq-armada-370-xp.c    |    2 +-
 drivers/pci/host/pci-tegra.c           |    2 +-
 drivers/pci/host/pcie-designware.c     |    2 +-
 drivers/pci/host/pcie-rcar.c           |    2 +-
 drivers/pci/host/pcie-xilinx.c         |    2 +-
 drivers/pci/msi.c                      |   11 +++++------
 drivers/vfio/pci/vfio_pci_intrs.c      |    2 +-
 include/linux/msi.h                    |    4 ++--
 26 files changed, 34 insertions(+), 35 deletions(-)

Index: tip/arch/arm/mach-iop13xx/msi.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/msi.c
+++ tip/arch/arm/mach-iop13xx/msi.c
@@ -153,7 +153,7 @@ int arch_setup_msi_irq(struct pci_dev *p
 	id = iop13xx_cpu_id();
 	msg.data = (id << IOP13XX_MU_MIMR_CORE_SELECT) | (irq & 0x7f);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &iop13xx_msi_chip, handle_simple_irq);
 
 	return 0;
Index: tip/arch/ia64/kernel/msi_ia64.c
===================================================================
--- tip.orig/arch/ia64/kernel/msi_ia64.c
+++ tip/arch/ia64/kernel/msi_ia64.c
@@ -35,7 +35,7 @@ static int ia64_set_msi_irq_affinity(str
 	data |= MSI_DATA_VECTOR(irq_to_vector(irq));
 	msg.data = data;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	cpumask_copy(idata->affinity, cpumask_of(cpu));
 
 	return 0;
@@ -71,7 +71,7 @@ int ia64_setup_msi_irq(struct pci_dev *p
 		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(vector);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &ia64_msi_chip, handle_edge_irq);
 
 	return 0;
Index: tip/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- tip.orig/arch/ia64/sn/kernel/msi_sn.c
+++ tip/arch/ia64/sn/kernel/msi_sn.c
@@ -145,7 +145,7 @@ int sn_setup_msi_irq(struct pci_dev *pde
 	msg.data = 0x100 + irq;
 
 	irq_set_msi_desc(irq, entry);
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &sn_msi_chip, handle_edge_irq);
 
 	return 0;
@@ -205,7 +205,7 @@ static int sn_set_msi_irq_affinity(struc
 	msg.address_hi = (u32)(bus_addr >> 32);
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	cpumask_copy(data->affinity, cpu_mask);
 
 	return 0;
Index: tip/arch/mips/pci/msi-octeon.c
===================================================================
--- tip.orig/arch/mips/pci/msi-octeon.c
+++ tip/arch/mips/pci/msi-octeon.c
@@ -178,7 +178,7 @@ msi_irq_allocated:
 	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
 
 	irq_set_msi_desc(irq, desc);
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	return 0;
 }
 
Index: tip/arch/mips/pci/msi-xlp.c
===================================================================
--- tip.orig/arch/mips/pci/msi-xlp.c
+++ tip/arch/mips/pci/msi-xlp.c
@@ -345,7 +345,7 @@ static int xlp_setup_msi(uint64_t lnkbas
 	if (ret < 0)
 		return ret;
 
-	write_msi_msg(xirq, &msg);
+	pci_write_msi_msg(xirq, &msg);
 	return 0;
 }
 
Index: tip/arch/mips/pci/pci-xlr.c
===================================================================
--- tip.orig/arch/mips/pci/pci-xlr.c
+++ tip/arch/mips/pci/pci-xlr.c
@@ -260,7 +260,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 	if (ret < 0)
 		return ret;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	return 0;
 }
 #endif
Index: tip/arch/powerpc/platforms/cell/axon_msi.c
===================================================================
--- tip.orig/arch/powerpc/platforms/cell/axon_msi.c
+++ tip/arch/powerpc/platforms/cell/axon_msi.c
@@ -279,7 +279,7 @@ static int axon_msi_setup_msi_irqs(struc
 
 		irq_set_msi_desc(virq, entry);
 		msg.data = virq;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 
 	return 0;
Index: tip/arch/powerpc/platforms/powernv/pci.c
===================================================================
--- tip.orig/arch/powerpc/platforms/powernv/pci.c
+++ tip/arch/powerpc/platforms/powernv/pci.c
@@ -91,7 +91,7 @@ static int pnv_setup_msi_irqs(struct pci
 			return rc;
 		}
 		irq_set_msi_desc(virq, entry);
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 }
Index: tip/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/fsl_msi.c
+++ tip/arch/powerpc/sysdev/fsl_msi.c
@@ -242,7 +242,7 @@ static int fsl_setup_msi_irqs(struct pci
 		irq_set_msi_desc(virq, entry);
 
 		fsl_compose_msi_msg(pdev, hwirq, &msg, msi_data);
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 
Index: tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -136,7 +136,7 @@ static int pasemi_msi_setup_msi_irqs(str
 		 * register to generate MSI [512...1023]
 		 */
 		msg.data = hwirq-0x200;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 
 	return 0;
Index: tip/arch/powerpc/sysdev/mpic_u3msi.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/mpic_u3msi.c
+++ tip/arch/powerpc/sysdev/mpic_u3msi.c
@@ -171,7 +171,7 @@ static int u3msi_setup_msi_irqs(struct p
 		printk("u3msi: allocated virq 0x%x (hw 0x%x) addr 0x%lx\n",
 			  virq, hwirq, (unsigned long)addr);
 		msg.data = hwirq;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 
 		hwirq++;
 	}
Index: tip/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
+++ tip/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
@@ -85,7 +85,7 @@ static int hsta_setup_msi_irqs(struct pc
 			msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
 			return -EINVAL;
 		}
-		write_msi_msg(hwirq, &msg);
+		pci_write_msi_msg(hwirq, &msg);
 	}
 
 	return 0;
Index: tip/arch/powerpc/sysdev/ppc4xx_msi.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/ppc4xx_msi.c
+++ tip/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -116,7 +116,7 @@ static int ppc4xx_setup_msi_irqs(struct
 
 		irq_set_msi_desc(virq, entry);
 		msg.data = int_no;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 }
Index: tip/arch/s390/pci/pci.c
===================================================================
--- tip.orig/arch/s390/pci/pci.c
+++ tip/arch/s390/pci/pci.c
@@ -403,7 +403,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 		msg.data = hwirq;
 		msg.address_lo = zdev->msi_addr & 0xffffffff;
 		msg.address_hi = zdev->msi_addr >> 32;
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 		airq_iv_set_data(zdev->aibv, hwirq, irq);
 		hwirq++;
 	}
Index: tip/arch/sparc/kernel/pci_msi.c
===================================================================
--- tip.orig/arch/sparc/kernel/pci_msi.c
+++ tip/arch/sparc/kernel/pci_msi.c
@@ -161,7 +161,7 @@ static int sparc64_setup_msi_irq(unsigne
 	msg.data = msi;
 
 	irq_set_msi_desc(*irq_p, entry);
-	write_msi_msg(*irq_p, &msg);
+	pci_write_msi_msg(*irq_p, &msg);
 
 	return 0;
 
Index: tip/arch/tile/kernel/pci_gx.c
===================================================================
--- tip.orig/arch/tile/kernel/pci_gx.c
+++ tip/arch/tile/kernel/pci_gx.c
@@ -1590,7 +1590,7 @@ int arch_setup_msi_irq(struct pci_dev *p
 	msg.address_hi = msi_addr >> 32;
 	msg.address_lo = msi_addr & 0xffffffff;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &tilegx_msi_chip, handle_level_irq);
 	irq_set_handler_data(irq, controller);
 
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3158,7 +3158,7 @@ msi_set_affinity(struct irq_data *data,
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	__write_msi_msg(data->msi_desc, &msg);
+	__pci_write_msi_msg(data->msi_desc, &msg);
 
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
@@ -3196,7 +3196,7 @@ int setup_msi_irq(struct pci_dev *dev, s
 	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
 	 */
 	if (!irq_offset)
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 
 	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
Index: tip/arch/x86/pci/xen.c
===================================================================
--- tip.orig/arch/x86/pci/xen.c
+++ tip/arch/x86/pci/xen.c
@@ -240,7 +240,7 @@ static int xen_hvm_setup_msi_irqs(struct
 				goto error;
 			}
 			xen_msi_compose_msg(dev, pirq, &msg);
-			__write_msi_msg(msidesc, &msg);
+			__pci_write_msi_msg(msidesc, &msg);
 			dev_dbg(&dev->dev, "xen: msi bound to pirq=%d\n", pirq);
 		} else {
 			dev_dbg(&dev->dev,
Index: tip/drivers/irqchip/irq-armada-370-xp.c
===================================================================
--- tip.orig/drivers/irqchip/irq-armada-370-xp.c
+++ tip/drivers/irqchip/irq-armada-370-xp.c
@@ -157,7 +157,7 @@ static int armada_370_xp_setup_msi_irq(s
 	msg.address_hi = 0;
 	msg.data = 0xf00 | (hwirq + 16);
 
-	write_msi_msg(virq, &msg);
+	pci_write_msi_msg(virq, &msg);
 	return 0;
 }
 
Index: tip/drivers/pci/host/pci-tegra.c
===================================================================
--- tip.orig/drivers/pci/host/pci-tegra.c
+++ tip/drivers/pci/host/pci-tegra.c
@@ -1308,7 +1308,7 @@ static int tegra_msi_setup_irq(struct ms
 	msg.address_hi = 0;
 	msg.data = hwirq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
Index: tip/drivers/pci/host/pcie-designware.c
===================================================================
--- tip.orig/drivers/pci/host/pcie-designware.c
+++ tip/drivers/pci/host/pcie-designware.c
@@ -298,7 +298,7 @@ static int dw_msi_setup_irq(struct msi_c
 	else
 		msg.data = pos;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
Index: tip/drivers/pci/host/pcie-rcar.c
===================================================================
--- tip.orig/drivers/pci/host/pcie-rcar.c
+++ tip/drivers/pci/host/pcie-rcar.c
@@ -647,7 +647,7 @@ static int rcar_msi_setup_irq(struct msi
 	msg.address_hi = rcar_pci_read_reg(pcie, PCIEMSIAUR);
 	msg.data = hwirq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
Index: tip/drivers/pci/host/pcie-xilinx.c
===================================================================
--- tip.orig/drivers/pci/host/pcie-xilinx.c
+++ tip/drivers/pci/host/pcie-xilinx.c
@@ -374,7 +374,7 @@ static int xilinx_pcie_msi_setup_irq(str
 	msg.address_lo = msg_addr;
 	msg.data = irq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -26,7 +26,6 @@ static int pci_msi_enable = 1;
 
 #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
 
-
 /* Arch hooks */
 
 int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
@@ -114,7 +113,7 @@ static void default_restore_msi_irq(stru
 	}
 
 	if (entry)
-		__write_msi_msg(entry, &entry->msg);
+		__pci_write_msi_msg(entry, &entry->msg);
 }
 
 void __weak arch_restore_msi_irqs(struct pci_dev *dev)
@@ -272,7 +271,7 @@ void __pci_read_msi_msg(struct msi_desc
 	}
 }
 
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
@@ -309,13 +308,13 @@ void __write_msi_msg(struct msi_desc *en
 	entry->msg = *msg;
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
 
-	__write_msi_msg(entry, msg);
+	__pci_write_msi_msg(entry, msg);
 }
-EXPORT_SYMBOL_GPL(write_msi_msg);
+EXPORT_SYMBOL_GPL(pci_write_msi_msg);
 
 static void free_msi_irqs(struct pci_dev *dev)
 {
Index: tip/drivers/vfio/pci/vfio_pci_intrs.c
===================================================================
--- tip.orig/drivers/vfio/pci/vfio_pci_intrs.c
+++ tip/drivers/vfio/pci/vfio_pci_intrs.c
@@ -560,7 +560,7 @@ static int vfio_msi_set_vector_signal(st
 		struct msi_msg msg;
 
 		get_cached_msi_msg(irq, &msg);
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 	}
 
 	ret = request_irq(irq, vfio_msihandler, 0,
Index: tip/include/linux/msi.h
===================================================================
--- tip.orig/include/linux/msi.h
+++ tip/include/linux/msi.h
@@ -16,9 +16,7 @@ struct msi_desc;
 void mask_msi_irq(struct irq_data *data);
 void unmask_msi_irq(struct irq_data *data);
 void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
-void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {
 	struct {
@@ -48,6 +46,8 @@ struct msi_desc {
 
 #ifdef CONFIG_PCI_MSI
 void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg);
 #endif
 
 /*


