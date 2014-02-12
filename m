Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaBLI2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:28:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbaBLIOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:03 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.386207612@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 64/79] pci: Add PCI_DEVICE_SUB() macro
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This was added as part of commit 3d567e0e291c ('tg3: Set 10_100_ONLY
flag for additional 10/100 Mbps devices') upstream and is needed by
the following patch to ahci.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/pci.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -590,6 +590,20 @@ struct pci_driver {
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
 /**
+ * PCI_DEVICE_SUB - macro used to describe a specific pci device with subsystem
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @subvend: the 16 bit PCI Subvendor ID
+ * @subdev: the 16 bit PCI Subdevice ID
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device with subsystem information.
+ */
+#define PCI_DEVICE_SUB(vend, dev, subvend, subdev) \
+	.vendor = (vend), .device = (dev), \
+	.subvendor = (subvend), .subdevice = (subdev)
+
+/**
  * PCI_DEVICE_CLASS - macro used to describe a specific pci device class
  * @dev_class: the class, subclass, prog-if triple for this device
  * @dev_class_mask: the class mask for this device

