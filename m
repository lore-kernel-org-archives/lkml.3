Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaKEN1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:27:11 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54281 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:27:07 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
        alexei.starovoitov@gmail.com, rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial] treewide: Fix typo in printk and Kconfig
Date: Wed,  5 Nov 2014 22:26:48 +0900
Message-Id: <1415194008-25550-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0
In-Reply-To: <CAADnVQLye-wFpnRgnSd6n=9awSA3Q_HshaMkZ=rdQ1C-zEtpFA@mail.gmail.com>
References: <CAADnVQLye-wFpnRgnSd6n=9awSA3Q_HshaMkZ=rdQ1C-zEtpFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in printk and Kconfig within
various part of kernel sources.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/cavium-octeon/setup.c                                | 4 ++--
 arch/mips/pci/pci-octeon.c                                     | 2 +-
 arch/powerpc/kvm/e500_mmu_host.c                               | 6 +++---
 drivers/isdn/mISDN/l1oip_core.c                                | 2 +-
 drivers/media/pci/ttpci/budget-patch.c                         | 2 +-
 drivers/s390/char/tape_3590.c                                  | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c                      | 2 +-
 drivers/target/target_core_xcopy.c                             | 2 +-
 drivers/tty/serial/Kconfig                                     | 2 +-
 drivers/usb/gadget/function/f_hid.c                            | 2 +-
 drivers/usb/host/ehci-sysfs.c                                  | 2 +-
 drivers/usb/host/fotg210-hcd.c                                 | 2 +-
 drivers/usb/host/fusbh200-hcd.c                                | 2 +-
 fs/reiserfs/journal.c                                          | 2 +-
 tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c | 2 +-
 15 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 5ebdb32..94f888d 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -1092,7 +1092,7 @@ static int __init edac_devinit(void)
 		name = edac_device_names[i];
 		dev = platform_device_register_simple(name, -1, NULL, 0);
 		if (IS_ERR(dev)) {
-			pr_err("Registation of %s failed!\n", name);
+			pr_err("Registration of %s failed!\n", name);
 			err = PTR_ERR(dev);
 		}
 	}
@@ -1103,7 +1103,7 @@ static int __init edac_devinit(void)
 		dev = platform_device_register_simple("octeon_lmc_edac",
 						      i, NULL, 0);
 		if (IS_ERR(dev)) {
-			pr_err("Registation of octeon_lmc_edac %d failed!\n", i);
+			pr_err("Registration of octeon_lmc_edac %d failed!\n", i);
 			err = PTR_ERR(dev);
 		}
 	}
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 59cccd9..d07e041 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -708,7 +708,7 @@ static int __init octeon_pci_setup(void)
 
 	if (IS_ERR(platform_device_register_simple("octeon_pci_edac",
 						   -1, NULL, 0)))
-		pr_err("Registation of co_pci_edac failed!\n");
+		pr_err("Registration of co_pci_edac failed!\n");
 
 	octeon_pci_dma_init();
 
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 769778f8..cc536d4 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -661,7 +661,7 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu, enum instruction_type type,
 	if (unlikely((pr && !(mas3 & MAS3_UX)) ||
 		     (!pr && !(mas3 & MAS3_SX)))) {
 		pr_err_ratelimited(
-			"%s: Instuction emulation from guest addres %08lx without execute permission\n",
+			"%s: Instruction emulation from guest address %08lx without execute permission\n",
 			__func__, geaddr);
 		return EMULATE_AGAIN;
 	}
@@ -673,7 +673,7 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu, enum instruction_type type,
 	if (has_feature(vcpu, VCPU_FTR_MMU_V2) &&
 	    unlikely((mas2 & MAS2_I) || (mas2 & MAS2_W) || !(mas2 & MAS2_M))) {
 		pr_err_ratelimited(
-			"%s: Instuction emulation from guest addres %08lx mismatches storage attributes\n",
+			"%s: Instruction emulation from guest address %08lx mismatches storage attributes\n",
 			__func__, geaddr);
 		return EMULATE_AGAIN;
 	}
@@ -686,7 +686,7 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu, enum instruction_type type,
 
 	/* Guard against emulation from devices area */
 	if (unlikely(!page_is_ram(pfn))) {
-		pr_err_ratelimited("%s: Instruction emulation from non-RAM host addres %08llx is not supported\n",
+		pr_err_ratelimited("%s: Instruction emulation from non-RAM host address %08llx is not supported\n",
 			 __func__, addr);
 		return EMULATE_AGAIN;
 	}
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mist/l1oip_core.c
index 9f454d7..67c2187 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1334,7 +1334,7 @@ init_card(struct l1oip *hc, int pri, int bundle)
 	if (id[l1oip_cnt] == 0) {
 		printk(KERN_WARNING "Warning: No 'id' value given or "
 		       "0, this is highly unsecure. Please use 32 "
-		       "bit randmom number 0x...\n");
+		       "bit random number 0x...\n");
 	}
 	hc->id = id[l1oip_cnt];
 	if (debug & DEBUG_L1OIP_INIT)
