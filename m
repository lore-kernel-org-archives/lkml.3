Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaEDQam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:30:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaEDPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.14 109/158] usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM
Date: Sun,  4 May 2014 11:40:18 -0400
Message-Id: <20140504154044.795593889@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit 01bb59ebffdec314da8da66266edf29529372f9b upstream.

When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
warning:
drivers/usb/host/xhci.c:409:13: warning: ‘xhci_msix_sync_irqs’ defined
but not used [-Wunused-function]

Instead of creating nested #ifdefs, this patch fixes it by defining the
xHCI PCI stubs as inline.

This warning has been in since 3.2 kernel and was
caused by commit 421aa841a134f6a743111cf44d0c6d3b45e3cf8c
"usb/xhci: hide MSI code behind PCI bars", but wasn't noticed
until 3.13 when a configuration with these options was tried

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -404,16 +404,16 @@ static int xhci_try_enable_msi(struct us
 
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
 


