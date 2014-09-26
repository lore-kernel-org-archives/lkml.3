Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaIZKbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbaIZJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/142] usb: xhci: amd chipset also needs short TX quirk
Date: Fri, 26 Sep 2014 11:43:52 +0200
Message-Id: <6f5a9e2719ffc5f89640f0f267ca35610e4edce1.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index f34b42e4c391..1cfe0c743092 100644
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
2.1.0

