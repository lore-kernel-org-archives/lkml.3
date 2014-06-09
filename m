Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621AbaFIXEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:04:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387AbaFIWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jorge <xxopxe@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.14 60/78] usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
Date: Mon,  9 Jun 2014 15:48:40 -0700
Message-Id: <20140609224815.271899989@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit b38f09ccc3fd453180e96273bf3f34083c30809a upstream.

Sony VAIO t-series machines are not capable of switching usb2 ports over
from Intel EHCI to xHCI controller. If tried the USB2 port will be left
unconnected and unusable.

This patch should be backported to stable kernels as old as 3.12,
that contain the commit 26b76798e0507429506b93cd49f8c4cfdab06896
"Intel xhci: refactor EHCI/xHCI port switching"

Reported-by: Jorge <xxopxe@gmail.com>
Tested-by: Jorge <xxopxe@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -847,6 +847,13 @@ void usb_enable_intel_xhci_ports(struct
 	bool		ehci_found = false;
 	struct pci_dev	*companion = NULL;
 
+	/* Sony VAIO t-series with subsystem device ID 90a8 is not capable of
+	 * switching ports from EHCI to xHCI
+	 */
+	if (xhci_pdev->subsystem_vendor == PCI_VENDOR_ID_SONY &&
+	    xhci_pdev->subsystem_device == 0x90a8)
+		return;
+
 	/* make sure an intel EHCI controller exists */
 	for_each_pci_dev(companion) {
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&


