Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaICXCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:02:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbaICWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:25:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.16 109/125] xhci: Disable streams on Via XHCI with device-id 0x3432
Date: Wed,  3 Sep 2014 15:07:46 -0700
Message-Id: <20140903220626.967775778@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit e21eba05afd288a227320f797864ddd859397eed upstream.

This is a bit bigger hammer then I would like to use for this, but for now
it will have to make do. I'm working on getting my hands on one of these so
that I can try to get streams to work (with a quirk flag if necessary) and
then we can re-enable them.

For now this at least makes uas capable disk enclosures work again by forcing
fallback to the usb-storage driver.

https://bugzilla.kernel.org/show_bug.cgi?id=79511

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -155,6 +155,11 @@ static void xhci_pci_quirks(struct devic
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 
+	/* See https://bugzilla.kernel.org/show_bug.cgi?id=79511 */
+	if (pdev->vendor == PCI_VENDOR_ID_VIA &&
+			pdev->device == 0x3432)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");


