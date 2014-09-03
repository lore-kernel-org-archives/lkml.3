Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaICWGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:06:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbaICWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arindam Nath <arindam.nath@amd.com>,
        Shriraj-Rai P <shriraj-rai.p@amd.com>, Huang Rui <ray.huang@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.10 45/55] usb: xhci: amd chipset also needs short TX quirk
Date: Wed,  3 Sep 2014 15:05:35 -0700
Message-Id: <20140903220501.156865477@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -87,6 +87,10 @@ static void xhci_pci_quirks(struct devic
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


