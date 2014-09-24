Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaIXRgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:36:08 -0400
Received: from mx.aristanetworks.com ([162.210.130.12]:46481 "EHLO
	prod-mx.aristanetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751600AbaIXRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:36:06 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 13:36:06 EDT
Date: Wed, 24 Sep 2014 10:29:23 -0700
To: linux-pci@vger.kernel.org
Subject: [PATCH 1/1] pci: move PCI_VENDOR_ID_VMWARE to pci_ids.h
Cc: sbhatewara@vmware.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, pv-drivers@vmware.com
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20140924172923.D112148565B@fruggeri-Arora18.sjc.aristanetworks.com>
From: fruggeri@aristanetworks.com (Francesco Ruggeri)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b99b1ec156ab351668eb77a00a57a4ae095eec28 Mon Sep 17 00:00:00 2001
From: Francesco Ruggeri <fruggeri@arista.com>
Date: Wed, 24 Sep 2014 10:12:41 -0700
Subject: [PATCH 1/1] pci: move PCI_VENDOR_ID_VMWARE to pci_ids.h

Moving PCI_VENDOR_ID_VMWARE from device specific files to pci_ids.h.
It is useful to always have access to it, especially when accessing
subsystem_vendor_id on emulated devices.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 drivers/gpu/drm/vmwgfx/svga_reg.h  | 1 -
 drivers/misc/vmw_vmci/vmci_guest.c | 1 -
 drivers/net/vmxnet3/vmxnet3_int.h  | 1 -
 drivers/scsi/vmw_pvscsi.h          | 1 -
 include/linux/pci_ids.h            | 2 ++
 5 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/svga_reg.h b/drivers/gpu/drm/vmwgfx/svga_reg.h
index 11323dd..e4259c2 100644
--- a/drivers/gpu/drm/vmwgfx/svga_reg.h
+++ b/drivers/gpu/drm/vmwgfx/svga_reg.h
@@ -35,7 +35,6 @@
 /*
  * PCI device IDs.
  */
-#define PCI_VENDOR_ID_VMWARE            0x15AD
 #define PCI_DEVICE_ID_VMWARE_SVGA2      0x0405
 
 /*
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index 248399a..189b325 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -35,7 +35,6 @@
 #include "vmci_driver.h"
 #include "vmci_event.h"
 
-#define PCI_VENDOR_ID_VMWARE		0x15AD
 #define PCI_DEVICE_ID_VMWARE_VMCI	0x0740
 
 #define VMCI_UTIL_NUM_RESOURCES 1
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3759479..5f0199f 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -117,7 +117,6 @@ enum {
 /*
  * PCI vendor and device IDs.
  */
-#define PCI_VENDOR_ID_VMWARE            0x15AD
 #define PCI_DEVICE_ID_VMWARE_VMXNET3    0x07B0
 #define MAX_ETHERNET_CARDS		10
 #define MAX_PCI_PASSTHRU_DEVICE		6
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index ce45888..ee16f0c 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -32,7 +32,6 @@
 
 #define MASK(n)        ((1 << (n)) - 1)        /* make an n-bit mask */
 
-#define PCI_VENDOR_ID_VMWARE		0x15AD
 #define PCI_DEVICE_ID_VMWARE_PVSCSI	0x07C0
 
 /*
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb7..e62b20a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2971,4 +2971,6 @@
 
 #define PCI_VENDOR_ID_OCZ		0x1b85
 
+#define PCI_VENDOR_ID_VMWARE		0x15AD
+
 #endif /* _LINUX_PCI_IDS_H */
-- 
1.8.1.4

