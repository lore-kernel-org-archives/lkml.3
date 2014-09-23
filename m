Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaIWCjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:38269 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaIWCjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:42 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 24/45] usb: xhci: amd chipset also needs short TX quirk
Date: Tue, 23 Sep 2014 10:31:26 +0800
Message-Id: <1411439507-30391-24-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 2597fe99bb0259387111d0431691f5daac84f5a5 upstream.

AMD xHC also needs short tx quirk after tested on most of chipset
generations. That's because there is the same incorrect behavior like
Fresco Logic host. Please see below message with on USB webcam
attached on xHC host:

[  139.262944] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.266934] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.270913] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.274937] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.278914] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.282936] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.286915] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.290938] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.294913] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?
[  139.298917] xhci_hcd 0000:00:10.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?

Reported-by: Arindam Nath <arindam.nath@amd.com>
Tested-by: Shriraj-Rai P <shriraj-rai.p@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/host/xhci-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 33cff01..8882d65 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -98,6 +98,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* AMD PLL quirk */
 	if (pdev->vendor == PCI_VENDOR_ID_AMD && usb_amd_find_chipset_info())
 		xhci->quirks |= XHCI_AMD_PLL_FIX;
+
+	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
-- 
1.7.9.5

