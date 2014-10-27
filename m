Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaJ0TKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:10:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaJ0TEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 026/105] PCI: Generate uppercase hex for modalias interface class
Date: Mon, 27 Oct 2014 11:56:01 -0700
Message-Id: <1414436240-13879-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c91e6c1..21ba076 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -178,7 +178,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 
-	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
+	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
 		       pci_dev->vendor, pci_dev->device,
 		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
-- 
1.9.1