diff --git a/drivers/media/pci/ttpci/budget-patch.c b/drivers/media/pci/ttpci/budget-patch.c
index 2cb35c2..a4d8867 100644
--- a/drivers/media/pci/ttpci/budget-patch.c
+++ b/drivers/media/pci/ttpci/budget-patch.c
@@ -490,7 +490,7 @@ static int budget_patch_attach (struct saa7146_dev* dev, struct saa7146_pci_exte
 
 	if(detected == 0)
 		printk("budget-patch not detected or saa7146 in non-default state.\n"
-		       "try enabling ressetting of 7146 with MASK_31 in MC1 register\n");
+		       "try enabling resetting of 7146 with MASK_31 in MC1 register\n");
 
 	else
 		printk("BUDGET-PATCH DETECTED.\n");
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 327cb19..d3d1936 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -1090,7 +1090,7 @@ tape_3590_print_io_sim_msg_f1(struct tape_device *device, struct irb *irb)
 				"channel path 0x%x on CU",
 				sense->fmt.f71.md[1]);
 		else
-			snprintf(service, BUFSIZE, "Repair will disable cannel"
+			snprintf(service, BUFSIZE, "Repair will disable channel"
 				" paths (0x%x-0x%x) on CU",
 				sense->fmt.f71.md[1], sense->fmt.f71.md[2]);
 		break;
@@ -1481,7 +1481,7 @@ tape_3590_irq(struct tape_device *device, struct tape_request *request,
 	}
 
 	if (irb->scsw.cmd.dstat & DEV_STAT_CHN_END) {
-		DBF_EVENT(2, "cannel end\n");
+		DBF_EVENT(2, "channel end\n");
 		return TAPE_IO_PENDING;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..4ea3b97 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6740,7 +6740,7 @@ static int __init megasas_init(void)
 	rval = pci_register_driver(&megasas_pci_driver);
 
 	if (rval) {
-		printk(KERN_DEBUG "megasas: PCI hotplug regisration failed \n");
+		printk(KERN_DEBUG "megasas: PCI hotplug registration failed \n");
 		goto err_pcidrv;
 	}
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index e9186cd..33ac39b 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -335,7 +335,7 @@ static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
 			desc += XCOPY_SEGMENT_DESC_LEN;
 			break;
 		default:
-			pr_err("XCOPY unspported segment descriptor"
+			pr_err("XCOPY unsupported segment descriptor"
 				"type: 0x%02x\n", desc[0]);
 			goto out;
 		}
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 649b784..f967d65 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -701,7 +701,7 @@ config PDC_CONSOLE
 	  Saying Y here will enable the software based PDC console to be 
 	  used as the system console.  This is useful for machines in 
 	  which the hardware based console has not been written yet.  The
-	  following steps must be competed to use the PDC console:
+	  following steps must be completed to use the PDC console:
 
 	    1. create the device entry (mknod /dev/ttyB0 c 11 0)
 	    2. Edit the /etc/inittab to start a getty listening on /dev/ttyB0
diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 59ab62c..ea2b9c3 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -396,7 +396,7 @@ static int hidg_setup(struct usb_function *f,
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
-		VDBG(cdev, "set_report | wLenght=%d\n", ctrl->wLength);
+		VDBG(cdev, "set_report | wLength=%d\n", ctrl->wLength);
 		goto stall;
 		break;
 
diff --git a/drivers/usb/host/ehci-sysfs.c b/drivers/usb/host/ehci-sysfs.c
index f6459df..5e44407 100644
--- a/drivers/usb/host/ehci-sysfs.c
+++ b/drivers/usb/host/ehci-sysfs.c
@@ -132,7 +132,7 @@ static ssize_t store_uframe_periodic_max(struct device *dev,
 
 		if (allocated_max > uframe_periodic_max) {
 			ehci_info(ehci,
-				"cannot decrease uframe_periodic_max becase "
+				"cannot decrease uframe_periodic_max because "
 				"periodic bandwidth is already allocated "
 				"(%u > %u)\n",
 				allocated_max, uframe_periodic_max);
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 3de1278..ecf02b2 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4958,7 +4958,7 @@ static ssize_t store_uframe_periodic_max(struct device *dev,
 
 		if (allocated_max > uframe_periodic_max) {
 			fotg210_info(fotg210,
-				"cannot decrease uframe_periodic_max becase "
+				"cannot decrease uframe_periodic_max because "
 				"periodic bandwidth is already allocated "
 				"(%u > %u)\n",
 				allocated_max, uframe_periodic_max);
diff --git a/drivers/usb/host/fusbh200-hcd.c b/drivers/usb/host/fusbh200-hcd.c
index abe42f3..664d2aa 100644
--- a/drivers/usb/host/fusbh200-hcd.c
+++ b/drivers/usb/host/fusbh200-hcd.c
@@ -4893,7 +4893,7 @@ static ssize_t store_uframe_periodic_max(struct device *dev,
 
 		if (allocated_max > uframe_periodic_max) {
 			fusbh200_info(fusbh200,
-				"cannot decrease uframe_periodic_max becase "
+				"cannot decrease uframe_periodic_max because "
 				"periodic bandwidth is already allocated "
 				"(%u > %u)\n",
 				allocated_max, uframe_periodic_max);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index d571e17..9d6486d 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2772,7 +2772,7 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
 		reiserfs_warning(sb, "sh-462",
-				 "unable to initialize jornal device");
+				 "unable to initialize journal device");
 		goto free_and_return;
 	}
 
diff --git a/tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c b/tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
index af4b050..aaca1f4 100644
--- a/tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
+++ b/tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
@@ -342,7 +342,7 @@ int main(int argc, char *argv[])
 				iobuf[i].requested = ret;
 				printf("submit: %d requests buf: %d\n", ret, i);
 			} else
-				perror("unable to submit reqests");
+				perror("unable to submit requests");
 		}
 
 		/* if event is ready to read */
-- 
2.2.0.rc0

