Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3JBKYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:24:10 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41953 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3JBKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:24:08 -0400
From: Andre Richter <andre.o.richter@gmail.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andre Richter <andre.o.richter@gmail.com>
Subject: [PATCH 1/1] virt/kvm/iommu.c: Add leading zeros to device's BDF notation in debug messages
Date: Wed,  2 Oct 2013 12:23:26 +0200
Message-Id: <1380709406-3528-1-git-send-email-andre.o.richter@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KVM (de)assigns PCI(e) devices to VMs, a debug message is printed
including the BDF notation of the respective device. Currently, the BDF
notation does not have the commonly used leading zeros. This produces
messages like "assign device 0:1:8.0", which look strange at first sight.

The patch fixes this by exchanging the printk(KERN_DEBUG ...) with dev_info()
and also inserts "kvm" into the debug message, so that it is obvious where
the message comes from. Also reduces LoC.

Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
---
 virt/kvm/iommu.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 72a130b..a3b1410 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -190,11 +190,7 @@ int kvm_assign_device(struct kvm *kvm,
 
 	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
 
-	printk(KERN_DEBUG "assign device %x:%x:%x.%x\n",
-		assigned_dev->host_segnr,
-		assigned_dev->host_busnr,
-		PCI_SLOT(assigned_dev->host_devfn),
-		PCI_FUNC(assigned_dev->host_devfn));
+	dev_info(&pdev->dev, "kvm assign device\n");
 
 	return 0;
 out_unmap:
@@ -220,11 +216,7 @@ int kvm_deassign_device(struct kvm *kvm,
 
 	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
 
-	printk(KERN_DEBUG "deassign device %x:%x:%x.%x\n",
-		assigned_dev->host_segnr,
-		assigned_dev->host_busnr,
-		PCI_SLOT(assigned_dev->host_devfn),
-		PCI_FUNC(assigned_dev->host_devfn));
+	dev_info(&pdev->dev, "kvm deassign device\n");
 
 	return 0;
 }
-- 
1.8.1.2

