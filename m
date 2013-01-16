Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3APQA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35895 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3APQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell Webb <russell.webb@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 055/222] xhci: Add Lynx Point LP to list of Intel switchable hosts
Date: Wed, 16 Jan 2013 13:54:15 -0200
Message-Id: <1358351822-7675-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Webb <russell.webb@linux.intel.com>

commit bb1e5dd7113d2fd178d3af9aca8f480ae0468edf upstream.

Like Lynx Point, Lynx Point LP is also switchable.  See
1c12443ab8eba71a658fae4572147e56d1f84f66 for more details.

This patch should be backported to stable kernels as old as 3.0,
that contain commit 69e848c2090aebba5698a1620604c7dccb448684
"Intel xhci: Support EHCI/xHCI port switching."

Signed-off-by: Russell Webb <russell.webb@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/ehci-pci.c   |    3 ++-
 drivers/usb/host/pci-quirks.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 1234817..0909783 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -362,7 +362,8 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev *pdev)
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		(pdev->device == 0x1E26 ||
 		 pdev->device == 0x8C2D ||
-		 pdev->device == 0x8C26);
+		 pdev->device == 0x8C26 ||
+		 pdev->device == 0x9C26);
 }
 
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 39f9e4a..eb5563a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -723,6 +723,7 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
 }
 
 #define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI	0x9C31
 
 bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
@@ -736,7 +737,8 @@ bool usb_is_intel_lpt_switchable_xhci(struct pci_dev *pdev)
 {
 	return pdev->class == PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
-		pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+		(pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI ||
+		 pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI);
 }
 
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
-- 
1.7.9.5

