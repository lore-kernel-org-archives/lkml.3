Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaGKAsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:48:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21412 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaGKAse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:48:34 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, gleb@kernel.org, pbonzini@redhat.com,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com,
        vaughan.cao@oracle.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 2/4] xen-pciback: use PCI VFs assignment helper functions
Date: Fri, 11 Jul 2014 08:47:20 +0800
Message-Id: <1405039642-23519-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1405039642-23519-1-git-send-email-ethan.zhao@oracle.com>
References: <1405039642-23519-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New VFs reference counter mechanism and VFs assignment helper functions are introduced to
PCI SRIOV, use them instead of manipulating device flag directly.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 62fcd48..1d7b747 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
 	xen_pcibk_config_free_dyn_fields(dev);
 	xen_pcibk_config_free_dev(dev);
 
-	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_sriov_deassign_device(dev);
 	pci_dev_put(dev);
 
 	kfree(psdev);
@@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "reset device\n");
 	xen_pcibk_reset_device(dev);
 
-	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
+	pci_sriov_assign_device(dev);
 	return 0;
 
 config_release:
-- 
1.7.1

