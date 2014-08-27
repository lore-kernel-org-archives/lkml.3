Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaH0M6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:58:06 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35728 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0M6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:58:04 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: gregkh@linuxfoundation.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Date: Wed, 27 Aug 2014 14:57:57 +0200
Message-Id: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missmatch between the way file2alias generates the modalias
and the way the pci driver generates it.

Some implementations of modprobe will fail to load the driver for a pci
device automatically when the pci interface is defined on the driver. As
one will be in uppercase and the other in lowercase.

Fortunatelly not many drivers define this.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9ff0a90..76ef791 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -177,7 +177,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 
-	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
+	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
 		       pci_dev->vendor, pci_dev->device,
 		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
-- 
2.1.0

