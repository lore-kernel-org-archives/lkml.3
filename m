Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaLBQfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:35:14 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39527 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaLBQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:35:09 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] PCI: Generate uppercase hex for modalias var in uevent
Date: Tue,  2 Dec 2014 17:35:04 +0100
Message-Id: <1417538104-27341-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some implementations of modprobe fail to load the driver for a PCI device
automatically because the "interface" part of the modalias from the kernel
is lowercase, and the modalias from file2alias is uppercase.

The "interface" is the low-order byte of the Class Code, defined in PCI
r3.0, Appendix D.  Most interface types defined in the spec do not use
alpha characters, so they won't be affected.  For example, 00h, 01h, 10h,
20h, etc. are unaffected.

Print the "interface" byte of the Class Code in uppercase hex, as we
already do for the Vendor ID, Device ID, Class, etc.

Commit 89ec3dcf17fd ("PCI: Generate uppercase hex for modalias
interface class") fixed only half of the problem. Some udev
implementations relays on the uevent file and not in the modalias file.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: d1ded203adf1 ("PCI: add MODALIAS to hotplug event for pci devices")
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

Modified line is >80 char, but I believe that it is better than breaking
the string or indent it bad.

 drivers/pci/pci-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2b3c894..b720e78 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1389,7 +1389,7 @@ static int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (add_uevent_var(env, "PCI_SLOT_NAME=%s", pci_name(pdev)))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x",
+	if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X",
 			   pdev->vendor, pdev->device,
 			   pdev->subsystem_vendor, pdev->subsystem_device,
 			   (u8)(pdev->class >> 16), (u8)(pdev->class >> 8),
-- 
2.1.3

