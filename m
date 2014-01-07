Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbaAGBj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:39:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:61803 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbaAGBj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:39:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,615,1384329600"; 
   d="scan'208";a="434817020"
From: David Cohen <david.a.cohen@linux.intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM
Date: Mon,  6 Jan 2014 17:44:28 -0800
Message-Id: <1389059068-18491-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
warning:
drivers/usb/host/xhci.c:409:13: warning: ‘xhci_msix_sync_irqs’ defined
but not used [-Wunused-function]

Instead of creating nested #ifdefs, this patch fixes it by defining the
xHCI PCI stubs as inline.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/host/xhci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4265b48856f6..672df9840014 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -397,16 +397,16 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 
 #else
 
-static int xhci_try_enable_msi(struct usb_hcd *hcd)
+static inline int xhci_try_enable_msi(struct usb_hcd *hcd)
 {
 	return 0;
 }
 
-static void xhci_cleanup_msix(struct xhci_hcd *xhci)
+static inline void xhci_cleanup_msix(struct xhci_hcd *xhci)
 {
 }
 
-static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
+static inline void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 }
 
-- 
1.8.4.2

