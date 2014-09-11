Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbaIKMxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:53:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51563 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Shriraj-Rai P" <shriraj-rai.p@amd.com>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Arindam Nath" <arindam.nath@amd.com>, "Huang Rui" <ray.huang@amd.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.852594374@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/131] usb: xhci: amd chipset also needs short TX quirk
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -98,6 +98,10 @@ static void xhci_pci_quirks(struct devic
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

