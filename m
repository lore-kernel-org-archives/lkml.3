Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbbA1F3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:29:35 -0500
Received: from mail.kernel.org ([198.145.29.136]:36976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645AbbA1EOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:25 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 013/177] PCI: Generate uppercase hex for modalias interface class
Date: Wed, 28 Jan 2015 12:06:32 +0800
Message-Id: <1422418236-12852-25-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index a55e248..985ada7 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -173,7 +173,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 
-	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
+	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
 		       pci_dev->vendor, pci_dev->device,
 		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
-- 
1.9.1

