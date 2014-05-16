Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaEPMxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49558 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David Cohen" <david.a.cohen@linux.intel.com>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.43636218@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 26/34] usb/xhci: fix compilation warning when
 !CONFIG_PCI && !CONFIG_PM
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -378,16 +378,16 @@ static int xhci_try_enable_msi(struct us
 
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
 

