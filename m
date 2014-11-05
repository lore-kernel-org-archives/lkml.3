Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaKEJmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:42:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:4557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKEJl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:41:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208,223";a="484672288"
Message-ID: <5459F0DE.6000307@linux.intel.com>
Date: Wed, 05 Nov 2014 17:41:50 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86 platforms
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <20141104144730.GE14512@8bytes.org> <5458ECF3.4040308@linux.intel.com> <20141105085154.GG10744@8bytes.org>
In-Reply-To: <20141105085154.GG10744@8bytes.org>
Content-Type: multipart/mixed;
 boundary="------------060906020808040102030602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060906020808040102030602
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Joerg,
	Could you please help to apply the attached patch and send me
console outputs?
Regards!
Gerry

On 2014/11/5 16:51, Joerg Roedel wrote:
> On Tue, Nov 04, 2014 at 11:12:51PM +0800, Jiang Liu wrote:
>> 	Do you have the call stack?
> 
> Okay, had some issues with serial setup, but now its working. Here is
> the complete panic msg from the AMD Kaveri box (the panic only occurs
> with IOMMU enabled):
> 
> [    2.487552] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 8 ports 6 Gbps 0xff impl SATA mode
> [    2.495844] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
> [    2.504592] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    2.512618] IP: [<ffffffff8136849d>] msi_set_mask_bit+0xd/0x50
> [    2.518556] PGD 0 
> [    2.520672] Oops: 0000 [#1] PREEMPT SMP 
> [    2.524784] Modules linked in:
> [    2.527946] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc3+ #4
> [    2.534384] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A88XM-HD3, BIOS F6 05/28/2014
> [    2.544576] task: ffff88042b54c010 ti: ffff88042b550000 task.ti: ffff88042b550000
> [    2.552170] RIP: 0010:[<ffffffff8136849d>]  [<ffffffff8136849d>] msi_set_mask_bit+0xd/0x50
> [    2.560594] RSP: 0000:ffff88042b5539d8  EFLAGS: 00010096
> [    2.565954] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88042b553968
> [    2.573175] RDX: ffffffff81c25f40 RSI: 0000000000000000 RDI: ffff880424c65c00
> [    2.580361] RBP: ffff88042b5539e8 R08: ffff88042b519800 R09: ffff88042b000b20
> [    2.587582] R10: ffff880424c24410 R11: 0000000000000246 R12: 0000000000000001
> [    2.594762] R13: ffff8804253fb2c0 R14: ffff880424c24410 R15: ffff880424c65c98
> [    2.601983] FS:  0000000000000000(0000) GS:ffff88043ed80000(0000) knlGS:0000000000000000
> [    2.610181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.615975] CR2: 0000000000000000 CR3: 0000000001c16000 CR4: 00000000000407e0
> [    2.623197] Stack:
> [    2.625264]  ffff88042b5539f8 ffff880424c65c00 ffff88042b5539f8 ffffffff813688fb
> [    2.632936]  ffff88042b553a18 ffffffff810b0603 ffff880424c65c00 ffff880424c65c00
> [    2.640598]  ffff88042b553a48 ffffffff810b0685 0000000000000000 0000000000000000
> [    2.648261] Call Trace:
> [    2.650768]  [<ffffffff813688fb>] unmask_msi_irq+0xb/0x10
> [    2.656222]  [<ffffffff810b0603>] irq_enable+0x33/0x50
> [    2.661414]  [<ffffffff810b0685>] irq_startup+0x65/0x70
> [    2.666696]  [<ffffffff810af161>] __setup_irq+0x511/0x5a0
> [    2.672152]  [<ffffffff81196326>] ? __kmalloc_track_caller+0x256/0x4b0
> [    2.678733]  [<ffffffff81460a50>] ? ahci_bad_pmp_check_ready+0x60/0x60
> [    2.685347]  [<ffffffff810af34a>] request_threaded_irq+0xca/0x170
> [    2.691529]  [<ffffffff81460a50>] ? ahci_bad_pmp_check_ready+0x60/0x60
> [    2.698110]  [<ffffffff81461ee0>] ? ahci_single_irq_intr+0x110/0x110
> [    2.704517]  [<ffffffff810b102a>] devm_request_threaded_irq+0x5a/0xc0
> [    2.711002]  [<ffffffff81462b93>] ahci_host_activate+0x143/0x220
> [    2.717098]  [<ffffffff814602a8>] ahci_init_one+0x7b8/0xb00
> [    2.722728]  [<ffffffff8134e760>] local_pci_probe+0x40/0xa0
> [    2.728355]  [<ffffffff8134f9b5>] ? pci_match_device+0xe5/0x110
> [    2.734365]  [<ffffffff8134faf1>] pci_device_probe+0xd1/0x130
> [    2.740164]  [<ffffffff81413d9b>] driver_probe_device+0x8b/0x3d0
> [    2.746216]  [<ffffffff814141b3>] __driver_attach+0x93/0xa0
> [    2.751846]  [<ffffffff81414120>] ? __device_attach+0x40/0x40
> [    2.757681]  [<ffffffff81411e13>] bus_for_each_dev+0x63/0xa0
> [    2.763385]  [<ffffffff81413819>] driver_attach+0x19/0x20
> [    2.768842]  [<ffffffff81413430>] bus_add_driver+0x180/0x250
> [    2.774591]  [<ffffffff81d2fd60>] ? ata_sff_init+0x33/0x33
> [    2.780123]  [<ffffffff81414a0f>] driver_register+0x5f/0xf0
> [    2.785751]  [<ffffffff8134e107>] __pci_register_driver+0x47/0x50
> [    2.791892]  [<ffffffff81d2fd79>] ahci_pci_driver_init+0x19/0x1b
> [    2.797954]  [<ffffffff810002f4>] do_one_initcall+0xb4/0x1f0
> [    2.803667]  [<ffffffff81095e23>] ? __wake_up+0x43/0x60
> [    2.808948]  [<ffffffff81ce7248>] kernel_init_freeable+0x197/0x21f
> [    2.815181]  [<ffffffff81ce6983>] ? initcall_blacklist+0xc0/0xc0
> [    2.821280]  [<ffffffff815fe680>] ? rest_init+0x90/0x90
> [    2.826561]  [<ffffffff815fe689>] kernel_init+0x9/0xf0
> [    2.831756]  [<ffffffff8161433c>] ret_from_fork+0x7c/0xb0
> [    2.837211]  [<ffffffff815fe680>] ? rest_init+0x90/0x90
> [    2.842489] Code: c1 83 c9 01 83 c2 0c 85 f6 0f 45 c1 48 63 d2 48 03 57 28 89 02 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 48 83 ec 08 48 8b 5f 40 <f6> 03 01 75 26 8b 4f 04 2b 4b 0c 89 f2 be 01 00 00 00 48 89 df 
> [    2.864562] RIP  [<ffffffff8136849d>] msi_set_mask_bit+0xd/0x50
> [    2.870588]  RSP <ffff88042b5539d8>
> [    2.874127] CR2: 0000000000000000
> [    2.877501] ---[ end trace dd9f8c29b83b2de1 ]---
> [    2.882174] note: swapper/0[1] exited with preempt_count 1
> [    2.887769] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [    2.887769] 
> [    2.897147] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [    2.907440] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--------------060906020808040102030602
Content-Type: text/plain; charset=gb18030;
 name="0001-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-.patch"

>From 705c73aee455cfe5abb27da0d62cb38e1a256bde Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@linux.intel.com>
Date: Wed, 5 Nov 2014 17:25:04 +0800
Subject: [PATCH]


Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |    1 +
 drivers/ata/ahci.c         |    2 ++
 drivers/ata/libahci.c      |    1 +
 drivers/pci/msi.c          |    7 ++++++-
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index cc70fc659121..a2dffe3c30ce 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -110,6 +110,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	if (type == PCI_CAP_ID_MSI) {
 		info.type = X86_IRQ_ALLOC_TYPE_MSI;
 		info.flags |= X86_IRQ_ALLOC_CONTIGOUS_VECTORS;
+		dev_warn(&dev->dev, "irqdomain: try allocate %d MSI IRQs\n", nvec);
 	} else {
 		info.type = X86_IRQ_ALLOC_TYPE_MSIX;
 	}
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5f039f191067..13985ba61b18 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1200,6 +1200,7 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	if (nvec < 0)
 		goto intx;
 
+	pr_warn("irqdomain: AHCI %d ports, %d MSI\n", n_ports, nvec);
 	/*
 	 * If number of MSIs is less than number of ports then Sharing Last
 	 * Message mode could be enforced. In this case assume that advantage
@@ -1214,6 +1215,7 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	else if (rc < 0)
 		goto intx;
 
+	pr_warn("irqdomain: AHCI allocated IRQ%d to IRQ%d\n", dev->irq, dev->irq + nvec - 1);
 	/* fallback to single MSI mode if the controller enforced MRSM mode */
 	if (readl(hpriv->mmio + HOST_CTL) & HOST_MRSM) {
 		pci_disable_msi(pdev);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 5eb61c9e63da..d90b623eab35 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2456,6 +2456,7 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
 			continue;
 		}
 
+		pr_warn("irqdomain: request IRQ%d\n", irq + i);
 		rc = devm_request_threaded_irq(host->dev, irq + i,
 					       ahci_multi_irqs_intr,
 					       ahci_port_thread_fn, IRQF_SHARED,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7423ee16972f..4d8fef065e2c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -216,6 +216,8 @@ static void msi_set_mask_bit(struct irq_data *data, u32 flag)
 {
 	struct msi_desc *desc = irq_data_get_msi(data);
 
+	if (desc == NULL)
+		pr_warn("no msi_desc for IRQ%d\n", data->irq);
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
 		readl(desc->mask_base);		/* Flush write to device */
@@ -1202,6 +1204,8 @@ int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 	int node = dev_to_node(&dev->dev);
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		if (type == PCI_CAP_ID_MSI && msidesc->nvec_used > 1) 
+			dev_warn(&dev->dev, "try to alloc nvec %d\n", msidesc->nvec_used);
 		arch_msi_irq_domain_set_hwirq(arg, msi_get_hwirq(dev, msidesc));
 		virq = irq_domain_alloc_irqs(domain, msidesc->nvec_used,
 					     node, arg);
@@ -1210,8 +1214,9 @@ int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 			return (type == PCI_CAP_ID_MSI &&
 				msidesc->nvec_used > 1) ?  1 : -ENOSPC;
 		}
+		dev_warn(&dev->dev, "allocated IRQ%d for MSI\n", virq);
 		for (i = 0; i < msidesc->nvec_used; i++)
-			irq_set_msi_desc_off(virq + i, i, msidesc);
+			BUG_ON(irq_set_msi_desc_off(virq + i, i, msidesc));
 	}
 
 	list_for_each_entry(msidesc, &dev->msi_list, list)
-- 
1.7.10.4


--------------060906020808040102030602--
