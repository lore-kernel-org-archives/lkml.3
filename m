Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaG2EHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 00:07:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaG2EHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 00:07:31 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 3/4 v3] xen-pciback: use pci device flag operation helper function
Date: Tue, 29 Jul 2014 12:06:30 +0800
Message-Id: <1406606791-8834-4-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci device flag operation helper functions when set device
to assigned or deassigned state.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 v3: amend helper functions naming.
 drivers/xen/xen-pciback/pci_stub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 62fcd48..71f69f1 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
 	xen_pcibk_config_free_dyn_fields(dev);
 	xen_pcibk_config_free_dev(dev);
 
-	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_clear_dev_assigned(dev);
 	pci_dev_put(dev);
 
 	kfree(psdev);
@@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "reset device\n");
 	xen_pcibk_reset_device(dev);
 
-	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
+	pci_set_dev_assigned(dev);
 	return 0;
 
 config_release:
-- 
1.7.1

