Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbaJ1E3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:29:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979AbaJ1Dw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.10 30/43] PCI: Generate uppercase hex for modalias interface class
Date: Tue, 28 Oct 2014 11:36:28 +0800
Message-Id: <20141028033524.698762844@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

commit 89ec3dcf17fd3fa009ecf8faaba36828dd6bc416 upstream.

Some implementations of modprobe fail to load the driver for a PCI device
automatically because the "interface" part of the modalias from the kernel
is lowercase, and the modalias from file2alias is uppercase.

The "interface" is the low-order byte of the Class Code, defined in PCI
r3.0, Appendix D.  Most interface types defined in the spec do not use
alpha characters, so they won't be affected.  For example, 00h, 01h, 10h,
20h, etc. are unaffected.

Print the "interface" byte of the Class Code in uppercase hex, as we
already do for the Vendor ID, Device ID, Class, etc.

[bhelgaas: changelog]
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -175,7 +175,7 @@ static ssize_t modalias_show(struct devi
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 
-	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
+	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
 		       pci_dev->vendor, pci_dev->device,
 		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),


