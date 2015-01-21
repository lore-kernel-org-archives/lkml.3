Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbbAUMx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:53:28 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49649 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbbAUMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:53:15 -0500
From: Baptiste Reynal <b.reynal@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, Alexander Graf <agraf@suse.de>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 13/18] vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit
Date: Wed, 21 Jan 2015 13:50:01 +0100
Message-Id: <1421844606-24751-14-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

The functions vfio_pci_virqfd_init and vfio_pci_virqfd_exit are not really
PCI specific, since we plan to reuse the virqfd code with more VFIO drivers
in addition to VFIO_PCI.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci.c       | 6 +++---
 drivers/vfio/pci/vfio_pci_intrs.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9558da3..fc4308c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1012,7 +1012,7 @@ put_devs:
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_virqfd_exit();
+	vfio_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -1026,7 +1026,7 @@ static int __init vfio_pci_init(void)
 		return ret;
 
 	/* Start the virqfd cleanup handler */
-	ret = vfio_pci_virqfd_init();
+	ret = vfio_virqfd_init();
 	if (ret)
 		goto out_virqfd;
 
@@ -1038,7 +1038,7 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_pci_virqfd_exit();
+	vfio_virqfd_exit();
 out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 0a41833d..a5378d5 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -45,7 +45,7 @@ struct virqfd {
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 
-int __init vfio_pci_virqfd_init(void)
+int __init vfio_virqfd_init(void)
 {
 	vfio_irqfd_cleanup_wq =
 		create_singlethread_workqueue("vfio-irqfd-cleanup");
@@ -55,7 +55,7 @@ int __init vfio_pci_virqfd_init(void)
 	return 0;
 }
 
-void vfio_pci_virqfd_exit(void)
+void vfio_virqfd_exit(void)
 {
 	destroy_workqueue(vfio_irqfd_cleanup_wq);
 }
-- 
2.2.2

