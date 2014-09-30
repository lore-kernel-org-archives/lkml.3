Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaI3ViV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaI3ViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Huang Rui <ray.huang@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/103] usb: xhci: amd chipset also needs short TX quirk
Date: Tue, 30 Sep 2014 14:30:59 -0700
Message-Id: <1412112708-27356-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Rui <ray.huang@amd.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 67394da..3fc8d9e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -101,6 +101,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* AMD PLL quirk */
 	if (pdev->vendor == PCI_VENDOR_ID_AMD && usb_amd_find_chipset_info())
 		xhci->quirks |= XHCI_AMD_PLL_FIX;
+
+	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_INTEL_HOST;
-- 
1.9.1

