Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaCGJlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:41:09 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:46315 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaCGJkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:40:46 -0500
Message-ID: <53199419.9010901@compulab.co.il>
Date: Fri, 07 Mar 2014 11:40:41 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] xhci: Switch Intel Lynx Point ports to EHCI on shutdown.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same issue like with Panther Point chipsets. If the USB ports are
switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
which will wake the system. Some BIOS have work around for this, but not all.
One example is Compulab's mini-desktop, the Intense-PC2.

The bug can be avoided if the USB ports are switched back to EHCI on
shutdown.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 3c898c1..9233d12 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -134,6 +134,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
 			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+
+		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
-- 1.8.1.2

